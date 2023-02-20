{lib, ...}: {
  time.timeZone = lib.mkDefault "Europe/Berlin";

  console.keyMap = lib.mkDefault "de";

  i18n.supportedLocales = lib.mkDefault ["en_US.UTF-8/UTF-8" "de_DE.UTF-8/UTF-8"];
  i18n.extraLocaleSettings = lib.mkDefault {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };
}
