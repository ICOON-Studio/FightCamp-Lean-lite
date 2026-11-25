// RINGANIM1 (S552): every action of Ring Switches needs a FRAME RUN on disk (the owner, S551: "seeing every card being
// executed by the fighters"). Lists each run the page plays and fails for each one that is missing from
// proto/twohands/img/anim/frames.json, has fewer than MIN frames, or names a file that is not on disk.
//   node proto/twohands/tools/anim_check.mjs [--quiet]
// Exit 0 = every run is there; 1 = at least one is missing (the list is printed).
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const here = path.dirname(fileURLToPath(import.meta.url));
const dir = path.join(here, '..', 'img', 'anim');
const MIN = 3;
const CORNERS = ['blue', 'red'];
// the page's punches (ACT[..].pic in switch.html) - the overhand has its own run name even while it borrows a take
const PUNCHES = ['jab', 'cross', 'lead_hook', 'body_hook', 'lead_uppercut', 'rear_uppercut', 'body_cross', 'overhand'];
const RESULTS = ['landed', 'blocked', 'missed'];
// one run each: feet, both hands held high / low, the feint, the push, the clinch, the knockdown
const SOLO = ['step_in', 'back_off', 'hold_high', 'hold_low', 'feint', 'push', 'clinch', 'knockdown'];
// NO TAKE EXISTS (S552, docs/RINGANIM1_RESULT.md): one hand held high or low while the other does something else. Our
// library holds a guard with BOTH hands only. Listed every run so nobody reads a pass as "every action is seen".
const NO_TAKE = ['lead_high', 'lead_low', 'rear_high', 'rear_low'];

export function wanted() {
  const runs = [];
  for (const c of CORNERS) {
    for (const p of PUNCHES) for (const r of RESULTS) runs.push(`${c}_${p}_${r}`);
    for (const s of SOLO) runs.push(`${c}_${s}`);
  }
  return runs;
}

let table = {};
try { table = JSON.parse(fs.readFileSync(path.join(dir, 'frames.json'), 'utf8')).runs || {}; } catch (e) { /* no table yet: every run is red */ }
const missing = [];
for (const run of wanted()) {
  const row = table[run];
  if (!row) { missing.push(`${run}: no run`); continue; }
  const files = row.files || [], offs = row.offs || [];
  if (files.length < MIN) { missing.push(`${run}: ${files.length} frames (needs ${MIN})`); continue; }
  if (files.length !== offs.length) { missing.push(`${run}: ${files.length} files but ${offs.length} times`); continue; }
  const gone = files.filter((f) => !fs.existsSync(path.join(dir, f)));
  if (gone.length) missing.push(`${run}: not on disk: ${gone.join(', ')}`);
}
const total = wanted().length;
const noTake = CORNERS.flatMap((c) => NO_TAKE.map((n) => `${c}_${n}`)).filter((n) => !table[n]);
const borrowed = Object.keys(table).filter((n) => table[n].same_as);
if (!process.argv.includes('--quiet')) { for (const m of missing) console.log('MISSING ' + m); for (const n of noTake) console.log('NO TAKE ' + n); for (const n of borrowed) console.log(`BORROWED ${n} plays ${table[n].same_as}`); }
console.log(`ANIM_CHECK runs=${total} ok=${total - missing.length} missing=${missing.length} no_take=${noTake.length} borrowed=${borrowed.length} ${missing.length ? 'FAIL' : 'PASS'}`);
process.exit(missing.length ? 1 : 0);
