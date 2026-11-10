cols = 257
x0 = 60
days = [("Mon", "Run", "Pads", 3, 2, "g"), ("Tue", "Sprint", "Spar", 2, 3, "g"), ("Wed", "Run", "Pads", 2, 3, "r"),
        ("Thu", "Rest", "Film", 0, 0, "g"), ("Fri", "Bag", "Rest", 1, 0, "g"), ("Sat", "Rest", "Rest", 0, 0, "g"),
        ("Sun", "Rest", "FIGHT", 0, 0, "f")]
vals = [(30, 42), (52, 60), (70, 82), (66, 58), (50, 44), (36, 30), (26, 34)]


def y(v):
    return 548 - v * 1.2


pts = []
for i, (a, b) in enumerate(vals):
    cx = x0 + cols * i + cols / 2
    pts += [(cx - 55, y(a)), (cx + 55, y(b))]
poly = " ".join("%d,%d" % (px, py) for px, py in pts)
area = "%d,548 " % pts[0][0] + poly + " %d,548" % pts[-1][0]
cc = {"Run": "#3fa86b", "Sprint": "#3fa86b", "Bag": "#d4503f", "Rest": "#4b8fd0", "Pads": "#e9a935", "Spar": "#d4503f",
      "Film": "#8a6cc9", "FIGHT": "#d4503f"}


def badge(w):
    return '<div class="bd" style="background:%s"><b></b></div><div class="bw">%s</div>' % (cc[w], w)


def pipset(n):
    if not n:
        return '<i class="x"></i>'
    return "".join('<i class="%s"></i>' % ("on" if k < n else "") for k in range(3))


tiles = ""
for i, (d, am, pm, pa, pp, s) in enumerate(days):
    cls = "tile" + (" sel" if s == "r" else "") + (" fight" if s == "f" else "")
    tiles += ('<div class="%s" style="left:%dpx"><div class="dn">%s</div><div class="hv"><div class="half">%s<div class="pips">%s</div></div>'
              '<div class="half">%s<div class="pips p2">%s</div></div></div></div>') % (
        cls, x0 + cols * i + 8, d, badge(am), pipset(pa), badge(pm), pipset(pp))

cards = [("Jab Cross Hook", "Raw", 24, "#d4503f", 35, "+1.2"), ("Slip Counter", "Usable", 41, "#e9a935", 25, "+0.9"),
         ("Body Hook", "Usable", 58, "#2fb3b0", 15, "+0.5")]
ch = ""
for i, (n, t, m, c, mn, g) in enumerate(cards):
    ch += ('<div class="card" style="left:%dpx;border-color:%s"><div class="ct" style="background:%s">%s</div><div class="tier">%s %d</div>'
           '<div class="mb"><div class="mf" style="width:%d%%;background:%s"></div><u style="left:30%%"></u><u style="left:60%%"></u>'
           '<span class="wp" style="left:30%%">Weapon</span></div><div class="gain">%s</div>'
           '<div class="step"><button>-</button><span>%d min</span><button>+</button></div></div>') % (
        i * 392, c, c, n, t, m, m, c, g, mn)
hand = [("Uppercut", "Raw 12"), ("Double Jab", "Usable 33"), ("Check Hook", "Raw 18"), ("Pivot Out", "Sharp 62")]
hh = "".join('<div class="hc" style="left:%dpx;transform:rotate(%ddeg)"><b>%s</b><span>%s</span><i>+</i></div>' % (
    k * 292, r, a, b) for k, ((a, b), r) in enumerate(zip(hand, [-2, -1, 1, 2])))


def lv(name, left, g, t, on):
    def m(cls, n):
        return '<div class="m %s">%s</div>' % (cls, "".join(
            '<i class="%s" style="height:%dpx"></i>' % ("on" if k < n else "", 12 + 14 * k) for k in range(3)))
    return '<div class="lv%s" style="left:%dpx"><h4>%s</h4><div class="ml">Gain</div>%s<div class="ml">Tired</div>%s</div>' % (
        " on" if on else "", left, name, m("g", g), m("t", t))


css = """
*{box-sizing:border-box;margin:0;padding:0}
body{width:1920px;height:1080px;overflow:hidden;background:#0d0b0a;color:#f3efe4;font-family:"Bahnschrift","Segoe UI",Arial,sans-serif;position:relative;background-image:radial-gradient(ellipse at 20% 0,#3a2a1c,transparent 40%)}
.a{position:absolute}
.wood{background:linear-gradient(180deg,#7a5230,#4c2f1a 60%,#3c2514);box-shadow:inset 0 2px 0 #9a6d42,0 4px 10px #000a}
.board{position:absolute;border:12px solid #5b3a20;border-radius:6px;background:linear-gradient(#212325,#151617);box-shadow:0 0 0 2px #1d1008,inset 0 0 0 2px #8a5f36,inset 0 0 40px #000c}
.nt{position:absolute;top:12px;height:44px;border-radius:5px;font-size:26px;display:flex;align-items:center;padding:0 24px;background:#3b2616;border:2px solid #20120a}
.nt.on{background:linear-gradient(#a26d3a,#6b4527);box-shadow:inset 0 0 0 2px #f0bd4f}
.tile{position:absolute;top:238px;width:241px;height:178px;border-radius:8px;background:linear-gradient(#2c2f32,#1f2123);border:3px solid #3d4146;text-align:center}
.tile.sel{border-color:#f0bd4f;box-shadow:0 0 24px #f0bd4f66}
.tile.fight{border-color:#e0493b;background:linear-gradient(#5a1c18,#2c1210)}
.dn{font-size:28px;font-weight:700;line-height:36px}
.hv{display:flex;height:128px}.half{flex:1;display:flex;flex-direction:column;align-items:center;gap:2px}.half+.half{border-left:2px dashed #ffffff24}
.bd{width:54px;height:54px;border-radius:50%;border:3px solid #0008;margin-top:6px;display:flex;align-items:center;justify-content:center;box-shadow:inset 0 3px 0 #fff4}
.bd b{width:22px;height:22px;border-radius:5px;background:#fff9;display:block}
.bw{font-size:22px;font-weight:700;line-height:26px}
.pips{display:flex;gap:6px;margin-top:4px}.pips i{width:16px;height:16px;border-radius:50%;background:#ffffff26;border:2px solid #0008}.pips i.on{background:#f0bd4f}.pips i.x{opacity:0}
.pips.p2 i.on{background:#7fd0e8}
.card{position:absolute;top:44px;width:378px;height:206px;border:4px solid;border-radius:8px;background:#202224}
.ct{height:48px;font-size:28px;font-weight:700;color:#1a0f08;padding:8px 14px}
.tier{font-size:24px;font-weight:700;padding:10px 14px 0}
.mb{position:relative;margin:34px 14px 0;height:20px;border-radius:10px;background:#0b0c0d;border:2px solid #444}
.mf{height:100%;border-radius:8px}.mb u{position:absolute;top:-6px;width:3px;height:28px;background:#fff9}
.wp{position:absolute;top:-30px;font-size:20px;transform:translateX(-50%);color:#ddd}
.gain{position:absolute;right:16px;top:58px;font-size:30px;font-weight:700;color:#8fe3a2}
.step{position:absolute;left:0;right:0;bottom:8px;display:flex;align-items:center;justify-content:center;gap:20px;font-size:34px;font-weight:700}
.step button{width:64px;height:48px;font-size:36px;font-weight:700;border-radius:6px;border:2px solid #20120a;background:linear-gradient(#7a5230,#4c2f1a);color:#fff}
.hc{position:absolute;top:266px;width:276px;height:66px;background:#efe6cf;color:#2a1b0a;border-radius:6px;padding:6px 14px;box-shadow:0 3px 6px #000a}
.hc b{font-size:26px;display:block;line-height:28px}.hc span{font-size:22px}.hc i{position:absolute;right:12px;top:8px;font-style:normal;font-size:32px;font-weight:700;color:#a0701d}
.lv{position:absolute;top:0;width:170px;height:226px;border-radius:8px;background:linear-gradient(#2c2f32,#1f2123);border:3px solid #3d4146;text-align:center}
.lv.on{border-color:#f0bd4f;background:linear-gradient(#41381f,#2a2517);box-shadow:0 0 20px #f0bd4f66}
.lv h4{font-size:30px;line-height:40px}
.m{display:flex;gap:6px;justify-content:center;align-items:flex-end;height:50px;margin:0 0 8px}.m i{width:30px;border-radius:4px;background:#ffffff1f;display:block}
.g i.on{background:#4fd07a}.t i.on{background:#e0493b}
.ml{font-size:22px;line-height:26px}
.pill{position:absolute;top:106px;height:88px;border-radius:12px;background:#0008;text-align:center}
.pill .l{font-size:24px;margin-top:6px;font-weight:700}
"""
body = f"""
<div class="a wood" style="left:0;top:0;width:1920px;height:68px"></div>
<div class="a" style="left:30px;top:14px;width:42px;height:42px;border-radius:50%;background:#c58b5a;border:3px solid #f0bd4f"></div>
<div class="a" style="left:88px;top:14px;font-size:34px;font-weight:700">Lucy Jackson</div>
<div class="nt" style="left:520px">Overview</div><div class="nt on" style="left:690px">Training</div><div class="nt" style="left:850px">Playbook</div><div class="nt" style="left:1020px">History</div>
<div class="a" style="right:36px;top:12px;font-size:40px;font-weight:700;color:#f0bd4f">$16,841</div>

<div class="board" style="left:30px;top:84px;width:1860px;height:132px"></div>
<div class="a" style="left:60px;top:100px;width:100px;height:100px;border-radius:50%;background:#9a9d9f;border:4px solid #f0bd4f"></div>
<div class="a" style="left:176px;top:98px;font-size:44px;font-weight:700;color:#ff8d80">Wed is too tired</div>
<div class="a" style="left:176px;top:152px;font-size:28px">Swap Wed pads for rest</div>
<div class="pill" style="left:700px;width:220px;border:3px solid #c9342a"><div class="l" style="color:#ff8d80">Tired</div><div style="margin:8px 14px;height:22px;border-radius:11px;background:linear-gradient(90deg,#3fa86b,#e9a935,#d4503f);position:relative"><span style="position:absolute;left:82%;top:-8px;width:8px;height:38px;background:#fff;border-radius:3px"></span></div></div>
<div class="pill" style="left:940px;width:200px;border:3px solid #3d8d52"><div class="l" style="color:#8fe3a2">Weight</div><div style="font-size:34px;font-weight:700">OK</div></div>
<div class="pill" style="left:1160px;width:200px;border:3px solid #3d8d52"><div class="l" style="color:#8fe3a2">Gains</div><div style="font-size:34px;font-weight:700">+0.5</div></div>
<div class="pill" style="left:1380px;width:230px;border:3px solid #f0bd4f"><div class="l" style="color:#f0bd4f">Fight in</div><div style="font-size:36px;font-weight:700">4 weeks</div></div>
<div class="a" style="left:1650px;top:112px;width:210px;height:78px;border-radius:8px;background:linear-gradient(#58c26f,#2c8a46);border:3px solid #123;font-size:36px;font-weight:700;display:flex;align-items:center;justify-content:center;color:#fff;box-shadow:0 0 24px #4fd07a88">Fix it</div>

<div class="board" style="left:30px;top:226px;width:1860px;height:346px"></div>
{tiles}
<svg class="a" style="left:0;top:0" width="1920" height="1080">
<defs><linearGradient id="ar" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#e9a935" stop-opacity=".85"/><stop offset="1" stop-color="#3fa86b" stop-opacity=".6"/></linearGradient></defs>
<rect x="60" y="424" width="1800" height="25" fill="#d4503f" opacity=".35"/>
<line x1="60" y1="449" x2="1860" y2="449" stroke="#ff6a5a" stroke-width="3" stroke-dasharray="14 8"/>
<polygon points="{area}" fill="url(#ar)" opacity=".7"/>
<polyline points="{poly}" fill="none" stroke="#fff3c4" stroke-width="5"/>
<circle cx="{pts[5][0]}" cy="{pts[5][1]}" r="11" fill="#d4503f" stroke="#fff" stroke-width="4"/>
<rect x="{pts[5][0]-34}" y="{pts[5][1]-54}" width="68" height="38" rx="8" fill="#a32a20"/>
<text x="{pts[5][0]}" y="{pts[5][1]-26}" font-size="30" font-weight="700" fill="#fff" text-anchor="middle" font-family="Bahnschrift,Segoe UI">82</text>
<text x="1840" y="442" font-size="24" font-weight="700" fill="#ff8d80" text-anchor="end" font-family="Bahnschrift,Segoe UI">Too tired</text>
</svg>

<div class="board" style="left:30px;top:588px;width:610px;height:410px"></div>
<div class="a" style="left:62px;top:602px;font-size:38px;font-weight:700;color:#f0bd4f">Wed morning: Run</div>
<div class="a" style="left:62px;top:662px;width:560px;height:240px">{lv("Light",0,1,1,False)}{lv("Normal",178,2,2,True)}{lv("Hard",356,3,3,False)}</div>
<div class="a" style="left:62px;top:900px;font-size:30px;font-weight:700">Stamina 64 → 66</div>
<div class="a" style="left:62px;top:944px;width:546px;height:22px;border-radius:11px;background:#0b0c0d;border:2px solid #444"><div style="width:60%;height:100%;border-radius:9px;background:linear-gradient(90deg,#3fa86b,#8fe3a2)"></div></div>

<div class="board" style="left:660px;top:588px;width:1230px;height:410px"></div>
<div class="a" style="left:692px;top:602px;font-size:38px;font-weight:700;color:#f0bd4f">Wed night: Pads</div>
<div class="a" style="left:1060px;top:606px;font-size:34px;font-weight:700">75 min</div>
<div class="nt on" style="left:1250px;top:604px">Pads</div><div class="nt" style="left:1370px;top:604px">Spar</div><div class="nt" style="left:1490px;top:604px">Film</div><div class="nt" style="left:1600px;top:604px">Rest</div>
<div class="a" style="left:692px;top:660px;width:1170px;height:34px;display:flex;border-radius:6px;overflow:hidden;font-size:24px;font-weight:700;color:#1a0f08"><div style="width:47%;background:#d4503f;padding:2px 14px">35</div><div style="width:33%;background:#e9a935;padding:2px 14px">25</div><div style="width:20%;background:#2fb3b0;padding:2px 14px">15</div></div>
<div class="a" style="left:692px;top:664px;width:1170px;height:330px">{ch}{hh}</div>

<div class="a wood" style="left:30px;top:1008px;width:1860px;height:64px;border-radius:8px"></div>
<div class="a" style="left:60px;top:1020px;font-size:30px;font-weight:700">Sun 60.9 of 61 kg</div>
<div class="a" style="left:420px;top:1018px;width:120px;height:44px;border-radius:6px;background:linear-gradient(#f7cf6a,#c2902c);color:#2a1b06;font-size:28px;font-weight:700;display:flex;align-items:center;justify-content:center">Hold</div>
<div class="a" style="left:556px;top:1018px;width:120px;height:44px;border-radius:6px;background:#2c2f32;border:2px solid #555;font-size:28px;font-weight:700;display:flex;align-items:center;justify-content:center">Cut</div>
<div class="a" style="left:1500px;top:1014px;width:370px;height:52px;border-radius:8px;background:linear-gradient(#e0493b,#a32a20);font-size:38px;font-weight:700;display:flex;align-items:center;justify-content:center;border:2px solid #20120a">Start week &#9654;</div>
"""
html = '<!doctype html><html><head><meta charset="utf-8"><title>Training new player 10</title><style>%s</style></head><body>%s</body></html>' % (css, body)
open("E:/FightCamp/Lean/docs/mockups/s419/training_b_critic_newplayer.html", "w", encoding="utf-8").write(html)
