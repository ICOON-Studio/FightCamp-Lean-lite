"""S442 result page, round 3: drawn from a bout the game really played (bout.json, tools/result_dump.gd seed 44).
Every number and word on the page comes from bout.json or from a game word table it carries (quoted beside each use).
python docs/mockups/s442/result/build_result.py  ->  fight_result.html ; then python tools/render_mockup.py <that html>"""
import base64, html, io, json, pathlib, re
from PIL import Image

ROOT = pathlib.Path("E:/FightCamp/Lean")
HERE = pathlib.Path(__file__).parent
OUT = HERE / "fight_result.html"
D = json.loads((HERE / "bout.json").read_text(encoding="utf-8"))
W = D["words"]
E = html.escape


def b64(p):
    return base64.b64encode(pathlib.Path(p).read_bytes()).decode()


def img64(im):
    buf = io.BytesIO()
    im.save(buf, "PNG")
    return "data:image/png;base64," + base64.b64encode(buf.getvalue()).decode()


top = Image.open(ROOT / "docs/mockups/s439/result/top_today.png").convert("RGB")   # the game's own portraits (round 2 crop)
FACE = {"a": img64(top.crop((205, 113, 291, 199)).resize((124, 124), Image.LANCZOS)),
        "b": img64(top.crop((1629, 113, 1715, 199)).resize((124, 124), Image.LANCZOS))}

# ---------------------------------------------------------------- facts from the bout
F, O = D["fighter"], D["opponent"]
A, B = F["first"], O["first"]
ROUNDS = D["rounds"]
EXS = [x for r in ROUNDS for x in r["exchanges"]]
N_EX = len(EXS)
CALL_LABEL = {k: v["label"] for k, v in W["calls"].items()}          # Exchanges.CALLS label
MODE_LABEL = {k: v["label"] for k, v in W["modes"].items()}          # Exchanges.MODES label
EDGE_WORD = W["edge_word"]                                           # Exchanges.EDGE_WORD (the shout bar's fit words)
FIT_WORDS = W["fit_words"]                                           # PlanLines.FIT_WORDS (the Playbook's fit words)
RING = W["ring_place"]                                               # RingDuel.PLACE_WORD_CAP: At range / In the pocket / Inside
TIRED = W["she_tired"]                                               # Exchanges.SHE_TIRED, the tired line
PLAN = D["plan"]
LETTER = {p["move"]: p["letter"] for p in PLAN}
LINE = {p["letter"]: p for p in PLAN}
FW = D["fight_why"]
ST = D["fight_stats"]
CF = D["counterfactual"]
CARDS = D["cards"]
FLIP = D["flip_round"]


def judge_rows():
    """BoutRules.cards_of: two judges score every round to its winner; judge 3 flips the flip_round round."""
    rows = []
    for j in range(3):
        row = []
        for i, r in enumerate(ROUNDS):
            ours = r["won"] != (j == 2 and i == FLIP)
            row.append((10, 9) if ours else (9, 10))
        rows.append(row)
    return rows


JR = judge_rows()
for j, row in enumerate(JR):   # the grid must add up to the game's own cards
    assert "%d-%d" % (sum(a for a, _ in row), sum(b for _, b in row)) == CARDS[j], (row, CARDS[j])

# the opponent's game: runs never over 3 (Exchanges.MAX_RUN)
for r in ROUNDS:
    run, prev = 0, ""
    for x in r["exchanges"]:
        run = run + 1 if x["mode"] == prev else 1
        prev = x["mode"]
        assert run <= 3, ("opponent game run over 3", r["n"], x["i"])

# a plan line fires only on its own card, and a WHEN line only on its own situation
for x in EXS:
    if x["planned"]:
        ln = LINE[LETTER[x["arrow"]]]
        assert x["at"] == ln["place"], ("line fired off its card", x)
        assert ln["when"] in ("", x["sit"]), ("line fired off its situation", x)

# the fight moves at most one place an exchange (Duels.step), round to round too
places = [x["place"] for x in EXS]
assert all(abs(a - b) <= 1 for a, b in zip(places, places[1:])), places

# exchanges and punches: the grid's sums against FightStats' totals
xw = [sum(1 for x in EXS if x["won"]), sum(1 for x in EXS if not x["won"])]
assert xw == ST["xwon"], (xw, ST["xwon"])
landed = [sum(x["landed"][k] for x in EXS) for k in (0, 1)]
assert landed == ST["landed"], (landed, ST["landed"])
body = [sum(x["body"][k] for x in EXS) for k in (0, 1)]
assert body == ST["body"], (body, ST["body"])
for r, sr in zip(ROUNDS, ST["rounds"]):
    assert r["won_n"] == sr["xwon"][0] and r["landed"] == sr["landed"]


def plain(sit):
    return MODE_LABEL.get(sit, sit)


# ---------------------------------------------------------------- the causes: every lost exchange in exactly one
LOST = [(ri, x) for ri, r in enumerate(ROUNDS) for x in r["exchanges"] if not x["won"]]
hurt_after = [(ri, x) for ri, r in enumerate(ROUNDS) for x in r["exchanges"] if x["after"]["hurt"][0]]
by_sit = {}
for ri, x in LOST:
    by_sit.setdefault(x["sit"], []).append((ri, x))
loadup_all = [x for x in EXS if x["sit"] == "loadup"]
c_uses = [(ri, x) for ri, r in enumerate(ROUNDS) for x in r["exchanges"] if x["planned"] and LETTER[x["arrow"]] == "C"]
c_lost = [x for _, x in c_uses if not x["won"]]
assert all(x["sit"] == "counter" for x in c_lost) and len(c_lost) == len(by_sit.get("counter", [])), "every counter loss is a line C loss"
turned = -sum(min(0, x["plan_swing"]) for x in EXS)
assert turned == FW["cost"]
tank_cost = round(FW["pressure"]["tank"])
def crossed(side):
    """The first exchange fought under the tired line: the one after the exchange that left the tank under it."""
    for ri, r in enumerate(ROUNDS):
        for x in r["exchanges"]:
            if x["after"][side] < TIRED:
                return ri, x
    return None


cross_a, cross_b = crossed("a"), crossed("b")
first_tired = cross_a
end_a, end_b = EXS[-1]["after"]["a"], EXS[-1]["after"]["b"]


def rx(ri, x, after=0):
    return "R%d-%d" % (ri + 1, x["i"] + 1 + after)


closest = min(EXS, key=lambda x: abs(x["margin"]))
turned_x = [(ri, x) for ri, r in enumerate(ROUNDS) for x in r["exchanges"] if x["plan_swing"] < 0]
assert len(turned_x) == 1 and turned_x[0][1] is closest, "the exchange line C turned is the bout's closest"


ld = CF["loadup_name"]
CAUSES = [
    {"key": "loadup", "icon": "power", "lost": len(by_sit.get("loadup", [])), "of": len(loadup_all),
     "title": "%s loading up" % B, "num": "%d of %d lost" % (len(by_sit.get("loadup", [])), len(loadup_all)),
     "ev": "No line for it; Hands up won %d of %d" % (sum(1 for x in loadup_all if x["call"] == "hands" and x["won"]), sum(1 for x in loadup_all if x["call"] == "hands")),
     "hover": "%s's game was Loading up in %d exchanges (%s). %s won %d. The call for it, %s, has a %s against it and %s is %s at it (the shout bar's grade), "
              "yet it won %d of %d. The plan has no line for it: a line at mid range, %s, %s (the Playbook's top answer there)." % (
                  B, len(loadup_all), ", ".join(rx(ri, x) for ri, r in enumerate(ROUNDS) for x in r["exchanges"] if x["sit"] == "loadup"), A,
                  len(loadup_all) - len(by_sit.get("loadup", [])), CALL_LABEL["hands"], EDGE_WORD["best"].lower(), A, D["call_grades"]["hands"],
                  sum(1 for x in loadup_all if x["call"] == "hands" and x["won"]), sum(1 for x in loadup_all if x["call"] == "hands"), ld, FIT_WORDS[CF["loadup_fit"]].lower()),
     "btn": "Playbook: add %s" % ld, "btn_hover": "Opens the Playbook on a new line: when the opponent loads up, at mid range -> %s (%s)." % (ld, FIT_WORDS[CF["loadup_fit"]])},
    {"key": "linec", "icon": "plan", "lost": len(c_lost), "of": len(c_uses),
     "title": "Line C: %s" % FIT_WORDS[LINE["C"]["fit"]], "num": "%d of %d lost" % (len(c_lost), len(c_uses)),
     "ev": "Turned %d exchange; cost %d of the tank" % (turned, tank_cost),
     "hover": "Line C, when the opponent waits to counter, at long range: %s. It fired %d times (%s) and won %d. The game replays each exchange "
              "without the plan's edge: line C turned %d of them (%s, lost by the smallest margin of the bout). Wrong answers punished cost %s %d of the tank "
              "for the rest of the fight (the Why). The Playbook's top answer there: %s, %s." % (
                  LINE["C"]["move_name"], len(c_uses), ", ".join(rx(ri, x) for ri, x in c_uses), len(c_uses) - len(c_lost), turned, rx(*turned_x[0]), A, tank_cost,
                  CF["rewrite_name"], FIT_WORDS[CF["rewrite_fit"]].lower()),
     "btn": "Playbook: rewrite C", "btn_hover": "Opens the Playbook on line C: %s (%s) in place of %s." % (CF["rewrite_name"], FIT_WORDS[CF["rewrite_fit"]], LINE["C"]["move_name"])},
    {"key": "hurt", "icon": "star", "lost": len(by_sit.get("she_hurt", [])), "of": sum(1 for x in EXS if x["sit"] == "she_hurt"),
     "title": "Fought hurt", "num": "%d of %d lost" % (len(by_sit.get("she_hurt", [])), sum(1 for x in EXS if x["sit"] == "she_hurt")),
     "ev": "Hurt %d times: %d loaded, %d on line C, %d again" % (len(hurt_after), sum(1 for _, x in hurt_after if x["sit"] == "loadup"),
                                                             sum(1 for _, x in hurt_after if x["sit"] == "counter"), sum(1 for _, x in hurt_after if x["sit"] == "she_hurt")),
     "hover": "%s was left hurt after %s: twice by %s loading up, once by the counter that answered line C, once more while still hurt. "
              "Hurt, the corner's Tie up has a %s and %s is %s at it." % (A, ", ".join(rx(ri, x) for ri, x in hurt_after), B, EDGE_WORD["best"].lower(), A, D["call_grades"]["tie"]),
     "btn": "", "btn_hover": ""},
    {"key": "tired", "icon": "batt", "lost": len(by_sit.get("she_tired", [])), "of": sum(1 for x in EXS if x["sit"] == "she_tired"),
     "title": "Tired", "num": "%d of %d lost" % (len(by_sit.get("she_tired", [])), sum(1 for x in EXS if x["sit"] == "she_tired")),
     "ev": "Under %d from %s; last bell %d v %d" % (TIRED, rx(*cross_a, after=1), round(end_a), round(end_b)),
     "hover": "Under the tired line (%d) a fighter fights tired whatever the opponent does. %s fought under it from %s, %s from %s. "
              "Line C's wrong answers had already taken %d off %s's tank." % (TIRED, A, rx(*cross_a, after=1), B, rx(*cross_b, after=1), tank_cost, A),
     "btn": "Training: Cardio", "btn_hover": "Opens the Training tab with Cardio as next week's focus (Data.LABEL: conditioning reads Cardio)."},
]
CAUSES.sort(key=lambda c: -c["lost"])
assert sum(c["lost"] for c in CAUSES) == len(LOST) == ST["xwon"][1], "every lost exchange is in one cause"

# ---------------------------------------------------------------- colours, icons
RED, BLUE, GOLD, GREEN, AMBER, GREY = "#e0503c", "#4278e0", "#e9b84a", "#6cc27a", "#e8a33c", "#8a8079"
RT, BT = "#ff8a78", "#8fbcff"
FITC = {"best": GREEN, "ok": "#b9d36a", "none": GREY, "wrong": RED}
MODEC = {"counter": "#3b4f7a", "loadup": "#7a3b3b", "range": "#3b6a5a", "press": "#7a5a2b", "tiring": "#5a5a5a", "hurt": "#6a2b6a"}


def ic(name, c="#c9bfb3", s=20):
    p = {
        "power": '<path d="M11 1L4 11h5l-2 8 8-11h-5l3-7z" fill="{c}"/>',
        "plan": '<rect x="4" y="3" width="12" height="15" rx="2" fill="none" stroke="{c}" stroke-width="2"/><path d="M7 8h6M7 12h6" stroke="{c}" stroke-width="2" stroke-linecap="round"/>',
        "star": '<path d="M10 1l2 5 5-2-2 5 4 2-5 2 2 5-5-2-1 4-2-4-5 2 2-5-4-2 5-2-2-5 5 2z" fill="{c}"/>',
        "batt": '<rect x="2" y="6" width="14" height="9" rx="2" fill="none" stroke="{c}" stroke-width="2"/><path d="M18 9v3" stroke="{c}" stroke-width="2.4" stroke-linecap="round"/><rect x="4.5" y="8.5" width="4" height="4" fill="{c}"/>',
        "mega": '<path d="M2 8h4l9-5v14l-9-5H2z" fill="none" stroke="{c}" stroke-width="2" stroke-linejoin="round"/>',
        "tick": '<path d="M3 10.5l4.5 4.5L17 5" fill="none" stroke="{c}" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>',
        "cross": '<path d="M5 5l10 10M15 5L5 15" fill="none" stroke="{c}" stroke-width="3" stroke-linecap="round"/>',
        "play": '<circle cx="10" cy="10" r="8" fill="none" stroke="{c}" stroke-width="2"/><path d="M8 6.5v7l6-3.5z" fill="{c}"/>',
        "drill": '<path d="M3 10h4l2-5 3 10 2-5h3" fill="none" stroke="{c}" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/>',
        "habit": '<path d="M16 10H4M8 5l-5 5 5 5" fill="none" stroke="{c}" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"/>',
    }[name]
    return f'<svg width="{s}" height="{s}" viewBox="0 0 20 20">{p.format(c=c)}</svg>'


# ---------------------------------------------------------------- top band
def fighter_card(side):
    red = side == "a"
    p = F if red else O
    bf, af = D["before"], D["after"]
    rec0, rec1 = (bf["record"], af["record"]) if red else (bf["opp_record"], af["opp_record"])
    rk0, rk1 = (bf["rank"], af["rank"]) if red else (bf["opp_rank"], af["opp_rank"])

    def rank(r):
        return "No. %d" % r["now"] if r["now"] else "Unranked"
    rank_line = f'{rank(rk0)} <span class="ar">&#8594;</span> <b>{rank(rk1)}</b>'
    rank_hover = "Regional table (RankLine): " + (rk1["words"] if rk0["now"] == rk1["now"] else "%s Now: %s" % (rk0["words"], rk1["words"]))
    col, colt = (RED, RT) if red else (BLUE, BT)
    x = 16 if red else 1384
    face = f'<img class="face" src="{FACE[side]}" style="border-color:{col}">'
    info = (f'<div class="fi"><div class="fn">{E(p["name"]).upper()}</div>'
            f'<div class="fs" style="color:{colt}">{"RED" if red else "BLUE"} &middot; {E(p["stance"]).upper()} &middot; {E(p["style"]).upper()}</div>'
            f'<div class="fr"><span class="k">Record</span>{rec0[0]}-{rec0[1]} <span class="ar">&#8594;</span> <b>{rec1[0]}-{rec1[1]}</b></div>'
            f'<div class="fr" title="{E(rank_hover)}"><span class="k">Rank</span>{rank_line}</div></div>')
    inner = face + info if red else info + face
    return f'<div class="fcard {"r" if red else "b"}" style="left:{x}px">{inner}</div>'


def centre():
    lost = D["outcome"] == "loss"
    word = {"loss": "LOST", "win": "WON", "draw": "DRAW"}[D["outcome"]]
    split = len(set(CARDS)) > 1
    winner_cards = sum(1 for c in CARDS if (int(c.split("-")[0]) < int(c.split("-")[1])) == lost)
    how = "On points, %s" % ("split" if split else "unanimous")   # BoutHistory / PriorBouts: "points, split"
    counts = D["counts"]
    cnt = "No standing counts" if counts["a"] == 0 and counts["b"] == 0 else "Standing counts %d-%d" % (counts["a"], counts["b"])
    v = (f'<div class="verdict"><div class="vw" style="color:{RED if lost else GREEN}">{word}</div>'
         f'<div class="va">{how}</div><div class="vb">{winner_cards} judges to {3 - winner_cards} for <b style="color:{BT if lost else RT}">{E(O["first"] if lost else F["first"])}</b></div>'
         f'<div class="vb">{cnt}</div></div>')
    g = ['<div class="jg"><div></div>']
    for i in range(len(ROUNDS)):
        g.append(f'<div class="jh">R{i + 1}</div>')
    g.append('<div class="jh">TOTAL</div>')
    for j, row in enumerate(JR):
        g.append(f'<div class="jn">Judge {j + 1}</div>')
        for i, (a, b) in enumerate(row):
            mark = " swing" if (j == 2 and i == FLIP) else ""
            hv = ("The deciding cell: judge 3 alone gave round %d to %s. One more judge that way and %s won." % (i + 1, A, A)) if mark else ""
            g.append(f'<div class="jc {"r" if a > b else "b"}{mark}"{(" title=%s" % chr(34) + E(hv) + chr(34)) if hv else ""}>{a}-{b}</div>')
        t = CARDS[j]
        g.append(f'<div class="jt" style="color:{RT if int(t.split("-")[0]) > int(t.split("-")[1]) else BT}">{t}</div>')
    g.append('</div>')
    r2 = ROUNDS[FLIP]
    hv = ("Round %d: %d-%d in exchanges, %d-%d in punches landed. A level round goes to the bigger total margin (Exchanges.round_of): %s. "
          "Two judges scored it %s, judge 3 %s. Its first exchange, line C into a counter, was the closest of the bout." % (
              FLIP + 1, r2["won_n"], 6 - r2["won_n"], r2["landed"][0], r2["landed"][1], B, B, A))
    dec = (f'<div class="decided" title="{E(hv)}">&#9654; Round {FLIP + 1} decided it: {r2["won_n"]}-{6 - r2["won_n"]} in exchanges, '
           f'{r2["landed"][0]}-{r2["landed"][1]} in punches</div>')
    return f'<div class="centre">{v}{"".join(g)}{dec}</div>'


# ---------------------------------------------------------------- what decided it + what would have won it
TY = 180   # labels row of the second band


def causes():
    o = [f'<div class="lab" style="left:16px;top:{TY}px">What decided it &middot; exchanges lost, ranked</div>']
    x0, w, gap = 16, 316, 10
    for k, c in enumerate(CAUSES):
        x = x0 + k * (w + gap)
        btn = (f'<div class="fix" title="{E(c["btn_hover"])}">{E(c["btn"])}</div>' if c["btn"] else
               '<div class="nofix" title="No button of its own: the hurt came from the two causes before it.">Comes from 1 and 2</div>')
        o.append(f'<div class="cause" style="left:{x}px;width:{w}px" title="{E(c["hover"])}">'
                 f'<div class="crk">{k + 1}</div><div class="cic">{ic(c["icon"], GOLD, 24)}</div>'
                 f'<div class="ctt">{E(c["title"])}</div><div class="cnum">{c["lost"]}<span>of {c["of"]} lost</span></div>'
                 f'<div class="cev">{E(c["ev"])}</div>{btn}</div>')
    return "".join(o)


def would():
    n = CF["n"]
    wins = CF["wins"]
    rows = [("as_written", "The plan as written", GREY),
            ("rewrite_c", "Line C: %s" % E(CF["rewrite_name"]), GREEN),
            ("no_line_c", "No line C at all", "#b9d36a"),
            ("add_loadup_line", "New line: loads up &#8594; %s" % E(CF["loadup_name"]), "#b9d36a"),
            ("rewrite_c_and_loadup", "Both changes", GREEN)]
    o = [f'<div class="lab" style="left:1320px;top:{TY}px">What would have won it &middot; measured</div>'
         f'<div class="would" title="{E("Measured: the same opponent and corner on %d other fight nights, one bout each; only the plan changes (tools/result_dump.gd). Wins out of %d." % (n, n))}">']
    for k, label, col in rows:
        v = wins[k]
        o.append(f'<div class="wr"><div class="wl">{label}</div><div class="wbar"><i style="width:{v / n * 100:.1f}%;background:{col}"></i></div>'
                 f'<div class="wv"><b>{v}</b> of {n}</div></div>')
    sb = CF["same_bout"]
    hv = "Replayed with this night's dice: with line C rewritten it was a %s again (round 2 went 3-3 once more); with no line C at all %s improvised and won %s." % (
        sb["rewrite_c"]["outcome"], A, ", ".join(sb["no_line_c"]["cards"]))
    o.append(f'<div class="same" title="{E(hv)}">This bout without line C: {sb["no_line_c"]["outcome"].upper()} {", ".join(sb["no_line_c"]["cards"])}</div></div>')
    assert sb["as_written"]["outcome"] == D["outcome"] and sb["as_written"]["cards"] == CARDS, "the replay reproduces the bout"
    return "".join(o)


# ---------------------------------------------------------------- the 18-exchange grid
GX = 186                    # first cell left
CW, RG = 92, 14             # cell width, gap between rounds
GT = 352                    # grid label row; the panel starts 22 below
Y_HEAD, Y_GAME, Y_MID, Y_PLAN, Y_CALL, Y_CNAME, Y_EV, Y_PLACE, Y_EN, EN_H = 382, 408, 496, 556, 590, 618, 640, 666, 726, 92


def cx(k):
    return GX + k * CW + (k // 6) * RG


def grid():
    legend = "".join(f'<i style="background:{FITC[k]}"></i>{E(EDGE_WORD[k])}' for k in ("best", "ok", "none", "wrong"))
    o = [f'<div class="lab" style="left:16px;top:{GT}px">The fight &middot; 18 exchanges of 30 seconds</div>',
         f'<div class="leg" style="top:{GT - 2}px" title="Fit of a call or a plan line to the moment (the shout bar\'s words, Exchanges.EDGE_WORD). Square fill: red won, blue lost.">Fit: {legend}</div>']
    labels = [(Y_GAME + 4, "%s's game" % B, "Exchanges.MODES: the game the opponent fought each 30 seconds. One game is kept at most 3 exchanges in a row."),
              (Y_MID - 10, "Who won it", "Up = %s, down = %s; taller = won by more. The numbers are punches landed in that exchange, winner first (4-3 close, 5-2 clear, 6-1 dominant)." % (A, B)),
              (Y_PLAN + 2, "Plan line", "The plan line that fired: its letter, its fit, and whether that exchange was won. A dot: no line for that moment, so the fighter improvised."),
              (Y_CALL + 2, "Corner call", "A dot: the round's call (it stands for every exchange), coloured by its fit to that moment. A megaphone: your shout for that exchange."),
              (Y_EV + 1, "Hurt / habit", "A star: %s left hurt after that exchange. An arrow: a habit of %s's punished (it costs an edge, won or lost)." % (A, A)),
              (Y_EN + 8, "Energy", "Energy 0-100 after each exchange, as the fight display shows it; the rest between rounds gives some back. Under the dashed line (%d) a fighter is tired." % TIRED)]
    for y, lab, hv in labels:
        o.append(f'<div class="gl" style="top:{y}px" title="{E(hv)}">{E(lab)}</div>')
    for ri, r in enumerate(ROUNDS):
        x = cx(ri * 6)
        jw = [JR[j][ri][0] > JR[j][ri][1] for j in range(3)]
        jt = "all 3 judges %s" % (A if jw[0] else B) if len(set(jw)) == 1 else "2 judges %s, judge 3 %s" % (A if jw[0] else B, B if jw[0] else A)
        o.append(f'<div class="rh" style="left:{x}px;top:{Y_HEAD}px;width:{CW * 6 - 4}px"><b style="color:{RT if r["won"] else BT}">ROUND {ri + 1}</b>'
                 f'<span>{A} {r["won_n"]}-{6 - r["won_n"]}</span><em>{jt}</em></div>')
        o.append(f'<div class="cband" style="left:{x}px;top:{Y_CALL - 4}px;width:{CW * 6 - 4}px"></div>')
        o.append(f'<div class="axis" style="left:{x}px;top:{Y_MID}px;width:{CW * 6 - 4}px"></div>')
        txt = "Corner: %s" % CALL_LABEL[r["corner"]] if r["corner"] else "Corner: no call in round 1"
        o.append(f'<div class="cn" style="left:{x}px;top:{Y_CNAME}px;width:{CW * 6 - 4}px">{E(txt)}</div>')
    for ri, r in enumerate(ROUNDS):   # the opponent's game, run by run (never over 3)
        xs = r["exchanges"]
        i = 0
        while i < 6:
            j = i
            while j + 1 < 6 and xs[j + 1]["mode"] == xs[i]["mode"]:
                j += 1
            o.append(f'<div class="run" style="left:{cx(ri * 6 + i)}px;top:{Y_GAME}px;width:{(j - i + 1) * CW - 4}px;background:{MODEC[xs[i]["mode"]]}">'
                     f'<span>{E(MODE_LABEL[xs[i]["mode"]])}</span></div>')
            i = j + 1
    for ri, r in enumerate(ROUNDS):
        for x in r["exchanges"]:
            left = cx(ri * 6 + x["i"])
            won = x["won"]
            h = min(26.0, abs(x["margin"]) * 0.6) + 6
            top = Y_MID - h if won else Y_MID
            lan = "%d-%d" % ((x["landed"][0], x["landed"][1]) if won else (x["landed"][1], x["landed"][0]))
            bar_hv = "Round %d, exchange %d: %s won it. Punches landed %d-%d, to the body %d-%d (%s first)." % (
                ri + 1, x["i"] + 1, A if won else B, x["landed"][0], x["landed"][1], x["body"][0], x["body"][1], A)
            o.append(f'<div class="xb" style="left:{left + 20}px;top:{top:.0f}px;height:{h:.0f}px;background:{RED if won else BLUE}" title="{E(bar_hv)}"></div>')
            ly = (top - 20) if won else (top + h + 1)
            o.append(f'<div class="xl" style="left:{left}px;top:{ly:.0f}px;width:{CW - 4}px;color:{RT if won else BT}">{lan}</div>')
            if x["planned"]:
                lt = LETTER[x["arrow"]]
                fc = FITC[x["arrow_fit"]]
                hv = "Line %s fired: %s, %s: %s. %s. %s." % (lt, LINE[lt]["place_words"], ("when " + LINE[lt]["when_words"]) if LINE[lt]["when"] else "any time",
                                                          LINE[lt]["move_name"], FIT_WORDS[x["arrow_fit"]] or "No fit either way", "Won" if won else "Lost")
                if x["plan_swing"] < 0:
                    hv += " Replayed without the plan's edge, this exchange goes the other way: line C turned it."
                ring = ";box-shadow:0 0 0 3px #e9b84a" if x["plan_swing"] else ""
                o.append(f'<div class="pc" style="left:{left + 20}px;top:{Y_PLAN}px;border-color:{fc};color:{fc}{ring}" title="{E(hv)}">{lt}{ic("tick" if won else "cross", fc, 16)}</div>')
            else:
                o.append(f'<div class="dot" style="left:{left + 40}px;top:{Y_PLAN + 10}px"></div>')
            fc = FITC[x["fit"]]
            word = EDGE_WORD[x["fit"]]
            hv = "%s %s: %s for %s. %s." % ("Your shout" if x["shout"] else "The round's call", CALL_LABEL.get(x["call"], "none"), word, plain(x["sit"]), "Won" if won else "Lost")
            if x["shout"]:
                o.append(f'<div class="sc" style="left:{left + 2}px;top:{Y_CALL}px;border-color:{fc}" title="{E(hv)}">{ic("mega", fc, 16)}<span style="color:{fc}">{E(word)}</span></div>')
            elif x["call"]:
                o.append(f'<div class="cd" style="left:{left + 36}px;top:{Y_CALL + 5}px;background:{fc}" title="{E(hv)}"></div>')
            else:
                o.append(f'<div class="dot" style="left:{left + 40}px;top:{Y_CALL + 10}px" title="No call: round 1 is fought on the plan alone."></div>')
            ev = []
            if x["after"]["hurt"][0]:
                ev.append(f'<span title="{E("%s left hurt after this exchange." % A)}">{ic("star", AMBER, 20)}</span>')
            if x["habit"] and x["habit"] != x["fix"]:
                ev.append(f'<span title="{E("Habit punished: %s. It cost an edge; the exchange was %s." % (x["habit"].replace("_", " "), "still won" if won else "lost"))}">{ic("habit", "#c9a0ff", 20)}</span>')
            if x["pinned"]:
                ev.append('<span title="On the ropes">ROPES</span>')
            o.append(f'<div class="ev" style="left:{left}px;top:{Y_EV}px;width:{CW - 4}px">{"".join(ev)}</div>')
            for p in range(3):
                on = p == x["place"]
                o.append(f'<div class="pl{" on" if on else ""}" style="left:{left + 6}px;top:{Y_PLACE + 4 + p * 17}px;width:{CW - 16}px"></div>')
    for p in range(3):
        o.append(f'<div class="pw" style="top:{Y_PLACE + p * 17}px" title="Where each exchange was fought (RingDuel): the gold bar.">{E(RING[p])}</div>')
    o.append(energy())
    return "".join(o)


def energy():
    y0, h = Y_EN, EN_H

    def Y(v):
        return y0 + h - v / 100 * h
    pts = {"a": [], "b": []}
    for ri, r in enumerate(ROUNDS):
        for side in "ab":
            seg = [(cx(ri * 6) + 2, Y(r["start"][side]))]
            for xx in r["exchanges"]:
                seg.append((cx(ri * 6 + xx["i"]) + CW - 6, Y(xx["after"][side])))
            pts[side].append(seg)
    o = ['<svg class="en" width="1920" height="1080">']
    for v in (0, 50, 100):
        o.append(f'<line x1="{GX}" x2="{cx(17) + CW}" y1="{Y(v):.1f}" y2="{Y(v):.1f}" stroke="#2c2826" stroke-width="1"/>')
    o.append(f'<line x1="{GX}" x2="{cx(17) + CW}" y1="{Y(TIRED):.1f}" y2="{Y(TIRED):.1f}" stroke="{GOLD}" stroke-width="2" stroke-dasharray="7 6"/>')
    for side, col in (("b", BLUE), ("a", RED)):
        for seg in pts[side]:
            o.append('<polyline fill="none" stroke="%s" stroke-width="4" stroke-linejoin="round" points="%s"/>' % (col, " ".join("%.1f,%.1f" % p for p in seg)))
    ri, x = first_tired
    k = ri * 6 + x["i"]
    v = x["after"]["a"]
    o.append(f'<circle cx="{cx(k) + CW - 6}" cy="{Y(v):.1f}" r="7" fill="none" stroke="{GOLD}" stroke-width="3"/></svg>')
    o.append(f'<div class="ey" style="top:{Y(100) - 9:.0f}px">100</div><div class="ey" style="top:{Y(0) - 12:.0f}px">0</div>')
    o.append(f'<div class="tl" style="left:{cx(6)}px;top:{Y(TIRED) + 2:.0f}px">{int(TIRED)} = tired</div>')
    o.append(f'<div class="tl" style="left:{cx(k) - 182}px;top:{Y(v) + 4:.0f}px">{E(A)} tired from {rx(*first_tired, after=1)}</div>')
    for ri, r in enumerate(ROUNDS):
        last = r["exchanges"][-1]["after"]
        top = min(Y(last["a"]), Y(last["b"])) - 24
        o.append(f'<div class="ee" style="left:{cx(ri * 6 + 5) + CW - 64}px;top:{top:.0f}px" title="Energy at the bell of round {ri + 1}">'
                 f'<b style="color:{RT}">{round(last["a"])}</b> <b style="color:{BT}">{round(last["b"])}</b></div>')
    o.append(f'<div class="ek" style="top:{y0 + 34}px"><i style="background:{RED}"></i>{E(A)}</div><div class="ek" style="top:{y0 + 56}px"><i style="background:{BLUE}"></i>{E(B)}</div>')
    return "".join(o)


# ---------------------------------------------------------------- bottom row
BY = 834


def damage():
    bands = W["bands"]
    o = [f'<div class="lab" style="left:16px;top:{BY}px">Damage &middot; what it costs</div><div class="box" style="left:16px;top:{BY + 24}px;width:440px">']
    places = D["body_map"]["a"]["places"]
    below = sorted([(p, v) for p, v in places.items() if v <= bands["hurt"]], key=lambda t: t[1])
    if below:
        for p, v in below:
            o.append(f'<div class="dl"><span>{E(p.replace("_", " ").capitalize())}</span><b>{round(v)}</b></div>')
    else:
        low = min(places.items(), key=lambda t: t[1])
        o.append(f'<div class="dbig" title="{E("Body map at the last bell (BoutMarks): fine over %d, hurt to %d, critical to %d. Lowest place: %s %d." % (bands["hurt"], bands["critical"], bands["doctor"], low[0].replace("_", " "), round(low[1])))}">'
                 f'{ic("tick", GREEN, 22)}No place went below fine</div>')
    inj = D["injury"] or "None"
    o.append(f'<div class="dr"><span class="k">Injury roll</span><b>{E(inj)}</b><em>full training</em></div>')
    sd = D["stand_down_words"]
    if sd:
        head, why = sd.split(": ", 1) if ": " in sd else (sd, "")
        hv = "StandDown, the game's line: %s. The head damage the bout left decides how long sparring is locked (5, 10 or 21 days); pads, bag and runs go on." % sd
        o.append(f'<div class="dr" title="{E(hv)}"><span class="k">Sparring</span><b>{E(head[0].upper() + head[1:])}</b></div>')
        if why:
            o.append(f'<div class="dr" title="{E(hv)}"><span class="k">Why</span><b>{E(why[0].upper() + why[1:])}</b></div>')
    o.append('</div>')
    return "".join(o)


def punches():
    def won_at(p):
        return [sum(1 for x in EXS if x["place"] == p and x["won"]), sum(1 for x in EXS if x["place"] == p and not x["won"])]
    hurt = [sum(1 for x in EXS if x["after"]["hurt"][1]), sum(1 for x in EXS if x["after"]["hurt"][0])]
    rows = [("Exchanges won", ST["xwon"]), ("Punches landed", ST["landed"]), ("To the head", ST["head"]), ("To the body", ST["body"]),
            ("Won %s" % RING[0].lower(), won_at(0)), ("Won %s" % RING[1].lower(), won_at(1)), ("Won %s" % RING[2].lower(), won_at(2)),
            ("Left the other hurt", hurt)]
    assert len(rows) <= 8
    assert sum(won_at(p)[0] for p in range(3)) == ST["xwon"][0] and sum(won_at(p)[1] for p in range(3)) == ST["xwon"][1]
    assert ST["head"][0] + ST["body"][0] == ST["landed"][0] and ST["head"][1] + ST["body"][1] == ST["landed"][1]
    o = [f'<div class="lab" style="left:468px;top:{BY}px">The numbers &middot; {E(A)} v {E(B)}</div><div class="box" style="left:468px;top:{BY + 24}px;width:500px" title="Each row: both bars on one scale, the longer side in gold. From the exchange records (FightStats).">']
    for lab, (a, b) in rows:
        top = max(1, a, b)
        o.append(f'<div class="nr"><b class="na" style="color:{GOLD if a > b else "#e8ddd0"}">{a}</b>'
                 f'<span class="nbl"><i style="width:{a / top * 100:.0f}%;background:{RED}"></i></span><span class="nl">{E(lab)}</span>'
                 f'<span class="nbr"><i style="width:{b / top * 100:.0f}%;background:{BLUE}"></i></span><b class="nb" style="color:{GOLD if b > a else "#e8ddd0"}">{b}</b></div>')
    o.append('</div>')
    return "".join(o)


def plan_corner():
    o = [f'<div class="lab" style="left:980px;top:{BY}px">The plan and the corner &middot; fit and result</div><div class="box" style="left:980px;top:{BY + 24}px;width:924px">']
    for p in PLAN:
        uses = [(ri, x) for ri, r in enumerate(ROUNDS) for x in r["exchanges"] if x["planned"] and LETTER[x["arrow"]] == p["letter"]]
        fc = FITC[p["fit"]]
        sq = "".join(f'<i class="sq" style="background:{RED if x["won"] else BLUE}" title="{rx(ri, x)}: {"won" if x["won"] else "lost"}"></i>' for ri, x in uses)
        when = ("when " + p["when_words"]) if p["when"] else "any time"
        never = ("won %d of %d" % (sum(1 for _, x in uses if x["won"]), len(uses))) if uses else ("%s never %s" % (B, {"press": "pressed"}.get(p["when"], "showed it")))
        o.append(f'<div class="pr" title="{E("%s, %s: %s. Rated against %s." % (p["place_words"], when, p["move_name"], plain(p["rated_against"]).lower()))}">'
                 f'<span class="lt" style="border-color:{fc};color:{fc}">{p["letter"]}</span><span class="pw2">{E(p["place_words"])}, {E(when)} &#8594; <b>{E(p["move_name"])}</b></span>'
                 f'<span class="fw" style="color:{fc}">{E(FIT_WORDS[p["fit"]] or "No fit")}</span>{('<span class="sqs">' + sq + '</span>') if uses else ''}<span class="nv">{E(never)}</span></div>')
    # corner calls by round, graded per exchange by fit and result
    for ri, r in enumerate(ROUNDS):
        if not r["corner"]:
            continue
        st = [x for x in r["exchanges"] if not x["shout"]]
        fit_n = sum(1 for x in st if x["fit"] in ("best", "ok"))
        won_n = sum(1 for x in st if x["won"])
        o.append(f'<div class="pr"><span class="lt c">{ic("mega", "#c9bfb3", 16)}</span><span class="pw2">R{ri + 1} call <b>{E(CALL_LABEL[r["corner"]])}</b></span>'
                 f'<span class="fw">fit {fit_n} of {len(st)}</span><span class="sqs">' +
                 "".join(f'<i class="sq" style="background:{RED if x["won"] else BLUE};outline:2px solid {FITC[x["fit"]]}" title="R{ri + 1}-{x["i"] + 1}: {EDGE_WORD[x["fit"]]}, {"won" if x["won"] else "lost"}"></i>' for x in st) +
                 f'</span><span class="nv">won {won_n}</span></div>')
    sh = [x for x in EXS if x["shout"]]
    o.append(f'<div class="pr"><span class="lt c">{ic("mega", "#c9bfb3", 16)}</span><span class="pw2">Your shouts</span>'
             f'<span class="fw" style="color:{GREEN}">{EDGE_WORD["best"]} {sum(1 for x in sh if x["fit"] == "best")} of {len(sh)}</span><span class="sqs">' +
             "".join(f'<i class="sq" style="background:{RED if x["won"] else BLUE}"></i>' for x in sh) + f'</span><span class="nv">won {sum(1 for x in sh if x["won"])}</span></div>')
    # the clash the records show: the round's call standing while line C fired into the counter
    clash = [(ri, x) for ri, x in c_uses if not x["shout"] and x["call"] and x["fit"] == "none"]
    if clash:
        cl = "; ".join("%s %s + line C" % (rx(ri, x), CALL_LABEL[x["call"]]) for ri, x in clash)
        hv = ("The round's call was chosen from the end of the round before; the next round opened with %s waiting to counter. "
              "The call had no edge there and line C threw %s into the counter: %s." % (B, LINE["C"]["move_name"], ", ".join("%s %s" % (rx(ri, x), "won" if x["won"] else "lost") for ri, x in clash)))
        o.append(f'<div class="clash" title="{E(hv)}">Clash: {E(cl)}, both lost</div>' if all(not x["won"] for _, x in clash) else
                 f'<div class="clash" title="{E(hv)}">Clash: {E(cl)}</div>')
    o.append('</div>')
    return "".join(o)


def footer():
    btns = [c for c in CAUSES if c["btn"]]
    o = ['<div class="foot"><span class="fl">Fixes</span>']
    for c in btns:
        o.append(f'<div class="btn" title="{E(c["btn_hover"])}">{E(c["btn"])}</div>')
    o.append(f'<div class="btn" title="{E("Training tab, pad nights: puts %s on the next pad night (PadEdit.drill_it). Undrilled, a plan line throws it at 80%%." % CF["rewrite_name"])}">{ic("drill", "#f0e3cf", 18)}Drill it: {E(CF["rewrite_name"])}</div>')
    o.append('<div class="btn go">Continue &#9654;</div></div>')
    return "".join(o)


CSS = """
@font-face{font-family:Barlow;font-weight:500;src:url(data:font/ttf;base64,BM)}
@font-face{font-family:Barlow;font-weight:600;src:url(data:font/ttf;base64,BS)}
@font-face{font-family:Barlow;font-weight:700;src:url(data:font/ttf;base64,BB)}
@font-face{font-family:Bebas;src:url(data:font/ttf;base64,BE)}
*{box-sizing:border-box;margin:0;padding:0}
html,body{width:1920px;height:1080px;overflow:hidden;background:#070605}
body{position:relative;font-family:Barlow,sans-serif;color:#f3ece2}
[title]{cursor:help}
.lab{position:absolute;font:600 17px Barlow;letter-spacing:2.4px;color:#e9b84a;text-transform:uppercase;white-space:nowrap}
.fcard{position:absolute;top:12px;width:520px;height:158px;border-radius:6px;display:flex;align-items:center;gap:18px;padding:0 20px}
.fcard.r{background:linear-gradient(160deg,#3a1410,#160a08);border-bottom:4px solid #e0503c}
.fcard.b{background:linear-gradient(200deg,#122347,#0a0f1c);border-bottom:4px solid #4278e0;justify-content:flex-end;text-align:right}
.face{width:116px;height:116px;border-radius:8px;border:3px solid;object-fit:cover;flex:none}
.fi{display:flex;flex-direction:column;gap:4px}
.fn{font:400 40px/1 Bebas;letter-spacing:1px}
.fs{font:600 16px Barlow;letter-spacing:1.6px}
.fr{font:500 20px Barlow;color:#d9cdbf;white-space:nowrap}
.fr .k{display:inline-block;width:76px;font:600 16px Barlow;letter-spacing:1.6px;color:#a89c90;text-transform:uppercase}
.fcard.b .fr .k{width:auto;margin-right:12px}
.fr b{color:#fff}.ar{color:#e9b84a}
.centre{position:absolute;left:548px;top:12px;width:824px;height:158px;background:#121010;border-radius:6px;border-top:3px solid #3a3532}
.verdict{position:absolute;left:20px;top:8px;width:300px}
.vw{font:400 76px/0.92 Bebas;letter-spacing:2px}
.va{font:400 28px/1 Bebas;letter-spacing:1px;color:#e9b84a;margin-top:2px}
.vb{font:500 17px/22px Barlow;color:#d9cdbf;white-space:nowrap}
.jg{position:absolute;left:316px;top:8px;display:grid;grid-template-columns:84px repeat(3,74px) 92px;gap:4px 8px;align-items:center}
.jh{font:600 16px/18px Barlow;letter-spacing:1.6px;color:#a89c90;text-align:center}
.jn{font:600 17px Barlow;color:#d9cdbf}
.jc{height:26px;border-radius:4px;display:flex;align-items:center;justify-content:center;font:400 23px/1 Bebas;padding-top:2px}
.jc.r{background:#5e2018;border:2px solid #e0503c}.jc.b{background:#1b3360;border:2px solid #4278e0}
.jc.swing{box-shadow:0 0 0 3px #e9b84a}
.jt{font:400 26px/1 Bebas;text-align:center;padding-top:2px}
.decided{position:absolute;left:316px;top:128px;font:600 17px Barlow;color:#e9b84a;white-space:nowrap}
.cause{position:absolute;top:202px;height:140px;background:#151313;border-radius:6px;border-top:3px solid #e9b84a;padding:8px 14px}
.crk{position:absolute;right:12px;top:4px;font:400 32px/1 Bebas;color:#5a514a}
.cic{position:absolute;left:14px;top:9px}
.ctt{margin-left:34px;font:700 19px Barlow;white-space:nowrap}
.cnum{margin-top:2px;font:400 40px/1 Bebas;color:#ff8a78;display:flex;align-items:baseline;gap:8px}
.cnum span{font:500 18px Barlow;color:#c9bfb3}
.cev{font:500 16px Barlow;color:#c9bfb3;white-space:nowrap}
.fix,.nofix{position:absolute;left:14px;bottom:9px;height:32px;padding:0 12px;display:flex;align-items:center;border-radius:4px;font:700 17px Barlow;white-space:nowrap}
.fix{background:linear-gradient(#7a5a2a,#5a3f1c);border:1px solid #c79a4a;color:#ffe9c2}
.nofix{color:#8a8079;font-weight:500;padding:0}
.would{position:absolute;left:1320px;top:202px;width:584px;height:140px;background:#151313;border-radius:6px;border-top:3px solid #6cc27a;padding:8px 14px}
.wr{display:flex;align-items:center;gap:10px;height:21px}
.wl{width:262px;font:600 16px Barlow;color:#e8ddd0;white-space:nowrap}
.wbar{flex:1;height:12px;background:#2a2624;border-radius:3px;overflow:hidden}.wbar i{display:block;height:100%}
.wv{width:84px;font:500 16px Barlow;color:#a89c90;text-align:right;white-space:nowrap}.wv b{font:400 22px/1 Bebas;color:#fff}
.same{margin-top:6px;font:600 17px Barlow;color:#e9b84a;white-space:nowrap}
.gridbg{position:absolute;left:16px;top:374px;width:1888px;height:452px;background:#100e0d;border-radius:6px}
.leg{position:absolute;right:28px;display:flex;align-items:center;gap:8px;font:500 16px Barlow;color:#c9bfb3;white-space:nowrap}
.leg i{display:inline-block;width:14px;height:14px;border-radius:50%;margin-left:10px}
.gl{position:absolute;left:28px;font:600 16px Barlow;letter-spacing:1.2px;color:#a89c90;text-transform:uppercase;white-space:nowrap}
.rh{position:absolute;display:flex;align-items:baseline;gap:10px;height:22px;white-space:nowrap}
.rh b{font:400 24px/1 Bebas;letter-spacing:1px}.rh span{font:600 17px Barlow}.rh em{margin-left:auto;font:500 16px Barlow;font-style:normal;color:#a89c90}
.run{position:absolute;height:38px;border-radius:4px;display:flex;align-items:center;justify-content:center;text-align:center;padding:0 4px}
.run span{font:600 16px/17px Barlow;color:#f3ece2}
.axis{position:absolute;height:1px;background:#3a3532}
.xb{position:absolute;width:48px;border-radius:2px}
.xl{position:absolute;text-align:center;font:400 19px/19px Bebas;padding-top:1px}
.pc{position:absolute;height:24px;padding:2px 6px 0;border:2px solid;border-radius:4px;display:flex;align-items:center;gap:2px;font:400 20px/1 Bebas;background:#0b0a0a}
.dot{position:absolute;width:6px;height:6px;border-radius:50%;background:#4a423c}
.sc{position:absolute;height:24px;padding:0 4px;border:2px solid;border-radius:4px;display:flex;align-items:center;gap:3px;font:600 16px Barlow;background:#0b0a0a;white-space:nowrap}
.cd{position:absolute;width:14px;height:14px;border-radius:50%}
.cband{position:absolute;height:32px;border-radius:4px;background:#1a1716}
.cn{position:absolute;font:500 16px Barlow;color:#c9bfb3;text-align:center;white-space:nowrap}
.ev{position:absolute;height:22px;display:flex;justify-content:center;gap:4px}
.pl{position:absolute;height:9px;border-radius:2px;background:#221f1d}.pl.on{background:#e9b84a}
.pw{position:absolute;left:28px;width:146px;font:500 16px/17px Barlow;color:#8a8079;text-align:left;white-space:nowrap}
.en{position:absolute;left:0;top:0;pointer-events:none}
.ey{position:absolute;left:140px;width:36px;text-align:right;font:500 16px/18px Barlow;color:#6a625c}
.tl{position:absolute;font:600 16px Barlow;color:#e9b84a;white-space:nowrap}
.ee{position:absolute;font:400 22px/1 Bebas;white-space:nowrap;background:#100e0d;padding:0 3px}
.ek{position:absolute;left:28px;display:flex;align-items:center;gap:6px;font:500 16px Barlow;color:#c9bfb3}.ek i{display:inline-block;width:16px;height:4px}
.box{position:absolute;height:162px;background:#151313;border-radius:6px;border-top:3px solid #3a3532;padding:8px 16px}
.dbig{display:flex;align-items:center;gap:8px;font:700 22px Barlow;color:#6cc27a;height:36px}
.dl{display:flex;justify-content:space-between;font:600 19px Barlow}
.dr{display:flex;align-items:baseline;gap:10px;margin-top:8px;font:500 18px Barlow;color:#d9cdbf;white-space:nowrap}
.dr .k{width:110px;flex:none;font:600 16px Barlow;letter-spacing:1.4px;color:#a89c90;text-transform:uppercase}
.dr b{color:#fff;font-weight:600}.dr em{font-style:normal;color:#6cc27a;font:600 16px Barlow}
.nr{display:flex;align-items:center;gap:8px;height:18px}
.na,.nb{width:32px;font:400 21px/1 Bebas;padding-top:2px}.na{text-align:right}
.nbl,.nbr{width:100px;height:10px;background:#221f1d;display:flex}.nbl{justify-content:flex-end}.nbl i,.nbr i{display:block;height:100%}
.nl{width:176px;text-align:center;font:500 16px/1 Barlow;color:#d9cdbf;white-space:nowrap}
.pr{display:flex;align-items:center;gap:10px;height:20px;white-space:nowrap}
.lt{width:26px;height:20px;border:2px solid;border-radius:4px;display:flex;align-items:center;justify-content:center;font:400 18px/1 Bebas;padding-top:2px;flex:none}
.lt.c{border-color:#4a423c}
.pw2{width:500px;flex:none;font:500 16px Barlow;color:#d9cdbf}.pw2 b{color:#fff;font-weight:600}
.fw{width:130px;flex:none;font:600 16px Barlow;color:#c9bfb3}
.sqs{display:flex;gap:5px;width:114px;flex:none}
.sq{display:inline-block;width:14px;height:14px;border-radius:2px}
.nv{font:500 16px Barlow;color:#a89c90}
.clash{margin-top:2px;font:600 16px Barlow;color:#ff8a78;white-space:nowrap}
.foot{position:absolute;left:16px;top:1028px;width:1888px;height:46px;display:flex;align-items:center;gap:12px}
.fl{font:600 17px Barlow;letter-spacing:2.4px;color:#e9b84a;text-transform:uppercase;margin-right:4px}
.btn{height:42px;padding:0 16px;display:flex;align-items:center;gap:8px;border-radius:4px;font:700 18px Barlow;color:#ffe9c2;background:linear-gradient(#7a5a2a,#5a3f1c);border:1px solid #c79a4a;white-space:nowrap}
.btn.go{margin-left:auto;background:linear-gradient(#c3322c,#95221d);border-color:#e0675c;color:#fff;font-size:24px;padding:0 44px}
"""


def page():
    css = CSS
    for k, f in (("BM", "Barlow-Medium"), ("BS", "Barlow-SemiBold"), ("BB", "Barlow-Bold"), ("BE", "BebasNeue-Regular")):
        css = css.replace("base64," + k + ")", "base64," + b64(ROOT / ("assets/fonts/%s.ttf" % f)) + ")")
    body = (fighter_card("a") + centre() + fighter_card("b") + causes() + would() + '<div class="gridbg"></div>' + grid()
            + damage() + punches() + plan_corner() + footer())
    return (f'<!doctype html><html><head><meta charset="utf-8"><title>Fight result</title><style>{css}</style></head>'
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

OUT.write_text(doc, encoding="utf-8")
print(OUT, OUT.stat().st_size)
