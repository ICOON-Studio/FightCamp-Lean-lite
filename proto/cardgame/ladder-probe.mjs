import fs from 'node:fs';
import { RUNGS, TRAINING, measureTraining, simulateLadder } from './career.mjs';
const started = Date.now();
const l2 = Object.fromEntries(['boxing', 'bjj'].map((style) => [style, measureTraining(style)]));
const l1 = simulateLadder(100, 600000000, 80);
const report = { barsWritten: 'ops/research/DESIGN_CARDGAME_SCOPE.md §4f', rungCount: RUNGS.length, options: Object.fromEntries(Object.entries(TRAINING).map(([s, a]) => [s, a.map(({ id, cost, fail }) => ({ id, cost, failure: fail }))])), L1: { runs: l1.runs, titleWins: l1.titleWins, titleRate: +(l1.titleRate * 100).toFixed(1), meanBouts: +l1.meanBouts.toFixed(1), estimatedMeanMinutesAllRuns: +l1.meanMinutes.toFixed(1), titleWinnerMeanBouts: +l1.titleWinnerMeanBouts.toFixed(1), titleWinnerMeanMinutes: +l1.titleWinnerMeanMinutes.toFixed(1), capped: l1.capped, decisionModel: '8 seconds per player decision, from the D1 round-3 time model' }, L2: l2, runtimeSeconds: +((Date.now() - started) / 1000).toFixed(1) };
fs.mkdirSync(new URL('./out/', import.meta.url), { recursive: true });
fs.writeFileSync(new URL('./out/r6ladder.json', import.meta.url), JSON.stringify(report, null, 2) + '\\n');
console.log(JSON.stringify(report, null, 2));
