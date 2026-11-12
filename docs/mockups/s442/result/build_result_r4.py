"""S442 result page, round 4: drawn from bout_r4.json (tools/result_dump.gd seed 44 cf 200, the game as it stands today).
Every number and word comes from bout_r4.json or a game word table it carries. Round 3's files stay as they are.
python docs/mockups/s442/result/build_result_r4.py -> fight_result_r4.html ; python tools/render_mockup.py <that html>"""
import base64, html, io, json, pathlib, re
from PIL import Image

ROOT = pathlib.Path("E:/FightCamp/Lean")
HERE = pathlib.Path(__file__).parent
OUT = HERE / "fight_result_r4.html"
D = json.loads((HERE / "bout_r4.json").read_text(encoding="utf-8"))
W = D["words"]
E = html.escape


def b64(p):
    return base64.b64encode(pathlib.Path(p).read_bytes()).decode()


def img64(im):
    buf = io.BytesIO()
    im.save(buf, "PNG")
    return "data:image/png;base64," + base64.b64encode(buf.getvalue()).decode()


top = Image.open(ROOT / "docs/mockups/s439/result/top_today.png").convert("RGB")   # the game's own portraits
FACE = {"a": img64(top.crop((205, 113, 291, 199)).resize((108, 108), Image.LANCZOS)),
        "b": img64(top.crop((1629, 113, 1715, 199)).resize((108, 108), Image.LANCZOS))}

# ---------------------------------------------------------------- the colour legend (asserted at the end)
# ours = our fighter, everywhere; theirs = the opponent, everywhere; good / bad = outcomes and fits only;
# gold = the one primary action and the deciding marks (judge cell, the turned exchange, the best-fix card); the rest greys.
LEGEND = {"ours": "#f0a04b", "theirs": "#5b8fd6", "good": "#6cc27a", "bad": "#e0503c", "gold": "#ffd84a", "neutral": "#8a8079"}
OURS, THEIRS, GOOD, BAD, GOLD, GREY = (LEGEND[k] for k in ("ours", "theirs", "good", "bad", "gold", "neutral"))
BASE = {"#070605", "#0b0a0a", "#100e0d", "#121010", "#151313", "#1a1716", "#221f1d", "#2c2826", "#3a3532", "#4a423c",
        "#6a625c", "#a89c90", "#c9bfb3", "#d9cdbf", "#f3ece2", "#ffffff", "#2a2420", "#3d332b"}
assert OURS != BAD and OURS != GOLD

# ---------------------------------------------------------------- facts from the bout
F, O = D["fighter"], D["opponent"]
A, B = F["first"], O["first"]
ROUNDS = D["rounds"]
EXS = [x for r in ROUNDS for x in r["exchanges"]]
RX = [(ri, x) for ri, r in enumerate(ROUNDS) for x in r["exchanges"]]
CALL_LABEL = {k: v["label"] for k, v in W["calls"].items()}          # the shout bar's call names
MODE_LABEL = {k: v["label"] for k, v in W["modes"].items()}          # the opponent's games
EDGE_WORD = W["edge_word"]                                           # the shout bar's fit words
FIT_WORDS = W["fit_words"]                                           # the Playbook's fit words
RING = W["ring_place"]                                               # At range / In the pocket / Inside
TIRED = W["she_tired"]                                               # the tired line, 35
PLAN = D["plan"]
LETTER = {p["move"]: p["letter"] for p in PLAN}
LINE = {p["letter"]: p for p in PLAN}
FW = D["fight_why"]
ST = D["fight_stats"]
CF = D["counterfactual"]
CARDS = D["cards"]
FLIP = D["flip_round"]
N = CF["n"]
WINS = CF["wins"]
SAME = CF["same_bout"]
LUCK = 10          # a measured change under 10 of 200 (5 in 100) is luck: no button for it
CARD_NAME = {"long": "Long range", "mid": "Mid range", "inside": "Inside", "clinch": "Clinch", "own_ropes": "On the ropes",
             "opp_ropes": "Opponent on the ropes", "outside": "Outside"}   # the plan cards' own names
CARD_LADDER = {"long": 0, "mid": 1, "inside": 2}


def judge_rows():
    """Two judges score every round to its winner; judge 3 scores the flip round the other way."""
    rows = []
    for j in range(3):
        rows.append([(10, 9) if r["won"] != (j == 2 and i == FLIP) else (9, 10) for i, r in enumerate(ROUNDS)])
    return rows


JR = judge_rows()
for j, row in enumerate(JR):
    assert "%d-%d" % (sum(a for a, _ in row), sum(b for _, b in row)) == CARDS[j], (row, CARDS[j])
for r in ROUNDS:   # the opponent's game: a run never over 3
    run, prev = 0, ""
    for x in r["exchanges"]:
        run = run + 1 if x["mode"] == prev else 1
        prev = x["mode"]
        assert run <= 3, ("opponent game run over 3", r["n"], x["i"])
for x in EXS:      # a plan line fires only on its own card and its own WHEN situation
    if x["planned"]:
        ln = LINE[LETTER[x["arrow"]]]
        assert x["at"] == ln["place"] and ln["when"] in ("", x["sit"]), ("line fired off its card", x)
places = [x["place"] for x in EXS]
assert all(abs(a - b) <= 1 for a, b in zip(places, places[1:])), places
xw = [sum(1 for x in EXS if x["won"]), sum(1 for x in EXS if not x["won"])]
assert xw == ST["xwon"]
assert [sum(x["landed"][k] for x in EXS) for k in (0, 1)] == ST["landed"]
assert [sum(x["body"][k] for x in EXS) for k in (0, 1)] == ST["body"]
for r, sr in zip(ROUNDS, ST["rounds"]):
    assert r["won_n"] == sr["xwon"][0] and r["landed"] == sr["landed"]
assert SAME["as_written"]["outcome"] == D["outcome"] and SAME["as_written"]["cards"] == CARDS, "the replay reproduces the bout"


def plain(sit):
    return MODE_LABEL.get(sit, sit)


def where(ri, x):
    return "round %d, exchange %d" % (ri + 1, x["i"] + 1)


def short(call):
    """A call's name up to its comma ("Hands up, move your head" -> "Hands up"): the chip's room."""
    return CALL_LABEL[call].split(",")[0]


# ---------------------------------------------------------------- the causes (every lost exchange in exactly one group)
LOST = [(ri, x) for ri, x in RX if not x["won"]]
by_sit = {}
for ri, x in LOST:
    by_sit.setdefault(x["sit"], []).append((ri, x))
assert sum(len(v) for v in by_sit.values()) == ST["xwon"][1]
c_uses = [(ri, x) for ri, x in RX if x["planned"] and LETTER[x["arrow"]] == "C"]
c_lost = [x for _, x in c_uses if not x["won"]]
assert all(x["sit"] == "counter" for x in c_lost) and len(c_lost) == len(by_sit.get("counter", []))
turned = [(ri, x) for ri, x in RX if x["plan_swing"] < 0]
assert len(turned) == FW["cost"] == 1 and turned[0][1] is min(EXS, key=lambda x: abs(x["margin"])), "the turned exchange is the closest"
loadup = [x for x in EXS if x["sit"] == "loadup"]
hands = [x for x in loadup if x["call"] == "hands"]
assert all(x["fit"] == "best" for x in hands)
hurt_after = [(ri, x) for ri, x in RX if x["after"]["hurt"][0]]


def start_energy(side):
    """Energy as each exchange starts: the round's start, then the exchange before's end."""
    out = []
    for r in ROUNDS:
        e = r["start"][side]
        for x in r["exchanges"]:
            out.append(e)
            e = x["after"][side]
    return out


SE_A, SE_B = start_energy("a"), start_energy("b")
tired_a = [(ri, x) for (ri, x), e in zip(RX, SE_A) if e < TIRED]
tired_b = [x for x, e in zip(EXS, SE_B) if e < TIRED]
opener = [(ri, x) for ri, x in RX if x["i"] == 0 and ri > 0]
assert all(x["call"] == ROUNDS[ri]["corner"] and x["fit"] == "none" and not x["shout"] for ri, x in opener), "the minute's call had no edge on the openers"
gain = {k: WINS[k] - WINS["as_written"] for k in WINS}
gf = D["before"]["opp_file"]
weapon = next(t for t in gf if t["id"] == "weapon")
on_ropes = [(ri, x) for ri, x in RX if x["at"] == "own_ropes"]
hurt_ropes = [(ri, x) for ri, x in hurt_after if x["at"] == "own_ropes"]
best_rewrite = CF["rewrite_name"]
why_next = FW["next"]   # the game's own next step (it names another move: see the result file)


def pct(v):
    return "%d of %d" % (v, N)


CAUSES = [
    {"key": "linec", "title": "Line C threw into %s's counter" % B, "lost": len(c_lost), "of": len(c_uses),
     "lost_words": "%d of %d exchanges lost" % (len(c_lost), len(c_uses)), "gain": gain["rewrite_c"], "measure": "rewrite_c",
     "lines": ["%s into a counter-puncher: %s." % (LINE["C"]["move_name"], FIT_WORDS[LINE["C"]["fit"]].lower()),
               ("On %s's file before the bout: %s." if weapon["known"] else "Not on %s's file before the bout: %s.") % (B, weapon["value"].lower())],
     "btn": "Rewrite line C: %s" % best_rewrite,
     "btn_hover": "Opens the Playbook on line C, %s in place of %s. The Playbook rates it %s against a counter-puncher: feints and single jabs answer a counter; long combinations walk into it." % (
         best_rewrite, LINE["C"]["move_name"], FIT_WORDS[CF["rewrite_fit"]].lower()),
     "hover": "Line C fired at the start of every round. It won %d of %d, and without the plan's edge %s would have gone the other way. "
              "The Why after the fight: %s %s" % (
                  len(c_uses) - len(c_lost), len(c_uses), where(*turned[0]), why_next,
                  "It agrees with the measured fix." if best_rewrite in why_next else "This page follows the measured fix, %s." % best_rewrite)},
    {"key": "tools", "title": "Right call, not the tools", "lost": len(by_sit.get("loadup", [])), "of": len(loadup),
     "lost_words": "%d of %d lost while %s loaded up" % (len(by_sit.get("loadup", [])), len(loadup), B), "gain": None, "measure": None,
     "lines": ["%s called %d times: %s, won %d" % (short("hands"), len(hands), EDGE_WORD["best"].lower(), sum(1 for x in hands if x["won"])),
               "%s is %s at it" % (A, D["call_grades"]["hands"]), "The fix is training"],
     "btn": "Training: Defence focus", "btn_hover": "Opens the Training tab with Defence as next week's focus. Not measured: the replays change only the plan and the corner.",
     "hover": "A plan line for loading up (at mid range, Step back) was measured too: %s instead of %s nights in %d, inside luck." % (WINS["add_loadup_line"], WINS["as_written"], N)},
    {"key": "minute", "title": "The minute called the last round", "lost": None, "of": None,
     "lost_words": "%d openers lost, no edge" % sum(1 for _, x in opener if not x["won"]), "gain": gain["open_call"], "measure": "open_call",
     "lines": ["Each round opened: %s" % plain("counter").lower(), "Calls %s, %s: no edge there" % (short(ROUNDS[1]["corner"]), short(ROUNDS[2]["corner"])),
               "%s instead: this night %s" % (short(W["modes"]["counter"]["best"]), "won" if SAME["open_call"]["outcome"] == "win" else "lost")],
     "btn": "", "btn_hover": "",
     "hover": "Measured: the minute calls %s for rounds 2 and 3 instead of the coach's read of the round before. This night: %s %s. Over %d other nights: %d wins against %d." % (
         CALL_LABEL[W["modes"]["counter"]["best"]], SAME["open_call"]["outcome"], ", ".join(SAME["open_call"]["cards"]), N, WINS["open_call"], WINS["as_written"])},
    {"key": "tired", "title": "Tired at the end", "lost": len(tired_a) - sum(1 for _, x in tired_a if x["won"]), "of": len(tired_a),
     "lost_words": "%d of %d lost under the tired line" % (len(tired_a) - sum(1 for _, x in tired_a if x["won"]), len(tired_a)), "gain": gain["push_last"], "measure": "push_last",
     "lines": ["Under %d: %s %d exchanges, %s %d" % (TIRED, A, len(tired_a), B, len(tired_b)), "Last bell %d-%d, %s first" % (round(EXS[-1]["after"]["a"]), round(EXS[-1]["after"]["b"]), A),
               "Push the last minute: this night %s" % ("won" if SAME["push_last"]["outcome"] == "win" else "lost")],
     "btn": "", "btn_hover": "",
     "hover": "Line C's wrong answers had cost %s %d of the tank for the rest of the fight. Measured: Push from exchange 4 of round 3. Over %d other nights: %d wins against %d." % (
         A, round(FW["pressure"]["tank"]), N, WINS["push_last"], WINS["as_written"])},
]
for c in CAUSES:   # no button for a measured change inside luck; a measured card shows its number
    if c["gain"] is not None and abs(c["gain"]) < LUCK:
        assert not c["btn"], c["key"]
CAUSES.sort(key=lambda c: (-(c["gain"] if c["gain"] is not None and c["gain"] >= LUCK else -1), -(c["lost"] or 0)))
BEST = CAUSES[0]
assert BEST["key"] == "linec" and BEST["gain"] >= LUCK and BEST["gain"] == max(gain[k] for k in ("rewrite_c", "no_line_c", "add_loadup_line", "open_call", "push_last"))


def ic(name, c, s=20):
    p = {
        "star": '<path d="M10 1l2 5 5-2-2 5 4 2-5 2 2 5-5-2-1 4-2-4-5 2 2-5-4-2 5-2-2-5 5 2z" fill="{c}"/>',
        "tick": '<path d="M3 10.5l4.5 4.5L17 5" fill="none" stroke="{c}" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>',
        "cross": '<path d="M5 5l10 10M15 5L5 15" fill="none" stroke="{c}" stroke-width="3" stroke-linecap="round"/>',
    }[name]
    return f'<svg width="{s}" height="{s}" viewBox="0 0 20 20">{p.format(c=c)}</svg>'


FIT_C = {"best": GOOD, "ok": GOOD, "none": GREY, "wrong": BAD}


# ---------------------------------------------------------------- header
def fighter_card(side):
    ours = side == "a"
    p = F if ours else O
    bf, af = D["before"], D["after"]
    rec0, rec1 = (bf["record"], af["record"]) if ours else (bf["opp_record"], af["opp_record"])
    rk0, rk1 = (bf["rank"], af["rank"]) if ours else (bf["opp_rank"], af["opp_rank"])
    col = OURS if ours else THEIRS
    if rk1["now"]:
        rank = 'Rank No. %d <span class="ar">&#8594;</span> <b>No. %d</b>' % (rk0["now"], rk1["now"]) if rk0["now"] else "Rank <b>No. %d</b>" % rk1["now"]
    else:
        rank = "Ladder: <b>%s</b>" % E(rk1["words"].rstrip(".").replace("Unranked: ", "unranked, ").replace("from entering", "to enter"))
    road = ""
    if ours:
        chk = af["season_check"]
        road = f'<div class="fr2">Nationals: {E(chk["reason"].lower()) if not chk["ok"] else "ready to enter"}</div>'
    info = (f'<div class="fi"><div class="fn" style="color:{col}">{E(p["name"]).upper()}</div>'
            f'<div class="fs">{"Your fighter" if ours else E(p.get("club", ""))} &middot; {E(p["style"])} &middot; {E(p["stance"])}</div>'
            f'<div class="fr">Record {rec0[0]}-{rec0[1]} <span class="ar">&#8594;</span> <b>{rec1[0]}-{rec1[1]}</b></div><div class="fr">{rank}</div>{road}</div>')
    face = f'<img class="face" src="{FACE[side]}">'
    return f'<div class="fcard {"a" if ours else "b"}" style="left:{16 if ours else 1404}px;border-left-color:{col}">{face + info if ours else info + face}</div>'


def centre():
    lost = D["outcome"] == "loss"
    word = {"loss": "LOST", "win": "WON", "draw": "DRAW"}[D["outcome"]]
    r2 = ROUNDS[FLIP]
    jw = [JR[j][FLIP][0] > JR[j][FLIP][1] for j in range(3)]
    line = "On points, %s." % ("split" if len(set(CARDS)) > 1 else "unanimous")
    line2 = "Round %d swung it: 2 judges gave it to %s." % (FLIP + 1, B if jw.count(False) >= 2 else A)
    hv = "Round %d: %d-%d in exchanges, %d-%d in punches landed (%s first). A level round goes to the clearer exchanges: %s's. Judge 3 alone gave it to %s." % (
        FLIP + 1, r2["won_n"], 6 - r2["won_n"], r2["landed"][0], r2["landed"][1], A, B, A)
    g = ['<div class="jg"><div></div>'] + [f'<div class="jh">R{i + 1}</div>' for i in range(len(ROUNDS))] + ['<div class="jh">TOTAL</div>']
    for j, row in enumerate(JR):
        g.append(f'<div class="jn">Judge {j + 1}</div>')
        for i, (a, b) in enumerate(row):
            sw = j == 2 and i == FLIP
            t = (' title="%s"' % E("The deciding card: judge 3 alone gave round %d to %s; one more judge and %s won." % (i + 1, A, A))) if sw else ""
            g.append(f'<div class="jc {"a" if a > b else "b"}{" swing" if sw else ""}"{t}>{a}-{b}</div>')
        t = CARDS[j]
        g.append(f'<div class="jt" style="color:{OURS if int(t.split("-")[0]) > int(t.split("-")[1]) else THEIRS}">{t}</div>')
    g.append('</div>')
    cnt = "" if D["counts"]["a"] == 0 and D["counts"]["b"] == 0 else " Standing counts %d-%d." % (D["counts"]["a"], D["counts"]["b"])
    return (f'<div class="centre"><div class="vw" style="color:{BAD if lost else GOOD}">{word}</div>'
            f'<div class="vl" title="{E(hv + cnt)}"><div>{E(line)}{E(cnt)}</div><div>{E(line2)}</div></div>{"".join(g)}</div>')


# ---------------------------------------------------------------- cause cards
def card(c, k, x, w):
    best = c is BEST
    o = [f'<div class="cause{" best" if best else ""}" style="left:{x}px;width:{w}px" title="{E(c["hover"])}">']
    o.append(f'<div class="ctt">{k + 1}. {E(c["title"])}</div>')
    if best:
        o.append('<div class="besttag">BEST FIX</div>')
    o.append(f'<div class="clost">{E(c["lost_words"])}</div>')
    for ln in c["lines"]:
        o.append(f'<div class="cln">{E(ln)}</div>')
    if c["measure"] and abs(c["gain"]) >= LUCK:
        a, b = WINS["as_written"], WINS[c["measure"]]
        o.append(f'<div class="meas"><span class="mk">Wins in {N} nights v {E(B)}</span>'
                 f'<span class="mbar"><i style="width:{a / N * 100:.0f}%;background:{GREY}"></i></span><b>{a}</b>'
                 f'<span class="ar">&#8594;</span><span class="mbar"><i style="width:{b / N * 100:.0f}%;background:{GOOD}"></i></span><b class="g">{b}</b></div>')
    elif c["measure"]:
        o.append(f'<div class="meas"><b>{WINS["as_written"]}</b><span class="ar">&#8594;</span><b>{WINS[c["measure"]]}</b><span>of {N} nights: luck, no button</span></div>')
    else:
        o.append('<div class="meas"><span class="luck">Not measured: replays change plan, corner</span></div>')
    if c["btn"]:
        o.append(f'<div class="btn{" primary" if best else " second"} fixbtn" title="{E(c["btn_hover"])}">{E(c["btn"])}</div>')
    o.append('</div>')
    return "".join(o)


def chances():
    rows = [("as_written", "The plan as written"), ("rewrite_c", "Line C: %s" % best_rewrite), ("no_line_c", "No line C at all")]
    o = ['<div class="chances" title="%s">' % E("Measured: the same opponent and corner on %d other fight nights, one bout each, plus this night's own dice replayed. Only the plan changes. Gaps under %d nights are luck." % (N, LUCK)),
         f'<div class="chh"><span>Plan</span><span>of {N}</span><span>this night</span></div>']
    for k, lab in rows:
        res = SAME[k]["outcome"]
        o.append(f'<div class="chr"><span>{E(lab)}</span><span><b>{WINS[k]}</b></span><span style="color:{GOOD if res == "win" else BAD}">{"won" if res == "win" else "lost"}</span></div>')
    o.append(f'<div class="chn">Rewrite: this night lost again</div><div class="chn">(round 2 goes 3-3), {WINS["rewrite_c"]} of {N} nights won</div></div>')
    return "".join(o)


def causes():
    o = ['<div class="lab" style="left:16px;top:154px">Why it was lost, and the measured fix &middot; best fix first</div>']
    xs, ws = [16, 556, 898, 1240], [528, 330, 330, 330]
    for k, c in enumerate(CAUSES):
        o.append(card(c, k, xs[k], ws[k]))
    o.append(f'<div class="cpanel" style="left:1582px">{chances()}</div>')
    return "".join(o)


# ---------------------------------------------------------------- the fight strip
GX, CW, RG = 268, 88, 12
T0 = 414
Y = {"head": T0 + 8, "game": T0 + 34, "mid": T0 + 112, "plan": T0 + 172, "shout": T0 + 204, "call": T0 + 244, "lane": T0 + 284,
     "tag": T0 + 328, "hurt": T0 + 348, "en": T0 + 372, "en_h": 62}


def cx(k):
    return GX + k * CW + (k // 6) * RG


def strip():
    tx = turned[0]
    key = (f'Plan line: <span class="kc" style="color:{GOOD};border-color:{GOOD}">A</span> beats or works &middot; '
           f'<span class="kc" style="color:{BAD};border-color:{BAD}">C</span> walks into it &middot; '
           f'<span class="kc" style="color:{GREY};border-color:{GREY}">A</span> no fit &middot; {ic("tick", "#c9bfb3", 16)} won {ic("cross", "#c9bfb3", 16)} lost &middot; '
           f'<i class="kd" style="background:{GOOD}"></i>call fits <i class="kd" style="background:{GREY}"></i>no edge &middot; '
           f'{ic("star", BAD, 16)} {E(A)} hurt &middot; <b class="kr">ROPES</b> {E(A)} on the ropes &middot; <b class="kn">&#8800;</b> plan card: another distance')
    o = [f'<div class="lab" style="left:16px;top:{T0 - 26}px">The fight &middot; 18 exchanges of 30 seconds</div>',
         f'<div class="key" style="top:{T0 - 27}px">{key}</div>', f'<div class="sbg" style="top:{T0}px"></div>']
    labels = [(Y["game"] + 6, "%s's game" % B, ""),
              (Y["mid"] - 46, "Punches landed", "%s-%s, bar up = %s won" % (A, B, A)),
              (Y["plan"] + 2, "Plan line used", ""),
              (Y["shout"] + 2, "Your shout", ""),
              (Y["call"] + 4, "Round call, all round", ""),
              (Y["hurt"], "%s hurt" % A, ""),
              (Y["en"] + 2, "Energy 0-100", "")]
    for y, lab, sub in labels:
        o.append(f'<div class="gl" style="top:{y}px">{E(lab)}{"<span>" + E(sub) + "</span>" if sub else ""}</div>')
    for p in range(3):
        o.append(f'<div class="lw" style="top:{Y["lane"] - 4 + p * 15}px">{"WHERE &middot; " if p == 0 else ""}{E(RING[p])}</div>')
    o.append(f'<div class="lw" style="top:{Y["tag"]}px">ropes, clinch: the plan card</div>')
    o.append(f'<div class="gl2" style="top:{Y["en"] + 22}px"><i class="kl" style="background:{OURS}"></i>{E(A)} <i class="kl" style="background:{THEIRS}"></i>{E(B)}<br>dash = tired ({int(TIRED)})</div>')
    for ri, r in enumerate(ROUNDS):
        x = cx(ri * 6)
        jw = [JR[j][ri][0] > JR[j][ri][1] for j in range(3)]
        jt = ("all 3 judges %s" % (A if jw[0] else B)) if len(set(jw)) == 1 else "2 judges %s, 1 %s" % (A if jw[0] else B, B if jw[0] else A)
        o.append(f'<div class="rh" style="left:{x}px;top:{Y["head"]}px;width:{CW * 6 - 4}px"><b>ROUND {ri + 1}</b>'
                 f'<span>exchanges {r["won_n"]}-{6 - r["won_n"]}</span><em>{jt}</em></div>')
        o.append(f'<div class="axis" style="left:{x}px;top:{Y["mid"]}px;width:{CW * 6 - 4}px"></div>')
        call = r["corner"]
        o.append(f'<div class="cband" style="left:{x}px;top:{Y["call"]}px;width:{CW * 6 - 4}px">'
                 f'<span>{E(CALL_LABEL[call]) if call else "No call before round 1"}</span></div>')
        xs = r["exchanges"]
        i = 0
        while i < 6:
            j = i
            while j + 1 < 6 and xs[j + 1]["mode"] == xs[i]["mode"]:
                j += 1
            o.append(f'<div class="run" style="left:{cx(ri * 6 + i)}px;top:{Y["game"]}px;width:{(j - i + 1) * CW - 4}px"><span>{E(MODE_LABEL[xs[i]["mode"]])}</span></div>')
            i = j + 1
    for ri, x in RX:
        k = ri * 6 + x["i"]
        left = cx(k)
        won = x["won"]
        h = min(26.0, abs(x["margin"]) * 0.6) + 6
        top = Y["mid"] - h if won else Y["mid"]
        col = OURS if won else THEIRS
        bh = "%s: %s won it, punches landed %d-%d, to the body %d-%d (%s first)." % (where(ri, x).capitalize(), A if won else B, x["landed"][0], x["landed"][1], x["body"][0], x["body"][1], A)
        o.append(f'<div class="xb {"ours" if won else "theirs"}" style="left:{left + 20}px;top:{top:.0f}px;height:{h:.0f}px;background:{col}" title="{E(bh)}"></div>')
        ly = (top - 20) if won else (top + h + 1)
        o.append(f'<div class="xl" style="left:{left}px;top:{ly:.0f}px;width:{CW - 4}px;color:{col}">{x["landed"][0]}-{x["landed"][1]}</div>')
        if x["planned"]:
            lt = LETTER[x["arrow"]]
            fc = FIT_C[x["arrow_fit"]]
            hv = "Line %s: %s, %s: %s. %s. %s." % (lt, LINE[lt]["place_words"], ("when " + LINE[lt]["when_words"]) if LINE[lt]["when"] else "any time",
                                                 LINE[lt]["move_name"], FIT_WORDS[x["arrow_fit"]] or "No fit either way", "Won" if won else "Lost")
            o.append(f'<div class="pc" style="left:{left + 22}px;top:{Y["plan"]}px;border-color:{fc};color:{fc}" title="{E(hv)}">{lt}{ic("tick" if won else "cross", fc, 16)}</div>')
        else:
            o.append(f'<div class="dash" style="left:{left + 34}px;top:{Y["plan"] + 11}px" title="No plan line for this moment: {E(A)} improvised."></div>')
        if x["shout"]:
            fc = FIT_C[x["fit"]]
            hv = "Your shout: %s. %s against %s. %s." % (CALL_LABEL[x["call"]], EDGE_WORD[x["fit"]], plain(x["sit"]).lower(), "Won" if won else "Lost")
            o.append(f'<div class="sc" style="left:{left + 2}px;top:{Y["shout"]}px;width:{CW - 8}px;border-color:{fc};color:{fc}" title="{E(hv)}">{E(short(x["call"]))}</div>')
        else:
            o.append(f'<div class="dash" style="left:{left + 34}px;top:{Y["shout"] + 11}px"></div>')
        if not x["shout"] and x["call"]:
            fc = FIT_C[x["fit"]]
            hv = "The round's call, %s: %s against %s. %s." % (CALL_LABEL[x["call"]], EDGE_WORD[x["fit"]], plain(x["sit"]).lower(), "Won" if won else "Lost")
            o.append(f'<div class="cd" style="left:{left + 36}px;top:{Y["call"] + 22}px;background:{fc}" title="{E(hv)}"></div>')
        for p in range(3):
            o.append(f'<div class="pl{" on" if p == x["place"] else ""}" style="left:{left + 6}px;top:{Y["lane"] + p * 15}px;width:{CW - 16}px"></div>')
        tags = []
        if x["at"] == "own_ropes":
            tags.append('<b class="kr" title="%s">ROPES</b>' % E("The plan card: %s on the ropes." % A))
        elif x["at"] == "clinch":
            tags.append('<b class="kc2" title="The plan card: in the clinch.">CLINCH</b>')
        if x["at"] in CARD_LADDER and CARD_LADDER[x["at"]] != x["place"]:
            tags.append('<b class="kn" title="%s">&#8800;</b>' % E("The ring has it %s; the plan card says %s. The two disagree here (a known fault being fixed)." % (RING[x["place"]].lower(), CARD_NAME[x["at"]].lower())))
        if tags:
            o.append(f'<div class="tg" style="left:{left}px;top:{Y["tag"]}px;width:{CW - 4}px">{"".join(tags)}</div>')
        if x["after"]["hurt"][0]:
            o.append(f'<div class="hs" style="left:{left + 32}px;top:{Y["hurt"]}px" title="{E(A + " left hurt after this exchange.")}">{ic("star", BAD, 20)}</div>')
    ri, x = turned[0]
    k = ri * 6 + x["i"]
    o.append(f'<div class="turn" style="left:{cx(k) - 3}px;top:{Y["game"] - 4}px;width:{CW + 2}px;height:{Y["hurt"] + 22 - Y["game"]}px" '
             f'title="{E("The exchange that turned the bout: replayed without line C, the game gives it to " + A + ", and round 2 goes 4-2.")}"><span>TURNED IT</span></div>')
    o.append(energy())
    return "".join(o)


def energy():
    y0, h = Y["en"], Y["en_h"]

    def yy(v):
        return y0 + h - v / 100 * h
    o = ['<svg class="en" width="1920" height="1080">']
    for v in (0, 100):
        o.append(f'<line x1="{GX}" x2="{cx(17) + CW}" y1="{yy(v):.1f}" y2="{yy(v):.1f}" stroke="#2c2826" stroke-width="1"/>')
    o.append(f'<line x1="{GX}" x2="{cx(17) + CW}" y1="{yy(TIRED):.1f}" y2="{yy(TIRED):.1f}" stroke="#a89c90" stroke-width="2" stroke-dasharray="7 6"/>')
    for side, col in (("b", THEIRS), ("a", OURS)):
        for ri, r in enumerate(ROUNDS):
            pts = [(cx(ri * 6) + 2, yy(r["start"][side]))] + [(cx(ri * 6 + x["i"]) + CW - 6, yy(x["after"][side])) for x in r["exchanges"]]
            o.append('<polyline class="%s" fill="none" stroke="%s" stroke-width="4" stroke-linejoin="round" points="%s"/>' % ("ours" if side == "a" else "theirs", col, " ".join("%.1f,%.1f" % p for p in pts)))
    o.append('</svg>')
    for ri, r in enumerate(ROUNDS):
        last = r["exchanges"][-1]["after"]
        o.append(f'<div class="ee" style="left:{cx(ri * 6 + 5) - 30}px;top:{min(yy(last["a"]), yy(last["b"])) - 22:.0f}px" title="Energy at the bell, {E(A)} first">'
                 f'<b style="color:{OURS}">{round(last["a"])}</b>-<b style="color:{THEIRS}">{round(last["b"])}</b></div>')
    return "".join(o)


# ---------------------------------------------------------------- bottom row
BY = 874


def damage():
    sd = D["stand_down"]
    inj = D["injury"] or "None"
    hs = ", ".join(where(ri, x) for ri, x in hurt_after)
    until = D["stand_down_words"].split("until ")[1].split(":")[0]
    sd_hv = "The game's line: %s. Only sparring nights are locked." % D["stand_down_words"]
    lines = [f'<div class="dl" title="{E("Hurt after " + hs + ".")}"><b>Hurt {len(hurt_after)} times</b> in the fight, {len(hurt_ropes)} of them on the ropes.</div>',
             f'<div class="dl"><b>Nothing lasting</b>: injury roll {E(inj.lower())}.</div>',
             f'<div class="dl" title="{E(sd_hv)}"><b>No sparring until {E(until)}</b>: the head took {int(sd["damage"])} damage.</div>',
             '<div class="dl">Only sparring is locked; the rest of the week trains in full.</div>']
    return f'<div class="lab" style="left:16px;top:{BY - 24}px">What it cost {E(A)}</div><div class="box" style="left:16px;top:{BY}px;width:556px">{"".join(lines)}</div>'


def numbers():
    def won_at(p):
        return [sum(1 for x in EXS if x["place"] == p and x["won"]), sum(1 for x in EXS if x["place"] == p and not x["won"])]
    groups = [("Exchanges won", ST["xwon"], [("%s" % RING[p], won_at(p)) for p in range(3)]),
              ("Punches landed", ST["landed"], [("to the head", ST["head"]), ("to the body", ST["body"])])]
    o = [f'<div class="lab" style="left:584px;top:{BY - 24}px">The numbers &middot; {E(A)} v {E(B)}</div>'
         f'<div class="box" style="left:584px;top:{BY}px;width:470px" title="One scale per group: each bar is the number beside it against the group total.">']
    for lab, tot, subs in groups:
        scale = max(tot)
        for k, (l, v) in enumerate([(lab, tot)] + subs):
            a, b = v
            assert a <= scale and b <= scale
            o.append(f'<div class="nr{" sub" if k else ""}"><b class="na" style="color:{OURS}">{a}</b><span class="nbl"><i class="ours" style="width:{a / scale * 100:.0f}%;background:{OURS}"></i></span>'
                     f'<span class="nl">{E(l)}</span><span class="nbr"><i class="theirs" style="width:{b / scale * 100:.0f}%;background:{THEIRS}"></i></span><b class="nb" style="color:{THEIRS}">{b}</b></div>')
    assert sum(won_at(p)[0] for p in range(3)) == ST["xwon"][0] and sum(won_at(p)[1] for p in range(3)) == ST["xwon"][1]
    assert ST["head"][0] + ST["body"][0] == ST["landed"][0] and ST["head"][1] + ST["body"][1] == ST["landed"][1]
    o.append('</div>')
    return "".join(o)


SQ_GOOD = f'<i class="sq" style="background:{GOOD}"></i>'
SQ_BAD = f'<i class="sq" style="background:{BAD}"></i>'


def plan_table():
    o = [f'<div class="lab" style="left:1066px;top:{BY - 24}px">The plan and the corner</div><div class="box" style="left:1066px;top:{BY}px;width:838px">',
         f'<div class="ph"><span class="c1">line</span><span class="c2">fit to {E(B)}</span><span class="c3">each use: won / lost</span></div>']
    for p in PLAN:
        uses = [(ri, x) for ri, x in RX if x["planned"] and LETTER[x["arrow"]] == p["letter"]]
        fc = FIT_C[p["fit"]]
        when = ("when " + p["when_words"]) if p["when"] else "any time"
        sq = "".join(f'<i class="sq" style="background:{GOOD if x["won"] else BAD}" title="{E(where(ri, x))}: {"won" if x["won"] else "lost"}"></i>' for ri, x in uses)
        tail = ("won %d of %d" % (sum(1 for _, x in uses if x["won"]), len(uses))) if uses else ("%s never pressed" % B if p["when"] == "press" else "never fired")
        o.append(f'<div class="pr"><span class="c1"><b class="lt" style="color:{fc};border-color:{fc}">{p["letter"]}</b>{E(p["place_words"])}, {E(when)} &#8594; <b>{E(p["move_name"])}</b></span>'
                 f'<span class="c2" style="color:{fc}">{E(FIT_WORDS[p["fit"]] or "no fit")}</span><span class="c3">{sq}<em>{E(tail)}</em></span></div>')
    sh = [x for x in EXS if x["shout"]]
    o.append(f'<div class="pr"><span class="c1">Your {len(sh)} shouts</span><span class="c2" style="color:{GOOD}">{EDGE_WORD["best"].lower()} {sum(1 for x in sh if x["fit"] == "best")} of {len(sh)}</span>'
             f'<span class="c3">{"".join(SQ_GOOD if x["won"] else SQ_BAD for x in sh)}<em>won {sum(1 for x in sh if x["won"])}</em></span></div>')
    o.append(f'<div class="pr"><span class="c1">The plan had a line for {sum(1 for x in EXS if x["planned"])} of {len(EXS)} exchanges</span></div>')
    o.append('</div>')
    return "".join(o)


def footer():
    learned = [l for t in D["aftermath"] if t["id"] == "learned" for l in t["lines"] if B in l]
    return ('<div class="foot">' + (f'<span class="fl">{E(learned[0])}</span>' if learned else "") +
            '<div class="btn quiet">Continue</div></div>')


CSS = """
@font-face{font-family:Barlow;font-weight:500;src:url(data:font/ttf;base64,BM)}
@font-face{font-family:Barlow;font-weight:600;src:url(data:font/ttf;base64,BS)}
@font-face{font-family:Barlow;font-weight:700;src:url(data:font/ttf;base64,BB)}
@font-face{font-family:Bebas;src:url(data:font/ttf;base64,BE)}
*{box-sizing:border-box;margin:0;padding:0}
html,body{width:1920px;height:1080px;overflow:hidden;background:#070605}
body{position:relative;font-family:Barlow,sans-serif;color:#f3ece2}
[title]{cursor:help}
.lab{position:absolute;font:600 17px Barlow;letter-spacing:2.2px;color:#d9cdbf;text-transform:uppercase;white-space:nowrap}
.ar{color:#a89c90;margin:0 2px}
.fcard{position:absolute;top:12px;width:500px;height:132px;border-radius:6px;background:#151313;border-left:6px solid;display:flex;align-items:center;gap:12px;padding:0 12px}
.fcard.b{justify-content:flex-end;text-align:right;border-left:none;border-right:6px solid #5b8fd6}
.face{width:92px;height:92px;border-radius:6px;object-fit:cover;flex:none;border:2px solid #3a3532}
.fi{display:flex;flex-direction:column;gap:1px}
.fn{font:400 32px/1 Bebas;letter-spacing:1px}
.fs{font:500 16px Barlow;color:#c9bfb3;white-space:nowrap}
.fr,.fr2{font:500 17px/21px Barlow;color:#d9cdbf;white-space:nowrap}.fr b{color:#ffffff}
.fr2{font-size:16px;color:#c9bfb3}
.centre{position:absolute;left:528px;top:12px;width:864px;height:132px;background:#121010;border-radius:6px}
.vw{position:absolute;left:20px;top:6px;font:400 72px/1 Bebas;letter-spacing:2px}
.vl{position:absolute;left:20px;top:84px;width:410px;font:600 17px/21px Barlow;color:#d9cdbf;white-space:nowrap}
.jg{position:absolute;left:432px;top:8px;display:grid;grid-template-columns:76px repeat(3,70px) 80px;gap:4px 8px;align-items:center}
.jh{font:600 16px/18px Barlow;color:#a89c90;text-align:center}
.jn{font:600 16px Barlow;color:#d9cdbf}
.jc{height:26px;border-radius:4px;display:flex;align-items:center;justify-content:center;font:400 22px/1 Bebas;padding-top:2px;background:#1a1716;border:2px solid #3a3532}
.jc.a{color:#f0a04b}.jc.b{color:#5b8fd6}
.jc.swing{border-color:#ffd84a;box-shadow:0 0 0 2px #ffd84a}
.jt{font:400 26px/1 Bebas;text-align:center;padding-top:2px}
.cause{position:absolute;top:178px;height:204px;background:#151313;border-radius:6px;border-top:3px solid #3a3532;padding:8px 14px}
.cause.best{border:2px solid #ffd84a;border-top-width:3px}
.besttag{position:absolute;right:12px;top:8px;padding:2px 8px;border-radius:3px;background:#ffd84a;color:#070605;font:700 16px Barlow}
.ctt{font:700 19px Barlow;white-space:nowrap}
.clost{font:400 26px/1.1 Bebas;color:#e0503c;margin-top:2px}
.cln{font:500 16px/20px Barlow;color:#c9bfb3;white-space:nowrap}
.meas{position:absolute;left:14px;bottom:50px;display:flex;align-items:center;gap:8px;font:500 16px Barlow;color:#c9bfb3;white-space:nowrap}
.meas b{font:400 24px/1 Bebas;color:#ffffff}.meas b.g{color:#6cc27a}
.mbar{display:inline-block;width:80px;height:10px;background:#221f1d}.mbar i{display:block;height:100%}
.luck{color:#a89c90;font-style:italic}
.btn{height:40px;padding:0 16px;display:inline-flex;align-items:center;border-radius:4px;font:700 18px Barlow;white-space:nowrap}
.cause .btn{position:absolute;left:14px;bottom:8px}
.btn.primary{background:#ffd84a;color:#070605;border:1px solid #ffd84a}
.btn.second{background:#2a2420;color:#f3ece2;border:1px solid #6a625c}
.btn.quiet{background:#1a1716;color:#d9cdbf;border:1px solid #4a423c;margin-left:auto;padding:0 36px}
.cpanel{position:absolute;top:178px;width:322px;height:204px;background:#151313;border-radius:6px;border-top:3px solid #3a3532;padding:8px 12px}
.chh,.chr{display:grid;grid-template-columns:170px 56px 1fr;gap:4px;align-items:baseline;white-space:nowrap}
.chh{font:600 16px/20px Barlow;color:#a89c90}
.chr{font:500 16px/24px Barlow;color:#d9cdbf}.chr b{font:400 22px/1 Bebas;color:#ffffff}
.chn{font:500 16px/19px Barlow;color:#c9bfb3;white-space:nowrap}
.sbg{position:absolute;left:16px;width:1888px;height:442px;background:#100e0d;border-radius:6px}
.key{position:absolute;right:16px;display:flex;align-items:center;gap:5px;font:500 16px Barlow;color:#c9bfb3;white-space:nowrap}
.kc{display:inline-flex;align-items:center;justify-content:center;width:22px;height:20px;border:2px solid;border-radius:3px;font:400 17px/1 Bebas;padding-top:2px}
.kd{display:inline-block;width:12px;height:12px;border-radius:50%}
.kr,.kc2{font:700 16px/18px Barlow;color:#070605;background:#c9bfb3;padding:0 4px;border-radius:2px}
.kn{font:700 18px/18px Barlow;color:#ffffff;background:#4a423c;padding:0 5px;border-radius:2px}
.kl{display:inline-block;width:16px;height:4px;margin:0 4px 3px 6px}
.gl{position:absolute;left:28px;width:230px;font:600 16px/18px Barlow;color:#d9cdbf;text-transform:uppercase;letter-spacing:1px}
.gl span{display:block;text-transform:none;letter-spacing:0;font-weight:500;color:#a89c90}
.gl2{position:absolute;left:28px;width:236px;font:500 16px/18px Barlow;color:#a89c90}
.lw{position:absolute;left:28px;width:232px;font:500 16px/16px Barlow;color:#a89c90;text-align:right;white-space:nowrap}
.rh{position:absolute;display:flex;align-items:baseline;gap:10px;height:22px;white-space:nowrap}
.rh b{font:400 24px/1 Bebas;letter-spacing:1px;color:#f3ece2}.rh span{font:600 17px Barlow;color:#d9cdbf}.rh em{margin-left:auto;font:500 16px Barlow;font-style:normal;color:#a89c90}
.run{position:absolute;height:36px;border-radius:4px;display:flex;align-items:center;justify-content:center;text-align:center;padding:0 4px;background:#2c2826}
.run span{font:600 16px/17px Barlow;color:#f3ece2}
.axis{position:absolute;height:1px;background:#3a3532}
.xb{position:absolute;width:44px;border-radius:2px}
.xl{position:absolute;text-align:center;font:400 19px/19px Bebas;padding-top:1px}
.pc{position:absolute;height:24px;padding:2px 5px 0;border:2px solid;border-radius:4px;display:flex;align-items:center;gap:2px;font:400 20px/1 Bebas;background:#0b0a0a}
.dash{position:absolute;width:14px;height:2px;background:#3a3532}
.sc{position:absolute;height:36px;border:2px solid;border-radius:4px;display:flex;align-items:center;justify-content:center;text-align:center;font:400 17px/16px Bebas;padding-top:2px;background:#0b0a0a;letter-spacing:.3px}
.cband{position:absolute;height:30px;border-radius:4px;background:#1a1716}
.cband span{position:absolute;left:8px;top:-1px;font:500 16px/18px Barlow;color:#c9bfb3;white-space:nowrap}
.cd{position:absolute;width:12px;height:6px;border-radius:2px}
.pl{position:absolute;height:9px;border-radius:2px;background:#221f1d}.pl.on{background:#d9cdbf}
.tg{position:absolute;display:flex;justify-content:center;gap:4px}
.hs{position:absolute}
.turn{position:absolute;border:3px solid #ffd84a;border-radius:6px;pointer-events:auto}
.turn span{position:absolute;left:0;bottom:2px;width:100%;text-align:center;font:400 17px/16px Bebas;color:#ffd84a}
.en{position:absolute;left:0;top:0;pointer-events:none}
.ee{position:absolute;font:400 20px/1 Bebas;white-space:nowrap;background:#100e0d;padding:0 3px;color:#a89c90}
.box{position:absolute;height:150px;background:#151313;border-radius:6px;border-top:3px solid #3a3532;padding:8px 14px}
.dl{font:500 17px/26px Barlow;color:#d9cdbf;white-space:nowrap}.dl b{color:#ffffff;font-weight:700}
.nr{display:flex;align-items:center;gap:8px;height:19px}
.nr.sub .nl{color:#a89c90}
.na,.nb{width:32px;font:400 20px/1 Bebas;padding-top:2px}.na{text-align:right}
.nbl,.nbr{width:100px;height:9px;background:#221f1d;display:flex}.nbl{justify-content:flex-end}.nbl i,.nbr i{display:block;height:100%}
.nl{width:150px;text-align:center;font:500 16px/1 Barlow;color:#d9cdbf;white-space:nowrap}
.ph,.pr{display:flex;align-items:center;height:21px;white-space:nowrap;font:500 16px Barlow;color:#d9cdbf}
.ph{color:#a89c90;font-weight:600}
.c1{width:520px;flex:none;display:flex;align-items:center;gap:8px}.c1 b{color:#ffffff;font-weight:600}
.c2{width:130px;flex:none;font-weight:600}.c3{display:flex;align-items:center;gap:5px}.c3 em{font-style:normal;color:#a89c90;margin-left:6px}
.lt{display:inline-flex;align-items:center;justify-content:center;width:22px;height:19px;border:2px solid;border-radius:3px;font:400 16px/1 Bebas;padding-top:2px}
.sq{display:inline-block;width:14px;height:14px;border-radius:2px}
.foot{position:absolute;left:16px;top:1030px;width:1888px;height:44px;display:flex;align-items:center;gap:12px}
.fl{font:500 17px Barlow;color:#c9bfb3}
"""


def page():
    css = CSS
    body = (fighter_card("a") + centre() + fighter_card("b") + causes() + strip() + damage() + numbers() + plan_table() + footer())
    full = css
    for k, f in (("BM", "Barlow-Medium"), ("BS", "Barlow-SemiBold"), ("BB", "Barlow-Bold"), ("BE", "BebasNeue-Regular")):
        full = full.replace("base64," + k + ")", "base64," + b64(ROOT / ("assets/fonts/%s.ttf" % f)) + ")")
    return (f'<!doctype html><html><head><meta charset="utf-8"><title>Fight result</title><style>{full}</style></head>'
            f'<body>{body}</body></html>'), css, body


doc, css, body = page()

# ---------------------------------------------------------------- build gates
for m in re.finditer(r"font:\s*(?:\d+\s+)?(\d+)px", css):
    assert int(m.group(1)) >= 16, ("text under 16 px in CSS", m.group(0))
for m in re.finditer(r"font-size:\s*(\d+)px", css + body):
    assert int(m.group(1)) >= 16, ("text under 16 px", m.group(0))
texts = re.findall(r">([^<]+)<", body) + re.findall(r'title="([^"]*)"', body)
alltext = html.unescape(" ".join(texts))
bad = re.findall(r"\b(he|she|her|him|his|hers|herself|himself)\b", alltext, re.I)
assert not bad, ("pronoun in page text", bad[:5])
code = re.findall(r"\b(?:[A-Z][a-z]+){2,}\.[a-z_]+|\b(?:RankLine|BoutMarks|FightStats|PadEdit|RingDuel|StandDown|PlanLines|FightWhy|BoutRules)\b|\bExchanges\.\w", alltext)
assert not code, ("code names in page text", code[:5])
# palette: every colour on the page is in the legend or the base greys
used = {c.lower() for c in re.findall(r"#[0-9a-fA-F]{6}\b", css + body)}
allowed = {c.lower() for c in LEGEND.values()} | {c.lower() for c in BASE}
assert used <= allowed, ("colour outside the legend", used - allowed)
assert len(LEGEND) == 6
# gold only in the primary button, the deciding judge cell, the turned exchange and the best-fix card
for rule in re.findall(r"([^{}]+)\{([^}]*)\}", css):
    if GOLD.lower() in rule[1].lower():
        assert any(s in rule[0] for s in (".primary", ".swing", ".turn", ".best")), ("gold outside primary/deciding", rule[0])
assert GOLD.lower() not in body.lower(), "gold in an inline style"
# our fighter never in the bad colour; the opponent's marks never in ours
for tag in re.findall(r"<[^>]+class=\"[^\"]*\bours\b[^\"]*\"[^>]*>", body):
    assert BAD.lower() not in tag.lower(), tag
for tag in re.findall(r"<[^>]+class=\"[^\"]*\btheirs\b[^\"]*\"[^>]*>", body):
    assert OURS.lower() not in tag.lower(), tag
# one primary action; every fix button once
assert len(re.findall(r'class="btn primary', body)) == 1, "exactly one primary"
fixes = re.findall(r'class="btn[^"]*fixbtn"[^>]*>([^<]+)<', body)
assert len(fixes) == len(set(fixes)) and fixes, fixes
assert not re.search(r"class=\"btn[^\"]*\"[^>]*>[^<]*[Ww]atch", body), "no watch button: that screen does not exist"

OUT.write_text(doc, encoding="utf-8")
print(OUT, OUT.stat().st_size)
