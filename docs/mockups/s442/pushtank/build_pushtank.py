"""S442 PUSHTANK drawing: the Push switch and the tank beside each fighter (ops/research/PUSHTANK_MAP_S442.md).
Three states: the corner minute refilling (switch off), Push on with the ghost of the next exchange, near empty.
Numbers from the game's rules (quoted beside each); readouts worked out below. Writes fight_bars.html beside this file;
render with: python tools/render_mockup.py docs/mockups/s442/pushtank/fight_bars.html"""
import base64, html, pathlib, re

ROOT = pathlib.Path(__file__).resolve().parents[4]
OUT = pathlib.Path(__file__).resolve().parent / "fight_bars.html"
E = html.escape


def b64(p):
    return base64.b64encode(pathlib.Path(p).read_bytes()).decode()


FONTS = ""
for fam, w, f in (("Barlow", 500, "Barlow-Medium"), ("Barlow", 600, "Barlow-SemiBold"), ("Barlow", 700, "Barlow-Bold"),
                  ("Bebas", 400, "BebasNeue-Regular")):
    FONTS += "@font-face{font-family:%s;font-weight:%d;src:url(data:font/ttf;base64,%s)}" % (fam, w, b64(ROOT / ("assets/fonts/%s.ttf" % f)))

INK, SOFT = "#f3ece2", "#b8a88f"
GOLD, AMBER, REDW, GOOD = "#f5c242", "#f0a020", "#e06060", "#6cc27a"
RED, BLUE = "#e0503c", "#4278e0"
WEAR = "#5b5550"

# ---- the rules the readouts use (CODE unless marked) -------------------------------------------------------------
DRAIN = 5.0          # Combos.round_spend at Stamina 55, no drilled combinations: (18 + 54 x 0.22 x 1.05) x 0.98 / 6
PUSH = 1.35          # PaceAim.PACE_SPEND push
MINUTE = 15.0        # Combos.refill (52% of 60% of a 30 round, x1.0) ~9 + two water points x3 (CornerJobs): ESTIMATE
TIRED = 35.0         # Exchanges.SHE_TIRED
PUSH_FADE = 55.0     # PaceAim.PUSH_GAS_FROM


def lasts(fuel, ex_round, rounds_after, rate):
    """(+spare exchanges past the final bell) or (-exchanges tired before it), at a steady rate, the minute refilling."""
    total = ex_round + 6 * rounds_after
    e, k = fuel, 0
    for r in range(rounds_after + 1):
        n = ex_round if r == 0 else 6
        if r > 0:
            e += MINUTE
        for _ in range(n):
            e -= rate
            k += 1
            if e < TIRED:
                return -(total - k + 1)
    return int((e - TIRED) / DRAIN)


def words(v, push):
    if v >= 0:
        return ("To the final bell: %d spare" % v) if v else "To the final bell: just"
    return "%s %d exchange%s early" % ("Push: tired" if push else "Tired", -v, "" if v == -1 else "s")


# state 1: the bell after round 1, switch off: 69 at the bell + the minute
S1 = {"fuel": 69.0, "refill": MINUTE, "wear": 4.8, "on": False}      # 4 body shots x Exchanges.BODY_COST 1.2
S1["read"] = words(lasts(S1["fuel"] + MINUTE, 6, 1, DRAIN), False)
# state 2: round 2, two exchanges gone (84 - 2 x 5 = 74), pointer on / switch on: the ghost is one push exchange
S2 = {"fuel": 74.0, "ghost": DRAIN * PUSH, "wear": 4.8, "on": True}
S2["read"] = words(lasts(S2["fuel"], 4, 1, DRAIN * PUSH), True)
S2["off"] = words(lasts(S2["fuel"], 4, 1, DRAIN), False)
# state 3: round 3, three exchanges left, Push on at 41: the push fades (12 x (55 - 41) / 30 = 5.6 of its 6)
S3 = {"fuel": 41.0, "ghost": DRAIN * PUSH, "wear": 9.6, "on": True}
S3["read"] = words(lasts(S3["fuel"], 3, 0, DRAIN * PUSH), True)
GAS = 12.0 * (PUSH_FADE - S3["fuel"]) / 30.0
# the opponent on film (SidePanel.NARROW 6): true 51, their wear 7 body shots x 1.2
OPP = {"lo": 48.0, "hi": 54.0, "wear": 8.4}
print("S1", S1["read"], "| S2", S2["read"], "/", S2["off"], "| S3", S3["read"], "push left %.1f" % (6 - GAS))

CSS = FONTS + f"""
*{{box-sizing:border-box;margin:0;padding:0}}
html,body{{width:1920px;height:1080px;overflow:hidden;background:#070605}}
body{{position:relative;font-family:Barlow,sans-serif;color:{INK}}}
.abs{{position:absolute}}
.game{{position:absolute;left:16px;top:16px;width:1920px;height:1080px;transform:scale(.75);transform-origin:0 0;overflow:hidden;border-radius:4px;
 background:linear-gradient(#1a1512 0,#2a2018 30%,#1a1410 40%)}}
.pn{{position:absolute;background:rgba(18,14,11,.88);border:1px solid #4a3a30;border-radius:8px}}
.seg{{display:inline-flex;align-items:center;justify-content:center;border:2px solid #5a4636;background:linear-gradient(#3a2d22,#241b14);color:#efe6d8;font-weight:700}}
.seg.on{{background:linear-gradient(#e8d9bd,#cdb994);color:#2a2018;border-color:#f3e6c8}}
.chip{{display:inline-flex;align-items:center;justify-content:center;border:2px solid #5a4636;border-radius:5px;background:#241b14;color:#efe6d8;font-weight:600}}
.chip.on{{background:#e8d9bd;color:#2a2018;border-color:#f3e6c8}}
.hatch{{background:repeating-linear-gradient(135deg,rgba(245,194,66,.85) 0 5px,rgba(30,22,16,.9) 5px 10px)}}
.sb{{position:absolute;left:1472px;width:432px;border-radius:6px;background:linear-gradient(#211913,#120d0a);border:1px solid #3a3532}}
.sbh{{font:700 17px Barlow;letter-spacing:1px;color:#e8ddd0;white-space:nowrap}}
.cap{{font:500 16px/20px Barlow;color:#d8cfc4}}
.cap b{{color:#fff}}
.sticky{{position:absolute;background:#ffd95a;color:#2a2018;border-radius:3px;box-shadow:0 3px 0 #c9a227;padding:8px 12px}}
.note{{position:absolute;left:16px;width:1888px;background:#141a22;border:2px dashed #5d7896;border-radius:6px;padding:10px 14px;
 font:500 18px/25px Barlow;color:#cfd9e4}}
.note b{{color:#fff}}.note .k{{display:inline-block;width:112px;font:700 18px Barlow;color:#8fbcff;letter-spacing:1px}}
@keyframes none{{}}
"""


def tank(x, y, w, h, fuel, wear, ghost=0.0, refill=0.0, col=GOLD, rng=None, pulse=False, k=1.0, ticks=((55, ""), (35, "tired"))):
    """The tank bar: fuel (gold), a hatched ghost of the next exchange, a refill slice, the grey wear end, ticks 55 and 35."""
    px = lambda v: w * v / 100.0
    o = [f'<div class="abs" style="left:{x}px;top:{y}px;width:{w}px;height:{h}px;background:#1b1512;border:1px solid #4a3a30;border-radius:3px;overflow:hidden">']
    if rng:
        lo, hi = rng
        o.append(f'<div class="abs" style="left:0;top:0;width:{px(lo):.0f}px;height:{h}px;background:{col}"></div>'
                 f'<div class="abs" style="left:{px(lo):.0f}px;top:0;width:{px(hi - lo):.0f}px;height:{h}px;background:{col};opacity:.45"></div>')
    else:
        solid = fuel - ghost
        o.append(f'<div class="abs" style="left:0;top:0;width:{px(solid):.0f}px;height:{h}px;background:{col}"></div>')
        if ghost:
            o.append(f'<div class="abs hatch" style="left:{px(solid):.0f}px;top:0;width:{px(ghost):.0f}px;height:{h}px"></div>')
        if refill:
            o.append(f'<div class="abs" style="left:{px(fuel):.0f}px;top:0;width:{px(refill):.0f}px;height:{h}px;background:#fbe6a8;opacity:.9"></div>')
    o.append(f'<div class="abs" style="left:{px(100 - wear):.0f}px;top:0;width:{px(wear) + 1:.0f}px;height:{h}px;background:{WEAR}"></div>')
    o.append('</div>')
    for v, lab in ticks:
        tx = x + px(v)
        glow = f";box-shadow:0 0 0 {4 * k:.0f}px rgba(224,96,96,.35),0 0 {14 * k:.0f}px rgba(224,96,96,.8)" if pulse and v == 35 else ""
        c = REDW if lab else "#d8cfc4"
        o.append(f'<div class="abs" style="left:{tx - 1.5:.0f}px;top:{y - 5 * k:.0f}px;width:3px;height:{h + 10 * k:.0f}px;background:{c}{glow}"></div>')
        if lab:
            o.append(f'<div class="abs" style="left:{tx - 30 * k:.0f}px;top:{y + h + 5 * k:.0f}px;width:{60 * k:.0f}px;text-align:center;font:600 {round(16 * k)}px Barlow;color:{c}">{lab}</div>')
    return "".join(o)


def ours(x, y, k, s, title="LUCY JACKSON", aim="Own game", hover=False):
    """Our panel: name, the PUSH switch + AIM, the tank, the readout. k scales it (1.4 inside the 0.75 game frame)."""
    f = lambda n: round(n * k)
    w = f(410)
    bw = f(380)
    col = GOLD
    if s["on"] and s["fuel"] < PUSH_FADE:
        col = AMBER
    if s["fuel"] < TIRED + 8:
        col = AMBER
    o = [f'<div class="pn" style="left:{x}px;top:{y}px;width:{w}px;height:{f(196)}px"></div>',
         f'<div class="abs" style="left:{x + f(14)}px;top:{y + f(8)}px;font:700 {f(24)}px Barlow;color:#fff;white-space:nowrap">{title}</div>']
    sy = y + f(46)
    o.append(f'<div class="abs" style="left:{x + f(14)}px;top:{sy + f(6)}px;font:700 {f(16)}px Barlow;letter-spacing:1px;color:{SOFT}">PUSH</div>')
    for i, (t, on) in enumerate((("ON", s["on"]), ("OFF", not s["on"]))):
        ring = f";outline:{f(3)}px dashed {GOLD};outline-offset:-5px" if hover and t == "ON" else ""
        rad = f"border-radius:{f(5)}px 0 0 {f(5)}px" if i == 0 else f"border-radius:0 {f(5)}px {f(5)}px 0;border-left:none"
        o.append(f'<div class="abs seg{" on" if on else ""}" style="left:{x + f(60) + i * f(52)}px;top:{sy}px;width:{f(52)}px;height:{f(32)}px;{rad};font-size:{f(17)}px{ring}">{t}</div>')
    ax = x + f(174)
    o.append(f'<div class="abs" style="left:{ax}px;top:{sy + f(6)}px;font:700 {f(16)}px Barlow;letter-spacing:1px;color:{SOFT}">AIM</div>')
    cx = ax + f(38)
    for t, wd in (("Own game", 80), ("Body", 48), ("Head", 48)):
        o.append(f'<div class="abs chip{" on" if t == aim else ""}" style="left:{cx}px;top:{sy}px;width:{f(wd)}px;height:{f(32)}px;font-size:{f(16)}px">{t}</div>')
        cx += f(wd) + f(3)
    ty = y + f(98)
    o.append(f'<div class="abs" style="left:{x + f(14)}px;top:{ty - f(4)}px;font:700 {f(16)}px Barlow;letter-spacing:1px;color:{SOFT}">TANK</div>'
             f'<div class="abs" style="left:{x + f(14) + bw - f(40)}px;top:{ty - f(4)}px;width:{f(40)}px;text-align:right;font:700 {f(16)}px Barlow;color:#fff">{round(s["fuel"] + s.get("refill", 0))}</div>')
    o.append(tank(x + f(14), ty + f(18), bw, f(22), s["fuel"], s["wear"], s.get("ghost", 0.0), s.get("refill", 0.0), col, None, s.get("pulse", False), k))
    rc = GOOD if not s["read"].startswith(("Push", "Tired")) else (REDW if "1 exchange" in s["read"] or s["fuel"] < 45 else AMBER)
    o.append(f'<div class="abs" style="left:{x + f(14)}px;top:{y + f(162)}px;font:700 {f(19)}px Barlow;color:{rc};white-space:nowrap">{E(s["read"])}</div>')
    return "".join(o)


def theirs(x, y, k, title="MARIA ORTEGA", line="Pressing &middot; on film", read="Tiring under 45: about 1 exchange"):
    f = lambda n: round(n * k)
    w = f(410)
    bw = f(380)
    o = [f'<div class="pn" style="left:{x}px;top:{y}px;width:{w}px;height:{f(196)}px"></div>',
         f'<div class="abs" style="left:{x + f(14)}px;top:{y + f(8)}px;font:700 {f(24)}px Barlow;color:#fff;white-space:nowrap">{title}</div>',
         f'<div class="abs" style="left:{x + f(14)}px;top:{y + f(50)}px;font:600 {f(19)}px Barlow;color:#8fbcff;white-space:nowrap">{line}</div>']
    ty = y + f(98)
    o.append(f'<div class="abs" style="left:{x + f(14)}px;top:{ty - f(4)}px;font:700 {f(16)}px Barlow;letter-spacing:1px;color:{SOFT}">TANK</div>'
             f'<div class="abs" style="left:{x + f(14) + bw - f(70)}px;top:{ty - f(4)}px;width:{f(70)}px;text-align:right;font:700 {f(16)}px Barlow;color:#fff">{OPP["lo"]:.0f}-{OPP["hi"]:.0f}</div>')
    o.append(tank(x + f(14), ty + f(18), bw, f(22), OPP["hi"], OPP["wear"], col=GOLD, rng=(OPP["lo"], OPP["hi"]), k=k, ticks=((45, "tiring"),)))
    o.append(f'<div class="abs" style="left:{x + f(14)}px;top:{y + f(162)}px;font:700 {f(19)}px Barlow;color:{GOOD};white-space:nowrap">{read}</div>')
    return "".join(o)


def ring():
    o = ['<svg class="abs" style="left:0;top:0" width="1920" height="1080" viewBox="0 0 1920 1080">'
         '<polygon points="470,430 1450,430 1920,900 0,900" fill="#2f63c8"/><polygon points="0,900 1920,900 1920,1080 0,1080" fill="#1f2f6a"/>'
         '<polygon points="470,430 1450,430 1460,445 460,445" fill="#24489a"/>']
    for kk, yy in enumerate((300, 345, 390)):
        c = "#d94a3a" if kk == 1 else "#e8e4dc"
        o.append(f'<line x1="470" y1="{yy}" x2="1450" y2="{yy}" stroke="{c}" stroke-width="5"/>'
                 f'<line x1="470" y1="{yy}" x2="0" y2="{yy + 300}" stroke="{c}" stroke-width="6"/>'
                 f'<line x1="1450" y1="{yy}" x2="1920" y2="{yy + 300}" stroke="{c}" stroke-width="6"/>')
    o.append('<rect x="458" y="270" width="24" height="170" rx="4" fill="#d23a2c"/><rect x="1438" y="270" width="24" height="170" rx="4" fill="#2f63c8"/>')
    for cx, col, glove, face in ((900, "#2f55b8", "#2a5ad8", 1), (1130, "#c9452f", "#d8382a", -1)):
        o.append(f'<rect x="{cx - 38}" y="440" width="76" height="160" rx="30" fill="{col}"/>'
                 f'<rect x="{cx - 34}" y="590" width="30" height="170" rx="12" fill="{col}" opacity=".85"/><rect x="{cx + 4}" y="590" width="30" height="170" rx="12" fill="{col}" opacity=".85"/>'
                 f'<ellipse cx="{cx - 22}" cy="768" rx="26" ry="12" fill="#111"/><ellipse cx="{cx + 22}" cy="768" rx="26" ry="12" fill="#111"/>'
                 f'<circle cx="{cx + face * 6}" cy="404" r="34" fill="#6b4632"/>'
                 f'<circle cx="{cx + face * 46}" cy="408" r="22" fill="{glove}"/><circle cx="{cx + face * 30}" cy="446" r="22" fill="{glove}"/>')
    o.append('</svg>')
    return "".join(o)


g = ['<div class="abs" style="left:0;top:0;width:1920px;height:440px;background:radial-gradient(circle at 20% 60%,#3a2c22 0 4%,transparent 4.5%),radial-gradient(circle at 75% 55%,#40302a 0 4%,transparent 4.5%)"></div>', ring()]
# our panel (state 2, the pointer on ON) and theirs, where today's name plates sit
g.append(ours(24, 18, 1.4, S2, hover=True, aim="Body"))
g.append(theirs(1322, 18, 1.4))
# the scoreboard (as today)
g.append('<div class="abs" style="left:640px;top:0;width:640px;height:168px;background:#2a2622;border:10px solid #6b4a2b;border-top:none;border-radius:0 0 8px 8px"></div>'
         '<div class="abs" style="left:640px;top:12px;width:640px;text-align:center;font:600 24px Barlow;color:#d8cfc4">ROUND 2 / 3</div>'
         '<div class="abs" style="left:640px;top:40px;width:640px;text-align:center;font:500 64px Barlow;color:#fff">2:00</div>')
dots = "".join(f'<span style="display:inline-block;width:26px;height:26px;border-radius:13px;background:{c};margin:0 9px"></span>'
               for c in (RED, BLUE, "#3a3532", "#3a3532", "#3a3532", "#3a3532"))
g.append(f'<div class="abs" style="left:640px;top:122px;width:640px;text-align:center">{dots}</div>')
# the bottom bar (as today, less the PACE and AIM rows)
g.append('<div class="abs" style="left:16px;top:906px;width:1888px;height:168px;background:linear-gradient(#3a2d22,#2a2018);border-radius:4px;border:2px solid #5a4636"></div>')
g.append('<div class="sticky" style="left:30px;top:918px;width:560px;font:600 22px/26px Barlow">PACE and AIM rows: moved to the panel beside the fighter</div>')
for i, (t, wd, wc) in enumerate((("JAB AND MOVE", "Beats it", "#2f9a55"), ("GO TO THE BODY", "Works", "#c97a10"), ("LET YOUR HANDS GO", "Risky", "#c8312a"))):
    g.append(f'<div class="abs seg" style="left:{28 + i * 288}px;top:996px;width:276px;height:66px;flex-direction:column;border-radius:5px">'
             f'<span style="font:700 22px Barlow">{t}</span><span style="font:700 22px Barlow;color:#fff;background:{wc};padding:0 8px;border-radius:3px">{wd}</span></div>')
g.append('<div class="abs seg" style="left:892px;top:996px;width:110px;height:66px;flex-direction:column;font:600 22px/24px Barlow;border-radius:5px"><span>Say</span><span>nothing</span></div>')
g.append(f'<div class="abs" style="left:1040px;top:930px;width:96px;height:96px;border-radius:48px;border:6px solid #3a3532;border-top-color:{GOLD};display:flex;align-items:center;justify-content:center;font:600 26px Barlow;color:{GOLD}">0:12</div>')
g.append(f'<div class="abs" style="left:1350px;top:918px;width:392px;height:144px;border:2px solid #5a4636;border-radius:4px;padding:6px 12px">'
         f'<div style="font:600 22px Barlow;color:#d8cfc4">LANDED</div><div style="display:flex;gap:30px;align-items:center"><span style="font:700 44px Barlow;color:{BLUE}">9</span>'
         f'<span style="font:700 44px Barlow;color:{RED}">6</span><span style="font:500 22px Barlow;color:#d8cfc4">this round</span></div></div>')
for i, t in enumerate(("2x", "Skip round", "Skip bout")):
    g.append(f'<div class="abs seg" style="left:1756px;top:{918 + i * 50}px;width:136px;height:42px;font:600 22px Barlow;border-radius:5px;opacity:.6">{t}</div>')
# the hover line under our readout (state 2): what Off would leave
g.append(f'<div class="abs" style="left:24px;top:300px;padding:8px 14px;background:rgba(18,14,11,.94);border:2px solid #cdb68a;border-radius:6px;font:600 22px Barlow;color:{INK};white-space:nowrap">'
         f'Hatched: one exchange of Push. With Push off: {E(S2["off"][0].lower() + S2["off"][1:])}.</div>')
game = f'<div class="game">{"".join(g)}</div>'

# ---- the storyboard (1:1): state 1 and state 3; state 2 is the game frame
cards = []
S1c = dict(S1)
cards.append(('1 &middot; THE CORNER MINUTE, PUSH OFF', S1c,
              f'<b>The pit stop.</b> The light slice is what the minute gives back (+{MINUTE:.0f}: the rest and two water points). '
              'It refills up to the grey end and never past it: body shots taken stay gone for the fight.'))
S3c = dict(S3)
S3c["pulse"] = True
cards.append(('3 &middot; ROUND 3, NEAR EMPTY, PUSH STILL ON', S3c,
              f'<b>The warning.</b> Under 55 with Push on the fuel turns amber (the push fades: {6 - GAS:.1f} of its 6 left); '
              'the tired line pulses once the fuel is one exchange away. One pulse on the screen at most.'))
sb = []
yy = 16
for h, s, cap in cards:
    sb.append(f'<div class="sb" style="top:{yy}px;height:{372}px"><div class="abs sbh" style="left:12px;top:10px">{h}</div></div>')
    sb.append(ours(1483, yy + 40, 1.0, s))
    sb.append(f'<div class="abs cap" style="left:1484px;top:{yy + 246}px;width:408px">{cap}</div>')
    yy += 388
sb.append(f'<div class="abs cap" style="left:1472px;top:{yy + 2}px;width:432px"><b>2 &middot; in the game frame:</b> round 2, pointer on ON: the hatched slice is the next exchange at Push, before pressing.</div>')

fb = 16 + 1080 * 0.75
note = (f'<div class="note" style="top:{fb + 12:.0f}px">'
        f'<div><span class="k">NEW</span>Beside each fighter one panel: <b>PUSH on / off</b> and the <b>tank</b> (fuel in gold, the grey end gone for the fight, '
        f'ticks at 55 where Push fades and 35 "tired", the hatched ghost of the next exchange) with one line that says whether it lasts to the final bell. '
        f'The opponent&#39;s panel is read-only: the tank as known from film (a range), their grey end exact, no switch.</div>'
        f'<div><span class="k">REPLACES</span>The plate&#39;s energy / legs / guard bars (legs and guard go to the hover; they are the 3D body, the result never reads them), '
        f'"lasts to R3", the bottom bar&#39;s PACE and AIM rows and the pace and aim lines in "From the next exchange"; Save becomes "Breathe, pick your shots".</div>'
        f'<div><span class="k">AS TODAY</span>Scoreboard, round dots, the calls with Beats it / Works / Risky, Say nothing, the landed box, speed and skip (the body holograms '
        f'are UX proposal C&#39;s business, not drawn).</div>'
        f'<div><span class="k">DECISION</span>Every 30 seconds: is this the moment to spend? The gain lands in the ring and on the opponent&#39;s tank; '
        f'the cost stays on ours, and the corner minute gives back fuel, never the grey end. Numbers: ops/research/PUSHTANK_MAP_S442.md.</div></div>')

body = game + "".join(sb) + note
for mm in re.finditer(r"font:\s*(?:\d+\s+)?(\d+)px|font-size:\s*(\d+)px", game):
    v = int(mm.group(1) or mm.group(2))
    assert v * 0.75 >= 16, ("scaled text under 16 px", mm.group(0))
for mm in re.finditer(r"font:\s*(?:\d+\s+)?(\d+)px|font-size:\s*(\d+)px", "".join(sb) + note):
    assert int(mm.group(1) or mm.group(2)) >= 16, ("text under 16 px", mm.group(0))
alltext = html.unescape(" ".join(re.findall(r">([^<]+)<", body)))
bad = re.findall(r"\b(he|she|her|him|his|hers|herself|himself|engine)\b", alltext, re.I)
assert not bad, bad
OUT.write_text(f'<!doctype html><html><head><meta charset="utf-8"><title>Push and tank</title><style>{CSS}</style></head><body>{body}</body></html>', encoding="utf-8")
print(OUT, OUT.stat().st_size)
