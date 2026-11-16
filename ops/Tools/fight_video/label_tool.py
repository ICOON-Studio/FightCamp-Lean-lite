"""Label the punches of a clip WE own (filmed at a gym with everyone's consent): confirm or fix with a key press.  (Claude, S495)

usage: python label_tool.py <video> --out <dir> [--port 8791] [--no-analyze]

  1. If <dir>/strikes.json is missing, analyze.py runs first (the pose pass; it asks the PC watchdog itself).
  2. A small page is served on http://127.0.0.1:<port>/ - THIS SCRIPT OPENS NOTHING: you open that address in your own
     browser when you want to label. Stop it with Ctrl+C.
  3. The page plays each proposed punch in a slow loop. One key confirms it, one rejects it, others fix the boxer, hand,
     type, target or result; N adds a punch the analyzer missed. Every change is saved at once to <dir>/labels.json.

labels.json has the same `punches` records as our synthetic clips (tools/fight_video_synth.gd): boxer 0|1, hand, lead,
type (jab, cross, lead/rear hook, lead/rear uppercut), target, result, start / contact / end frame - plus `status`
(confirmed | fixed | added), the analyzer's own proposal, and the clip's consent record. A clip counts as ready for
training only when the consent boxes are ticked: everyone filmed agreed in writing, and nobody filmed is under 18.
The video must be one a browser plays (H.264 .mp4 or .webm); convert a phone's HEVC file first:
  ffmpeg -i in.mov -c:v libx264 -crf 18 -an out.mp4
Standard library only (plain python works once strikes.json exists)."""
import json
import os
import subprocess
import sys
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

HERE = os.path.dirname(os.path.abspath(__file__))
TYPES = ["jab", "cross", "lead hook", "rear hook", "lead uppercut", "rear uppercut"]
MIME = {".mp4": "video/mp4", ".webm": "video/webm", ".mov": "video/quicktime", ".m4v": "video/mp4", ".ogv": "video/ogg"}


def proposals(strikes):
    """analyze.py's strikes.json -> the punches to confirm, in the dataset's own record shape."""
    info = strikes["info"]
    rows = strikes["strikes"]
    ratios = [s["frame"] / s["t"] for s in rows if s["t"] > 0.5]
    src_fps = float(sorted(ratios)[len(ratios) // 2]) if ratios else float(info["fps"])
    out = []
    for s in rows:
        lead = s["lead"] if s.get("lead") in ("lead", "rear") else ""
        family = s.get("family", "")
        kind = s["type"] if s["type"] in TYPES else ({"straight": {"lead": "jab", "rear": "cross"}}.get(family, {}).get(lead, "") or (("%s %s" % (lead, family)) if lead and family in ("hook", "uppercut") else ""))
        contact = int(s["frame"])
        p = dict(boxer="AB".index(s["boxer"]), hand=s["hand"], lead=lead, type=kind, target=s["target"] if s["target"] in ("head", "body") else "head",
                 result=s["result"] if s["result"] in ("landed", "blocked", "missed") else "landed",
                 start=max(0, int(round(s.get("onset_t", s["t"] - 0.2) * src_fps))), contact=contact, end=contact + int(round(0.3 * src_fps)),
                 shown=True, status="proposed", glove_xy=s.get("glove_xy"), confidence=s.get("confidence"))
        p["proposed"] = {k: p[k] for k in ("boxer", "hand", "lead", "type", "target", "result", "start", "contact", "end")}
        out.append(p)
    return out, src_fps


def load_state(video, out_dir):
    path = os.path.join(out_dir, "labels.json")
    if os.path.exists(path):
        return json.load(open(path, encoding="utf-8"))
    strikes = json.load(open(os.path.join(out_dir, "strikes.json"), encoding="utf-8"))
    punches, src_fps = proposals(strikes)
    info = strikes["info"]
    return dict(version=1, clip=os.path.splitext(os.path.basename(video))[0], video=os.path.abspath(video),
                source="real footage we own; punches proposed by ops/Tools/fight_video/analyze.py, confirmed or fixed by a person",
                fps=src_fps, frames=int(round(info["duration"] * src_fps)), boxers=[dict(kit=c) for c in info["colour"]],
                consent=dict(everyone_agreed_in_writing=False, nobody_under_18=False, filmed_by="", place="", date="", notes=""),
                ready_for_training=False, joints="not exact: the pose model's estimate is in pose.npz / boxers.npz beside this file",
                punches=punches)


def save_state(out_dir, state):
    c = state.get("consent", {})
    done = all(p["status"] != "proposed" for p in state["punches"])
    state["ready_for_training"] = bool(c.get("everyone_agreed_in_writing") and c.get("nobody_under_18") and done)
    state["counts"] = {k: sum(p["status"] == k for p in state["punches"]) for k in ("proposed", "confirmed", "fixed", "added", "rejected")}
    tmp = os.path.join(out_dir, "labels.json.tmp")
    json.dump(state, open(tmp, "w", encoding="utf-8"), indent=1)
    os.replace(tmp, os.path.join(out_dir, "labels.json"))
    return state


PAGE = r"""<!doctype html><html><head><meta charset="utf-8"><title>Punch labels</title><style>
body{margin:0;background:#16181c;color:#e8e8e8;font:15px/1.4 Segoe UI,Arial,sans-serif;display:flex;height:100vh}
#left{flex:1;display:flex;flex-direction:column;padding:10px;min-width:0}#wrap{position:relative;flex:1;min-height:0;background:#000}
video,canvas{position:absolute;inset:0;width:100%;height:100%;object-fit:contain}canvas{pointer-events:none}
#now{font-size:20px;padding:8px 2px}#now b{color:#ffd24a}.bad{color:#ff7a6a}
#right{width:400px;overflow:auto;padding:10px;border-left:1px solid #333}
.row{padding:3px 6px;cursor:pointer;border-radius:4px;white-space:nowrap}.row.cur{background:#2f4a7a}
.confirmed{color:#7fd67f}.fixed{color:#7fc8ff}.added{color:#d6b3ff}.rejected{color:#777;text-decoration:line-through}
kbd{background:#333;border-radius:3px;padding:1px 5px;margin-right:2px}#keys{font-size:13px;color:#bbb;line-height:1.9}
label{display:block;margin:3px 0}input[type=text]{width:240px;background:#222;color:#eee;border:1px solid #444}
#ready{padding:6px;margin:6px 0;border-radius:4px;background:#402020}#ready.ok{background:#1f4024}</style></head><body>
<div id="left"><div id="wrap"><video id="v" muted playsinline></video><canvas id="c"></canvas></div><div id="now"></div>
<div id="keys"><kbd>Enter</kbd>right as shown &nbsp;<kbd>X</kbd>not a punch &nbsp;<kbd>A</kbd>other boxer &nbsp;<kbd>S</kbd>other hand &nbsp;
<kbd>1</kbd>jab <kbd>2</kbd>cross <kbd>3</kbd>lead hook <kbd>4</kbd>rear hook <kbd>5</kbd>lead uppercut <kbd>6</kbd>rear uppercut &nbsp;
<kbd>H</kbd>head <kbd>B</kbd>body &nbsp;<kbd>L</kbd>landed <kbd>K</kbd>blocked <kbd>M</kbd>missed<br>
<kbd>&larr;</kbd><kbd>&rarr;</kbd>previous / next &nbsp;<kbd>R</kbd>replay &nbsp;<kbd>Space</kbd>pause &nbsp;<kbd>,</kbd><kbd>.</kbd>one frame back / on &nbsp;
<kbd>[</kbd>start here <kbd>C</kbd>contact here <kbd>]</kbd>end here &nbsp;<kbd>N</kbd>add a punch here &nbsp;<kbd>F</kbd>free play / loop</div></div>
<div id="right"><div id="ready"></div>
<label><input type="checkbox" id="agree"> Everyone filmed agreed in writing to this use</label>
<label><input type="checkbox" id="adult"> Nobody filmed is under 18</label>
<label>Filmed by <input type="text" id="by"></label><label>Place <input type="text" id="place"></label>
<label>Date <input type="text" id="date"></label><label>Notes <input type="text" id="notes"></label><hr><div id="list"></div></div>
<script>
const TYPES=["jab","cross","lead hook","rear hook","lead uppercut","rear uppercut"];
let S=null,cur=0,loop=true;const v=document.getElementById('v'),cv=document.getElementById('c');
const fr=t=>Math.round(t*S.fps),tm=f=>f/S.fps;
async function load(){S=await (await fetch('/state')).json();v.src='/video';v.playbackRate=0.5;
 for(const [id,k] of [['agree','everyone_agreed_in_writing'],['adult','nobody_under_18']]){const e=document.getElementById(id);e.checked=S.consent[k];e.onchange=()=>{S.consent[k]=e.checked;save()}}
 for(const id of ['by','place','date','notes']){const e=document.getElementById(id),k=id=='by'?'filmed_by':id;e.value=S.consent[k]||'';e.onchange=()=>{S.consent[k]=e.value;save()}}
 const first=S.punches.findIndex(p=>p.status=='proposed');go(first<0?0:first)}
function P(){return S.punches[cur]}
function go(i){if(!S.punches.length){draw();return}cur=Math.max(0,Math.min(S.punches.length-1,i));loop=true;v.currentTime=Math.max(0,tm(P().start)-0.35);v.play();draw()}
function mark(st){const p=P();if(st=='confirmed'&&p.status!='added'){const q=p.proposed||{};p.status=['boxer','hand','type','target','result','start','contact','end'].every(k=>q[k]===p[k])?'confirmed':'fixed'}else if(st!='confirmed')p.status=st;
 if(p.status!='rejected'&&!p.type){draw('Pick the punch type first (keys 1-6).');return}save();const n=S.punches.findIndex((q,i)=>i>cur&&q.status=='proposed');go(n<0?cur+1:n)}
function setv(k,val){const p=P();p[k]=val;if(k=='type')p.lead=val=='jab'||val.startsWith('lead')?'lead':'rear';if(p.status=='confirmed'||p.status=='rejected')p.status='fixed';save();draw()}
function add(){const f=fr(v.currentTime);const p={boxer:0,hand:'left',lead:'lead',type:'',target:'head',result:'landed',start:Math.max(0,f-Math.round(0.2*S.fps)),contact:f,end:f+Math.round(0.3*S.fps),shown:true,status:'added',glove_xy:null};
 S.punches.push(p);S.punches.sort((a,b)=>a.contact-b.contact);cur=S.punches.indexOf(p);save();draw('Added: now set boxer (A), hand (S), type (1-6), target, result, then Enter.')}
async function save(){const r=await fetch('/save',{method:'POST',body:JSON.stringify(S)});const j=await r.json();S.ready_for_training=j.ready_for_training;S.counts=j.counts;draw()}
function draw(msg){const p=S.punches.length?P():null,n=document.getElementById('now');
 n.innerHTML=p?`Punch ${cur+1} of ${S.punches.length}: boxer <b>${'AB'[p.boxer]}</b> (${(S.boxers[p.boxer]||{}).kit||'?'} kit), <b>${p.hand}</b> hand, <b>${p.type||'<span class=bad>type?</span>'}</b>, to the <b>${p.target}</b>, <b>${p.result}</b> &nbsp; [${p.status}]`+(msg?`<br><span class=bad>${msg}</span>`:''):'No punches proposed. Press N at a punch to add one.';
 const c=S.counts||{},left=S.punches.filter(q=>q.status=='proposed').length,rd=document.getElementById('ready');
 rd.className=S.ready_for_training?'ok':'';rd.textContent=S.ready_for_training?'Ready for training: every punch checked, consent recorded.':`Not ready: ${left} punch(es) unchecked`+((S.consent.everyone_agreed_in_writing&&S.consent.nobody_under_18)?'':', consent boxes not both ticked')+'.';
 document.getElementById('list').innerHTML=S.punches.map((q,i)=>`<div class="row ${q.status} ${i==cur?'cur':''}" onclick="go(${i})">${tm(q.contact).toFixed(2)}s ${'AB'[q.boxer]} ${q.hand} ${q.type||'?'} ${q.target} ${q.result}</div>`).join('');
 const e=document.querySelector('.row.cur');if(e)e.scrollIntoView({block:'nearest'})}
function tick(){if(S&&S.punches.length){const p=P();if(loop&&v.currentTime>tm(p.end)+0.35){v.currentTime=Math.max(0,tm(p.start)-0.35)}
 const g=cv.getContext('2d');cv.width=cv.clientWidth;cv.height=cv.clientHeight;g.clearRect(0,0,cv.width,cv.height);
 if(p.glove_xy&&v.videoWidth&&Math.abs(v.currentTime-tm(p.contact))<0.12){const s=Math.min(cv.width/v.videoWidth,cv.height/v.videoHeight),ox=(cv.width-v.videoWidth*s)/2,oy=(cv.height-v.videoHeight*s)/2;
  g.strokeStyle='#ffd24a';g.lineWidth=3;g.beginPath();g.arc(ox+p.glove_xy[0]*s,oy+p.glove_xy[1]*s,22,0,6.3);g.stroke()}}
 requestAnimationFrame(tick)}
document.addEventListener('keydown',e=>{if(e.target.tagName=='INPUT'&&e.target.type=='text')return;const k=e.key.toLowerCase();let used=true;
 if(k=='enter')mark('confirmed');else if(k=='x')mark('rejected');else if(k=='a')setv('boxer',1-P().boxer);else if(k=='s')setv('hand',P().hand=='left'?'right':'left');
 else if('123456'.includes(k)&&k.length==1)setv('type',TYPES[+k-1]);else if(k=='h')setv('target','head');else if(k=='b')setv('target','body');
 else if(k=='l')setv('result','landed');else if(k=='k')setv('result','blocked');else if(k=='m')setv('result','missed');
 else if(k=='arrowleft')go(cur-1);else if(k=='arrowright')go(cur+1);else if(k=='r')go(cur);else if(k==' '){v.paused?v.play():v.pause()}
 else if(k==','){v.pause();v.currentTime=Math.max(0,v.currentTime-1/S.fps)}else if(k=='.'){v.pause();v.currentTime+=1/S.fps}
 else if(k=='[')setv('start',fr(v.currentTime));else if(k=='c')setv('contact',fr(v.currentTime));else if(k==']')setv('end',fr(v.currentTime));
 else if(k=='n')add();else if(k=='f'){loop=!loop}else used=false;if(used)e.preventDefault()});
load();tick();
</script></body></html>"""


def make_handler(video, out_dir):
    class Handler(BaseHTTPRequestHandler):
        def log_message(self, *a):
            pass

        def _send(self, code, kind, body):
            self.send_response(code)
            self.send_header("Content-Type", kind)
            self.send_header("Content-Length", str(len(body)))
            self.send_header("Cache-Control", "no-store")
            self.end_headers()
            self.wfile.write(body)

        def do_GET(self):
            if self.path == "/":
                self._send(200, "text/html; charset=utf-8", PAGE.encode("utf-8"))
            elif self.path == "/state":
                self._send(200, "application/json", json.dumps(load_state(video, out_dir)).encode("utf-8"))
            elif self.path.startswith("/video"):
                self._video()
            elif self.path == "/favicon.ico":
                self._send(204, "image/x-icon", b"")
            else:
                self._send(404, "text/plain", b"not found")

        def _video(self):
            size = os.path.getsize(video)
            start, end = 0, size - 1
            rng = self.headers.get("Range", "")
            if rng.startswith("bytes="):
                a, _, b = rng[6:].partition("-")
                start = int(a) if a else max(0, size - int(b))
                end = min(size - 1, int(b)) if a and b else size - 1
            end = min(end, start + (4 << 20) - 1)   # at most 4 MB a request: the browser asks for more as it plays
            self.send_response(206 if rng else 200)
            self.send_header("Content-Type", MIME.get(os.path.splitext(video)[1].lower(), "application/octet-stream"))
            self.send_header("Accept-Ranges", "bytes")
            if rng:
                self.send_header("Content-Range", "bytes %d-%d/%d" % (start, end, size))
            else:
                end = size - 1
            self.send_header("Content-Length", str(end - start + 1))
            self.end_headers()
            with open(video, "rb") as f:
                f.seek(start)
                left = end - start + 1
                try:
                    while left > 0:
                        chunk = f.read(min(1 << 16, left))
                        if not chunk:
                            break
                        self.wfile.write(chunk)
                        left -= len(chunk)
                except (BrokenPipeError, ConnectionResetError, ConnectionAbortedError):
                    pass

        def do_POST(self):
            if self.path != "/save":
                return self._send(404, "text/plain", b"not found")
            state = json.loads(self.rfile.read(int(self.headers.get("Content-Length", "0"))).decode("utf-8"))
            state = save_state(out_dir, state)
            self._send(200, "application/json", json.dumps(dict(ready_for_training=state["ready_for_training"], counts=state["counts"])).encode("utf-8"))

    return Handler


def main():
    a = sys.argv
    if len(a) < 2 or "--help" in a or "-h" in a:
        print(__doc__)
        return
    opt = lambda k, d: type(d)(a[a.index(k) + 1]) if k in a else d
    video = os.path.abspath(a[1])
    out_dir = os.path.abspath(opt("--out", os.path.splitext(video)[0] + "_labels"))
    os.makedirs(out_dir, exist_ok=True)
    if not os.path.exists(os.path.join(out_dir, "strikes.json")) and not os.path.exists(os.path.join(out_dir, "labels.json")):
        if "--no-analyze" in a:
            sys.exit("no strikes.json in %s: run analyze.py first, or drop --no-analyze" % out_dir)
        print("no proposals yet: running the analyzer first (the pose pass takes a few minutes per minute of video)")
        rc = subprocess.run([sys.executable, os.path.join(HERE, "analyze.py"), video, "--out", out_dir]).returncode
        if rc != 0:
            sys.exit("the analyzer stopped (exit %d): nothing to label yet" % rc)
    port = opt("--port", 8791)
    server = ThreadingHTTPServer(("127.0.0.1", port), make_handler(video, out_dir))
    state = load_state(video, out_dir)
    print("%d punches proposed for %s" % (len(state["punches"]), os.path.basename(video)))
    print("Open this address in your browser to label:  http://127.0.0.1:%d/   (Ctrl+C here stops it)" % port)
    print("Labels are saved as you go to %s" % os.path.join(out_dir, "labels.json"))
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("stopped")


if __name__ == "__main__":
    main()
