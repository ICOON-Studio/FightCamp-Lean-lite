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
// one run each: feet, the feint, the push, the clinch, the knockdown, and since HOLDTAKES1 (S553) the four ONE-HAND holds
// (the choice the game is about: a hand held high or low). The two-hand holds of S552 are gone: the page never asks for them.
const SOLO = ['step_in', 'back_off', 'lead_high', 'lead_low', 'rear_high', 'rear_low', 'feint', 'push', 'clinch', 'knockdown'];
const NO_TAKE = [];
const HANDS = ['lead_high', 'lead_low', 'rear_high', 'rear_low'];
const BOTH = ['both_high_high', 'both_high_low', 'both_low_high', 'both_low_low'];

export function wanted() {
  const runs = [];
  for (const c of CORNERS) {
    for (const p of PUNCHES) for (const r of RESULTS) runs.push(`${c}_${p}_${r}`);
    for (const s of SOLO) runs.push(`${c}_${s}`);
    // S553: both hands held (every hand that does not punch is high or low), the knockdown that comes from each punch,
    // and the steps drawn ending on the range they reach (_r3 Long, _r2 Mid, _r1 Inside)
    for (const h of BOTH) runs.push(`${c}_${h}`);
    for (const p of PUNCHES) runs.push(`${c}_${p}_ko`);
    for (const s of ['step_in_r2', 'step_in_r1', 'back_off_r3', 'back_off_r2']) runs.push(`${c}_${s}`);
  }
  // the player's standing pictures at Mid and Inside (the plain name is Long)
  for (const h of [...HANDS, ...BOTH]) for (const r of ['_r2', '_r1']) runs.push(`blue_${h}${r}`);
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
