"""Writes the three Overview approaches (S430) as self-contained 1920x1080 HTML pages beside this file.
Usage: python docs/mockups/s430/gen_overview.py   then   python tools/render_mockup.py docs/mockups/s430/overview_a.html ...
The pages share the top bar, the tabs, the figure placeholder and the guide; only the page body differs."""
import pathlib

HERE = pathlib.Path(__file__).resolve().parent

# ---------------------------------------------------------------- data (the screenshot's fighter)
# key, name, value, gain this week, what trains it (None = character, does not train)
PHYSICAL = [("strength", "Strength", 61, 0.1, "Weights"), ("explosiveness", "Explosiveness", 58, 0, "Heavy bag"),
            ("speed", "Speed", 63, 0.2, "Speed bag"), ("stamina", "Stamina", 58, 0.4, "Roadwork"),
            ("recovery", "Recovery", 67, 0, "Rest days"), ("flexibility", "Flexibility", 55, 0, "Mobility"),
            ("durability", "Durability", 66, 0, "Neck work")]
SKILL = [("accuracy", "Accuracy", 60, 0.3, "Pads"), ("timing", "Timing", 61, 0, "Pads"), ("defence", "Defence", 57, 0.1, "Slip rope"),
         ("footwork", "Footwork", 58, 0.2, "Shadow"), ("inside", "Inside fighting", 55, 0, "Sparring")]
MIND = [("fight_iq", "Fight IQ", 62, 0, "Sparring"), ("composure", "Composure", 57, 0, "Sparring"), ("heart", "Heart", 85, 0, None),
        ("discipline", "Discipline", 69, 0, None), ("confidence", "Confidence", 51, 0, None),
        ("coachability", "Coachability", 45, 0, None), ("temper", "Temper", "Trades", 0, None)]
BY_KEY = {r[0]: r for r in PHYSICAL + SKILL + MIND}
CEILING = 84
# what the character values do, in the game's words (Recruit.gd, AttrBoard.WHY), short
DOES = {"heart": "gets up", "discipline": "holds the plan", "confidence": "swings by round", "coachability": "shouts land less",
        "temper": "when hit"}
# the region's five best lightweights, for approach C
TOP5 = {"strength": 60, "explosiveness": 61, "speed": 62, "stamina": 63, "recovery": 62, "flexibility": 58, "durability": 63,
        "accuracy": 62, "timing": 60, "defence": 61, "footwork": 60, "inside": 59, "fight_iq": 60, "composure": 60, "heart": 64,
        "discipline": 62, "confidence": 60, "coachability": 60, "temper": "Even"}

ICON = {
    "strength": '<path d="M4 9v6M7 6v12M17 6v12M20 9v6M7 12h10"/>',
    "explosiveness": '<path d="M13 2 4 14h7l-1 8 9-12h-7z"/>',
    "speed": '<path d="M4 6l6 6-6 6M12 6l6 6-6 6"/>',
    "stamina": '<path d="M2 12h5l2-6 4 12 2-6h7"/>',
    "recovery": '<path d="M20 11a8 8 0 1 0-2.3 5.7M20 5v6h-6"/>',
    "flexibility": '<path d="M5 19c0-9 5-14 14-14M13 5h6v6"/>',
    "durability": '<path d="M12 3l8 3v6c0 5-3.5 8-8 9-4.5-1-8-4-8-9V6z"/>',
    "accuracy": '<circle cx="12" cy="12" r="9"/><circle cx="12" cy="12" r="4.5"/><circle cx="12" cy="12" r=".6"/>',
    "timing": '<circle cx="12" cy="12" r="9"/><path d="M12 7v5l3.5 2"/>',
    "defence": '<path d="M12 3l8 3v6c0 5-3.5 8-8 9-4.5-1-8-4-8-9V6z"/><path d="M12 3v18"/>',
    "footwork": '<ellipse cx="8" cy="8" rx="3" ry="5"/><ellipse cx="16" cy="15" rx="3" ry="5"/>',
    "inside": '<path d="M2 12h7M6 8l4 4-4 4M22 12h-7M18 8l-4 4 4 4"/>',
    "fight_iq": '<path d="M9 18h6M10 21h4M12 3a6 6 0 0 0-4 10.5V15h8v-1.5A6 6 0 0 0 12 3z"/>',
    "composure": '<path d="M3 9c3-3 6 3 9 0s6 3 9 0M3 15c3-3 6 3 9 0s6 3 9 0"/>',
    "heart": '<path d="M12 20s-7-4.5-7-10a4 4 0 0 1 7-2.5A4 4 0 0 1 19 10c0 5.5-7 10-7 10z"/>',
    "discipline": '<path d="M4 6l1.5 1.5L8 5M4 12l1.5 1.5L8 11M4 18l1.5 1.5L8 17M11 6h9M11 12h9M11 18h9"/>',
    "confidence": '<path d="M3 17l6-6 4 4 8-8M15 7h6v6"/>',
    "coachability": '<path d="M4 5h16v10H10l-5 4v-4H4z"/>',
    "temper": '<path d="M12 3c1 4 5 5 5 10a5 5 0 0 1-10 0c0-2 1-3 2-4 0 2 1 3 2 3 0-3-1-5 1-9z"/>',
    "scale": '<rect x="3" y="4" width="18" height="16" rx="3"/><path d="M8 9a5 5 0 0 1 8 0M12 9l2-2"/>',
    "fresh": '<rect x="2" y="8" width="17" height="9" rx="2"/><path d="M22 11v3M6 11v3M10 11v3"/>',
    "mood": '<circle cx="12" cy="12" r="9"/><path d="M8 14c1.2 1.6 6.800 1.600 8 0M9 9.500v.01M15 9.500v.01"/>',
    "flag": '<path d="M5 21V4h12l-2.500 4L17 12H5"/>',
    "trophy": '<path d="M8 4h8v5a4 4 0 0 1-8 0zM8 6H4c0 3 1.500 4.500 4 4.500M16 6h4c0 3-1.500 4.500-4 4.500M12 13v4M8 20h8M10 17h4"/>',
    "week": '<rect x="3" y="5" width="18" height="16" rx="2"/><path d="M3 10h18M8 3v4M16 3v4M8 14h2M14 14h2"/>',
    "plan": '<path d="M4 19c4 0 4-12 9-12h5M15 3l4 4-4 4"/><circle cx="5" cy="6" r="2"/>',
    "bout": '<circle cx="11" cy="11" r="7"/><path d="M16.500 16.500 21 21"/>',
    "talk": '<path d="M4 5h16v10H10l-5 4v-4H4z"/><path d="M8 9h8M8 12h5"/>',
    "home": '<path d="M3 11l9-7 9 7M5 10v10h14V10"/>',
    "mail": '<rect x="3" y="5" width="18" height="14" rx="2"/><path d="M3 7l9 6 9-6"/>',
    "lock": '<rect x="5" y="11" width="14" height="9" rx="2"/><path d="M8 11V8a4 4 0 0 1 8 0v3"/>',
    "goal": '<circle cx="12" cy="12" r="9"/><circle cx="12" cy="12" r="5"/><path d="M12 12l8-8M17 4h3v3"/>',
    "left": '<path d="M14 6l-6 6 6 6"/>',
    "right": '<path d="M10 6l6 6-6 6"/>',
}


def ico(name: str, size: int = 24, cls: str = "") -> str:
    return '<svg class="ico %s" width="%d" height="%d" viewBox="0 0 24 24">%s</svg>' % (cls, size, size, ICON[name])


def band(key: str, v) -> str:
    if key == "temper":
        return "weak"
    for limit, name in ((45, "weak"), (55, "fair"), (65, "solid"), (75, "strong")):
        if v < limit:
            return name
    return "elite"


# ---------------------------------------------------------------- shared pieces
BASE_CSS = """
@font-face{font-family:Marker;src:url(../../../assets/fonts/PermanentMarker-Regular.ttf)}
@font-face{font-family:Barlow;font-weight:400;src:url(../../../assets/fonts/Barlow-Regular.ttf)}
@font-face{font-family:Barlow;font-weight:500;src:url(../../../assets/fonts/Barlow-Medium.ttf)}
@font-face{font-family:Barlow;font-weight:600;src:url(../../../assets/fonts/Barlow-SemiBold.ttf)}
@font-face{font-family:Barlow;font-weight:700;src:url(../../../assets/fonts/Barlow-Bold.ttf)}
@font-face{font-family:Bebas;src:url(../../../assets/fonts/BebasNeue-Regular.ttf)}
@font-face{font-family:Kalam;font-weight:700;src:url(../../../assets/fonts/Kalam-Bold.ttf)}
:root{--ink:#f1e8da;--soft:#c9b9a2;--gold:#ffd24a;--red:#dd4b3d;--blue:#4d8ef0;--green:#3fc07a;--amber:#f28d27;--purple:#ad80ff;
 --track:rgba(255,255,255,.10);--slate:#22262a;--weak:#dd4b3d;--fair:#f28d27;--solid:#4d8ef0;--strong:#3fc07a;--elite:#ad80ff}
*{box-sizing:border-box;margin:0;padding:0}
html,body{width:1920px;height:1080px;overflow:hidden}
body{position:relative;background:#120e0c;color:var(--ink);font:500 22px/1.2 Barlow,"Segoe UI",sans-serif}
.ico{fill:none;stroke:currentColor;stroke-width:2;stroke-linecap:round;stroke-linejoin:round;flex:none}
.abs{position:absolute}
/* the gym behind the page: a dim painted wall, one warm lamp */
.wall{position:absolute;left:0;right:0;top:78px;bottom:0;background:
 radial-gradient(ellipse 760px 520px at var(--lamp,50%) 26%,rgba(255,190,110,.13),transparent 72%),
 radial-gradient(ellipse 620px 420px at 4% 60%,rgba(221,75,61,.06),transparent 70%),
 radial-gradient(ellipse 620px 420px at 97% 55%,rgba(77,142,240,.06),transparent 70%),
 linear-gradient(#1b1512,#130f0d 62%,#0e0b09)}
/* top bar: as the game draws it today, not part of the redesign */
.top{position:absolute;left:0;top:0;width:1920px;height:78px;background:#0d0a09;border-bottom:1px solid rgba(255,255,255,.09);display:flex;align-items:center;gap:14px;padding:0 18px}
.nav{width:40px;height:40px;border-radius:8px;background:rgba(255,255,255,.08);display:grid;place-items:center;color:var(--ink)}
.nav.off{color:#6d635a}
.gym{font:400 31px/1 Marker;color:#5f9df4;margin:0 14px 0 8px;white-space:nowrap}
.date b{display:block;font-weight:600;font-size:22px}.date i,.cash i,.cont i{display:block;font-style:normal;font-size:20px;color:var(--soft)}
.tb{height:48px;padding:0 18px;border-radius:9px;background:rgba(255,255,255,.08);display:flex;align-items:center;gap:10px;font-weight:600;white-space:nowrap}
.grow{flex:1}
.cash{text-align:right}.cash b{display:block;font-size:27px;font-weight:700;color:var(--gold)}
.cont{height:62px;padding:0 26px;border-radius:11px;background:linear-gradient(#ffe070,#f0b32a);color:#2a1b06;display:flex;flex-direction:column;justify-content:center;box-shadow:0 3px 0 #9a6c10}
.cont b{font-size:24px;font-weight:700;letter-spacing:.04em}.cont i{color:#4a3208;font-weight:600;margin-top:-2px}
/* tabs: the chosen one glows, no flat border */
.tabs{position:absolute;left:28px;top:92px;display:flex;gap:6px}
.tab{height:48px;padding:0 20px;border-radius:10px;display:flex;align-items:center;font-weight:600;color:var(--soft);background:rgba(255,255,255,.05)}
.tab.on{color:#fff;background:rgba(255,214,120,.16);box-shadow:0 0 26px 2px rgba(255,205,90,.42)}
/* buttons */
.go{display:inline-flex;align-items:center;justify-content:center;gap:10px;height:56px;padding:0 24px;border-radius:11px;background:linear-gradient(#ffe070,#f0b32a);color:#2a1b06;font-weight:700;font-size:23px;box-shadow:0 3px 0 #9a6c10;white-space:nowrap}
.btn{display:inline-flex;align-items:center;gap:12px;height:56px;padding:0 20px;border-radius:11px;background:rgba(255,255,255,.085);color:var(--ink);font-weight:600;font-size:22px;white-space:nowrap}
.btn .ico{color:var(--gold)}
.btn small{font-size:20px;color:var(--soft);font-weight:500}
/* name */
.name{font:400 52px/1 Marker;color:#fff;white-space:nowrap}
.sub{font-size:22px;color:var(--soft);margin-top:6px;white-space:nowrap}
/* the overall ring */
.ring{border-radius:50%;display:grid;place-items:center;background:radial-gradient(closest-side,#191412 78%,transparent 79% 100%),conic-gradient(var(--gold) 0 60%,var(--track) 60% 100%)}
.ring b{display:block;font:400 46px/0.9 Bebas;color:#fff;text-align:center;letter-spacing:.02em}
.ring i{display:block;font-style:normal;font-size:20px;color:var(--soft);text-align:center;line-height:1}
/* meters */
.bar{position:relative;height:16px;border-radius:8px;background:var(--track)}
.bar b{position:absolute;left:0;top:0;bottom:0;border-radius:8px}
.bar em{position:absolute;top:-5px;width:3px;height:26px;border-radius:2px;background:#fff}
.bar u{position:absolute;top:-13px;margin-left:-8px;width:0;height:0;border:8px solid transparent;border-top:11px solid var(--gold)}
.weak{--c:var(--weak)}.fair{--c:var(--fair)}.solid{--c:var(--solid)}.strong{--c:var(--strong)}.elite{--c:var(--elite)}
.bar b{background:var(--c)}
.v{font-weight:700;font-size:28px;text-align:right;color:color-mix(in srgb,var(--c) 78%,#fff)}
.gain{color:var(--green);font-weight:600;font-size:20px;white-space:nowrap}
.cap{color:var(--soft);font-size:20px;white-space:nowrap}
.pill{display:inline-flex;align-items:center;height:32px;padding:0 13px;border-radius:16px;background:rgba(255,210,74,.13);color:var(--gold);font-weight:600;font-size:20px;white-space:nowrap}
.pill.hot{background:var(--gold);color:#2a1b06;box-shadow:0 0 22px 3px rgba(255,205,90,.55)}
.pips{display:flex;gap:7px;align-items:center}.pips s{width:26px;height:16px;border-radius:5px;background:var(--green)}.pips s.o{background:var(--track)}
.key{display:flex;align-items:center;gap:8px;font-size:20px;color:var(--soft);white-space:nowrap}
.key s{width:14px;height:14px;border-radius:4px;display:inline-block;margin-left:10px}
.key em{display:inline-block;width:3px;height:20px;background:#fff;border-radius:2px}
.key u{display:inline-block;width:0;height:0;border:8px solid transparent;border-top:11px solid var(--gold);margin-top:10px}
.key i{display:inline-block;width:30px;height:14px;border-radius:7px;margin-left:16px;background:repeating-linear-gradient(135deg,var(--strong) 0 6px,#1f6a43 6px 10px)}
.h{font-weight:700;font-size:22px;letter-spacing:.09em;color:var(--gold)}
/* the guide: the old trainer, bottom left on every page while the guide runs */
.guide{position:absolute;left:14px;bottom:14px;display:flex;align-items:flex-end}
.gface{width:190px;height:190px}
.gtail{width:24px;height:40px;margin-bottom:34px;background:#8a6a3d;clip-path:polygon(0 55%,100% 0,100% 100%)}
.gbub{width:452px;background:#262a2d;border:3px solid #8a6a3d;border-radius:24px;padding:14px 22px}
.gbub p{font:700 27px/34px Kalam,"Segoe Print",cursive;color:#efe6d8}
.gbub div{display:flex;justify-content:flex-end;margin-top:8px}
.gskip{height:38px;padding:0 14px;border-radius:9px;background:rgba(255,255,255,.07);color:var(--soft);font-size:20px;font-weight:600;display:flex;align-items:center}
.fig{display:block;filter:drop-shadow(-3px 0 0 rgba(255,214,160,.20)) drop-shadow(0 0 34px rgba(255,170,80,.10))}
.figtag{position:absolute;font-size:20px;color:#8f8272;white-space:nowrap}
"""


def top_bar() -> str:
    return ('<div class="top"><span class="nav">%s</span><span class="nav off">%s</span><span class="gym">ANVIL STREET GYM</span>'
            '<span class="date"><b>Tue 27 Jan 2026</b><i>Week 4</i></span><span style="width:18px"></span>'
            '<span class="tb">%s Gym</span><span class="tb">%s Mail (13 new)</span><span class="grow"></span>'
            '<span class="cash"><b>$18,702</b><i>running -$607 a week</i></span>'
            '<span class="cont"><b>CONTINUE</b><i>to Mon 2 Feb, week review</i></span><span class="tb">Menu</span></div>'
            ) % (ico("left"), ico("right"), ico("home"), ico("mail"))


def tabs() -> str:
    return '<div class="tabs"><span class="tab on">Overview</span><span class="tab">Training</span><span class="tab">Playbook</span><span class="tab">History</span></div>'


def figure(w: int, h: int) -> str:
    """The boxer's placeholder: a full-body silhouette in guard. In the game this is the real 3D model."""
    return '''<svg class="fig" width="%d" height="%d" viewBox="0 0 300 800">
<defs><linearGradient id="fb" gradientUnits="userSpaceOnUse" x1="70" x2="240" y1="0" y2="0"><stop offset="0" stop-color="#6a5a4c"/><stop offset=".5" stop-color="#40372f"/><stop offset="1" stop-color="#2a2420"/></linearGradient>
<linearGradient id="fg" gradientUnits="userSpaceOnUse" x1="80" x2="220" y1="0" y2="0"><stop offset="0" stop-color="#ee5f50"/><stop offset="1" stop-color="#a02f26"/></linearGradient></defs>
<ellipse cx="150" cy="778" rx="128" ry="15" fill="rgba(0,0,0,.6)"/>
<g stroke="url(#fb)" fill="none" stroke-linecap="round" stroke-linejoin="round">
<path d="M124 440 L108 592 L104 712" stroke-width="52"/><path d="M178 440 L196 592 L200 712" stroke-width="52"/></g>
<path d="M76 700h52v54q0 16-16 16H66q-12 0-9-13 5-17 19-21z" fill="#191614"/>
<path d="M176 700h52v36q14 4 19 21 3 13-9 13h-46q-16 0-16-16z" fill="#191614"/>
<path d="M100 334H200L218 474 160 480 150 424 140 480 82 474Z" fill="#54483d"/>
<path d="M98 148Q150 128 202 148L192 250Q188 296 196 336H104Q112 296 108 250Z" fill="url(#fb)"/>
<path d="M100 150Q150 131 200 150L193 238Q150 252 107 238Z" fill="#7a342b"/>
<rect x="100" y="326" width="100" height="18" rx="6" fill="#d8ccb8"/>
<rect x="136" y="106" width="28" height="36" fill="#4a4037"/>
<ellipse cx="150" cy="76" rx="36" ry="44" fill="url(#fb)"/>
<path d="M113 72Q114 28 150 28 186 28 187 72 172 50 150 50 128 50 113 72Z" fill="#191614"/><circle cx="150" cy="24" r="14" fill="#191614"/>
<g stroke="url(#fb)" fill="none" stroke-linecap="round" stroke-linejoin="round">
<path d="M104 160L80 262 108 200" stroke-width="32"/><path d="M196 160L222 258 196 210" stroke-width="32"/></g>
<rect x="80" y="208" width="36" height="17" rx="5" transform="rotate(-62 98 216)" fill="#e9dfcf"/>
<rect x="186" y="216" width="36" height="17" rx="5" transform="rotate(62 204 224)" fill="#e9dfcf"/>
<ellipse cx="114" cy="174" rx="31" ry="36" fill="url(#fg)"/><ellipse cx="190" cy="186" rx="31" ry="36" fill="url(#fg)"/>
</svg>''' % (w, h)


def guide() -> str:
    face = '''<svg width="190" height="190" viewBox="0 0 190 190"><defs><clipPath id="gc"><circle cx="95" cy="95" r="88"/></clipPath>
<radialGradient id="gr" cx=".5" cy=".35" r=".8"><stop offset="0" stop-color="#5b4a3a"/><stop offset="1" stop-color="#231c17"/></radialGradient></defs>
<circle cx="95" cy="95" r="88" fill="url(#gr)"/><g clip-path="url(#gc)"><path d="M22 200q4-62 73-62t73 62z" fill="#39424a"/>
<rect x="82" y="112" width="26" height="30" fill="#b08a6c"/><ellipse cx="95" cy="88" rx="33" ry="38" fill="#c39b7a"/>
<path d="M60 96q2 34 35 36 33-2 35-36-6 20-35 20T60 96z" fill="#e6e0d6"/>
<path d="M56 70q4-34 40-34 34 0 40 30l14 6q-30 6-94-2z" fill="#2b3036"/></g>
<circle cx="95" cy="95" r="88" fill="none" stroke="#8a6a3d" stroke-width="4"/></svg>'''
    return ('<div class="guide"><div class="gface">%s</div><div class="gtail"></div><div class="gbub">'
            '<p>Next job for the club: sign a second boxer.</p><div><span class="gskip">Skip the guide</span></div></div></div>') % face


def page(title: str, css: str, body: str, lamp: str = "50%") -> str:
    return ('<!doctype html>\n<html lang="en"><head><meta charset="utf-8"><title>%s</title>\n<style>%s%s</style></head>\n'
            '<body><div class="wall" style="--lamp:%s"></div>%s%s\n%s\n%s</body></html>\n') % (title, BASE_CSS, css, lamp, top_bar(), tabs(), body, guide())


def bar(key: str, v, goal: float = 0.0, tick: bool = True) -> str:
    out = '<span class="bar"><b style="width:%d%%"></b>' % v
    if tick and BY_KEY[key][4] is not None:
        out += '<em style="left:%d%%"></em>' % CEILING
    if goal:
        out += '<u style="left:%d%%"></u>' % goal
    return out + '</span>'


BANDS = ('<div class="key"><s style="background:var(--weak);margin-left:0"></s>Weak<s style="background:var(--fair)"></s>Fair'
         '<s style="background:var(--solid)"></s>Solid<s style="background:var(--strong)"></s>Strong<s style="background:var(--elite)"></s>Elite</div>')
MARKS = '<em></em>&nbsp;ceiling %d&nbsp;&nbsp;&nbsp;&nbsp;<u></u>&nbsp;goal' % CEILING

PIPS = '<span class="pips"><s></s><s></s><s></s><s></s><s></s></span>'


# ================================================================ A: the body chart
A_CSS = """
.floor{position:absolute;left:560px;right:560px;bottom:0;height:150px;background:
 repeating-linear-gradient(90deg,rgba(0,0,0,.28) 0 2px,transparent 2px 112px),linear-gradient(#3a2a1e,#1c140f);
 clip-path:polygon(9% 0,91% 0,100% 100%,0 100%);opacity:.9}
.step{position:absolute;left:560px;right:28px;top:88px;height:56px;display:flex;align-items:center;gap:14px;justify-content:flex-end}
.step .ico{color:var(--gold)}.step .go{color:#2a1b06}.step b{font-size:26px;font-weight:700;white-space:nowrap}.step span{color:var(--soft);white-space:nowrap}
.cl{position:absolute;width:624px}
.cl h3{height:40px;display:flex;align-items:baseline;gap:14px;font-weight:700;font-size:22px;letter-spacing:.09em;color:var(--gold);padding-top:6px}
.cl h3 span{font-weight:500;font-size:20px;letter-spacing:0;color:var(--soft)}
.r{display:grid;grid-template-columns:26px 164px 1fr 46px 168px;column-gap:10px;align-items:center;height:40px;border-radius:10px;padding:0 6px;margin:0 -6px}
.r .ico{color:var(--soft)}.r .n{font-weight:600;white-space:nowrap}
.r.char .bar b{background:repeating-linear-gradient(135deg,var(--c) 0 6px,color-mix(in srgb,var(--c) 55%,#000) 6px 10px)}
.r.sel{background:rgba(255,210,74,.09);box-shadow:0 0 26px 2px rgba(255,205,90,.28)}
.word{font-weight:700;font-size:22px;color:#ff8d7f;text-align:right}
.lead{position:absolute;left:0;top:0;pointer-events:none}
.goal{position:absolute;left:1268px;top:784px;width:624px;display:grid;grid-template-columns:86px 1fr auto;column-gap:16px;align-items:center}
.gr{width:86px;height:86px;border-radius:50%;display:grid;place-items:center;font:400 34px/1 Bebas;background:radial-gradient(closest-side,#191412 74%,transparent 75% 100%),conic-gradient(var(--green) 0 40%,var(--track) 40% 100%)}
.goal b{display:block;font-size:26px;font-weight:700;white-space:nowrap}.goal span{display:block;color:var(--soft);white-space:nowrap;margin-top:2px}
.ok{display:inline-flex;align-items:center;height:34px;padding:0 14px;border-radius:17px;background:rgba(63,192,122,.16);color:var(--green);font-weight:700;font-size:20px;white-space:nowrap}
.acts{position:absolute;left:1268px;top:904px;width:624px;display:grid;grid-template-columns:1fr 1fr;gap:12px}
.acts .btn{height:64px}
"""


def a_row(key: str, sel: bool = False, pill: str = "", goal: float = 0.0) -> str:
    _k, name, v, gain, by = BY_KEY[key]
    char = by is None
    cls = "r " + band(key, v) + (" char" if char else "") + (" sel" if sel else "")
    if key == "temper":
        return '<div class="%s">%s<span class="n">%s</span><span class="word" style="grid-column:3/5">Trades</span><span class="cap">%s</span></div>' % (cls, ico(key), name, DOES[key])
    if char:
        slot = '<span class="cap">%s</span>' % DOES[key]
    elif pill:
        slot = '<span><span class="pill%s">+ %s</span></span>' % (" hot" if sel else "", by)
    elif gain:
        slot = '<span class="gain">+%.1f a week</span>' % gain
    else:
        slot = '<span></span>'
    return '<div class="%s">%s<span class="n">%s</span>%s<span class="v">%d</span>%s</div>' % (cls, ico(key), name, bar(key, v, goal), v, slot)


def a_cluster(x: int, y: int, title: str, says: str, rows: str) -> str:
    return '<div class="cl" style="left:%dpx;top:%dpx"><h3>%s<span>%s</span></h3>%s</div>' % (x, y, title, says, rows)


def approach_a() -> str:
    lx, rx = 28, 1268
    body = '<div class="floor"></div>'
    body += ('<div class="step">%s<span class="h">NEXT STEP</span><b>The nationals</b><span>entries close in 44 days</span>'
             '<span class="go" style="margin-left:10px">Enter Lucy for the nationals</span></div>') % ico("trophy", 30)
    body += '<div class="abs" style="left:28px;top:156px"><div class="name">LUCY JACKSON</div><div class="sub">Lightweight, 21, orthodox, amateur 3-2</div></div>'
    body += '<div class="abs ring" style="left:536px;top:150px;width:112px;height:112px"><div><b>60</b><i>of 100</i></div></div>'
    # the figure, centre stage
    body += '<div class="abs" style="left:806px;top:236px">%s</div>' % figure(304, 810)
    body += '<div class="figtag" style="left:832px;top:1046px">the real 3D model stands here</div>'
    # leaders: cluster title -> the part of the body it lives in
    lines = [((386, 290), (700, 290), (922, 312)), ((234, 582), (720, 582), (896, 414)),
             ((1264, 172), (1200, 172), (1016, 420)), ((1264, 306), (1180, 306), (1006, 500)),
             ((1264, 480), (1210, 480), (1024, 836)), ((1264, 654), (1230, 654), (1040, 992))]
    svg = '<svg class="lead" width="1920" height="1080">'
    for a, b, c in lines:
        svg += '<path d="M%d %d H%d L%d %d" fill="none" stroke="rgba(241,232,218,.42)" stroke-width="2" stroke-dasharray="2 7" stroke-linecap="round"/>' % (a[0], a[1], b[0], c[0], c[1])
        svg += '<circle cx="%d" cy="%d" r="6" fill="#f1e8da"/><circle cx="%d" cy="%d" r="12" fill="none" stroke="rgba(241,232,218,.35)" stroke-width="2"/>' % (c[0], c[1], c[0], c[1])
    body += svg + '</svg>'
    body += a_cluster(lx, 268, "HEAD", "reads the fight, keeps the plan",
                      a_row("fight_iq") + a_row("composure", pill="y") + a_row("discipline") + a_row("confidence") + a_row("coachability") + a_row("temper"))
    body += a_cluster(lx, 560, "HANDS", "what lands",
                      a_row("accuracy") + a_row("timing") + a_row("inside", sel=True, pill="y") + a_row("strength") + a_row("explosiveness"))
    body += '<div class="abs key" style="left:28px;top:808px">%s<i></i>&nbsp;character, does not train</div>' % MARKS
    body += '<div class="abs" style="left:28px;top:838px">%s</div>' % BANDS
    body += a_cluster(rx, 150, "GUARD", "what gets through", a_row("defence") + a_row("durability"))
    body += a_cluster(rx, 284, "ENGINE", "how long it lasts", a_row("stamina", goal=61) + a_row("recovery") + a_row("heart"))
    body += a_cluster(rx, 458, "LEGS", "where the fight happens", a_row("speed") + a_row("footwork") + a_row("flexibility", pill="y"))
    scale = ('<div class="r strong">%s<span class="n">Weight</span><span class="bar"><b style="width:92%%"></b><em style="left:97%%"></em></span>'
             '<span class="v" style="grid-column:4/6;text-align:left;white-space:nowrap">59.7 <span class="cap">kg, limit 60.0</span></span></div>') % ico("scale")
    scale += '<div class="r strong">%s<span class="n">Freshness</span>%s<span class="v" style="grid-column:4/6;text-align:left">Fresh</span></div>' % (ico("fresh"), PIPS)
    body += a_cluster(rx, 632, "ON THE SCALE", "today", scale)
    body += ('<div class="goal"><div class="gr">40%</div><div><b>Goal: Stamina for five rounds</b><span>Stamina 58 of 61, 18 days left</span></div>'
             '<span class="ok">On track</span></div>')
    body += ('<div class="acts"><span class="btn">%s Plan the week</span><span class="btn">%s Fight plan <small>5 arrows</small></span>'
             '<span class="btn">%s Find a bout</span><span class="btn">%s Talk to Lucy</span></div>') % (ico("week", 28), ico("plan", 28), ico("bout", 28), ico("talk", 28))
    return page("Overview A - the body chart", A_CSS, body)


# ================================================================ B: the clean sheet with a do-next rail
B_CSS = """
.sheet{position:absolute;left:14px;top:256px;width:1052px;height:604px;border-radius:16px;background:linear-gradient(rgba(38,42,46,.86),rgba(30,33,37,.86));box-shadow:0 14px 40px rgba(0,0,0,.45)}
.ledge{position:absolute;left:14px;top:856px;width:1052px;height:8px;border-radius:0 0 8px 8px;background:linear-gradient(#8a6038,#5a3c22)}
.col{position:absolute;width:486px}
.col h3{height:40px;display:flex;align-items:center;gap:10px;font-weight:700;font-size:22px;letter-spacing:.09em;color:var(--gold)}
.col h4{height:34px;display:flex;align-items:center;gap:8px;font-weight:500;font-size:20px;color:var(--soft);margin-top:4px}
.r{display:grid;grid-template-columns:26px 152px 1fr 44px 88px;column-gap:10px;align-items:center;height:38px;border-radius:10px;padding:0 6px;margin:0 -6px}
.r .ico{color:var(--soft)}.r .n{font-weight:600;white-space:nowrap}
.r .bar{height:20px;border-radius:0;transform:skewX(-18deg)}.r .bar b{border-radius:0}.r .bar em{top:-4px;height:28px}
.r .bar u{transform:skewX(18deg)}
.r.sel{background:rgba(255,210,74,.09);box-shadow:0 0 26px 2px rgba(255,205,90,.28)}
.word{font-weight:700;font-size:22px;color:#ff8d7f}
.rail{position:absolute;left:1412px;top:150px;width:480px;display:flex;flex-direction:column;gap:14px}
.card{border-radius:16px;background:linear-gradient(rgba(38,42,46,.9),rgba(30,33,37,.9));padding:18px 20px 20px;box-shadow:0 10px 30px rgba(0,0,0,.4)}
.card.first{background:linear-gradient(rgba(64,50,26,.92),rgba(38,32,24,.92));box-shadow:0 0 34px 2px rgba(255,205,90,.22)}
.card .h{display:flex;align-items:center;gap:10px}
.fact{display:grid;grid-template-columns:auto 1fr;column-gap:16px;align-items:center;margin:10px 0 14px}
.big{font:400 66px/0.9 Bebas;color:#fff}
.fact b{display:block;font-size:26px;font-weight:700;white-space:nowrap}.fact span{display:block;color:var(--soft);white-space:nowrap}
.card .go,.card .btn{width:100%;justify-content:center}
.two{display:grid;grid-template-columns:1fr 1fr;gap:10px}
.gm{position:relative;height:16px;border-radius:8px;background:var(--track);margin:2px 0 14px}.gm b{position:absolute;left:0;top:0;bottom:0;width:40%;border-radius:8px;background:var(--green)}
.ok{color:var(--green);font-weight:700}
.line{margin:10px 0 14px}
.line b{display:block;font-size:26px;font-weight:700;white-space:nowrap}.line i{display:block;font-style:normal;color:var(--soft);white-space:nowrap}
"""


def b_row(key: str, sel: bool = False, pill: bool = False, goal: float = 0.0) -> str:
    _k, name, v, gain, by = BY_KEY[key]
    cls = "r " + band(key, v) + (" sel" if sel else "")
    if key == "temper":
        return '<div class="%s">%s<span class="n">%s</span><span class="word" style="grid-column:3/6">Trades when hit</span></div>' % (cls, ico(key), name)
    if pill:
        slot = '<span><span class="pill%s">Train</span></span>' % (" hot" if sel else "")
    elif gain:
        slot = '<span class="gain">+%.1f wk</span>' % gain
    else:
        slot = '<span></span>'
    return '<div class="%s">%s<span class="n">%s</span>%s<span class="v">%d</span>%s</div>' % (cls, ico(key), name, bar(key, v, goal), v, slot)


def approach_b() -> str:
    body = '<div class="abs" style="left:28px;top:154px"><div class="name">LUCY JACKSON</div><div class="sub">Lightweight, 21, orthodox, amateur 3-2</div></div>'
    body += '<div class="abs ring" style="left:452px;top:150px;width:98px;height:98px"><div><b style="font-size:40px">60</b><i>of 100</i></div></div>'
    body += '<div class="sheet"></div><div class="ledge"></div>'
    c1 = '<h3>PHYSICAL</h3>' + "".join(b_row(r[0], goal=61 if r[0] == "stamina" else 0, pill=r[0] == "flexibility") for r in PHYSICAL)
    c1 += '<h3 style="margin-top:10px">SKILL</h3>' + "".join(b_row(r[0], sel=r[0] == "inside", pill=r[0] == "inside") for r in SKILL)
    body += '<div class="col" style="left:36px;top:268px">%s</div>' % c1
    c2 = '<h3>MIND</h3>' + b_row("fight_iq") + b_row("composure", pill=True)
    c2 += '<h4>%s Character: set at signing, training does not move it</h4>' % ico("lock", 20)
    c2 += "".join(b_row(k) for k in ("heart", "discipline", "confidence", "coachability", "temper"))
    c2 += '<h3 style="margin-top:10px">TODAY</h3>'
    c2 += ('<div class="r strong">%s<span class="n">Weight</span><span class="bar"><b style="width:92%%"></b><em style="left:97%%"></em></span>'
           '<span class="v" style="grid-column:4/6;text-align:left;white-space:nowrap;font-size:24px">59.7 <span class="cap">of 60.0 kg</span></span></div>') % ico("scale")
    c2 += '<div class="r strong">%s<span class="n">Freshness</span>%s<span class="v" style="grid-column:4/6;text-align:left;font-size:24px">Fresh</span></div>' % (ico("fresh"), PIPS)
    c2 += ('<div class="r solid">%s<span class="n">Mood</span><span class="bar"><b style="width:62%%"></b></span>'
           '<span class="v" style="grid-column:4/6;text-align:left;font-size:24px">Steady</span></div>') % ico("mood")
    body += '<div class="col" style="left:558px;top:268px">%s</div>' % c2
    body += '<div class="abs key" style="left:558px;top:792px">%s</div><div class="abs" style="left:558px;top:822px">%s</div>' % (MARKS, BANDS)
    body += '<div class="abs" style="left:1086px;top:246px">%s</div>' % figure(300, 800)
    body += '<div class="figtag" style="left:1108px;top:1044px">the real 3D model stands here</div>'
    rail = ('<div class="card first"><div class="h">%s NEXT STEP</div><div class="fact"><span class="big">44</span><div><b>The nationals</b><span>days until entries close</span></div></div>'
            '<span class="go">Enter Lucy for the nationals</span></div>') % ico("trophy", 26)
    rail += ('<div class="card"><div class="h">%s GOAL</div><div class="fact" style="margin-bottom:8px"><span class="big">18</span><div><b>Stamina for five rounds</b>'
             '<span>days left, Stamina 58 of 61, <i class="ok" style="font-style:normal">on track</i></span></div></div><div class="gm"><b></b></div>'
             '<div class="two"><span class="btn">%s Plan the week</span><span class="btn">%s Talk to Lucy</span></div></div>') % (ico("goal", 26), ico("week", 26), ico("talk", 26))
    rail += ('<div class="card"><div class="h">%s NEXT BOUT</div><div class="line"><b>None booked</b><i>no offer on the table</i></div>'
             '<span class="btn">%s Find a bout</span></div>') % (ico("flag", 26), ico("bout", 26))
    rail += ('<div class="card"><div class="h">%s FIGHT PLAN</div><div class="line"><b>5 arrows drawn</b><i>Out-boxer, stays at range, steady pace</i></div>'
             '<span class="btn">%s Fight plan</span></div>') % (ico("plan", 26), ico("plan", 26))
    body += '<div class="rail">%s</div>' % rail
    return page("Overview B - the clean sheet", B_CSS, body, "64%")


# ================================================================ C: the tale of the tape
C_CSS = """
.rope{position:absolute;top:150px;height:4px;border-radius:2px}
.tape{position:absolute;left:712px;top:150px;width:766px}
.th{display:grid;grid-template-columns:1fr 150px 1fr;align-items:center;height:60px}
.th .l,.th .rr{display:flex;align-items:baseline;gap:12px;font:400 38px/1 Bebas;letter-spacing:.03em}
.th .l{color:#ff8d7f}.th .rr{color:#8db8ff;justify-content:flex-end}
.th span{font:500 20px/1 Barlow;color:var(--soft);letter-spacing:0}
.th .m{text-align:center;font:400 26px/1 Bebas;color:var(--soft);letter-spacing:.12em}
.gh{height:30px;display:flex;align-items:center;justify-content:center;gap:14px;font-weight:700;font-size:20px;letter-spacing:.14em;color:var(--gold)}
.gh::before,.gh::after{content:"";flex:1;height:2px;background:linear-gradient(90deg,transparent,rgba(255,210,74,.35))}
.gh::after{transform:scaleX(-1)}
.t{display:grid;grid-template-columns:62px 46px 150px 186px 150px 46px 86px;column-gap:6px;align-items:center;height:37px}
.t .gain{text-align:right}
.t .nm{text-align:center;font-weight:600;white-space:nowrap}
.t .nm .ico{color:#8f8272;vertical-align:-3px;margin-left:4px}
.t .n1,.t .n2{font:400 32px/1 Bebas;letter-spacing:.02em;padding-top:3px}
.t .n1{text-align:right;color:#ff8d7f}.t .n2{color:#8db8ff}
.t .lose{opacity:.42}.t .n1.lose,.t .n2.lose{opacity:.72}
.lb,.rb{position:relative;height:16px;background:var(--track)}
.lb{border-radius:8px 0 0 8px}.rb{border-radius:0 8px 8px 0}
.lb b{position:absolute;right:0;top:0;bottom:0;background:var(--red);border-radius:8px 0 0 8px}
.rb b{position:absolute;left:0;top:0;bottom:0;background:var(--blue);border-radius:0 8px 8px 0}
.lb em{position:absolute;top:-4px;width:3px;height:24px;border-radius:2px;background:#fff}
.vd{font-weight:700;font-size:22px;white-space:nowrap;display:flex;align-items:center;gap:2px}
.vd.a{color:#ff8d7f}.vd.b{color:#8db8ff;justify-content:flex-end}.vd.e{color:#8f8272;justify-content:center;font-weight:500}
.wd{font-weight:700;font-size:22px}
.side{position:absolute;left:1500px;top:150px;width:392px}
.blk{border-radius:16px;background:linear-gradient(rgba(38,42,46,.9),rgba(30,33,37,.9));padding:16px 18px 18px;box-shadow:0 10px 30px rgba(0,0,0,.4)}
.blk.first{background:linear-gradient(rgba(64,50,26,.92),rgba(38,32,24,.92));box-shadow:0 0 34px 2px rgba(255,205,90,.22)}
.blk .h{display:flex;align-items:center;gap:10px}
.blk b.t1{display:block;font-size:26px;font-weight:700;margin-top:8px}.blk span.t2{display:block;color:var(--soft);margin:2px 0 12px}
.blk .go{width:100%}
.cmp{display:flex;gap:10px;margin-top:10px}
.chip{height:44px;padding:0 14px;border-radius:22px;display:flex;align-items:center;font-weight:600;font-size:20px;white-space:nowrap;background:rgba(255,255,255,.06);color:#8f8272}
.chip.on{color:#fff;background:rgba(77,142,240,.26);box-shadow:0 0 22px 2px rgba(77,142,240,.5)}
.score{display:grid;grid-template-columns:1fr 1fr 1fr;text-align:center;margin-top:8px}
.score b{display:block;font:400 62px/0.95 Bebas}.score span{font-size:20px;color:var(--soft)}
.gap{display:grid;grid-template-columns:26px 1fr auto;column-gap:10px;align-items:center;height:56px;border-radius:11px;background:rgba(255,255,255,.07);padding:0 12px 0 14px;margin-top:8px;font-weight:600;white-space:nowrap}
.gap .ico{color:var(--soft)}.gap small{font-size:20px;color:var(--soft);font-weight:500}
.acts{display:grid;grid-template-columns:1fr;gap:8px}
.acts .btn{height:52px}
.me{position:absolute;left:316px;width:374px}
.me .r{display:grid;grid-template-columns:26px 112px 1fr;column-gap:10px;align-items:center;height:44px}
.me .r .ico{color:var(--soft)}.me .r .n{font-weight:600}
.me .val{font-weight:700;font-size:24px;white-space:nowrap}
.me .pips s{width:20px}
.gm{position:relative;height:16px;border-radius:8px;background:var(--track);margin:10px 0 8px}.gm b{position:absolute;left:0;top:0;bottom:0;width:40%;border-radius:8px;background:var(--green)}
.ok{color:var(--green);font-weight:700}
"""


def c_row(key: str) -> str:
    _k, name, v, gain, by = BY_KEY[key]
    them = TOP5[key]
    g = '<span class="gain">%s</span>' % ("+%.1f" % gain if gain else "")
    lock = "" if by is not None else ico("lock", 18)
    if key == "temper":
        return ('<div class="t">%s<span></span><span class="wd" style="text-align:right;color:#ff8d7f">Trades</span><span class="nm">%s%s</span>'
                '<span class="wd" style="color:#8db8ff">Even</span><span></span><span></span></div>') % (g, name, lock)
    d = v - them
    lw, rw = (v - 40) * 3, (them - 40) * 3
    tick = '<em style="right:%dpx"></em>' % ((CEILING - 40) * 3 - 1) if by is not None else ""
    if d >= 2:
        verdict = '<span class="vd a">%s+%d</span>' % (ico("left", 22), d)
    elif d <= -2:
        verdict = '<span class="vd b">+%d%s</span>' % (-d, ico("right", 22))
    else:
        verdict = '<span class="vd e">level</span>'
    lc, rc = (" lose" if d <= -2 else ""), (" lose" if d >= 2 else "")
    return ('<div class="t">%s<span class="n1%s">%d</span><span class="lb%s"><b style="width:%dpx"></b>%s</span><span class="nm">%s%s</span>'
            '<span class="rb%s"><b style="width:%dpx"></b></span><span class="n2%s">%d</span>%s</div>') % (g, lc, v, lc, lw, tick, name, lock, rc, rw, rc, them, verdict)


def approach_c() -> str:
    body = '<div class="rope" style="left:712px;width:383px;background:linear-gradient(90deg,var(--red),transparent)"></div>'
    body += '<div class="rope" style="left:1095px;width:383px;background:linear-gradient(270deg,var(--blue),transparent)"></div>'
    body += '<div class="abs" style="left:28px;top:154px"><div class="name">LUCY JACKSON</div><div class="sub">Lightweight, 21, orthodox, amateur 3-2</div></div>'
    body += '<div class="abs" style="left:44px;top:254px">%s</div>' % figure(229, 610)
    body += '<div class="abs ring" style="left:548px;top:150px;width:112px;height:112px"><div><b>60</b><i>of 100</i></div></div>'
    me = '<div class="h">TODAY</div>'
    me += '<div class="r">%s<span class="n">Weight</span><span class="val">59.7 <span class="cap" style="font-weight:500">of 60.0 kg</span></span></div>' % ico("scale")
    me += '<div class="r">%s<span class="n">Freshness</span><span style="display:flex;gap:12px;align-items:center">%s<span class="val">Fresh</span></span></div>' % (ico("fresh"), PIPS)
    me += '<div class="r">%s<span class="n">Mood</span><span class="val">Steady</span></div>' % ico("mood")
    body += '<div class="me" style="top:300px">%s</div>' % me
    goal = ('<div class="h" style="display:flex;gap:10px;align-items:center">%s GOAL</div><b style="display:block;font-size:26px;font-weight:700;margin-top:8px;white-space:nowrap">Stamina for five rounds</b>'
            '<div class="gm"><b></b></div><span style="color:var(--soft);white-space:nowrap">Stamina 58 of 61, 18 days left, <i class="ok" style="font-style:normal">on track</i></span>') % ico("goal", 26)
    body += '<div class="me" style="top:508px">%s</div>' % goal
    body += '<div class="me" style="top:664px;display:grid;gap:8px"><span class="btn">%s Talk to Lucy</span><span class="btn">%s Plan the week</span></div>' % (ico("talk", 26), ico("week", 26))
    # the tape
    tape = ('<div class="th"><div class="l">LUCY <span>60 overall</span></div><div class="m">THE TAPE</div>'
            '<div class="rr"><span>62 overall</span> REGION\'S TOP 5</div></div>')
    for title, rows in (("PHYSICAL", PHYSICAL), ("SKILL", SKILL), ("MIND", MIND)):
        tape += '<div class="gh">%s</div>' % title + "".join(c_row(r[0]) for r in rows)
    tape += ('<div class="key" style="justify-content:center;margin-top:10px"><em></em>&nbsp;ceiling %d&nbsp;&nbsp;&nbsp;%s&nbsp;character, does not train'
             '&nbsp;&nbsp;&nbsp;<span class="gain">+0.4</span>&nbsp;gained this week</div>') % (CEILING, ico("lock", 18))
    body += '<div class="tape">%s</div>' % tape
    side = ('<div class="blk first"><div class="h">%s NEXT STEP</div><b class="t1">The nationals</b><span class="t2">entries close in 44 days</span>'
            '<span class="go">Enter Lucy for the nationals</span></div>') % ico("trophy", 26)
    side += ('<div class="blk" style="margin-top:12px"><div class="h">COMPARE WITH</div><div class="cmp"><span class="chip on">Region\'s top 5</span>'
             '<span class="chip">Next opponent</span></div><div class="cap" style="text-align:right;margin-top:4px">no bout booked</div>'
             '<div class="score"><div><b style="color:#ff8d7f">5</b><span>ahead</span></div><div><b style="color:#d8ccb8">3</b><span>level</span></div>'
             '<div><b style="color:#8db8ff">10</b><span>behind</span></div></div></div>')
    gaps = "".join('<div class="gap">%s<span>%s <small style="color:#8db8ff;font-weight:700">-%s</small></span><span class="pill">+ %s</span></div>' % (ico(k), BY_KEY[k][1], n, BY_KEY[k][4])
                   for k, n in (("stamina", 5), ("defence", 4), ("inside", 4)))
    side += '<div class="blk" style="margin-top:12px"><div class="h">GAPS YOU CAN TRAIN</div>%s</div>' % gaps
    side += '<div class="acts" style="margin-top:12px"><span class="btn">%s Find a bout</span><span class="btn">%s Fight plan <small>5 arrows</small></span></div>' % (ico("bout", 26), ico("plan", 26))
    body += '<div class="side">%s</div>' % side
    return page("Overview C - the tale of the tape", C_CSS, body, "57%")


if __name__ == "__main__":
    for name, make in (("overview_a.html", approach_a), ("overview_b.html", approach_b), ("overview_c.html", approach_c)):
        (HERE / name).write_text(make(), encoding="utf-8")
        print(HERE / name)
