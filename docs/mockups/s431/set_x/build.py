"""Writes overview.html and squad.html (set_x: the closest literal match to the gym screen). Run from this folder:
    python build.py   then, from E:/FightCamp/Lean:   python tools/render_mockup.py docs/mockups/s431/set_x/overview.html docs/mockups/s431/set_x/squad.html
overview.html is ../../s430/overview_a.html with only the listed changes applied (each one asserted below)."""
import re

A = "../../../../assets/"
W = A + "ui/wood/"

# The game's own line icons (scripts/ui/KitIcon.gd), 24 x 24.
ICON = {
    "bag": '<path d="M12 2v3M8 5h8v14a4 4 0 0 1-8 0zM8 10h8"/>',
    "offer": '<rect x="2" y="4" width="20" height="16" rx="2"/><path d="m22 7-10 6L2 7"/>',
    "booked": '<rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18M9 16l2 2 4-4"/>',
    "free": '<rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18M9 16h6"/>',
    "champion": '<path d="M3 18h18L19 7l-4 4-3-7-3 7-4-4zM4 21h16"/>',
    "mat": '<rect x="2" y="14" width="20" height="6" rx="1"/><circle cx="8" cy="9" r="2.5"/><path d="M11 12l6-2 3 3"/>',
    "sparring": '<path d="M6 11V8a5 5 0 0 1 5-5h3a5 5 0 0 1 5 5v5a5 5 0 0 1-5 5H9a3 3 0 0 1-3-3zM6 11H5a2 2 0 0 0 0 5h1M8 21h9M11 8h4"/>',
    "guard": '<path d="M8 21V10a2 2 0 1 1 4 0M12 10V8a2 2 0 1 1 4 0v13M4 21h16"/>',
    "rest": '<path d="M21 13A9 9 0 1 1 11 3a7 7 0 0 0 10 10z"/>',
    "weight": '<rect x="3" y="4" width="18" height="16" rx="3"/><path d="M8 9a5 5 0 0 1 8 0M12 9l2-2"/>',
    "tired": '<rect x="2" y="8" width="17" height="9" rx="2"/><path d="M22 11v3M6 11v3M10 11v3"/>',
    "fresh": '<path d="M2 12h5l2-6 4 12 2-6h7"/>',
    "mood": '<circle cx="12" cy="12" r="9"/><path d="M8 14s1.5 2 4 2 4-2 4-2M9 9h.01M15 9h.01"/>',
    "Strength": '<path d="M4 9v6M7 6v12M17 6v12M20 9v6M7 12h10"/>',
    "Explosive": '<path d="M13 2 4 14h7l-1 8 9-12h-7z"/>',
    "Speed": '<path d="M4 6l6 6-6 6M12 6l6 6-6 6"/>',
    "Stamina": '<path d="M2 12h5l2-6 4 12 2-6h7"/>',
    "Flexibility": '<path d="M5 19c0-9 5-14 14-14M13 5h6v6"/>',
    "Durability": '<path d="M12 3l8 3v6c0 5-3.5 8-8 9-4.5-1-8-4-8-9V6z"/>',
    "Defence": '<path d="M12 3l8 3v6c0 5-3.5 8-8 9-4.5-1-8-4-8-9V6z"/><path d="M12 3v18"/>',
    "Composure": '<path d="M3 9c3-3 6 3 9 0s6 3 9 0M3 15c3-3 6 3 9 0s6 3 9 0"/>',
    "brain": '<path d="M9 3a3 3 0 0 0-3 3 3 3 0 0 0-2 5 3 3 0 0 0 2 5 3 3 0 0 0 6 2V5a2 2 0 0 0-3-2zM15 3a3 3 0 0 1 3 3 3 3 0 0 1 2 5 3 3 0 0 1-2 5 3 3 0 0 1-6 2"/>',
    "feet": '<path d="M7 16c-2 0-3-1.5-3-4s1-5 3-5 3 2.5 3 5-1 4-3 4zM5 19h4M17 13c-2 0-3-1.5-3-4s1-5 3-5 3 2.5 3 5-1 4-3 4zM15 16h4"/>',
    "belt": '<rect x="2" y="9" width="20" height="6" rx="1"/><path d="M9 9v6M15 9v6"/>',
    "trophy": '<path d="M8 4h8v5a4 4 0 0 1-8 0zM8 6H4c0 3 1.5 4.5 4 4.5M16 6h4c0 3-1.5 4.5-4 4.5M12 13v4M8 20h8M10 17h4"/>',
}


def ico(name: str, size: int = 24, cls: str = "") -> str:
    return '<svg class="ico %s" width="%d" height="%d" viewBox="0 0 24 24">%s</svg>' % (cls, size, size, ICON[name])


# ---------------------------------------------------------------------------------------------------------------------
# What is carried over from the gym screen. Colours were sampled from ref/gym_screen.png (see notes.md); the wood is the
# game's own cut (assets/ui/wood), laid as the game lays it (WoodKit: 9 px corners, the bar's last 8 rows kept unscaled).
GYM_CSS = """
/* ---- the gym screen's top bar, rebuilt (scripts/ui/Shell.gd: 78 px, 18 px sides, 14 px gaps) ---- */
.top{position:absolute;left:0;top:0;width:1920px;height:78px;z-index:5;border-style:solid;border-width:0 0 8px 0;border-image:url(%(W)sbar.png) 0 0 8 0 fill / 0 0 8px 0 / 0 stretch;display:flex;align-items:center;gap:14px;padding:8px 18px 0 18px;color:#efe6d8;font-family:Barlow,"Segoe UI",sans-serif}
.tab9{border:9px solid transparent;border-image:url(%(W)stab.png) 9 fill / 9px / 0 stretch}
.plank9{border:9px solid transparent;border-image:url(%(W)splank.png) 9 fill / 9px / 0 stretch}
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
/* ---- the gym screen's pin, its name plate and its news strip (GymHub.gd, HomeCorners.gd) ---- */
.pin{width:56px;height:56px;border-radius:50%%;background:#1c2640;border:3px solid #fff;display:grid;place-items:center;color:#fff;box-shadow:0 3px 10px rgba(0,0,0,.45)}
.pin.red{background:#e2483d}
.pin .ico{stroke-width:2}
.plate{display:inline-flex;align-items:center;height:36px;padding:0 12px;border-radius:8px;background:#1d2741;color:#fff;font:700 22px/1 Barlow;white-space:nowrap}
.strip{display:flex;align-items:center;gap:12px;height:48px;padding:0 14px 0 10px;border-radius:8px;background:#252d45;color:#fff;font:700 21px/1 Barlow;white-space:nowrap}
.tag{display:inline-flex;align-items:center;height:32px;padding:0 10px;border-left:4px solid #275696;border-radius:3px;background:#1a2033;color:#8eb9f3;font:600 20px/1 Barlow;letter-spacing:.01em;text-transform:uppercase;white-space:nowrap}
.strip small{font:500 20px/1 Barlow;color:#b8c3de}
/* a button below the top bar: the gym screen's plank ("More below") */
.pbtn{height:56px;display:flex;align-items:center;justify-content:center;gap:10px;font:700 22px/1 Barlow;color:#efe6d8;white-space:nowrap;padding-bottom:2px}
""" % {"W": W}


def top_bar(need_line: str) -> str:
    return ('<div class="top"><span class="tnav tab9">&lt;</span><span class="tnav tab9 off">&gt;</span>'
            '<span class="tgym">Anvil Street Gym</span><span class="tdate"><b>Tue 27 Jan 2026</b><i>Week 4</i></span>'
            '<span class="trail"><span class="rail plank9">%s<u>Gym</u></span><span class="rail plank9">Mail (13 new)</span></span>'
            '<span class="tgrow"></span><span class="tcash"><b>$18,702</b><i>running -$607 a week</i></span>'
            '<span class="tgo plank9"><b>NEEDS YOU (1)</b><i>%s</i></span><span class="tnav tmenu tab9">Menu</span></div>'
            % (ico("bag", 24), need_line))


NEED = "Answer Samira's bout offer"
TABS_CSS = """.tabs{position:absolute;left:28px;top:92px;display:flex;gap:6px}
.tab{height:48px;padding:0 17px;border-radius:8px;display:flex;align-items:center;font-weight:700;color:#b8c3de;background:#1d2741;white-space:nowrap}
.tab.on{color:#fff;background:#275696;box-shadow:0 0 26px 2px rgba(255,205,90,.42)}"""


def must(s: str, old: str, new: str, count: int = 1) -> str:
    assert s.count(old) == count, (old[:70], s.count(old))
    return s.replace(old, new)


def must_re(s: str, pat: str, new: str) -> str:
    out, n = re.subn(pat, lambda m: new, s, flags=re.S)
    assert n == 1, (pat[:70], n)
    return out


# ---------------------------------------------------------------------------------------------------------------------
def overview() -> str:
    s = open("../../s430/overview_a.html", encoding="utf-8").read()
    s = must(s, "<title>Overview A - the body chart</title>", "<title>Fighter, Profile tab: the body chart (set x)</title>")
    s = must(s, "../../../assets/fonts/", A + "fonts/", 7)
    # (1) the top bar: a copy of the gym screen's
    s = must_re(s, r"/\* top bar: as the game draws it today.*?(?=/\* tabs: the chosen one glows)", GYM_CSS.strip() + "\n")
    s = must_re(s, r'<div class="top">.*?</div>(?=<div class="tabs">)', top_bar(NEED))
    # (4) the six tabs, as the gym's navy name plates; the chosen one keeps its glow
    s = must_re(s, r"\.tabs\{position:absolute.*?\.tab\.on\{[^}]*\}", TABS_CSS)
    s = must(s, '<span class="tab on">Overview</span><span class="tab">Training</span><span class="tab">Playbook</span><span class="tab">History</span>',
             '<span class="tab on">Profile</span><span class="tab">Condition</span><span class="tab">Training</span>'
             '<span class="tab">Playbook</span><span class="tab">Fight plan</span><span class="tab">History</span>')
    # (6) the next step sits on the gym's news strip with its blue tag; the gold button is untouched
    s = must_re(s, r"\.step\{position:absolute.*?\.step span\{[^}]*\}",
                ".step{position:absolute;left:820px;right:28px;top:88px;height:56px;display:flex;align-items:center;gap:14px;justify-content:flex-end}")
    s = must_re(s, r'<div class="step">.*?</div>(?=<div class="abs" style="left:28px;top:156px">)',
                '<div class="step"><span class="strip"><span class="tag">Next step</span>The nationals'
                '<small>entries close in 44 days</small></span><span class="go">Enter Lucy for the nationals</span></div>')
    # (5) the real 3D figure, on the gym's training floor (no wood below the top bar except planks)
    s = must_re(s, r'<div class="abs" style="left:806px;top:236px"><svg class="fig".*?</svg></div><div class="figtag"[^>]*>[^<]*</div>',
                '<div class="abs" style="left:868px;top:978px;width:270px;height:60px;background:radial-gradient(closest-side,rgba(0,0,0,.6),transparent)"></div>'
                '<img class="abs fig" src="figure.png" style="left:760px;top:236px;height:810px" alt="">')
    s = must_re(s, r"\.floor\{position:absolute.*?opacity:\.9\}",
                ".floor{position:absolute;left:700px;right:668px;bottom:0;height:176px;background:linear-gradient(#a8343b,#6e2328);clip-path:polygon(8% 0,92% 0,100% 100%,0 100%);opacity:.92}\n"
                ".floor::after{content:'';position:absolute;inset:0;background:repeating-linear-gradient(90deg,rgba(0,0,0,.16) 0 2px,transparent 2px 100px),linear-gradient(#4c4549,#2b2729 70%,#211e20);clip-path:polygon(10% 10px,90% 10px,97.8% 100%,2.2% 100%)}")
    s = must(s, ".fig{display:block;filter:drop-shadow(-3px 0 0 rgba(255,214,160,.20)) drop-shadow(0 0 34px rgba(255,170,80,.10))}",
             ".fig{display:block;filter:drop-shadow(0 0 30px rgba(255,170,80,.12)) drop-shadow(0 14px 10px rgba(0,0,0,.5))}\n"
             ".lead{z-index:2}.bpin{position:absolute;z-index:3;width:38px;height:38px;margin:-19px 0 0 -19px;border-width:2.5px}")
    # the leader lines end on the real body; each end is a small gym pin
    ends = [("M386 290 H700 L966 268", 966, 268, "brain"), ("M234 582 H720 L850 366", 850, 366, "sparring"),
            ("M1264 172 H1200 L1024 440", 1024, 440, "Defence"), ("M1264 306 H1180 L1030 528", 1030, 528, "fresh"),
            ("M1264 480 H1210 L1030 786", 1030, 786, "feet"), ("M1264 654 H1230 L1052 992", 1052, 992, "weight")]
    lead = '<svg class="lead" width="1920" height="1080">' + "".join(
        '<path d="%s" fill="none" stroke="rgba(241,232,218,.42)" stroke-width="2" stroke-dasharray="2 7" stroke-linecap="round"/>' % e[0] for e in ends) + "</svg>"
    lead += "".join('<span class="pin bpin" style="left:%dpx;top:%dpx">%s</span>' % (e[1], e[2], ico(e[3], 22)) for e in ends)
    s = must_re(s, r'<svg class="lead".*?</svg>', lead)
    # (2) Engine is Cardio
    s = must(s, "<h3>ENGINE<span>how long it lasts</span></h3>", "<h3>CARDIO<span>how long it lasts</span></h3>")
    assert "ngine" not in s
    # (3) On the scale: the tiredness meter beside the weight (bar to 100, the white tick at 80, the number, rest days)
    s = must_re(s, r'<div class="r strong"><svg class="ico "[^>]*><rect x="2" y="8" width="17" height="9" rx="2"/>.*?<span class="n">Freshness</span>.*?>Fresh</span></div>',
                '<div class="r strong">' + ico("tired") + '<span class="n">Tiredness</span><span class="bar"><b style="width:38%"></b><em style="left:80%"></em></span>'
                '<span class="v" style="grid-column:4/6;text-align:left;white-space:nowrap">38 <span class="cap">Fresh, no rest day</span></span></div>')
    # the guide: the game's own trainer in a gym pin, the bubble on the pin's navy; it now talks about this fighter
    s = must_re(s, r"\.gbub\{width:452px;[^}]*\}", ".gbub{width:452px;background:#1d2741;border-radius:14px;padding:14px 22px;box-shadow:0 6px 18px rgba(0,0,0,.45)}")
    s = must(s, ".gtail{width:24px;height:40px;margin-bottom:34px;background:#8a6a3d;clip-path:polygon(0 55%,100% 0,100% 100%)}",
             ".gtail{width:24px;height:40px;margin-bottom:34px;background:#1d2741;clip-path:polygon(0 55%,100% 0,100% 100%)}\n"
             ".gface img{display:block;width:176px;height:176px;margin:7px;border-radius:50%;border:4px solid #fff;box-shadow:0 4px 14px rgba(0,0,0,.5)}")
    s = must_re(s, r'<div class="gface"><svg.*?</svg></div>', '<div class="gface"><img src="face_trainer.png" alt=""></div>')
    s = must(s, "<p>Next job for the club: sign a second boxer.</p>", "<p>Lucy gives ground up close. Two sparring nights fix that.</p>")
    return s


# ---------------------------------------------------------------------------------------------------------------------
BAND = lambda v: "weak" if v < 45 else "fair" if v < 55 else "solid" if v < 65 else "strong" if v < 75 else "elite"


def stat(icon: str, name: str, v: int, ceil: int, gain: str = "") -> str:
    return ('<div class="r %s">%s<span class="n">%s</span><span class="bar"><b style="width:%d%%"></b><em style="left:%d%%"></em></span>'
            '<span class="rt"><span class="v">%d</span>%s</span></div>'
            % (BAND(v), ico(icon), name, v, ceil, v, '<span class="gain">%s</span>' % gain if gain else ""))


def meter(icon: str, name: str, cls: str, fill: int, tick, big: str, cap: str, cap_cls: str = "cap") -> str:
    em = '<em style="left:%d%%"></em>' % tick if tick is not None else ""
    return ('<div class="r %s">%s<span class="n">%s</span><span class="bar"><b style="width:%d%%"></b>%s</span>'
            '<span class="rt"><span class="v">%s</span><span class="%s">%s</span></span></div>' % (cls, ico(icon), name, fill, em, big, cap_cls, cap))


def tired(v: int) -> str:
    days, f = 0, float(v)
    while f >= 50.0:      # rules/Aftermath.rest_days: a full rest day leaves 87%
        f *= 0.87
        days += 1
    cls = "strong" if v < 50 else "fair" if v < 70 else "weak"
    cap = "fresh" if days == 0 else "%d rest day%s" % (days, "" if days == 1 else "s")
    return meter("tired", "Tiredness", cls, v, 80, str(v), cap, "cap" if days == 0 else "cap warn")


def weight(kg: float, limit: float) -> str:
    over = round(kg - limit, 1)
    fill = max(4, min(100, int(round(85 + (kg - limit) * 10))))
    if over > 0:
        return meter("weight", "Weight", "fair" if over < 1.0 else "weak", fill, 85, "%.1f" % kg, "%.1f kg over" % over, "cap warn")
    return meter("weight", "Weight", "strong", fill, 85, "%.1f" % kg, "of %.1f kg" % limit)


def mood(v: int) -> str:
    word = "Fired up" if v >= 75 else "Steady" if v >= 50 else "Flat" if v >= 30 else "Low"
    cls = "strong" if v >= 75 else "solid" if v >= 50 else "fair" if v >= 30 else "weak"
    return meter("mood", "Mood", cls, v, None, str(v), word)


FIGHTERS = [
    {"face": "lucy", "name": "Lucy Jackson", "sub": "Lightweight, 21, orthodox, amateur 3-2", "pin": "free", "red": False,
     "head": "IN THE RING", "style": "out-boxer",
     "stats": [("Strength", "Strength", 61, 84, ""), ("Speed", "Speed", 63, 84, "+0.2 a week"), ("Defence", "Defence", 57, 84, ""),
               ("Stamina", "Stamina", 58, 84, "+0.4 a week"), ("Durability", "Durability", 66, 84, "")],
     "today": [tired(38), weight(59.7, 60.0), mood(62)],
     "need": ("sparring", "Coach says: spar twice", "inside fighting 55, +0.6 a week"),
     "tag": "No bout", "next": "Nationals close in 44 days", "line": "5 bouts fought: Lucy can enter",
     "btn": ("pbtn plank9", "trophy", "Enter the nationals")},
    {"face": "samira", "name": "Samira Khan", "sub": "Welterweight, 18, orthodox, amateur 2-1", "pin": "offer", "red": True,
     "head": "IN THE RING", "style": "slugger",
     "stats": [("Strength", "Strength", 66, 82, "+0.3 a week"), ("Speed", "Speed", 57, 82, ""), ("Defence", "Defence", 50, 82, ""),
               ("Stamina", "Stamina", 60, 82, ""), ("Durability", "Durability", 63, 82, "")],
     "today": [tired(57), weight(65.9, 65.0), mood(78)],
     "need": ("guard", "Coach says: slip rope", "defence 50, +1.2 a week"),
     "tag": "Offer", "next": "Nia Okoro, Sat 7 Feb", "line": "win chance 47 to 58%, answer by Thursday",
     "btn": ("go", "offer", "Answer the offer")},
    {"face": "tess", "name": "Tess Reilly", "sub": "Middleweight, 23, southpaw, amateur 6-4", "pin": "booked", "red": False,
     "head": "IN THE RING", "style": "pressure fighter",
     "stats": [("Strength", "Strength", 62, 76, ""), ("Speed", "Speed", 55, 76, ""), ("Defence", "Defence", 58, 76, ""),
               ("Stamina", "Stamina", 64, 76, ""), ("Durability", "Durability", 67, 76, "")],
     "today": [tired(76), weight(75.4, 75.0), mood(55)],
     "need": ("rest", "Coach says: rest to Saturday", "4 rest days needed, 4 days left"),
     "tag": "In 4 days", "next": "Amy Croft, Sat 31 Jan", "line": "weigh-in Friday, 0.4 kg to lose",
     "btn": ("pbtn plank9", "rest", "Set the fight week")},
    {"face": "ana", "name": "Ana Ribeiro", "sub": "Featherweight no-gi, 22, white belt, opens 4-2", "pin": "free", "red": False,
     "head": "ON THE MAT", "style": "guard player",
     "stats": [("Strength", "Strength", 52, 80, ""), ("Stamina", "Stamina", 58, 80, ""), ("Flexibility", "Flexibility", 56, 80, ""),
               ("Explosive", "Explosive", 50, 80, ""), ("Composure", "Composure", 45, 80, "+0.5 a week")],
     "today": [tired(22), meter("belt", "Blue belt", "solid", 68, None, "41", "of 60 hours"), mood(68)],
     "need": ("mat", "Coach says: drill the armbar", "28 of 30, owned next week"),
     "tag": "In 12 days", "next": "London Open, Sun 8 Feb", "line": "not entered, 8 places in the bracket",
     "btn": ("pbtn plank9", "mat", "Enter the open")},
]

SQUAD_CSS = """
@font-face{font-family:Marker;src:url(%(A)sfonts/PermanentMarker-Regular.ttf)}
@font-face{font-family:Barlow;font-weight:400;src:url(%(A)sfonts/Barlow-Regular.ttf)}
@font-face{font-family:Barlow;font-weight:500;src:url(%(A)sfonts/Barlow-Medium.ttf)}
@font-face{font-family:Barlow;font-weight:600;src:url(%(A)sfonts/Barlow-SemiBold.ttf)}
@font-face{font-family:Barlow;font-weight:700;src:url(%(A)sfonts/Barlow-Bold.ttf)}
@font-face{font-family:Bebas;src:url(%(A)sfonts/BebasNeue-Regular.ttf)}
:root{--ink:#f1e8da;--soft:#c9b9a2;--gold:#ffd24a;--red:#dd4b3d;--blue:#4d8ef0;--green:#3fc07a;--amber:#f28d27;--purple:#ad80ff;
 --track:rgba(255,255,255,.10);--weak:#dd4b3d;--fair:#f28d27;--solid:#4d8ef0;--strong:#3fc07a;--elite:#ad80ff}
*{box-sizing:border-box;margin:0;padding:0}
html,body{width:1920px;height:1080px;overflow:hidden}
body{position:relative;background:#120e0c;color:var(--ink);font:500 22px/1.2 Barlow,"Segoe UI",sans-serif}
.ico{fill:none;stroke:currentColor;stroke-width:2;stroke-linecap:round;stroke-linejoin:round;flex:none}
/* the same dim wall and lamps as the fighter page */
.wall{position:absolute;left:0;right:0;top:78px;bottom:0;background:
 radial-gradient(ellipse 620px 430px at 13%% 22%%,rgba(255,190,110,.10),transparent 72%%),
 radial-gradient(ellipse 620px 430px at 38%% 22%%,rgba(255,190,110,.10),transparent 72%%),
 radial-gradient(ellipse 620px 430px at 62%% 22%%,rgba(255,190,110,.10),transparent 72%%),
 radial-gradient(ellipse 620px 430px at 87%% 22%%,rgba(255,190,110,.10),transparent 72%%),
 linear-gradient(#1b1512,#130f0d 62%%,#0e0b09)}
%(GYM)s
%(TABS)s
.tabs{left:262px}
.title{position:absolute;left:28px;top:92px;height:48px;display:flex;align-items:center;font:400 44px/1 Marker;color:#fff;white-space:nowrap}
.news{position:absolute;right:28px;top:92px}
/* the same meters as the fighter page */
.go{display:flex;align-items:center;justify-content:center;gap:10px;height:56px;padding:0 24px;border-radius:11px;background:linear-gradient(#ffe070,#f0b32a);color:#2a1b06;font-weight:700;font-size:23px;box-shadow:0 3px 0 #9a6c10,0 0 26px 2px rgba(255,205,90,.30);white-space:nowrap}
.bar{position:relative;height:16px;border-radius:8px;background:var(--track)}
.bar b{position:absolute;left:0;top:0;bottom:0;border-radius:8px;background:var(--c)}
.bar em{position:absolute;top:-5px;width:3px;height:26px;border-radius:2px;background:#fff}
.weak{--c:var(--weak)}.fair{--c:var(--fair)}.solid{--c:var(--solid)}.strong{--c:var(--strong)}.elite{--c:var(--elite)}
.v{font-weight:700;font-size:28px;text-align:right;min-width:36px;color:color-mix(in srgb,var(--c) 78%%,#fff)}
.gain{color:var(--green);font-weight:600;font-size:20px;white-space:nowrap}
.cap{color:var(--soft);font-size:20px;white-space:nowrap}
.cap.warn{color:color-mix(in srgb,var(--c) 70%%,#fff);font-weight:600}
.key{position:absolute;left:0;right:0;top:1040px;display:flex;justify-content:center;align-items:center;gap:8px;font-size:20px;color:var(--soft);white-space:nowrap}
.key s{width:14px;height:14px;border-radius:4px;display:inline-block;margin-left:12px}
.key em{display:inline-block;width:3px;height:20px;background:#fff;border-radius:2px}
.key i{display:inline-block;width:18px;height:18px;border-radius:50%%;background:#e2483d;border:2px solid #fff;margin-left:34px}
/* one fighter: a big gym pin with the face, the name on the pin's plate */
.col{position:absolute;top:158px;width:448px}
.rule{position:absolute;top:170px;height:850px;width:0;border-left:2px dotted rgba(241,232,218,.20)}
.who{position:relative;height:262px;text-align:center}
.face{width:180px;height:180px;margin:0 auto;border-radius:50%%;border:4px solid #fff;overflow:hidden;box-shadow:0 6px 18px rgba(0,0,0,.5);background:#1c2640}
.face img{display:block;width:172px;height:172px}
.who .pin{position:absolute;left:266px;top:126px}
.who .plate{position:absolute;left:50%%;top:186px;transform:translateX(-50%%);height:40px;font-size:26px;padding:0 16px}
.who .sub{position:absolute;left:0;right:0;top:234px;font-size:20px;color:var(--soft);white-space:nowrap}
.col h3{height:34px;display:flex;align-items:baseline;gap:12px;font-weight:700;font-size:22px;letter-spacing:.09em;color:var(--gold);padding-top:2px}
.col h3 span{font-weight:500;font-size:20px;letter-spacing:0;color:var(--soft)}
.r{display:grid;grid-template-columns:26px 114px 1fr 162px;column-gap:8px;align-items:center;height:38px}
.r .ico{color:var(--soft)}.r .n{font-weight:600;white-space:nowrap}
.rt{display:flex;align-items:baseline;gap:8px;white-space:nowrap}
.sec2{margin-top:6px}
.need{display:flex;align-items:center;gap:12px;height:56px;margin-top:10px}
.need .pin{width:50px;height:50px;flex:none}
.need b{display:block;font-size:22px;font-weight:700;white-space:nowrap}.need i{display:block;font-style:normal;font-size:20px;color:var(--soft);white-space:nowrap}
.col .strip{margin-top:10px}
.line{height:30px;display:flex;align-items:center;font-size:20px;color:var(--soft);white-space:nowrap;padding-left:2px}
.col .pbtn,.col .go{margin-top:8px}
.col .go .ico,.col .pbtn .ico{flex:none}
""" % {"A": A, "GYM": GYM_CSS, "TABS": TABS_CSS}


def column(i: int, f: dict) -> str:
    x = 28 + i * 472
    h = '<div class="col" style="left:%dpx">' % x
    h += ('<div class="who"><div class="face"><img src="face_%s.png" alt=""></div><span class="pin%s">%s</span>'
          '<span class="plate">%s</span><div class="sub">%s</div></div>'
          % (f["face"], " red" if f["red"] else "", ico(f["pin"], 34), f["name"], f["sub"]))
    h += "<h3>%s<span>%s</span></h3>" % (f["head"], f["style"])
    h += "".join(stat(*s) for s in f["stats"])
    h += '<h3 class="sec2">TODAY</h3>'
    h += "".join(f["today"])
    n = f["need"]
    h += '<div class="need"><span class="pin">%s</span><div><b>%s</b><i>%s</i></div></div>' % (ico(n[0], 28), n[1], n[2])
    h += '<div class="strip"><span class="tag">%s</span>%s</div>' % (f["tag"], f["next"])
    h += '<div class="line">%s</div>' % f["line"]
    b = f["btn"]
    h += '<span class="%s">%s %s</span>' % (b[0], ico(b[1], 26), b[2])
    return h + "</div>"


def squad() -> str:
    body = '<div class="wall"></div>' + top_bar(NEED)
    body += '<div class="title">Fighters</div>'
    body += '<div class="tabs"><span class="tab on">All four</span><span class="tab">Compare two</span><span class="tab">Find a fighter</span></div>'
    body += ('<div class="news"><span class="strip"><span class="tag">Show in 11 days</span>'
             'The show on Sat 7 Feb has offered Samira a bout against Nia Okoro.</span></div>')
    body += "".join('<div class="rule" style="left:%dpx"></div>' % (488 + k * 472) for k in range(3))
    body += "".join(column(i, f) for i, f in enumerate(FIGHTERS))
    body += ('<div class="key"><em></em>&nbsp;the ceiling, the weight limit, too tired at 80&nbsp;&nbsp;<s style="background:var(--weak)"></s>Weak<s style="background:var(--fair)"></s>Fair'
             '<s style="background:var(--solid)"></s>Solid<s style="background:var(--strong)"></s>Strong<s style="background:var(--elite)"></s>Elite'
             '<i></i>&nbsp;needs you</div>')
    return ('<!doctype html>\n<html lang="en"><head><meta charset="utf-8"><title>Fighters: all four (set x)</title>\n<style>%s</style></head>\n<body>%s</body></html>\n'
            % (SQUAD_CSS, body))


if __name__ == "__main__":
    open("overview.html", "w", encoding="utf-8").write(overview())
    open("squad.html", "w", encoding="utf-8").write(squad())
    print("wrote overview.html, squad.html")
