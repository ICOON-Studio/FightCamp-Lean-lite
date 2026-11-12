"""S442 PUSHTANK v2 drawing (ops/research/PUSHTANK_MAP_V2_S442.md): HANDS spend WIND, FEET spend LEGS, both protect the HEAD.
Three states: the corner minute as the pit stop (setting HANDS and FEET), mid-round with both floor rings and the head meter
(the big frame), late with legs gone and the fighter on the ropes. Writes fight_bars_v2.html beside this file; render with:
python tools/render_mockup.py docs/mockups/s442/pushtank/fight_bars_v2.html"""
import base64, html, pathlib, re

ROOT = pathlib.Path(__file__).resolve().parents[4]
OUT = pathlib.Path(__file__).resolve().parent / "fight_bars_v2.html"
E = html.escape


def b64(p):
    return base64.b64encode(pathlib.Path(p).read_bytes()).decode()


FONTS = ""
for fam, w, f in (("Barlow", 500, "Barlow-Medium"), ("Barlow", 600, "Barlow-SemiBold"), ("Barlow", 700, "Barlow-Bold")):
    FONTS += "@font-face{font-family:%s;font-weight:%d;src:url(data:font/ttf;base64,%s)}" % (fam, w, b64(ROOT / ("assets/fonts/%s.ttf" % f)))

INK, SOFT = "#f3ece2", "#b8a88f"
GOLD, TEAL, HEADC = "#f5c242", "#3fc1b0", "#e0503c"
AMBER, REDW, GOOD = "#f0a020", "#e06060", "#6cc27a"
BLUE, RED = "#4278e0", "#e0503c"
GONE = "#5b5550"

# ---- the rules the readouts use (CODE unless marked) -------------------------------------------------------------
DRAIN = 5.0            # wind an exchange at Steady, Stamina 55: Combos.round_spend / 6
SPEND = {"Coast": 0.6, "Steady": 1.0, "Push": 1.35}   # PaceAim.PACE_SPEND
MINUTE_W = 15.0        # Combos.refill (~9) + two water points x3 (CornerJobs): ESTIMATE
GASSED, PUSH0 = 35.0, 40.0   # Exchanges.SHE_TIRED; PaceAim.push_gassed is 0 at 40
LEGS_BASE = 2.0        # NEW (map 3.2)
FEET = {"Press": 1.5, "Hold": 0.7, "Move": 1.0}      # NEW (map 3.2)
LEGS_GONE = 30.0       # NEW cliff
HEAD_LINE = 60.0       # Knockdowns.KO_DAMAGE / DAMAGE_SCALE


def clock(ex_into_round, rnd):
    s = int(ex_into_round * 30)
    return "%d:%02d into round %d" % (s // 60, s % 60, rnd)


def wind_when(w, ex_left, rnd, rounds, hands):
    """When wind crosses the gassed line at this setting, in clock time; or the spare at the final bell."""
    r, left = rnd, ex_left
    while r <= rounds:
        for i in range(left):
            w -= DRAIN * SPEND[hands]
            if w < GASSED:
                return "gassed %s at %s" % (clock(6 - left + i + 1, r), hands)
        r += 1
        left = 6
        w += MINUTE_W
    spare = (w - MINUTE_W - GASSED) / (DRAIN * SPEND[hands]) * 30
    return "to the final bell, %d:%02d spare" % (int(spare) // 60, int(spare) % 60)


def legs_when(l, w, ex_left, rnd, rounds, feet):
    r, left = rnd, ex_left
    while r <= rounds:
        for i in range(left):
            l -= LEGS_BASE * FEET[feet] * (1 + 0.5 * (1 - w / 100))     # BodyLoad.TANK_MULT 0.5 (CODE)
            if l < LEGS_GONE:
                return "gone %s if you %s" % (clock(6 - left + i + 1, r), feet.lower())
        r += 1
        left = 6
        l += 3.0                                                      # the minute: 20% back (NEW)
    return "to the final bell, plenty"


CSS = FONTS + f"""
*{{box-sizing:border-box;margin:0;padding:0}}
html,body{{width:1920px;height:1080px;overflow:hidden;background:#070605}}
body{{position:relative;font-family:Barlow,sans-serif;color:{INK}}}
.abs{{position:absolute}}
.game{{position:absolute;left:16px;top:16px;width:1920px;height:1080px;transform:scale(.75);transform-origin:0 0;overflow:hidden;border-radius:4px;
 background:linear-gradient(#1a1512 0,#2a2018 30%,#1a1410 40%)}}
.pn{{position:absolute;background:rgba(18,14,11,.9);border:1px solid #4a3a30;border-radius:8px;overflow:hidden}}
.seg{{display:inline-flex;align-items:center;justify-content:center;border:2px solid #5a4636;background:linear-gradient(#3a2d22,#241b14);color:#efe6d8;font-weight:700}}
.seg.on{{background:linear-gradient(#e8d9bd,#cdb994);color:#2a2018;border-color:#f3e6c8}}
.seg.off{{opacity:.4}}
.hatch{{background:repeating-linear-gradient(135deg,rgba(255,255,255,.85) 0 4px,rgba(30,22,16,.9) 4px 8px)}}
.sb{{position:absolute;left:1472px;width:432px;border-radius:6px;background:linear-gradient(#211913,#120d0a);border:1px solid #3a3532}}
.sbh{{font:700 17px Barlow;letter-spacing:1px;color:#e8ddd0;white-space:nowrap}}
.cap{{font:500 16px/20px Barlow;color:#d8cfc4}}
.sticky{{position:absolute;background:#ffd95a;color:#2a2018;border-radius:3px;box-shadow:0 3px 0 #c9a227;padding:8px 12px}}
.note{{position:absolute;left:16px;width:1888px;background:#141a22;border:2px dashed #5d7896;border-radius:6px;padding:10px 14px;
 font:500 18px/24px Barlow;color:#cfd9e4}}
.note b{{color:#fff}}.note .k{{display:inline-block;width:112px;font:700 18px Barlow;color:#8fbcff;letter-spacing:1px}}
"""


def bar(x, y, w, h, v, col, gone=0.0, ghost=0.0, refill=0.0, rng=None, lines=(), pulse=None, k=1.0):
    px = lambda q: w * q / 100.0
    o = [f'<div class="abs" style="left:{x}px;top:{y}px;width:{w}px;height:{h}px;background:#1b1512;border:1px solid #4a3a30;border-radius:3px;overflow:hidden">']
    if rng:
        o.append(f'<div class="abs" style="left:0;top:0;width:{px(rng[0]):.0f}px;height:{h}px;background:{col}"></div>'
                 f'<div class="abs" style="left:{px(rng[0]):.0f}px;top:0;width:{px(rng[1] - rng[0]):.0f}px;height:{h}px;background:{col};opacity:.4"></div>')
    else:
        o.append(f'<div class="abs" style="left:0;top:0;width:{px(v - ghost):.0f}px;height:{h}px;background:{col}"></div>')
        if ghost:
            o.append(f'<div class="abs hatch" style="left:{px(v - ghost):.0f}px;top:0;width:{px(ghost):.0f}px;height:{h}px"></div>')
        if refill:
            o.append(f'<div class="abs" style="left:{px(v):.0f}px;top:0;width:{px(refill):.0f}px;height:{h}px;background:#fff;opacity:.55"></div>')
    if gone:
        o.append(f'<div class="abs" style="left:{px(100 - gone):.0f}px;top:0;width:{px(gone) + 1:.0f}px;height:{h}px;background:{GONE}"></div>')
    o.append('</div>')
    for q, c in lines:
        glow = f";box-shadow:0 0 0 {4 * k:.0f}px rgba(224,96,96,.35),0 0 {14 * k:.0f}px rgba(224,96,96,.85)" if pulse == q else ""
        o.append(f'<div class="abs" style="left:{x + px(q) - 1.5:.0f}px;top:{y - 4 * k:.0f}px;width:3px;height:{h + 8 * k:.0f}px;background:{c}{glow}"></div>')
    return "".join(o)


def segs(x, y, k, labels, on, hover="", dim=()):
    f = lambda n: round(n * k)
    o = []
    for i, t in enumerate(labels):
        rad = f"border-radius:{f(5)}px 0 0 {f(5)}px" if i == 0 else (f"border-radius:0 {f(5)}px {f(5)}px 0;border-left:none" if i == len(labels) - 1 else "border-radius:0;border-left:none")
        ring = f";outline:{f(3)}px dashed {GOLD};outline-offset:-{f(5)}px" if t == hover else ""
        cls = "seg" + (" on" if t == on else "") + (" off" if t in dim else "")
        o.append(f'<div class="abs {cls}" style="left:{x + i * f(66)}px;top:{y}px;width:{f(66)}px;height:{f(28)}px;{rad};font-size:{f(16)}px{ring}">{t}</div>')
    return "".join(o)


def ours(x, y, k, s, corner=BLUE, title="LUCY JACKSON", side_word="Blue corner"):
    f = lambda n: round(n * k)
    w, bw = f(412), f(236)
    o = [f'<div class="pn" style="left:{x}px;top:{y}px;width:{w}px;height:{f(272)}px;border-top:{f(5)}px solid {corner}"></div>',
         f'<div class="abs" style="left:{x + f(14)}px;top:{y + f(10)}px;font:700 {f(22)}px Barlow;color:#fff;white-space:nowrap">{title}</div>',
         f'<div class="abs" style="left:{x + w - f(150)}px;top:{y + f(14)}px;width:{f(136)}px;text-align:right;font:600 {f(16)}px Barlow;color:{SOFT};white-space:nowrap">{side_word}</div>']
    for row, (lab, labels, on, hov, dim) in enumerate((("HANDS", ("Coast", "Steady", "Push"), s["hands"], s.get("hh", ""), ()),
                                                       ("FEET", ("Press", "Hold", "Move"), s["feet"], s.get("fh", ""), s.get("fdim", ())))):
        ry = y + f(44) + row * f(34)
        o.append(f'<div class="abs" style="left:{x + f(14)}px;top:{ry + f(5)}px;font:700 {f(16)}px Barlow;letter-spacing:1px;color:{SOFT}">{lab}</div>')
        o.append(segs(x + f(76), ry, k, labels, on, hov, dim))
    o.append(f'<div class="abs" style="left:{x + f(280)}px;top:{y + f(50)}px;width:{f(120)}px;font:600 {f(16)}px/{f(20)}px Barlow;color:{s.get("tagc", GOOD)}">{s["tag"]}</div>')
    for row, (lab, col, key, lines, ro) in enumerate((("WIND", GOLD, "wind", ((PUSH0, "#f3ece2"), (GASSED, REDW)), "rw"),
                                                      ("LEGS", TEAL, "legs", ((LEGS_GONE, REDW),), "rl"),
                                                      ("HEAD", HEADC, "head", ((HEAD_LINE, "#f3ece2"),), "rh"))):
        by = y + f(124) + row * f(50)
        o.append(f'<div class="abs" style="left:{x + f(14)}px;top:{by - f(3)}px;font:700 {f(16)}px Barlow;letter-spacing:1px;color:{SOFT}">{lab}</div>')
        o.append(bar(x + f(76), by, bw, f(16), s[key], col, s.get(key + "_gone", 0.0), s.get(key + "_ghost", 0.0), s.get(key + "_refill", 0.0),
                     None, lines, s.get("pulse", {}).get(key), k))
        o.append(f'<div class="abs" style="left:{x + f(320)}px;top:{by - f(3)}px;font:700 {f(16)}px Barlow;color:{s.get(key + "_c", INK)};white-space:nowrap">{s[key + "_w"]}</div>')
        o.append(f'<div class="abs" style="left:{x + f(14)}px;top:{by + f(20)}px;font:600 {f(16)}px Barlow;color:{s.get(ro + "c", INK)};white-space:nowrap">{E(s[ro])}</div>')
    return "".join(o)


def theirs(x, y, k, corner=RED):
    f = lambda n: round(n * k)
    w, bw = f(412), f(236)
    o = [f'<div class="pn" style="left:{x}px;top:{y}px;width:{w}px;height:{f(272)}px;border-top:{f(5)}px solid {corner}"></div>',
         f'<div class="abs" style="left:{x + f(14)}px;top:{y + f(10)}px;font:700 {f(22)}px Barlow;color:#fff">MARIA ORTEGA</div>',
         f'<div class="abs" style="left:{x + w - f(150)}px;top:{y + f(14)}px;width:{f(136)}px;text-align:right;font:600 {f(16)}px Barlow;color:{SOFT}">Red corner</div>',
         f'<div class="abs" style="left:{x + f(14)}px;top:{y + f(48)}px;font:600 {f(16)}px Barlow;color:{SOFT};white-space:nowrap">HANDS <b style="color:#8fbcff">pushing since round 2</b> &middot; seen</div>',
         f'<div class="abs" style="left:{x + f(14)}px;top:{y + f(82)}px;font:600 {f(16)}px Barlow;color:{SOFT};white-space:nowrap">FEET <b style="color:#8fbcff">pressing</b> &middot; mouth open after the jab</div>']
    for row, (lab, col, rng, word, read, lines) in enumerate((("WIND", GOLD, (44, 56), "slowing", "Breaking soon at this pace", ((GASSED, REDW),)),
                                                              ("LEGS", TEAL, (52, 64), "fresh", "Pressing costs these legs too", ((LEGS_GONE, REDW),)),
                                                              ("HEAD", HEADC, None, "30", "Two clear rounds from the line", ((HEAD_LINE, "#f3ece2"),)))):
        by = y + f(124) + row * f(50)
        o.append(f'<div class="abs" style="left:{x + f(14)}px;top:{by - f(3)}px;font:700 {f(16)}px Barlow;letter-spacing:1px;color:{SOFT}">{lab}</div>')
        o.append(bar(x + f(76), by, bw, f(16), 30 if rng is None else rng[1], col, 0.0, rng=rng, lines=lines, k=k))
        o.append(f'<div class="abs" style="left:{x + f(320)}px;top:{by - f(3)}px;font:700 {f(16)}px Barlow;color:{INK}">{word}</div>')
        o.append(f'<div class="abs" style="left:{x + f(14)}px;top:{by + f(20)}px;font:600 {f(16)}px Barlow;color:{GOOD if row < 2 else INK};white-space:nowrap">{read}</div>')
    return "".join(o)


def rings(cx, cy, wind, legs, rx=110, ry=30, band=None, sw=9):
    """Floor rings under the feet: outer WIND, inner LEGS (arcs empty as they drain). band = (lo, hi) for a range."""
    o = []
    for r, v, col in ((1.0, wind, GOLD), (0.72, legs, TEAL)):
        o.append(f'<ellipse cx="{cx}" cy="{cy}" rx="{rx * r}" ry="{ry * r}" fill="none" stroke="#0e1d48" stroke-width="{sw}" opacity=".8"/>')
        if band and r == 1.0:
            o.append(f'<ellipse cx="{cx}" cy="{cy}" rx="{rx * r}" ry="{ry * r}" fill="none" stroke="{col}" stroke-width="{sw}" pathLength="100" stroke-dasharray="{band[1]} 100" opacity=".45"/>')
            v = band[0]
        if band and r < 1.0:
            o.append(f'<ellipse cx="{cx}" cy="{cy}" rx="{rx * r}" ry="{ry * r}" fill="none" stroke="{col}" stroke-width="{sw}" pathLength="100" stroke-dasharray="{band[3]} 100" opacity=".45"/>')
            v = band[2]
        o.append(f'<ellipse cx="{cx}" cy="{cy}" rx="{rx * r}" ry="{ry * r}" fill="none" stroke="{col}" stroke-width="{sw}" pathLength="100" stroke-dasharray="{v} 100" transform="rotate(180 {cx} {cy})"/>')
    return "".join(o)


def boxer(cx, col, glove, face, y0=440):
    return (f'<rect x="{cx - 38}" y="{y0}" width="76" height="160" rx="30" fill="{col}"/>'
            f'<rect x="{cx - 34}" y="{y0 + 150}" width="30" height="170" rx="12" fill="{col}" opacity=".9"/><rect x="{cx + 4}" y="{y0 + 150}" width="30" height="170" rx="12" fill="{col}" opacity=".9"/>'
            f'<ellipse cx="{cx - 22}" cy="{y0 + 328}" rx="26" ry="12" fill="#111"/><ellipse cx="{cx + 22}" cy="{y0 + 328}" rx="26" ry="12" fill="#111"/>'
            f'<circle cx="{cx + face * 6}" cy="{y0 - 36}" r="34" fill="#6b4632"/>'
            f'<circle cx="{cx + face * 46}" cy="{y0 - 32}" r="22" fill="{glove}"/><circle cx="{cx + face * 30}" cy="{y0 + 6}" r="22" fill="{glove}"/>')


def canvas_svg(w, h, scale=1.0):
    o = [f'<svg class="abs" style="left:0;top:0" width="{w}" height="{h}" viewBox="0 0 1920 1080">'
         '<polygon points="470,430 1450,430 1920,900 0,900" fill="#2f63c8"/><polygon points="0,900 1920,900 1920,1080 0,1080" fill="#1f2f6a"/>'
         '<polygon points="470,430 1450,430 1460,445 460,445" fill="#24489a"/>']
    for kk, yy in enumerate((300, 345, 390)):
        c = "#d94a3a" if kk == 1 else "#e8e4dc"
        o.append(f'<line x1="470" y1="{yy}" x2="1450" y2="{yy}" stroke="{c}" stroke-width="5"/>'
                 f'<line x1="470" y1="{yy}" x2="0" y2="{yy + 300}" stroke="{c}" stroke-width="6"/>'
                 f'<line x1="1450" y1="{yy}" x2="1920" y2="{yy + 300}" stroke="{c}" stroke-width="6"/>')
    o.append('<rect x="458" y="270" width="24" height="170" rx="4" fill="#2f63c8" stroke="#9dbbf0" stroke-width="2"/><rect x="1438" y="270" width="24" height="170" rx="4" fill="#d23a2c"/>')
    return o


# ---- state 2: mid-round (the big frame) ----------------------------------------------------------------------------
S2 = {"hands": "Push", "feet": "Hold", "tag": "1 of 2 shouts left", "wind": 62.0, "legs": 71.0, "head": 24.0,
      "wind_ghost": DRAIN * SPEND["Push"], "legs_ghost": LEGS_BASE * FEET["Hold"] * 1.2, "wind_gone": 6.0, "legs_gone": 2.0,
      "wind_w": "slowing", "legs_w": "fresh", "head_w": "24", "hh": "Push"}
S2["rw"] = "Wind: " + wind_when(S2["wind"], 3, 2, 3, "Push")
S2["rwc"] = AMBER
S2["rl"] = "Legs: " + legs_when(S2["legs"], S2["wind"], 3, 2, 3, "Hold")
S2["rh"] = "Head 24: a dominant round lost adds 32"
STEADY2 = wind_when(S2["wind"], 3, 2, 3, "Steady").replace(" at Steady", "")
# ---- state 1: the corner minute after round 1 (the pit stop) -------------------------------------------------------
S1 = {"hands": "Push", "feet": "Hold", "tag": "Set for round 2: free", "wind": 66.0, "legs": 84.0, "head": 8.0,
      "wind_refill": MINUTE_W, "legs_refill": 3.0, "wind_gone": 4.0, "legs_gone": 1.0, "fh": "Press",
      "wind_w": "fresh", "legs_w": "fresh", "head_w": "8"}
S1["rw"] = "Wind +15; at Push " + wind_when(S1["wind"] + MINUTE_W, 6, 2, 3, "Push").replace(" at Push", "")
S1["rwc"] = AMBER
S1["rl"] = "Legs +3 only; " + legs_when(S1["legs"] + 3, 80, 6, 2, 3, "Press")
S1["rlc"] = AMBER
S1["rh"] = "Head 8: the minute gives none back"
# ---- state 3: round 3, 1:00 left, legs gone, on the ropes ----------------------------------------------------------
S3 = {"hands": "Steady", "feet": "Move", "tag": "0 of 2 shouts left", "tagc": REDW, "wind": 33.0, "legs": 24.0, "head": 52.0,
      "wind_gone": 9.0, "legs_gone": 5.0, "fdim": ("Press",), "pulse": {"head": HEAD_LINE},
      "wind_w": "gassed", "legs_w": "gone", "head_w": "52", "wind_c": REDW, "legs_c": REDW, "head_c": AMBER,
      "rw": "Wind: gassed; the hands are slow", "rwc": REDW, "rl": "Legs: gone; can't step off the ropes", "rlc": REDW,
      "rh": "Head 52: one clear round lost and a count can finish it", "rhc": AMBER}
print("S2", S2["rw"], "|", STEADY2, "|", S2["rl"], "\nS1", S1["rw"], "|", S1["rl"])

g = ['<div class="abs" style="left:0;top:0;width:1920px;height:440px;background:radial-gradient(circle at 25% 60%,#3a2c22 0 4%,transparent 4.5%),radial-gradient(circle at 72% 55%,#40302a 0 4%,transparent 4.5%)"></div>']
sv = canvas_svg(1920, 1080)
sv.append(rings(900, 768, S2["wind"], S2["legs"]))                       # drawn BEFORE the bodies
sv.append(rings(1130, 768, 0, 0, band=(44, 56, 52, 64)))
sv.append(boxer(900, "#2f55b8", "#2a5ad8", 1) + boxer(1130, "#c9452f", "#d8382a", -1))
sv.append('</svg>')
g.append("".join(sv))
g.append(ours(24, 18, 1.4, S2))
g.append(theirs(1318, 18, 1.4))
g.append('<div class="abs" style="left:640px;top:0;width:640px;height:168px;background:#2a2622;border:10px solid #6b4a2b;border-top:none;border-radius:0 0 8px 8px"></div>'
         '<div class="abs" style="left:640px;top:12px;width:640px;text-align:center;font:600 24px Barlow;color:#d8cfc4">ROUND 2 / 3 &middot; CARDS 1 - 0</div>'
         '<div class="abs" style="left:640px;top:40px;width:640px;text-align:center;font:500 64px Barlow;color:#fff">1:30</div>')
dots = "".join(f'<span style="display:inline-block;width:26px;height:26px;border-radius:13px;background:{c};margin:0 9px"></span>'
               for c in (BLUE, RED, BLUE, "#3a3532", "#3a3532", "#3a3532"))
g.append(f'<div class="abs" style="left:640px;top:122px;width:640px;text-align:center">{dots}</div>')
g.append(f'<div class="abs" style="left:24px;top:410px;padding:8px 14px;background:rgba(18,14,11,.94);border:2px solid #cdb68a;border-radius:6px;font:600 22px/28px Barlow;color:{INK}">'
         f'Hatched: the next 30 seconds at Push.<br>At Steady: {E(STEADY2)}.</div>')
g.append('<div class="abs" style="left:16px;top:906px;width:1888px;height:168px;background:linear-gradient(#3a2d22,#2a2018);border-radius:4px;border:2px solid #5a4636"></div>')
g.append(f'<div class="abs" style="left:30px;top:916px;font:700 22px Barlow;color:#d8cfc4;letter-spacing:1px">SHOUT &middot; 1 OF 2 LEFT THIS ROUND (a HANDS or FEET change is one)</div>')
for i, (t, wd, wc) in enumerate((("JAB AND MOVE", "Beats it", "#2f9a55"), ("GO TO THE BODY", "Works", "#c97a10"), ("LET YOUR HANDS GO", "Risky", "#c8312a"))):
    g.append(f'<div class="abs seg" style="left:{28 + i * 288}px;top:960px;width:276px;height:84px;flex-direction:column;border-radius:5px">'
             f'<span style="font:700 22px Barlow">{t}</span><span style="font:700 22px Barlow;color:#fff;background:{wc};padding:0 8px;border-radius:3px">{wd}</span></div>')
g.append('<div class="abs seg" style="left:892px;top:960px;width:116px;height:84px;flex-direction:column;font:600 22px/26px Barlow;border-radius:5px"><span>Say</span><span>nothing</span></div>')
g.append(f'<div class="abs" style="left:1050px;top:944px;width:104px;height:104px;border-radius:52px;border:6px solid #3a3532;border-top-color:{GOLD};display:flex;align-items:center;justify-content:center;font:600 28px Barlow;color:{GOLD}">0:12</div>')
g.append(f'<div class="abs" style="left:1190px;top:952px;width:540px;height:100px;border:2px solid #5a4636;border-radius:4px;padding:6px 12px">'
         f'<div style="font:600 22px Barlow;color:#d8cfc4">LANDED THIS ROUND</div><div style="display:flex;gap:28px;align-items:center"><span style="font:700 44px Barlow;color:{BLUE}">7</span>'
         f'<span style="font:700 44px Barlow;color:{RED}">5</span><span style="font:500 22px Barlow;color:#d8cfc4">exchanges 2 - 1</span></div></div>')
for i, t in enumerate(("2x", "Skip round", "Skip bout")):
    g.append(f'<div class="abs seg" style="left:1756px;top:{946 + i * 40}px;width:136px;height:36px;font:600 22px Barlow;border-radius:5px;opacity:.6">{t}</div>')
game = f'<div class="game">{"".join(g)}</div>'

# ---- the side cards: state 1 (the minute) and state 3 (late, on the ropes) ------------------------------------------
sb = [f'<div class="sb" style="top:16px;height:360px"><div class="abs sbh" style="left:12px;top:8px">1 &middot; THE CORNER MINUTE: THE PIT STOP</div></div>',
      ours(1482, 46, 1.0, S1),
      f'<div class="abs cap" style="left:1484px;top:328px;width:410px">Both set for round 2, free. Pointer on Press: its legs cost shows first. White slices: what the minute gives back.</div>']
# state 3 mini scene: our fighter pinned on the ropes, rings almost empty
mini = ['<svg class="abs" style="left:1482px;top:416px" width="250" height="120" viewBox="0 0 250 120">'
        '<rect x="0" y="0" width="250" height="120" fill="#1a1512"/>'
        '<polygon points="60,40 250,40 250,120 0,120" fill="#2f63c8"/>'
        '<line x1="70" y1="22" x2="0" y2="62" stroke="#e8e4dc" stroke-width="3"/><line x1="70" y1="30" x2="0" y2="72" stroke="#d94a3a" stroke-width="3"/>'
        '<line x1="70" y1="22" x2="250" y2="22" stroke="#e8e4dc" stroke-width="3"/><line x1="70" y1="30" x2="250" y2="30" stroke="#d94a3a" stroke-width="3"/>'
        '<rect x="66" y="14" width="8" height="34" rx="2" fill="#2f63c8" stroke="#9dbbf0"/>']
mini.append('<g transform="translate(52,104) scale(.24) translate(-900,-768)">' + rings(900, 768, S3["wind"], S3["legs"], sw=16) + boxer(900, "#2f55b8", "#2a5ad8", 1) + '</g>')
mini.append('<g transform="translate(124,104) scale(.24) translate(-1130,-768)">' + rings(1130, 768, 0, 0, band=(30, 40, 40, 50), sw=16) + boxer(1130, "#c9452f", "#d8382a", -1) + '</g>')
mini.append('</svg>')
sb.append(f'<div class="sb" style="top:388px;height:446px"><div class="abs sbh" style="left:12px;top:8px">3 &middot; ROUND 3, 1:00 LEFT: ON THE ROPES</div></div>')
sb.append("".join(mini))
sb.append(f'<div class="abs cap" style="left:1742px;top:420px;width:156px">Pinned on the ropes: the legs ring is almost empty, the feet lose the steering.</div>')
sb.append(ours(1482, 548, 1.0, S3))
sb.append(f'<div class="abs cap" style="left:1484px;top:818px;width:410px;font-size:16px">&nbsp;</div>')

fb = 16 + 1080 * 0.75
note = (f'<div class="note" style="top:{fb + 12:.0f}px">'
        f'<div><span class="k">NEW</span><b>HANDS</b> (Coast / Steady / Push) spends <b>WIND</b>; <b>FEET</b> (Press / Hold / Move) spends <b>LEGS</b> and picks where it is fought; '
        f'<b>HEAD</b> has no control and never comes back. Set in the minute for free; a change in the round is one of the two shouts. Floor rings under the feet: wind outside, legs inside, '
        f'drawn before the bodies, hidden during a count. Lines: wind 40 push worth nothing, 35 gassed; legs 30 gone; head 60 a count can finish it. One pulse: the line about to be crossed.</div>'
        f'<div><span class="k">REPLACES</span>The plates&#39; energy / legs / guard bars, "lasts to R3", the two body holograms, the PACE and AIM rows and the "From the next exchange" box.</div>'
        f'<div><span class="k">AS TODAY</span>Scoreboard, round dots, the calls, Say nothing, the clock, the landed box, speed and skip. Big frame = state 2, mid-round.</div>'
        f'<div><span class="k">DECISION</span>Which tank to spend tonight, and against whom: wind refills in the minute, legs barely, the head never. Numbers: ops/research/PUSHTANK_MAP_V2_S442.md.</div></div>')

body = game + "".join(sb) + note
for mm in re.finditer(r"font:\s*(?:\d+\s+)?(\d+)px|font-size:\s*(\d+)px", game):
    v = int(mm.group(1) or mm.group(2))
    assert v * 0.75 >= 16, ("scaled text under 16 px", mm.group(0))
for mm in re.finditer(r"font:\s*(?:\d+\s+)?(\d+)px|font-size:\s*(\d+)px", "".join(sb) + note):
    assert int(mm.group(1) or mm.group(2)) >= 16, ("text under 16 px", mm.group(0))
alltext = html.unescape(" ".join(re.findall(r">([^<]+)<", body)))
bad = re.findall(r"\b(he|she|her|him|his|hers|herself|himself|engine)\b", alltext, re.I)
assert not bad, bad
OUT.write_text(f'<!doctype html><html><head><meta charset="utf-8"><title>Hands and feet</title><style>{CSS}</style></head><body>{body}</body></html>', encoding="utf-8")
print(OUT, OUT.stat().st_size)
