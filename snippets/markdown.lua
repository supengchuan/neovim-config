return {
  s("d", t("> [!DANGER]")),
  s("s", t("> [!SUMMARY]")),
  s("s", t("> [!SUCCESS]")),
  s("tl", t("> [!TLDR]")),
  s("e", t("> [!ERROR]")),
  s("q", t("> [!QUESTION]")),
  s({ trig = "ib", desc = "bold italic" }, { t("**_"), i(1), t("_**") }),
}
