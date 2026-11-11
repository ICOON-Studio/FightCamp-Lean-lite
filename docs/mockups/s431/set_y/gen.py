"""Writes squad.html and overview.html (S431 set Y). Run from anywhere:  python docs/mockups/s431/set_y/gen.py
then  python tools/render_mockup.py docs/mockups/s431/set_y/squad.html docs/mockups/s431/set_y/overview.html
The Overview is docs/mockups/s430/overview_a.html with the six listed changes; the top bar on both pages is a copy of the
gym screen's bar, built from the game's own wood pieces (assets/ui/wood) and fonts (assets/fonts)."""
import pathlib

HERE = pathlib.Path(__file__).resolve().parent
A = "../../../../assets/"

I = {  # 24x24 line icons, drawn here
    "bag": "M12 2.5v3M8 5.5h8v10a4 4 0 0 1-8 0zM8 9.5h8",
    "bulb": "M9 18h6M10 21h4M12 3a6 6 0 0 0-4 10.5V15h8v-1.5A6 6 0 0 0 12 3z",
    "waves": "M3 9c3-3 6 3 9 0s6 3 9 0M3 15c3-3 6 3 9 0s6 3 9 0",
    "list": "M4 6l1.5 1.5L8 5M4 12l1.5 1.5L8 11M4 18l1.5 1.5L8 17M11 6h9M11 12h9M11 18h9",
    "trend": "M3 17l6-6 4 4 8-8M15 7h6v6",
    "chat": "M4 5h16v10H10l-5 4v-4H4z",
    "flame": "M12 3c1 4 5 5 5 10a5 5 0 0 1-10 0c0-2 1-3 2-4 0 2 1 3 2 3 0-3-1-5 1-9z",
    "target": "M12 3a9 9 0 1 0 .01 0M12 7.5a4.5 4.5 0 1 0 .01 0M12 11.6a.4.4 0 1 0 .01 0",
    "clock": "M12 3a9 9 0 1 0 .01 0M12 7v5l3.5 2",
    "inout": "M2 12h7M6 8l4 4-4 4M22 12h-7M18 8l-4 4 4 4",
    "dumb": "M4 9v6M7 6v12M17 6v12M20 9v6M7 12h10",
    "bolt": "M13 2 4 14h7l-1 8 9-12h-7z",
    "shieldhalf": "M12 3l8 3v6c0 5-3.5 8-8 9-4.5-1-8-4-8-9V6zM12 3v18",
    "shield": "M12 3l8 3v6c0 5-3.5 8-8 9-4.5-1-8-4-8-9V6z",
    "pulse": "M2 12h5l2-6 4 12 2-6h7",
    "cycle": "M20 11a8 8 0 1 0-2.3 5.7M20 5v6h-6",
    "heart": "M12 20s-7-4.5-7-10a4 4 0 0 1 7-2.5A4 4 0 0 1 19 10c0 5.500-7 10-7 10z",
    "chev2": "M4 6l6 6-6 6M12 6l6 6-6 6",
    "feet": "M8 3a3 5 0 1 0 .01 0M16 10a3 5 0 1 0 .01 0",
    "arc": "M5 19c0-9 5-14 14-14M13 5h6v6",
    "scale": "M6 4h12a3 3 0 0 1 3 3v10a3 3 0 0 1-3 3H6a3 3 0 0 1-3-3V7a3 3 0 0 1 3-3zM8 9a5 5 0 0 1 8 0M12 9l2-2",
    "battery": "M4 8h13a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2zM22 11v3M6 11v3M10 11v3",
    "plan": "M5 5h14a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V7a2 2 0 0 1 2-2zM3 10h18M8 3v4M16 3v4M8 14h2M14 14h2",
    "arrowplan": "M4 19c4 0 4-12 9-12h5M15 3l4 4-4 4M5 4a2 2 0 1 0 .01 0",
    "search": "M11 4a7 7 0 1 0 .01 0M16.5 16.5 21 21",
    "talk": "M4 5h16v10H10l-5 4v-4H4zM8 9h8M8 12h5",
    "trophy": "M8 4h8v5a4 4 0 0 1-8 0zM8 6H4c0 3 1.5 4.5 4 4.5M16 6h4c0 3-1.5 4.5-4 4.5M12 13v4M8 20h8M10 17h4",
    "road": "M6 21 9 3M18 21 15 3M12 5v2M12 11v2M12 17v2",
    "rope": "M4 5v14M20 5v14M4 9c5 5 11-5 16 0M4 15c5 3 11-3 16 0",
    "bed": "M3 18V8M3 14h18v4M21 14v-2a3 3 0 0 0-3-3h-6v5M7.5 10a1.4 1.4 0 1 0 .01 0",
    "mat": "M3 6h18v12H3zM3 12h18M12 6v12",
    "doc": "M6 3h9l4 4v14H6zM14 3v5h5M9 13h7M9 17h5",
    "smile": "M12 3a9 9 0 1 0 .01 0M8.5 14c1 2 6 2 7 0M9 9.5v.6M15 9.5v.6",
    "meh": "M12 3a9 9 0 1 0 .01 0M9 14.500h6M9 9.5v.6M15 9.5v.6",
    "frown": "M12 3a9 9 0 1 0 .01 0M8.5 16c1-2 6-2 7 0M9 9.5v.6M15 9.5v.6",
    "back": "M14 6l-6 6 6 6",
}


def ico(name, size=24, cls="", style=""):
    return f'<svg class="ico {cls}" width="{size}" height="{size}" viewBox="0 0 24 24" style="{style}"><path d="{I[name]}"/></svg>'


FONTS = f"""@font-face{{font-family:Marker;src:url({A}fonts/PermanentMarker-Regular.ttf)}}
@font-face{{font-family:Barlow;font-weight:400;src:url({A}fonts/Barlow-Regular.ttf)}}
@font-face{{font-family:Barlow;font-weight:500;src:url({A}fonts/Barlow-Medium.ttf)}}
@font-face{{font-family:Barlow;font-weight:600;src:url({A}fonts/Barlow-SemiBold.ttf)}}
@font-face{{font-family:Barlow;font-weight:700;src:url({A}fonts/Barlow-Bold.ttf)}}
@font-face{{font-family:Bebas;src:url({A}fonts/BebasNeue-Regular.ttf)}}
@font-face{{font-family:Kalam;font-weight:700;src:url({A}fonts/Kalam-Bold.ttf)}}
"""

# Everything both pages share. Colours marked GYM were sampled from docs/mockups/s431/ref/gym_screen.png.
COMMON = FONTS + f""":root{{--ink:#f1e8da;--soft:#c9b9a2;--gold:#ffd24a;--red:#dd4b3d;--blue:#4d8ef0;--green:#3fc07a;--amber:#f28d27;--purple:#ad80ff;
 --track:rgba(255,255,255,.10);--weak:#dd4b3d;--fair:#f28d27;--solid:#4d8ef0;--strong:#3fc07a;--elite:#ad80ff;
 --navy:#1c2640;--ring:#fdf9f1;--pinred:#e1473a;--strip:#252d45;--tagbg:#1a1f31;--tagbar:#275696;--tagink:#8eb8f2;--chalk:#efe2ce;--chalksoft:#b7a588}}
*{{box-sizing:border-box;margin:0;padding:0}}
html,body{{width:1920px;height:1080px;overflow:hidden}}
body{{position:relative;background:#120e0c;color:var(--ink);font:500 22px/1.2 Barlow,"Segoe UI",sans-serif}}
.ico{{fill:none;stroke:currentColor;stroke-width:2;stroke-linecap:round;stroke-linejoin:round;flex:none}}
.abs{{position:absolute}}
.wall{{position:absolute;left:0;right:0;top:76px;bottom:0;background:
 radial-gradient(ellipse 760px 520px at var(--lamp,50%) 26%,rgba(255,190,110,.13),transparent 72%),
 radial-gradient(ellipse 620px 420px at 4% 60%,rgba(221,75,61,.06),transparent 70%),
 radial-gradient(ellipse 620px 420px at 97% 55%,rgba(77,142,240,.06),transparent 70%),
 linear-gradient(#1b1512,#130f0d 62%,#0e0b09)}}
/* TOP BAR: the gym screen's bar, piece for piece (bar.png, plank.png, tab.png are the game's own). Its type sizes are the build's. */
.top{{position:absolute;left:0;top:0;width:1920px;height:76px;border-style:solid;border-width:0 0 8px 0;border-image:url({A}ui/wood/bar.png) 0 0 8 0 fill/0 0 8px 0 stretch;color:var(--chalk)}}
.top>*{{position:absolute;white-space:nowrap}}
.plank{{border-style:solid;border-width:9px;border-image:url({A}ui/wood/plank.png) 9 fill/9px stretch;color:var(--chalk)}}
.tabw{{border-style:solid;border-width:9px;border-image:url({A}ui/wood/tab.png) 9 fill/9px stretch;color:var(--chalk)}}
.top .nav{{left:18px;top:20px;width:38px;height:40px}}
.top .nav i{{position:absolute;left:0;right:0;top:-1px;font:600 20px/20px Barlow;font-style:normal;text-align:center}}
.top .nav.off{{left:68px;opacity:.42}}
.top .gym{{left:117px;top:15px;font:400 32px/48px Marker;color:#6e9fe7}}
.top .d1{{left:403px;top:19px;font:500 19px/22px Barlow;color:#ede1cd}}
.top .d2{{left:403px;top:41px;font:400 16px/18px Barlow;letter-spacing:-.5px;color:var(--chalksoft)}}
.top .tbtn{{top:14px;height:48px;font:600 19px/19px Barlow;display:flex;align-items:center;justify-content:center;gap:24px}}
.top .tbtn span{{position:relative;top:-2px}}.top .tbtn .ico{{position:relative;top:-2px}}
.top .cash{{right:377px;top:16px;text-align:right}}
.top .cash b{{display:block;font:700 24px/28px Barlow;color:#e5bc55}}
.top .cash i{{display:block;font:400 16px/18px Barlow;letter-spacing:-.35px;font-style:normal;color:var(--chalksoft);margin-top:1px}}
.top .needs{{left:1558px;top:13px;width:266px;height:51px}}
.top .needs b{{position:absolute;left:7px;top:-3px;font:700 19px/22px Barlow;letter-spacing:-.15px}}
.top .needs i{{position:absolute;left:7px;top:19px;font:400 16px/18px Barlow;letter-spacing:-.5px;font-style:normal;color:#eadcc6}}
.top .menu{{left:1841px;top:19px;width:60px;height:40px;font:600 16px/16px Barlow;display:flex;align-items:center;justify-content:center}}
.top .menu span{{position:relative;top:-2px}}
/* from the gym screen: the round white-ringed pin, the navy pill label, the blue-tag strip (type scaled up to 20 px and more) */
.pin{{border-radius:50%;background:var(--navy);border:3px solid var(--ring);display:grid;place-items:center;color:var(--ring);flex:none;box-shadow:0 2px 8px rgba(0,0,0,.45)}}
.pin.red{{background:var(--pinred)}}
.npill{{display:inline-flex;align-items:center;height:30px;padding:0 11px;border-radius:7px;background:var(--navy);color:#fffbf3;font-weight:600;font-size:20px;white-space:nowrap}}
.tag{{display:inline-flex;align-items:center;height:28px;padding:0 11px;background:var(--tagbg);border-left:4px solid var(--tagbar);color:var(--tagink);font-weight:600;font-size:20px;letter-spacing:.02em;white-space:nowrap;flex:none}}
.strip{{display:flex;align-items:center;gap:14px;height:50px;padding:0 18px 0 12px;border-radius:9px;background:var(--strip);white-space:nowrap}}
.strip b{{font-weight:600;font-size:22px;color:#fffbf3}}.strip span{{font-size:20px;color:#b9c3dc}}
/* tabs, buttons, meters: as on overview_a */
.tabs{{position:absolute;display:flex;gap:6px}}
.tab{{height:48px;padding:0 20px;border-radius:10px;display:flex;align-items:center;gap:10px;font-weight:600;color:var(--soft);background:rgba(255,255,255,.05);white-space:nowrap}}
.tab.on{{color:#fff;background:rgba(255,214,120,.16);box-shadow:0 0 26px 2px rgba(255,205,90,.42)}}
.tab.dim{{color:#7d7266;background:rgba(255,255,255,.03)}}.tab small{{font-size:20px;font-weight:500}}
.go{{display:inline-flex;align-items:center;justify-content:center;gap:10px;height:56px;padding:0 24px;border-radius:11px;background:linear-gradient(#ffe070,#f0b32a);color:#2a1b06;font-weight:700;font-size:23px;box-shadow:0 3px 0 #9a6c10;white-space:nowrap}}
.btn{{display:inline-flex;align-items:center;gap:12px;height:56px;padding:0 20px;border-radius:11px;background:rgba(255,255,255,.085);color:var(--ink);font-weight:600;font-size:22px;white-space:nowrap}}
.btn .ico{{color:var(--gold)}}
.btn small{{font-size:20px;color:var(--soft);font-weight:500}}
.bar{{position:relative;height:16px;border-radius:8px;background:var(--track)}}
.bar b{{position:absolute;left:0;top:0;bottom:0;border-radius:8px;background:var(--c)}}
.bar em{{position:absolute;top:-5px;width:3px;height:26px;border-radius:2px;background:#fff}}
.bar u{{position:absolute;top:-13px;margin-left:-14px;width:0;height:0;border:8px solid transparent;border-top:11px solid var(--gold)}}
.weak{{--c:var(--weak)}}.fair{{--c:var(--fair)}}.solid{{--c:var(--solid)}}.strong{{--c:var(--strong)}}.elite{{--c:var(--elite)}}
.v{{font-weight:700;font-size:28px;text-align:right;color:color-mix(in srgb,var(--c) 78%,#fff)}}
.gain{{color:var(--green);font-weight:600;font-size:20px;white-space:nowrap}}
.cap{{color:var(--soft);font-size:20px;white-space:nowrap}}
.pill{{display:inline-flex;align-items:center;height:32px;padding:0 13px;border-radius:16px;background:rgba(255,210,74,.13);color:var(--gold);font-weight:600;font-size:20px;white-space:nowrap}}
.pill.hot{{background:var(--gold);color:#2a1b06;box-shadow:0 0 22px 3px rgba(255,205,90,.55)}}
.key{{display:flex;align-items:center;gap:8px;font-size:20px;color:var(--soft);white-space:nowrap}}
.key s{{width:14px;height:14px;border-radius:4px;display:inline-block;margin-left:10px}}
.key em{{display:inline-block;width:3px;height:20px;background:#fff;border-radius:2px}}
.key u{{display:inline-block;width:0;height:0;border:8px solid transparent;border-top:11px solid var(--gold);margin-top:10px}}
.key i{{display:inline-block;width:30px;height:14px;border-radius:7px;margin-left:16px;background:repeating-linear-gradient(135deg,var(--strong) 0 6px,#1f6a43 6px 10px)}}
.h{{font-weight:700;font-size:22px;letter-spacing:.09em;color:var(--gold)}}
"""


def top(inner=True):
    """The gym screen's top bar. An inner page adds the build's own "Gym" plank (the way back), as on today's pages."""
    mid = ('<span class="tbtn plank" style="left:656px;width:124px">' + ico("bag", 24, style="stroke-width:1.6;margin-left:-14px") + '<span>Gym</span></span>'
           '<span class="tbtn plank" style="left:790px;width:124px"><span>Mail (5 new)</span></span>') if inner else \
        '<span class="tbtn plank" style="left:725px;width:124px"><span>Mail (5 new)</span></span>'
    return ('<div class="top"><span class="nav tabw"><i>&lt;</i></span><span class="nav off tabw"><i>&gt;</i></span>'
            '<span class="gym">Anvil Street Gym</span><span class="d1">Mon 12 Jan 2026</span><span class="d2">Week 2</span>' + mid +
            '<span class="cash"><b>$16,841</b><i>running -$680 a week</i></span>'
            '<span class="needs plank"><b>NEEDS YOU (1)</b><i>Answer Lucy\'s bout offer</i></span>'
            '<span class="menu tabw"><span>Menu</span></span></div>')


def band(v):
    return "weak" if v < 45 else "fair" if v < 55 else "solid" if v < 65 else "strong" if v < 75 else "elite"


# ------------------------------------------------------------------ SQUAD
SQUAD_CSS = COMMON + f"""
.title{{position:absolute;left:28px;top:90px;display:flex;align-items:center;gap:14px}}
.title b{{font:400 46px/56px Marker;color:#fff;white-space:nowrap}}
.hd{{position:absolute;left:28px;width:1864px;display:grid;align-items:end;font-weight:600;font-size:20px;letter-spacing:.08em;color:#a8987f;white-space:nowrap}}
.g1{{grid-template-columns:410px 414px 200px 190px 104px 246px 210px;column-gap:15px}}
.row{{position:absolute;left:28px;width:1864px;height:132px;display:grid;align-items:center;border-top:1px solid rgba(255,255,255,.09)}}
.row.need{{background:linear-gradient(90deg,rgba(225,71,58,.13),rgba(225,71,58,0) 46%)}}
.who{{display:flex;align-items:center;gap:18px;padding-left:10px}}
.face{{position:relative;width:98px;height:98px;border-radius:50%;border:3px solid var(--ring);background-color:#141a2c;background-repeat:no-repeat;background-size:200px auto;background-position:50% -27px;box-shadow:0 3px 12px rgba(0,0,0,.55);flex:none}}
.face .pin{{position:absolute;left:-12px;top:-10px;width:38px;height:38px;font:700 24px/1 Barlow}}
.who .nm{{font-weight:700;font-size:29px;line-height:34px;color:#fff;white-space:nowrap}}
.who .l2{{display:flex;align-items:center;gap:10px;margin-top:3px;font-size:20px;color:var(--soft);white-space:nowrap}}
.who .l3{{display:flex;align-items:center;gap:10px;margin-top:6px;font-size:20px;color:var(--soft);white-space:nowrap}}
.who .l3 b{{font-weight:700;font-size:23px;color:var(--ink)}}
.who .l3 .rk{{color:var(--gold);font-weight:600}}
.belt{{display:inline-flex;align-items:center;justify-content:flex-end;gap:4px;width:74px;height:18px;border-radius:4px;background:#f3ede2;padding-right:8px}}
.belt i{{width:5px;height:18px;background:#1a1a1a}}.belt s{{width:26px;height:18px;background:#1a1a1a;display:flex;gap:4px;justify-content:center}}.belt s u{{width:4px;height:18px;background:#f3ede2}}
.call{{display:flex;align-items:center;gap:14px}}
.call .pin{{width:56px;height:56px}}
.call .t{{display:flex;align-items:center;gap:10px;font-weight:700;font-size:24px;color:#fff;white-space:nowrap}}
.call .s{{margin-top:4px;font-size:21px;font-weight:600;color:var(--ink);white-space:nowrap}}
.call .m{{display:flex;align-items:center;gap:10px;margin-top:7px;font-size:20px;color:var(--soft);white-space:nowrap}}
.days{{display:flex;gap:4px}}.days s{{width:14px;height:14px;border-radius:3px;background:var(--track)}}.days s.o{{background:#d9c9ae}}
.num{{display:flex;align-items:baseline;gap:8px;white-space:nowrap}}
.num b{{font-weight:700;font-size:32px;line-height:34px;color:color-mix(in srgb,var(--c) 78%,#fff)}}
.num span{{font-size:22px;font-weight:600;color:var(--ink)}}
.cellbar{{margin:8px 0 9px}}
.tired .bar{{background:linear-gradient(90deg,var(--track) 0 80%,rgba(221,75,61,.42) 80% 100%)}}
.sub{{display:flex;align-items:center;gap:8px;font-size:20px;color:var(--soft);white-space:nowrap}}
.sub.warn{{color:#ffb25e;font-weight:600}}.sub.good{{color:#7fd9a6}}
.mood{{text-align:left}}.mood b{{display:block;font-weight:700;font-size:23px;margin-top:4px;white-space:nowrap}}.mood span{{display:block;font-size:20px;color:var(--soft);white-space:nowrap}}
.nf{{display:flex;align-items:center;gap:14px}}
.nf .n{{width:62px;text-align:center;flex:none}}.nf .n b{{display:block;font:400 50px/46px Bebas;color:#fff}}.nf .n i{{display:block;font-style:normal;font-size:20px;line-height:20px;color:var(--soft)}}
.nf .n.none b{{color:#6f665c}}
.nf .x b{{display:block;font-weight:700;font-size:23px;line-height:28px;color:#fff;white-space:nowrap;margin-top:3px}}.nf .x .d{{display:block;font-size:20px;color:var(--soft);white-space:nowrap}}
.nf .x.none b{{color:var(--soft)}}
.act{{display:flex;justify-content:flex-end;padding-right:10px}}
.act .go,.act .btn{{width:200px;height:58px;padding:0 10px;justify-content:center;font-size:22px}}
/* side by side */
.sbs{{position:absolute;left:28px;width:1864px}}
.g2{{grid-template-columns:170px 96px 118px 118px 118px 136px 118px 118px 118px 118px 118px 118px 400px}}
.grp{{position:absolute;left:28px;width:1864px;display:grid;font-weight:700;font-size:20px;letter-spacing:.09em;color:var(--gold);white-space:nowrap}}
.grp span{{border-bottom:2px solid rgba(255,210,74,.28);margin-right:18px;padding-bottom:3px}}
.r2{{position:absolute;left:28px;width:1864px;height:50px;display:grid;align-items:center;border-top:1px solid rgba(255,255,255,.08)}}
.r2 .w{{display:flex;align-items:center;gap:12px;padding-left:10px;font-weight:700;font-size:24px;color:#fff}}
.sface{{width:40px;height:40px;border-radius:50%;border:2px solid var(--ring);background-color:#141a2c;background-repeat:no-repeat;background-size:86px auto;background-position:50% -13px;flex:none}}
.ov{{width:44px;height:44px;border-radius:50%;display:grid;place-items:center;font:400 25px/1 Bebas;color:#fff;padding-top:2px}}
.c{{display:flex;align-items:center;gap:8px}}
.c b{{width:34px;font-weight:700;font-size:26px;color:color-mix(in srgb,var(--c) 78%,#fff)}}
.c .mb{{position:relative;width:54px;height:8px;border-radius:4px;background:var(--track)}}
.c .mb i{{position:absolute;left:0;top:0;bottom:0;border-radius:4px;background:var(--c)}}
.c .mb em{{position:absolute;top:-4px;width:2px;height:16px;border-radius:1px;background:#fff}}
.c.char .mb i{{background:repeating-linear-gradient(135deg,var(--c) 0 4px,color-mix(in srgb,var(--c) 50%,#000) 4px 7px)}}
.c.best b{{text-shadow:0 0 14px color-mix(in srgb,var(--c) 80%,transparent)}}
.c.best::before{{content:"";width:8px;height:8px;border-radius:50%;background:var(--gold);margin-left:-16px;box-shadow:0 0 8px rgba(255,210,74,.7)}}
.mv{{display:flex;align-items:center;gap:10px;white-space:nowrap;font-size:22px;font-weight:600;color:var(--ink)}}
.mv b{{font-weight:700;font-size:26px;color:color-mix(in srgb,var(--c) 78%,#fff)}}.mv i{{font-style:normal;font-size:20px;color:color-mix(in srgb,var(--c) 70%,#fff)}}
"""

F = [
    dict(first="Lucy", name="Lucy Jackson", face="mh_boxer_11", cls="Lightweight", meta="21, orthodox", rec="3-1", ladder="1 win from the table", rk=False, need=True,
         tag="GOAL", sicon="road", session="Roadwork", stat="Stamina 57", gain="+0.4 a week", days="1111110", mtxt="6 mornings, $250 seat",
         tired=38, tword="Fresh", tb="strong", rest="0 rest days needed", restcls="",
         kg=60.9, limit=60.0, mood=("Steady", "meh", "#e9dfcf", ""),
         nf=("OFFER", "19", "days", "Maria Ortega", "Sat 31 Jan, home"), act=("go", "doc", "Open the offer"),
         ov=59, ceil=84, a=dict(iq=61, comp=56, str=60, exp=57, dur=66, sta=57, rec=66, heart=85, spd=63, flex=55), style="Out-boxer", move=("Jab", 61, "Sharp", "strong")),
    dict(first="Samira", name="Samira Khan", face="mh_boxer_20", cls="Welterweight", meta="18, orthodox", rec="2-1", ladder="2 wins from the table", rk=False, need=False,
         tag="FIX", sicon="rope", session="Slip rope with Coach", stat="Defence 50", gain="+1.2 a week", days="0101011", mtxt="4 mornings, college",
         tired=44, tword="Ok", tb="solid", rest="0 rest days needed", restcls="",
         kg=64.6, limit=65.0, mood=("Flat", "frown", "#ffb25e", "wants a bout"),
         nf=("", "", "", "No bout", "3 on the bout sheet"), act=("btn", "search", "Find a bout"),
         ov=55, ceil=80, a=dict(iq=46, comp=48, str=67, exp=66, dur=58, sta=52, rec=60, heart=70, spd=56, flex=50), style="Slugger", move=("Cross", 44, "Usable", "solid")),
    dict(first="Tess", name="Tess Reilly", face="mh_boxer_22", cls="Middleweight", meta="23, orthodox", rec="6-4", ladder="Number 5 in London", rk=True, need=False,
         tag="REST", sicon="bed", session="Two rest days", stat="Tiredness 71", gain="back under 50", days="0000011", mtxt="2 mornings, shifts",
         tired=71, tword="Tired", tb="fair", rest="2 rest days needed", restcls="warn",
         kg=76.1, limit=75.0, mood=("Fired up", "smile", "#7fd9a6", ""),
         nf=("", "", "", "No bout", "2 on the bout sheet"), act=("btn", "plan", "Plan the week"),
         ov=62, ceil=74, a=dict(iq=60, comp=64, str=64, exp=58, dur=73, sta=68, rec=61, heart=78, spd=49, flex=47), style="Pressure fighter", move=("Body hook", 63, "Sharp", "strong")),
    dict(first="Ana", name="Ana Ribeiro", face="mh_boxer_16", cls="No-gi", meta="22, grappler", rec="4-2", ladder="White, 2 stripes", rk=False, need=False, belt=True,
         tag="DRILL", sicon="mat", session="Kimura on the mat", stat="Kimura 24", gain="owned at 30, 2 weeks", days="1010100", mtxt="3 classes, café job",
         tired=30, tword="Fresh", tb="strong", rest="0 rest days needed", restcls="",
         kg=None, limit=None, mood=("Steady", "meh", "#e9dfcf", ""),
         nf=("NOT ENTERED", "26", "days", "London open", "Sat 7 Feb"), act=("btn", "trophy", "Enter the open"),
         ov=51, ceil=78, a=dict(iq=58, comp=66, str=52, exp=55, dur=50, sta=61, rec=63, heart=62, spd=54, flex=72), style="Grappler", move=("Kimura", 24, "Raw", "fair")),
]
FACE = A + "ui/face/"


def squad_row(f, y):
    need = '<span class="pin red">!</span>' if f["need"] else ""
    l3 = f'<b>{f["rec"]}</b>'
    if f.get("belt"):
        l3 += '<span class="belt"><s><u></u><u></u></s></span>'
    l3 += f'<span class="{"rk" if f["rk"] else ""}">{f["ladder"]}</span>'
    who = (f'<div class="who"><div class="face" style="background-image:url({FACE}{f["face"]}.jpg)">{need}</div><div>'
           f'<div class="nm">{f["name"]}</div><div class="l2"><span class="npill">{f["cls"]}</span>{f["meta"]}</div><div class="l3">{l3}</div></div></div>')
    days = "".join(f'<s class="{"o" if c == "1" else ""}"></s>' for c in f["days"])
    gaincls = "gain" if f["gain"].startswith("+") else "cap"
    call = (f'<div class="call"><span class="pin">{ico(f["sicon"], 30)}</span><div><div class="t">{f["session"]}<span class="tag">{f["tag"]}</span></div>'
            f'<div class="s">{f["stat"]} <span class="{gaincls}" style="margin-left:6px">{f["gain"]}</span></div>'
            f'<div class="m"><span class="days">{days}</span>{f["mtxt"]}</div></div></div>')
    tired = (f'<div class="tired {f["tb"]}"><div class="num"><b>{f["tired"]}</b><span>{f["tword"]}</span></div>'
             f'<div class="bar cellbar"><b style="width:{f["tired"]}%"></b><em style="left:80%"></em></div>'
             f'<div class="sub {f["restcls"]}">{ico("bed", 22)}{f["rest"]}</div></div>')
    if f["kg"] is None:
        weight = '<div><div class="num" style="--c:#8f8272"><b>&ndash;</b></div><div class="sub" style="margin-top:6px">no weigh-in<br>on the mat</div></div>'
    else:
        over = round(f["kg"] - f["limit"], 1)
        b = "fair" if over > 0 else "strong"
        pct = max(8, min(100, 80 + over * 9))
        txt = f'{abs(over):.1f} kg over' if over > 0 else f'{abs(over):.1f} kg under'
        weight = (f'<div class="{b}"><div class="num"><b>{f["kg"]:.1f}</b><span>kg</span></div>'
                  f'<div class="bar cellbar"><b style="width:{pct}%"></b><em style="left:80%"></em></div>'
                  f'<div class="sub {"warn" if over > 0 else "good"}">{txt}</div></div>')
    mw, mi, mc, why = f["mood"]
    mood = f'<div class="mood" style="color:{mc}">{ico(mi, 36)}<b>{mw}</b><span>{why or "&nbsp;"}</span></div>'
    tg, n, unit, l1, l2 = f["nf"]
    if n:
        nf = (f'<div class="nf"><div class="n"><b>{n}</b><i>{unit}</i></div><div class="x"><span class="tag">{tg}</span><b>{l1}</b><span class="d">{l2}</span></div></div>')
    else:
        nf = f'<div class="nf"><div class="n none"><b>&ndash;</b></div><div class="x none"><b>{l1}</b><span class="d">{l2}</span></div></div>'
    kind, ic, label = f["act"]
    act = f'<div class="act"><span class="{kind}">{ico(ic, 26)}{label}</span></div>'
    return f'<div class="row g1{" need" if f["need"] else ""}" style="top:{y}px">{who}{call}{tired}{weight}{mood}{nf}{act}</div>'


ATTR = [("iq", "Fight IQ"), ("comp", "Composure"), ("str", "Strength"), ("exp", "Explosiveness"), ("dur", "Durability"), ("sta", "Stamina"), ("rec", "Recovery"),
        ("heart", "Heart"), ("spd", "Speed"), ("flex", "Flexibility")]


def squad_cmp(f, y):
    cells = ""
    for key, _ in ATTR:
        v = f["a"][key]
        best = v == max(x["a"][key] for x in F)
        char = key == "heart"
        tick = "" if char else f'<em style="left:{f["ceil"]}%"></em>'
        cells += f'<div class="c {band(v)}{" char" if char else ""}{" best" if best else ""}"><b>{v}</b><span class="mb"><i style="width:{v}%"></i>{tick}</span></div>'
    o = f["ov"]
    ring = f'<div class="ov" style="background:radial-gradient(closest-side,#17120f 76%,transparent 78% 100%),conic-gradient(var(--gold) 0 {o}%,var(--track) {o}% 100%)">{o}</div>'
    mn, mvv, tier, mb = f["move"]
    mv = f'<div class="mv {mb}"><span class="npill">{f["style"]}</span>{mn}<b>{mvv}</b><i>{tier}</i></div>'
    return (f'<div class="r2 g2" style="top:{y}px"><div class="w"><span class="sface" style="background-image:url({FACE}{f["face"]}.jpg)"></span>{f["first"]}</div>'
            f'{ring}{cells}{mv}</div>')


def squad():
    y0, pitch = 196, 136
    rows = "".join(squad_row(f, y0 + i * pitch) for i, f in enumerate(F))
    y2 = y0 + 4 * pitch            # 740: the line under the last row
    cmp_rows = "".join(squad_cmp(f, y2 + 108 + i * 50) for i, f in enumerate(F))
    heads = "".join(f"<span>{n}</span>" for _, n in ATTR)
    body = f"""<div class="wall" style="--lamp:50%"></div>{top()}
<div class="title"><span class="pin" style="width:56px;height:56px">{ico("bag", 30)}</span><b>Fighters</b></div>
<div class="tabs" style="left:316px;top:94px"><span class="tab on">All four</span><span class="tab">Club week</span><span class="tab">Compare two</span><span class="tab dim">Find a fighter <small>4 of 4 places taken</small></span></div>
<div class="abs" style="right:28px;top:93px;display:flex;align-items:center;gap:10px"><div class="strip"><span class="tag">THIS WEEK</span><b>Coach is off Wednesday</b><span>2 pad places gone</span></div><span class="plank" style="height:50px;display:flex;align-items:center;font:600 20px/20px Barlow;padding:0 9px 3px">Answer</span></div>
<div class="hd g1" style="top:162px;height:28px"><span style="padding-left:10px">FIGHTER</span><span>COACH SAYS, THIS WEEK</span><span>TIREDNESS</span><span>WEIGHT</span><span>MOOD</span><span>NEXT FIGHT</span><span></span></div>
{rows}
<div class="row" style="top:{y2}px;height:1px"></div>
<div class="abs" style="left:38px;top:{y2 + 18}px;display:flex;align-items:baseline;gap:14px;white-space:nowrap"><span class="h">SIDE BY SIDE</span><span class="cap">the ten numbers every fighter has, in the groups of the fighter's page</span></div>
<div class="abs key" style="right:28px;top:{y2 + 18}px"><em></em>&nbsp;ceiling<span style="width:8px;height:8px;border-radius:50%;background:var(--gold);margin-left:18px"></span>best of the four<i></i>&nbsp;character, does not train<s style="background:var(--weak);margin-left:18px"></s>Weak<s style="background:var(--fair)"></s>Fair<s style="background:var(--solid)"></s>Solid<s style="background:var(--strong)"></s>Strong<s style="background:var(--elite)"></s>Elite</div>
<div class="grp" style="top:{y2 + 52}px;grid-template-columns:266px 236px 254px 118px 354px 236px 400px"><i></i><span>HEAD</span><span>HANDS</span><span>GUARD</span><span>CARDIO</span><span>LEGS</span><i></i></div>
<div class="hd g2" style="top:{y2 + 80}px;height:26px;letter-spacing:0;font-weight:500;color:var(--soft)"><span style="padding-left:10px"></span><span>Overall</span>{heads}<span>Style and best move</span></div>
{cmp_rows}"""
    return f'<!doctype html>\n<html lang="en"><head><meta charset="utf-8"><title>Fighters: all four (S431 set Y)</title>\n<style>\n{SQUAD_CSS}</style></head>\n<body>{body}</body></html>\n'


# ------------------------------------------------------------------ OVERVIEW (overview_a + the six listed changes)
OV_CSS = COMMON + """
.name{font:400 52px/1 Marker;color:#fff;white-space:nowrap}
.sub{display:flex;align-items:center;gap:10px;font-size:22px;color:var(--soft);margin-top:8px;white-space:nowrap}
.ring{border-radius:50%;display:grid;place-items:center;background:radial-gradient(closest-side,#191412 78%,transparent 79% 100%),conic-gradient(var(--gold) 0 59%,var(--track) 59% 100%)}
.ring b{display:block;font:400 46px/0.9 Bebas;color:#fff;text-align:center;letter-spacing:.02em}
.ring i{display:block;font-style:normal;font-size:20px;color:var(--soft);text-align:center;line-height:1}
.guide{position:absolute;left:14px;bottom:14px;display:flex;align-items:flex-end}
.gface{width:190px;height:190px}
.gtail{width:24px;height:40px;margin-bottom:34px;background:#8a6a3d;clip-path:polygon(0 55%,100% 0,100% 100%)}
.gbub{width:452px;background:#262a2d;border:3px solid #8a6a3d;border-radius:24px;padding:14px 22px}
.gbub p{font:700 27px/34px Kalam,"Segoe Print",cursive;color:#efe6d8}
.gbub div{display:flex;justify-content:flex-end;margin-top:8px}
.gskip{height:38px;padding:0 14px;border-radius:9px;background:rgba(255,255,255,.07);color:var(--soft);font-size:20px;font-weight:600;display:flex;align-items:center}
.fig{position:absolute;filter:drop-shadow(-3px 0 0 rgba(255,214,160,.16)) drop-shadow(0 0 34px rgba(255,170,80,.10))}
/* the floor under the figure: the gym screen's dark training floor, not boards */
.floor{position:absolute;left:560px;right:560px;bottom:0;height:150px;background:
 repeating-linear-gradient(90deg,rgba(0,0,0,.30) 0 2px,transparent 2px 112px),linear-gradient(#3b363a,#1b191b);
 clip-path:polygon(9% 0,91% 0,100% 100%,0 100%);opacity:.9}
.step{position:absolute;right:28px;top:88px;height:56px;display:flex;align-items:center;gap:12px}
.cl{position:absolute;width:624px}
.cl h3{height:40px;display:flex;align-items:baseline;gap:14px;font-weight:700;font-size:22px;letter-spacing:.09em;color:var(--gold);padding-top:6px}
.cl h3 span{font-weight:500;font-size:20px;letter-spacing:0;color:var(--soft)}
.r{display:grid;grid-template-columns:26px 164px 1fr 46px 168px;column-gap:10px;align-items:center;height:40px;border-radius:10px;padding:0 6px;margin:0 -6px}
.r .ico{color:var(--soft)}.r .n{font-weight:600;white-space:nowrap}
.r.char .bar b{background:repeating-linear-gradient(135deg,var(--c) 0 6px,color-mix(in srgb,var(--c) 55%,#000) 6px 10px)}
.r.sel{background:rgba(255,210,74,.09);box-shadow:0 0 26px 2px rgba(255,205,90,.28)}
.r.sc{grid-template-columns:26px 164px 120px 1fr}
.r.sc .tail{display:flex;align-items:baseline;gap:8px;white-space:nowrap}
.r.sc .tail .v{text-align:left}
.r.sc .tail .pill{align-self:center;margin-left:4px}
.tiredbar{background:linear-gradient(90deg,var(--track) 0 80%,rgba(221,75,61,.42) 80% 100%)}
.word{font-weight:700;font-size:22px;color:#ff8d7f;text-align:right}
.lead{position:absolute;left:0;top:0;pointer-events:none}
.goal{position:absolute;left:1268px;top:784px;width:624px;display:grid;grid-template-columns:86px 1fr auto;column-gap:16px;align-items:center}
.gr{width:86px;height:86px;border-radius:50%;display:grid;place-items:center;font:400 34px/1 Bebas;background:radial-gradient(closest-side,#191412 74%,transparent 75% 100%),conic-gradient(var(--green) 0 40%,var(--track) 40% 100%)}
.goal b{display:block;font-size:26px;font-weight:700;white-space:nowrap}.goal span{display:block;color:var(--soft);white-space:nowrap;margin-top:2px}
.ok{display:inline-flex;align-items:center;height:34px;padding:0 14px;border-radius:17px;background:rgba(63,192,122,.16);color:var(--green);font-weight:700;font-size:20px;white-space:nowrap}
.acts{position:absolute;left:1268px;top:904px;width:624px;display:grid;grid-template-columns:1fr 1fr;gap:12px}
.acts .btn{height:64px}
"""


def r(icon, name, v, tail="", ceil=84, char=False, sel=False, flag=None, word=None):
    b = band(v) if word is None else "weak"
    cls = f'r {b}{" char" if char else ""}{" sel" if sel else ""}'
    if word:
        mid = f'<span class="word" style="grid-column:3/5">{word}</span>'
    else:
        tick = "" if char else f'<em style="left:{ceil}%"></em>'
        fl = f'<u style="left:{flag}%"></u>' if flag else ""
        mid = f'<span class="bar"><b style="width:{v}%"></b>{tick}{fl}</span><span class="v">{v}</span>'
    return f'<div class="{cls}">{ico(icon)}<span class="n">{name}</span>{mid}<span>{tail}</span></div>'


def gain(t):
    return f'<span class="gain">{t}</span>'


def cap(t):
    return f'<span class="cap">{t}</span>'


def pill(t, hot=False):
    return f'<span class="pill{" hot" if hot else ""}">{t}</span>'


def lead(path, x, y):
    """A dotted chalk line that ends on the body in a small gym-screen pin (navy, white ring)."""
    return (f'<path d="{path} L{x} {y}" fill="none" stroke="rgba(241,232,218,.42)" stroke-width="2" stroke-dasharray="2 7" stroke-linecap="round"/>'
            f'<circle cx="{x}" cy="{y}" r="8" fill="#1c2640" stroke="#fdf9f1" stroke-width="3"/>')


def overview():
    # the figure: figure.png is 317 x 863; drawn 286 x 780 at (772, 266)
    FX, FY, S = 772, 266, 780 / 863

    def at(px, py):
        return round(FX + px * S), round(FY + py * S)

    head, glove, guard, chest, knee, boot = at(186, 22), at(66, 98), at(283, 168), at(236, 262), at(246, 612), at(276, 806)
    leads = (lead("M386 290 H700", *head) + lead("M234 582 H720", *glove) + lead("M1264 172 H1200", *guard) + lead("M1264 306 H1180", *chest)
             + lead("M1264 480 H1210", *knee) + lead("M1264 654 H1230", *boot))
    left = ('<div class="cl" style="left:28px;top:268px"><h3>HEAD<span>reads the fight, keeps the plan</span></h3>'
            + r("bulb", "Fight IQ", 61) + r("waves", "Composure", 56, pill("+ Sparring"))
            + r("list", "Discipline", 69, cap("holds the plan"), char=True) + r("trend", "Confidence", 51, cap("swings by round"), char=True)
            + r("chat", "Coachability", 45, cap("shouts land less"), char=True) + r("flame", "Temper", 0, cap("when hit"), word="Trades") + '</div>'
            '<div class="cl" style="left:28px;top:560px"><h3>HANDS<span>what lands</span></h3>'
            + r("target", "Accuracy", 59, gain("+0.3 a week")) + r("clock", "Timing", 61) + r("inout", "Inside fighting", 55, pill("+ Sparring", True), sel=True)
            + r("dumb", "Strength", 60, gain("+0.1 a week")) + r("bolt", "Explosiveness", 57) + '</div>')
    scale = ('<div class="cl" style="left:1268px;top:632px"><h3>ON THE SCALE<span>limit 60.0 kg</span></h3>'
             f'<div class="r sc fair">{ico("scale")}<span class="n">Weight</span><span class="bar"><b style="width:88%"></b><em style="left:80%"></em></span>'
             '<span class="tail"><span class="v">60.9</span><span class="cap">kg, 0.9 over</span>' + pill("+ Cut") + '</span></div>'
             f'<div class="r sc strong">{ico("battery")}<span class="n">Tiredness</span><span class="bar tiredbar"><b style="width:38%"></b><em style="left:80%"></em></span>'
             '<span class="tail"><span class="v">38</span><span class="cap">Fresh, 0 rest days needed</span></span></div></div>')
    right = ('<div class="cl" style="left:1268px;top:150px"><h3>GUARD<span>what gets through</span></h3>'
             + r("shieldhalf", "Defence", 57, gain("+0.1 a week")) + r("shield", "Durability", 66) + '</div>'
             '<div class="cl" style="left:1268px;top:284px"><h3>CARDIO<span>how long it lasts</span></h3>'
             + r("pulse", "Stamina", 57, gain("+0.4 a week"), flag=60) + r("cycle", "Recovery", 66) + r("heart", "Heart", 85, cap("gets up"), char=True) + '</div>'
             '<div class="cl" style="left:1268px;top:458px"><h3>LEGS<span>where the fight happens</span></h3>'
             + r("chev2", "Speed", 63, gain("+0.2 a week")) + r("feet", "Footwork", 58, gain("+0.2 a week")) + r("arc", "Flexibility", 55, pill("+ Mobility")) + '</div>' + scale)
    guide = """<div class="guide"><div class="gface"><svg width="190" height="190" viewBox="0 0 190 190"><defs><clipPath id="gc"><circle cx="95" cy="95" r="88"/></clipPath>
<radialGradient id="gr" cx=".5" cy=".35" r=".8"><stop offset="0" stop-color="#5b4a3a"/><stop offset="1" stop-color="#231c17"/></radialGradient></defs>
<circle cx="95" cy="95" r="88" fill="url(#gr)"/><g clip-path="url(#gc)"><path d="M22 200q4-62 73-62t73 62z" fill="#39424a"/>
<rect x="82" y="112" width="26" height="30" fill="#b08a6c"/><ellipse cx="95" cy="88" rx="33" ry="38" fill="#c39b7a"/>
<path d="M60 96q2 34 35 36 33-2 35-36-6 20-35 20T60 96z" fill="#e6e0d6"/>
<path d="M56 70q4-34 40-34 34 0 40 30l14 6q-30 6-94-2z" fill="#2b3036"/></g>
<circle cx="95" cy="95" r="88" fill="none" stroke="#8a6a3d" stroke-width="4"/></svg></div><div class="gtail"></div><div class="gbub"><p>Lucy has a bout offer. Answer it by Thursday.</p><div><span class="gskip">Skip the guide</span></div></div></div>"""
    body = f"""<div class="wall" style="--lamp:50%"></div>{top()}
<div class="tabs" style="left:28px;top:92px"><span class="tab on">Profile</span><span class="tab">Condition</span><span class="tab">Training</span><span class="tab">Playbook</span><span class="tab">Fight plan</span><span class="tab">History</span></div>
<div class="floor"></div>
<div class="step"><div class="strip"><span class="tag">SHOW IN 19 DAYS</span><b>Bout offer: Maria Ortega</b><span>the 5th bout opens the nationals</span></div><span class="go">Open the bout offer</span></div>
<div class="abs" style="left:28px;top:156px"><div class="name">Lucy Jackson</div><div class="sub"><span class="npill">Lightweight</span>21, orthodox, amateur 3-1</div></div>
<div class="abs ring" style="left:536px;top:150px;width:112px;height:112px"><div><b>59</b><i>of 100</i></div></div>
<img class="fig" src="figure.png" style="left:{FX}px;top:{FY}px;width:{round(317 * S)}px;height:780px" alt="">
<svg class="lead" width="1920" height="1080">{leads}</svg>
{left}
<div class="abs key" style="left:28px;top:808px"><em></em>&nbsp;ceiling 84&nbsp;&nbsp;&nbsp;&nbsp;<u></u>&nbsp;goal<i></i>&nbsp;character, does not train</div>
<div class="abs" style="left:28px;top:838px"><div class="key"><s style="background:var(--weak);margin-left:0"></s>Weak<s style="background:var(--fair)"></s>Fair<s style="background:var(--solid)"></s>Solid<s style="background:var(--strong)"></s>Strong<s style="background:var(--elite)"></s>Elite</div></div>
{right}
<div class="goal"><div class="gr">40%</div><div><b>Goal: Stamina for five rounds</b><span>Stamina 57 of 60, 18 days left</span></div><span class="ok">On track</span></div>
<div class="acts"><span class="btn">{ico("plan", 28)} Plan the week</span><span class="btn">{ico("arrowplan", 28)} Fight plan <small>5 arrows</small></span><span class="btn">{ico("search", 28)} Find a bout</span><span class="btn">{ico("talk", 28)} Talk to Lucy</span></div>
{guide}"""
    return f'<!doctype html>\n<html lang="en"><head><meta charset="utf-8"><title>Lucy Jackson: Profile, the body chart (S431 set Y)</title>\n<style>\n{OV_CSS}</style></head>\n<body>{body}</body></html>\n'


if __name__ == "__main__":
    (HERE / "squad.html").write_text(squad(), encoding="utf-8")
    (HERE / "overview.html").write_text(overview(), encoding="utf-8")
    print("wrote squad.html, overview.html")
