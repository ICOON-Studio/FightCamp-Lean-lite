// GRAPPLEMAP1 tests. node --test proto/grapplemap/grapplemap.test.mjs
// The parser is checked against the file's own text, the extract against the fetched full file (when it is present),
// and every picture against the geometry it is supposed to draw. Nothing here is loosened to go green: if a check
// cannot run (the 2.6 MB GrappleMap.txt is fetched, never committed), it says so and is reported as skipped.
import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { JOINTS, PLAYER_JOINTS, VALUES_PER_POSE, parseGrappleMap, encodePose, readGrappleMap } from './parse.mjs';
import { transitionSvg, svgPoints, VIEW } from './render2d.mjs';
import { CARDS } from '../cardgame/cards.mjs';
import { SOURCE } from './slice.mjs';

const HERE = path.dirname(fileURLToPath(import.meta.url));
const read = (p) => fs.readFileSync(path.join(HERE, p), 'utf8');
const slice = JSON.parse(read('bjj_slice.json'));
const extractText = read('bjj_slice.gm.txt');
const extract = parseGrappleMap(extractText);
const fullPath = path.join(HERE, 'GrappleMap.txt');
const haveFull = fs.existsSync(fullPath);
const pictures = slice.cards.filter((c) => c.grapplemap !== undefined);

const dist = (pose, a, b) => {
  const ia = JOINTS.indexOf(a) * 3, ib = JOINTS.indexOf(b) * 3;
  return Math.hypot(pose[ia] - pose[ib], pose[ia + 1] - pose[ib + 1], pose[ia + 2] - pose[ib + 2]);
};

test('the parser reads the counts out of the extract text itself', () => {
  const dataLines = extractText.split('\n').filter((l) => l.startsWith(' ')).length;
  assert.equal(dataLines, 4 * extract.counts.poses, 'every pose is the file format\'s 4 data lines');
  assert.equal(extract.counts.positions, slice.positions.length, 'positions in the extract');
  assert.equal(extract.counts.transitions, slice.transitions.length, 'transitions in the extract');
  assert.equal(extract.counts.frames, slice.transitions.reduce((n, t) => n + t.frames.length, 0), 'frames in the extract');
  assert.equal(extract.counts.poses, extract.counts.positions + extract.counts.frames);
  assert.equal(extract.counts.playerJoints, PLAYER_JOINTS);
  for (const p of extract.positions) assert.equal(p.pose.length, VALUES_PER_POSE);
  for (const t of extract.transitions) for (const f of t.frames) assert.equal(f.length, VALUES_PER_POSE);
  for (const t of extract.transitions) assert.ok(t.frames.length > 1, 'a transition holds more than one pose');
});

test('the tags are counted straight off the tags: lines', () => {
  const tokens = extractText.split('\n').filter((l) => l.startsWith('tags:')).flatMap((l) => l.slice(5).trim().split(/\s+/).filter(Boolean));
  assert.equal(extract.counts.tagUses, tokens.length);
  assert.equal(extract.counts.tags, new Set(tokens).size);
});

test('the base62 decode is right: the bones come out the length GrappleMap\'s own limb table gives', () => {
  // src/players.hpp limbs(): the lengths the file's own viewer uses. The poses are hand-authored and its spring only
  // nudges them, so a bone can be a few cm off in one pose; a wrong decode is off by tens of cm in every pose, which
  // is what the mean catches. (Measured on the full file: the mean is inside 1 cm for every bone below.)
  const bones = [['LeftAnkle', 'LeftKnee', 0.43], ['LeftKnee', 'LeftHip', 0.43], ['LeftShoulder', 'LeftElbow', 0.29],
    ['LeftElbow', 'LeftWrist', 0.26], ['Neck', 'Head', 0.165], ['Core', 'LeftShoulder', 0.37], ['LeftHip', 'Core', 0.27],
    ['LeftToe', 'LeftHeel', 0.23]];
  const poses = [...extract.positions.map((p) => p.pose), ...extract.transitions.flatMap((t) => t.frames)];
  for (const [a, b, want] of bones) {
    const lengths = poses.map((pose) => dist(pose, a, b));
    const mean = lengths.reduce((x, y) => x + y, 0) / lengths.length;
    assert.ok(Math.abs(mean - want) <= 0.01, `${a}-${b}: mean ${mean.toFixed(3)} m against the table's ${want} m`);
    assert.ok(Math.max(...lengths) < want + 0.2, `${a}-${b}: no pose is wildly off, so the joint order is right`);
  }
  for (const pose of poses) for (let i = 1; i < VALUES_PER_POSE; i += 3) assert.ok(pose[i] >= 0, 'y is up, nothing digs into the floor');
});

test('a pose survives the trip back out in the file\'s own 4 data lines', () => {
  const text = ['a position', 'tags: one two', encodePose(extract.positions[0].pose), '', 'a transition', encodePose(extract.positions[0].pose), encodePose(extract.transitions[0].frames[1])].join('\n');
  const back = parseGrappleMap(text);
  assert.equal(back.counts.positions, 1);
  assert.equal(back.counts.transitions, 1);
  assert.deepEqual(back.positions[0].pose, extract.positions[0].pose);
  assert.deepEqual(back.transitions[0].frames[1], extract.transitions[0].frames[1]);
  assert.deepEqual(back.positions[0].tags, ['one', 'two']);
  assert.equal(back.positions[0].name, 'a position');
});

test('every entry in bjj_slice.json exists in the extract text', () => {
  for (const p of slice.positions) {
    const hit = extract.positions.filter((q) => q.name === p.name);
    assert.equal(hit.length, 1, `one position named "${p.name}" in the extract`);
    assert.deepEqual(hit[0].pose, p.pose, `position ${p.id} "${p.name}" is the extract's own numbers`);
  }
  for (const t of slice.transitions) {
    const hit = extract.transitions.filter((q) => q.name === t.name && q.frames.length === t.frames.length);
    assert.equal(hit.length, 1, `one move named "${t.name}" with ${t.frames.length} frames in the extract`);
    assert.deepEqual(hit[0].frames, t.frames, `move ${t.id} "${t.name}" is the extract's own frames`);
  }
  assert.equal(slice.transitions.length, pictures.length, 'one move per pictured card');
});

test('the extract is a verbatim cut of the full GrappleMap.txt, and the counts are the file\'s', { skip: !haveFull && 'GrappleMap.txt not fetched in this checkout (it is 2.6 MB and never committed)' }, () => {
  const full = readGrappleMap(fullPath);
  assert.equal(full.counts.sha256, slice.source.sha256, 'the slice was cut from this exact file');
  for (const [k, v] of Object.entries(slice.source.counts)) assert.equal(full.counts[k], v, `full file count: ${k}`);
  const fullText = fs.readFileSync(fullPath, 'utf8');
  for (const r of [...extract.positions, ...extract.transitions]) {
    assert.ok(fullText.includes(r.raw.join('\n')), `the record "${r.name}" appears verbatim in GrappleMap.txt`);
  }
  for (const p of slice.positions) {
    const hit = full.positions[p.id];
    assert.equal(hit.name, p.name);
    assert.deepEqual(hit.pose, p.pose, `position ${p.id} is the full file's own numbers`);
  }
  for (const t of slice.transitions) {
    const hit = full.transitions[t.transitionIndex];
    assert.equal(full.positions.length + hit.id, t.id, 'the move id is the file\'s own record order');
    assert.equal(hit.name, t.name);
    assert.deepEqual(hit.frames, t.frames, `move ${t.id} is the full file's own frames`);
  }
  // the source stamp the README quotes
  assert.equal(SOURCE.commit, '032c8f91809786b7b784852abd07cf3e10c0ea35');
  assert.match(SOURCE.license, /Public Domain\.$/);
});

test('every BJJ card in cards.mjs has a picture, and the picture is a real GrappleMap move', () => {
  const bjj = Object.keys(CARDS).filter((id) => CARDS[id].st === 'bjj');
  assert.ok(bjj.length >= 6, `the BJJ deck has its cards (${bjj.length})`);
  for (const id of bjj) {
    const entry = slice.cards.find((c) => c.id === id);
    assert.ok(entry, `card "${id}" is in bjj_slice.json`);
    assert.notEqual(entry.grapplemap, undefined, `card "${id}" has a GrappleMap move, not "no match"`);
    assert.equal(entry.card.n, CARDS[id].n, `the slice quotes the card's printed name (${CARDS[id].n})`);
    assert.ok(entry.why && entry.why.length > 40, `card "${id}" says why this move is its picture`);
    const move = slice.transitions.find((t) => t.id === entry.grapplemap);
    assert.ok(move, `card "${id}" points at a move in the extract (${entry.grapplemap})`);
    assert.equal(move.frames.length, entry.frames);
    assert.ok(fs.existsSync(path.join(HERE, entry.picture)), `card "${id}" has its picture (${entry.picture})`);
  }
  // the shared core cards that are in the BJJ deck too
  for (const id of Object.keys(CARDS).filter((k) => CARDS[k].st === 'core')) {
    assert.ok(slice.cards.some((c) => c.id === id), `core card "${id}" is listed`);
  }
});

test('every picture has two figures, both inside the 512 frame', () => {
  for (const c of pictures) {
    const svg = read(c.picture);
    const { p0, p1 } = svgPoints(svg);
    assert.ok(p0.length > 20, `${c.picture}: the red figure is drawn (${p0.length} points)`);
    assert.ok(p1.length > 20, `${c.picture}: the blue figure is drawn (${p1.length} points)`);
    assert.match(svg, /#c8352b/, `${c.picture}: red is in the picture`);
    assert.match(svg, /#2b62c4/, `${c.picture}: blue is in the picture`);
    assert.match(svg, new RegExp(`viewBox="0 0 ${VIEW} ${VIEW}"`));
    for (const [who, points] of [['red', p0], ['blue', p1]]) {
      for (const p of points) {
        assert.ok(p.x >= 8 && p.x <= VIEW - 8 && p.y >= 8 && p.y <= VIEW - 8,
          `${c.picture}: ${who} point (${p.x}, ${p.y}) inside the frame`);
      }
      const xs = points.map((p) => p.x), ys = points.map((p) => p.y);
      assert.ok(Math.max(...xs) - Math.min(...xs) > 20 && Math.max(...ys) - Math.min(...ys) > 20, `${c.picture}: ${who} is a whole body, not a dot`);
    }
    // the floor line, when the picture draws one, is the world's y = 0: it has to sit at or under every drawn point
    const floor = svg.match(/class="t\d+-floor" x1="0" y1="([\d.]+)"/);
    if (floor) {
      const lowest = Math.max(...[...p0, ...p1].map((p) => p.y));
      assert.ok(+floor[1] >= lowest - 0.5, `${c.picture}: the floor (${floor[1]}) is at or under the lowest point (${lowest.toFixed(1)})`);
    }
    const frames = (svg.match(/class="t\d+-(?:frame) /g) || []).length;
    assert.equal(frames, c.frames, `${c.picture}: one group per frame`);
    assert.match(svg, new RegExp(`<meta name="grapplemap-frames" content="${c.frames}"/>`));
  }
});

test('the pictures on disk are what render2d draws from the slice, not hand-tuned files', () => {
  for (const c of pictures) {
    const move = slice.transitions.find((t) => t.id === c.grapplemap);
    const again = transitionSvg({ title: move.name, frames: move.frames, label: `t${c.grapplemap}`, frameMs: 280 });
    assert.equal(read(c.picture), again, `${c.picture} matches a fresh render`);
  }
});
