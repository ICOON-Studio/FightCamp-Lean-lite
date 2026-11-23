// GRAPPLEMAP1 - reads GrappleMap.txt (public domain, github.com/Eelis/GrappleMap) into positions and transitions.
// Format (from the repo's own src/persistence.cpp, read not guessed): a record is some description lines followed by
// data lines that start with a space. One data block = 4 lines, 69 base62 digits each = 276 digits = one pose of both
// figures: 2 players x 23 joints x 3 coordinates, each coordinate two digits d0 d1 with value (d0*62+d1)/1000;
// x = value - 2, y = value, z = value - 2 (metres, y is up). A record with ONE pose is a named position, a record
// with several poses is a transition (its frames). Plain node, no dependencies.
import fs from 'node:fs';
import crypto from 'node:crypto';

// the 23 joints in the file's own order (src/players.hpp enum Joint)
export const JOINTS = [
  'LeftToe', 'RightToe', 'LeftHeel', 'RightHeel', 'LeftAnkle', 'RightAnkle', 'LeftKnee', 'RightKnee',
  'LeftHip', 'RightHip', 'LeftShoulder', 'RightShoulder', 'LeftElbow', 'RightElbow', 'LeftWrist', 'RightWrist',
  'LeftHand', 'RightHand', 'LeftFingers', 'RightFingers', 'Core', 'Neck', 'Head',
];
export const PLAYER_JOINTS = JOINTS.length * 2; // 46 player-joints, player 0 (top/red) first, then player 1 (blue)
export const VALUES_PER_POSE = PLAYER_JOINTS * 3; // 138
export const DIGITS_PER_POSE = VALUES_PER_POSE * 2; // 276
const BASE62 = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

function digitsToPose(digits) {
  const v = new Array(VALUES_PER_POSE);
  for (let i = 0, o = 0; i < PLAYER_JOINTS; i++) {
    const x = (BASE62.indexOf(digits[o]) * 62 + BASE62.indexOf(digits[o + 1])) / 1000;
    const y = (BASE62.indexOf(digits[o + 2]) * 62 + BASE62.indexOf(digits[o + 3])) / 1000;
    const z = (BASE62.indexOf(digits[o + 4]) * 62 + BASE62.indexOf(digits[o + 5])) / 1000;
    o += 6;
    v[i * 3] = +(x - 2).toFixed(3); v[i * 3 + 1] = +y.toFixed(3); v[i * 3 + 2] = +(z - 2).toFixed(3);
  }
  return v;
}

// description lines -> the fields GrappleMap itself reads (src/metadata.cpp: "tags:", "properties:"; ref lines are
// the instructional sources it cites)
function describe(lines) {
  const tags = [], props = [], refs = [];
  for (const l of lines) {
    if (l.startsWith('tags:')) tags.push(...l.slice(5).trim().split(/\s+/).filter(Boolean));
    else if (l.startsWith('properties:')) props.push(...l.slice(11).trim().split(/\s+/).filter(Boolean));
    else if (l.startsWith('ref:')) refs.push(l.slice(4).trim());
  }
  const name = (lines[0] || '').replace(/\\n/g, ' ').trim();
  return { name, lines: lines.length, tags, props, refs, description: lines.join('\n') };
}

// every record: description lines, then poses. `raw` is the record's own text, so an extract can be cut verbatim.
export function splitRecords(text) {
  const records = [];
  let cur = { desc: [], digits: '', raw: [] };
  const close = () => {
    if (cur.desc.length || cur.digits.length) records.push(cur);
    cur = { desc: [], digits: '', raw: [] };
  };
  for (const line of text.split('\n')) {
    const isData = line.startsWith(' ');
    if (isData) {
      for (const ch of line) if (!/\s/.test(ch)) cur.digits += ch;
      cur.raw.push(line);
    } else {
      if (cur.digits.length) close(); // a description line after poses starts the next record
      if (line.trim().length) { cur.desc.push(line.replace(/\s+$/, '')); cur.raw.push(line); }
    }
  }
  close();
  return records;
}

// the other direction, for the round-trip test: a pose back to the file's own 4 data lines
export function encodePose(pose) {
  let s = '';
  const two = (v) => {
    const i = Math.round(v * 1000);
    if (i < 0 || i > 3843) throw new Error(`coordinate out of the file's range: ${v}`);
    return BASE62[Math.floor(i / 62)] + BASE62[i % 62];
  };
  for (let j = 0; j < PLAYER_JOINTS; j++) s += two(pose[j * 3] + 2) + two(pose[j * 3 + 1]) + two(pose[j * 3 + 2] + 2);
  const per = s.length / 4;
  return [0, 1, 2, 3].map((i) => '    ' + s.slice(i * per, (i + 1) * per)).join('\n');
}

export function encodeRecords(records) {
  return records.map((r) => [...r.desc, encodePose(r.pose)].join('\n')).join('\n');
}

// --- linking a transition end to a position, as GrappleMap's own loader does it (src/positions.cpp
// is_reoriented): a pose may appear rotated about y, mirrored, or with the two players swapped. The head-to-head
// distance is the same under every such reorientation, so it is the cheap gate; a joint may then differ by at most
// 0.04 m (basicallySame's 0.0016 squared).
const jointOf = (p, player, joint) => ({ x: p[(player * JOINTS.length + joint) * 3], y: p[(player * JOINTS.length + joint) * 3 + 1], z: p[(player * JOINTS.length + joint) * 3 + 2] });
const HEAD = JOINTS.indexOf('Head');
const d2 = (a, b) => (a.x - b.x) ** 2 + (a.y - b.y) ** 2 + (a.z - b.z) ** 2;
const yrot = (a, v) => ({ x: Math.cos(a) * v.x - Math.sin(a) * v.z, y: v.y, z: Math.sin(a) * v.x + Math.cos(a) * v.z });
const angleXZ = (v) => Math.atan2(v.x, v.z);
const mirrorPose = (p) => p.map((v, i) => (i % 3 === 0 ? -v : v));
const swapPlayers = (p) => { const q = p.slice(); for (let j = 0; j < JOINTS.length; j++) for (let c = 0; c < 3; c++) { q[j * 3 + c] = p[(JOINTS.length + j) * 3 + c]; q[(JOINTS.length + j) * 3 + c] = p[j * 3 + c]; } return q; };
const headGap2 = (p) => d2(jointOf(p, 0, HEAD), jointOf(p, 1, HEAD));

function sameUnderRotation(a, b) {
  const a0 = jointOf(a, 0, HEAD), a1 = jointOf(a, 1, HEAD);
  const b0 = jointOf(b, 0, HEAD), b1 = jointOf(b, 1, HEAD);
  const off = angleXZ({ x: b1.x - b0.x, y: 0, z: b1.z - b0.z }) - angleXZ({ x: a1.x - a0.x, y: 0, z: a1.z - a0.z });
  const shift = { x: b0.x - yrot(off, a0).x, y: b0.y - a0.y, z: b0.z - yrot(off, a0).z };
  for (let i = 0; i < PLAYER_JOINTS; i++) {
    const v = yrot(off, { x: a[i * 3], y: a[i * 3 + 1], z: a[i * 3 + 2] });
    if (d2({ x: v.x + shift.x, y: v.y + shift.y, z: v.z + shift.z }, { x: b[i * 3], y: b[i * 3 + 1], z: b[i * 3 + 2] }) > 0.0016) return false;
  }
  return true;
}

// true when b is a's pose rotated about y, possibly mirrored, possibly with the players swapped
export function samePose(a, b) {
  if (Math.abs(headGap2(a) - headGap2(b)) > 0.05) return false;
  if (sameUnderRotation(a, b)) return true;
  if (sameUnderRotation(a, mirrorPose(b))) return true;
  return sameUnderRotation(a, swapPlayers(b));
}

export function parseGrappleMap(text) {
  const records = splitRecords(text);
  const pos = [], trans = [];
  for (const r of records) {
    if (!r.desc.length) throw new Error('a record has poses but no description line');
    if (r.digits.length % DIGITS_PER_POSE !== 0) throw new Error(`pose data not a whole number of poses: ${r.digits.length} digits`);
    const poses = [];
    for (let o = 0; o < r.digits.length; o += DIGITS_PER_POSE) poses.push(digitsToPose(r.digits.slice(o, o + DIGITS_PER_POSE)));
    const meta = describe(r.desc);
    if (poses.length === 1) {
      pos.push({ id: pos.length, ...meta, pose: poses[0], raw: r.raw });
    } else {
      trans.push({ id: trans.length, ...meta, frames: poses, raw: r.raw });
    }
  }
  // link each transition to the named positions it starts and ends at (matcher above; GrappleMap itself also makes an
  // unnamed node when nothing matches, so a null end is the file's own behaviour, not a parse failure)
  const byPose = new Map(); // exact copies first: most ends are copied verbatim
  for (const p of pos) if (!byPose.has(p.pose.join(','))) byPose.set(p.pose.join(','), p.id);
  const findPos = (pose) => {
    const exact = byPose.get(pose.join(','));
    if (exact !== undefined) return exact;
    for (const p of pos) if (samePose(p.pose, pose)) return p.id;
    return null;
  };
  let unlinked = 0;
  const unnamed = new Map(); // unnamed nodes GrappleMap's loader would create, so both ends of a chain share an id
  const unnamedId = (pose) => {
    for (const [k, id] of unnamed) if (samePose(k, pose)) return id;
    const id = pos.length + unnamed.size;
    unnamed.set(pose, id);
    return id;
  };
  for (const t of trans) {
    const a = findPos(t.frames[0]), b = findPos(t.frames[t.frames.length - 1]);
    t.from = a; t.to = b;
    t.fromNode = a ?? unnamedId(t.frames[0]);
    t.toNode = b ?? unnamedId(t.frames[t.frames.length - 1]);
    if (a === null || b === null) unlinked++;
  }
  const tagCount = new Map();
  for (const r of [...pos, ...trans]) for (const t of r.tags) tagCount.set(t, (tagCount.get(t) || 0) + 1);
  return {
    positions: pos,
    transitions: trans,
    unlinked,
    counts: {
      positions: pos.length,
      transitions: trans.length,
      frames: trans.reduce((n, t) => n + t.frames.length, 0),
      positionsWithTags: pos.filter((p) => p.tags.length).length,
      transitionsWithTags: trans.filter((t) => t.tags.length).length,
      tags: tagCount.size,
      tagUses: [...tagCount.values()].reduce((a, b) => a + b, 0),
      joints: JOINTS.length,
      playerJoints: PLAYER_JOINTS,
      poses: pos.length + trans.reduce((n, t) => n + t.frames.length, 0),
      bytes: Buffer.byteLength(text),
      sha256: crypto.createHash('sha256').update(text).digest('hex'),
    },
    tagCount,
  };
}

export function readGrappleMap(file = new URL('./GrappleMap.txt', import.meta.url).pathname) {
  return parseGrappleMap(fs.readFileSync(file, 'utf8'));
}

// the parser's own count lines (node parse.mjs prints these)
export function countLines(g) {
  const c = g.counts;
  return [
    `positions:   ${c.positions}`,
    `transitions: ${c.transitions}`,
    `frames:      ${c.frames} in those transitions`,
    `poses:       ${c.poses} (positions + frames), ${c.playerJoints} player-joints each`,
    `tags:        ${c.tags} distinct, ${c.tagUses} uses`,
    `joints:      ${c.joints} per figure`,
    `source:      ${c.bytes} bytes, sha256 ${c.sha256}`,
    `unlinked:    ${g.unlinked} transitions whose ends did not match a named position`,
  ];
}

if (process.argv[1] && process.argv[1].endsWith('parse.mjs')) {
  const g = readGrappleMap(process.argv[2]);
  console.log(countLines(g).join('\n'));
}
