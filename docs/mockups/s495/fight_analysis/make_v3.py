"""Builds fight_analysis_v3.html from v1's style and film picture (S495 FIGHTFILM1 v2). Then:
python tools/render_mockup.py docs/mockups/s495/fight_analysis/fight_analysis_v3.html"""
import pathlib
import re

HERE = pathlib.Path(__file__).parent
v1 = (HERE / "fight_analysis.html").read_text(encoding="utf-8")
style = re.search(r"<style>.*?</style>", v1, re.S).group(0)
svg = re.search(r"<svg width.*?</svg>", v1, re.S).group(0)
# v2: no tell mark on the film, a shorter screen
svg = re.sub(r'<text x="706".*?</text>', "", svg, flags=re.S)
svg = re.sub(r'<path d="M425 196 L452 222".*?/>\s*<circle cx="431".*?/>', "", svg, flags=re.S)
svg = re.sub(r'<rect x="0" y="0" width="722" height="40".*?</text>', "", svg, flags=re.S)
svg = svg.replace('width="722" height="372" viewBox="0 0 722 372"', 'width="722" height="330" viewBox="0 20 722 330"')

extra = """<style>
.hdr .nm,.hdr span{white-space:nowrap}
.film{height:556px}.screen{height:330px}
.pat{top:728px;height:338px}
.strip{display:flex;gap:6px;margin-top:8px}
.rb{flex:1;background:var(--page);border:1px solid var(--line);border-radius:3px;padding:4px 8px;font-size:14px;font-weight:600}
.rb .h{display:flex;justify-content:space-between;color:var(--muted);font-weight:700;font-size:12px;letter-spacing:1.4px}
.rb .cards{display:flex;gap:5px;margin-top:3px}
.card{flex:1;text-align:center;border-radius:2px;padding:1px 0;font-family:'Barlow Condensed';font-weight:700;font-size:15px}
.cb{background:rgba(111,160,230,.22);color:#cfe0f7;border:1px solid rgba(111,160,230,.6)}
.cr{background:rgba(223,70,57,.18);color:#f6c2bb;border:1px solid rgba(223,70,57,.55)}
.ln .rg{width:52px;color:var(--muted);font-size:14px;font-weight:600}
.ln .af{width:96px;font-size:14px;font-weight:600;color:var(--text)}
.ln .p{flex:1}
.hd{display:flex;gap:10px;padding:0 8px;height:20px;align-items:center;font-size:12px;font-weight:700;letter-spacing:1.4px;color:var(--muted)}
.bar .cl{position:absolute;left:0;top:0;bottom:0;background:#cfe0f7}
.mk{height:28px}.mk .w{width:126px}.mk .f{width:150px;color:var(--muted);font-weight:600;font-size:14px}
.res .big em{color:var(--good)}
.tag{display:inline-flex;align-items:center;height:26px;padding:0 10px;border-radius:13px;background:#3a2e22;border:1px solid var(--warn);color:#f0c98f;font-weight:700;font-size:14px}
</style>"""

body = f"""<!doctype html><html><head><meta charset="utf-8"><title>Fight analysis v3</title>
<link href="https://fonts.googleapis.com/css2?family=Barlow:wght@400;500;600;700;800&family=Barlow+Condensed:wght@500;600;700&display=swap" rel="stylesheet">
{style}{extra}</head><body>
<div class="top"><span class="crumb">Fighters &rsaquo; Fight prep &rsaquo; <b>Film night</b></span><span class="sp"></span>
<span class="t">Thu 12 Mar 2026 &middot; evening</span><span class="t">Fight night in <b>3 days</b></span></div>

<div class="panel hdr">
  <span class="dot d-b" style="width:16px;height:16px"></span><span class="nm">Mia Holt</span><span class="vs">vs</span>
  <span class="dot d-r" style="width:16px;height:16px"></span><span class="nm">Tess Rowe</span>
  <span class="meta">&nbsp;&middot; club show, Feb 2026 &middot; Holt won on points</span>
  <span class="sp"></span>
  <span class="tag">Costs tonight: pads, one-two 27&rarr;31</span>
  <span class="caps" style="font-size:14px">Film 1 of 3</span><span class="btn small">Next film &rsaquo;</span>
  <span class="caps" style="font-size:14px;color:var(--text)">Checks</span><span class="pips"><span class="pip f"></span><span class="pip f"></span><span class="pip"></span></span>
  <span style="font-weight:700;font-size:16px;color:var(--muted)">2 left &middot; 6 for her</span>
  <span class="btn">Done for tonight</span>
</div>

<div class="panel film">
  <div class="pt">THE FILM <small>ringside camera &middot; Round 2</small></div>
  <div class="screen">{svg}</div>
  <div class="ctl">
    <span class="btn small">&#9664; Previous moment</span><span class="btn small act" style="width:44px">&#10074;&#10074;</span><span class="btn small">Next moment &#9654;</span>
    <span class="pick">0.5x</span><span class="pick on">1x</span><span class="pick">2x</span>
    <span class="clock">R2 0:44</span><span style="flex:1"></span>
    <span style="font-size:14px;color:var(--muted);font-weight:600">moment 21 of 31</span>
  </div>
  <div class="tl" id="tl"></div>
  <div class="strip">
    <div class="rb"><div class="h"><span>ROUND 1</span><span>the judges</span></div><div class="cards"><span class="card cb">10-9</span><span class="card cb">10-9</span><span class="card cb">10-9</span></div></div>
    <div class="rb"><div class="h"><span>ROUND 2</span><span>split</span></div><div class="cards"><span class="card cb">10-9</span><span class="card cr">9-10</span><span class="card cb">10-9</span></div></div>
    <div class="rb"><div class="h"><span>ROUND 3</span><span>reason on hover</span></div><div class="cards"><span class="card cr">9-10</span><span class="card cr">9-10</span><span class="card cr">9-10</span></div></div>
  </div>
</div>

<div class="panel pat">
  <div class="pt">MARK A PATTERN <small>finding is free, filing costs a check</small></div>
  <div class="row"><span class="lab">WHEN</span><div class="sel">Their jab <span>&#9662; 9 choices</span></div></div>
  <div class="row"><span class="lab">THEN</span><div class="sel">Right hand low <span>&#9662; 8 choices &middot; within 2 s</span></div></div>
  <div class="res">
    <div class="big">Coach: &ldquo;<em>That's her.</em>&rdquo; &nbsp;All of them: 7 of 31 jabs</div>
    <div class="sub">Against 3 of 43 other punches. On camera you saw 5 of 21. One film: 70%; pooled with a second: 85%.</div>
  </div>
  <div class="row" style="margin-top:9px"><span class="btn" style="opacity:.42">Check it with the coach (2 left)</span><span class="btn act">File it at 70%</span><span class="btn">Watch list</span></div>
  <div class="marked">
    <div class="caps" style="margin-top:4px">Marked tonight &nbsp;&middot;&nbsp; film 1 | film 2</div>
    <div class="mk"><span class="w" style="color:var(--good)">That's her</span><span class="f">7/31 &nbsp;|&nbsp; &ndash;</span>Their jab &rarr; right hand low</div>
    <div class="mk"><span class="w" style="color:var(--warn)">Not enough (2)</span><span class="f">watch list &nbsp;|&nbsp; &ndash;</span><span style="color:var(--muted)">They are hurt &rarr; single wild right</span></div>
  </div>
</div>

<div class="panel pun">
  <div class="pt">THE PUNCHES <small>both corners, every punch, in order</small></div>
  <div class="caps" style="margin-top:10px">Show me</div>
  <div class="filters">
    <span class="pick on"><span class="dot d-b"></span>Them</span><span class="pick"><span class="dot d-r"></span>The other</span><span class="pick">Both</span>
    <span class="pick"><span class="k">Hand</span> Any</span><span class="pick on"><span class="k">Punch</span> Jab</span>
    <span class="pick"><span class="k">Result</span> Any</span><span class="pick"><span class="k">Range</span> Any</span>
    <span class="pick"><span class="k">Round</span> All</span><span class="pick"><span class="k">Their game</span> Any</span><span class="pick"><span class="k">After</span> Any</span>
  </div>
  <div class="count"><span><b>31</b> lines of 164</span><span>seen on camera: right low after <b>5 of 21</b> jabs &middot; 10 not seen</span></div>
  <div class="hd"><span style="width:62px">CLOCK</span><span style="width:11px"></span><span style="flex:1">PUNCH</span><span style="width:52px">RANGE</span><span style="width:96px">AFTER</span><span style="width:84px;text-align:right">RESULT</span></div>
  <div class="list" id="list" style="height:660px"></div>
</div>

<div class="panel rep">
  <div class="pt">THE REPORT</div>
  <div class="tabs"><span class="tab on"><span class="dot d-b"></span>Them</span><span class="tab"><span class="dot d-r"></span>The other</span></div>
  <div class="sec"><div class="caps" style="display:flex;justify-content:space-between">Thrown, landed, clean<span style="letter-spacing:.5px;text-transform:none;font-size:13px">sort: <b style="color:var(--text)">count</b> | clean rate</span></div><div id="bars" style="margin-top:6px"></div>
    <div class="legend"><span><i style="background:#4f5a6b"></i>thrown</span><span><i style="background:var(--blue)"></i>landed</span><span><i style="background:#cfe0f7"></i>clean</span><span>head 19 &middot; body 6</span></div>
    <div style="margin-top:6px;display:flex;align-items:center;gap:10px"><span class="btn small">Check it (1): best weapon</span><span style="font-size:14px;color:var(--muted);font-weight:600">the punch that lands clean most</span></div></div>
  <div class="sec"><div class="caps">Landed by round</div>
    <div class="bar"><span class="n">Round 1</span><span class="tr"><span class="th" style="width:87%"></span><span class="la" style="width:32%"></span></span><span class="v">10/27</span></div>
    <div class="bar"><span class="n">Round 2</span><span class="tr"><span class="th" style="width:81%"></span><span class="la" style="width:29%"></span></span><span class="v">9/25</span></div>
    <div class="bar"><span class="n">Round 3</span><span class="tr"><span class="th" style="width:71%"></span><span class="la" style="width:19%"></span></span><span class="v">6/22</span></div></div>
  <div class="sec"><div class="caps">Landed by range</div>
    <div class="bar"><span class="n">Long</span><span class="tr"><span class="th" style="width:100%"></span><span class="la" style="width:29%"></span></span><span class="v">11/38</span></div>
    <div class="bar"><span class="n">Mid</span><span class="tr"><span class="th" style="width:63%"></span><span class="la" style="width:24%"></span></span><span class="v">9/24</span></div>
    <div class="bar"><span class="n">Inside</span><span class="tr"><span class="th" style="width:32%"></span><span class="la" style="width:13%"></span></span><span class="v">5/12</span></div></div>
  <div class="sec"><div class="caps">Their game, share of exchanges</div>
    <div class="split" style="margin-top:7px"><span class="seg" style="width:220px;background:var(--blue)"></span><span class="seg" style="width:130px;background:#4f6c99"></span><span class="seg" style="width:75px;background:#3c4d66"></span></div>
    <div class="legend" style="font-size:14px;color:var(--text)"><span>Boxes at range 9</span><span>Walks you down 6</span><span>Waits to counter 3</span></div>
    <div style="margin-top:6px"><span class="btn small">Check it (1): their game</span></div></div>
  <div class="sec"><div class="caps">Their combinations</div>
    <div class="cmb"><span class="x">x7</span><span class="nm2">Jab, cross</span><span class="tchip">R1 0:22</span><span class="tchip">R1 1:31</span><span class="tchip">R2 0:12</span><span class="tchip">+4</span></div>
    <div class="cmb"><span class="x">x3</span><span class="nm2">Jab, jab, cross</span><span class="tchip">R1 0:58</span><span class="tchip">R2 1:40</span><span class="tchip">R3 0:30</span></div></div>
  <div class="sec"><div class="caps">What the numbers say</div>
    <div class="say"><div>The jab is thrown most; the cross lands clean most, 4 times.</div>
      <div>Round 3: 6 landed of 22, against 10 of 27 in round 1.</div>
      <div>Inside, 5 landed of 12; at long range, 11 of 38.</div></div></div>
</div>

<script>
const L=[
 ["sit","Round 1 &middot; boxes at range"],
 ["R1 0:06","Jab to the head","long","guard up","Blocked","b"],["R1 0:09","Jab to the head","long","&ndash;","Missed","m"],
 ["R1 0:22","Jab to the head","long","threw on","Landed","l"],["R1 0:31","Jab to the body","long","&ndash;","Blocked","b"],
 ["sit","Round 1 &middot; walks the other down"],
 ["R1 0:38","Jab to the head","mid","right low","Landed","l"],["R1 0:47","Jab to the head","mid","&ndash;","Blocked","b"],
 ["R1 0:58","Jab to the head","mid","threw on","Clean","c"],["R1 1:04","Jab to the head","mid","guard up","Missed","m"],
 ["sit","Round 1 &middot; boxes at range"],
 ["R1 1:16","Jab to the head","long","&ndash;","Blocked","b"],["R1 1:31","Jab to the head","long","threw on","Landed","l"],
 ["R1 1:44","Jab to the head","long","guard up","Blocked","b"],["R1 2:20","Jab to the head","long","&ndash;","Missed","m"],
 ["sit","Round 2 &middot; boxes at range"],
 ["R2 0:12","Jab to the head","long","&ndash;","Landed","l"],["R2 0:20","Jab to the head","long","&ndash;","Missed","m"],
 ["R2 0:33","Jab to the head","long","guard up","Blocked","b"],["R2 0:44","Jab to the head","long","right low","Blocked","b","cur"],
 ["sit","Round 2 &middot; waits to counter"],
 ["R2 1:02","Jab to the head","mid","&ndash;","Missed","m"],["R2 1:10","Jab to the head","mid","threw on","Landed","l"],
 ["R2 1:23","Jab to the body","mid","&ndash;","Blocked","b"],["R2 1:40","Jab to the head","long","right low","Clean","c"],
 ["sit","Round 3 &middot; walks the other down"],
 ["R3 0:09","Jab to the head","inside","&ndash;","Blocked","b"],["R3 0:30","Jab to the head","mid","threw on","Landed","l"]
];
const list=document.getElementById('list');
for(const x of L){{
  if(x[0]==="sit"){{list.insertAdjacentHTML('beforeend',`<div class="sit">${{x[1]}}</div>`);continue}}
  const cls={{l:"r-l",b:"r-b",m:"r-m",c:"r-l"}}[x[5]];
  list.insertAdjacentHTML('beforeend',`<div class="ln ${{x[6]||""}}"><span class="c">${{x[0]}}</span><span class="dot d-b"></span><span class="p">${{x[1]}}</span><span class="rg">${{x[2]}}</span><span class="af">${{x[3]}}</span><span class="r ${{cls}}"${{x[5]==="c"?' style="font-weight:800"':""}}>${{x[4]}}</span></div>`);
}}
const B=[["Jab",31,9,2],["Cross",18,8,4],["Lead hook",12,4,1],["Body hook",9,3,1],["Uppercut",4,1,0]];
const bars=document.getElementById('bars');
for(const b of B){{bars.insertAdjacentHTML('beforeend',`<div class="bar"><span class="n">${{b[0]}}</span><span class="tr"><span class="th" style="width:${{b[1]/31*100}}%"></span><span class="la" style="width:${{b[2]/31*100}}%"></span><span class="cl" style="width:${{b[3]/31*100}}%"></span></span><span class="v">${{b[3]}}/${{b[2]}}/${{b[1]}}</span></div>`)}}
const tl=document.getElementById('tl');const W=720;
for(let r=0;r<3;r++){{tl.insertAdjacentHTML('beforeend',`<span class="rd" style="left:${{r*W/3}}px"></span><span class="rl" style="left:${{r*W/3}}px">R${{r+1}}</span>`)}}
const sec=s=>{{const m=s.match(/R(\\d) (\\d):(\\d\\d)/);return (m[1]-1)*180+(+m[2])*60+(+m[3])}};
for(const x of L){{if(x[0]==="sit")continue;tl.insertAdjacentHTML('beforeend',`<span class="tick" style="left:${{sec(x[0])/540*W}}px;background:#8b95a3"></span>`)}}
tl.insertAdjacentHTML('beforeend',`<span class="head" style="left:${{sec("R2 0:44")/540*W}}px"></span>`);
</script></body></html>"""
(HERE / "fight_analysis_v3.html").write_text(body, encoding="utf-8")
print("wrote", HERE / "fight_analysis_v3.html")
