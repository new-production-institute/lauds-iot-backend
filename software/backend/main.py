from fastapi import FastAPI, HTTPException,Query
from influxdb_client import InfluxDBClient, Point
from influxdb_client.client.flux_table import FluxTable
import pandas as pd
from fastapi.middleware.cors import CORSMiddleware
import json
from datetime import datetime
import os

app = FastAPI(title="FastAPI + InfluxDB")

# Allow frontend to access API
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # or ["http://localhost:8088"] for stricter control
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
# --- Connect to InfluxDB when the app starts ---
@app.on_event("startup")
def startup_event():
    app.state.influx_client = InfluxDBClient(
        url=os.getenv("INFLUXDB_URL", "http://influxdb:8086"),
        token=os.getenv("INFLUXDB_TOKEN", "my-token"),
        org=os.getenv("INFLUXDB_ORG", "my-org"),
    )
    print("✅ Connected to InfluxDB")

# --- Close client when shutting down ---
@app.on_event("shutdown")
def shutdown_event():
    app.state.influx_client.close()
    print("🛑 Closed InfluxDB connection")



@app.get("/test")
def test_influxdb():
    """
    Test the connection to InfluxDB by listing all buckets.
    """
    try:
        client = app.state.influx_client
        buckets_api = client.buckets_api()
        buckets = buckets_api.find_buckets().buckets
        bucket_names = [b.name for b in buckets]
        return {"status": "connected", "buckets": bucket_names}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"InfluxDB connection failed: {e}")
    
@app.get("/get_machines")
def get_unique_devices():
    """
    Get all unique devices from the 'machine' measurement
    in the 'microfactory' bucket from the beginning of time.
    """
    try:
        client: InfluxDBClient = app.state.influx_client
        query_api = client.query_api()

        flux_query = '''
        from(bucket: "microfactory")
          |> range(start: 0)
          |> filter(fn: (r) => r["_measurement"] == "machine")
          |> keep(columns: ["device"])
          |> distinct(column: "device")
        '''

        tables: list[FluxTable] = query_api.query(flux_query)
        
        devices = []
        for table in tables:
            for record in table.records:
                devices.append(record.get_value())  # get the device value

        return {"machines": devices}

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch devices: {e}")
    

@app.get("/get_machine_fields")
def get_machine_fields(machine_name: str = Query(..., description="Name of the machine (device)")):
    """
    Return predefined fields only if the machine name is similar to 'prusa-mk4'.
    Otherwise, return an empty list.
    """
    try:
        # Only return fields if machine name contains "prusa-mk4"
        if "prusa-mk4" in machine_name.lower():
            fields = [
                "axis_x",
                "axis_y",
                "axis_z",
                "fan_hotend",
                "fan_print",
                "flow",
                "speed",
                "temp_bed",
                "temp_nozzle"
            ]
        else:
            fields = []  # return empty if not similar

        return {"machine": machine_name, "fields": fields}

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch fields for {machine_name}: {e}")

       # flux_query = """import "join" machine_data = from(bucket: "microfactory") |> range(start: -1h, stop: now()) |> filter(fn: (r) => r["_measurement"] == "machine") |> filter(fn: (r) => r["device"] == "prusa-mk4-1") |> filter(fn: (r) => r["_field"] == "temp_nozzle" or r["_field"] == "temp_bed") |> aggregateWindow(every: 10s, fn: mean, createEmpty: false) |> pivot(rowKey: ["_time"], columnKey: ["_field"], valueColumn: "_value") |> keep(columns: ["_time", "temp_nozzle", "temp_bed"]) energy_data = from(bucket: "microfactory") |> range(start: -1h, stop: now()) |> filter(fn: (r) => r["_measurement"] == "sensor") |> filter(fn: (r) => r["device"] == "SPPS-04") |> filter(fn: (r) => r["_field"] == "apower" or r["_field"] == "current" or r["_field"] == "voltage") |> aggregateWindow(every: 10s, fn: mean, createEmpty: false) |> pivot(rowKey: ["_time"], columnKey: ["_field"], valueColumn: "_value") |> keep(columns: ["_time", "apower", "current", "voltage"]) join.inner( left: machine_data, right: energy_data, on: (l, r) => l._time == r._time, as: (l, r) => ({ _time: l._time, temp_nozzle: l.temp_nozzle, temp_bed: l.temp_bed, apower: r.apower, current: r.current, voltage: r.voltage }) )"""
@app.get("/machine_energy_correlation")
def get_machine_energy_correlation(
    machine_device: str = Query("prusa-mk4-1", description="Machine device name"),
    machine_fields: list[str] = Query(["temp_nozzle", "temp_bed"], description="Machine fields"),
    energy_device: str = Query("SPPS-04", description="Energy device name"),
    energy_fields: list[str] = Query(["apower", "current", "voltage"], description="Energy fields"),
    start: str = Query("-1h", description="Start time (Flux format)"),
    stop: str = Query("now()", description="Stop time (Flux format)")
):
    """
    Fetch machine + energy data and compute correlations between machine fields and energy fields.
    Only returns the correlations.
    """
    try:
        client: InfluxDBClient = app.state.influx_client
        query_api = client.query_api()

        machine_fields_filter = " or ".join([f'r["_field"] == "{f}"' for f in machine_fields])
        energy_fields_filter = " or ".join([f'r["_field"] == "{f}"' for f in energy_fields])
        machine_keep = ", ".join([f'"{f}"' for f in machine_fields])
        energy_keep = ", ".join([f'"{f}"' for f in energy_fields])
        as_mapping = ", ".join([f"{f}: l.{f}" for f in machine_fields] + [f"{f}: r.{f}" for f in energy_fields])

        flux_query = (
            f'import "join" '
            f'machine_data = from(bucket: "microfactory") |> range(start: {start}, stop: {stop}) '
            f'|> filter(fn: (r) => r["_measurement"] == "machine") '
            f'|> filter(fn: (r) => r["device"] == "{machine_device}") '
            f'|> filter(fn: (r) => {machine_fields_filter}) '
            f'|> aggregateWindow(every: 10s, fn: mean, createEmpty: false) '
            f'|> pivot(rowKey: ["_time"], columnKey: ["_field"], valueColumn: "_value") '
            f'|> keep(columns: ["_time", {machine_keep}]) '
            f'energy_data = from(bucket: "microfactory") |> range(start: {start}, stop: {stop}) '
            f'|> filter(fn: (r) => r["_measurement"] == "sensor") '
            f'|> filter(fn: (r) => r["device"] == "{energy_device}") '
            f'|> filter(fn: (r) => {energy_fields_filter}) '
            f'|> aggregateWindow(every: 10s, fn: mean, createEmpty: false) '
            f'|> pivot(rowKey: ["_time"], columnKey: ["_field"], valueColumn: "_value") '
            f'|> keep(columns: ["_time", {energy_keep}]) '
            f'join.inner(left: machine_data, right: energy_data, '
            f'on: (l, r) => l._time == r._time, '
            f'as: (l, r) => ({{ _time: l._time, {as_mapping} }}))'
        )

        tables: list[FluxTable] = query_api.query(flux_query)

        # Build DataFrame
        data = []
        for table in tables:
            for record in table.records:
                row = {}
                for f in machine_fields + energy_fields:
                    row[f] = record.values.get(f)
                data.append(row)

        df = pd.DataFrame(data)
        if df.empty:
            return {"correlations": {}}

        # Compute Pearson correlation
        correlations = {}
        for m_field in machine_fields:
            correlations[m_field] = {}
            for e_field in energy_fields:
                corr_value = df[m_field].corr(df[e_field])
                correlations[m_field][e_field] = corr_value

        return {"correlations": correlations}

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch machine energy correlations: {e}")
