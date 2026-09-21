FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    MPLBACKEND=Agg

WORKDIR /data

RUN pip install --no-cache-dir \
    voila \
    ipykernel \
    ipywidgets \
    matplotlib \
    numpy \
    pillow \
    reportlab

RUN mkdir -p /opt/self-assessment
COPY lauds_tech-infra-read_self-assessment_questionnaire_weighted.ipynb /opt/self-assessment/

EXPOSE 8050

CMD ["voila", "/opt/self-assessment/lauds_tech-infra-read_self-assessment_questionnaire_weighted.ipynb", "--Voila.ip=0.0.0.0", "--port=8050", "--no-browser", "--show_tracebacks=True", "--VoilaConfiguration.file_allowlist=.*"]
