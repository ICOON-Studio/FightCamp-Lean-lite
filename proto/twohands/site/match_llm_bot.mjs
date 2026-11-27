// MATCH_LLM_BOT (S568, owner: "Yes, wire it" - a local model on the match server, so he can play it live).
// A match-server player whose thinking is a LOCAL model (Ollama on this PC's GPU; gemma4:12b answers a beat in ~1.5 s).
// It joins by name, waits in the queue for anyone who presses "Find an opponent", fights the bout, then waits again.
// Each beat: the bout as it sees it (/api/state) -> one Ollama call (the server's /api/help is the rules, sent as the
// system text) -> /api/plan; a refused plan is sent back with the server's reason. Nothing leaves the PC.
//   node proto/twohands/site/match_llm_bot.mjs [name=Gemma] [server=http://127.0.0.1:8796] [model=gemma4:12b] [bouts=0 (for ever)] [vs=<name>] [keep=3m] [idle=120]
// Prints one line per bout and per late or refused beat; the beat seconds at the end of each bout.
const arg = Object.fromEntries(process.argv.slice(2).filter((a) => a.includes('=')).map((a) => { const i = a.indexOf('='); return [a.slice(0, i), a.slice(i + 1)]; }));
const B = (arg.server || 'http://127.0.0.1:8796').replace(/\/$/, ''), NAME = arg.name || 'Gemma', MODEL = arg.model || 'gemma4:12b', BOUTS = Number(arg.bouts || 0);
const IDLE_S = Number(arg.idle || 120);   /* an opponent silent this long loses the bout by leaving it: see the bout loop */
const KEEP = arg.keep || '3m';   /* the model holds ~9.5 GB: it loads when a bout starts and leaves 3 min after the last beat (S568: the watchdog went RED on memory while it waited loaded) */
const OLLAMA = 'http://127.0.0.1:11434/api/chat', sleep = (ms) => new Promise((r) => setTimeout(r, ms));
const post = async (p, o) => (await fetch(B + p, { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify(o) })).json(), get = async (p) => (await fetch(B + p)).json();
const FORM = 'Answer with ONE line only: lead=<punch|high|low> rear=<punch|high|low> feet=in|hold|back order=<feet,lead,rear in your order>   (or the one word: clinch). Nothing else.';
let RULES = '';
async function think(user, tokens = 24) {   /* think=false: the model otherwise spends its whole budget thinking; num_ctx 8192: Ollama's default here (262,144) made a beat 20 s */
  const body = { model: MODEL, stream: false, think: false, keep_alive: KEEP, messages: [{ role: 'system', content: `You are ${NAME}, a boxer in a small turn-based boxing game, playing to WIN against a person. Read what he does and punish it.\n\n${RULES}\n\n${FORM}` }, { role: 'user', content: user }], options: { num_predict: tokens, temperature: 0.8, num_ctx: 8192 } };
  const r = await fetch(OLLAMA, { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify(body) }); const d = await r.json(); return ((d.message || {}).content || '').trim(); }
function parsePlan(reply) { const lines = reply.split(/\r?\n/).map((l) => l.replace(/[`*>]/g, ' ').trim().toLowerCase());
  for (let i = lines.length - 1; i >= 0; i--) { const l = lines[i], lead = (l.match(/\blead\s*=\s*([a-z]+)/) || [])[1], rear = (l.match(/\brear\s*=\s*([a-z]+)/) || [])[1];
    if (lead && rear) { const feet = (l.match(/\bfeet\s*=\s*([a-z]+)/) || [])[1] || 'hold', order = ((l.match(/\border\s*=\s*([a-z, ]+)/) || [])[1] || '').split(',').map((x) => x.trim().split(' ')[0]).filter((x) => ['feet', 'lead', 'rear'].includes(x)).join(',');
      return { lead, rear, feet, ...(order ? { order } : {}) }; }
    if (/^(plan\s*[:=]\s*)?clinch\W*$/.test(l)) return { clinch: true }; }
  return null; }
function text(s) { const m = (lab, f) => `${lab}: health ${f.health}/${f.healthMax}${f.downs ? ` (down ${f.downs}x)` : ''}, stamina ${f.stamina}/${f.staminaCap}, guard ${f.guard}, ground given ${f.groundGiven}/2${f.onTheRopes ? ' ON THE ROPES' : ''}${f.noClinchYet ? ', no clinch yet' : ''}${f.keptOut ? ', kept out (no step in this beat)' : ''}`;
  const L = [`ROUND ${s.round} of ${s.rounds}, beat ${s.beat} of ${s.beats}, range ${s.rangeName}. Points this round: you ${s.me.points} - him ${s.he.points}. Cards so far (you-him): ${s.cards.map((c) => c.join('-')).join(', ') || 'none'}`, m('YOU', s.me), m(`HIM (${s.him})`, s.he)];
  if (s.hisLastBeats.length) L.push(`HIS LAST BEATS, newest first: ${s.hisLastBeats.join('  |  ')}`);
  if (s.lastBeat) L.push('THE LAST BEAT:', ...s.lastBeat.lines.map((x) => '  ' + x));
  return L.join('\n') + '\nChoose your beat.\n' + FORM; }
/* S568: the match server may restart (a rules change, the owner's OK): on any network error Gemma waits and joins again, never crashes */
let bouts = 0;
async function session() {
  RULES = await (await fetch(B + '/api/help')).text();
  const load = async () => { const w = Date.now(); await think('Say: ready', 4); return ((Date.now() - w) / 1000).toFixed(1); };
  console.log(`MATCH_LLM_BOT ${NAME}: ${MODEL} answers (${await load()} s); it stays loaded only during bouts`);
  let j = {}; for (let k = 1; k <= 9 && !j.token; k++) { j = await post('/api/join', { name: k === 1 ? NAME : `${NAME} ${k}` }); if (!j.token && !/in use/.test(j.error || '')) break; }   /* the server holds a name 15 min after its last call: a restart takes the next free one */
  if (!j.token) { console.log('MATCH_LLM_BOT could not join: ' + (j.error || '?')); process.exit(1); } console.log(`MATCH_LLM_BOT joined as ${j.name}`);
  for (; !BOUTS || bouts < BOUTS; bouts++) {
    let f; console.log(`MATCH_LLM_BOT ${NAME}: waiting for an opponent`); for (;;) { f = await post('/api/find', { token: j.token, ...(arg.vs ? { vs: arg.vs } : {}) }); if (f.match) break; if (f.error) throw new Error(f.error);   /* a restarted server does not know the token: join again */ await sleep(1500); }
    console.log(`MATCH_LLM_BOT ${NAME}: bout ${f.match}, the model loads (${await load()} s)`);
    const secs = []; let him = '', idleSince = Date.now(), lastN = -1;
    for (;;) { const s = await get(`/api/state?token=${j.token}&match=${f.match}`); if (s.error) throw new Error(s.error); him = s.him || him; if (s.over) { console.log(`MATCH_LLM_BOT ${NAME} v ${him}: ${s.over} | beat seconds ${secs.join(' ')}`); break; }
      if (s.n !== lastN) { lastN = s.n; idleSince = Date.now(); }
      /* S568: an opponent who has gone (closed the page, a dead process) would hold it for 10 min a beat: after IDLE_S with no
         beat played, it gives the bout up and waits for the next player */
      if (!s.yourTurn && Date.now() - idleSince > IDLE_S * 1000) { await post('/api/leave', { token: j.token, match: f.match }); console.log(`MATCH_LLM_BOT ${NAME}: ${him} has not moved for ${IDLE_S} s - bout given up`); break; }
      if (!s.yourTurn) { await sleep(400); continue; }
      const t0 = Date.now(); let msg = text(s), sealed = false;
      for (let t = 0; t < 3 && !sealed; t++) { let plan = null; try { plan = parsePlan(await think(msg)); } catch (e) { console.log('MATCH_LLM_BOT the local model does not answer: ' + e.message); }
        const r = await post('/api/plan', { token: j.token, match: f.match, ...(plan || { lead: 'high', rear: 'high', feet: 'hold' }) });
        if (r.ok || /already sealed|is over/.test(r.error || '')) sealed = true; else { console.log(`MATCH_LLM_BOT refused (${r.error})`); msg = text(s) + `\nYOUR LAST PLAN WAS REFUSED: ${r.error}. Send another.`; } }
      if (!sealed) await post('/api/plan', { token: j.token, match: f.match, lead: 'high', rear: 'high', feet: 'hold' });
      secs.push(((Date.now() - t0) / 1000).toFixed(1)); } }
}
for (;;) { try { await session(); if (BOUTS && bouts >= BOUTS) break; } catch (e) { console.log('MATCH_LLM_BOT the match server does not answer (' + (e.cause && e.cause.code || e.message) + '): trying again in 10 s'); await sleep(10000); } }
