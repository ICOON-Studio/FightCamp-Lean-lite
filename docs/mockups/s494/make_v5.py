"""Training K v5 (S494) from v4: his Q-252 mark 1 - 'this is a training screen, opponents have nothing to do here,
remove it and maybe move it in players tab'. The win-chance and fight-night panels leave; THIS WEEK (moves) and
MORNINGS take the right column; the session tray gets a morning row and an evening row; no win % anywhere."""
import pathlib, re

SRC = pathlib.Path(__file__).resolve().parents[1] / "s493/training_k/training_k_v4.html"
OUT = pathlib.Path(__file__).resolve().parent / "training_k/training_k_v5.html"
L = SRC.read_text(encoding="utf-8").split("\n")


def idx(marker):
    return next(i for i, s in enumerate(L) if s.startswith(marker))


def mbar(had, now, usable_at=30, top=60, w=300):
    """Mastery bar 0..top: deep pink = had, light pink white-edged = this week, dashed = missing to Usable, flag above."""
    k = w / top
    x0, x1, xf = had * k, now * k, usable_at * k
    s = [f'<svg class="mbs" width="{w}" height="30" viewBox="0 0 {w} 30">',
         f'<rect x="0" y="10" width="{w}" height="15" rx="4" fill="#26303c"/>',
         f'<rect x="0" y="10" width="{x0:.1f}" height="15" rx="4" fill="#c94a85"/>',
         f'<rect x="{x0:.1f}" y="10" width="{x1 - x0:.1f}" height="15" fill="#ffc8e0" stroke="#fff" stroke-width="1.5"/>']
    if x1 < xf:
        s.append(f'<rect x="{x1 + 1:.1f}" y="10.5" width="{xf - x1 - 2:.1f}" height="14" rx="2" fill="none" '
                 f'stroke="#ffc8e0" stroke-width="2" stroke-dasharray="4 3"/>')
    s.append(f'<line x1="{xf:.1f}" y1="0" x2="{xf:.1f}" y2="8.5" stroke="#5fcf7a" stroke-width="2.5"/>'
             f'<path d="M{xf:.1f} 0 L{xf + 9:.1f} 3.2 L{xf:.1f} 6.4Z" fill="#5fcf7a"/></svg>')
    return "".join(s)


MOVES = "../../../../assets/ui/moves/"
right = f'''<!-- RIGHT (v5, his Q-252 mark 1): training only - what the evenings teach, what the mornings build -->
<div class="box" style="left:1396px;top:64px;width:508px;height:290px;padding:12px 16px">
 <h2>THIS WEEK <small>what the evenings teach</small></h2>
 <div class="mvk"><span class="mth big" style="border-color:var(--acc);background-image:url({MOVES}lead_hook.png)"></span>
  <div style="flex:1"><div class="mvt"><b style="color:var(--acc)">Check hook</b><span class="bg">12 &#8594; <b style="color:#ffc8e0">28</b></span></div>
  {mbar(12, 28)}
  <div class="mvs" style="color:#ffc8e0"><span class="ghb"></span> one pad night short &middot; usable Mon 23</div></div></div>
 <div class="mvk"><span class="mth big" style="border-color:var(--acc);background-image:url({MOVES}lead_hook.png)"></span>
  <div style="flex:1"><div class="mvt"><b style="color:var(--acc)">Body hook</b><span class="bg">29 &#8594; <b style="color:#ffc8e0">35</b></span></div>
  {mbar(29, 35)}
  <div class="mvs gr"><span class="okb">&#10003;</span> usable from Wed</div></div></div>
 <div class="kmv"><span class="flg"></span> Usable = he throws it in a fight &middot; <span class="htb"></span> this week &middot; <span class="ghb"></span> still missing</div>
</div>

<div class="box" style="left:1396px;top:362px;width:508px;height:208px;padding:12px 16px">
 <h2>MORNINGS <small>this week's stat gains</small></h2>
 <div class="sg">
  <div><span style="color:var(--sta)">Cardio</span><b>+0.22</b></div><div><span style="color:var(--def)">Defence</span><b>+0.17</b></div>
  <div><span style="color:var(--acc)">Technique</span><b>+0.12</b></div><div><span style="color:var(--iq)">Fight IQ</span><b>+0.12</b></div>
  <div><span style="color:var(--str)">Power</span><b>+0.12</b></div><div><span style="color:var(--spd)">Speed</span><b>+0.06</b></div>
 </div>
 <div style="font-size:15px;font-weight:700;margin-top:10px;color:#c3cad4">Week total <b style="color:var(--ink)">+0.81</b> &middot; Sunday off <b style="color:var(--green)">-8 tiredness</b></div>
</div>
'''

TRAY_I = idx("<!-- SESSION TRAY -->")
tiles = [s for s in L[TRAY_I:TRAY_I + 22] if s.lstrip().startswith('<div class="ti">')]
morning, evening = tiles[:10], tiles[10:]
tray = ['<!-- SESSION TRAY (v5): one row for mornings, one for evenings -->',
        '<div class="box tray" style="left:16px;top:728px;width:1366px;height:338px;padding:8px 14px">',
        ' <h2>SESSIONS <small>drag a morning onto a day &middot; drag an evening onto the coach\'s slice &middot; one session at Normal</small></h2>',
        ' <div class="trl"><div class="trh">MORNING<small>one stat</small></div><div class="trow">', *morning, ' </div></div>',
        ' <div class="trl"><div class="trh">EVENING<small>moves, with the coach</small></div><div class="trow">', *evening, ' </div></div>',
        '</div>']

WEEK_I, WIN_I, FRI_I = idx("<!-- THIS WEEK BUYS"), idx("<!-- RIGHT: WIN CHANCE"), idx("<!-- RIGHT: FRIDAY DECISION")
tray_end = next(i for i in range(TRAY_I, WIN_I) if L[i] == "</div>" and L[i - 1] == " </div>")
out = L[:WEEK_I] + tray + L[tray_end + 1:WIN_I] + [right] + L[FRI_I:]
html = "\n".join(out)

# Friday box under MORNINGS; no win % on a training screen
html = html.replace('left:1396px;top:582px;width:508px;height:208px', 'left:1396px;top:578px;width:508px;height:212px').replace('margin-top:8px;color:var(--dim)">Give','margin-top:4px;color:var(--dim)">Give')
html = html.replace('<span class="ghb"></span> Mon 23</span> · +1.5% win<span class="est">est.</span>', '<span class="ghb"></span> usable Mon 23</span> with this night')
html = re.sub(r'<span class="flg"></span><span class="gr">win \+0</span>', '<span class="flg"></span><span class="gr">usable</span>', html)
html = re.sub(r'<div style="font-size:14px;font-weight:700;margin-top:8px;color:var\(--dim\)"><span class="dia"></span>.*?</div>\n',
              '<div style="font-size:14px;font-weight:700;margin-top:4px;color:var(--dim)">Give her the night: the check hook waits a week.</div>\n',
              html, count=1, flags=re.S)
html = html.replace("<title>Training scene K v3 (S490)</title>", "<title>Training scene K v5 (S494)</title>")
css = '''.mvk{display:flex;gap:12px;align-items:flex-start;margin-top:10px}
.mth.big{width:52px;height:52px;border-width:3px;flex:none;margin-top:4px}
.mvt{display:flex;justify-content:space-between;align-items:baseline;font-size:19px;font-weight:800;width:300px}
.mvs{font-size:14px;font-weight:800;margin-top:2px}
.kmv{font-size:13px;font-weight:700;color:var(--dim);margin-top:12px;border-top:1px solid #26303c;padding-top:8px}
.sg{display:grid;grid-template-columns:1fr 1fr;column-gap:28px;margin-top:8px}
.sg div{display:flex;justify-content:space-between;height:34px;align-items:center;border-bottom:1px solid #26303c;font-weight:800;font-size:17px}
.sg b{font-family:Oswald;font-weight:500;font-size:20px}
.trl{display:flex;align-items:center;gap:14px;margin-top:10px}
.trh{width:110px;font-family:Oswald;font-size:16px;letter-spacing:1.5px;color:#cfc4b1;line-height:1.1}
.trh small{display:block;font-family:Barlow;font-size:13px;letter-spacing:0;color:var(--dim);font-weight:700}
.tray .trl .trow{margin-top:0;gap:10px}
.tray .ti{width:100px}.tray .tic{width:84px;height:84px}.tray .tn{font-size:15px}.tray .tv{font-size:14px}
</style>'''
html = html.replace("</style>", css, 1)
OUT.parent.mkdir(parents=True, exist_ok=True)
OUT.write_text(html, encoding="utf-8")
print(OUT, len(html.split("\n")), "lines;", "win" in html.lower().replace("window", ""))
