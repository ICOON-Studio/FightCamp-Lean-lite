# Builds overview_10.html (the owner stand-in's 10/10 of the fighter Overview). Run: python build.py
import pathlib

A = "../../../../assets"


def ico(d, s=24):
    return f'<svg class="ico" width="{s}" height="{s}" viewBox="0 0 24 24">{d}</svg>'


I = {
    "brain": '<path d="M9 3a3 3 0 0 0-3 3 3 3 0 0 0-2 5 3 3 0 0 0 2 5 3 3 0 0 0 6 2V5a2 2 0 0 0-3-2zM15 3a3 3 0 0 1 3 3 3 3 0 0 1 2 5 3 3 0 0 1-2 5 3 3 0 0 1-6 2"/>',
    "glove": '<path d="M6 11V8a5 5 0 0 1 5-5h3a5 5 0 0 1 5 5v5a5 5 0 0 1-5 5H9a3 3 0 0 1-3-3zM6 11H5a2 2 0 0 0 0 5h1M8 21h9M11 8h4"/>',
    "guard": '<path d="M12 3l8 3v6c0 5-3.5 8-8 9-4.5-1-8-4-8-9V6z"/><path d="M12 3v18"/>',
    "shield": '<path d="M12 3l8 3v6c0 5-3.5 8-8 9-4.5-1-8-4-8-9V6z"/>',
    "pulse": '<path d="M2 12h5l2-6 4 12 2-6h7"/>',
    "feet": '<ellipse cx="8" cy="8" rx="3" ry="5"/><ellipse cx="16" cy="15" rx="3" ry="5"/>',
    "scale": '<rect x="3" y="4" width="18" height="16" rx="3"/><path d="M8 9a5 5 0 0 1 8 0M12 9l2-2"/>',
    "bulb": '<path d="M9 18h6M10 21h4M12 3a6 6 0 0 0-4 10.5V15h8v-1.5A6 6 0 0 0 12 3z"/>',
    "waves": '<path d="M3 9c3-3 6 3 9 0s6 3 9 0M3 15c3-3 6 3 9 0s6 3 9 0"/>',
    "list": '<path d="M4 6l1.5 1.5L8 5M4 12l1.5 1.5L8 11M4 18l1.5 1.5L8 17M11 6h9M11 12h9M11 18h9"/>',
    "trend": '<path d="M3 17l6-6 4 4 8-8M15 7h6v6"/>',
    "talk": '<path d="M4 5h16v10H10l-5 4v-4H4z"/>',
    "flame": '<path d="M12 3c1 4 5 5 5 10a5 5 0 0 1-10 0c0-2 1-3 2-4 0 2 1 3 2 3 0-3-1-5 1-9z"/>',
    "target": '<circle cx="12" cy="12" r="9"/><circle cx="12" cy="12" r="4.5"/><circle cx="12" cy="12" r=".6"/>',
    "clock": '<circle cx="12" cy="12" r="9"/><path d="M12 7v5l3.5 2"/>',
    "inside": '<path d="M2 12h7M6 8l4 4-4 4M22 12h-7M18 8l-4 4 4 4"/>',
    "bell": '<path d="M4 9v6M7 6v12M17 6v12M20 9v6M7 12h10"/>',
    "bolt": '<path d="M13 2 4 14h7l-1 8 9-12h-7z"/>',
    "redo": '<path d="M20 11a8 8 0 1 0-2.3 5.7M20 5v6h-6"/>',
    "heart": '<path d="M12 20s-7-4.5-7-10a4 4 0 0 1 7-2.5A4 4 0 0 1 19 10c0 5.5-7 10-7 10z"/>',
    "fast": '<path d="M4 6l6 6-6 6M12 6l6 6-6 6"/>',
    "bend": '<path d="M5 19c0-9 5-14 14-14M13 5h6v6"/>',
    "batt": '<rect x="2" y="8" width="17" height="9" rx="2"/><path d="M22 11v3M6 11v3M10 11v3"/>',
    "smile": '<circle cx="12" cy="12" r="9"/><path d="M8.5 14.5a4.5 4.5 0 0 0 7 0M9 9.5v.5M15 9.5v.5"/>',
    "cal": '<rect x="3" y="5" width="18" height="16" rx="2"/><path d="M3 10h18M8 3v4M16 3v4M8 14h2M14 14h2"/>',
    "route": '<path d="M4 19c4 0 4-12 9-12h5M15 3l4 4-4 4"/><circle cx="5" cy="6" r="2"/>',
    "two": '<circle cx="8" cy="8" r="3.5"/><circle cx="17" cy="9" r="2.8"/><path d="M2 20c0-3.5 2.7-6 6-6s6 2.5 6 6M15 14.5c3 0 5.5 2 5.5 5"/>',
    "bag": '<path d="M12 2v3M8 5h8v14a4 4 0 0 1-8 0zM8 10h8"/>',
}


def row(cls, icon, name, val, ceil=True, goal=None, right="", sel=False):
    em = '<em style="left:84%"></em>' if ceil else ""
    u = f'<u style="left:{goal}%"></u>' if goal else ""
    s = " sel" if sel else ""
    return (f'<div class="r {cls}{s}">{ico(I[icon])}<span class="n">{name}</span>'
            f'<span class="bar"><b style="width:{val}%"></b>{em}{u}</span><span class="v">{val}</span><span>{right}</span></div>')


def gain(t):
    return f'<span class="gain">{t} a week</span>'


def cap(t):
    return f'<span class="cap">{t}</span>'


def pill(t, hot=False):
    h = " hot" if hot else ""
    return f'<span class="pill{h}">+ {t}</span>'


def head(icon, title, sub):
    return f'<h3><span class="pin hpin">{ico(I[icon], 18)}</span>{title}<span>{sub}</span></h3>'


def bpin(icon, x, y):
    return f'<span class="pin bpin" style="left:{x}px;top:{y}px">{ico(I[icon], 22)}</span>'


def lead(d):
    return f'<path d="{d}" fill="none" stroke="rgba(241,232,218,.45)" stroke-width="2" stroke-dasharray="2 7" stroke-linecap="round"/>'


def act(icon, label, small=""):
    sm = f"<small>{small}</small>" if small else ""
    return f'<span class="act"><span class="pin">{ico(I[icon], 28)}</span><b>{label}</b>{sm}</span>'


def face(src, name, on=False):
    o = " on" if on else ""
    return f'<span class="sq{o}"><img src="{src}" alt=""><i>{name}</i></span>'


def day(cls, icon, name, w, tick, val, rest, tired=False):
    t = " tired" if tired else ""
    em = f'<em style="left:{tick}%"></em>' if tick else ""
    return (f'<div class="r day {cls}">{ico(I[icon])}<span class="n">{name}</span><span class="bar{t}"><b style="width:{w}%"></b>{em}</span>'
            f'<span class="v">{val}{rest}</span></div>')


CSS = pathlib.Path(__file__).with_name("style.css").read_text(encoding="utf-8").replace("@A@", A)

top = (f'<div class="top"><span class="tnav tab9">&lt;</span><span class="tnav tab9 off">&gt;</span><span class="tgym">Anvil Street Gym</span>'
       f'<span class="tdate"><b>Mon 12 Jan 2026</b><i>Week 2</i></span><span class="trail"><span class="rail plank9">{ico(I["bag"])}<u>Gym</u></span>'
       f'<span class="rail plank9">Mail (5 new)</span></span><span class="tgrow"></span><span class="tcash"><b>$16,841</b><i>running -$680 a week</i></span>'
       f'<span class="tgo plank9"><b>NEEDS YOU (1)</b><i>Answer Lucy&#39;s bout offer</i></span><span class="tnav tmenu tab9">Menu</span></div>')
names = ["Profile", "Condition", "Training", "Playbook", "Fight plan", "History"]
tabs = '<div class="tabs">' + "".join(f'<span class="tab{" on" if i == 0 else ""}">{t}</span>' for i, t in enumerate(names)) + "</div>"
step = ('<div class="step"><span class="strip"><span class="tag">Show in 19 days</span>Bout offer: Maria Ortega<small>Sat 31 Jan, answer by Thursday</small></span>'
        '<span class="go">Answer the bout offer</span></div>')
header = ('<div class="abs" style="left:28px;top:148px"><div class="name">LUCY JACKSON</div>'
          '<div class="sub"><span class="plate">Lightweight</span>21, orthodox, out-boxer</div>'
          '<div class="sub" style="margin-top:6px"><b>3-1</b>amateur<em>1 win from the ranking table</em></div></div>'
          '<div class="abs ring" style="left:540px;top:152px;width:112px;height:112px"><div><b>59</b><i>of 100</i></div></div>')
squad = ('<div class="squad">' + face("face_lucy.png", "Lucy", True) + face("face_samira.png", "Samira") + face("face_tess.png", "Tess")
         + face("face_ana.png", "Ana") + "</div>")
FX, FY, FH = 764, 250, 796   # the figure picture (452 x 924) drawn 796 high, feet on the mat
fig = ('<div class="abs" style="left:870px;top:980px;width:270px;height:60px;background:radial-gradient(closest-side,rgba(0,0,0,.6),transparent)"></div>'
       f'<img class="abs fig" src="figure.png" style="left:{FX}px;top:{FY}px;height:{FH}px" alt="">')
P = {"head": (966, 281), "hands": (852, 378), "guard": (1023, 450), "cardio": (1029, 537), "legs": (1029, 790), "today": (1051, 993)}
HEAD_Y, HANDS_Y = 294, 582
R = {"guard": 150, "cardio": 284, "legs": 458, "today": 632}
leads = '<svg class="lead" width="1920" height="1080">' + "".join([
    lead(f'M446 {HEAD_Y + 20} H700 L{P["head"][0]} {P["head"][1]}'),
    lead(f'M282 {HANDS_Y + 20} H720 L{P["hands"][0]} {P["hands"][1]}'),
    lead(f'M1258 {R["guard"] + 20} H1196 L{P["guard"][0]} {P["guard"][1]}'),
    lead(f'M1258 {R["cardio"] + 20} H1176 L{P["cardio"][0]} {P["cardio"][1]}'),
    lead(f'M1258 {R["legs"] + 20} H1206 L{P["legs"][0]} {P["legs"][1]}'),
    lead(f'M1258 {R["today"] + 20} H1228 L{P["today"][0]} {P["today"][1]}'),
]) + "</svg>"
pins = (bpin("brain", *P["head"]) + bpin("glove", *P["hands"]) + bpin("guard", *P["guard"]) + bpin("pulse", *P["cardio"])
        + bpin("feet", *P["legs"]) + bpin("scale", *P["today"]))
left = (f'<div class="cl" style="left:28px;top:{HEAD_Y}px">' + head("brain", "HEAD", "reads the fight, keeps the plan")
        + row("solid", "bulb", "Fight IQ", 61)
        + row("solid", "waves", "Composure", 56, right=pill("Sparring"))
        + row("strong char", "list", "Discipline", 69, ceil=False, right=cap("holds the plan"))
        + row("fair char", "trend", "Confidence", 51, ceil=False, right=cap("swings by round"))
        + row("fair char", "talk", "Coachability", 45, ceil=False, right=cap("shouts land less"))
        + f'<div class="r weak char">{ico(I["flame"])}<span class="n">Temper</span><span class="word" style="grid-column:3/5">Trades</span>{cap("when hit")}</div></div>'
        + f'<div class="cl" style="left:28px;top:{HANDS_Y}px">' + head("glove", "HANDS", "what lands")
        + row("solid", "target", "Accuracy", 59, right=gain("+0.3"))
        + row("solid", "clock", "Timing", 61)
        + row("solid", "inside", "Inside fighting", 55, right=pill("Sparring"), sel=True)
        + row("solid", "bell", "Strength", 60, right=gain("+0.1"))
        + row("solid", "bolt", "Explosiveness", 57) + "</div>"
        + '<div class="abs key" style="left:28px;top:836px"><em></em>&nbsp;ceiling 84<u></u>&nbsp;goal<i></i>&nbsp;cannot be trained'
          '<s style="background:var(--weak);margin-left:22px"></s>Weak<s style="background:var(--fair)"></s>Fair<s style="background:var(--solid)"></s>Solid'
          '<s style="background:var(--strong)"></s>Strong<s style="background:var(--elite)"></s>Elite</div>')
right = (f'<div class="cl" style="left:1268px;top:{R["guard"]}px">' + head("guard", "GUARD", "what gets through")
         + row("solid", "guard", "Defence", 57, right=gain("+0.1")) + row("strong", "shield", "Durability", 66) + "</div>"
         + f'<div class="cl" style="left:1268px;top:{R["cardio"]}px">' + head("pulse", "CARDIO", "how long it lasts")
         + row("solid", "pulse", "Stamina", 57, goal=60, right=gain("+0.4")) + row("strong", "redo", "Recovery", 66)
         + row("elite char", "heart", "Heart", 85, ceil=False, right=cap("gets up")) + "</div>"
         + f'<div class="cl" style="left:1268px;top:{R["legs"]}px">' + head("feet", "LEGS", "gets in and out")
         + row("solid", "fast", "Speed", 63, right=gain("+0.2")) + row("solid", "feet", "Footwork", 58, right=gain("+0.2"))
         + row("solid", "bend", "Flexibility", 55, right=pill("Mobility")) + "</div>"
         + f'<div class="cl" style="left:1268px;top:{R["today"]}px">' + head("scale", "TODAY", "weight limit 60.0 kg")
         + day("fair", "scale", "Weight", 100, 96, "60.9", cap("0.9 over") + pill("Cut", True))
         + day("strong", "batt", "Tiredness", 38, 80, "38", cap("Fresh, no rest day"), tired=True)
         + day("solid", "smile", "Mood", 62, 0, "62", cap("Steady, listens")) + "</div>")
goal = ('<div class="goal"><div class="gr">40%</div><div><b>Goal: Stamina for five rounds</b><span>Stamina 57 of 60, 18 days left</span></div>'
        '<span class="ok">On track</span></div>')
acts = '<div class="acts">' + act("cal", "Plan the week") + act("route", "Fight plan", "5 lines") + act("two", "Compare") + act("talk", "Talk to Lucy") + "</div>"
guide = ('<div class="guide"><div class="gface"><img src="face_trainer.png" alt=""><span class="plate">Coach</span></div><div class="gtail"></div>'
         '<div class="gbub"><p>Gives ground up close. Two sparring nights fix it.</p><div><span class="cap">Inside fighting +0.6 a week</span>'
         '<span class="go sm">Do it</span></div></div></div>')
html = ('<!doctype html>\n<html lang="en"><head><meta charset="utf-8"><title>Fighter, Profile tab: the body chart (owner stand-in, 10 of 10)</title>\n<style>\n'
        + CSS + "\n</style></head>\n<body>" + '<div class="wall"></div>' + top + tabs + '<div class="floor"></div>' + step + header + squad + fig + leads + pins
        + left + right + goal + acts + guide + "</body></html>\n")
pathlib.Path(__file__).with_name("overview_10.html").write_text(html, encoding="utf-8")
print("written", len(html))
