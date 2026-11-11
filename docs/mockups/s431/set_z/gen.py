"""Writes set_z's two pages (S431): squad.html and overview.html, both 1920x1080, beside this file.
overview.html is a COPY of docs/mockups/s430/overview_a.html with only the listed changes applied (top bar, Cardio,
tiredness, six tabs, the real figure, small gym-screen touches). squad.html is new, in the same look.
Usage: python docs/mockups/s431/set_z/gen.py   then   python tools/render_mockup.py docs/mockups/s431/set_z/squad.html ...overview.html"""
import pathlib

HERE = pathlib.Path(__file__).resolve().parent
SRC_A = HERE.parent.parent / "s430" / "overview_a.html"
A = "../../../../assets"          # the game's own fonts and wood kit, by relative path

# ------------------------------------------------------------------ colours sampled from ref/gym_screen.png (see notes.md)
NAME_BLUE = "#6c9de6"   # the brush club name
DATE_INK = "#ede1cd"
SOFT_INK = "#b7a488"    # "Week 2", "running -$680 a week"
MONEY = "#e7bd55"
PLANK_INK = "#efe2ce"
PIN_NAVY = "#252b43"
PIN_RING = "#fffbf3"
PIN_RED = "#e1473a"
PILL_NAVY = "#1b253f"
STRIP_NAVY = "#222a44"
TAG_BG = "#1a1f31"
TAG_BAR = "#275696"
TAG_INK = "#8eb8f3"

ICON = {
    "crown": '<path d="M4 17 3 7l5 4 4-6 4 6 5-4-1 10zM4 20h16"/>',
    "bag": '<path d="M9 7h6v9a3 3 0 0 1-6 0zM12 3v4M10 7h4"/>',
    "moon": '<path d="M20 14.500A8 8 0 0 1 9.500 4 8 8 0 1 0 20 14.500z"/>',
    "mat": '<rect x="3" y="5" width="18" height="14" rx="2"/><path d="M3 12h18M12 5v14"/>',
    "flag": '<path d="M5 21V4h12l-2.500 4L17 12H5"/>',
    "target": '<circle cx="12" cy="12" r="9"/><circle cx="12" cy="12" r="5"/><circle cx="12" cy="12" r="1"/>',
    "tired": '<rect x="2" y="8" width="17" height="9" rx="2"/><path d="M22 11v3M6 11v3M10 11v3"/>',
    "scale": '<rect x="3" y="4" width="18" height="16" rx="3"/><path d="M8 9a5 5 0 0 1 8 0M12 9l2-2"/>',
    "mood": '<circle cx="12" cy="12" r="9"/><path d="M8 14c1.200 1.600 6.800 1.600 8 0M9 9.500v.01M15 9.500v.01"/>',
    "rank": '<path d="M4 20V10h5v10M9 20V4h6v16M15 20v-7h5v7M2 20h20"/>',
    "right": '<path d="M10 6l6 6-6 6"/>',
    "week": '<rect x="3" y="5" width="18" height="16" rx="2"/><path d="M3 10h18M8 3v4M16 3v4M8 14h2M14 14h2"/>',
    "plan": '<path d="M4 19c4 0 4-12 9-12h5M15 3l4 4-4 4"/><circle cx="5" cy="6" r="2"/>',
    "bout": '<circle cx="11" cy="11" r="7"/><path d="M16.500 16.500 21 21"/>',
    "talk": '<path d="M4 5h16v10H10l-5 4v-4H4z"/><path d="M8 9h8M8 12h5"/>',
    "trophy": '<path d="M8 4h8v5a4 4 0 0 1-8 0zM8 6H4c0 3 1.500 4.500 4 4.500M16 6h4c0 3-1.500 4.500-4 4.500M12 13v4M8 20h8M10 17h4"/>',
    "check": '<path d="M5 12.500l4.500 4.500L19 7.500"/>',
}


def ico(name, size=24, cls="", sw=2):
    return '<svg class="ico %s" width="%d" height="%d" viewBox="0 0 24 24" style="stroke-width:%s">%s</svg>' % (cls, size, size, sw, ICON[name])


def pin(name, size=56, cls="", icon=None):
    return '<span class="pin %s" style="width:%dpx;height:%dpx">%s</span>' % (cls, size, size, ico(name, icon or int(size * 0.5)))


# ------------------------------------------------------------------ the gym screen's top bar, rebuilt from the game's wood kit
TOP_CSS = """
/* TOP BAR: a copy of the real gym screen's (ref/gym_screen.png): the game's own plank (assets/ui/wood), sizes and inks measured from the picture */
.top{position:absolute;left:0;top:0;width:1920px;height:76px;box-sizing:border-box;border-style:solid;border-width:0 0 8px 0;border-image:url(%(A)s/ui/wood/bar.png) 0 0 8 0 fill stretch;z-index:6}
.pl{position:absolute;box-sizing:border-box;border:9px solid transparent;border-image:url(%(A)s/ui/wood/plank.png) 9 fill stretch;display:flex;align-items:center;justify-content:center;gap:26px;color:%(PLANK_INK)s;font-weight:600;font-size:19px;line-height:1;white-space:nowrap}
.pl.off{opacity:.42}
.pl.need{flex-direction:column;align-items:flex-start;justify-content:center;gap:5px;padding-left:7px}
.pl.need b{font-weight:700;font-size:19px;letter-spacing:.01em}.pl.need i{font-style:normal;font-weight:400;font-size:15px}
.gymname{position:absolute;left:118px;top:17px;font:400 %(NAMEPX)spx/44px Marker;color:%(NAME_BLUE)s;white-space:nowrap}
.tdate{position:absolute;left:402px;top:19px;white-space:nowrap}
.tdate b{display:block;font-weight:600;font-size:19px;line-height:22px;color:%(DATE_INK)s}.tdate i{display:block;font-style:normal;font-weight:400;font-size:15px;line-height:18px;color:%(SOFT_INK)s}
.tcash{position:absolute;right:376px;top:16px;text-align:right;white-space:nowrap}
.tcash b{display:block;font-weight:700;font-size:24px;line-height:28px;color:%(MONEY)s}.tcash i{display:block;font-style:normal;font-weight:400;font-size:15px;line-height:19px;color:%(SOFT_INK)s}
/* the gym screen's own marks, reused below the bar: the round white-ringed pin, its navy label, the blue-tag strip */
.pin{box-sizing:border-box;border-radius:50%%;background:%(PIN_NAVY)s;border:3px solid %(PIN_RING)s;box-shadow:0 3px 9px rgba(0,0,0,.5);display:inline-grid;place-items:center;color:%(PIN_RING)s;flex:none}
.pin.red{background:%(PIN_RED)s}
.pin.maybe{border-style:dashed;border-width:2px;background:rgba(37,43,67,.72)}
.lbl{display:inline-flex;align-items:center;height:36px;padding:0 12px;border-radius:7px;background:%(PILL_NAVY)s;color:%(PIN_RING)s;font-weight:600;font-size:22px;line-height:1;white-space:nowrap}
.strip{display:flex;align-items:center;gap:14px;height:46px;padding:0 16px 0 9px;border-radius:8px;background:%(STRIP_NAVY)s;color:%(PIN_RING)s;font-weight:600;font-size:22px;white-space:nowrap;box-shadow:0 3px 10px rgba(0,0,0,.35)}
.tag{display:inline-flex;align-items:center;height:32px;padding:0 10px 0 9px;background:%(TAG_BG)s;border-left:4px solid %(TAG_BAR)s;color:%(TAG_INK)s;font-weight:600;font-size:20px;letter-spacing:.02em;white-space:nowrap}
.link{color:%(TAG_INK)s}
"""


def top_css(name_px=32):
    d = dict(globals())
    d["NAMEPX"] = name_px
    return TOP_CSS % d


def top_html():
    return (
        '<div class="top">'
        '<span class="pl" style="left:17px;top:17px;width:38px;height:43px;font-size:20px">&lt;</span>'
        '<span class="pl off" style="left:67px;top:17px;width:38px;height:43px;font-size:20px">&gt;</span>'
        '<span class="gymname">Anvil Street Gym</span>'
        '<span class="tdate"><b>Mon 12 Jan 2026</b><i>Week 2</i></span>'
        '<span class="pl" style="left:655px;top:15px;width:127px;height:46px">' + ico("bag", 27, "", 1.7) + 'Gym</span>'
        '<span class="pl" style="left:789px;top:15px;width:128px;height:46px">Mail (5 new)</span>'
        '<span class="tcash"><b>$16,841</b><i>running -$680 a week</i></span>'
        '<span class="pl need" style="left:1557px;top:13px;width:268px;height:50px"><b>NEEDS YOU (1)</b><i>Answer Lucy\'s bout offer</i></span>'
        '<span class="pl" style="left:1840px;top:18px;width:59px;height:39px;font-size:16px">Menu</span>'
        '</div>')


# ------------------------------------------------------------------ overview.html = overview_a.html + the allowed changes
def cut(s, start, end, new, include_end=False):
    i = s.index(start)
    j = s.index(end, i + len(start)) + (len(end) if include_end else 0)
    return s[:i] + new + s[j:]


def build_overview():
    s = SRC_A.read_text(encoding="utf-8")
    s = s.replace("<title>Overview A - the body chart</title>", "<title>Fighter page, Profile: the body chart (set Z)</title>")
    s = s.replace("../../../assets", A)
    # (1) the top bar: the gym screen's
    s = cut(s, "/* top bar: as the game draws it today", "/* tabs:", top_css())
    s = cut(s, '<div class="top">', '<div class="tabs">', top_html())
    # (4) the six tabs
    s = cut(s, '<div class="tabs">', "</div>", '<div class="tabs"><span class="tab on">Profile</span><span class="tab">Condition</span><span class="tab">Training</span>'
            '<span class="tab">Playbook</span><span class="tab">Fight plan</span><span class="tab">History</span></div>', include_end=True)
    # (6) the next step: the gym screen's blue-tag strip carries it; the gold button stays
    s = s.replace(".step{position:absolute;left:560px;", ".step .strip,.step .strip span{color:%s}.step .strip .tag,.step .strip .link{color:%s} .step{position:absolute;left:800px;" % (PIN_RING, TAG_INK))
    s = cut(s, '<div class="step">', '</div>',
            '<div class="step">' + ico("trophy", 30) + '<span class="h">NEXT STEP</span>'
            '<span class="strip"><span class="tag">SHOW IN 19 DAYS</span><span>Offer: <span class="link">Maria Ortega</span>, Sat 31 Jan</span></span>'
            '<span class="go" style="margin-left:2px">Answer the bout offer</span></div>', include_end=True)
    s = s.replace("Lightweight, 21, orthodox, amateur 3-2", "Lightweight, 21, orthodox, amateur 3-1")
    # (5) the real 3D figure (cut out of ref/overview_today.png) in the placeholder's place
    s = cut(s, '<div class="abs" style="left:806px;top:236px"><svg class="fig"', '<svg class="lead"',
            '<div class="abs" style="left:838px;top:986px;width:250px;height:44px;border-radius:50%;background:radial-gradient(closest-side,rgba(0,0,0,.72),rgba(0,0,0,0))"></div>'
            '<img class="fig" src="lucy_figure.png" width="360" height="828" style="position:absolute;left:783px;top:212px">')
    lead = []
    for d, (cx, cy) in (("M386 290 H700 L979 262", (979, 262)), ("M234 582 H720 L884 352", (884, 352)),
                        ("M1264 172 H1200 L1069 392", (1069, 392)), ("M1264 306 H1180 L1016 500", (1016, 500)),
                        ("M1264 480 H1210 L1040 690", (1040, 690)), ("M1264 654 H1230 L1060 984", (1060, 984))):
        lead.append('<path d="%s" fill="none" stroke="rgba(241,232,218,.42)" stroke-width="2" stroke-dasharray="2 7" stroke-linecap="round"/>'
                    '<circle cx="%d" cy="%d" r="6" fill="#f1e8da"/><circle cx="%d" cy="%d" r="12" fill="none" stroke="rgba(241,232,218,.35)" stroke-width="2"/>' % (d, cx, cy, cx, cy))
    s = cut(s, '<svg class="lead" width="1920" height="1080">', "</svg>", '<svg class="lead" width="1920" height="1080" style="z-index:3">' + "".join(lead) + "</svg>", include_end=True)
    # (2) Engine is called Cardio
    s = s.replace("<h3>ENGINE<span>", "<h3>CARDIO<span>")
    assert "ngine" not in s
    # (3) On the scale: weight against the limit AND the tiredness meter (bar, number, rest days)
    s = cut(s, '<h3>ON THE SCALE<span>today</span></h3>', '<div class="goal">',
            '<h3>ON THE SCALE<span>today</span></h3>'
            '<div class="r fair">' + ico("scale") + '<span class="n">Weight</span><span class="bar"><b style="width:95%"></b><em style="left:86%"></em></span>'
            '<span class="v" style="grid-column:4/6;text-align:left;white-space:nowrap">60.9 <span class="cap">kg, limit 60.0</span></span></div>'
            '<div class="r strong">' + ico("tired") + '<span class="n">Tiredness</span><span class="bar tz"><b style="width:38%"></b><em style="left:50%"></em></span>'
            '<span class="v">38</span><span class="cap">Fresh, 0 rest days</span></div></div>')
    s = s.replace(".h{font-weight:700;", ".bar.tz{background:linear-gradient(90deg,var(--track) 0 50%,rgba(242,141,39,.28) 50% 80%,rgba(221,75,61,.42) 80% 100%)}\n.h{font-weight:700;")
    # (6) the four actions keep their shape; each icon sits in the gym screen's pin
    s = s.replace(".btn .ico{color:var(--gold)}", ".btn .pin .ico{color:%s}" % PIN_RING)
    s = s.replace(".acts .btn{height:64px}", ".acts .btn{height:64px;padding-left:14px}")
    for old_w in ("week", "plan", "bout", "talk"):
        old = '<svg class="ico " width="28" height="28" viewBox="0 0 24 24">%s</svg>' % ICON[old_w]
        assert old in s, old_w
        s = s.replace(old, pin(old_w, 44, "", 24))
    # the guide's line for this Monday (four fighters are signed; Lucy's offer is what waits)
    s = s.replace("Next job for the club: sign a second boxer.", "Lucy has a bout offer. Answer it by Thursday.")
    s = s.replace(".fig{display:block;", ".fig{display:block;z-index:2;")
    (HERE / "overview.html").write_text(s, encoding="utf-8")


# ------------------------------------------------------------------ squad.html
BASE_CSS = """
@font-face{font-family:Marker;src:url(%(A)s/fonts/PermanentMarker-Regular.ttf)}
@font-face{font-family:Barlow;font-weight:400;src:url(%(A)s/fonts/Barlow-Regular.ttf)}
@font-face{font-family:Barlow;font-weight:500;src:url(%(A)s/fonts/Barlow-Medium.ttf)}
@font-face{font-family:Barlow;font-weight:600;src:url(%(A)s/fonts/Barlow-SemiBold.ttf)}
@font-face{font-family:Barlow;font-weight:700;src:url(%(A)s/fonts/Barlow-Bold.ttf)}
@font-face{font-family:Bebas;src:url(%(A)s/fonts/BebasNeue-Regular.ttf)}
@font-face{font-family:Kalam;font-weight:700;src:url(%(A)s/fonts/Kalam-Bold.ttf)}
:root{--ink:#f1e8da;--soft:#c9b9a2;--gold:#ffd24a;--red:#dd4b3d;--blue:#4d8ef0;--green:#3fc07a;--amber:#f28d27;--purple:#ad80ff;--track:rgba(255,255,255,.10)}
*{box-sizing:border-box;margin:0;padding:0}
html,body{width:1920px;height:1080px;overflow:hidden}
body{position:relative;background:#120e0c;color:var(--ink);font:500 22px/1.2 Barlow,"Segoe UI",sans-serif}
.ico{fill:none;stroke:currentColor;stroke-width:2;stroke-linecap:round;stroke-linejoin:round;flex:none}
.abs{position:absolute}
/* the same dim wall and lamp as the fighter page (overview_a) */
.wall{position:absolute;left:0;right:0;top:76px;bottom:0;background:
 radial-gradient(ellipse 900px 520px at 50%% 20%%,rgba(255,190,110,.12),transparent 72%%),
 radial-gradient(ellipse 620px 420px at 4%% 60%%,rgba(221,75,61,.06),transparent 70%%),
 radial-gradient(ellipse 620px 420px at 97%% 55%%,rgba(77,142,240,.06),transparent 70%%),
 linear-gradient(#1b1512,#130f0d 62%%,#0e0b09)}
/* page head: brush title, tabs (the chosen one glows), the next step */
.title{position:absolute;left:28px;top:90px;font:400 50px/56px Marker;color:#fff;white-space:nowrap}
.tabs{position:absolute;left:300px;top:94px;display:flex;gap:6px}
.tab{height:48px;padding:0 20px;border-radius:10px;display:flex;align-items:center;font-weight:600;color:var(--soft);background:rgba(255,255,255,.05);white-space:nowrap}
.tab.on{color:#fff;background:rgba(255,214,120,.16);box-shadow:0 0 26px 2px rgba(255,205,90,.42)}
.step{position:absolute;right:28px;top:90px;height:56px;display:flex;align-items:center;gap:14px}
.go{display:inline-flex;align-items:center;justify-content:center;height:56px;padding:0 24px;border-radius:11px;background:linear-gradient(#ffe070,#f0b32a);color:#2a1b06;font-weight:700;font-size:23px;box-shadow:0 3px 0 #9a6c10;white-space:nowrap}
.h{font-weight:700;font-size:20px;letter-spacing:.09em;color:var(--gold);white-space:nowrap}
.cap{color:var(--soft);font-size:20px;white-space:nowrap}
/* column heads */
.ch{position:absolute;top:160px;height:26px;line-height:26px}
.ax{position:absolute;top:160px;height:26px;line-height:26px;font-size:20px;color:var(--soft);white-space:nowrap}
/* one fighter = one row */
.row{position:absolute;left:28px;width:1864px;height:162px;border-radius:16px;background:linear-gradient(90deg,rgba(255,255,255,.060),rgba(255,255,255,.035))}
.row.sel{background:linear-gradient(90deg,rgba(255,210,74,.10),rgba(255,210,74,.045));box-shadow:0 0 28px 2px rgba(255,205,90,.20)}
.face{position:absolute;left:18px;top:10px;width:116px;height:116px;border-radius:50%%;border:3px solid %(PIN_RING)s;background-size:138%%;background-position:50%% 26%%;box-shadow:0 3px 10px rgba(0,0,0,.5)}
.cls{position:absolute;left:76px;top:110px;transform:translateX(-50%%);height:34px;font-size:20px;padding:0 11px}
.nm{position:absolute;left:170px;top:18px;font:400 33px/40px Marker;color:#fff;white-space:nowrap}
.sub{position:absolute;left:170px;top:62px;font-size:22px;line-height:28px;color:var(--soft);white-space:nowrap}
.rk{position:absolute;left:170px;top:98px;height:30px;display:flex;align-items:center;gap:9px;font-size:20px;font-weight:600;color:var(--ink);white-space:nowrap}
.rk .ico{color:var(--soft)}
.belt{position:relative;display:inline-block;width:76px;height:20px;border-radius:4px;background:#ece6da;flex:none;overflow:hidden}
.belt u{position:absolute;right:15px;top:0;width:27px;height:20px;background:#3b3632}
.belt s{position:absolute;top:0;width:3px;height:20px;background:#ece6da}
/* rings */
.rg{position:absolute;border-radius:50%%;display:grid;place-items:center}
.rg:before{content:"";position:absolute;inset:0;border-radius:50%%;background:conic-gradient(var(--c) 0 calc(var(--p)*1%%),var(--track) calc(var(--p)*1%%) 100%%);-webkit-mask:radial-gradient(closest-side,transparent 73%%,#000 75%%);mask:radial-gradient(closest-side,transparent 73%%,#000 75%%)}
.rg b{font:400 42px/1 Bebas;color:#fff;letter-spacing:.02em;padding-top:4px}
.rg.sm b{font-size:31px}
.rg .ico{color:var(--c)}
/* meter tiles: icon, big number, bar with a tick, two words */
.tile{position:absolute;top:12px;width:136px;height:138px;border-radius:13px;background:rgba(255,255,255,.05)}
.tile.hot{background:rgba(242,141,39,.13);box-shadow:0 0 22px 2px rgba(242,141,39,.38)}
.tile .ico{position:absolute;left:13px;top:17px;color:var(--soft)}
.tile b.n{position:absolute;left:46px;top:9px;font:400 50px/50px Bebas;letter-spacing:.01em;color:color-mix(in srgb,var(--c) 80%%,#fff)}
.tile .bar{position:absolute;left:14px;top:72px;width:108px}
.tile i{position:absolute;left:14px;top:99px;font-style:normal;font-weight:600;font-size:20px;line-height:26px;white-space:nowrap;color:color-mix(in srgb,var(--c) 70%%,#fff)}
.bar{position:relative;height:13px;border-radius:7px;background:var(--track);display:block}
.bar b{position:absolute;left:0;top:0;bottom:0;border-radius:7px;background:var(--c)}
.bar em{position:absolute;top:-5px;width:3px;height:23px;border-radius:2px;background:#fff}
.bar.tz{background:linear-gradient(90deg,var(--track) 0 50%%,rgba(242,141,39,.30) 50%% 80%%,rgba(221,75,61,.45) 80%% 100%%)}
.g{--c:var(--green)}.a{--c:var(--amber)}.r{--c:var(--red)}.b{--c:var(--blue)}.q{--c:#bfb3a2}
/* goal */
.gl{position:absolute;left:1098px;top:30px;white-space:nowrap}
.gl b{display:block;font-weight:700;font-size:22px;line-height:28px}.gl span{display:block;font-size:20px;line-height:26px;color:var(--soft)}
.gl em{display:block;font-style:normal;font-weight:700;font-size:20px;line-height:26px;color:var(--c)}
/* the next four weeks */
.tk{position:absolute;left:1290px;top:0;width:330px;height:162px}
.tk .big{position:absolute;left:6px;top:14px;display:flex;align-items:baseline;gap:8px;white-space:nowrap;font-weight:600;font-size:22px}
.tk .big b{font:400 44px/44px Bebas;color:#fff;letter-spacing:.01em}
.tk .big u{text-decoration:none;font-size:20px;color:var(--soft);font-weight:500;margin-right:4px}
.tk .l2{position:absolute;left:6px;top:62px;font-size:20px;line-height:26px;color:var(--soft);white-space:nowrap}
.tk .none{position:absolute;left:6px;top:24px;font-weight:600;font-size:22px;color:#a39683}
.ln{position:absolute;left:6px;top:116px;width:318px;height:5px;border-radius:3px;background:rgba(255,255,255,.20)}
.ln s{position:absolute;top:-6px;width:2px;height:16px;background:rgba(255,255,255,.26)}
.ln i{position:absolute;top:-4px;width:10px;height:10px;margin-left:-5px;margin-top:1px;transform:rotate(45deg);background:#8d7f6d}
.ln .pin{position:absolute;top:-16px;margin-left:-18px}
.ln .rest{position:absolute;left:0;top:-13px;height:30px;border-radius:8px;background:rgba(242,141,39,.26);box-shadow:0 0 14px 1px rgba(242,141,39,.30);display:flex;align-items:center;justify-content:center;color:var(--amber)}
.ln .due{position:absolute;top:-21px;margin-left:-8px;width:0;height:0;border:8px solid transparent;border-top:12px solid var(--red)}
/* the one action: the gym screen's pin with its label */
.act{position:absolute;left:1640px;top:16px;width:186px;display:flex;flex-direction:column;align-items:center;gap:7px}
.open{position:absolute;right:14px;top:66px;color:#8f8272}
/* the guide, as on the fighter page */
.guide{position:absolute;left:14px;bottom:14px;display:flex;align-items:flex-end}
.gface{width:190px;height:190px}
.gtail{width:24px;height:40px;margin-bottom:34px;background:#8a6a3d;clip-path:polygon(0 55%%,100%% 0,100%% 100%%)}
.gbub{width:452px;background:#262a2d;border:3px solid #8a6a3d;border-radius:24px;padding:14px 22px}
.gbub p{font:700 27px/34px Kalam,"Segoe Print",cursive;color:#efe6d8}
.gbub div{display:flex;justify-content:flex-end;margin-top:8px}
.gskip{height:38px;padding:0 14px;border-radius:9px;background:rgba(255,255,255,.07);color:var(--soft);font-size:20px;font-weight:600;display:flex;align-items:center}
/* the hover card: the gym screen's navy and blue tag */
.hov{position:absolute;left:704px;top:880px;width:608px;height:184px;border-radius:12px;background:%(STRIP_NAVY)s;box-shadow:0 10px 34px rgba(0,0,0,.6),0 0 0 1px rgba(142,184,243,.20);z-index:4}
.hov:before{content:"";position:absolute;left:22px;top:-12px;border:12px solid transparent;border-top:0;border-bottom:13px solid %(STRIP_NAVY)s}
.hov .hd{position:absolute;left:14px;top:14px;display:flex;align-items:center;gap:12px;font-weight:700;font-size:22px;color:%(PIN_RING)s;white-space:nowrap}
.hov p{position:absolute;left:16px;top:60px;font-size:21px;line-height:29px;color:#dfe5f2;white-space:nowrap}
.hov p b{color:#fff;font-weight:700}
.mini{position:absolute;right:14px;top:14px;width:244px;height:154px}
.mini .mc{position:absolute;right:2px;top:0;font-size:20px;line-height:24px;color:#aab6d0;white-space:nowrap}
.mini .fr{position:absolute;left:0;width:190px;border-top:2px dashed rgba(120,230,160,.9)}
.mini .fl{position:absolute;left:196px;font-weight:600;font-size:20px;line-height:22px;color:#78e6a0;white-space:nowrap}
.mini .col{position:absolute;bottom:26px;width:40px;border-radius:5px 5px 0 0;z-index:1}
.mini .col b{display:block;text-align:center;font-weight:700;font-size:20px;line-height:26px;color:#1b1206}
.mini .d{position:absolute;bottom:0;width:40px;text-align:center;font-size:20px;line-height:22px;color:#aab6d0}
.cur{position:absolute;z-index:5}
/* the key */
.key{position:absolute;left:1340px;display:flex;align-items:center;gap:10px;font-size:20px;color:var(--soft);white-space:nowrap;height:40px}
.key .sp{width:22px}
.key em{display:inline-block;width:3px;height:22px;background:#fff;border-radius:2px}
.key i{display:inline-block;width:11px;height:11px;transform:rotate(45deg);background:#8d7f6d;margin:0 3px}
.key .rest{display:inline-flex;width:40px;height:26px;border-radius:7px;background:rgba(242,141,39,.26);color:var(--amber);align-items:center;justify-content:center}
.key .due{display:inline-block;width:0;height:0;border:8px solid transparent;border-top:12px solid var(--red);margin-top:10px}
"""

DAYPX = 318.0 / 28.0


def dx(day):
    return round(day * DAYPX, 1)


def tile(left, icon, num, tone, pct, tick, word, hot=False, tz=False):
    em = '<em style="left:%s%%"></em>' % tick if tick is not None else ""
    return ('<div class="tile %s%s" style="left:%dpx">%s<b class="n">%s</b><span class="bar%s"><b style="width:%s%%"></b>%s</span><i>%s</i></div>'
            % (tone, " hot" if hot else "", left, ico(icon), num, " tz" if tz else "", pct, em, word))


def track(big, name, l2, marks, none=""):
    out = '<div class="tk">'
    if big:
        out += '<div class="big"><b>%s</b><u>days</u>%s</div>' % (big, name)
    else:
        out += '<div class="none">%s</div>' % none
    if l2:
        out += '<div class="l2">%s</div>' % l2
    out += '<div class="ln">' + "".join('<s style="left:%spx"></s>' % dx(d) for d in (0, 7, 14, 21, 28))
    out += '<i style="left:%spx"></i><i style="left:%spx"></i>' % (dx(5), dx(19))   # club show nights: Sat 17 and Sat 31 Jan
    out += marks + "</div></div>"
    return out


FIGHTERS = [
    dict(key="lucy", name="LUCY JACKSON", cls="Lightweight", sub="3-1 &middot; 21 &middot; orthodox", rank=ico("rank", 22) + "1 win to be ranked", overall=60,
         tiles=[("tired", "38", "g", 38, 50, "Fresh", False, True), ("scale", "60.9", "a", 95, 86, "0.9 kg over", False, False), ("mood", "62", "b", 62, None, "Steady", False, False)],
         goal=("g", 40, "40", "Stamina to 61", "18 days left", "On track"),
         track=track("19", '<span class="link">Maria Ortega</span>', "offer: answer by Thu 15 Jan",
                     '<span class="due" style="left:%spx"></span><span class="pin maybe" style="left:%spx;width:36px;height:36px">%s</span>' % (dx(3), dx(19), ico("crown", 20))),
         act=("crown", "red", "Answer offer")),
    dict(key="samira", name="SAMIRA KHAN", cls="Welterweight", sub="2-1 &middot; 18 &middot; orthodox", rank=ico("rank", 22) + "2 wins to be ranked", overall=58,
         tiles=[("tired", "44", "g", 44, 50, "Fresh", False, True), ("scale", "65.9", "q", 95, 86, "0.9 kg over", False, False), ("mood", "78", "g", 78, None, "Fired up", False, False)],
         goal=("g", 100, None, "Goal met", "Defence to 52", "Pick the next"),
         track=track("", "", "", "", none="No bout"),
         act=("flag", "", "Set a goal")),
    dict(key="ana", name="ANA RIBEIRO", cls="Feather, no-gi", sub="4-2 in opens &middot; 22", rank='<span class="belt"><u></u><s style="right:22px"></s><s style="right:31px"></s></span>White belt, 2 stripes', overall=52,
         tiles=[("tired", "30", "g", 30, 50, "Fresh", False, True), ("scale", "57.2", "g", 72, 86, "In class", False, False), ("mood", "55", "b", 55, None, "Steady", False, False)],
         goal=("g", 62, "62", "Third stripe", "6 classes left", "On track"),
         track=track("12", "London No-Gi Open", "not entered yet",
                     '<span class="pin maybe" style="left:%spx;width:36px;height:36px">%s</span>' % (dx(12), ico("mat", 20))),
         act=("mat", "", "Enter the open")),
    dict(key="tess", name="TESS REILLY", cls="Middleweight", sub="6-4 &middot; 23 &middot; southpaw", rank=ico("rank", 22) + "Number 8, London", overall=61, sel=True,
         tiles=[("tired", "72", "a", 72, 50, "3 rest days", True, True), ("scale", "76.1", "q", 96, 86, "1.1 kg over", False, False), ("mood", "58", "b", 58, None, "Steady", False, False)],
         goal=("g", 45, "45", "Speed to 57", "16 days left", "On track"),
         track=track("", "", '<span style="color:var(--amber);font-weight:600">3 rest days first</span>', '<span class="rest" style="width:%spx">%s</span>' % (dx(3), ico("moon", 20)), none="No bout"),
         act=("moon", "", "Rest days")),
]


def row(i, f):
    top = 192 + i * 170
    out = '<div class="row%s" style="top:%dpx">' % (" sel" if f.get("sel") else "", top)
    out += '<div class="face" style="background-image:url(face_%s.jpg)"></div><span class="lbl cls">%s</span>' % (f["key"], f["cls"])
    out += '<div class="nm">%s</div><div class="sub">%s</div><div class="rk">%s</div>' % (f["name"], f["sub"], f["rank"])
    out += '<div class="rg" style="left:446px;top:35px;width:92px;height:92px;--c:var(--gold);--p:%d"><b>%d</b></div>' % (f["overall"], f["overall"])
    for n, t in enumerate(f["tiles"]):
        icon, num, tone, pct, tick, word, hot, tz = t
        out += tile(566 + n * 146, icon, num, tone, pct, tick, word, hot, tz)
    tone, p, num, title, l2, status = f["goal"]
    inner = "<b>%s</b>" % num if num else ico("check", 34, "", 2.6)
    out += '<div class="rg sm %s" style="left:1010px;top:43px;width:76px;height:76px;--p:%d">%s</div>' % (tone, p, inner)
    out += '<div class="gl %s"><b>%s</b><span>%s</span><em>%s</em></div>' % (tone, title, l2, status)
    out += f["track"]
    icon, cls, label = f["act"]
    out += '<div class="act">%s<span class="lbl">%s</span></div>' % (pin(icon, 60, cls, 30), label)
    out += '<div class="open">%s</div>' % ico("right", 30)
    return out + "</div>"


GUIDE = """<div class="guide"><div class="gface"><svg width="190" height="190" viewBox="0 0 190 190"><defs><clipPath id="gc"><circle cx="95" cy="95" r="88"/></clipPath>
<radialGradient id="gr" cx=".5" cy=".35" r=".8"><stop offset="0" stop-color="#5b4a3a"/><stop offset="1" stop-color="#231c17"/></radialGradient></defs>
<circle cx="95" cy="95" r="88" fill="url(#gr)"/><g clip-path="url(#gc)"><path d="M22 200q4-62 73-62t73 62z" fill="#39424a"/>
<rect x="82" y="112" width="26" height="30" fill="#b08a6c"/><ellipse cx="95" cy="88" rx="33" ry="38" fill="#c39b7a"/>
<path d="M60 96q2 34 35 36 33-2 35-36-6 20-35 20T60 96z" fill="#e6e0d6"/>
<path d="M56 70q4-34 40-34 34 0 40 30l14 6q-30 6-94-2z" fill="#2b3036"/></g>
<circle cx="95" cy="95" r="88" fill="none" stroke="#8a6a3d" stroke-width="4"/></svg></div><div class="gtail"></div><div class="gbub"><p>%s</p><div><span class="gskip">Skip the guide</span></div></div></div>"""


def build_squad():
    css = (BASE_CSS % dict(globals())) + top_css()
    b = ['<div class="wall"></div>', top_html()]
    b.append('<div class="title">FIGHTERS</div>')
    b.append('<div class="tabs"><span class="tab on">Roster</span><span class="tab">Compare</span><span class="tab">Find a fighter</span></div>')
    b.append('<div class="step"><span class="strip"><span class="tag">SHOW IN 19 DAYS</span><span>Lucy has an offer: <span class="link">Maria Ortega</span>, Sat 31 Jan</span></span>'
             '<span class="go">Answer the bout offer</span></div>')
    # column heads
    for left, word in ((28 + 446, "OVERALL"), (28 + 566, "TIREDNESS"), (28 + 712, "WEIGHT"), (28 + 858, "MOOD"), (28 + 1010, "GOAL")):
        b.append('<span class="ch h" style="left:%dpx">%s</span>' % (left, word))
    for d, word in ((0, "12 Jan"), (7, "19"), (14, "26"), (21, "2 Feb")):
        b.append('<span class="ax" style="left:%spx">%s</span>' % (28 + 1290 + 6 + dx(d), word))
    b.append('<span class="ch h" style="left:%dpx;width:186px;text-align:center">DO NEXT</span>' % (28 + 1640))
    for i, f in enumerate(FIGHTERS):
        b.append(row(i, f))
    b.append(GUIDE % "Lucy's offer runs out on Thursday. Answer it first.")
    # one hover drawn open: Tess's tiredness
    cols = ""
    for n, (v, d, c) in enumerate(((72, "now", "var(--amber)"), (63, "1", "var(--amber)"), (55, "2", "#e0b040"), (47, "3", "var(--green)"))):
        h = round(v * 0.95)
        x = 0 + n * 49
        cols += '<span class="col" style="left:%dpx;height:%dpx;background:%s"><b>%d</b></span><span class="d" style="left:%dpx">%s</span>' % (x, h, c, v, x, d)
    b.append('<div class="hov"><div class="hd"><span class="tag">TIREDNESS</span>Tess: 72 of 100</div>'
             '<p>Under <b>50</b> is fresh.<br>A full rest day takes off an eighth.<br>Over <b>80</b>, training counts 60%%.</p>'
             '<div class="mini"><span class="mc">after rest days</span><span class="fr" style="top:%dpx"></span><span class="fl" style="top:%dpx">fresh</span>%s</div></div>' % (154 - 26 - round(50 * 0.95), 154 - 26 - round(50 * 0.95) - 11, cols))
    b.append('<svg class="cur" style="left:694px;top:752px" width="30" height="34" viewBox="0 0 30 34"><path d="M3 2v25l6.500-6 4.500 10.500 4.500-2L14 19h9z" fill="#fff" stroke="#111" stroke-width="2" stroke-linejoin="round"/></svg>')
    # the key
    b.append('<div class="key" style="top:884px">' + pin("crown", 30, "red", 16) + 'needs you now<span class="sp"></span>' + pin("bag", 30, "", 16) + 'the next step</div>')
    b.append('<div class="key" style="top:930px"><span class="pin maybe" style="width:30px;height:30px">' + ico("crown", 16) + '</span>offered, not booked<span class="sp"></span><span class="due"></span>answer by</div>')
    b.append('<div class="key" style="top:976px"><i></i>club show night<span class="sp"></span><span class="rest">' + ico("moon", 18) + '</span>rest first<span class="sp"></span><em></em>&nbsp;limit, fresh line</div>')
    b.append('<div class="key" style="top:1022px">' + ico("right", 24) + 'a row opens the fighter&rsquo;s page</div>')
    html = ('<!doctype html>\n<html lang="en"><head><meta charset="utf-8"><title>Fighters: the squad (set Z)</title>\n<style>' + css + "</style></head>\n<body>"
            + "\n".join(b) + "</body></html>\n")
    (HERE / "squad.html").write_text(html, encoding="utf-8")


if __name__ == "__main__":
    build_overview()
    build_squad()
    print("wrote overview.html, squad.html")
