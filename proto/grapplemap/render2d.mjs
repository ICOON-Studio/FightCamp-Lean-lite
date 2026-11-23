// GRAPPLEMAP1 - draws one GrappleMap pose, or a whole transition, as a 512x512 SVG: both figures, side view,
// orthographic, red on the left and blue on the right, limbs as round-capped strokes. A transition becomes N frames in
// one SVG stepped by CSS, so it plays anywhere without JavaScript. No dependencies, no browser, plain node.
import { JOINTS } from './parse.mjs';

export const VIEW = 512;
export const PAD = 34; // room for the thickest stroke plus the head
export const RED = '#c8352b';
export const BLUE = '#2b62c4';
const PAPER = '#fbf9f4';
const GROUND = '#d8d2c6';
const INK = '#4a4438';

// the drawn skeleton: bone chains per figure (GrappleMap's own joint table, src/players.hpp)
const CHAINS = [
  ['LeftShoulder', 'LeftElbow', 'LeftWrist', 'LeftHand', 'LeftFingers'],
  ['RightShoulder', 'RightElbow', 'RightWrist', 'RightHand', 'RightFingers'],
  ['LeftHip', 'LeftKnee', 'LeftAnkle', 'LeftToe'],
  ['RightHip', 'RightKnee', 'RightAnkle', 'RightToe'],
  ['RightHip', 'LeftHip'],                 // hip line
  ['RightShoulder', 'LeftShoulder'],       // shoulder line
  ['LeftHip', 'Core', 'Neck', 'Head'],     // trunk, so a body reads as one piece
  ['RightHip', 'Core'],
  ['RightShoulder', 'Core'],
  ['LeftShoulder', 'Core'],
];
const STUBS = [['LeftHeel', 'LeftAnkle'], ['RightHeel', 'RightAnkle']];

const joint = (pose, player, name) => {
  const o = (player * JOINTS.length + JOINTS.indexOf(name)) * 3;
  return { x: pose[o], y: pose[o + 1], z: pose[o + 2] };
};

// the camera: turn the pair about the vertical axis until blue stands to the right of red, then look along z
// (orthographic side view). The turn is taken from the picture's first frame, so a transition does not swing about.
export function orient(frames) {
  const a = joint(frames[0], 0, 'Head'), b = joint(frames[0], 1, 'Head');
  const turned = Math.atan2(b.x - a.x, b.z - a.z) - Math.PI / 2; // yrot takes the pair's own angle to +x
  const rot = (v) => ({ x: Math.cos(turned) * v.x - Math.sin(turned) * v.z, y: v.y, z: Math.sin(turned) * v.x + Math.cos(turned) * v.z });
  const mirror = rot(b).x < rot(a).x ? -1 : 1;
  return (pose, player, name) => {
    const v = rot(joint(pose, player, name));
    return { x: mirror * v.x, y: v.y, z: v.z };
  };
}

// fit every frame of a picture into the 512 box, keeping the aspect ratio
export function project(frames) {
  const at = orient(frames);
  const drawn = frames.map((pose) => [0, 1].map((player) => ({
    head: at(pose, player, 'Head'),
    joints: Object.fromEntries(JOINTS.map((n) => [n, at(pose, player, n)])),
  })));
  let x0 = Infinity, x1 = -Infinity, y0 = Infinity, y1 = -Infinity;
  for (const pair of drawn) for (const fig of pair) for (const v of [fig.head, ...Object.values(fig.joints)]) {
    x0 = Math.min(x0, v.x); x1 = Math.max(x1, v.x); y0 = Math.min(y0, v.y); y1 = Math.max(y1, v.y);
  }
  const w = Math.max(x1 - x0, 0.4), h = Math.max(y1 - y0, 0.4);
  const scale = Math.min((VIEW - 2 * PAD) / w, (VIEW - 2 * PAD) / h);
  const cx = (x0 + x1) / 2, cy = (y0 + y1) / 2;
  const to = (v) => ({ x: +(VIEW / 2 + (v.x - cx) * scale).toFixed(1), y: +(VIEW / 2 - (v.y - cy) * scale).toFixed(1) });
  const box = { x0, x1, y0, y1, scale };
  const out = drawn.map((pair) => pair.map((fig) => {
    // which side of the body is nearer the camera (depth is the world z we look along): its limbs draw solid, the far
    // side fades - the depth cue GrappleMap's own 3D viewer gives
    const depth = (side) => JOINTS.filter((n) => n.startsWith(side)).reduce((q, n) => q + fig.joints[n].z, 0);
    const far = depth('Left') >= depth('Right') ? 'Right' : 'Left';
    const near = far === 'Right' ? 'Left' : 'Right';
    const isSide = (chain, side) => chain.some((n) => n.startsWith(side));
    const chains = (keep) => CHAINS.concat(STUBS).filter(keep).map((c) => c.map((n) => to(fig.joints[n])));
    return {
      head: to(fig.head),
      near: chains((c) => !isSide(c, far)),
      far: chains((c) => isSide(c, far) && !c.every((n) => n.startsWith(near))),
    };
  }));
  return { frames: out, box };
}

const path = (bones) => bones.map((chain) => chain.map((v, i) => `${i ? 'L' : 'M'}${v.x} ${v.y}`).join(' ')).join(' ');
const headRadius = (box) => Math.max(6, Math.min(15, box.scale * 0.05));
const esc = (s) => String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');

// a paper-coloured casing under the bones, so the figure drawn second still reads where the two bodies overlap
function figure(fig, color, cls, r) {
  const bones = (list, width, stroke, opacity) => `<path d="${path(list)}" fill="none" stroke="${stroke}" stroke-width="${width}" stroke-linecap="round" stroke-linejoin="round" stroke-opacity="${opacity}"/>`;
  const drawn = (list, opacity) => (list.length ? bones(list, 13, PAPER, opacity) + bones(list, 7, color, opacity) : '');
  return `<g class="${cls}">${drawn(fig.far, 0.45)}${drawn(fig.near, 1)}` +
    `<circle cx="${fig.head.x}" cy="${fig.head.y}" r="${(r + 3).toFixed(1)}" fill="${PAPER}"/>` +
    `<circle cx="${fig.head.x}" cy="${fig.head.y}" r="${r.toFixed(1)}" fill="${color}"/></g>`;
}

// uid keeps the CSS of one picture out of the way of another when several are inlined on one page
function shell({ uid, title, label, frames, box, frameMs }) {
  const r = headRadius(box);
  const figs = frames.map(([red, blue]) => figure(blue, BLUE, `${uid}-p1`, r) + figure(red, RED, `${uid}-p0`, r));
  const n = figs.length;
  const style = n > 1
    ? `<style>.${uid}-f{opacity:0;animation:${uid}-step ${frameMs * n}ms steps(1,end) infinite}` +
      `${figs.map((_, i) => `.${uid}-f${i}{animation-delay:${-frameMs * i}ms}`).join('')}` +
      `@keyframes ${uid}-step{0%{opacity:1}${(100 / n).toFixed(4)}%{opacity:0}}</style>`
    : '';
  const floorY = +(VIEW / 2 + ((box.y0 + box.y1) / 2) * box.scale).toFixed(1); // world y = 0 in screen pixels
  const floor = floorY > 8 && floorY < VIEW - 8
    ? `<line class="${uid}-floor" x1="0" y1="${floorY}" x2="${VIEW}" y2="${floorY}" stroke="${GROUND}" stroke-width="2" stroke-dasharray="6 8"/>`
    : '';
  const groups = figs.map((f, i) => `<g class="${uid}-frame ${uid}-f${i} ${uid}-f">${f}</g>`).join('\n');
  const caption = n > 1 ? `${n} frames` : '1 pose';
  return `<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${VIEW} ${VIEW}" width="${VIEW}" height="${VIEW}" role="img" aria-label="${esc(label)}">
<title>${esc(title)}</title>
<meta name="grapplemap" content="${esc(label)}"/>
<meta name="grapplemap-frames" content="${n}"/>
${style}
<rect width="${VIEW}" height="${VIEW}" fill="${PAPER}" rx="10"/>
${floor}
${groups}
<text x="14" y="${VIEW - 14}" font-family="system-ui,sans-serif" font-size="15" fill="${INK}">${esc(title)}</text>
<text x="${VIEW - 14}" y="${VIEW - 14}" text-anchor="end" font-family="system-ui,sans-serif" font-size="12" fill="#8a8272">${esc(caption)} · red vs blue · side view</text>
</svg>`;
}

// one pose: a still picture
export function positionSvg({ title, pose, label = 'position' }) {
  const { frames, box } = project([pose]);
  return shell({ uid: label, title, label, frames, box, frameMs: 0 });
}

// a transition: its N frames in one SVG, stepped by CSS
export function transitionSvg({ title, frames, label = 'transition', frameMs = 260 }) {
  const { frames: drawn, box } = project(frames);
  return shell({ uid: label, title, label, frames: drawn, box, frameMs });
}

// read a rendered SVG back: every drawn point, grouped by figure. The test uses this, so it checks the file, not a guess.
export function svgPoints(svg) {
  const out = { p0: [], p1: [] };
  for (const m of svg.matchAll(/<g class="[\w-]*?-(p[01])">([\s\S]*?)<\/g>/g)) {
    const [, cls, body] = m;
    for (const d of body.matchAll(/ d="([^"]*)"/g)) {
      for (const p of d[1].matchAll(/[ML](-?[\d.]+) (-?[\d.]+)/g)) out[cls].push({ x: +p[1], y: +p[2] });
    }
    for (const c of body.matchAll(/<circle cx="(-?[\d.]+)" cy="(-?[\d.]+)"/g)) out[cls].push({ x: +c[1], y: +c[2] });
  }
  return out;
}

// node render2d.mjs <position|transition> <index> [outfile] - one picture from the fetched GrappleMap.txt
if (process.argv[1] && process.argv[1].endsWith('render2d.mjs')) {
  const [kind, id, file] = process.argv.slice(2);
  const { readGrappleMap } = await import('./parse.mjs');
  const g = readGrappleMap();
  const rec = kind === 'position' ? g.positions[+id] : g.transitions[+id];
  if (!rec) throw new Error(`no such ${kind}: ${id}`);
  const svg = kind === 'position'
    ? positionSvg({ title: rec.name, pose: rec.pose, label: `p${rec.id}` })
    : transitionSvg({ title: rec.name, frames: rec.frames, label: `t${rec.id}` });
  if (file) {
    (await import('node:fs')).writeFileSync(file, svg);
    console.log(`wrote ${file} (${rec.name})`);
  } else console.log(svg);
}
