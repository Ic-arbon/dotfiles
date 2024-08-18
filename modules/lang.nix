{pkgs, ...}: {
  home.packages = with pkgs; [
    (
      glibcLocales.override {
        allLocales = false;
        locales = ["zh_CN.UTF-8/UTF-8"];
      }
    )
  ];
}
