"""make_wait.py - wait.html: the boxing page (order.html) where your step can come a moment later (S565).

Owner S562, on the order strip "1 Body jab then 2 Step in": "can i be able to select exactly on which part of a beat i
move ? or it breaks balance ?". MOMENTGAP1 measured two answers: A, a free wait anywhere (picked in 67% of beats, two
bars lost), and B, only the FEET may come one moment later (picked in 8% of beats, the page's bars held on seed 1).
This page is B, to be played.

    python proto/twohands/tools/make_wait.py [ops/research/s558_balance/moment_gap_b.json]

The RULES are the measured tweak file, applied text for text. The PAGE part is patched here: a switch beside your order
("Step in a moment later"), the wait shown as its own chip in the order, the how-to line.
Every anchor must be found exactly once: an edit to order.html that moves one stops the build with its text.
order.html is never written. Run again after order.html changes.
"""
from __future__ import annotations

import io
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
SRC = HERE.parent / "order.html"
OUT = HERE.parent / "wait.html"
TWEAK = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "ops/research/s558_balance/moment_gap_b.json"


def main() -> None:
    s = io.open(SRC, encoding="utf-8", newline="").read()
    tw = json.load(io.open(TWEAK, encoding="utf-8"))

    def rep(a: str, b: str, what: str) -> None:
        nonlocal s
        if s.count(a) != 1:
            sys.exit(f"MAKE_WAIT FAIL {what}: anchor found {s.count(a)} times: {a[:90]!r}")
        s = s.replace(a, b)

    # ---- the rules: the tweak file as measured (a 'wait' may stand in the order, only right before a last step)
    for i, (a, b) in enumerate(tw["src"]):
        rep(a, b, f"tweak src {i}")

    # ---- the page
    rep("<title>Puncher's chance</title>", "<title>Puncher's chance - Pick your moment</title>", "title")
    rep(".seq button b{color:var(--gold);margin-right:.3rem}",
        ".seq button b{color:var(--gold);margin-right:.3rem}.seq button[data-sl=\"wait\"]{border-style:dashed;background:none;font-weight:400;opacity:.8}"
        ".waitsw{margin-left:.5rem;padding:.25rem .7rem;border-radius:.7rem;border:1px dashed #8a8170;background:none;color:inherit;font:inherit;cursor:pointer}"
        ".waitsw.on{border:1px solid var(--gold);color:var(--gold);background:#3a2c18;font-weight:600}",
        "the look")
    # the wait is legal only right before a step that is the last action, in a beat of three moments or fewer; anything
    # else the player does to the order (a third action, the step dragged earlier) drops it
    rep("function board() { const me = F[0], left = me.st - cost(P); P.ord = ordOf(P);",
        "const waitCan = (o) => { const rest = o.filter((sl) => sl !== 'wait'); return rest.length > 0 && rest.length < 3 && rest[rest.length - 1] === 'feet'; };   /* MOMENTGAP1 B (S565) */\n"
        "const fixWait = (o) => { if (!o.includes('wait')) return o; const rest = o.filter((sl) => sl !== 'wait'); return waitCan(o) ? [...rest.slice(0, -1), 'wait', 'feet'] : rest; };\n"
        "const waitBtn = () => (P.clinch || !waitCan(P.ord) ? '' : `<button id=\"waitsw\" class=\"waitsw ${P.ord.includes('wait') ? 'on' : ''}\" title=\"Free. Your ${FEET[P.feet].n.toLowerCase()} comes one moment later: nothing happens in the moment before it. Your hands keep their moments.\">${FEET[P.feet].n} a moment later</button>`);\n"
        "function board() { const me = F[0], left = me.st - cost(P); P.ord = fixWait(ordOf(P));",
        "the order keeps a legal wait")
    rep("`<span class=\"lab\" style=\"margin-left:.8rem\">What you leave open</span>`",
        "waitBtn() + `<span class=\"lab\" style=\"margin-left:.8rem\">What you leave open</span>`",
        "the switch beside the order")
    rep("const chips = [...$('lines').querySelectorAll('.seq button')];",
        "const chips = [...$('lines').querySelectorAll('.seq button')];\n"
        "  const wsw = document.getElementById('waitsw'); if (wsw && waitCan(P.ord)) wsw.onclick = () => { const rest = P.ord.filter((sl) => sl !== 'wait'); P.ord = P.ord.includes('wait') ? rest : [...rest.slice(0, -1), 'wait', 'feet']; plan(); };",
        "the click")
    rep("title=\"Drag it to its place in the order (a click: one place earlier)\"><b>${i + 1}</b>${actName(P, sl)}",
        "title=\"${sl === 'wait' ? 'An empty moment before your step. Switch it off beside the order.' : 'Drag it to its place in the order (a click: one place earlier)'}\"><b>${i + 1}</b>${actName(P, sl)}",
        "the wait chip's tooltip")
    rep("Feet take a moment too: step in and then hook, or jab and then back off.",
        "Feet take a moment too: step in and then hook, or jab and then back off. <b>Your step can come a moment later</b> (the switch beside your order, free): jab in moment 1, nothing in moment 2, step in moment 3 - what he throws in moment 2 finds you where you stood.",
        "the how-to line")
    # the opponent's look-ahead: the page's own table was solved WITHOUT the late step. Once this page's table is built
    # (`balance.mjs table tweak=<the tweak> out=proto/twohands/vtable_wait.json jobs=2`, about an hour) the page loads it.
    own = (HERE.parent / "vtable_wait.json").exists()
    if own:
        rep("fetch('vtable.json')", "fetch('vtable_wait.json')", "its own look-ahead table")
    io.open(OUT, "w", encoding="utf-8", newline="").write(s)
    print("MAKE_WAIT look-ahead table: " + ("vtable_wait.json (its own)" if own else "vtable.json (the main page's: build vtable_wait.json)"))
    print(f"MAKE_WAIT wrote {OUT.name} from {SRC.name} + {TWEAK.name} ({len(tw['src'])} rule edits)")


if __name__ == "__main__":
    main()
