"""Writes overview.html, squad.html and side_by_side.html (the final matched set). Run from this folder:
    python build.py    then, from E:/FightCamp/Lean:
    python tools/render_mockup.py docs/mockups/s431/final/overview.html docs/mockups/s431/final/squad.html
    python tools/render_mockup.py docs/mockups/s431/final/side_by_side.html
overview.html is ../../s430/overview_a.html (the drawing the owner said "looks nice" about) with the changes listed in
notes.md applied one by one; every replacement is asserted, so nothing else in that page can drift."""
import re

A = "../../../../assets/"
W = A + "ui/wood/"

# Line icons, 24 x 24 (the game's KitIcon set plus a few in the same hand).
ICON = {
    "bag": '<path d="M12 2v3M8 5h8v14a4 4 0 0 1-8 0zM8 10h8"/>',
    "offer": '<rect x="2" y="4" width="20" height="16" rx="2"/><path d="m22 7-10 6L2 7"/>',
    "mat": '<rect x="2" y="14" width="20" height="6" rx="1"/><circle cx="8" cy="9" r="2.5"/><path d="M11 12l6-2 3 3"/>',
    "glove": '<path d="M6 11V8a5 5 0 0 1 5-5h3a5 5 0 0 1 5 5v5a5 5 0 0 1-5 5H9a3 3 0 0 1-3-3zM6 11H5a2 2 0 0 0 0 5h1M8 21h9M11 8h4"/>',
    "rope": '<path d="M8 21V10a2 2 0 1 1 4 0M12 10V8a2 2 0 1 1 4 0v13M4 21h16"/>',
    "rest": '<path d="M21 13A9 9 0 1 1 11 3a7 7 0 0 0 10 10z"/>',
    "weight": '<rect x="3" y="4" width="18" height="16" rx="3"/><path d="M8 9a5 5 0 0 1 8 0M12 9l2-2"/>',
    "tired": '<rect x="2" y="8" width="17" height="9" rx="2"/><path d="M22 11v3M6 11v3M10 11v3"/>',
    "pulse": '<path d="M2 12h5l2-6 4 12 2-6h7"/>',
    "mood": '<circle cx="12" cy="12" r="9"/><path d="M8 14s1.5 2 4 2 4-2 4-2M9 9h.01M15 9h.01"/>',
    "shield": '<path d="M12 3l8 3v6c0 5-3.5 8-8 9-4.5-1-8-4-8-9V6z"/><path d="M12 3v18"/>',
    "brain": '<path d="M9 3a3 3 0 0 0-3 3 3 3 0 0 0-2 5 3 3 0 0 0 2 5 3 3 0 0 0 6 2V5a2 2 0 0 0-3-2zM15 3a3 3 0 0 1 3 3 3 3 0 0 1 2 5 3 3 0 0 1-2 5 3 3 0 0 1-6 2"/>',
    "feet": '<path d="M7 16c-2 0-3-1.5-3-4s1-5 3-5 3 2.5 3 5-1 4-3 4zM5 19h4M17 13c-2 0-3-1.5-3-4s1-5 3-5 3 2.5 3 5-1 4-3 4zM15 16h4"/>',
    "week": '<rect x="3" y="5" width="18" height="16" rx="2"/><path d="M3 10h18M8 3v4M16 3v4M8 14h2M14 14h2"/>',
    "plan": '<path d="M4 19c4 0 4-12 9-12h5M15 3l4 4-4 4"/><circle cx="5" cy="6" r="2"/>',
    "compare": '<circle cx="8" cy="8" r="3"/><circle cx="17" cy="9" r="2.5"/><path d="M2 20c0-4 3-6 6-6s6 2 6 6M15.5 14.2c3 0 5.5 1.6 5.5 5"/>',
    "coin": '<circle cx="12" cy="12" r="9"/><path d="M15 9.2c-1-1.6-5.2-1.6-5.2.8 0 2.6 5.2 1.6 5.2 4.2 0 2.4-4.2 2.4-5.6.6M12 6v12"/>',
    "flag": '<path d="M5 21V4M5 4h13l-2.5 4 2.5 4H5"/>',
    "table": '<path d="M9 21V9h6v12M3 21v-7h6M15 21v-5h6v5M2 21h20"/>',
    "belt": '<rect x="2" y="9" width="20" height="6" rx="1"/><path d="M9 9v6M15 9v6"/>',
    "road": '<path d="M7 21 10 3M17 21 14 3M12 6v2M12 11v3M12 17v3"/>',
}


def ico(name: str, size: int = 24, cls: str = "") -> str:
    return '<svg class="ico %s" width="%d" height="%d" viewBox="0 0 24 24">%s</svg>' % (cls, size, size, ICON[name])


# ---------------------------------------------------------------------------------------------------------------------
# Carried over from the gym screen. Colours sampled from ref/gym_screen.png (table in notes.md); the wood is the game's
# own cut (assets/ui/wood), laid as the game lays it (9 px corners, the bar's last 8 rows kept unscaled).
GYM_CSS = """
/* ---- the gym screen's top bar, rebuilt (Shell.gd: 78 px, 18 px sides, 14 px gaps) ---- */
.top{position:absolute;left:0;top:0;width:1920px;height:78px;z-index:5;border-style:solid;border-width:0 0 8px 0;border-image:url(WOODbar.png) 0 0 8 0 fill / 0 0 8px 0 / 0 stretch;display:flex;align-items:center;gap:14px;padding:8px 18px 0 18px;color:#efe6d8;font-family:Barlow,"Segoe UI",sans-serif}
.tab9{border:9px solid transparent;border-image:url(WOODtab.png) 9 fill / 9px / 0 stretch}
.plank9{border:9px solid transparent;border-image:url(WOODplank.png) 9 fill / 9px / 0 stretch}
.tnav{width:36px;height:36px;display:flex;align-items:center;justify-content:center;font:500 20px/1 Barlow;color:#efe6d8;flex:none}
.tnav.off{opacity:.42}
.tmenu{width:auto;height:37px;padding:0 3px 2px 3px;font:500 16px/1 Barlow}
.tgym{font:400 32px/1 Marker;color:#6ea2f2;white-space:nowrap;padding-top:2px}
.tdate{min-width:176px}.tdate b{display:block;font:500 19px/23px Barlow;color:#efe6d8;white-space:nowrap}.tdate i{display:block;font:400 15px/18px Barlow;font-style:normal;color:#b8a88f}
.trail{flex:1;display:flex;justify-content:center;gap:6px}
.rail{min-width:128px;height:48px;padding:0 5px 2px 5px;display:flex;align-items:center;justify-content:center;font:600 19px/1 Barlow;color:#efe6d8;white-space:nowrap}
.rail .ico{margin:0 -24px 0 4px}.rail u{flex:1;text-align:center;text-decoration:none}
.tgrow{flex:1}
.tcash{text-align:right}.tcash b{display:block;font:600 24px/28px Barlow;color:#e8c15a}.tcash i{display:block;font:400 15px/18px Barlow;font-style:normal;color:#b8a88f;white-space:nowrap}
.tgo{width:270px;height:54px;padding:0 7px 2px 7px;display:flex;flex-direction:column;justify-content:center;flex:none}
.tgo b{display:block;font:600 19px/23px Barlow;color:#efe6d8;white-space:nowrap}.tgo i{display:block;font:400 15px/18px Barlow;font-style:normal;color:#efe6d8;white-space:nowrap}
/* ---- the gym screen's pin, its navy label and its news strip ---- */
.pin{width:56px;height:56px;border-radius:50%;background:#1c2640;border:3px solid #fdfaf2;display:grid;place-items:center;color:#fff;box-shadow:0 3px 10px rgba(0,0,0,.45);flex:none}
.pin.red{background:#e2483d}
.plate{display:inline-flex;align-items:center;height:36px;padding:0 12px;border-radius:8px;background:#1d2741;color:#fffbf3;font:700 22px/1 Barlow;white-space:nowrap}
.strip{display:flex;align-items:center;gap:12px;height:48px;padding:0 14px 0 10px;border-radius:8px;background:#252d45;color:#fff;font:700 21px/1 Barlow;white-space:nowrap}
.tag{display:inline-flex;align-items:center;height:32px;padding:0 10px;border-left:4px solid #275696;border-radius:3px;background:#1a2033;color:#8eb8f2;font:600 20px/1 Barlow;letter-spacing:.01em;text-transform:uppercase;white-space:nowrap}
.strip small{font:500 20px/1 Barlow;color:#b8c3de}
.link{color:#8eb8f2}
/* tabs: the gym's navy label; the open one in the tag's blue, with the glow the approved drawing had */
.tabs{position:absolute;left:28px;top:92px;display:flex;gap:6px}
.tab{height:48px;padding:0 17px;border-radius:8px;display:flex;align-items:center;gap:10px;font-weight:700;color:#b8c3de;background:#1d2741;white-space:nowrap}
.tab.on{color:#fff;background:#275696;box-shadow:0 0 26px 2px rgba(255,205,90,.42)}
.tab.off{color:#7f8aa6;background:rgba(29,39,65,.55)}.tab small{font:500 20px/1 Barlow;color:#7f8aa6}
""".replace("WOOD", W)


def top_bar() -> str:
    """The gym screen's own Monday, so the three pictures show one moment of one game."""
    return ('<div class="top"><span class="tnav tab9">&lt;</span><span class="tnav tab9 off">&gt;</span>'
            '<span class="tgym">Anvil Street Gym</span><span class="tdate"><b>Mon 12 Jan 2026</b><i>Week 2</i></span>'
            '<span class="trail"><span class="rail plank9">%s<u>Gym</u></span><span class="rail plank9">Mail (5 new)</span></span>'
            '<span class="tgrow"></span><span class="tcash"><b>$16,841</b><i>running -$680 a week</i></span>'
            '<span class="tgo plank9"><b>NEEDS YOU (1)</b><i>Answer Lucy\'s bout offer</i></span><span class="tnav tmenu tab9">Menu</span></div>'
            % ico("bag", 24))


def must(s: str, old: str, new: str, count: int = 1) -> str:
    assert s.count(old) == count, (old[:80], s.count(old))
    return s.replace(old, new)


def must_re(s: str, pat: str, new: str) -> str:
    out, n = re.subn(pat, lambda m: new, s, flags=re.S)
    assert n == 1, (pat[:80], n)
    return out


# ---------------------------------------------------------------------------------------------------------------------
OV_CSS = """
/* ---- added for the final set ---- */
.sub{display:flex;align-items:center;gap:10px;margin-top:2px}
.sub .plate{height:32px;font-size:21px}
.rank{display:flex;align-items:center;gap:8px;margin-top:6px;font-size:22px;color:var(--soft);white-space:nowrap}
.rank b{color:#fff;font-weight:700}.rank span{color:var(--gold);font-weight:600}.rank .ico{color:var(--gold)}
.cl h3{align-items:center}
.hpin{width:32px;height:32px;border-width:2.5px;margin-right:-2px;box-shadow:0 2px 6px rgba(0,0,0,.4)}
.lead{z-index:2}
.bpin{position:absolute;z-index:3;width:44px;height:44px;margin:-22px 0 0 -22px}
.sw{position:absolute;left:806px;top:150px;display:flex;gap:8px;z-index:3}
.sw div{position:relative;width:70px;text-align:center;font-size:20px;line-height:22px;font-weight:600;color:var(--soft)}
.sw img{display:block;width:48px;height:48px;margin:4px auto 4px;border-radius:50%;border:2.5px solid #fdfaf2;opacity:.7}
.sw .on{color:#fff}.sw .on img{width:56px;height:56px;margin:0 auto;border:3px solid var(--gold);opacity:1;box-shadow:0 0 18px 3px rgba(255,205,90,.55)}
.sw s{position:absolute;left:44px;top:-2px;width:18px;height:18px;border-radius:50%;background:#e2483d;border:2px solid #fdfaf2}
.tv{grid-column:4/6;display:flex;align-items:center;gap:8px;white-space:nowrap}
.tv .v{text-align:left}
.bar .zone{position:absolute;left:80%;right:0;top:0;bottom:0;border-radius:0 8px 8px 0;background:rgba(221,75,61,.42)}
.act{display:flex;align-items:center;gap:12px;height:60px;padding-right:14px;border-radius:30px 10px 10px 30px;background:#1d2741;color:#fffbf3;font:700 22px/1 Barlow;white-space:nowrap;box-shadow:0 3px 10px rgba(0,0,0,.35)}
.act .pin{width:60px;height:60px;box-shadow:none}
.act small{font:500 20px/1 Barlow;color:#b8c3de}
.gface{position:relative}
.gface img{display:block;width:176px;height:176px;margin:7px;border-radius:50%;border:4px solid #fdfaf2;box-shadow:0 4px 14px rgba(0,0,0,.5)}
.gface .plate{position:absolute;left:50%;bottom:-2px;transform:translateX(-50%);height:34px;box-shadow:0 2px 8px rgba(0,0,0,.5)}
.gbub div{align-items:center;gap:14px}
.doit{display:inline-flex;align-items:center;height:40px;padding:0 18px;border-radius:9px;background:linear-gradient(#ffe070,#f0b32a);color:#2a1b06;font:700 21px/1 Barlow;box-shadow:0 2px 0 #9a6c10}
.key b{font-weight:500;margin-left:22px}.key s+s{margin-left:0}
"""


def h3(icon: str, title: str, cap: str) -> str:
    return '<h3><i class="pin hpin">%s</i>%s<span>%s</span></h3>' % (ico(icon, 19), title, cap)


def overview() -> str:
    s = open("../../s430/overview_a.html", encoding="utf-8").read()
    s = must(s, "<title>Overview A - the body chart</title>", "<title>Fighter page, Profile tab: the body chart (final)</title>")
    s = must(s, "../../../assets/fonts/", A + "fonts/", 7)
    # (1) the top bar: a copy of the gym screen's; (4) the six tabs as the gym's navy labels
    s = must_re(s, r"/\* top bar: as the game draws it today.*?(?=/\* buttons \*/)", GYM_CSS.strip() + "\n")
    s = must_re(s, r'<div class="top">.*?</div>(?=<div class="tabs">)', top_bar())
    s = must(s, '<span class="tab on">Overview</span><span class="tab">Training</span><span class="tab">Playbook</span><span class="tab">History</span>',
             '<span class="tab on">Profile</span><span class="tab">Condition</span><span class="tab">Training</span>'
             '<span class="tab">Playbook</span><span class="tab">Fight plan</span><span class="tab">History</span>')
    s = must(s, "</style>", OV_CSS + "</style>")
    # (6) the next step sits on the gym's news strip with its blue tag; the one gold button is as it was
    s = must_re(s, r"\.step\{position:absolute.*?\.step span\{[^}]*\}",
                ".step{position:absolute;left:776px;right:28px;top:88px;height:56px;display:flex;align-items:center;gap:14px;justify-content:flex-end}")
    s = must_re(s, r'<div class="step">.*?</div>(?=<div class="abs" style="left:28px;top:156px">)',
                '<div class="step"><span class="strip"><span class="tag">Show in 19 days</span>Bout offer: <span class="link">Maria Ortega</span>'
                '<small>the 5th bout opens the nationals</small></span><span class="go">Answer the bout offer</span></div>')
    s = must(s, ".go{display:inline-flex;align-items:center;justify-content:center;gap:10px;height:56px;padding:0 24px;border-radius:11px;background:linear-gradient(#ffe070,#f0b32a);color:#2a1b06;font-weight:700;font-size:23px;box-shadow:0 3px 0 #9a6c10;white-space:nowrap}",
             ".go{display:inline-flex;align-items:center;justify-content:center;gap:10px;height:56px;padding:0 24px;border-radius:11px;background:linear-gradient(#ffe070,#f0b32a);color:#2a1b06;font-weight:700;font-size:23px;box-shadow:0 3px 0 #9a6c10,0 0 26px 2px rgba(255,205,90,.30);white-space:nowrap}")
    # the header: weight class on the gym's navy label, the style word, the record and how far the table is
    s = must(s, '<div class="abs" style="left:28px;top:156px"><div class="name">LUCY JACKSON</div><div class="sub">Lightweight, 21, orthodox, amateur 3-2</div></div>',
             '<div class="abs" style="left:28px;top:150px"><div class="name">LUCY JACKSON</div>'
             '<div class="sub"><span class="plate">Lightweight</span>21, orthodox, out-boxer</div>'
             '<div class="rank">' + ico("table", 22) + '<b>3-1</b>amateur<span>1 win from the table</span></div></div>')
    # one click between the four fighters: four small face pins above the figure
    sw = '<div class="sw">' + "".join(
        '<div%s><img src="face_%s.png" alt="">%s%s</div>' % (' class="on"' if k == 0 else "", n.lower(), "<s></s>" if k == 0 else "", n)
        for k, n in enumerate(["Lucy", "Samira", "Tess", "Ana"])) + "</div>"
    # (5) the real 3D figure, standing on the gym's training mat (no wood below the top bar)
    s = must_re(s, r'<div class="abs" style="left:806px;top:236px"><svg class="fig".*?</svg></div><div class="figtag"[^>]*>[^<]*</div>',
                sw + '<div class="abs" style="left:852px;top:980px;width:300px;height:64px;background:radial-gradient(closest-side,rgba(0,0,0,.66),transparent)"></div>'
                '<img class="abs fig" src="figure.png" style="left:760px;top:236px;height:810px" alt="">')
    s = must_re(s, r"\.floor\{position:absolute.*?opacity:\.9\}",
                ".floor{position:absolute;left:706px;right:674px;bottom:0;height:168px;background:linear-gradient(rgba(168,52,59,.55),rgba(110,35,40,.9));clip-path:polygon(8% 0,92% 0,100% 100%,0 100%);opacity:.8}\n"
                ".floor::after{content:'';position:absolute;inset:0;background:repeating-linear-gradient(90deg,rgba(0,0,0,.16) 0 2px,transparent 2px 100px),linear-gradient(#3d373a,#2b2729 60%,#1d1a1c);clip-path:polygon(9.2% 8px,90.8% 8px,98.2% 100%,1.8% 100%)}")
    s = must(s, ".fig{display:block;filter:drop-shadow(-3px 0 0 rgba(255,214,160,.20)) drop-shadow(0 0 34px rgba(255,170,80,.10))}",
             ".fig{display:block;filter:drop-shadow(0 0 30px rgba(255,170,80,.12)) drop-shadow(0 14px 10px rgba(0,0,0,.5))}")
    # the left column moves 14 px down for the header's third line; the legend becomes one line
    s = must(s, '<div class="cl" style="left:28px;top:268px">', '<div class="cl" style="left:28px;top:282px">')
    s = must(s, '<div class="cl" style="left:28px;top:560px">', '<div class="cl" style="left:28px;top:574px">')
    s = must_re(s, r'<div class="abs key" style="left:28px;top:808px">.*?Elite</div></div>',
                '<div class="abs key" style="left:28px;top:830px"><em></em>&nbsp;ceiling 84&nbsp;&nbsp;&nbsp;&nbsp;<u></u>&nbsp;goal<i></i>&nbsp;cannot be trained'
                '<b>Weak</b><s style="background:var(--weak)"></s><s style="background:var(--fair)"></s><s style="background:var(--solid)"></s>'
                '<s style="background:var(--strong)"></s><s style="background:var(--elite)"></s>&nbsp;Elite</div>')
    # the same pin sits on the body and before its group's title
    for old, icon, title, cap in (("<h3>HEAD<span>reads the fight, keeps the plan</span></h3>", "brain", "HEAD", "reads the fight, keeps the plan"),
                                  ("<h3>HANDS<span>what lands</span></h3>", "glove", "HANDS", "what lands"),
                                  ("<h3>GUARD<span>what gets through</span></h3>", "shield", "GUARD", "what gets through"),
                                  # (2) Engine is Cardio
                                  ("<h3>ENGINE<span>how long it lasts</span></h3>", "pulse", "CARDIO", "how long it lasts"),
                                  ("<h3>LEGS<span>where the fight happens</span></h3>", "feet", "LEGS", "gets in and out")):
        s = must(s, old, h3(icon, title, cap))
    assert "ngine" not in s
    ends = [("M432 305 H700 L966 268", 966, 268, "brain"), ("M282 597 H720 L850 366", 850, 366, "glove"),
            ("M1264 172 H1200 L1024 440", 1024, 440, "shield"), ("M1264 306 H1180 L1030 528", 1030, 528, "pulse"),
            ("M1264 480 H1210 L1030 786", 1030, 786, "feet"), ("M1264 654 H1230 L1052 992", 1052, 992, "weight")]
    lead = '<svg class="lead" width="1920" height="1080">' + "".join(
        '<path d="%s" fill="none" stroke="rgba(241,232,218,.5)" stroke-width="2.5" stroke-dasharray="1 8" stroke-linecap="round"/>' % e[0] for e in ends) + "</svg>"
    lead += "".join('<span class="pin bpin" style="left:%dpx;top:%dpx">%s</span>' % (e[1], e[2], ico(e[3], 24)) for e in ends)
    s = must_re(s, r'<svg class="lead".*?</svg>', lead)
    # (3) On the scale gains the tiredness meter (bar, number, rest days); with mood beside them the group is "Today"
    today = ('<div class="cl" style="left:1268px;top:632px">' + h3("weight", "TODAY", "weight limit 60.0 kg")
             + '<div class="r fair">' + ico("weight") + '<span class="n">Weight</span><span class="bar"><b style="width:94%"></b><em style="left:85%"></em></span>'
             '<span class="tv"><span class="v">60.9</span><span class="cap">0.9 over</span><span class="pill">+ Cut</span></span></div>'
             + '<div class="r strong">' + ico("tired") + '<span class="n">Tiredness</span><span class="bar"><span class="zone"></span><b style="width:38%"></b><em style="left:80%"></em></span>'
             '<span class="tv"><span class="v">38</span><span class="cap">Fresh, no rest day</span></span></div>'
             + '<div class="r solid">' + ico("mood") + '<span class="n">Mood</span><span class="bar"><b style="width:62%"></b></span>'
             '<span class="tv"><span class="v">62</span><span class="cap">Steady, listens</span></span></div></div>')
    s = must_re(s, r'<div class="cl" style="left:1268px;top:632px">.*?(?=<div class="goal">)', today)
    s = must(s, ".goal{position:absolute;left:1268px;top:784px;", ".goal{position:absolute;left:1268px;top:806px;")
    # the four quiet actions: the gym's pin fused to its navy label (gold stays for the one that stops the clock)
    s = must(s, ".acts{position:absolute;left:1268px;top:904px;width:624px;display:grid;grid-template-columns:1fr 1fr;gap:12px}",
             ".acts{position:absolute;left:1268px;top:912px;width:624px;display:grid;grid-template-columns:1fr 1fr;gap:14px 12px}")
    acts = "".join('<span class="act"><i class="pin">%s</i>%s%s</span>' % (ico(i, 28), t, "<small>%s</small>" % sm if sm else "")
                   for i, t, sm in (("week", "Plan the week", ""), ("plan", "Fight plan", "5 arrows"),
                                    ("compare", "Compare", "the four"), ("coin", "Stipend", "$250 a week")))
    s = must_re(s, r'<div class="acts">.*?</div>(?=\s*<div class="guide">)', '<div class="acts">' + acts + "</div>")
    # the guide: the game's own coach in the pin's white ring, named by role, the bubble on the label's navy;
    # the line is about this fighter and its button does what it says (the highlighted row and its chip)
    s = must_re(s, r"\.gbub\{width:452px;[^}]*\}", ".gbub{width:452px;background:#1d2741;border-radius:14px;padding:14px 22px 14px;box-shadow:0 6px 18px rgba(0,0,0,.45)}")
    s = must(s, ".gtail{width:24px;height:40px;margin-bottom:34px;background:#8a6a3d;clip-path:polygon(0 55%,100% 0,100% 100%)}",
             ".gtail{width:24px;height:40px;margin-bottom:44px;background:#1d2741;clip-path:polygon(0 55%,100% 0,100% 100%)}")
    s = must_re(s, r'<div class="gface"><svg.*?</svg></div>', '<div class="gface"><img src="face_trainer.png" alt=""><span class="plate">Coach</span></div>')
    s = must(s, '<p>Next job for the club: sign a second boxer.</p><div><span class="gskip">Skip the guide</span></div>',
             '<p>Lucy gives ground up close. Two sparring nights fix that.</p><div><span class="cap">Inside fighting +0.6 a week</span><span class="doit">Do it</span></div>')
    return s


# ---------------------------------------------------------------------------------------------------------------------
BAND = lambda v: "weak" if v < 45 else "fair" if v < 55 else "solid" if v < 65 else "strong" if v < 75 else "elite"
GROUPS = [("brain", "Head"), ("glove", "Hands"), ("shield", "Guard"), ("pulse", "Cardio"), ("feet", "Legs")]


def rest_days(v: int) -> int:
    days, f = 0, float(v)
    while f >= 50.0:      # rules/Aftermath: a full rest day leaves 87%; under 50 is fresh
        f *= 0.87
        days += 1
    return days


FIGHTERS = [
    {"face": "lucy", "name": "Lucy Jackson", "l1": "Lightweight, 21", "rec": "3-1", "rank": "1 win from the table", "belt": 0,
     "need": True, "overall": 60, "ceil": 84, "groups": [60, 59, 62, 63, 59], "style": "Out-boxer", "st2": "Out-boxer, orthodox", "move": ("Jab", 61, "Sharp"),
     "tired": 38, "kg": 60.9, "limit": 60.0, "weigh": True, "mood": 62,
     "coach": ("glove", "Spar twice", "Fix", "Inside fighting +0.6 a week"),
     "goal": (40, "Stamina to 61", "18 days left", "On track"),
     "next": ("19", "Offer", "Maria Ortega 5-2", "Sat 31 Jan, answer by Thu"),
     "act": ("go", "offer", "Answer offer")},
    {"face": "samira", "name": "Samira Khan", "l1": "Welterweight, 18", "rec": "2-1", "rank": "2 wins from the table", "belt": 0,
     "need": False, "overall": 55, "ceil": 82, "groups": [47, 66, 55, 56, 53], "style": "Slugger", "st2": "Slugger, orthodox", "move": ("Cross", 44, "Usable"),
     "tired": 44, "kg": 64.6, "limit": 65.0, "weigh": False, "mood": 78,
     "coach": ("rope", "Slip rope", "Fix", "Defence +0.8 a week"),
     "goal": (100, "Defence to 52", "goal met", "Pick the next"),
     "next": ("", "", "No bout", "next offers Mon 19 Jan"),
     "act": ("pin", "flag", "Set a goal")},
    {"face": "tess", "name": "Tess Reilly", "l1": "Middleweight, 23", "rec": "6-4", "rank": "Number 8, London", "belt": 0,
     "need": False, "overall": 61, "ceil": 76, "groups": [60, 61, 66, 65, 51], "style": "Pressure fighter", "st2": "Pressure fighter, southpaw", "move": ("Body hook", 63, "Sharp"),
     "tired": 72, "kg": 76.1, "limit": 75.0, "weigh": False, "mood": 58,
     "coach": ("rest", "Rest to Thursday", "Rest", "3 rest days, back under 50"),
     "goal": (45, "Speed to 57", "16 days left", "On track"),
     "next": ("", "", "No bout", "next offers Mon 19 Jan"),
     "act": ("pin", "rest", "Rest 3 days")},
    {"face": "ana", "name": "Ana Ribeiro", "l1": "No-gi featherweight, 22", "rec": "4-2", "rank": "White belt", "belt": 2,
     "need": False, "overall": 54, "ceil": 80, "groups": [62, 49, 47, 58, 55], "style": "Guard player", "st2": "Guard player", "move": ("Kimura", 24, "Learning"),
     "tired": 30, "kg": 57.2, "limit": 58.5, "weigh": False, "mood": 55,
     "coach": ("mat", "Drill the kimura", "Drill", "Kimura 24, owned at 30"),
     "goal": (62, "Third stripe", "6 classes left", "On track"),
     "next": ("12", "Open", "London No-Gi Open", "Sat 24 Jan, not entered"),
     "act": ("pin", "mat", "Enter the open")},
]
BEST = [max(range(4), key=lambda k: FIGHTERS[k]["groups"][g]) for g in range(5)]

SQUAD_CSS = """
@font-face{font-family:Marker;src:url(ASSETfonts/PermanentMarker-Regular.ttf)}
@font-face{font-family:Barlow;font-weight:400;src:url(ASSETfonts/Barlow-Regular.ttf)}
@font-face{font-family:Barlow;font-weight:500;src:url(ASSETfonts/Barlow-Medium.ttf)}
@font-face{font-family:Barlow;font-weight:600;src:url(ASSETfonts/Barlow-SemiBold.ttf)}
@font-face{font-family:Barlow;font-weight:700;src:url(ASSETfonts/Barlow-Bold.ttf)}
@font-face{font-family:Bebas;src:url(ASSETfonts/BebasNeue-Regular.ttf)}
:root{--ink:#f1e8da;--soft:#c9b9a2;--gold:#ffd24a;--red:#dd4b3d;--blue:#4d8ef0;--green:#3fc07a;--amber:#f28d27;--purple:#ad80ff;
 --track:rgba(255,255,255,.10);--weak:#dd4b3d;--fair:#f28d27;--solid:#4d8ef0;--strong:#3fc07a;--elite:#ad80ff;--plain:#b9ae9f}
*{box-sizing:border-box;margin:0;padding:0}
html,body{width:1920px;height:1080px;overflow:hidden}
body{position:relative;background:#120e0c;color:var(--ink);font:500 22px/1.2 Barlow,"Segoe UI",sans-serif}
.ico{fill:none;stroke:currentColor;stroke-width:2;stroke-linecap:round;stroke-linejoin:round;flex:none}
/* the same dim wall and warm lamp as the fighter page */
.wall{position:absolute;left:0;right:0;top:78px;bottom:0;background:
 radial-gradient(ellipse 900px 520px at 50% 22%,rgba(255,190,110,.11),transparent 72%),
 radial-gradient(ellipse 620px 420px at 4% 60%,rgba(221,75,61,.06),transparent 70%),
 radial-gradient(ellipse 620px 420px at 97% 55%,rgba(77,142,240,.06),transparent 70%),
 linear-gradient(#1b1512,#130f0d 62%,#0e0b09)}
GYMCSS
.tabs{left:318px}
.title{position:absolute;left:28px;top:88px;height:56px;display:flex;align-items:center;gap:14px;font:400 44px/1 Marker;color:#fff;white-space:nowrap}
.news{position:absolute;right:28px;top:92px}
.weak{--c:var(--weak)}.fair{--c:var(--fair)}.solid{--c:var(--solid)}.strong{--c:var(--strong)}.elite{--c:var(--elite)}.plain{--c:var(--plain)}
.go{display:flex;align-items:center;justify-content:center;gap:9px;height:56px;border-radius:11px;background:linear-gradient(#ffe070,#f0b32a);color:#2a1b06;font-weight:700;font-size:22px;box-shadow:0 3px 0 #9a6c10,0 0 26px 2px rgba(255,205,90,.30);white-space:nowrap}
/* column heads: the fighter page's gold group titles */
.hd{position:absolute;top:154px;height:32px;display:flex;align-items:center;gap:8px;font-weight:700;font-size:20px;letter-spacing:.09em;color:var(--gold);white-space:nowrap}
.hd .ico{color:var(--gold)}
.hd .pin{width:32px;height:32px;border-width:2.5px;box-shadow:0 2px 6px rgba(0,0,0,.4)}
/* one fighter a row: no box, a hairline between rows; the row that needs you carries a warm wash */
.row{position:absolute;left:28px;width:1864px;height:205px;border-top:1px solid rgba(255,255,255,.085)}
.row.need{border-top-color:transparent;border-radius:16px;background:linear-gradient(90deg,rgba(226,72,61,.20),rgba(226,72,61,.07) 38%,rgba(255,205,90,.05) 80%,rgba(255,205,90,.09))}
.row.need+.row{border-top-color:transparent}
.row>*{position:absolute}
.face{left:10px;top:42px;width:120px;height:120px;border-radius:50%;border:4px solid #fdfaf2;overflow:hidden;background:#1c2640;box-shadow:0 5px 16px rgba(0,0,0,.5)}
.face img{display:block;width:112px;height:112px}
.badge{left:96px;top:32px;width:46px;height:46px}
.who{left:140px;top:30px;width:250px}
.who .plate{height:38px;font-size:25px;padding:0 12px}
.who p{font-size:20px;line-height:26px;color:var(--soft);white-space:nowrap;margin-top:8px}
.who p+p{margin-top:0;color:var(--ink);font-weight:600}
.who .rk{display:flex;align-items:center;gap:8px;font-size:20px;line-height:26px;margin-top:6px;white-space:nowrap;color:var(--gold);font-weight:600}
.who .rk b{color:#fff;font-weight:700}.who .rk .ico{color:var(--gold)}
.stripes{display:inline-flex;gap:3px;align-items:center}.stripes i{width:34px;height:14px;border-radius:2px;background:#f1e8da}.stripes s{width:5px;height:14px;background:#f1e8da}
.ring{left:392px;top:40px;width:92px;height:92px;border-radius:50%;display:grid;place-items:center;font:400 44px/1 Bebas;color:#fff;letter-spacing:.02em;padding-top:3px}
.sty{left:392px;top:150px;width:306px;font-size:20px;color:var(--soft);white-space:nowrap}
.sty b{color:var(--ink);font-weight:600}.sty u{text-decoration:none;font-weight:700;color:color-mix(in srgb,var(--c) 78%,#fff)}
.grp{left:496px;top:30px;display:flex}
.grp div{position:relative;width:40px;height:106px;text-align:center}
.grp b{display:block;font-size:20px;line-height:24px;font-weight:700;color:color-mix(in srgb,var(--c) 78%,#fff)}
.grp i{position:absolute;left:12px;top:28px;width:16px;height:64px;border-radius:8px;background:var(--track)}
.grp i::after{content:'';position:absolute;left:0;right:0;bottom:0;height:var(--h);border-radius:8px;background:var(--c)}
.grp s{position:absolute;left:16px;top:97px;width:8px;height:8px;border-radius:50%;background:var(--gold);box-shadow:0 0 8px 1px rgba(255,205,90,.7)}
.tile{top:38px;width:118px}
.tile b{display:block;font:400 54px/50px Bebas;letter-spacing:.02em;color:color-mix(in srgb,var(--c) 78%,#fff);white-space:nowrap}
.tile b small{font:600 20px/1 Barlow;letter-spacing:0;color:var(--soft);margin-left:5px}
.bar{display:block;position:relative;height:14px;border-radius:7px;background:var(--track);margin-top:8px}
.bar b{position:absolute;left:0;top:0;bottom:0;border-radius:7px;background:var(--c)}
.bar em{position:absolute;top:-5px;width:3px;height:24px;border-radius:2px;background:#fff}
.bar .zone{position:absolute;left:80%;right:0;top:0;bottom:0;border-radius:0 7px 7px 0;background:rgba(221,75,61,.42)}
.tile p{font-size:20px;line-height:24px;margin-top:10px;white-space:nowrap;color:var(--soft)}
.tile p.w{font-weight:600;color:color-mix(in srgb,var(--c) 74%,#fff)}
.coach{left:1110px;top:34px;display:flex;align-items:center;gap:12px;height:58px}
.coach .pin{width:50px;height:50px}
.coach b{display:flex;align-items:center;gap:10px;font-size:23px;font-weight:700;white-space:nowrap}
.coach .tag{height:26px;padding:0 8px;font-size:20px}
.coach i{display:block;font-style:normal;font-size:20px;font-weight:600;color:var(--green);white-space:nowrap;margin-top:3px}
.coach i.q{color:var(--soft);font-weight:500}
.goal{left:1110px;top:110px;display:flex;align-items:center;gap:12px;height:58px}
.gr{width:50px;height:50px;border-radius:50%;display:grid;place-items:center;font:400 23px/1 Bebas;padding-top:2px;flex:none}
.goal b{display:block;font-size:21px;font-weight:600;white-space:nowrap}
.goal i{display:block;font-style:normal;font-size:20px;color:var(--soft);white-space:nowrap;margin-top:3px}
.goal i u{text-decoration:none;font-weight:700;color:var(--green);margin-left:8px}
.next{left:1436px;top:36px;width:228px}
.next .d{display:flex;align-items:center;gap:8px;height:52px}
.next .d b{font:400 54px/50px Bebas;color:#fff;letter-spacing:.02em}
.next .d small{font-size:20px;color:var(--soft);margin-right:4px}
.next .d .tag{height:28px;padding:0 8px}
.next .o{font-size:22px;font-weight:700;line-height:28px;margin-top:8px;white-space:nowrap}
.next .o.none{font-size:26px;color:var(--soft);margin-top:20px}
.next p{font-size:20px;line-height:26px;color:var(--soft);white-space:nowrap;margin-top:2px}
.do{left:1668px;top:0;width:192px;height:204px;display:flex;flex-direction:column;align-items:center;justify-content:center}
.do .pin{margin-bottom:-4px;position:relative;z-index:1}
.do .go{width:192px;padding:0 6px}
.key{position:absolute;left:28px;right:28px;top:1030px;display:flex;justify-content:center;align-items:center;gap:8px;font-size:20px;color:var(--soft);white-space:nowrap}
.key s{width:14px;height:14px;border-radius:4px;display:inline-block}
.key em{display:inline-block;width:3px;height:20px;background:#fff;border-radius:2px}
.key i{display:inline-block;width:10px;height:10px;border-radius:50%;background:var(--gold);margin-left:30px}
.key u{display:inline-block;width:18px;height:18px;border-radius:50%;background:#e2483d;border:2px solid #fdfaf2;margin-left:30px}
.key b{font-weight:500;margin-left:30px}
""".replace("ASSET", A).replace("GYMCSS", GYM_CSS)


def tile(x: int, cls: str, big: str, unit: str, fill: int, tick, zone: bool, word: str, strong: bool) -> str:
    em = '<em style="left:%d%%"></em>' % tick if tick is not None else ""
    return ('<div class="tile %s" style="left:%dpx"><b>%s%s</b><span class="bar">%s<b style="width:%d%%"></b>%s</span><p%s>%s</p></div>'
            % (cls, x, big, "<small>%s</small>" % unit if unit else "", '<span class="zone"></span>' if zone else "", fill, em,
               ' class="w"' if strong else "", word))


def row(i: int, f: dict) -> str:
    h = '<div class="row%s" style="top:%dpx">' % (" need" if f["need"] else "", 192 + i * 205)
    h += '<div class="face"><img src="face_%s.png" alt=""></div>' % f["face"]
    if f["need"]:
        h += '<span class="pin red badge">%s</span>' % ico("offer", 24)
    rk = ('<span class="stripes"><i></i>' + "<s></s>" * f["belt"] + "</span>") if f["belt"] else ""
    h += ('<div class="who"><span class="plate">%s</span><p>%s</p><p>%s</p><div class="rk"><b>%s</b>%s%s</div></div>'
          % (f["name"], f["l1"], f["st2"], f["rec"], rk, f["rank"]))
    o = f["overall"]
    h += ('<div class="ring" style="background:radial-gradient(closest-side,#17120f 76%%,transparent 77%% 100%%),'
          'conic-gradient(var(--gold) 0 %d%%,var(--track) %d%% 100%%)">%d</div>' % (o, o, o))
    h += '<div class="grp">' + "".join(
        '<div class="%s"><b>%d</b><i style="--h:%d%%"></i>%s</div>' % (BAND(v), v, v, "<s></s>" if BEST[g] == i else "")
        for g, v in enumerate(f["groups"])) + "</div>"
    m = f["move"]
    tier = "weak" if m[1] < 30 else "fair" if m[1] < 60 else "strong" if m[1] < 85 else "elite"
    h += '<div class="sty %s">Best move: <b>%s</b> <u>%d %s</u></div>' % (tier, m[0], m[1], m[2])
    # today: tiredness, weight, mood
    t, d = f["tired"], rest_days(f["tired"])
    h += tile(712, "strong" if t < 50 else "fair" if t < 80 else "weak", str(t), "", t, 80, True,
              "Fresh" if d == 0 else "%d rest day%s" % (d, "" if d == 1 else "s"), d > 0)
    over = round(f["kg"] - f["limit"], 1)
    fill = max(4, min(100, int(round(85 + (f["kg"] - f["limit"]) * 10))))
    if f["weigh"]:
        h += tile(844, "fair" if over > 0 else "strong", "%.1f" % f["kg"], "kg", fill, 85, False,
                  "%.1f kg over" % over if over > 0 else "on weight", True)
    else:
        h += tile(844, "plain", "%.1f" % f["kg"], "kg", fill, 85, False, "limit %.1f" % f["limit"], False)
    mv = f["mood"]
    h += tile(976, "strong" if mv >= 75 else "solid" if mv >= 50 else "fair" if mv >= 30 else "weak", str(mv), "", mv, None, False,
              "Fired up" if mv >= 75 else "Steady" if mv >= 50 else "Flat" if mv >= 30 else "Low", mv >= 75 or mv < 50)
    c = f["coach"]
    h += ('<div class="coach"><span class="pin">%s</span><div><b>%s<span class="tag">%s</span></b><i%s>%s</i></div></div>'
          % (ico(c[0], 26), c[1], c[2], "" if "+" in c[3] else ' class="q"', c[3]))
    g = f["goal"]
    h += ('<div class="goal"><span class="gr" style="background:radial-gradient(closest-side,#17120f 70%%,transparent 71%% 100%%),'
          'conic-gradient(var(--green) 0 %d%%,var(--track) %d%% 100%%)">%s</span><div><b>Goal: %s</b><i>%s<u>%s</u></i></div></div>'
          % (g[0], g[0], "%d" % g[0] if g[0] < 100 else "&#10003;", g[1], g[2], g[3]))
    n = f["next"]
    if n[0]:
        h += ('<div class="next"><div class="d"><b>%s</b><small>days</small><span class="tag">%s</span></div><div class="o">%s</div><p>%s</p></div>'
              % (n[0], n[1], n[2], n[3]))
    else:
        h += '<div class="next"><div class="o none">%s</div><p>%s</p></div>' % (n[2], n[3])
    a = f["act"]
    if a[0] == "go":
        h += '<div class="do"><span class="go">%s%s</span></div>' % (ico(a[1], 24), a[2])
    else:
        h += '<div class="do"><span class="pin">%s</span><span class="plate">%s</span></div>' % (ico(a[1], 28), a[2])
    return h + "</div>"


def squad() -> str:
    body = '<div class="wall"></div>' + top_bar()
    body += '<div class="title"><span class="pin">%s</span>Fighters</div>' % ico("bag", 28)
    body += ('<div class="tabs"><span class="tab on">All four</span><span class="tab">Club week</span><span class="tab">Compare two</span>'
             '<span class="tab off">Find a fighter<small>4 of 4 places taken</small></span></div>')
    body += ('<div class="news"><span class="strip"><span class="tag">This week</span>Coach is off Wednesday'
             '<small>2 pad places gone</small><span class="link">Club week &gt;</span></span></div>')
    hd = lambda x, inner: '<div class="hd" style="left:%dpx">%s</div>' % (x, inner)
    body += hd(38, "FIGHTER") + hd(28 + 392, "OVERALL")
    body += "".join(hd(28 + 496 + 4 + 40 * k, '<span class="pin">%s</span>' % ico(g[0], 19)) for k, g in enumerate(GROUPS))
    body += hd(28 + 712, "TIREDNESS") + hd(28 + 844, "WEIGHT") + hd(28 + 976, "MOOD")
    body += hd(28 + 1110, "COACH SAYS, THIS WEEK") + hd(28 + 1436, "NEXT FIGHT") + hd(28 + 1668 + 52, "DO NEXT")
    body += "".join(row(i, f) for i, f in enumerate(FIGHTERS))
    body += ('<div class="key">' + "".join('<span class="pin" style="width:28px;height:28px;border-width:2px;box-shadow:none;margin-left:%dpx">%s</span>&nbsp;%s'
                                           % (0 if k == 0 else 14, ico(g[0], 16), g[1]) for k, g in enumerate(GROUPS))
             + '<i></i>&nbsp;best of the four<b></b><em></em>&nbsp;weight limit, too tired from 80'
             '<b>Weak</b><s style="background:var(--weak)"></s><s style="background:var(--fair)"></s><s style="background:var(--solid)"></s>'
             '<s style="background:var(--strong)"></s><s style="background:var(--elite)"></s>&nbsp;Elite<u></u>&nbsp;needs you</div>')
    return ('<!doctype html>\n<html lang="en"><head><meta charset="utf-8"><title>Fighters: all four (final)</title>\n<style>%s</style></head>\n<body>%s</body></html>\n'
            % (SQUAD_CSS, body))


# ---------------------------------------------------------------------------------------------------------------------
def side_by_side() -> str:
    css = """
@font-face{font-family:Barlow;font-weight:500;src:url(ASSETfonts/Barlow-Medium.ttf)}
@font-face{font-family:Barlow;font-weight:700;src:url(ASSETfonts/Barlow-Bold.ttf)}
*{box-sizing:border-box;margin:0;padding:0}
html,body{width:1920px;height:1080px;overflow:hidden}
body{position:relative;background:#0c0a09;color:#f1e8da;font:500 22px/1.2 Barlow,"Segoe UI",sans-serif}
.c{position:absolute;width:882px}
.c>img{display:block;width:882px;height:496px;border-radius:6px;box-shadow:0 0 0 1px rgba(255,255,255,.10),0 8px 24px rgba(0,0,0,.6)}
.c p{height:36px;display:flex;align-items:center;gap:12px;font-size:22px;color:#c9b9a2;white-space:nowrap}
.c p b{color:#fff;font-weight:700}
.c p i{font-style:normal;display:inline-flex;align-items:center;height:26px;padding:0 9px;border-left:4px solid #275696;border-radius:3px;background:#1a2033;color:#8eb8f2;font-weight:700;font-size:20px;letter-spacing:.02em}
.crop{position:absolute;overflow:hidden;border-radius:4px}
.crop img{position:absolute;max-width:none}
.lab{position:absolute;font-size:20px;line-height:24px;color:#c9b9a2;white-space:nowrap}
.lab b{color:#fff}
""".replace("ASSET", A)

    def crop(src: str, sx: int, sy: int, w: int, h: int, x: int, y: int, k: float = 1.0) -> str:
        return ('<div class="crop" style="left:%dpx;top:%dpx;width:%dpx;height:%dpx"><img src="%s" style="left:%dpx;top:%dpx;width:%dpx" alt=""></div>'
                % (x, y, round(w * k), round(h * k), src, -round(sx * k), -round(sy * k), round(1920 * k)))

    G, S, O = "../ref/gym_screen.png", "squad.png", "overview.png"
    b = ('<div class="c" style="left:64px;top:4px"><p><i>IN THE BUILD</i><b>The gym screen, Home</b>unchanged: the real screen, rendered from the build</p><img src="%s" alt=""></div>' % G)
    b += ('<div class="c" style="left:974px;top:4px"><p><i>NEW</i><b>Fighters: all four</b>the page behind the gym screen\'s Fighters pin</p><img src="%s" alt=""></div>' % S)
    b += ('<div class="c" style="left:64px;top:542px"><p><i>NEW</i><b>One fighter, Profile tab</b>the body chart, kept as drawn; Engine is now Cardio</p><img src="%s" alt=""></div>' % O)
    # the fourth cell: the same parts, cut from the three pictures
    x0, y0 = 974, 542
    b += ('<div class="c" style="left:%dpx;top:%dpx"><p><i>SAME PARTS</i><b>Cut from the three pictures</b>top to bottom: gym, Fighters, Profile</p></div>' % (x0, y0))
    y, k = y0 + 40, 0.83
    for src in (G, S, O):                       # the top bar: its left end and its right end
        b += crop(src, 0, 0, 545, 78, x0, y, k) + crop(src, 1398, 0, 522, 78, x0 + 882 - round(522 * k), y, k)
        y += 70
    y += 6                                      # the pin with its navy label
    b += crop(G, 862, 640, 122, 110, x0, y) + crop(G, 1188, 336, 100, 110, x0 + 128, y)
    b += crop(S, 1694, 446, 196, 106, x0 + 240, y + 2)
    b += crop(O, 1262, 906, 318, 72, x0 + 448, y + 18) + crop(O, 936, 238, 60, 60, x0 + 778, y + 24)
    b += '<div class="lab" style="left:%dpx;top:%dpx"><b>The pin and its navy label</b>: on the gym floor, as a fighter\'s next step, as an action, on the body</div>' % (x0, y + 114)
    y += 146                                    # the news strip with its blue tag
    b += crop(G, 1040, 1028, 728, 44, x0, y) + '<div class="lab" style="left:%dpx;top:%dpx"><b>The news strip</b></div>' % (x0 + 744, y + 10)
    b += crop(O, 868, 90, 744, 52, x0, y + 50) + '<div class="lab" style="left:%dpx;top:%dpx">and its blue tag</div>' % (x0 + 756, y + 64)
    return ('<!doctype html>\n<html lang="en"><head><meta charset="utf-8"><title>One game: gym, Fighters, Profile</title>\n<style>%s</style></head>\n<body>%s</body></html>\n' % (css, b))


if __name__ == "__main__":
    open("overview.html", "w", encoding="utf-8").write(overview())
    open("squad.html", "w", encoding="utf-8").write(squad())
    open("side_by_side.html", "w", encoding="utf-8").write(side_by_side())
    print("wrote overview.html, squad.html, side_by_side.html")
