"""S442 loop drawings: corner_cards / fight_bubbles / headline_card, built from the real bout (bout.json) and the game's
own word tables (quoted beside each use). Writes docs/mockups/s442/loop/*.html; render with tools/render_mockup.py."""
import base64, html, io, json, pathlib, re
from PIL import Image

ROOT = pathlib.Path("E:/FightCamp/Lean")
OUTD = ROOT / "docs/mockups/s442/loop"
OUTD.mkdir(parents=True, exist_ok=True)
D = json.loads((ROOT / "docs/mockups/s442/result/bout.json").read_text(encoding="utf-8"))
E = html.escape
F, O = D["fighter"], D["opponent"]
A, B = F["first"], O["first"]
R = D["rounds"]
CALLS = D["words"]["calls"]


def b64(p):
    return base64.b64encode(pathlib.Path(p).read_bytes()).decode()


def img64(im):
    buf = io.BytesIO()
    im.save(buf, "PNG")
    return "data:image/png;base64," + base64.b64encode(buf.getvalue()).decode()


FONTS = ""
for fam, w, f in (("Barlow", 500, "Barlow-Medium"), ("Barlow", 600, "Barlow-SemiBold"), ("Barlow", 700, "Barlow-Bold"),
                  ("Bebas", 400, "BebasNeue-Regular"), ("Plex", 500, "IBMPlexMono-Medium")):
    FONTS += "@font-face{font-family:%s;font-weight:%d;src:url(data:font/ttf;base64,%s)}" % (fam, w, b64(ROOT / ("assets/fonts/%s.ttf" % f)))

# palette: TV.gd (the dark fight look) + WoodKit chalk; one meaning per colour
INK, SOFT, MUTE = "#f3ece2", "#b8a88f", "#8a8079"     # TV.FG, WoodKit.SOFT, grey
GOLD = "#e9b84a"        # TV.GOLD: the ONE primary action (the button that breathes, Pulse.gd)
RED, BLUE = "#e0503c", "#4278e0"   # red corner / blue corner (TV.RED; the HUD blue)
GOOD, FAIR, POOR = "#6cc27a", "#f0a020", "#e06060"   # CallButtons.GRADE_COLOR (Good / Fair / Poor) - also fit best / - / wrong
AMBER = "#f0a020"       # TV.AMBER: step tags, "untrained"
PURPLE = "#8a5cf0"      # UI.PURPLE: an achievement (the milestone treatment), never an action
PANEL, LINE = "#1d1714", "#4a3a30"   # TV.BG / TV.LINE

BASE_CSS = FONTS + """
*{box-sizing:border-box;margin:0;padding:0}
html,body{width:1920px;height:1080px;overflow:hidden;background:#070605}
body{position:relative;font-family:Barlow,sans-serif;color:%s}
.abs{position:absolute}
.note{position:absolute;left:16px;width:1888px;background:#141a22;border:2px dashed #5d7896;border-radius:6px;padding:8px 14px;
 font:500 16px/21px Barlow;color:#cfd9e4}
.note b{color:#fff;font-weight:700}.note .k{display:inline-block;width:96px;white-space:nowrap;font:700 16px Barlow;color:#8fbcff;letter-spacing:1px}
.note .w{color:#9fb4c8}
""" % INK


def gate(name, css, body):
    """The page rules: no text under 16 px rendered; no he/she/her/him in page text."""
    scale = 1.0
    m = re.search(r"--scale:\s*([0-9.]+)", css)
    for mm in re.finditer(r"font:\s*(?:\d+\s+)?(\d+)px", css + body):
        assert int(mm.group(1)) >= 16, (name, "text under 16 px", mm.group(0))
    for mm in re.finditer(r"font-size:\s*(\d+)px", css + body):
        assert int(mm.group(1)) >= 16, (name, "text under 16 px", mm.group(0))
    texts = re.findall(r">([^<]+)<", body)
    alltext = html.unescape(" ".join(texts))
    bad = re.findall(r"\b(he|she|her|him|his|hers|herself|himself|engine)\b", alltext, re.I)
    assert not bad, (name, "banned word in page text", bad[:5])


def write(name, title, css, body):
    gate(name, css, body)
    doc = (f'<!doctype html><html><head><meta charset="utf-8"><title>{title}</title><style>{BASE_CSS}{css}</style></head>'
           f'<body>{body}</body></html>')
    p = OUTD / name
    p.write_text(doc, encoding="utf-8")
    print(p, p.stat().st_size)


def minfont(h, m, n):
    for mm in re.finditer(r"(?:font:\s*(?:\d+\s+)?|font-size:\s*)(\d+)px", h):
        assert int(mm.group(1)) >= m, (n, "scaled text too small", mm.group(0))


def named(s):
    return s.replace("{her}", A).replace("{opp}", B)


# ============================================================ the game's rules, re-read (PlanFight / StrikeMap / LineSwap)
EDGE = {"best": 9.0, "ok": 3.0, "none": 0.0, "wrong": -7.0}             # PlanFight.EDGE
ANSWERS = {                                                                # PlanFight.ANSWERS (the rows used here)
    "counter": {"best": ["feint", "1-1", "1-1-2"], "ok": ["1-2", "step_in", "step_out", "1-2-3b"], "wrong": ["1-2-3-2", "1-2-3", "1-6-3", "2-3"]},
    "she_hurt": {"best": ["tie_up", "pivot_out", "roll_out", "step_out"], "ok": ["step_back", "1-1", "push_off"],
                 "wrong": ["1-2-3-2", "1-6-3", "3b-3", "herd", "step_in", "slip 2-3"]},
}
LONG_OUTS = [("1-1", "Double jab", "combo", "long"), ("1-2", "One-two", "combo", "long"), ("2-3", "Cross, hook", "combo", "mid"),
             ("1-2-3", "One-two-hook", "combo", "mid"), ("1-2-3-2", "One-two-hook-cross", "combo", "mid"),
             ("1-2-3b", "One-two, body hook", "combo", "mid"), ("step_out", "Step out", "step", "outside"),
             ("cut_off", "Cut off the ring", "step", "opp_ropes")]          # StrikeMap.outs("long")
CARD_NAME = {"outside": "Outside", "long": "Long range", "mid": "Mid range", "inside": "Inside", "clinch": "Clinch",
             "own_ropes": "On the ropes", "opp_ropes": "Opponent on the ropes", "corner": "Corner trap"}   # StrikeMap.CARDS
FIT_WORDS = {"best": "Beats it", "ok": "Works", "none": "", "wrong": "Walks into it"}               # PlanLines.FIT_WORDS
GAME_WORDS = {"counter": "Opponent waited to counter", "she_hurt": "Your fighter was hurt", "loadup": "Opponent loaded up"}  # LineSwap._game_words


def fit(mid, sit):
    row = ANSWERS[sit]
    for k in ("best", "ok", "wrong"):
        if mid in row[k]:
            return k
    return "none"


def rate(kind):   # PlanFight.rate: combos {} -> undrilled 0.8 (PlanBoard.UNDRILLED); a step 1.0
    return 0.8 if kind == "combo" else 1.0


def value(mid, kind, sit):
    e = EDGE[fit(mid, sit)]
    return e * rate(kind) if e > 0 else e


def options(sit, lost_move="1-2-3"):
    base = sum(value(m, k, sit) for m, _, k, _ in LONG_OUTS) / len(LONG_OUTS)   # PlanFight.card_mean (all 8 can_do: bout plan options)
    lost_w = value(lost_move, "combo", sit) - base
    out = []
    for m, n, k, to in LONG_OUTS:
        if m == lost_move:
            continue
        w = value(m, k, sit) - base
        if w <= lost_w:
            continue
        out.append({"move": m, "name": n, "fit": fit(m, sit), "worth": w, "was": lost_w, "to": to, "rate": rate(k)})
    out.sort(key=lambda o: -o["worth"])
    return out[:2], lost_w


# lost_most after round 2 (LineSwap._aggregate over rounds 1-2)
agg = {}
for r in R[:2]:
    for x in r["exchanges"]:
        if x["planned"] and x["arrow"]:
            a = agg.setdefault(x["arrow"], {"won": 0, "thrown": 0, "at": x["at"], "o": len(agg)})
            a["won"] += int(x["won"])
            a["thrown"] += 1
lost = max(((k, v) for k, v in agg.items() if v["thrown"] - v["won"] > 0),
           key=lambda kv: (kv[1]["thrown"] - kv[1]["won"], -kv[1]["won"], kv[1]["thrown"], -kv[1]["o"]))
assert lost[0] == "1-2-3" and (lost[1]["won"], lost[1]["thrown"]) == (1, 2), lost
# LineSwap.shown_game over round 2 as the code stands: the later of the tied games
cnt, last = {}, {}
for i, x in enumerate(R[1]["exchanges"]):
    cnt[x["psit"]] = cnt.get(x["psit"], 0) + 1
    last[x["psit"]] = i
shown = max(cnt, key=lambda s: (cnt[s], last[s]))
assert shown == "she_hurt", shown
CODE_OPTS, CODE_LOST = options("she_hurt")          # what LineSwap.row() offers today
FIX_OPTS, FIX_LOST = options("counter")             # rated on line C's own WHEN (the fix drawn)
assert [o["move"] for o in CODE_OPTS] == ["step_out", "1-1"], CODE_OPTS
assert [o["move"] for o in FIX_OPTS] == ["1-1", "step_out"], FIX_OPTS
# the bout's own plan options carry the game's edge numbers for line C: they must match ours
gopt = {o["id"]: o["edge"] for o in D["plan"][2]["options"]}
for o in FIX_OPTS:
    assert abs(gopt[o["move"]] - o["worth"]) < 0.01, (o, gopt[o["move"]])
assert abs(gopt["1-2-3"] - FIX_LOST) < 0.01


def sgn(v):
    return ("+%d" if round(v) >= 0 else "&minus;%d") % abs(round(v))   # GamePlan._rating: "%+.0f over improvising"


# ============================================================ icons (inline SVG, stroke icons)
def svg(path, c, s=20, sw=2):
    return (f'<svg width="{s}" height="{s}" viewBox="0 0 24 24" fill="none" stroke="{c}" stroke-width="{sw}" '
            f'stroke-linecap="round" stroke-linejoin="round" style="flex:none">{path}</svg>')


IC = {
    "mega": '<path d="M3 10v4h3l7 4V6L6 10z"/><path d="M16 9a4 4 0 0 1 0 6"/><path d="M18.5 6.5a8 8 0 0 1 0 11"/>',
    "talk": '<path d="M4 5h16v10H9l-5 4z"/>',
    "plan": '<rect x="5" y="3" width="14" height="18" rx="2"/><path d="M9 8h6M9 12h6M9 16h4"/>',
    "swap": '<path d="M4 8h13l-3-3M20 16H7l3 3"/>',
    "eye": '<path d="M2 12s4-7 10-7 10 7 10 7-4 7-10 7S2 12 2 12z"/><circle cx="12" cy="12" r="3"/>',
    "tick": '<path d="M4 12l5 5L20 6"/>',
    "half": '<circle cx="12" cy="12" r="8"/><path d="M12 4v16" /><path d="M12 4a8 8 0 0 1 0 16z" fill="currentColor"/>',
    "cross": '<path d="M6 6l12 12M18 6L6 18"/>',
    "trophy": '<path d="M8 4h8v5a4 4 0 0 1-8 0z"/><path d="M8 6H5a3 3 0 0 0 3 4M16 6h3a3 3 0 0 1-3 4"/><path d="M12 13v4M8 20h8M9 17h6"/>',
    "play": '<path d="M7 5l11 7-11 7z" fill="currentColor"/>',
}


# ============================================================ 1. CORNER CARDS (the corner minute after round 2)
def corner():
    r2 = R[1]
    st = D["fight_stats"]["rounds"][1]
    ea, eb = r2["exchanges"][-1]["after"]["a"], r2["exchanges"][-1]["after"]["b"]   # CornerJobsRow.menu: energy = last exchange's after
    body_a = r2["exchanges"][-1]["after"]["body"][0]                                  # bout body hits on our fighter
    # Exchanges.read on the round's last three exchanges -> sit, the coach's pick, the line
    last3 = [x["sit"] for x in r2["exchanges"][-3:]]
    tally = {}
    for s in last3:
        tally[s] = tally.get(s, 0) + 1
    rsit = last3[-1]
    for k in tally:
        if tally[k] > tally.get(rsit, 0):
            rsit = k
    assert rsit == "she_hurt"
    coach_pick = "tie"                                   # Exchanges.MODES she_hurt best
    coach_line = "You got hurt at the end of that round. " + named(CALLS[coach_pick]["tell"])
    # recover: CornerJobs.recover_options + CornerJobsRow.defaults (energy < WEARY_AT 40 -> +6 a point; ice 3 hits; body >= 6 -> 1 ice)
    water_per = 6 if ea < 40 else 3
    rec_ice = 1 if body_a >= 6 else 0
    rec_water = 3 - rec_ice
    grades = D["call_grades"]
    GW = {"Good": "Good", "OK": "Fair", "Poor": "Poor"}           # CallButtons.GRADE_WORD
    GC = {"Good": GOOD, "OK": FAIR, "Poor": POOR}

    def ew(c):                                                      # CallButtons.energy_words
        return "saves energy" if c < 0 else ("energy even" if c == 0 else ("costs a lot of energy" if c >= 3 else "costs energy"))

    S = 0.88
    gl = (1920 - 1920 * S) / 2
    css = f"""
.game{{position:absolute;left:{gl:.0f}px;top:8px;width:1920px;height:1080px;transform:scale({S});transform-origin:0 0;overflow:hidden;
 background:radial-gradient(ellipse at 70% 55%,#3b2a20 0%,#1b130e 45%,#0b0806 80%);border-radius:4px}}
.scene{{position:absolute;left:0;top:138px;width:1920px;height:806px;background:
 radial-gradient(circle at 18% 30%,#4a3426 0 6%,transparent 7%),radial-gradient(circle at 34% 22%,#3e2c20 0 5%,transparent 6%),
 radial-gradient(circle at 52% 26%,#46322a 0 5%,transparent 6%),radial-gradient(circle at 80% 24%,#3a2a20 0 5%,transparent 6%),
 linear-gradient(#20160f,#140e0a)}}
.rope{{position:absolute;left:0;width:1920px;height:14px;background:linear-gradient(#5a5048,#2a2420);opacity:.8}}
.boxer{{position:absolute;left:-160px;top:220px;width:620px;height:900px;border-radius:300px 300px 0 0;background:#2b1b14;border:3px solid #3a261c}}
.topbar{{position:absolute;left:0;top:0;width:1920px;height:138px;background:#000}}
.mono{{font:500 22px Plex;color:#efe6d8;letter-spacing:1px}}
.bot{{position:absolute;left:0;top:944px;width:1920px;height:136px;background:#000}}
.card{{position:absolute;left:634px;top:142px;width:1262px;height:934px;background:rgba(18,14,12,.95);border:1px solid #3a2e26;border-radius:6px}}
.t19{{font:500 19px Barlow;color:{INK};white-space:nowrap}}
.s19{{font:500 19px Barlow;color:{SOFT};white-space:nowrap}}
.cap{{font:600 19px Barlow;letter-spacing:2px;text-transform:uppercase;white-space:nowrap}}
.tab{{position:absolute;top:16px;height:40px;padding:0 14px;display:flex;align-items:center;border-radius:4px;font:600 21px Barlow;color:{SOFT};border:1px solid #3a2e26}}
.tab.on{{color:#e8d5a8;background:#2a211c;border-color:#8a7350}}
.row{{position:absolute;display:flex;align-items:center;gap:8px;white-space:nowrap}}
.qb{{width:32px;height:32px;border:1px solid #4a3a30;border-radius:4px;display:flex;align-items:center;justify-content:center;font:600 20px Barlow;color:{SOFT};background:#1a1411}}
.choice{{position:absolute;border:1px solid #4a3a30;border-radius:5px;background:#231b16;padding:6px 14px}}
.choice b{{display:block;font:600 20px/24px Barlow;color:{INK};white-space:nowrap}}
.choice span{{display:block;font:500 19px/22px Barlow;color:{SOFT};white-space:nowrap}}
.choice.on{{background:#3a2f26;border-color:#cdb68a}}
.pin{{width:30px;height:28px;border:2px solid;border-radius:4px;display:flex;align-items:center;justify-content:center;font:400 22px/1 Bebas;padding-top:2px;color:{INK};background:#120e0c}}
.tile{{position:absolute;left:18px;width:244px;height:36px;border:1px solid #3a2e26;border-radius:4px;background:#1a1411;display:flex;align-items:center;padding:0 6px 0 10px;gap:6px}}
.tile .n{{flex:1;font:500 19px Barlow;color:{SOFT};white-space:nowrap}}
.tile.fire .n{{color:{INK}}}
.swap{{position:absolute;width:302px;height:150px;overflow:hidden;border:1px solid #4a3a30;border-radius:6px;background:#211a15;padding:10px 12px}}
.swap.hov{{border:2px solid #efe6d8;box-shadow:0 0 0 4px rgba(239,230,216,.18),0 0 22px rgba(239,230,216,.25)}}
.chip{{display:inline-flex;align-items:center;height:28px;padding:0 10px;border-radius:4px;font:700 19px Barlow;white-space:nowrap}}
.trk{{position:absolute;left:12px;top:48px;width:276px;height:12px;background:#2e2520;border-radius:3px}}
.btn2{{position:absolute;left:12px;bottom:10px;height:34px;padding:0 12px;display:flex;align-items:center;gap:6px;border-radius:4px;
 font:700 19px Barlow;color:{INK};background:linear-gradient(#3a2f28,#2a221c);border:1px solid #6a5a4a;white-space:nowrap}}
.call{{position:absolute;width:233px;height:88px;border:1px solid #4a3a30;border-radius:5px;background:#221a15;padding:3px 8px}}
.foot{{position:absolute;left:0;bottom:0;width:100%;height:34px;display:flex;align-items:center;justify-content:center;gap:8px;font:700 19px Barlow;color:{INK};background:linear-gradient(#3a2f28,#2a221c);border-top:1px solid #6a5a4a}}
.call b{{display:block;font:600 20px/24px Barlow;white-space:nowrap;letter-spacing:-0.2px}}
.call span{{display:block;font:500 19px/20px Barlow;color:{SOFT};letter-spacing:-0.2px}}
.call.pri{{border:2px solid {GOLD};box-shadow:0 0 0 5px rgba(233,184,74,.22),0 0 26px rgba(233,184,74,.45);transform:scale(1.03)}}
"""
    g = []
    # top bar as today (CornerOverlay: clock 19 px light ink since the audit)
    g.append('<div class="scene"></div><div class="rope" style="top:300px"></div><div class="rope" style="top:420px"></div>'
             '<div class="boxer"></div><div class="topbar"></div><div class="bot"></div>')
    g.append(f'<div class="abs mono" style="left:32px;top:30px">CORNER&nbsp;&nbsp;&nbsp;0:51&nbsp;&nbsp;&nbsp;ROUND 3 NEXT</div>')
    g.append(f'<div class="abs" style="left:578px;top:30px;width:780px;height:40px">'
             f'<span class="abs cap" style="left:0;top:8px;color:{RED}">{E(A)}</span>'
             f'<span class="abs" style="left:56px;top:15px;width:120px;height:12px;background:#2a2420"><i style="position:absolute;right:0;top:0;height:12px;width:{ea:.0f}%;background:{RED}"></i></span>'
             f'<span class="abs" style="left:196px;top:2px;font:700 26px Barlow">{ea:.0f}</span>'
             f'<span class="abs cap" style="left:330px;top:8px;color:{INK}">Energy</span>'
             f'<span class="abs" style="left:516px;top:2px;font:700 26px Barlow">{eb:.0f}</span>'
             f'<span class="abs" style="left:566px;top:15px;width:120px;height:12px;background:#2a2420"><i style="position:absolute;left:0;top:0;height:12px;width:{eb:.0f}%;background:{BLUE}"></i></span>'
             f'<span class="abs cap" style="left:700px;top:8px;color:#8fbcff">{E(B)}</span></div>')
    g.append(f'<div class="abs" style="left:1620px;top:22px;width:272px;height:48px;border:1px solid #3a3532;border-radius:6px;'
             f'display:flex;align-items:center;justify-content:center;font:600 19px Barlow;color:{SOFT}">Skip to the bell</div>')
    # the card
    c = ['<div class="card">']
    # left column: body figure (as today) + the NEW ring strip
    c.append(f'<div class="abs" style="left:46px;top:16px;width:192px;height:262px;border:1px solid #2c4a6a;border-radius:6px;background:#0d1622">'
             f'<svg class="abs" style="left:56px;top:14px" width="80" height="236" viewBox="0 0 80 236" fill="none" stroke="#6fb4ff" stroke-width="2">'
             f'<circle cx="40" cy="20" r="14"/><path d="M26 44h28l8 70-8 4-4-40v150h-12l-2-90-2 90H22V78l-4 40-8-4z"/></svg></div>')
    c.append(f'<div class="abs s19" style="left:18px;top:286px;width:250px;white-space:normal;line-height:23px;text-align:center">No cut, no swollen eye: the cutman waits.</div>')
    c.append(f'<div class="abs cap" style="left:18px;top:470px;color:{SOFT}">Where the lines fire</div>')
    tiles = ["outside", "long", "mid", "inside", "clinch", "own_ropes", "opp_ropes", "corner"]
    pins = {"long": [("A", INK), ("C", POOR)], "mid": [("B", GOOD)]}   # plan letters on their card; colour = fit vs the opponent (PlanLines.FIT_WORDS)
    tile_y = {}
    y = 498
    for t in tiles:
        tile_y[t] = y
        hov = t == "long"
        ps = "".join(f'<span class="pin" style="border-color:{col}{";box-shadow:0 0 0 3px #efe6d8,0 0 14px rgba(239,230,216,.6)" if (hov and L == "C") else ""}">{L}</span>'
                     for L, col in pins.get(t, []))
        if hov:   # the hovered card's line: the tile opens a second line naming the swap
            c.append(f'<div class="tile fire" style="top:{y}px;height:64px;flex-wrap:wrap;align-content:center;border-color:#efe6d8">'
                     f'<span class="n">{CARD_NAME[t]}</span>{ps}<span style="width:100%;font:700 19px Barlow;color:#efe6d8">C &#8594; Double jab</span></div>')
            y += 70
        else:
            c.append(f'<div class="tile{" fire" if t in pins else ""}" style="top:{y}px"><span class="n">{CARD_NAME[t]}</span>{ps}</div>')
            y += 42
    # right column
    X = 285   # card-relative left of the right column (919 - 634)
    c.append(f'<div class="tab on" style="left:{X}px;top:12px">This round</div><div class="tab" style="left:{X + 136}px;top:12px">The fight so far</div>')
    c.append(f'<div class="abs cap" style="left:{X}px;top:60px;color:{GOLD}">Round 2: {E(B)}&#39;s round - 9-10 on your card - rounds 1-1</div>')
    c.append(f'<div class="abs cap" style="left:{X}px;top:86px;width:95px;text-align:right;color:{RED}">{E(A)}</div>'
             f'<div class="abs cap" style="left:{X + 280}px;top:86px;width:170px;text-align:center;color:{SOFT}">This round</div>'
             f'<div class="abs cap" style="left:{X + 636}px;top:86px;color:#8fbcff">{E(B)}</div>')
    rows = [("Punches landed", st["landed"][0], st["landed"][1], RED, BLUE, max(st["landed"])),
            ("To the body", st["body"][0], st["body"][1], RED, BLUE, max(st["body"])),
            ("Exchanges won", st["xwon"][0], st["xwon"][1], RED, BLUE, 6),
            ("Energy at the bell", round(ea), round(eb), GOOD, GOOD, 100)]
    for i, (lab, a, b, ca, cb, top) in enumerate(rows):
        y = 110 + i * 23
        c.append(f'<div class="abs t19" style="left:{X}px;top:{y}px;width:95px;text-align:right">{a}</div>'
                 f'<div class="abs" style="left:{X + 105}px;top:{y + 7}px;width:170px;height:11px;background:#2a2420"><i style="position:absolute;right:0;height:11px;width:{a / top * 100:.0f}%;background:{ca}"></i></div>'
                 f'<div class="abs s19" style="left:{X + 280}px;top:{y}px;width:170px;text-align:center">{lab}</div>'
                 f'<div class="abs" style="left:{X + 456}px;top:{y + 7}px;width:170px;height:11px;background:#2a2420"><i style="position:absolute;left:0;height:11px;width:{b / top * 100:.0f}%;background:{cb}"></i></div>'
                 f'<div class="abs t19" style="left:{X + 636}px;top:{y}px">{b}</div>')
    c.append(f'<div class="abs" style="left:{X}px;top:208px;font:600 22px Barlow;letter-spacing:1px;color:{INK}">IN THE CORNER: WHAT DO YOU TELL {E(A.upper())}?</div>')
    c.append(f'<div class="abs cap" style="left:{X}px;top:240px;color:{AMBER}">Coach</div><div class="abs t19" style="left:{X + 96}px;top:239px;font-size:20px">{E(coach_line)}</div>')
    c.append(f'<div class="abs cap" style="left:{X}px;top:270px;color:{AMBER}">1&nbsp;&nbsp;The minute</div>')
    dots_w = "&#9679;" * rec_water + "&#9675;" * (3 - rec_water)
    dots_i = "&#9679;" * rec_ice + "&#9675;" * (3 - rec_ice)
    c.append(f'<div class="row" style="left:{X}px;top:294px;gap:6px"><span class="cap" style="width:132px;letter-spacing:1px;color:{GOOD}">Recover 3/3</span>'
             f'<span class="qb">-</span><span class="t19">Water and breathing</span><span class="t19" style="color:{GOOD}">{dots_w}</span>'
             f'<span class="s19">(+{water_per} energy each)</span><span class="qb">+</span><span style="width:6px"></span>'
             f'<span class="qb">-</span><span class="t19">Ice on the ribs</span><span class="t19" style="color:{GOOD}">{dots_i}</span>'
             f'<span class="s19">(-3 body hits each)</span><span class="qb">+</span></div>')
    c.append(f'<div class="row" style="left:{X}px;top:328px"><span class="cap" style="width:120px;color:{AMBER}">Set-up</span>'
             f'<span class="s19">{E(A)} has no combination yet - drill one on the pads in the gym to set it up here.</span></div>')
    c.append(f'<div class="abs cap" style="left:{X}px;top:368px;color:{AMBER}">Talk</div>')
    talks = [("Calm down", "saves energy, safer"), ("Fire up", "+1.5 power, tiring, riskier"), ("Tell the truth", "+0.3 power")]   # CornerJobs.talk at personality 50/50/50
    for i, (t1, t2) in enumerate(talks):
        c.append(f'<div class="choice" style="left:{X + 124 + i * 250}px;top:356px;width:240px;height:52px;padding-top:2px"><b>{t1}</b><span>{t2}</span></div>')
    # ---- PLAN: NEW
    PY = 418
    c.append(f'<div class="abs cap" style="left:{X}px;top:{PY + 9}px;color:{GOOD}">Plan</div>')
    c.append(f'<div class="abs" style="left:{X + 124}px;top:{PY}px;width:836px;height:40px;background:#241c17;border-left:4px solid {POOR};border-radius:4px;'
             f'display:flex;align-items:center;gap:10px;padding:0 12px;white-space:nowrap">'
             f'<span class="pin" style="border-color:{POOR}">C</span><span class="cap" style="color:{SOFT}">Lost most</span>'
             f'<span style="font:700 21px Barlow">One-two-hook {lost[1]["won"]} of {lost[1]["thrown"]}</span>'
             f'<span style="width:2px;height:24px;background:#4a3a30;margin:0 6px"></span>{svg(IC["eye"], SOFT, 22)}'
             f'<span class="t19" style="font-size:20px">{GAME_WORDS["counter"]}</span></div>')
    CT = PY + 48
    sx = [X + 124, X + 438]
    for i, o in enumerate(FIX_OPTS):
        fc = GOOD if o["fit"] == "best" else "#5a5048"
        tc = "#0f2a17" if o["fit"] == "best" else INK

        def px(v):   # worth bar on the EDGE scale -7..+9: the lost line's tick, the option's fill
            return (v + 7.0) / 16.0 * 276.0
        x0, x1 = px(o["was"]), px(o["worth"])
        extra = (f'<div class="abs" style="left:12px;top:86px;font:600 19px Barlow;color:{AMBER}">Untrained: lands 80%</div>' if o["rate"] < 1
                 else f'<div class="abs s19" style="left:12px;top:86px">Ends at: {CARD_NAME[o["to"]]}</div>')
        c.append(f'<div class="swap{" hov" if i == 0 else ""}" style="left:{sx[i]}px;top:{CT}px">'
                 f'<div style="display:flex;justify-content:space-between;align-items:center"><b style="font:700 23px Barlow">{E(o["name"])}</b>'
                 f'<span class="chip" style="background:{fc};color:{tc}">{FIT_WORDS[o["fit"]]}</span></div>'
                 f'<div class="trk" style="top:42px"><i style="position:absolute;left:{x0:.0f}px;width:{x1 - x0:.0f}px;top:0;height:12px;border-radius:3px;background:{fc if o["fit"] == "best" else "#cdbfa8"}"></i>'
                 f'<i style="position:absolute;left:{x0 - 2:.0f}px;top:-5px;width:4px;height:22px;background:{POOR}"></i></div>'
                 f'<div class="abs s19" style="left:12px;top:60px"><b style="color:{INK}">{sgn(o["worth"])}</b> over improvising &middot; C was {sgn(o["was"])}</div>'
                 f'{extra}<div class="foot">{svg(IC["swap"], INK, 20)}Swap into C</div></div>')
    c.append(f'<div class="choice on" style="left:{X + 752}px;top:{CT}px;width:208px;height:58px"><b>Keep the plan</b><span>A, B and C stay</span></div>')
    c.append(f'<div class="abs s19" style="left:{X + 752}px;top:{CT + 70}px;width:208px;white-space:normal;line-height:22px">Other changes &#9662;<br>(today&#39;s list)</div>')
    # the hover link: card 1 -> the C pin on Long range (card-relative coords)
    hx, hy = sx[0], CT + 40
    py = tile_y["long"] + 18
    c.append(f'<svg class="abs" style="left:0;top:0" width="1262" height="940"><path d="M{hx} {hy} C {hx - 60} {hy}, 330 {py}, 268 {py}" '
             f'stroke="#efe6d8" stroke-width="3" fill="none" stroke-dasharray="8 6"/><circle cx="268" cy="{py}" r="5" fill="#efe6d8"/></svg>')
    # ---- 2 one change (as today: Adaptation.offers with hold 0.835 -> 3 punches, BODY_COST 1.2 -> 4 energy; the habit fix; Leave it)
    CY = CT + 156
    c.append(f'<div class="abs cap" style="left:{X}px;top:{CY}px;color:{AMBER}">2&nbsp;&nbsp;One change (optional)</div>')
    ch = [("Elbows in", "3 fewer body, 3 more head, +4 energy", 222), ("Gloves high", "3 fewer head, 3 more body, -4 energy", 222),
          ("Fix: Chases the stoppage", "Your coach has seen it. Press to work on it next round", 330), ("Leave it", "Just the plan", 161)]
    cx0 = X
    for t1, t2, w in ch:
        c.append(f'<div class="choice" style="left:{cx0}px;top:{CY + 24}px;width:{w}px;height:72px;padding-top:3px"><b>{t1}</b>'
                 f'<span style="white-space:normal;color:{AMBER if t1.startswith(("Elbows", "Gloves")) else SOFT}">{t2}</span></div>')
        cx0 += w + 8
    # ---- 3 calls (CallButtons.corner_grid compact): grade colour on the name, the coach's star
    KY = CY + 104
    c.append(f'<div class="abs cap" style="left:{X}px;top:{KY}px;color:{AMBER}">3&nbsp;&nbsp;Pick the plan - it starts the round</div>')
    for i, k in enumerate(["long", "body", "lead", "hands", "let_go", "calm", "tie", "finish"]):
        cc = CALLS[k]
        gr = grades[k]
        x = X + (i % 4) * 241
        y = KY + 24 + (i // 4) * 92
        star = "&#9733;&nbsp;" if k == coach_pick else ""
        c.append(f'<div class="call{" pri" if k == coach_pick else ""}" style="left:{x}px;top:{y}px"><b style="color:{GC[gr]}">{star}{E(cc["label"])}</b>'
                 f'<span>{E(named(cc["when"]).replace("Use when", "When"))}</span><span>{GW[gr]} at it, {ew(cc["cost"])}</span></div>')
    c.append('</div>')
    g.append("".join(c))
    game = f'<div class="game">{"".join(g)}</div>'
    minfont(game, 19, "corner")
    fb = 8 + 1080 * S
    note = (f'<div class="note" style="top:{fb + 8:.0f}px;height:{1072 - fb - 8:.0f}px">'
            f'<div><span class="k">NEW</span><b>The PLAN row:</b> the line that lost most and what the opponent showed (LineSwap.lost_most / shown_game), two swap cards (LineSwap.options: name, '
            f'PlanLines.FIT_WORDS chip, worth bar on PlanFight.EDGE, "Untrained" from PlanFight.rate), Keep the plan, and the ring strip (StrikeMap.CARDS + the plan letters); '
            f'hovering a card draws its line to the place it fires. One click = LineSwap.apply &#8594; sel.arrow &#8594; CornerJobsRow.suffix "|arrow=2:1-1" (today&#39;s path).</div>'
            f'<div><span class="k">AS TODAY</span>Top bar, stats, coach line, Recover, Set-up, Talk, One change, the eight calls (CornerJobsRow / CallButtons.corner_grid). '
            f'<span class="w">Gold = the one primary: the coach&#39;s starred call breathes (Pulse.gd). Cards are rated on line C&#39;s own WHEN (counter): needs a LineSwap fix, see the notes file.</span></div></div>')
    write("corner_cards.html", "Corner cards", css, game + note)


# ============================================================ 2. FIGHT BUBBLES (round 2, the 3D fight)
def fight():
    r2 = R[1]
    x0, x1, x2 = r2["exchanges"][0], r2["exchanges"][1], r2["exchanges"][2]
    assert x0["planned"] and x0["arrow"] == "1-2-3" and not x0["won"] and x0["plan_tally"] == [1, 2]
    assert x2["shout"] and x2["call"] == "hands" and x2["planned"] and x2["arrow"] == "1-2"
    shouts_before = sum(1 for x in r2["exchanges"][:2] if x["shout"])
    assert shouts_before == 0      # the first shout of the round: ShoutBar.shout_note -> taken in fully (2 a round)
    # HUD numbers at 2:32 of round 2 (the end of exchange 1): FightHud shows exchanges up to (t + VERDICT_LEAD_S) / 30
    ea, eb = x0["after"]["a"], x0["after"]["b"]
    la, lb = x0["landed"]
    ba, bb = x0["body"]
    allx = [x for x in R[0]["exchanges"]] + [x0]
    heard = [x["shout"] for x in allx if x["call"]][-3:]
    nmode = sum(1 for x in allx if x["mode"] == "counter")
    verdict0 = x0["verdict"]
    verdict2 = x2["verdict"]
    S = 0.75
    css = f"""
.game{{position:absolute;left:16px;top:16px;width:1920px;height:1080px;transform:scale({S});transform-origin:0 0;overflow:hidden;border-radius:4px;
 background:linear-gradient(#1a1512 0,#2a2018 30%,#1a1410 40%)}}
.crowd{{position:absolute;left:0;top:0;width:1920px;height:460px;background:
 radial-gradient(circle at 10% 40%,#3a2c22 0 3%,transparent 3.5%),radial-gradient(circle at 22% 30%,#40302a 0 3%,transparent 3.5%),
 radial-gradient(circle at 40% 36%,#3a2c22 0 3%,transparent 3.5%),radial-gradient(circle at 60% 30%,#40302a 0 3%,transparent 3.5%),
 radial-gradient(circle at 78% 38%,#3a2c22 0 3%,transparent 3.5%),radial-gradient(circle at 92% 30%,#40302a 0 3%,transparent 3.5%)}}
.t22{{font:600 22px Barlow;color:#fff;white-space:nowrap}}
.s22{{font:500 22px Barlow;color:#e8ddd0;white-space:nowrap}}
.hb{{position:absolute;border-radius:5px;background:linear-gradient(#3a2d22,#241b14);border:2px solid #5a4636;display:flex;align-items:center;justify-content:center;
 font:600 22px Barlow;color:#efe6d8;white-space:nowrap}}
.hb.on{{background:linear-gradient(#e8d9bd,#cdb994);color:#2a2018;border-color:#f3e6c8}}
.bub{{position:absolute;display:flex;align-items:flex-start;gap:10px;padding:10px 14px;border-radius:8px;background:rgba(20,15,12,.94);
 border:2px solid #cdb68a;box-shadow:0 4px 14px rgba(0,0,0,.5)}}
.bub .tx{{font:600 22px/27px Barlow;color:{INK}}}
.bub .tg{{font:700 22px Barlow;white-space:nowrap}}
.life{{position:absolute;left:0;bottom:0;height:4px;background:#cdb68a;border-radius:0 0 0 6px}}
.pinb{{display:inline-flex;align-items:center;justify-content:center;width:34px;height:32px;border:2px solid;border-radius:5px;font:400 26px/1 Bebas;padding-top:3px;color:{INK}}}
.sb{{position:absolute;left:1472px;width:432px;height:244px;border-radius:6px;overflow:hidden;background:linear-gradient(#211913,#120d0a);border:1px solid #3a3532}}
.sbh{{position:absolute;left:10px;top:6px;font:700 17px Barlow;letter-spacing:1px;color:#e8ddd0;white-space:nowrap}}
.mb{{position:absolute;display:flex;align-items:center;gap:6px;padding:5px 9px;border-radius:6px;background:rgba(20,15,12,.94);border:2px solid #cdb68a;
 font:600 16px/19px Barlow;color:{INK}}}
.mpin{{display:inline-flex;align-items:center;justify-content:center;width:24px;height:22px;border:2px solid;border-radius:4px;font:400 19px/1 Bebas;padding-top:2px}}
"""

    def ring(scale=1.0, ox=0, oy=0, people=True):
        """The ring stand-in in game coords: canvas, ropes, the two corner posts, two simple boxers."""
        o = []
        o.append(f'<svg class="abs" style="left:{ox}px;top:{oy}px" width="{1920 * scale}" height="{1080 * scale}" viewBox="0 0 1920 1080">'
                 '<polygon points="470,430 1450,430 1920,900 0,900" fill="#2f63c8"/><polygon points="0,900 1920,900 1920,1080 0,1080" fill="#1f2f6a"/>'
                 '<polygon points="470,430 1450,430 1460,445 460,445" fill="#24489a"/>')
        for k, y in enumerate((300, 345, 390)):
            col = "#d94a3a" if k == 1 else "#e8e4dc"
            o.append(f'<line x1="470" y1="{y}" x2="1450" y2="{y}" stroke="{col}" stroke-width="5"/>'
                     f'<line x1="470" y1="{y}" x2="0" y2="{y + 300}" stroke="{col}" stroke-width="6"/>'
                     f'<line x1="1450" y1="{y}" x2="1920" y2="{y + 300}" stroke="{col}" stroke-width="6"/>')
        o.append('<rect x="458" y="270" width="24" height="170" rx="4" fill="#d23a2c"/><rect x="1438" y="270" width="24" height="170" rx="4" fill="#2f63c8" stroke="#9dbbf0" stroke-width="2"/>')
        if people:
            for cx, col, glove, face in ((970, "#c9452f", "#d8382a", 1), (1200, "#2f55b8", "#2a5ad8", -1)):
                o.append(f'<g><rect x="{cx - 38}" y="440" width="76" height="160" rx="30" fill="{col}"/>'
                         f'<rect x="{cx - 34}" y="590" width="30" height="170" rx="12" fill="{col}" opacity=".85"/><rect x="{cx + 4}" y="590" width="30" height="170" rx="12" fill="{col}" opacity=".85"/>'
                         f'<ellipse cx="{cx - 22}" cy="768" rx="26" ry="12" fill="#111"/><ellipse cx="{cx + 22}" cy="768" rx="26" ry="12" fill="#111"/>'
                         f'<circle cx="{cx + face * 6}" cy="404" r="34" fill="#6b4632"/>'
                         f'<circle cx="{cx + face * 46}" cy="408" r="22" fill="{glove}"/><circle cx="{cx + face * 30}" cy="446" r="22" fill="{glove}"/></g>')
        o.append('</svg>')
        return "".join(o)

    g = ['<div class="crowd"></div>', ring()]
    # today's HUD (FightHud / HudBars / SidePanel / ShoutBar), round 2 at 2:32
    for side, nm, mode, en, col in (("a", F["name"], "Own game", ea, "#f5c242"), ("b", O["name"], "Waiting to counter", eb, "#f5c242")):
        x = 28 if side == "a" else 1308
        bx = 210 if side == "a" else 1490
        g.append(f'<div class="abs" style="left:{x}px;top:24px;font:700 32px Barlow;color:#fff">{E(nm.upper())}</div>'
                 f'<div class="abs s22" style="left:{x}px;top:66px">{mode}</div>')
        for k, (lab, val, c2) in enumerate((("energy", "%d" % round(en), col), ("legs", "", "#5ac46a"), ("guard", "", "#8fbcff"))):
            y = 102 + k * 34
            g.append(f'<div class="abs s22" style="left:{x}px;top:{y}px">{lab.upper()}</div>'
                     f'<div class="abs t22" style="left:{x + 98}px;top:{y}px">{val}</div>'
                     f'<div class="abs" style="left:{bx}px;top:{y + 6}px;width:{en * 2.06 if k == 0 else 190:.0f}px;height:20px;background:{c2};opacity:{1 if k == 0 else .55}"></div>')
    # holograms (today), simple outlines
    for hx in (40, 1600):
        g.append(f'<svg class="abs" style="left:{hx}px;top:350px" width="280" height="540" viewBox="0 0 80 236" fill="rgba(111,180,255,.12)" stroke="#6fb4ff" stroke-width="1.2">'
                 '<circle cx="40" cy="20" r="14"/><path d="M26 44h28l8 70-8 4-4-40v150h-12l-2-90-2 90H22V78l-4 40-8-4z"/></svg>')
    # the scoreboard (wood frame) + round dots
    g.append('<div class="abs" style="left:640px;top:0;width:640px;height:168px;background:#2a2622;border:10px solid #6b4a2b;border-top:none;border-radius:0 0 8px 8px"></div>'
             '<div class="abs t22" style="left:640px;top:12px;width:640px;text-align:center;color:#d8cfc4">ROUND 2 / 3</div>'
             '<div class="abs" style="left:640px;top:40px;width:640px;text-align:center;font:500 64px Barlow;color:#fff">2:32</div>')
    dots = ""
    for i in range(6):
        if i == 0:
            dots += f'<span style="display:inline-block;width:26px;height:26px;border-radius:13px;background:{BLUE};margin:0 9px"></span>'
        else:
            dots += '<span style="display:inline-block;width:26px;height:26px;border-radius:13px;background:#3a3532;margin:0 9px"></span>'
    g.append(f'<div class="abs" style="left:640px;top:122px;width:640px;text-align:center">{dots}</div>')
    g.append(f'<div class="abs" style="left:826px;top:186px;display:flex;gap:10px;align-items:center"><span class="s22" style="color:#d8cfc4">CARDS</span>'
             f'<span class="hb" style="position:static;width:56px;height:44px;border-color:{RED}">R1</span><span class="hb" style="position:static;width:56px;height:44px;border-style:dashed;border-color:{GOLD}">R2</span>'
             f'<span class="hb" style="position:static;width:56px;height:44px">R3</span></div>')
    # over-head state boxes (today)
    g.append(f'<div class="abs" style="left:770px;top:316px;padding:6px 14px;border:2px solid {RED};border-radius:6px;background:rgba(20,15,12,.85)" ><span class="t22">Hands up, move your head</span></div>')
    g.append(f'<div class="abs" style="left:1120px;top:316px;padding:6px 14px;border:2px solid #8fbcff;border-radius:6px;background:rgba(20,15,12,.85)"><span class="t22">Waiting to counter</span></div>')
    # bottom bar (today)
    g.append('<div class="abs" style="left:16px;top:906px;width:1888px;height:168px;background:linear-gradient(#3a2d22,#2a2018);border-radius:4px;border:2px solid #5a4636"></div>')
    g.append('<div class="abs s22" style="left:28px;top:912px;color:#d8cfc4">PACE</div><div class="abs s22" style="left:326px;top:912px;color:#d8cfc4">AIM</div>')
    for i, (t, on) in enumerate((("Push", 0), ("Steady", 1), ("Save", 0))):
        g.append(f'<div class="hb{" on" if on else ""}" style="left:{26 + i * 96}px;top:942px;width:90px;height:42px">{t}</div>')
    for i, (t, on) in enumerate((("Own game", 1), ("Head", 0), ("Body", 0))):
        g.append(f'<div class="hb{" on" if on else ""}" style="left:{324 + i * 96 + (20 if i else 0)}px;top:942px;width:{112 if i == 0 else 84}px;height:42px">{t}</div>')
    calls = [("JAB AND MOVE", "Works", "#c97a10"), ("DRAW THE LEAD", "Beats it", "#2f9a55"), ("LET YOUR HANDS GO", "Risky", "#c8312a")]   # Exchanges.offers("counter"), in CALLS order: long (ok), lead (best), let_go (wrong)
    for i, (t, w, wc) in enumerate(calls):
        pri = ";border-color:%s;box-shadow:0 0 0 5px rgba(233,184,74,.25),0 0 24px rgba(233,184,74,.5);transform:scale(1.03)" % GOLD if i == 1 else ""
        g.append(f'<div class="hb" style="left:{28 + i * 288}px;top:996px;width:276px;height:66px;flex-direction:column;gap:2px{pri}">'
                 f'<span style="font:700 22px Barlow">{t}</span><span style="font:700 22px Barlow;color:#fff;background:{wc};padding:0 8px;border-radius:3px">{w}</span></div>')
    g.append('<div class="hb" style="left:892px;top:996px;width:100px;height:66px;flex-direction:column;font-size:22px;line-height:22px"><span>Say</span><span>nothing</span></div>')
    g.append(f'<div class="abs" style="left:628px;top:912px;width:80px;height:80px;border-radius:40px;border:6px solid #3a3532;border-top-color:{GOLD};display:flex;align-items:center;justify-content:center;font:600 24px Barlow;color:{GOLD}">0:02</div>')
    g.append('<div class="abs" style="left:718px;top:912px;width:300px;height:76px;border:2px solid #5a4636;border-radius:4px;padding:2px 8px">'
             '<div style="font:700 22px Barlow;color:#d8cfc4">FROM THE NEXT EXCHANGE</div><div style="font:500 22px Barlow;color:#d8cfc4">Steady: no gain, no cost</div></div>')
    pips = "".join(f'<span style="display:inline-block;width:18px;height:18px;border-radius:9px;margin-right:6px;background:{GOLD if h else "#4a423c"}"></span>' for h in heard)
    g.append(f'<div class="abs" style="left:1030px;top:922px">{pips}</div><div class="abs s22" style="left:1030px;top:950px">Heard {sum(heard)} of 3</div>')
    g.append(f'<div class="abs" style="left:1150px;top:914px;width:192px;height:72px;border:2px solid #cdb68a;border-radius:5px;display:flex;flex-direction:column;align-items:center;justify-content:center;font:600 22px/24px Barlow;color:#fff">'
             f'<span>Waiting to counter,</span><span>{nmode} times</span></div>')
    g.append(f'<div class="abs" style="left:1350px;top:912px;width:392px;height:150px;border:2px solid #5a4636;border-radius:4px;padding:6px 10px">'
             f'<div style="display:flex;gap:110px"><span class="s22" style="color:#d8cfc4">LANDED</span><span class="s22" style="color:#d8cfc4">YOUR CALLS</span></div>'
             f'<div style="display:flex;align-items:center;gap:30px"><span style="font:700 40px Barlow;color:{RED}">{la}</span><span style="font:700 40px Barlow;color:#5a8ff0">{lb}</span>'
             f'<span class="s22" style="font-size:22px">Hands up, move your head</span></div>'
             f'<div class="s22" style="font-size:22px">{E(A)} head {la - ba} body {ba}</div><div class="s22" style="font-size:22px">{E(B)} head {lb - bb} body {bb}</div></div>')
    for i, t in enumerate(("2x", "Skip round", "Skip bout")):
        g.append(f'<div class="hb" style="left:1756px;top:{914 + i * 50}px;width:136px;height:42px;font-size:22px">{t}</div>')
    # ---- the bubbles (NEW): both from our (red) corner post, at 2:32 of round 2
    # 1. the coach's line after exchange 1 (Exchanges.verdict, today a caption under the ring)
    g.append(f'<div class="bub" style="left:40px;top:212px;width:400px">{svg(IC["talk"], "#cdb68a", 28)}'
             f'<div><div class="tx">{E(verdict0)}</div>'
             f'<div style="display:flex;align-items:center;gap:8px;margin-top:4px"><span style="width:16px;height:16px;border-radius:8px;background:{BLUE}"></span>'
             f'<span style="font:600 22px Barlow;color:{SOFT}">Coach &middot; exchange to {E(B)}</span></div></div>'
             f'<div class="life" style="width:62%"></div></div>')
    g.append('<svg class="abs" style="left:0;top:0" width="1920" height="1080"><path d="M441 268 L458 282 L441 296" fill="#cdb68a" stroke="#cdb68a" stroke-width="2"/></svg>')
    # 2. the plan mark at the exchange's end (ExchangeBeats.plan_tally_caption, today a caption) with the line's letter
    g.append(f'<div class="bub" style="left:500px;top:448px;align-items:center;padding:8px 12px">'
             f'<span class="pinb" style="border-color:{POOR}">C</span><span class="tg">Plan C</span><span class="tx" style="white-space:nowrap">&middot; lost it &middot; 1 of 2</span>'
             f'<div class="life" style="width:80%"></div></div>')
    g.append('<svg class="abs" style="left:0;top:0" width="1920" height="1080"><path d="M499 460 L482 472 L499 484" fill="#cdb68a" stroke="#cdb68a" stroke-width="2"/></svg>')
    game = f'<div class="game">{"".join(g)}</div>'
    minfont(game, 22, "fight")

    # ---- the storyboard: the same round, three other moments (each bubble drawn at its rendered size)
    sbs = []

    def mini_ring(y):
        return (f'<svg class="abs" style="left:0;top:0" width="432" height="244" viewBox="0 0 432 244"><g transform="translate(0,22)">'
                f'<polygon points="104,120 328,120 432,226 0,226" fill="#2f63c8"/>'
                f'<line x1="104" y1="92" x2="328" y2="92" stroke="#e8e4dc" stroke-width="2"/><line x1="104" y1="102" x2="328" y2="102" stroke="#d94a3a" stroke-width="2"/>'
                f'<line x1="104" y1="92" x2="0" y2="160" stroke="#e8e4dc" stroke-width="2"/><line x1="328" y1="92" x2="432" y2="160" stroke="#e8e4dc" stroke-width="2"/>'
                f'<rect x="100" y="84" width="8" height="40" rx="2" fill="#d23a2c"/><rect x="324" y="84" width="8" height="40" rx="2" fill="#2f63c8" stroke="#9dbbf0"/>'
                f'<g transform="translate(64,0)"><rect x="183" y="132" width="20" height="74" rx="8" fill="#c9452f"/><circle cx="195" cy="122" r="9" fill="#6b4632"/><circle cx="206" cy="128" r="6" fill="#d8382a"/>'
                f'<rect x="232" y="132" width="20" height="74" rx="8" fill="#2f55b8"/><circle cx="240" cy="122" r="9" fill="#6b4632"/><circle cx="229" cy="128" r="6" fill="#2a5ad8"/></g></g></svg>')

    shots = [
        ("ROUND 2, 2:58 &middot; LINE C FIRES",
         f'<div class="mb" style="left:10px;top:172px"><span class="mpin" style="border-color:{POOR}">C</span>Plan C &middot; One-two-hook</div>',
         '<path d="M104 146 L104 172" stroke="#cdb68a" stroke-width="3"/>'),
        ("ROUND 2, 1:58 &middot; THE SHOUT, HEARD",
         f'<div class="mb" style="left:10px;top:32px;width:260px">{svg(IC["mega"], "#cdb68a", 18)}<span>&quot;Hands up! Move your head!&quot;</span>'
         f'<span style="color:{GOOD};display:flex;align-items:center;gap:3px">{svg(IC["tick"], GOOD, 16, 3)}Heard</span></div>'
         f'<div class="mb" style="left:10px;top:172px"><span class="mpin" style="border-color:{INK}">A</span>Plan A &middot; One-two</div>',
         '<path d="M104 84 L104 106" stroke="#cdb68a" stroke-width="3"/><path d="M104 146 L104 172" stroke="#cdb68a" stroke-width="3"/>'),
        ("ROUND 2, 1:32 &middot; THE COACH AFTER IT",
         f'<div class="mb" style="left:10px;top:30px;width:300px;align-items:flex-start">{svg(IC["talk"], "#cdb68a", 18)}<span>{E(verdict2)}</span></div>'
         f'<div class="mb" style="left:10px;top:172px"><span class="mpin" style="border-color:{INK}">A</span>Plan A &middot; lost it &middot; 1 of 2</div>',
         '<path d="M104 100 L104 106" stroke="#cdb68a" stroke-width="3"/><path d="M104 146 L104 172" stroke="#cdb68a" stroke-width="3"/>'),
    ]
    assert x2["plan_tally"] == [1, 2] and not x2["won"]
    for i, (h, bubs, extra) in enumerate(shots):
        y = 16 + i * 256
        sbs.append(f'<div class="sb" style="top:{y}px">{mini_ring(y)}<svg class="abs" style="left:0;top:0" width="432" height="244">{extra}</svg>'
                   f'{bubs}<div class="sbh">{h}</div></div>')
    rules = (f'<div class="abs" style="left:1472px;top:786px;width:432px;font:500 16px/20px Barlow;color:#d8cfc4">'
             f'<b style="color:#fff">Heard mark:</b> <span style="color:{GOOD}">Heard</span> (first 2 shouts of a round) &middot; '
             f'<span style="color:{AMBER}">Half heard</span> (the 3rd on) &middot; <span style="color:{MUTE}">Not heard</span> (stopped listening)</div>')
    fb = 16 + 1080 * S
    note = (f'<div class="note" style="top:{fb + 12:.0f}px;height:118px">'
            f'<div><span class="k">NEW</span><b>Reaction bubbles</b> from our corner post: the shout and whether it went in (ExchangeBeats shout beat + ShoutBar.shout_note / CornerTrust.lands), '
            f'the coach&#39;s line after each exchange (Exchanges.verdict, the x.verdict caption), and the plan mark with its letter when a line fires and when it ends '
            f'(ExchangeBeats "Plan:" beat and plan_tally_caption). Two at most, about 2 s each (the gold-brown strip runs down), never over a head, glove or feet.</div>'
            f'<div><span class="k">AS TODAY</span>Plates, scoreboard, state boxes over the heads, holograms, the bottom bar and its calls (FightHud / HudBars / SidePanel / ShoutBar / CornerBar). '
            f'<span class="w">These three captions leave the line under the ring; set-up, read and habit captions stay there. Legs and guard numbers are not in the bout record: bars only. '
            f'Gold = the one primary: the shout bar&#39;s Beats it call keeps its gold edge and breathes (Pulse.gd).</span></div></div>')
    write("fight_bubbles.html", "Fight bubbles", css, game + "".join(sbs) + rules + note)


# ============================================================ 3. HEADLINE CARD (before the result page)
def headline():
    top = Image.open(ROOT / "docs/mockups/s439/result/top_today.png").convert("RGB")   # the game's own portraits (as build_result.py)
    FACE = {"a": img64(top.crop((214, 122, 282, 190)).resize((150, 150), Image.LANCZOS)),
            "b": img64(top.crop((1638, 122, 1706, 190)).resize((150, 150), Image.LANCZOS))}
    cf = D["counterfactual"]["same_bout"]["no_line_c"]
    assert D["outcome"] == "loss" and D["cards"] == ["28-29", "28-29", "29-28"]
    assert cf["outcome"] == "win" and cf["cards"] == ["29-28", "29-28", "28-29"]
    assert D["before"]["rank"]["need"] == 1          # "Unranked: 1 win from entering."
    st2 = D["fight_stats"]["rounds"][1]
    why = D["fight_why"]["against"].split(". ")[0] + "."   # FightWhy: the AGAINST line, first sentence
    css = f"""
.fr{{position:absolute;top:12px;width:936px;height:940px;border-radius:6px;overflow:hidden;
 background:radial-gradient(ellipse at 50% 70%,#203a78 0,#14204a 35%,#0b0a0a 75%)}}
.dim{{position:absolute;inset:0;background:rgba(6,5,4,.62)}}
.lbl{{position:absolute;left:16px;top:14px;font:700 17px Barlow;letter-spacing:2px;color:#cfd9e4;background:#141a22;border:2px dashed #5d7896;border-radius:4px;padding:2px 10px}}
.hc{{position:absolute;left:48px;top:96px;width:840px;height:790px;background:linear-gradient(#211a15,#14100d);border:1px solid #4a3a30;border-radius:8px;
 box-shadow:0 12px 40px rgba(0,0,0,.6)}}
.hc.ms{{border:2px solid {PURPLE};box-shadow:0 0 0 6px rgba(138,92,240,.18),0 0 60px rgba(138,92,240,.45)}}
.show{{position:absolute;left:0;top:26px;width:840px;text-align:center;font:600 19px Barlow;letter-spacing:3px;color:{SOFT}}}
.hl{{position:absolute;left:30px;top:66px;width:780px;text-align:center;font:400 64px/64px Bebas;letter-spacing:1px}}
.fc{{position:absolute;top:172px;width:330px;height:346px;border-radius:6px;padding:16px;text-align:center}}
.fc.r{{left:30px;background:linear-gradient(160deg,#3a1410,#160a08);border-bottom:4px solid {RED}}}
.fc.b{{right:30px;background:linear-gradient(200deg,#122347,#0a0f1c);border-bottom:4px solid {BLUE}}}
.fc img{{width:150px;height:150px;border-radius:6px;border:3px solid}}
.fn{{margin-top:8px;font:400 38px/1 Bebas;letter-spacing:1px;color:#fff}}
.fs{{margin-top:2px;font:600 17px Barlow;letter-spacing:1px;white-space:nowrap;color:{SOFT};text-transform:uppercase}}
.fr2{{margin-top:6px;font:600 20px Barlow;color:#e8ddd0}}.fr2 b{{color:#fff}}
.vs{{position:absolute;left:370px;top:300px;width:100px;text-align:center;font:400 40px Bebas;color:{MUTE}}}
.cards{{position:absolute;left:0;top:540px;width:840px;display:flex;justify-content:center;gap:14px}}
.cd{{width:118px;height:52px;border-radius:5px;display:flex;flex-direction:column;align-items:center;justify-content:center}}
.cd b{{font:400 30px/1 Bebas;color:#fff;padding-top:2px}}.cd span{{font:600 16px Barlow;color:{SOFT}}}
.sub{{position:absolute;left:40px;top:624px;width:760px;text-align:center;font:600 22px/28px Barlow;color:#e8ddd0}}
.go{{position:absolute;left:290px;top:704px;width:260px;height:60px;border-radius:6px;display:flex;align-items:center;justify-content:center;gap:10px;
 font:700 26px Barlow;color:#231b16;background:linear-gradient(#f2cd6a,#d9a73a);border:1px solid #f7dc8f;
 box-shadow:0 0 0 6px rgba(233,184,74,.2),0 0 26px rgba(233,184,74,.5);transform:scale(1.03)}}
.ribbon{{position:absolute;left:220px;top:-22px;width:400px;height:44px;border-radius:22px;background:#2a1f45;border:2px solid {PURPLE};
 display:flex;align-items:center;justify-content:center;gap:10px;font:700 20px Barlow;letter-spacing:2px;color:#e6dcff}}
"""
    show = "FIGHT NIGHT &middot; SAT 7 MAR &middot; LIGHTWEIGHT &middot; 3 ROUNDS"

    def card(ms):
        rec_a = "3-1 &#8594; <b>%s</b>" % ("4-1" if ms else "%d-%d" % tuple(D["after"]["record"]))
        rec_b = "5-1 &#8594; <b>%s</b>" % ("5-2" if ms else "%d-%d" % tuple(D["after"]["opp_record"]))
        rk_a = "Unranked &#8594; <b>Ranked</b>" if ms else "Unranked"
        rk_b = "No. 4" if ms else "No. 4 &#8594; <b>No. 3</b>"
        cards = cf["cards"] if ms else D["cards"]
        hl = "%s wins on a split, 2-1" % A if ms else "%s loses on a split, 2-1" % A
        sub = ("Round 2 decided it: %s won %d of 6 exchanges; judge 3 gave it to %s." % (A, cf["rounds_won_n"][1], B) if ms
               else why)
        o = [f'<div class="hc{" ms" if ms else ""}">']
        if ms:
            o.append(f'<div class="ribbon">{svg(IC["trophy"], "#c9b3ff", 24)}ENTERS THE RANKINGS</div>')
        o.append(f'<div class="show">{show}</div>')
        o.append(f'<div class="hl" style="color:{"#fff" if ms else "#ff8a78"}">{E(hl.upper())}</div>')
        o.append(f'<div class="fc r"><img src="{FACE["a"]}" style="border-color:{RED}"><div class="fn">{E(F["name"].upper())}</div>'
                 f'<div class="fs">Red &middot; {E(F["style"])}</div><div class="fs">&nbsp;</div><div class="fr2">{rec_a}</div><div class="fr2">{rk_a}</div></div>')
        o.append('<div class="vs">V</div>')
        o.append(f'<div class="fc b"><img src="{FACE["b"]}" style="border-color:{BLUE}"><div class="fn">{E(O["name"].upper())}</div>'
                 f'<div class="fs">Blue &middot; {E(O["style"])}</div><div class="fs">{E(O["club"])}</div><div class="fr2">{rec_b}</div><div class="fr2">{rk_b}</div></div>')
        o.append('<div class="cards">' + "".join(
            f'<div class="cd" style="background:{"#5e2018" if int(c.split("-")[0]) > int(c.split("-")[1]) else "#1b3360"};border:2px solid {RED if int(c.split("-")[0]) > int(c.split("-")[1]) else BLUE}">'
            f'<b>{c}</b><span>Judge {j + 1}</span></div>' for j, c in enumerate(cards)) + '</div>')
        o.append(f'<div class="sub">{E(sub)}</div>')
        o.append(f'<div class="go">See the fight {svg(IC["play"], "#231b16", 22)}</div>')
        o.append('</div>')
        return "".join(o)

    body = []
    for i, ms in enumerate((False, True)):
        x = 16 + i * 952
        lab = "A LOSS &middot; THIS BOUT" if not ms else "A MILESTONE WIN &middot; THE SAME NIGHT WITHOUT LINE C (MEASURED REPLAY)"
        body.append(f'<div class="fr" style="left:{x}px"><div class="dim"></div><div class="lbl">{lab}</div>{card(ms)}'
                    + (f'<div class="abs" style="left:600px;top:892px;font:600 16px Barlow;color:#c9b3ff;background:#141a22;border:2px dashed #5d7896;border-radius:4px;padding:2px 8px">'
                       f'purple glow + ribbon = milestone treatment</div>' if ms else '') + '</div>')
    note = ('<div class="note" style="top:962px;height:110px">'
            '<div><span class="k">NEW</span><b>A headline card</b> between the last bell and the result page, built only from the bout&#39;s own fields: outcome and how (BoutRules cards, 2-1), '
            'records and ranks before / after (Career record, RankRow words), the cards, one cause (FightWhy "against" line; for a win, the flip round), and See the fight &#8594; today&#39;s result page.</div>'
            '<div><span class="k">AS TODAY</span>The result page itself, the portraits (the game&#39;s faces), the fight-night label and date. '
            '<span class="w">The game holds no show or venue name, so the line names the night, the date, the weight and the rounds. Gold = the one action; purple = an achievement, never a button.</span></div></div>')
    write("headline_card.html", "Headline card", css, "".join(body) + note)


corner()
fight()
headline()
