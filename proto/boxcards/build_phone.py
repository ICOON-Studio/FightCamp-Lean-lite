"""Builds phone.html: the version 2 page as ONE file (rules, bot and page script inlined, a phone layout), for publishing
as an Artifact so the owner can play on his phone. python proto/boxcards/build_phone.py"""
import os
import re

here = os.path.dirname(os.path.abspath(__file__))
read = lambda n: open(os.path.join(here, n), encoding="utf-8").read()


def strip(js):
    js = re.sub(r"^import .*?;\s*$", "", js, flags=re.M)
    return re.sub(r"^export (const|function|let)", r"\1", js, flags=re.M)


page = strip(read("page2.js"))
page = page.replace("const seed = +(new URLSearchParams(location.search).get('seed') || Math.floor(Math.random() * 1e6));", "let seed = Math.floor(Math.random() * 1e6);")
page = page.replace("$('again').onclick = () => { location.search = ''; };", "$('again').onclick = () => { seed = Math.floor(Math.random() * 1e6); lines = []; start(); };")
assert "let seed" in page and "lines = []; start();" in page
html = read("index.html")
css = html[html.index("<style>") + 7:html.index("</style>")]
body = html[html.index('<div class="app">'):html.index('<script type="module"')]
body = re.sub(r' - <a href="v1.html"[^>]*>version 1</a>', "", body)
css = css.replace(":root{", ":root{color-scheme:dark;", 1).replace("color-scheme:dark}", "}", 1)
css = css.replace(".app{height:100%;display:grid;grid-template-rows:auto 1fr auto;gap:0.714rem;padding:0.714rem 1.143rem}",
                  ".app{height:100%;display:grid;grid-template-rows:auto 1fr auto;gap:0.714rem;padding-block:0.714rem;padding-left:max(16px,env(safe-area-inset-left,0px));padding-right:max(16px,env(safe-area-inset-right,0px))}")
assert "padding-left:max(16px" in css
css += """
@media (max-width:820px){
  html{font-size:14px}
  .app{height:auto;min-height:100%;grid-template-rows:auto auto auto}
  .top{flex-wrap:wrap;gap:6px 14px}.top .lab{display:none}
  .mid{grid-template-columns:1fr 1fr;grid-template-areas:"you him" "table table"}
  .man.you{grid-area:you}.man.him{grid-area:him}.table{grid-area:table;min-width:0}
  .man{padding:8px;gap:6px;min-width:0}.man .used{display:none}.pip{width:auto;flex:1 1 0;min-width:0}
  .lines{max-height:9rem}.opts{grid-template-columns:1fr}
  .card{width:auto;flex:1 1 30%;min-width:0}.card.down{flex:0 0 3rem}
  .bottom{flex-direction:column;align-items:stretch}.bottom>div:nth-child(2){display:none}
  #acts{display:flex;flex-direction:column;gap:8px}.btn{width:100%;min-height:44px}.opt{min-height:44px}
}
"""
out = ('<title>Boxer v Boxer</title>\n<meta name="claude:viewport-fit-sides" content="cover">\n<style>' + css + "</style>\n" + body
       + '<script type="module">\n' + strip(read("rules2.mjs")) + "\n" + strip(read("bot2.mjs")) + "\n" + page + "\n</script>\n")
open(os.path.join(here, "phone.html"), "w", encoding="utf-8").write(out)
print("phone.html", len(out), "bytes")
