"""make_mmc.py - mmc.html: the boxing page (order.html) with Mixed Martial Cards' DISTANCE STRUCTURE (MMCTOY1, S569).

Owner S569, after reading how Mixed Martial Cards handles distance: "i care about the way they structured it and their
rules", then "Build the toy". Measured in docs/MMCTOY1_RESULT.md. Their rules read, not copied: no card text, number or
art of theirs is here.

    python proto/twohands/tools/make_mmc.py [ops/research/s558_balance/mmc_m2.json]

Two places (Outside, the pocket) and the clinch; the jab and the body jab are long range (no counter off them, a punch
timed for his step in from Outside is a step-in counter); a back off from the pocket creates distance (the beat ends
there, the other man has the lead); the lead wins a tie of speed; the feint is a MODE of a lead-hand punch.

The RULES are the measured tweak file, applied text for text to the rules part of the page (above the page mark, as
tools/rules.mjs reads it). The PAGE part is patched here: two range pills, the lead and off rhythm on a man's card, the
feint chip on a lead-hand punch card, no back off Outside, the help box, the rule tooltips, and the words of the shared
ui files (Long / Mid / Inside) put right at run time. Every anchor must be found exactly once: an edit to order.html
that moves one stops the build with its text. order.html is never written. Run again after order.html changes.
order.html is CRLF in some checkouts and LF in git: it is read as LF, and mmc.html is written LF.
"""
from __future__ import annotations

import io
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
SRC = HERE.parent / "order.html"
OUT = HERE.parent / "mmc.html"
TABLE = "vtable_mmc.json"
TWEAK = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "ops/research/s558_balance/mmc_m2.json"

# [text on the page, its replacement, what it is] - kept as JSON so the page's own quotes need no second escaping
PAGE = json.loads(r'''[
 [
  "<title>Puncher's chance</title>",
  "<title>Puncher's chance - Outside and the pocket</title>",
  "title"
 ],
 [
  "<span id=\"where\"></span>",
  "<span class=\"lab\" title=\"A trial page (MMCTOY1): two places - Outside and the pocket. The jab is long range, a back off ends the beat, one man has the lead, the feint is a mode of a punch. The main page is order.html.\">trial: Outside / Pocket</span><span id=\"where\"></span>",
  "the trial tag"
 ],
 [
  "</style><script src=\"ring_ui.js\" defer>",
  ".sw .fm{display:inline-block;margin-left:.35rem;padding:0 .4rem;border:1px dashed currentColor;border-radius:.7rem;font-size:.68rem;line-height:1.25;opacity:.85;cursor:pointer;font-style:normal;text-decoration:none}.sw .fm:hover{opacity:1}.sw .fm.on{background:var(--gold,#e3ab45);color:#1a120c;border-style:solid;opacity:1;font-weight:700}.sw.pc .rg .fm{position:absolute;right:.12rem;top:2.36rem;z-index:3;margin:0;padding:0 .16rem;font-size:.54rem;line-height:1.35;background:#000c;color:#f2e6d8;border-radius:.3rem}.sw.pc .rg .fm.on{background:var(--gold,#e3ab45);color:#1a120c}.man{position:relative}.man .tag.ld,.man .tag.offr{position:absolute;top:.5rem;right:.7rem;margin:0}.man .tag.offr{top:2.1rem}.tag.ld{background:var(--gold,#e3ab45);color:#1a120c}.tag.offr{background:#6a302b;color:#fff}\n</style><script src=\"ring_ui.js\" defer>",
  "styles: the feint chip, the lead tag"
 ],
 [
  "fetch('vtable.json')",
  "fetch('vtable_mmc.json')",
  "its own look-ahead table"
 ],
 [
  "${m.g <= 0 ? '<span class=\"tag\">guard broken</span>' : ''}",
  "${m.lead ? `<span class=\"tag ld\"${tipAttr('THE LEAD. When both men throw at the same speed in the same moment, the man with the lead lands first - and a big punch that lands stops the other. You get it when he backs off to create distance, when your step in cuts his back off off, when he bites on your feint, or when your hand is busy as he feints. A new round starts with nobody in the lead.')}>${k ? 'he has' : 'you have'} the lead</span>` : ''}${m.off ? `<span class=\"tag offr\"${tipAttr('OFF RHYTHM this beat (a hand went to a feint last beat): no counter bonus, and in moment 1 the hands are still where they were held last beat.')}>off rhythm</span>` : ''}${m.g <= 0 ? '<span class=\"tag\">guard broken</span>' : ''}",
  "the lead and off rhythm on a man's card"
 ],
 [
  "[1, 2, 3].map((r) => `<span class=\"${r === range ? 'on' : ''}\">${RNG[r]}</span>`)",
  "[2, 3].map((r) => `<span class=\"${r === range ? 'on' : ''}\">${RNG[r]}</span>`)",
  "two range pills"
 ],
 [
  "clamp(range + (stepAt >= 0 && stepAt < at ? dr : 0), 1, 3)",
  "clamp(range + (stepAt >= 0 && stepAt < at ? dr : 0), 2, 3)",
  "where a card will be thrown from: two places"
 ],
 [
  "${[1, 2, 3].map((r) => `<i class=\"${a.reach.includes(r) ? 'y' : ''}${r === at ? ' now' : ''}\">${RNG[r]}</i>`).join('')}",
  "${[2, 3].map((r) => `<i class=\"${a.reach.includes(r) ? 'y' : ''}${r === at ? ' now' : ''}\">${RNG[r]}</i>`).join('')}",
  "a card's reach: two places"
 ],
 [
  "(jab, body jab, lead hook, lead uppercut, body hook, feint, push)",
  "(jab, body jab, lead hook, lead uppercut, body hook). Each can be thrown as a FEINT: the small feint on its card",
  "the lead hand's words"
 ],
 [
  "const hand = (h) => { const slot = h ? 'rear' : 'lead',",
  "const fm = (id, on) => `<span class=\"fm${on && P.fnt === 'lead' ? ' on' : ''}\" data-fm=\"${id}\"${tipAttr('FEINT MODE: pull this punch. 1 stamina, no damage. The hand of his that guards that side goes to it unless it is busy in that moment: it then guards nothing for the rest of the beat, you take the lead and he is off rhythm next beat. If that hand was busy he did not bite, and he takes the lead.')}>feint</u>`;   /* MMCTOY1: the feint is a mode of a lead-hand punch */\n  const hand = (h) => { const slot = h ? 'rear' : 'lead',",
  "the feint chip"
 ],
 [
  "return sw(slot, id, a.n, a.st + ' stamina', sub, on, P.clinch || (short && !on), why, 0, a.d ? rg(a, after) : ''); }).join('') + '</div>'; };",
  "const asF = on && slot === 'lead' && P.fnt === 'lead'; return sw(slot, id, a.n + (asF ? ' (feint)' : ''), (asF ? 1 : a.st) + ' stamina', sub, on, P.clinch || (short && !on), why, 0, a.d ? rg(a, after).replace(/<\\/span>$/, () => (slot === 'lead' ? fm(id, on) : '') + '</span>') : ''); }).join('') + '</div>'; };",
  "a punch card carries its feint chip"
 ],
 [
  "for (const b of $('board').querySelectorAll('.sw')) b.onclick = () => {",
  "for (const c of $('board').querySelectorAll('.fm')) c.onclick = (ev) => { ev.stopPropagation(); const id = c.dataset.fm, was = { lead: P.lead, fnt: P.fnt, clinch: P.clinch }; if (P.lead === id && P.fnt === 'lead') P.fnt = null; else { P.clinch = false; P.lead = id; P.fnt = 'lead'; } if (cost(P) > F[0].st) Object.assign(P, was); if (active(P, 'lead') && !P.ord.includes('lead')) P.ord = [...P.ord, 'lead']; plan(); };\n  for (const b of $('board').querySelectorAll('.sw')) b.onclick = () => {",
  "a click on the chip: that punch, as a feint"
 ],
 [
  "bad = (id === 'back' && me.ropes >= 2) || (id === 'in' && me.kept);",
  "bad = (id === 'back' && (me.ropes >= 2 || range > 2)) || (id === 'in' && me.kept);",
  "no back off Outside"
 ],
 [
  "id === 'hold' ? `You are at ${RNG[range]}.` : ft.t",
  "id === 'hold' ? (range > 2 ? 'You are Outside.' : 'You are in the pocket.') : ft.t",
  "where you are"
 ],
 [
  "bad ? (id === 'in' ? 'His jab landed: no way in this beat.' : 'You are on the ropes.')",
  "bad ? (id === 'in' ? 'His jab landed: no way in this beat.' : range > 2 ? 'You are Outside already: there is no distance to create.' : 'You are on the ropes.')",
  "why no back off"
 ],
 [
  "'Inside only: no punch lands for either man, you get 2 stamina. Not twice running.', P.clinch, (range > 1 || me.held || left + (P.clinch ? 1 : 0) < 1) && !P.clinch, range > 1 ? 'Inside only.' :",
  "'From the pocket only: no punch lands for either man, you get 2 stamina. Not twice running. His jab or body jab in that beat stops it.', P.clinch, (range > 2 || me.held || left + (P.clinch ? 1 : 0) < 1) && !P.clinch, range > 2 ? 'From the pocket only.' :",
  "the clinch card"
 ],
 [
  "pullAt = P.feet === 'back' && feetAt >= 0 ? P.ord.findIndex((s, j) => j > feetAt && s !== 'feet' && ACT[P[s]].d) : -1;",
  "pullAt = -1, cutAt = P.feet === 'back' && range === 2 && feetAt >= 0 ? feetAt : 99;",
  "what a back off cuts"
 ],
 [
  "${i === pullAt ? '<em style=\"font-style:normal;color:var(--gold);margin-left:.35rem\" title=\"The pull counter: you back off first, so this punch lands +1 (not if his step in cuts you off)\">+1</em>' : ''}",
  "${i > cutAt ? '<em style=\"font-style:normal;opacity:.7;margin-left:.35rem\" title=\"Your back off ends the beat: this is not thrown (and costs nothing) unless his step in cuts you off\">not thrown</em>' : ''}",
  "the order chips: not thrown after a back off"
 ],
 [
  "L.push('A step in beats a back off in the same moment: the range closes anyway.');",
  "L.push('A step in beats a back off in the same moment: he is cut off, the beat goes on, and the man who stepped in takes the lead.');",
  "rule words: cut off"
 ],
 [
  "'The pull counter: a back off arms the next punch of the man who backed off, in the same beat, +1 if it lands. Cut off by a step in, it arms nothing.');",
  "'Create distance: a back off from the pocket puts the men Outside and ENDS THE BEAT. Nothing later is thrown by either man, and what was not thrown costs nothing. The other man has the lead next beat.');",
  "rule words: create distance"
 ],
 [
  "L.push(\"After a blocked punch the other man's later punches this beat are counters (+1 health).\"); }",
  "L.push(a.lr ? 'Long range: a jab or a body jab that is blocked gives no counter.' : \"After a blocked punch the other man's later punches this beat are counters (+1 health).\"); }",
  "rule words: block"
 ],
 [
  "L.push(\"After a miss the other man's later punches this beat are counters (+1 health).\"); }",
  "L.push(a.lr ? 'Long range: a jab or a body jab that misses gives no counter.' : \"After a miss the other man's later punches this beat are counters (+1 health).\"); }",
  "rule words: miss"
 ],
 [
  "L.push('A feint draws his hands: the punch in the next moment cannot be blocked.');",
  "L.push('The feint drew that hand: it guards nothing for the rest of the beat.');",
  "rule words: feint hit"
 ],
 [
  "L.push('Counter: his punch missed or was blocked earlier this beat, so this one does +1 health.');",
  "L.push(/step-in counter/.test(o) ? 'Step-in counter (+1 health): he walked in from Outside onto a punch timed for that moment.' : 'Counter: his punch missed or was blocked earlier this beat, so this one does +1 health. A man who is off rhythm gets none.');",
  "rule words: counter"
 ],
 [
  "A big one (3 health or more) that lands stops the slower punch. Its stamina is still paid.');",
  "At the same speed the man with THE LEAD lands first. A big one (3 health or more) that lands stops the other punch. Its stamina is still paid.');",
  "rule words: the lead"
 ],
 [
  "L.push('A feint draws his hands: your punch in the NEXT moment cannot be blocked. 1 stamina, no damage.');",
  "L.push('A feint is a punch you pull: 1 stamina, no damage. The hand that guards that side goes to it unless it is busy in that moment: it then guards nothing for the rest of the beat, the feinter takes the lead and the other man is off rhythm next beat. A busy hand does not bite: that man takes the lead.');",
  "rule words: feint"
 ],
 [
  "L.push('The clinch: Inside only, 1 stamina. No punch lands for either man, 2 stamina back, the referee breaks them at Mid. Not twice running; a push stops it.');",
  "L.push('The clinch: from the pocket only, 1 stamina. No punch lands for either man, 2 stamina back, the referee breaks them in the pocket. Not twice running; a jab or a body jab thrown that beat stops it.');",
  "rule words: clinch"
 ],
 [
  "function plan() { phase = 'plan'; draw();",
  "function plan() { phase = 'plan'; if (!P.lead || P.clinch) P.fnt = null; if (P.feet === 'back' && range > 2) { P.feet = 'hold'; P.ord = ordOf(P); } draw();",
  "the plan: a feint needs its punch, no back off Outside"
 ],
 [
  "round++; beat = 0; range = 3; for (const m of F) { m.pts = 0; m.st = m.cap; m.g = N.guard; m.ropes = 0; m.held = 0; m.kept = 0; m.gave = 0; }",
  "round++; beat = 0; range = 3; for (const m of F) { m.pts = 0; m.st = m.cap; m.g = N.guard; m.ropes = 0; m.held = 0; m.kept = 0; m.gave = 0; m.lead = m.off = 0; }",
  "the bell: nobody has the lead"
 ],
 [
  "Round ${round}: back at Long.`;",
  "Round ${round}: back Outside.`;",
  "the bell's words"
 ],
 [
  "'Round 1. You start at Long: only a jab reaches.'",
  "'Round 1. You start Outside: only the jab and the body jab reach.'",
  "the first words"
 ]
]''')
# the help box (the page's "how" paragraph), whole
HOW_NEW = json.loads(r'''"<b>Two places.</b> <b>Outside</b>: only the jab and the body jab reach. <b>The pocket</b>: every punch reaches. Step in to get there; the clinch is from the pocket only.<br><b>The jab is long range:</b> when it misses or is blocked he gets no counter, and a jab in your beat stops his clinch. Walk in from Outside onto a punch he timed for that moment and it is a <b>step-in counter</b> (+1).<br><b>Back off = create distance.</b> From the pocket it puts you Outside and <b>ends the beat</b>: nothing later is thrown, by either man. You give ground (two and you are on the ropes) and he has the lead. His step in in the same moment cancels it, and he takes the lead.<br><b>The lead:</b> when both men throw at the same speed in the same moment, the man with the lead lands first, and a big punch that lands stops the other.<br><b>The feint is a mode</b> of a lead-hand punch (the small <i>feint</i> on its card): 1 stamina, no damage. The hand of his that guards that side goes to it: it guards nothing for the rest of the beat, you take the lead and he is off rhythm next beat. If that hand was busy in that moment he did not bite, and he takes the lead.<br><b>Each hand</b> throws one punch a beat, or stays home and blocks: the lead hand high stops straight head punches, low stops body punches; the rear hand high stops hooks, low stops uppercuts. <b>A beat is three moments</b>, in the order you set; a hand is out of its guard only in the moment it acts, and the faster punch lands first. A punch of his that misses or is blocked (not a jab) makes your later punches counters (+1).<br><b>Stamina:</b> 1 comes back each beat, and 1 more for each hand you held. <b>The judges:</b> more points takes the round 10-9, 10-8 when 5 or more ahead; level on points it goes to the man who backed off less."''')
# the last lines of the page: the words of the shared ui files, corrected as they are drawn
TAIL_FROM, TAIL_TO = json.loads(r'''["setup();\nif (/peek=/","window.addEventListener('DOMContentLoaded', () => { const FIX = [[/\\(Inside only\\)/g, '(from the pocket only)'], [/Inside only/g, 'from the pocket only'], [/brings you to Mid, where more punches land/g, 'brings you into the pocket, where every punch lands'], [/breaks them at Mid/g, 'breaks them in the pocket'], [/\\bat Mid\\b/g, 'in the pocket'], [/\\bat Long\\b/g, 'Outside'], [/\\bat (Pocket|Outside)\\b/g, (m, w) => (w === 'Pocket' ? 'in the pocket' : 'Outside')], [/\\bLong\\b/g, 'Outside'], [/\\bMid\\b/g, 'the pocket']];\n  const fixIn = (root) => { const w = document.createTreeWalker(root, NodeFilter.SHOW_TEXT); for (let n = w.nextNode(); n; n = w.nextNode()) { let t = n.nodeValue; for (const [a, b] of FIX) t = t.replace(a, b); if (t !== n.nodeValue) n.nodeValue = t; } };   /* MMCTOY1: body_ui.js, ring_ui.js and strip_ui.js are shared with the main page - their words about Long / Mid / Inside are put right here */\n  for (const id of ['side', 'said', 'stage']) { const el = document.getElementById(id); if (el) { new MutationObserver(() => fixIn(el)).observe(el, { childList: true, subtree: true, characterData: true }); fixIn(el); } }\n  const strip2 = () => { const el = document.getElementById('strip'); if (!el) return; fixIn(el); if (phase === 'plan' && P && P.fnt === 'lead') for (const c of el.querySelectorAll('.slot[data-sl=\"lead\"] .vb')) { const n = c.firstChild; if (n && n.nodeType === 3 && /punch/i.test(n.nodeValue)) n.nodeValue = n.nodeValue.replace(/punch/i, 'FEINT'); } };   /* the strip is rebuilt on every plan (strip_ui.js): a feinted punch's slot says FEINT */\n  new MutationObserver(strip2).observe(document.body, { childList: true, subtree: true }); strip2(); });\nsetup();\nif (/peek=/"]''')


def main() -> None:
    s = io.open(SRC, encoding="utf-8", newline="").read().replace("\r\n", "\n")
    tw = json.load(io.open(TWEAK, encoding="utf-8"))

    def rep(text: str, a: str, b: str, what: str) -> str:
        if text.count(a) != 1:
            sys.exit(f"MAKE_MMC FAIL {what}: anchor found {text.count(a)} times: {a[:90]!r}")
        return text.replace(a, b)

    # ---- the rules: the tweak file as measured, on the rules part only (what tools/rules.mjs reads)
    i, j = s.index("<script>") + 8, s.index("// ---- the page")
    rules = s[i:j]
    for n, (a, b) in enumerate(tw["src"]):
        rules = rep(rules, a, b, f"tweak src {n}")
    s = s[:i] + rules + s[j:]

    # ---- the page
    own = (HERE.parent / TABLE).exists()
    for a, b, what in PAGE:
        if what == "its own look-ahead table" and not own:
            continue
        s = rep(s, a, b, what)
    a0 = '<div class="how">'
    if s.count(a0) != 1:
        sys.exit("MAKE_MMC FAIL how: the help box moved")
    h0 = s.index(a0) + len(a0)
    h1 = s.index("</div>`;", h0)
    s = s[:h0] + HOW_NEW + s[h1:]
    s = rep(s, TAIL_FROM, TAIL_TO, "the words of the shared ui files")
    io.open(OUT, "w", encoding="utf-8", newline="").write(s)
    print("MAKE_MMC look-ahead table: " + (f"{TABLE} (its own)" if own else f"NONE OF ITS OWN: build {TABLE} (balance.mjs table tweak=<the tweak> out=proto/twohands/{TABLE}); the main page's table is for three ranges"))
    print(f"MAKE_MMC wrote {OUT.name} from {SRC.name} + {TWEAK.name} ({len(tw['src'])} rule edits, {len(PAGE) + 2} page edits)")


if __name__ == "__main__":
    main()
