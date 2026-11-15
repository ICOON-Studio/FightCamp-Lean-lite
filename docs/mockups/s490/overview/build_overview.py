"""S490 Overview mockups (operator feedback 2026-11-15-03), review round 2: builds overview_A.html, overview_B.html and
overview_C.html (a lean card for his mark 3, "not sure about this whole thing").
The header, tabs, NEXT STEP strip, the boxer's picture and the bottom row are the real screenshot (embedded); the boxer
column's TIREDNESS and LOYALTY meters, the approach card, the attribute meters and the At a glance panel (redrawn to keep the
alignment) are new HTML.
Run: python docs/mockups/s490/overview/build_overview.py   then   python tools/render_mockup.py <each html>"""
import base64
import io
import json
import math
import pathlib

from PIL import Image, ImageFilter, ImageEnhance, ImageDraw

HERE = pathlib.Path(__file__).resolve().parent
ROOT = HERE.parents[3]
SHOT = ROOT / "ops/Feedback/2026-11-15-03/original.png"

# ---------------------------------------------------------------- numbers (sources in README.md)
LOY_NOW = 31            # her loyalty (screenshot; Loyalty.value)
MATE_NOW = 64           # the team-mate on the stipend: derived from the card (HALF 60 = 64 - 4; MOVE 43 = 64 - 12 - 3*3)
CHANCE10 = 8            # Approach.talk_chance(84) = 0.30 + 0.60 * 0.84 = 0.804 -> "8 in 10"
TALK_FAIL = 4           # Approach.TALK_FAILED -4 (loyalty now, so every 12-week number drops 4)
CEIL = 86               # f["pot"], the white tick
TIRED = 40              # screenshot "40 Fresh"; Aftermath.FRESH_UNDER 50; over 80 training counts 60%
REP_LEAVE = -2          # Leaving.REP_LEAVE (unranked; -5 for a regional top 5)
MATE_LEFT = -2          # Loyalty.MOVES teammate_left, every team-mate under 50 (Leaving.gd:99-101)
SHOW_NET = (100, 2825)  # ClubShow.preview net_lo / net_hi with STAND-IN club numbers (README): 30 members, rep 10, 4 boxers
SHOW_DAY = "Sat 14 Feb"
ANSWERS = [
    dict(id="match", word="MATCH IT", cash=-3000, weekly=250, loy=43, th=100, mate=64, tm=100, note="lock"),
    dict(id="half", word="HALF EACH", cash=0, loy=37, landed=41, th=93, mate=60, tm=93, note="lock"),
    dict(id="move", word="MOVE THE STIPEND", cash=0, loy=43, th=100, mate=43, tm=85, note="dayjob"),
    dict(id="promise", word="PROMISE: OUR SHOW", cash=None, net=SHOW_NET, loy=39, th=100, mate=64, tm=100, note="risk"),
    dict(id="let_go", word="LET THEM GO", cash=0, rep=REP_LEAVE, loy=None, th=None, mate=64, tm=100, note="left"),
]
GROUPS = [
    ("BODY", [("strength", "Strength", 55), ("explosiveness", "Explosiveness", 52), ("speed", "Speed", 66),
              ("stamina", "Stamina", 54), ("recovery", "Recovery", 62), ("flexibility", "Flexibility", 55),
              ("durability", "Durability", 52)]),
    ("BOXING SKILLS", [("accuracy", "Accuracy", 58), ("timing", "Timing", 60), ("defence", "Defence", 57),
                       ("footwork", "Footwork", 58), ("inside", "Inside fighting", 52)]),
    ("MIND", [("fight_iq", "Fight IQ", 54), ("composure", "Composure", 59), ("heart", "Heart", 36),
              ("discipline", "Discipline", 64), ("confidence", "Confidence", 58), ("coachability", "Coachability", 84),
              ("temper", "Temper", None)]),
]
PERSONALITY = {"heart", "discipline", "confidence", "coachability", "temper"}   # AttrBoard.PERSONALITY: no ceiling
LINES = {"stamina": "&#9660; 60 stops her tiring from round 3",
         "discipline": "Disciplined: the truth works: +1.2, not +0.3",
         "confidence": "Confident: a hard talk never sinks the next round"}
ICON_OF = {"strength": "hand-fist", "explosiveness": "zap", "speed": "zap", "stamina": "heart-pulse", "recovery": "refresh-cw",
           "flexibility": "user", "durability": "shield", "accuracy": "target", "timing": "zap", "defence": "shield",
           "footwork": "footprints", "inside": "user", "fight_iq": "brain", "composure": "shield", "heart": "heart",
           "discipline": "clipboard-pen", "confidence": "trending-up", "coachability": "user-check", "temper": "flame"}

ICONS = json.loads((HERE / "icons.json").read_text()) if (HERE / "icons.json").exists() else {}
ICONS.update({
    "coins": '<circle cx="8" cy="8" r="6"/><path d="M18.09 10.37A6 6 0 1 1 10.34 18"/><path d="M7 6h1v4"/><path d="m16.71 13.88.7.71-2.82 2.82"/>',
    "dumbbell": '<path d="M6 5v14"/><path d="M18 5v14"/><path d="M3 8v8"/><path d="M21 8v8"/><path d="M6 12h12"/>',
    "door": '<path d="M13 4h3a2 2 0 0 1 2 2v14"/><path d="M2 20h3"/><path d="M13 20h9"/><path d="M10 12v.01"/><path d="M13 4.562v16.157a1 1 0 0 1-1.242.97L5 20V5.562a2 2 0 0 1 1.515-1.94l4-1A2 2 0 0 1 13 4.561Z"/>',
    "clock": '<circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/>',
    "alert": '<path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3"/><path d="M12 9v4"/><path d="M12 17h.01"/>',
    "talk": '<path d="M7.9 20A9 9 0 1 0 4 16.1L2 22Z"/>',
    "briefcase": '<path d="M16 20V4a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/><rect width="20" height="14" x="2" y="6" rx="2"/>',
    "calendar": '<rect width="18" height="18" x="3" y="4" rx="2"/><path d="M16 2v4"/><path d="M8 2v4"/><path d="M3 10h18"/>',
    "users": '<path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/>',
    "wallet": '<path d="M19 7V4a1 1 0 0 0-1-1H5a2 2 0 0 0 0 4h15a1 1 0 0 1 1 1v4h-3a2 2 0 0 0 0 4h3a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1"/><path d="M3 5v14a2 2 0 0 0 2 2h15a1 1 0 0 0 1-1v-4"/>',
    "battery": '<rect width="16" height="10" x="2" y="7" rx="2" ry="2"/><line x1="22" x2="22" y1="11" y2="13"/>',
})

RED, AMBER, YEL, LIME, GREEN, BLUE, PURPLE = "#e2483d", "#f08a24", "#f2c53d", "#9bd447", "#2fb56e", "#3f7fe0", "#a36cff"
TALKY = "#ffd54a"
GAME_BAND = {"weak": RED, "fair": AMBER, "solid": BLUE, "strong": GREEN, "elite": PURPLE}   # DarkOverview.BAND
SIMS_BAND = {"weak": RED, "fair": AMBER, "solid": YEL, "strong": LIME, "elite": GREEN}       # variant A: the Sims ramp


def band(v):    # AttrBoard.BANDS: under 45 weak, under 55 fair, under 65 solid, under 75 strong, else elite
    for lim, name in ((45, "weak"), (55, "fair"), (65, "solid"), (75, "strong")):
        if v < lim:
            return name
    return "elite"


def loy_tone(v):    # DarkOverview.loyalty: green from 50 (Settled), amber from 25, red under 25 (Leaving)
    return GREEN if v >= 50 else (AMBER if v >= 25 else RED)


def tired_tone(v):  # DarkOverview.condition: green while fresh (under 50), red from 80, amber between
    return GREEN if v < 50 else (RED if v >= 80 else AMBER)


def train_tone(v):
    return GREEN if v >= 100 else AMBER


def ico(name, px=20, col="currentColor", sw=2.0, cls="", fill="none"):
    return (f'<svg class="ico {cls}" width="{px}" height="{px}" viewBox="0 0 24 24" fill="{fill}" stroke="{col}" '
            f'stroke-width="{sw}" stroke-linecap="round" stroke-linejoin="round">{ICONS[name]}</svg>')


def background() -> str:
    im = Image.open(SHOT).convert("RGB")
    box = (478, 272, 1920, 1058)
    reg = im.crop(box).filter(ImageFilter.GaussianBlur(28))
    reg = ImageEnhance.Brightness(reg).enhance(0.55)
    im.paste(reg, box[:2])
    ImageDraw.Draw(im).rectangle((18, 414, 474, 474), fill=(9, 6, 4))   # the old TIREDNESS / LOYALTY meters, redrawn in HTML
    buf = io.BytesIO()
    im.save(buf, "JPEG", quality=86)
    return base64.b64encode(buf.getvalue()).decode()


BASE_CSS = """
*{box-sizing:border-box;margin:0;padding:0}
html,body{width:1920px;height:1080px;overflow:hidden;background:#0b0807}
body{position:relative;font-family:'Barlow',sans-serif;color:#f1e8da}
.bg{position:absolute;inset:0;width:1920px;height:1080px}
.ico{display:inline-block;vertical-align:middle;flex:none}
.panel{position:absolute;border-radius:6px;padding:16px 22px;
  background:radial-gradient(ellipse at 30% 20%,rgba(255,255,255,.035),transparent 60%),
    repeating-linear-gradient(115deg,rgba(255,255,255,.012) 0 3px,transparent 3px 7px),linear-gradient(#1c1b1b,#151413);
  border:10px solid #4a3324;
  box-shadow:inset 0 0 0 2px #2a1c13,inset 0 0 28px rgba(0,0,0,.7),0 0 0 2px #6b4a33,0 6px 16px rgba(0,0,0,.6)}
.panel::before,.panel::after{content:"";position:absolute;width:10px;height:10px;border-radius:50%;
  background:radial-gradient(circle at 35% 35%,#c8b39a,#5b4636);top:-10px;box-shadow:0 0 2px #000}
.panel::before{left:-10px}.panel::after{right:-10px}
.ptitle{font-family:'Barlow';font-weight:700;font-size:23px;color:#ffd54a;letter-spacing:.5px}
.caps{font-weight:700;font-size:14px;letter-spacing:2.5px;color:#c9b9a2}
.soft{color:#c9b9a2}.num{font-weight:700}.red{color:#ff5a4c}
.btn{display:flex;align-items:center;justify-content:center;gap:8px;height:36px;padding:0 14px;border-radius:5px;
  font-weight:700;font-size:15px;letter-spacing:.6px;color:#f6ead8;white-space:nowrap;
  background:linear-gradient(#7a4a35,#4c2b1f);border:1px solid #a26a4c;box-shadow:inset 0 1px 0 rgba(255,255,255,.15),0 2px 3px rgba(0,0,0,.6)}
.btn.talkb{background:linear-gradient(#5a4612,#3a2d0b);border:1px solid #c9a227;color:#ffe9a6;font-size:14px;padding:0 10px}
.chip{display:inline-flex;align-items:center;gap:5px;font-size:14px;font-weight:700;padding:1px 8px;border-radius:4px;white-space:nowrap}
.chip.rep{color:#ffb4a8;background:rgba(226,72,61,.16);border:1px solid rgba(226,72,61,.6)}
.chip.mates{color:#ffcf9a;background:rgba(240,138,36,.12);border:1px solid rgba(240,138,36,.5)}
.chip.off{color:#ff8a7e;border:1px solid #ff8a7e;text-decoration:line-through}
.dl{font-size:15px;font-weight:700}
.coins{display:inline-flex}.coin{display:inline-block;border-radius:50%;background:radial-gradient(circle at 35% 30%,#ffe9a0,#e0a91c 55%,#9a6a07);
  box-shadow:0 0 0 1px #5b3d04}
/* the boxer column's two meters (redrawn) */
.left{position:absolute;left:28px;top:415px;width:440px}
.lrow{display:flex;align-items:center;gap:12px;height:29px}
.lrow .lab{width:112px;font-size:19px;font-weight:700;color:#d8cbb6;letter-spacing:.3px}
.lrow .lv{font-size:24px;font-weight:800;min-width:30px;text-align:right}
.lrow .lw{font-size:19px;font-weight:600;color:#efe4d2}
/* At a glance (redrawn as in the screenshot) */
.glance .row{display:flex;align-items:center;gap:14px;background:rgba(0,0,0,.35);border-left:4px solid #2fb56e;
  border-radius:3px;padding:8px 14px;margin-top:8px;font-size:19px;font-weight:600}
.glance .row b{font-weight:700;font-size:20px}.glance .k{width:112px;flex:none;font-size:17px;color:#e8dccb}
/* attribute captions: condensed so the game's own lines fit at 15px */
.cap2{font-family:'Barlow Condensed';font-weight:600;font-size:15px;color:#c9b9a2;margin:-4px 0 1px 28px;white-space:nowrap;height:18px}
.tchip{font-size:15px;font-weight:700;padding:2px 12px;border:1px solid #2fb56e;border-radius:4px;justify-self:start;grid-column:3/5}
.akey{display:flex;align-items:center;gap:8px;font-size:14px;color:#c9b9a2;margin-left:auto}
"""

GLANCE = """
<div class="panel glance" style="left:1475px;top:{top}px;width:437px;height:{h}px;padding-top:12px">
  <div class="ptitle">AT A GLANCE</div>
  <div class="row"><span class="k">Best</span><b>Coachability, Speed</b></div>
  <div class="row" style="border-color:#f08a24"><span class="k">Work on</span><b>Heart, Durability</b></div>
  <div class="row"><span class="k">Room to grow</span><b>A lot</b></div>
  <div class="row"><span class="k">In the ring</span><b>Stays at range, busy, tires faster</b></div>
  <div class="row" style="border-color:#f08a24"><span class="k">Style</span><b>Out-boxer</b></div>
</div>"""

APPROACH_TOP, APPROACH_H = 280, 398
ATTR_TOP, ATTR_H = 688, 364


def page(title, css, body, bg):
    return f"""<!doctype html><html><head><meta charset="utf-8"><title>{title}</title>
<link href="https://fonts.googleapis.com/css2?family=Barlow:wght@400;500;600;700;800&family=Barlow+Condensed:wght@600;700&display=swap" rel="stylesheet">
<style>{BASE_CSS}{css}</style></head><body>
<img class="bg" src="data:image/jpeg;base64,{bg}" alt="">
{body}
</body></html>"""


def money(n):
    return ("-" if n < 0 else "") + "${:,}".format(abs(n))


def smoney(n):
    return ("+" if n > 0 else "") + money(n)


def delta(now, end, size=15):
    d = end - now
    if d == 0:
        return f'<span class="dl soft" style="font-size:{size + 4}px">=</span>'
    return f'<span class="dl" style="font-size:{size}px;color:{GREEN if d > 0 else "#ff6a5c"}">{"+" if d > 0 else ""}{d}</span>'


def rep_chip():
    return f'<span class="chip rep">{ico("star", 14, "#ffb4a8")}{REP_LEAVE} rep</span>'


def mates_chip(text=None):
    return f'<span class="chip mates">{ico("users", 15, "#ffcf9a")}{text or f"team-mates under 50: {MATE_LEFT}"}</span>'


# ================================================================ VARIANT A: Sims-style need bars
A_CSS = """
.ahead{display:flex;align-items:center;gap:16px;height:58px}
.offer{display:flex;align-items:center;gap:8px;font-size:17px;font-weight:600;background:rgba(255,255,255,.06);
  border:1px solid rgba(255,255,255,.12);border-radius:20px;padding:5px 14px 5px 10px;white-space:nowrap}
.count{margin-left:auto;display:flex;align-items:center;gap:10px}
.count .t1{font-size:17px;font-weight:700;white-space:nowrap}.count .t2{display:flex;gap:6px;align-items:center;margin-top:3px;font-size:15px;color:#ff8a7e;white-space:nowrap}
.grid{display:grid;grid-template-columns:168px 166px 430px 168px 192px 180px;column-gap:12px;margin-top:8px}
.col{display:flex;flex-direction:column;background:rgba(0,0,0,.28);border-radius:6px;padding:0 10px 4px;border:1px solid rgba(255,255,255,.06)}
.col.half{padding:0 0 4px 10px}
.gl{display:flex;align-items:center;gap:8px;font-size:15px;color:#d5c7b1;font-weight:600;line-height:1.1}
.gl.sub{color:#b9aa93;padding-left:26px;font-weight:500}
.cell{display:flex;align-items:center;gap:7px;white-space:nowrap}
.r0{height:46px}.r1{height:32px}.r2{height:28px}.r3{height:50px}.r4{height:32px}.r5{height:28px}.r6{height:44px}
.grp{border-top:1px solid rgba(255,255,255,.07)}
.note{display:flex;flex-direction:column;justify-content:center;gap:2px;font-size:14px;font-weight:600;line-height:1.15}
.note span{display:flex;align-items:center;gap:5px;white-space:nowrap}
.need{position:relative;height:14px;border-radius:7px;background:#0c0b0a;box-shadow:inset 0 1px 3px rgba(0,0,0,.9),0 0 0 1px rgba(255,255,255,.10);flex:none}
.need .z{position:absolute;top:0;bottom:0}
.need .f{position:absolute;top:0;bottom:0;left:0;border-radius:7px;box-shadow:inset 0 3px 0 rgba(255,255,255,.22),inset 0 -2px 0 rgba(0,0,0,.25)}
.need .g{position:absolute;top:0;bottom:0;border-radius:0 7px 7px 0;
  background-image:repeating-linear-gradient(135deg,rgba(255,255,255,.35) 0 3px,transparent 3px 6px)}
.need .tg{position:absolute;top:-1px;bottom:-1px;border:2px dashed #ffd54a;border-left:none;border-radius:0 7px 7px 0}
.need .n50{position:absolute;top:-3px;bottom:-3px;width:2px;background:rgba(255,255,255,.55)}
.need .ft{position:absolute;top:-5px;bottom:-5px;width:3px;background:#ff3b30;border-radius:1px;box-shadow:0 0 0 1px rgba(0,0,0,.6)}
.need .arr{position:absolute;top:-3px;width:0;height:0;border-top:10px solid transparent;border-bottom:10px solid transparent}
.need .c0{position:absolute;top:-4px;bottom:-4px;width:2px;background:#fff}
.need .rf{position:absolute;top:0;bottom:0}
.big{font-size:21px;font-weight:800;min-width:26px;text-align:right}
.mlab{font-size:15px;font-weight:700;margin-top:5px;white-space:nowrap}
.tm{display:flex;align-items:center;gap:6px;font-size:15px;font-weight:700}
.tm .bar{width:72px;height:9px;border-radius:5px;background:#0c0b0a;box-shadow:0 0 0 1px rgba(255,255,255,.1);position:relative;overflow:hidden}
.tm .bar i{position:absolute;left:0;top:0;bottom:0;border-radius:5px}
.hrow{display:flex}.hrow>.l{width:var(--lw,172px);flex:none;padding-right:10px}
.hrow>.t{flex:1;padding:0 10px;background:rgba(255,213,74,.07);border-left:2px dashed rgba(255,213,74,.55);border-right:1px solid rgba(255,213,74,.2)}
.hrow.first>.t{border-top:1px solid rgba(255,213,74,.2);border-radius:0 6px 0 0}
.hrow.last>.t{border-bottom:1px solid rgba(255,213,74,.2);border-radius:0 0 6px 0}
.pips{display:flex;gap:3px}.pip{width:16px;height:16px;border-radius:50%;display:flex;align-items:center;justify-content:center}
.pip.ok{background:#2fb56e;box-shadow:inset 0 -2px 0 rgba(0,0,0,.25)}.pip.no{background:#e2483d;box-shadow:inset 0 -2px 0 rgba(0,0,0,.25)}
.tl{font-size:15px;font-weight:700;display:flex;align-items:center;gap:5px;white-space:nowrap}
/* attributes */
.acols{display:grid;grid-template-columns:286px 262px 320px;column-gap:22px;margin-top:4px}
.arow{display:grid;grid-template-columns:22px 114px 1fr 34px;align-items:center;column-gap:6px;height:31px}
.arow .nm{font-size:17px;font-weight:600;white-space:nowrap}
.arow .v{font-size:22px;font-weight:800;text-align:right}
.sims{position:relative;height:16px;border-radius:8px;background:#0b0a09;box-shadow:inset 0 1px 3px rgba(0,0,0,.9),0 0 0 1px rgba(255,255,255,.10)}
.sims .f{position:absolute;left:0;top:0;bottom:0;border-radius:8px;box-shadow:inset 0 4px 0 rgba(255,255,255,.25),inset 0 -3px 0 rgba(0,0,0,.22)}
.sims .r{position:absolute;top:3px;bottom:3px;border-radius:0 5px 5px 0}
.sims .cap{position:absolute;top:-3px;bottom:-3px;width:2px;border-radius:1px}
.sims .nt{position:absolute;top:-7px;width:0;height:0;border-left:5px solid transparent;border-right:5px solid transparent;border-top:6px solid #fff}
"""


def need(now, end, width=140, zones=True, h=14, fail=None, talk_to=None, notch=50, tone=loy_tone):
    """A Sims need bar 0-100: solid to `now`, striped ghost to `end`, arrow at `end`. Loyalty zones tint the track.
    fail: a red tick where this answer lands if the talk fails. talk_to: a dashed yellow ghost on to the talk's number."""
    pct = lambda v: v * width / 100.0
    z = ""
    if zones:
        z = (f'<i class="z" style="left:0;width:{pct(25)}px;background:rgba(226,72,61,.20);border-radius:7px 0 0 7px"></i>'
             f'<i class="z" style="left:{pct(25)}px;width:{pct(25)}px;background:rgba(240,138,36,.13)"></i>'
             f'<i class="z" style="left:{pct(50)}px;width:{pct(50)}px;background:rgba(47,181,110,.12);border-radius:0 7px 7px 0"></i>')
    if notch is not None:
        z += f'<i class="n50" style="left:{pct(notch) - 1}px"></i>'
    lo = min(now, end)
    s = f'<div class="need" style="width:{width}px;height:{h}px">{z}<i class="f" style="width:{pct(lo)}px;background:{tone(lo)}"></i>'
    if end > now:
        c = tone(end)
        s += f'<i class="g" style="left:{pct(now)}px;width:{pct(end - now)}px;background-color:{c}99"></i>'
        if talk_to:
            s += f'<i class="tg" style="left:{pct(end)}px;width:{pct(talk_to - end)}px"></i>'
        s += f'<i class="arr" style="left:{pct(talk_to or end) - 1}px;border-left:9px solid {TALKY if talk_to else c}"></i>'
    elif end < now:
        s += (f'<i class="g" style="left:{pct(end)}px;width:{pct(now - end)}px;background-color:#e2483d55;'
              f'background-image:repeating-linear-gradient(135deg,rgba(226,72,61,.9) 0 3px,transparent 3px 6px)"></i>')
    if fail is not None:
        s += f'<i class="ft" style="left:{pct(fail) - 1.5}px"></i>'
    return s + "</div>"


def cash_meter(a, width=154, h=12):
    """Money as a two-way Sims bar: the centre is $0; red to the left is paid out, green to the right comes back.
    $3,500 a side (the show's price, the dearest answer)."""
    half = width / 2.0
    sc = half / 3500.0
    s = f'<div class="need" style="width:{width}px;height:{h}px;border-radius:6px">'
    if a.get("cash"):
        w = -a["cash"] * sc
        s += f'<i class="rf" style="left:{half - w}px;width:{w}px;background:linear-gradient(90deg,#ff5a4c,#c23a2f);border-radius:6px 0 0 6px"></i>'
    if a.get("net"):
        lo, hi = a["net"]
        s += (f'<i class="rf" style="left:{half + lo * sc}px;width:{(hi - lo) * sc}px;border-radius:0 6px 6px 0;'
              f'background:linear-gradient(90deg,rgba(47,181,110,.25),#2fb56e)"></i>')
    s += f'<i class="c0" style="left:{half - 1}px"></i></div>'
    if a.get("cash"):
        lab = f'<span style="color:#ff8a7e">{money(a["cash"])}</span> <span class="soft" style="font-weight:600">{money(a["weekly"])} a week</span>'
    elif a.get("net"):
        lab = f'<span style="color:#6fe3a0">{smoney(a["net"][0])} to {smoney(a["net"][1])}</span>'
    else:
        lab = '<span class="soft" style="font-weight:600">no cash</span>'
        if a.get("rep"):
            lab += f' &nbsp;{rep_chip()}'
    return f'<div style="display:flex;flex-direction:column;justify-content:center">{s}<div class="mlab">{lab}</div></div>'


def tmeter(v):
    if v is None:
        return '<span class="soft">-</span>'
    col = train_tone(v)
    return f'<span class="tm"><span class="bar"><i style="width:{v}%;background:{col}"></i></span><span style="color:{col}">{v}%</span></span>'


def countdown_ring(days=7, left=7, px=54):
    segs = ""
    r, cx = px / 2 - 5, px / 2
    for i in range(days):
        a0 = -math.pi / 2 + i * 2 * math.pi / days + 0.07
        a1 = -math.pi / 2 + (i + 1) * 2 * math.pi / days - 0.07
        x0, y0 = cx + r * math.cos(a0), cx + r * math.sin(a0)
        x1, y1 = cx + r * math.cos(a1), cx + r * math.sin(a1)
        col = "#ffb02e" if i < left else "rgba(255,255,255,.12)"
        segs += f'<path d="M{x0:.1f} {y0:.1f} A{r} {r} 0 0 1 {x1:.1f} {y1:.1f}" stroke="{col}" stroke-width="6" fill="none"/>'
    return (f'<svg width="{px}" height="{px}">{segs}<text x="{cx}" y="{cx + 8}" text-anchor="middle" font-family="Barlow" '
            f'font-weight="800" font-size="24" fill="#fff">{left}</text></svg>')


def a_note(a):
    if a["note"] == "lock":
        return f'<div class="note r6 soft"><span>{ico("lock", 15, "#c9b9a2")}Locked for 12 weeks</span></div>'
    if a["note"] == "dayjob":
        return (f'<div class="note r6 soft"><span>{ico("briefcase", 15, "#c9b9a2")}He takes a day job</span>'
                f'<span>{ico("lock", 15, "#c9b9a2")}Locked for 12 weeks</span></div>')
    if a["note"] == "risk":
        return (f'<div class="note r6"><span style="color:#ffb02e">{ico("alert", 15, "#ffb02e")}Miss 14 Feb: she goes</span>'
                f'<span class="soft">{ico("wallet", 15, "#c9b9a2")}Her keep stays unpaid</span></div>')
    return (f'<div class="note r6" style="color:#ffcf9a"><span>{ico("users", 15, "#ffcf9a")}Team-mates under 50:</span>'
            f'<span style="padding-left:20px">loyalty {MATE_LEFT}</span></div>')


def a_head():
    return f"""
  <div class="ahead">
    <div class="ptitle red" style="font-size:25px;white-space:nowrap">EASTSIDE ABC WANTS KIRA MENSAH</div>
    <div class="offer">{ico("coins", 18, "#ffcf4a")}Full time: Eastside's backers pay the keep</div>
    <div class="count">{countdown_ring()}<div><div class="t1">DAYS TO ANSWER &middot; by Mon 19 Jan</div>
      <div class="t2">{ico("door", 16, "#ff8a7e")}No answer: she goes {rep_chip()}{mates_chip()}</div></div></div>
  </div>"""


def a_gutter():
    return f"""<div style="display:flex;flex-direction:column">
      <div class="r0"></div>
      <div class="gl r1">{ico("heart", 18, "#ff6a8a")}Her loyalty, 12 wks</div>
      <div class="gl sub r2">Her training</div>
      <div class="gl r3 grp">{ico("coins", 18, "#ffcf4a")}Cost</div>
      <div class="gl r4 grp">{ico("heart", 18, "#8fd0ff")}<span>Stipend team-mate:<br>loyalty, 12 wks</span></div>
      <div class="gl sub r5">His training</div>
      <div class="r6"></div>
    </div>"""


def a_cells(a, fail=True, bar=94):
    """The six aligned cells of one answer column (her loyalty, her training, cost, his loyalty, his training, note)."""
    if a["loy"] is None:
        loy = f'<div class="cell r1" style="color:#ff6a5c;font-weight:700;font-size:15px">{ico("door", 18, "#ff6a5c")}Leaves next Monday</div>'
    else:
        f = a["loy"] - TALK_FAIL if (fail and a["id"] in ("match", "move", "promise")) else None
        loy = (f'<div class="cell r1">{need(LOY_NOW, a["loy"], bar, fail=f)}<span class="big" style="color:{loy_tone(a["loy"])}">{a["loy"]}</span>'
               f'{delta(LOY_NOW, a["loy"])}</div>')
    her_t = f'<div class="cell r2">{tmeter(a["th"])}</div>'
    cost = f'<div class="cell r3 grp">{cash_meter(a, bar + 56)}</div>'
    mate = (f'<div class="cell r4 grp">{need(MATE_NOW, a["mate"], bar)}<span class="big" style="color:{loy_tone(a["mate"])}">{a["mate"]}</span>'
            f'{delta(MATE_NOW, a["mate"])}</div>')
    his_t = f'<div class="cell r5">{tmeter(a["tm"])}</div>'
    return [loy, her_t, cost, mate, his_t, a_note(a)]


def a_half_col(a, bar=86, lw=172, fail_line="all answers drop to the red tick"):
    """HALF EACH with its optional upgrade, TELL IT STRAIGHT, drawn as a yellow side-box on the same rows."""
    pips = "".join(f'<span class="pip {"ok" if i < CHANCE10 else "no"}">{ico("check" if i < CHANCE10 else "x", 11, "#0d1a10" if i < CHANCE10 else "#2a0806", 3.4)}</span>' for i in range(10))
    loy = (f'<div class="cell">{need(LOY_NOW, a["loy"], bar, talk_to=a["landed"])}<span class="big" style="color:{loy_tone(a["loy"])}">{a["loy"]}</span>'
           f'{delta(LOY_NOW, a["loy"])}</div>')
    cells = a_cells(a, False, bar)
    talk = [
        f'<div class="btn talkb" style="width:100%">{ico("talk", 16)}+ TELL IT STRAIGHT FIRST</div>',
        f'<div class="tl" style="color:#5fe39a">{ico("check", 15, "#5fe39a", 3)}lands: <span style="color:{loy_tone(41)};font-size:20px;font-weight:800">{a["landed"]}</span>{delta(LOY_NOW, a["landed"])}</div>',
        f'<div class="pips">{pips}</div>',
        f'<div class="tl soft" style="font-weight:600">{ico("coins", 15, "#c9b9a2")}no cash</div>',
        f'<div class="tl" style="color:#ff6a5c">{ico("x", 15, "#ff6a5c", 3)}fails: her loyalty {-TALK_FAIL} now</div>',
        f'<div class="tl" style="color:#ffb4a8;font-weight:600"><i style="display:inline-block;width:3px;height:16px;background:#ff3b30"></i>{fail_line}</div>',
        f'<div class="tl" style="color:#ffb4a8;font-weight:600"><span class="chip off">HALF EACH</span> closes</div>',
    ]
    left = [f'<div class="btn" style="margin-left:-10px;width:calc(100% + 10px)">{a["word"]}</div>', loy] + cells[1:]
    rows = ""
    hs = [46, 32, 28, 50, 32, 28, 44]
    for i, (l, t) in enumerate(zip(left, talk)):
        cls = "hrow" + (" first" if i == 0 else "") + (" last" if i == 6 else "")
        grp = " grp" if i in (3, 4) else ""
        rows += (f'<div class="{cls}" style="height:{hs[i]}px"><div class="l{grp}" style="display:flex;align-items:center">{l}</div>'
                 f'<div class="t" style="display:flex;align-items:center">{t}</div></div>')
    return f'<div class="col half" style="--lw:{lw}px">{rows}</div>'


A_BAR = {"match": 82, "move": 82, "promise": 96, "let_go": 90}


def a_approach():
    cols = ""
    for a in ANSWERS:
        if a["id"] == "half":
            cols += a_half_col(a)
            continue
        btn = f'<div class="r0" style="display:flex;align-items:center;margin:0 -10px"><div class="btn" style="width:100%">{a["word"]}</div></div>'
        cols += f'<div class="col">{btn}{"".join(a_cells(a, bar=A_BAR[a["id"]]))}</div>'
    return f"""
<div class="panel" style="left:484px;top:{APPROACH_TOP}px;width:1428px;height:{APPROACH_H}px;padding-top:10px">
  {a_head()}
  <div class="grid">{a_gutter()}{cols}</div>
</div>"""


def a_left():
    """TIREDNESS and LOYALTY under her name, as the same Sims bars (operator note 4 was general)."""
    tired = need(TIRED, TIRED, 150, zones=False, h=16, notch=50, tone=tired_tone)
    tired = tired.replace('class="need"', 'class="need" data-k="tired"')
    tz = (f'<div style="position:relative">{tired}'
          f'<i style="position:absolute;left:{150 * .8 - 1}px;top:-3px;bottom:-3px;width:2px;background:rgba(226,72,61,.8)"></i></div>')
    loy = need(LOY_NOW, LOY_NOW, 150, zones=True, h=16)
    return f"""
<div class="left">
  <div class="lrow"><span class="lab">TIREDNESS</span>{tz}<span class="lv" style="color:{tired_tone(TIRED)}">{TIRED}</span><span class="lw">Fresh</span></div>
  <div class="lrow"><span class="lab">LOYALTY</span>{loy}<span class="lv" style="color:{loy_tone(LOY_NOW)}">{LOY_NOW}</span><span class="lw">Wavering</span></div>
</div>"""


def a_bar(key, v):
    col = SIMS_BAND[band(v)]
    s = f'<div class="sims"><i class="f" style="width:{v}%;background:linear-gradient({col},{col}cc)"></i>'
    if key not in PERSONALITY:
        s += (f'<i class="r" style="left:{v}%;width:{CEIL - v}%;background:{col}70;box-shadow:inset 0 2px 0 rgba(255,255,255,.18)"></i>'
              f'<i class="cap" style="left:calc({CEIL}% - 1px);background:#fff"></i>')
    if key == "stamina":
        s += '<i class="nt" style="left:calc(60% - 5px)"></i>'
    return s + "</div>"


def attributes(bar_fn, band_cols, key_html):
    cols = ""
    for title, rows in GROUPS:
        body = f'<div class="caps" style="height:20px">{title}</div>'
        for key, name, v in rows:
            icon = ico(ICON_OF[key], 19, "#c9b9a2")
            if v is None:
                body += f'<div class="arow">{icon}<span class="nm">{name}</span><span class="tchip">Patient</span></div>'
                continue
            col = band_cols[band(v)]
            body += f'<div class="arow">{icon}<span class="nm">{name}</span>{bar_fn(key, v)}<span class="v" style="color:{col}">{v}</span></div>'
            if key in LINES:
                body += f'<div class="cap2">{LINES[key]}</div>'
        cols += f"<div>{body}</div>"
    return f"""
<div class="panel" style="left:484px;top:{ATTR_TOP}px;width:976px;height:{ATTR_H}px;padding-top:10px">
  <div style="display:flex;align-items:center;height:30px"><div class="ptitle">ATTRIBUTES</div>{key_html}</div>
  <div class="acols">{cols}</div>
</div>"""


def a_key():
    return (f'<div class="akey"><span style="display:inline-block;width:64px;height:12px;border-radius:6px;'
            f'background:linear-gradient(90deg,{YEL} 0 55%,{YEL}70 55% 100%);box-shadow:0 0 0 1px rgba(255,255,255,.15)"></span>'
            f'now, then room to grow <span style="display:inline-block;width:2px;height:14px;background:#fff"></span> her ceiling {CEIL}</div>')


def build_a(bg):
    body = a_left() + a_approach() + attributes(a_bar, SIMS_BAND, a_key()) + GLANCE.format(top=ATTR_TOP, h=ATTR_H)
    return page("Overview A", A_CSS, body, bg)


# ================================================================ VARIANT B: segmented cells, answers as rows
B_CSS = """
.bhead{display:flex;align-items:center;gap:18px;height:54px}
.offer{display:flex;align-items:center;gap:8px;font-size:17px;font-weight:600;color:#e8dccb;white-space:nowrap}
.cal{margin-left:auto;display:flex;align-items:center;gap:4px}
.day{width:44px;height:50px;border-radius:4px;background:rgba(255,255,255,.07);display:flex;flex-direction:column;align-items:center;justify-content:center;
  font-size:14px;font-weight:700;color:#c9b9a2;border:1px solid rgba(255,255,255,.08);line-height:1.05}
.day b{font-size:19px;color:#f1e8da}
.day.today{background:#ffd54a;color:#3a2a05;border-color:#ffd54a}.day.today b{color:#1a1208}
.day.last{background:#7d1f18;border-color:#ff5a4c;color:#ffd0c8}.day.last b{color:#fff}
.calcap{display:flex;flex-direction:column;gap:3px;margin-left:8px;font-size:15px;color:#ff8a7e;font-weight:600}
.calcap>span{display:flex;align-items:center;gap:6px;white-space:nowrap}
table{border-collapse:separate;border-spacing:0 3px;width:100%;margin-top:4px}
th{font-size:14px;font-weight:700;letter-spacing:1.2px;color:#c9b9a2;text-align:left;padding:0 8px 2px 10px;height:36px;white-space:nowrap;line-height:1.2;vertical-align:bottom}
th .ico{margin-right:5px}
th.grpL{border-left:2px solid rgba(255,255,255,.08)}
td{background:rgba(0,0,0,.30);height:39px;padding:0 10px;vertical-align:middle;white-space:nowrap}
td:first-child{padding:0 10px 0 0;background:none}
td:nth-child(2){border-radius:5px 0 0 5px}td:last-child{border-radius:0 5px 5px 0}
td.grpL{border-left:2px solid rgba(255,255,255,.08)}
.cells{display:inline-flex;gap:3px;vertical-align:middle;position:relative}
.c{width:14px;height:18px;border-radius:3px;background:#0b0a09;box-shadow:inset 0 1px 2px rgba(0,0,0,.9),0 0 0 1px rgba(255,255,255,.09);position:relative;overflow:hidden}
.c.s{width:10px;height:14px;border-radius:2px}
.c i{position:absolute;left:0;top:0;bottom:0}
.c.g{box-shadow:0 0 0 1.5px var(--g),0 0 6px var(--g)}
.c.tk{box-shadow:0 0 0 1.5px #ffd54a;outline:1px dashed #ffd54a}
.cells .ft{position:absolute;top:-5px;bottom:-5px;width:3px;background:#ff3b30;border-radius:1px;box-shadow:0 0 0 1px rgba(0,0,0,.6)}
.n{font-size:21px;font-weight:800;margin-left:10px;vertical-align:middle}
.dl{margin-left:4px;vertical-align:middle}
.amt{font-weight:700;font-size:15px;margin-left:8px;vertical-align:middle}
.mc{display:inline-flex;gap:2px;vertical-align:middle;align-items:center}
.mc .m{width:9px;height:16px;border-radius:2px;background:#0b0a09;box-shadow:inset 0 1px 2px rgba(0,0,0,.9),0 0 0 1px rgba(255,255,255,.09)}
.mc .z{width:2px;height:24px;background:#fff;margin:0 2px}
.trc{display:inline-flex;align-items:center;gap:6px;font-size:15px;font-weight:700;vertical-align:middle}
.note{font-size:14px;font-weight:600;display:flex;align-items:center;gap:5px;line-height:1.15}
.talkrow td{background:rgba(255,213,74,.07);border-top:1px dashed rgba(255,213,74,.5);border-bottom:1px dashed rgba(255,213,74,.5);height:40px}
.talkrow td:first-child{background:none;border:none}
.talkrow td:nth-child(2){border-left:1px dashed rgba(255,213,74,.5)}.talkrow td:last-child{border-right:1px dashed rgba(255,213,74,.5)}
.dice{display:inline-flex;gap:3px;vertical-align:middle}
.die{width:16px;height:19px;border-radius:3px;display:inline-flex;align-items:center;justify-content:center}
.die.ok{background:#2fb56e;box-shadow:inset 0 -3px 0 rgba(0,0,0,.25)}.die.no{background:#e2483d;box-shadow:inset 0 -3px 0 rgba(0,0,0,.25)}
.oc{display:inline-flex;align-items:center;gap:6px;font-size:15px;font-weight:700;white-space:nowrap;vertical-align:middle}
.ans{display:inline-flex;align-items:center;gap:4px;font-size:14px;font-weight:700;padding:1px 6px;border-radius:3px;background:rgba(0,0,0,.4);color:#e8dccb}
/* attributes */
.acols{display:grid;grid-template-columns:286px 262px 320px;column-gap:22px;margin-top:4px}
.arow{display:grid;grid-template-columns:22px 112px 1fr 32px;align-items:center;column-gap:6px;height:31px}
.arow .nm{font-size:17px;font-weight:600;white-space:nowrap}
.arow .v{font-size:22px;font-weight:800;text-align:right}
.seg{display:flex;gap:2px;position:relative}
.sc{flex:1;height:16px;border-radius:2px;background:#0b0a09;box-shadow:inset 0 1px 2px rgba(0,0,0,.9),0 0 0 1px rgba(255,255,255,.08);position:relative;overflow:hidden}
.sc i{position:absolute;left:0;top:0;bottom:0;box-shadow:inset 0 3px 0 rgba(255,255,255,.22)}
.sc.room{box-shadow:inset 0 0 0 1px var(--c)}
.sc.room i.r{background:var(--c);opacity:.32;box-shadow:none}
.sc.past{background:repeating-linear-gradient(135deg,rgba(255,255,255,.06) 0 2px,transparent 2px 5px),#0b0a09}
.seg .nt{position:absolute;top:-7px;width:0;height:0;border-left:5px solid transparent;border-right:5px solid transparent;border-top:6px solid #fff}
"""


def cells(now, end, small=False, fail=None, talk_to=None, tone=loy_tone):
    """Ten cells of 10 points: solid to the lower value, glowing ghost cells up to a gain, red hatched cells for a loss.
    fail: a red tick where this answer lands if the talk fails; talk_to: dashed yellow cells on to the talk's number."""
    out = ""
    lo = min(now, end)
    cw, gap = (10, 3) if small else (14, 3)
    for i in range(10):
        a, b = i * 10, i * 10 + 10
        cls = "c s" if small else "c"
        solid = max(0.0, min(1.0, (lo - a) / 10.0))
        inner = f'<i style="width:{solid * 100:.0f}%;background:{tone(lo)}"></i>' if solid > 0 else ""
        style = ""
        if end > now and b > now and a < end:
            g0 = max(0.0, (now - a) / 10.0)
            g1 = min(1.0, (end - a) / 10.0)
            c = tone(end)
            inner += f'<i style="left:{g0 * 100:.0f}%;width:{(g1 - g0) * 100:.0f}%;background:{c}80"></i>'
            cls += " g"
            style = f' style="--g:{c}"'
        elif talk_to and b > end and a < talk_to:
            g0 = max(0.0, (end - a) / 10.0)
            g1 = min(1.0, (talk_to - a) / 10.0)
            inner += f'<i style="left:{g0 * 100:.0f}%;width:{(g1 - g0) * 100:.0f}%;background:rgba(255,213,74,.35)"></i>'
            cls += " tk"
        if end < now and b > end and a < now:
            g0 = max(0.0, (end - a) / 10.0)
            g1 = min(1.0, (now - a) / 10.0)
            inner += (f'<i style="left:{g0 * 100:.0f}%;width:{(g1 - g0) * 100:.0f}%;'
                      f'background:repeating-linear-gradient(135deg,#e2483d 0 2px,#3a0e0b 2px 5px)"></i>')
        out += f'<span class="{cls}"{style}>{inner}</span>'
    if fail is not None:
        x = (fail // 10) * (cw + gap) + (fail % 10) / 10.0 * cw
        out += f'<i class="ft" style="left:{x - 1.5:.1f}px"></i>'
    return f'<span class="cells">{out}</span>'


def cash_cells(a):
    """Money in $500 cells either side of a white $0 line: red cells paid out, green cells back (the show's net range:
    solid to its bad-luck end, faded to its good-luck end)."""
    left, right = "", ""
    for i in range(7):          # paid out, nearest the line first
        lo_v = i * 500
        fill = "#e2483d" if a.get("cash") and -a["cash"] > lo_v else None
        st = f' style="background:{fill}"' if fill else ""
        left = f'<span class="m"{st}></span>' + left
    for i in range(6):          # back on the night
        lo_v = i * 500
        st = ""
        if a.get("net"):
            nlo, nhi = a["net"]
            if nhi > lo_v:
                f = max(0.0, min(1.0, (nlo - lo_v) / 500.0))
                st = (f' style="background:linear-gradient(90deg,#2fb56e {f * 100:.0f}%,rgba(47,181,110,.38) {f * 100:.0f}%)"' if f < 1
                      else ' style="background:#2fb56e"')
        right += f'<span class="m"{st}></span>'
    meter = f'<span class="mc">{left}<span class="z"></span>{right}</span>'
    if a.get("cash"):
        lab = f'<span class="amt" style="color:#ff8a7e">{money(a["cash"])}</span>'
    elif a.get("net"):
        lab = f'<span class="amt" style="color:#6fe3a0">{smoney(a["net"][0])} to {smoney(a["net"][1])}</span>'
    else:
        lab = '<span class="amt soft" style="font-weight:600">no cash</span>'
    return meter + lab


def b_head():
    days = [("MON", 12), ("TUE", 13), ("WED", 14), ("THU", 15), ("FRI", 16), ("SAT", 17), ("SUN", 18), ("MON", 19)]
    cal = "".join(f'<div class="day{" today" if i == 0 else (" last" if i == 7 else "")}">{d}<b>{n}</b></div>' for i, (d, n) in enumerate(days))
    return f"""
  <div class="bhead">
    <div><div class="ptitle red" style="font-size:25px;white-space:nowrap">EASTSIDE ABC WANTS KIRA MENSAH</div>
      <div class="offer" style="margin-top:2px">{ico("coins", 18, "#ffcf4a")}Full time: Eastside's backers pay the keep</div></div>
    <div class="cal">{cal}<div class="calcap"><span>{ico("door", 16, "#ff8a7e")}No answer by Mon 19: she goes</span>
      <span>{rep_chip()}{mates_chip()}</span></div></div>
  </div>"""


def b_note(a):
    if a["note"] == "lock":
        return f'<span class="note soft">{ico("lock", 15, "#c9b9a2")}Locked for 12 weeks</span>'
    if a["note"] == "dayjob":
        return (f'<span class="note soft">{ico("briefcase", 15, "#c9b9a2")}He takes a day job</span>'
                f'<span class="note soft">{ico("lock", 15, "#c9b9a2")}Locked for 12 weeks</span>')
    if a["note"] == "risk":
        return (f'<span class="note" style="color:#ffb02e">{ico("alert", 15, "#ffb02e")}Miss 14 Feb: she goes</span>'
                f'<span class="note soft">{ico("wallet", 15, "#c9b9a2")}Her keep stays unpaid</span>')
    return (f'<span class="note" style="color:#ffcf9a">{ico("users", 15, "#ffcf9a")}Team-mates under 50:</span>'
            f'<span class="note" style="color:#ffcf9a;padding-left:20px">loyalty {MATE_LEFT}</span>')


def b_approach():
    rows = ""
    for a in ANSWERS:
        btn = f'<div class="btn" style="height:35px;font-size:15px">{a["word"]}</div>'
        if a["loy"] is None:
            loy = f'<span style="color:#ff6a5c;font-weight:700;font-size:16px">{ico("door", 18, "#ff6a5c")} Leaves next Monday</span>'
        else:
            f = a["loy"] - TALK_FAIL if a["id"] in ("match", "move", "promise") else None
            loy = (f'{cells(LOY_NOW, a["loy"], fail=f, talk_to=a.get("landed"))}<span class="n" style="color:{loy_tone(a["loy"])}">{a["loy"]}</span>'
                   f'{delta(LOY_NOW, a["loy"])}')
        her_t = '<span class="soft">-</span>' if a["th"] is None else f'<span class="trc" style="color:{train_tone(a["th"])}">{ico("dumbbell", 15, "#c9b9a2")}{a["th"]}%</span>'
        cost = cash_cells(a)
        if a.get("rep"):
            cost = cost + " " + rep_chip()
        mate = (f'{cells(MATE_NOW, a["mate"], True)}<span class="n" style="font-size:19px;color:{loy_tone(a["mate"])}">{a["mate"]}</span>'
                f'{delta(MATE_NOW, a["mate"])}')
        his_t = f'<span class="trc" style="color:{train_tone(a["tm"])}">{ico("dumbbell", 15, "#c9b9a2")}{a["tm"]}%</span>'
        rows += (f'<tr><td>{btn}</td><td>{loy}</td><td>{her_t}</td><td class="grpL">{cost}</td>'
                 f'<td class="grpL">{mate}</td><td>{his_t}</td><td class="grpL">{b_note(a)}</td></tr>')
        if a["id"] == "half":
            dice = "".join(f'<span class="die {"ok" if i < CHANCE10 else "no"}">{ico("check" if i < CHANCE10 else "x", 13, "#0d1a10" if i < CHANCE10 else "#2a0806", 3.4)}</span>' for i in range(10))
            fails = " ".join(f'<span class="ans">{w} <span style="color:{AMBER}">{n}</span></span>' for w, n in (("MATCH", 39), ("MOVE", 39), ("PROMISE", 35)))
            rows += (f'<tr class="talkrow"><td><div style="display:flex;justify-content:flex-end;padding-right:6px;color:{TALKY};font-size:22px">&#8627;</div></td>'
                     f'<td colspan="6"><div style="display:flex;align-items:center;gap:11px">'
                     f'<div class="btn talkb" style="height:32px">{ico("talk", 16)}+ TELL IT STRAIGHT FIRST: no cash</div>'
                     f'<span class="dice">{dice}</span>'
                     f'<span class="oc" style="color:#5fe39a">{ico("check", 15, "#5fe39a", 3)}lands: '
                     f'<span style="color:{loy_tone(41)};font-size:20px;font-weight:800">{a["landed"]}</span>{delta(LOY_NOW, a["landed"])}</span>'
                     f'<span class="oc" style="color:#ff6a5c">{ico("x", 15, "#ff6a5c", 3)}fails: her loyalty {-TALK_FAIL} now '
                     f'<i style="display:inline-block;width:3px;height:16px;background:#ff3b30"></i> {fails}<span class="chip off">HALF EACH</span></span>'
                     f'</div></td></tr>')
    head = (f'<tr><th></th><th>{ico("heart", 15, "#ff6a8a")}HER LOYALTY<br>IN 12 WEEKS</th><th>HER<br>TRAINING</th>'
            f'<th class="grpL">{ico("coins", 15, "#ffcf4a")}COST<br>(CASH)</th>'
            f'<th class="grpL">{ico("heart", 15, "#8fd0ff")}STIPEND TEAM-MATE:<br>LOYALTY IN 12 WEEKS</th><th>HIS<br>TRAINING</th><th class="grpL"></th></tr>')
    cw = '<colgroup><col style="width:196px"><col style="width:262px"><col style="width:104px"><col style="width:290px"><col style="width:230px"><col style="width:104px"><col></colgroup>'
    return f"""
<div class="panel" style="left:484px;top:{APPROACH_TOP}px;width:1428px;height:{APPROACH_H}px;padding-top:8px">
  {b_head()}
  <table>{cw}{head}{rows}</table>
</div>"""


def b_left():
    tired = cells(TIRED, TIRED, tone=tired_tone)
    loy = cells(LOY_NOW, LOY_NOW)
    mark = lambda v: f'<i style="position:absolute;left:{(v // 10) * 17 - 2.5}px;top:-4px;bottom:-4px;width:2px;background:rgba(255,255,255,.7)"></i>'
    return f"""
<div class="left">
  <div class="lrow"><span class="lab">TIREDNESS</span><span style="position:relative;display:inline-flex">{tired}{mark(50)}</span><span class="lv" style="color:{tired_tone(TIRED)}">{TIRED}</span><span class="lw">Fresh</span></div>
  <div class="lrow"><span class="lab">LOYALTY</span><span style="position:relative;display:inline-flex">{loy}{mark(50)}</span><span class="lv" style="color:{loy_tone(LOY_NOW)}">{LOY_NOW}</span><span class="lw">Wavering</span></div>
</div>"""


def b_bar(key, v):
    col = GAME_BAND[band(v)]
    room = key not in PERSONALITY
    out = ""
    for i in range(10):
        a = i * 10
        fill = max(0.0, min(1.0, (v - a) / 10.0))
        inner = f'<i style="width:{fill * 100:.0f}%;background:{col}"></i>' if fill > 0 else ""
        cls = "sc"
        if room and a + 10 > v and a < CEIL:
            r0 = fill
            r1 = min(1.0, (CEIL - a) / 10.0)
            inner += f'<i class="r" style="left:{r0 * 100:.0f}%;width:{(r1 - r0) * 100:.0f}%"></i>'
            cls += " room"
        if room and a >= CEIL:
            cls += " past"
        out += f'<span class="{cls}" style="--c:{col}">{inner}</span>'
    nt = '<i class="nt" style="left:calc(60% - 5px)"></i>' if key == "stamina" else ""
    return f'<div class="seg">{out}{nt}</div>'


def b_key():
    sw = lambda inner, extra="": f'<span class="sc{extra}" style="--c:{BLUE};flex:none;width:13px;height:15px;display:inline-block">{inner}</span>'
    now_i = '<i style="width:100%;background:' + BLUE + '"></i>'
    room_i = '<i class="r" style="width:100%"></i>'
    return f'<div class="akey">{sw(now_i)} now {sw(room_i, " room")} room to grow, to {CEIL}</div>'


def build_b(bg):
    body = b_left() + b_approach() + attributes(b_bar, GAME_BAND, b_key()) + GLANCE.format(top=ATTR_TOP, h=ATTR_H)
    return page("Overview B", B_CSS, body, bg)


# ================================================================ VARIANT C: a lean card (mark 3), A's bars, three answers
C_CSS = A_CSS + """
.cgrid{display:grid;grid-template-columns:168px 330px 500px 324px;column-gap:14px;margin-top:8px}
.prop{position:absolute;right:22px;bottom:12px;font-size:14px;color:#ffcf9a;display:flex;align-items:center;gap:6px}
"""


def build_c(bg):
    """A proposal only: the same card cut to three answers (pay, share with the talk, let go). MOVE and PROMISE leave."""
    keep = [a for a in ANSWERS if a["id"] in ("match", "half", "let_go")]
    cols = ""
    for a in keep:
        if a["id"] == "half":
            cols += a_half_col(a, bar=110, lw=210, fail_line=f"MATCH IT drops to {43 - TALK_FAIL}")
            continue
        btn = f'<div class="r0" style="display:flex;align-items:center;margin:0 -10px"><div class="btn" style="width:100%">{a["word"]}</div></div>'
        cells_ = a_cells(a, fail=a["id"] == "match", bar=150)
        cols += f'<div class="col">{btn}{"".join(cells_)}</div>'
    card = f"""
<div class="panel" style="left:484px;top:{APPROACH_TOP}px;width:1428px;height:{APPROACH_H}px;padding-top:10px">
  {a_head()}
  <div class="cgrid">{a_gutter()}{cols}</div>
  <div class="prop">{ico("info", 15, "#ffcf9a")}Proposal: three answers. MOVE THE STIPEND and PROMISE: OUR SHOW leave the card.</div>
</div>"""
    body = a_left() + card + attributes(a_bar, SIMS_BAND, a_key()) + GLANCE.format(top=ATTR_TOP, h=ATTR_H)
    return page("Overview C", C_CSS, body, bg)


if __name__ == "__main__":
    bg = background()
    (HERE / "overview_A.html").write_text(build_a(bg), encoding="utf-8")
    (HERE / "overview_B.html").write_text(build_b(bg), encoding="utf-8")
    (HERE / "overview_C.html").write_text(build_c(bg), encoding="utf-8")
    print("built")
