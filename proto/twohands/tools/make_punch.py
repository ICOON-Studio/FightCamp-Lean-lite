"""make_punch.py - punch.html: the boxing page (order.html) with the Puncher's chance switch on it (S561).

Owner S559: "can you add a jumpswitch on the board for the card game . We will name it "Puncher's chance" for now";
S561: "can i have a jumpsuit for punchers chance on the board".

    python proto/twohands/tools/make_punch.py [ops/research/s558_balance/punch_chance_c.json]

The RULES are the measured tweak file, applied text for text (docs/PUNCHCHANCE1_RESULT.md: version C, open when 4+ health
behind, once a round). The PAGE part is patched here: the switch beside the clinch, what it costs and why it is shut in its
tooltip, "his is open" shown when the other man can go all in, the story's words and their rule tooltips.
Every anchor must be found exactly once: an edit to order.html that moves one stops the build with its text.
order.html is never written. Run again after a new tweak version is chosen (PUNCHCHANCE2).
"""
from __future__ import annotations

import io
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
SRC = HERE.parent / "order.html"
OUT = HERE.parent / "punch.html"
TWEAK = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "ops/research/s558_balance/punch_chance_c.json"


def main() -> None:
    s = io.open(SRC, encoding="utf-8", newline="").read()
    tw = json.load(io.open(TWEAK, encoding="utf-8"))

    def rep(a: str, b: str, what: str) -> None:
        nonlocal s
        if s.count(a) != 1:
            sys.exit(f"MAKE_PUNCH FAIL {what}: anchor found {s.count(a)} times: {a[:90]!r}")
        s = s.replace(a, b)

    # ---- the rules: the tweak file as measured
    for i, (a, b) in enumerate(tw["src"]):
        rep(a, b, f"tweak src {i}")
    nums = ", ".join(f"{k}: {json.dumps(v)}" for k, v in tw["N"].items()).replace('"', "'")
    rep("const N = { ", "const N = { " + nums + ", ", "the numbers")

    # ---- the story's words (the page turns "throws ..." into "You throw ..." / "He throws ...")
    rep("a: 'goes all in', o: 'the puncher chance: the next power punch is double and drops him if it lands'",
        "a: 'throws the big one', o: `Puncher's chance, all in: the next power punch is double and puts ${k ? 'you' : 'him'} down if it lands`", "words: all in")
    rep("a: 'all in and missed', o: 'wide open for the rest of the beat'",
        "a: 'falls short, wide open', o: `all in and it missed: every punch at ${sh.k ? 'him' : 'you'} lands as a counter for the rest of the beat`", "words: missed")
    rep("a: 'all in and blocked', o: 'wide open for the rest of the beat'",
        "a: 'gets blocked, wide open', o: `all in and blocked: every punch at ${sh.k ? 'him' : 'you'} lands as a counter for the rest of the beat`", "words: blocked")
    rep("all ? 'ALL IN, the puncher chance' :", "all ? `ALL IN, the Puncher's chance: double, and down` :", "words: why")

    # ---- the page
    rep("<title>Ring Switches</title>", "<title>Ring Switches - Puncher's chance</title>", "title")
    rep("function ICON(grp, id) { if (id === 'high' || id === 'low') return SVGI(ICONS[id]); if (grp === 'clinch') return SVGI(ICONS.clinch);",
        "function ICON(grp, id) { if (id === 'high' || id === 'low') return SVGI(ICONS[id]); if (grp === 'clinch') return SVGI(ICONS.clinch); if (grp === 'pch') return SVGI('<path d=\"M11 2L4 11h5l-1 7 8-10h-5z\"/>');   /* the Puncher's chance: a bolt */",
        "icon")
    rep("range > 1 ? 'Inside only.' : me.held ? 'The referee will not allow it yet.' : '')}</div>`;",
        "range > 1 ? 'Inside only.' : me.held ? 'The referee will not allow it yet.' : '')}\n"
        "      ${(() => { const open = pcOpen({ f: F }, 0), pow = pcPower(P), short = left + (P.pch ? N.pchSt : 0) < N.pchSt, used = F[0].pcR === pcRound(F[0]);   /* PUNCHCHANCE (S561): the comeback switch - open only to the man behind, once a round */\n"
        "        return sw('pch', 'x', `Puncher's chance`, `+${N.pchSt} stamina`, `All in. Your next power punch this beat does double damage and puts him down if it lands.\\nBlocked or short, you are wide open: his punches land as counters for the rest of the beat.\\nOnce a round.`, !!P.pch, (!open || !pow || short || P.clinch) && !P.pch,\n"
        "          !open ? (used ? 'Used this round.' : F[0].pcDrop === pcRound(F[0]) ? 'Not in the round his put you down.' : `Opens when you are ${N.pcGap} or more health behind.`) : !pow ? 'Pick a power punch first: hook, cross, overhand or uppercut.' : short ? `Needs ${N.pchSt} stamina.` : ''); })()}</div>`;",
        "the switch")
    rep("${m.g <= 0 ? '<span class=\"tag\">guard broken</span>' : ''}",
        "${m.g <= 0 ? '<span class=\"tag\">guard broken</span>' : ''}${pcOpen({ f: F }, k) ? `<span class=\"tag\" style=\"border-color:var(--gold);color:var(--gold)\"${tipAttr(k ? `He is ${N.pcGap} or more health behind: his Puncher's chance is open this round.\\nOne power punch of his can be all in: double damage, and it puts you down if it lands.\\nBlock it or be out of reach and he is wide open.` : `You are ${N.pcGap} or more health behind: your Puncher's chance is open this round. The switch is beside the clinch.`)}>Puncher's chance open</span>` : ''}",
        "the tag beside the name")
    rep("if (g === 'clinch') { P.clinch = !P.clinch; if (P.clinch) { P.lead = P.rear = null; P.feet = 'hold'; } }",
        "if (g === 'pch') { P.pch = !P.pch; return plan(); } if (g === 'clinch') { P.clinch = !P.clinch; if (P.clinch) { P.lead = P.rear = null; P.feet = 'hold'; } }",
        "the click")
    rep("P.ord = P.ord.filter((sl) => active(P, sl)); plan(); };",
        "P.ord = P.ord.filter((sl) => active(P, sl)); if (P.pch && (P.clinch || !pcPower(P) || cost(P) > F[0].st)) P.pch = false;   /* all in needs a power punch it can pay for */ plan(); };",
        "the click's check")
    rep("P = { ...P, clinch: false, lead: affordable(P.lead)", "P = { ...P, clinch: false, pch: false, lead: affordable(P.lead)", "carry over")
    rep("  else if (/^push/.test(e.a || '')) L.push('A push is",
        "  else if (/big one|wide open/.test(e.a || '')) L.push(`Puncher's chance: open only to the man ${N.pcGap} or more health behind, once a round, +${N.pchSt} stamina. His next power punch that beat is all in: double damage, and the other man goes down if it lands. Blocked or short, he is wide open: punches at him land as counters for the rest of the beat. Never open in the round an all-in punch put him down.`);\n"
        "  else if (/^push/.test(e.a || '')) L.push('A push is",
        "the rule tooltip")
    rep("b = document.querySelector(e.id ? `.sw[data-id=\"${e.id}\"]` : e.t === 'clinch' ? '.sw[data-g=\"clinch\"]' : null)",
        "b = document.querySelector(e.id ? `.sw[data-id=\"${e.id}\"]` : e.t === 'clinch' ? '.sw[data-g=\"clinch\"]' : /big one/.test(e.a || '') ? '.sw[data-g=\"pch\"]' : null)",
        "the lit switch")
    io.open(OUT, "w", encoding="utf-8", newline="").write(s)
    print(f"MAKE_PUNCH wrote {OUT.name} from {SRC.name} + {TWEAK.name} ({len(tw['src'])} rule edits)")


if __name__ == "__main__":
    main()
