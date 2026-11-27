// MATCH_BOT (S567): the smallest player of the match server - joins, finds a bout, sends a plan whenever it is its turn.
// It is the worked example for an agent: the same five calls, with thinking put where `choose` is.
//   node proto/twohands/site/match_bot.mjs <name> [server=http://127.0.0.1:8796] [bouts=1] [vs=<name>]
const [name = 'Sparring bot', ...rest] = process.argv.slice(2), arg = Object.fromEntries(rest.filter((a) => a.includes('=')).map((a) => { const i = a.indexOf('='); return [a.slice(0, i), a.slice(i + 1)]; }));
const B = arg.server || 'http://127.0.0.1:8796', sleep = (ms) => new Promise((r) => setTimeout(r, ms));
const post = async (p, o) => (await fetch(B + p, { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify(o) })).json(), get = async (p) => (await fetch(B + p)).json();
// a plain boxer: jab from Long, step in when fresh, cross and hook at Mid and Inside, cover when tired or hurt
function choose(s, tries) { const me = s.me, r = s.rangeName, i = s.n + tries;
  if (tries >= 2 || me.stamina <= 1) return { lead: 'high', rear: i % 2 ? 'high' : 'low', feet: 'hold' };
  if (r === 'Long') return me.stamina >= 4 && i % 3 === 0 && !me.keptOut ? { lead: 'jab', rear: 'high', feet: 'in', order: 'feet,lead' } : { lead: i % 2 ? 'jab' : 'bjab', rear: 'high', feet: 'hold' };
  if (r === 'Mid') return me.stamina >= 4 ? (i % 2 ? { lead: 'jab', rear: 'cross', feet: 'hold', order: 'lead,rear' } : { lead: 'hook', rear: 'high', feet: 'hold' }) : { lead: 'jab', rear: 'high', feet: me.onTheRopes ? 'hold' : 'back', order: 'lead,feet' };
  return me.stamina >= 4 ? (i % 2 ? { lead: 'hook', rear: 'rbody', feet: 'hold', order: 'lead,rear' } : { lead: 'lup', rear: 'high', feet: 'hold' }) : (me.noClinchYet ? { lead: 'low', rear: 'high', feet: 'hold' } : { clinch: true }); }
const j = await post('/api/join', { name }); if (!j.token) { console.log('MATCH_BOT ' + (j.error || 'could not join')); process.exit(1); }
for (let bout = 0; bout < Number(arg.bouts || 1); bout++) { let f; for (;;) { f = await post('/api/find', { token: j.token, ...(arg.vs ? { vs: arg.vs } : {}) }); if (f.match) break; await sleep(1500); }
  console.log(`MATCH_BOT ${name}: bout ${f.match}`);
  for (;;) { const s = await get(`/api/state?token=${j.token}&match=${f.match}`); if (s.over) { console.log(`MATCH_BOT ${name}: ${s.over}`); break; }
    if (!s.yourTurn) { await sleep(700); continue; } for (let t = 0; t < 4; t++) { const r = await post('/api/plan', { token: j.token, match: f.match, ...choose(s, t) }); if (r.ok) break; } } }
