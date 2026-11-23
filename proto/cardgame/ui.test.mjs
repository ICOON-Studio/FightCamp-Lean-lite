// The page, played by script. node --test proto/cardgame/   (also run by engine.test.mjs's link smoke)
import test from 'node:test';
import assert from 'node:assert/strict';
import { CARDS, N, fighter, STYLES } from './cards.mjs';
import { newBout, startAct, declare, endAct, answerOptions, bout, clone } from './engine.mjs';
import { actions } from './plan.mjs';
import { names, cardText, card, previewTraining, esc, printedProblems, answerTable, rangeStrip, howtoLines } from './ui-text.mjs';
import { guideLines, volleyThreat, threatLine } from './guide.mjs';
import { TRAINING, RUNGS, TITLE_SHOT, CUT_AT_LOSSES, freshCareer, takesTitle, rivalFighter, rivalPilot, playerFighter } from './career.mjs';
import { install } from './uidom.mjs';

const p = install();
const ui = await import('./ui.js');
const { state, copyPlayLog, oneCardFirstVolley } = ui;
const enabled = (sel) => p.screen.querySelectorAll(sel).filter((b) => !b.disabled);
const click = (sel) => { const b = p.screen.querySelector(sel); assert.ok(b, 'the page offers ' + sel); b.click(); return b; };
function pick(style) { click('[data-style="' + style + '"]'); }
// play the human's turns until the verdict: the coach's line first (round 8), then the first card it may lay, else the
// first answer, else end the turn
function playBout() {
  for (let guard = 0; guard < 4000; guard++) {
    const gotit = p.screen.querySelector('#gotit'); // the coach speaks at the verdict too, if a line is still unsaid
    if (gotit) { gotit.click(); continue; }
    if (p.screen.querySelector('#trainNext')) return;
    const b = ['[data-answer]', '[data-card]', '[data-floor]'].map((sel) => enabled(sel)[0]).find(Boolean);
    if (b) { b.click(); continue; }
    const end = p.screen.querySelector('#endTurn');
    if (end && !end.disabled) { end.click(); continue; }
    assert.fail('the page is stuck with nothing to click:\n' + p.screen.innerHTML.slice(0, 400));
  }
  assert.fail('the bout never reached a verdict');
}

test('the two engine answers have words: the page used to die looking them up in CARDS', () => {
  assert.equal(CARDS['@cover'], undefined); assert.equal(CARDS['@break'], undefined);
  assert.equal(names('@cover'), 'Cover up'); assert.equal(names('@break'), 'Break free');
  assert.match(cardText('@cover'), /Cover up/); assert.match(cardText('@break'), /Break free/);
  for (const id of ['@in', '@out', '@stand', '@up', '@pull']) assert.doesNotThrow(() => cardText(id), id);
  for (const s of STYLES) for (const id of fighter(s).deck) { assert.doesNotThrow(() => cardText(id), s + ' ' + id); assert.ok(cardText(id).length > 8, id); }
  for (const s of STYLES) for (const o of TRAINING[s]) assert.doesNotThrow(() => previewTraining(o), o.id);
  assert.doesNotThrow(() => card('jab'));
});

test('the page links and renders the art pick (round 7 opening: two fighters, two lines each)', () => {
  assert.match(p.where.textContent, /PICK YOUR FIGHTER/i);
  assert.equal(p.screen.querySelectorAll('[data-style]').length, 2);
  assert.match(p.screen.innerHTML, /card ladder/i);
  // the first-10-minutes script, minute 0:00: each fighter says where he wins and his one rule
  assert.match(p.screen.innerHTML, /Where he wins:/); assert.match(p.screen.innerHTML, /His one rule:/);
  assert.match(p.screen.innerHTML, /combinations/i); assert.match(p.screen.innerHTML, /the guard/i);
});

test('the page plays a whole bout and a ladder step by script', () => {
  pick('boxing');
  assert.equal(state.career.style, 'boxing'); assert.equal(state.career.rung, 0);
  assert.match(p.screen.innerHTML, /Training turn/);
  click('[data-train="jab"]'); // one training turn: the card is upgraded in place, one card in, one card out
  const deck = state.career.deck; assert.equal(deck.length, 15); assert.ok(deck.includes('jab+1'));
  click('#skip');
  assert.match(p.screen.innerHTML, /His volley, face up|Choose a card or end your turn/, 'the bout is on the table');
  playBout();
  assert.ok(state.result, 'a verdict'); assert.ok(['ko', 'lead', 'tap', 'pin', 'cards', 'points'].includes(state.result.how));
  assert.ok(state.logs.length > 0, 'the fight log has lines');
  assert.equal(state.career.bouts, 1); assert.ok(p.screen.innerHTML.includes('Victory') || p.screen.innerHTML.includes('Defeat'));
  const rungAfter = state.career.rung, rankAfter = state.career.rank;
  click('#trainNext'); // the ladder step: verdict -> training -> the next bout
  assert.match(p.screen.innerHTML, /Training turn/);
  click('#skip');
  assert.match(p.screen.innerHTML, /His volley, face up|Choose a card or end your turn/, 'the second bout is on the table');
  assert.equal(state.career.bouts, 1); assert.equal(state.career.rank, rankAfter); assert.equal(state.career.rung, rungAfter);
});

test('a win at the title shot takes the title; the defences are defences', () => {
  // the belt is won at the TITLE SHOT, read off the rung before resultCareer moves it
  for (const [rung, won, want] of [[TITLE_SHOT, true, true], [TITLE_SHOT, false, false], [TITLE_SHOT - 1, true, false], [TITLE_SHOT + 1, true, false], [RUNGS.length - 1, true, false]]) {
    const c = freshCareer('boxing'); c.rung = rung;
    assert.equal(takesTitle(c, won), want, `${RUNGS[rung]} ${won ? 'won' : 'lost'}`);
  }
  // and the page says so: an overpowered deck at the title shot wins, and the verdict is the title
  ui.reset(); pick('boxing');
  state.career.rung = TITLE_SHOT;
  CARDS.titlehit = { ...CARDS.cross, n: 'The bell ringer', dmg: 99, w: 1, L: '', at: ['K', 'P', 'C', 'G'] };
  state.career.deck = Array(15).fill('titlehit');
  click('#skip');
  playBout();
  assert.equal(state.result.winner, 0, 'the overpowered deck wins');
  assert.match(state.note, /TAKE THE TITLE/);
  assert.equal(state.champion, true, 'he holds the belt at the defence rung');
  assert.ok(state.career.rung > TITLE_SHOT, 'the ladder moved him onto a defence');
  assert.match(p.screen.innerHTML, /Defend the title/);
});

test('the career ends at the last defence won, not before: a win at defence 2 is a defence 3 to come', () => {
  ui.reset(); pick('boxing');
  CARDS.titlehit = { ...CARDS.cross, n: 'The bell ringer', dmg: 99, w: 1, L: '', at: ['K', 'P', 'C', 'G'] };
  // a title defence rival's sweep scores seven at once: the corner carries sprawls to stop it, and bells otherwise
  state.career.deck = Array(8).fill('sprawl').concat(Array(7).fill('titlehit'));
  state.career.rung = RUNGS.length - 2; state.champion = true;
  // this corner reads the table: it sprawls the sweep and breaks the hold before it lays a card
  const readFirst = () => { for (let g = 0; g < 4000; g++) { const gotit = p.screen.querySelector('#gotit'); if (gotit) { gotit.click(); continue; } if (p.screen.querySelector('#trainNext')) return; const stop = enabled('[data-answer]').find((b) => ['sprawl', 'escape', '@break'].includes(b.dataset.id)); const b = stop || ['[data-card]', '[data-floor]', '[data-answer]'].map((sel) => enabled(sel)[0]).find(Boolean); if (b) { b.click(); continue; } const end = p.screen.querySelector('#endTurn'); if (end && !end.disabled) { end.click(); continue; } assert.fail('the page is stuck'); } assert.fail('the bout never reached a verdict'); };
  click('#skip'); readFirst();
  assert.equal(state.result.winner, 0); assert.equal(state.complete, false, 'defence 2 won: the career goes on'); assert.equal(state.career.rung, RUNGS.length - 1);
  assert.match(p.screen.innerHTML, /Defend the title/);
  click('#trainNext'); click('#skip'); readFirst();
  assert.equal(state.result.winner, 0); assert.equal(state.complete, true, 'defence 3 won: the career is complete'); assert.match(p.screen.innerHTML, /Start another career/);
});

test('a career ends at the cut, and the page offers another one', () => {
  ui.reset(); pick('bjj');
  state.career.rung = 1; state.career.losses = CUT_AT_LOSSES - 1; // the Area rival is the other art, a boxer who hits (a club novice of his own art could only coin-flip this deck)
  state.career.deck = Array(15).fill('sprawl'); // a corner that can only defend cannot win
  click('#skip');
  playBout();
  assert.equal(state.result.winner, 1, 'he lost the bout');
  assert.equal(state.career.losses, CUT_AT_LOSSES);
  assert.equal(state.cut, true);
  assert.match(state.note, /cuts you/);
  assert.match(p.screen.innerHTML, /Start another career/);
  click('#newCareer');
  assert.equal(p.screen.querySelectorAll('[data-style]').length, 2, 'the page goes back to the art pick');
});

test('a rival is the other art with better cards at every rung, and a club novice is the weakest', () => {
  const c = freshCareer('boxing');
  const decks = RUNGS.map((_, rung) => rivalFighter(c, rung).deck);
  for (const [i, d] of decks.entries()) { assert.equal(d.length, 15, 'rung ' + i); assert.ok(d.every((id) => CARDS[id]), 'rung ' + i); }
  assert.notDeepEqual(decks[0], decks[1], 'the club novice is not the area fighter');
  assert.notDeepEqual(decks[2], decks[3], 'the national fighter is not the title shot');
  assert.ok(decks[6].some((id) => id.includes('+')), 'a title defence rival carries upgraded cards');
});

// ---- round 7: the PLAY gate (plan section 7) -----------------------------------------------

test('the printed numbers equal the engine\'s: every card line, step line and training preview', () => {
  const { checked, problems } = printedProblems();
  assert.ok(checked >= 40, `checked ${checked} printed numbers`);
  assert.deepEqual(problems, [], problems.join('\n'));
});

test('the play log has every decision with its seconds, the copy button returns it, and it ends where the player stopped', () => {
  ui.reset(); pick('bjj');
  assert.match(p.where.textContent, /TRAINING/);
  click('#skip');
  assert.match(p.screen.innerHTML, /His volley, face up|Choose a card or end your turn/, 'the bout is on the table');
  playBout();
  assert.ok(p.screen.querySelector('#copyLog'), 'the verdict offers the copy button');
  p.screen.querySelector('#copyLog').click();
  const text = state.lastLogText;
  assert.ok(text && text.startsWith('FightCamp card ladder - play log'), 'the copy button put the log on the table');
  assert.match(text, /\[pick\s*\] picked the BJJ man \(the guard\)/);
  assert.match(text, /\[training\s*\] skipped training/);
  assert.match(text, /\[bout\s*\] bout 1 starts: Club challenger, his first volley is one card/);
  assert.match(text, /\[bout\s*\] the bout ended: /);
  assert.match(text, /\[verdict\s*\] verdict: /);
  // every line of the log carries its seconds and its phase
  for (const line of text.split('\n').slice(1)) assert.match(line, /^\s*\d+(\.\d+)? s  \[\w+\s*\] /, line);
  // where the player stopped is the last line
  p.screen.querySelector('#newCareer').click();
  assert.match(copyPlayLog(), /\[stopped\s*\] the player left the career \(New career\) at verdict/);
});

test('the first bout: the rival\'s first volley is one card, his later volleys are the full line', () => {
  // the pure limit, tested directly: the pilot wants three cards, the player sees one, then the full line resumes
  const base = { name: 'stub', answer: () => null, act: () => ['jab', 'cross', 'hook'] };
  const flag = { on: true, full: null, declared: null };
  const rival = oneCardFirstVolley(base, flag);
  assert.deepEqual(rival.act(null, 1), ['jab'], 'the first volley is one card');
  assert.equal(flag.full, 3, 'the pilot wanted his full line');
  assert.equal(flag.declared, 1, 'one card was declared');
  assert.deepEqual(rival.act(null, 1), ['jab', 'cross', 'hook'], 'his next volley is the full line');
  assert.deepEqual(oneCardFirstVolley(base, { on: false, full: null, declared: null }).act(null, 1), ['jab', 'cross', 'hook'], 'a later bout is not limited');
  // and on the page: in bout 1 the rival declares at most one card
  ui.reset(); pick('boxing');
  click('#skip');
  playBout();
  assert.ok(state.volleyFlag.full !== null, 'the rival threw his first volley in bout 1');
  assert.ok(state.volleyFlag.declared <= 1, `the first volley is one card, not ${state.volleyFlag.declared}`);
});

test('the verdict says in one line why the bout ended, and the line matches the finish', () => {
  for (const style of ['boxing', 'bjj']) {
    ui.reset(); pick(style);
    click('#skip');
    playBout();
    const r = state.result;
    assert.ok(state.why, style + ': a why line');
    const expect = { ko: /health reached 0/, lead: /ahead by \d+ points/, tap: /tapped out/, pin: /hold-down/, cards: /judges counted/, points: /judges counted/ }[r.how];
    assert.match(state.why, expect, `${style} ${r.how}: ${state.why}`);
    assert.ok(p.screen.innerHTML.includes(esc(state.why)), 'the why line is on the verdict screen');
  }
});

// ---- round 8: the guide (TASK CARDROUND8) ---------------------------------------------------

test('the guide: the first bout shows each coach line exactly once, in order, each pointing at its element; bout 2 shows none', () => {
  ui.reset(); pick('boxing');
  assert.equal(state.guide, true, 'the guide is on for a new career');
  click('#skip');
  const targets = [];
  for (let guard = 0; guard < 4000; guard++) {
    const gotit = p.screen.querySelector('#gotit'); // the coach speaks at the verdict too, if a line is still unsaid
    if (gotit) { // the coach's line points at an element: that element carries coach-target
      const m = /<[a-z]+([^>]*class="[^"]*coach-target[^"]*"[^>]*)>/.exec(p.screen.innerHTML);
      assert.ok(m, 'a coach line is on screen with its element highlighted');
      targets.push(/id="([^"]+)"/.exec(m[1])[1]);
      gotit.click(); continue;
    }
    if (p.screen.querySelector('#trainNext')) break;
    const b = ['[data-answer]', '[data-card]', '[data-floor]'].map((sel) => enabled(sel)[0]).find(Boolean);
    if (b) { b.click(); continue; }
    const end = p.screen.querySelector('#endTurn');
    if (end && !end.disabled) { end.click(); continue; }
    assert.fail('the page is stuck with nothing to click');
  }
  assert.deepEqual(state.guideSeen, ['volley', 'wind', 'range', 'lay', 'win', 'bell'], 'each line once, in the brief\'s order');
  assert.deepEqual(targets, ['volleysheet', 'wind', 'range', 'hand', 'score', 'rounds'], 'each line points at its element');
  // each line is in the play log, with its seconds and its phase
  const log = copyPlayLog();
  const coach = log.split('\n').filter((l) => /\[coach\s*\]/.test(l));
  assert.equal(coach.length, 6, 'six coach lines in the log');
  for (const [i, id] of ['volley', 'wind', 'range', 'lay', 'win', 'bell'].entries()) {
    const line = guideLines().find((l) => l.id === id);
    assert.ok(coach[i].includes(`coach: ${line.title}`), coach[i]);
  }
  // bout 2: the guide is off, so no line is said
  click('#trainNext');
  assert.equal(state.guide, false, 'the guide is off after the first bout');
  click('#skip');
  const before = state.guideSeen.length;
  playBout();
  assert.equal(state.guideSeen.length, before, 'no coach line in bout 2');
});

test('the guide\'s lines are generated from the engine\'s numbers: no number is typed into the text', () => {
  const lines = guideLines();
  assert.equal(lines.length, 6);
  assert.deepEqual(lines.map((l) => l.id), ['volley', 'wind', 'range', 'lay', 'win', 'bell']);
  const numbers = new Set([N.back, N.cap, N.stepW, N.hp, N.lead, N.rounds, N.turns].map(String));
  for (const l of lines) for (const d of l.text.match(/\d+/g) || []) assert.ok(numbers.has(d), `${l.id}: the number ${d} is not one of the engine's`);
  const by = Object.fromEntries(lines.map((l) => [l.id, l.text]));
  assert.ok(by.wind.includes(`${N.back} comes back`) && by.wind.includes(`up to ${N.cap}`), 'the wind line carries the refill and the cap');
  assert.ok(by.range.includes(`Step in costs ${N.stepW} wind`) && by.range.includes(`Step out costs ${N.stepW} wind`), 'the strip line carries the step prices');
  assert.ok(by.win.includes(`Health is ${N.hp}`) && by.win.includes(`a points lead of ${N.lead}`), 'the win line carries health and the lead');
  assert.ok(by.bell.includes(`${N.rounds} rounds of ${N.turns} turns`), 'the bell line carries the rounds and the turns');
  // and the lines follow the engine: change a number, the words change
  const lead = N.lead, turns = N.turns;
  N.lead = 99; N.turns = 3;
  try {
    const t = Object.fromEntries(guideLines().map((l) => [l.id, l.text]));
    assert.ok(t.win.includes('a points lead of 99'), 'the lead is read when the line is spoken');
    assert.ok(t.bell.includes('rounds of 3 turns'), 'the turns are read when the line is spoken');
  } finally { N.lead = lead; N.turns = turns; }
});

test('the low-health warning shows when and only when the laid volley would knock you out', () => {
  // a table built by hand: he lays two Uppercuts, then the player's health decides the warning
  const S = newBout(fighter('boxing'), fighter('boxing'), 11);
  S.pos = 'P'; S.f[1].hand = ['upper', 'upper', 'upper', 'upper', 'upper']; S.f[1].wind = 20;
  startAct(S); declare(S, 1, 'upper'); declare(S, 1, 'upper'); endAct(S, 1);
  const opts = answerOptions(S, 0);
  S.f[0].hp = 5;
  const ko = volleyThreat(S, 0);
  assert.equal(ko.ko, true, 'two Uppercuts take 5 health to 0');
  assert.equal(threatLine(ko), 'This volley knocks you out unless you answer.');
  assert.match(answerTable(S, opts), /class="warn"[^>]*>This volley knocks you out unless you answer/);
  S.f[0].hp = 20;
  const low = volleyThreat(S, 0);
  assert.equal(low.ko, false); assert.equal(low.low, true, 'under a quarter of the engine\'s health');
  assert.match(answerTable(S, opts), /under a quarter of your health/);
  S.f[0].hp = N.hp;
  assert.equal(volleyThreat(S, 0).ko, false); assert.equal(volleyThreat(S, 0).low, false);
  assert.doesNotMatch(answerTable(S, opts), /class="warn"/, 'no warning when the volley cannot knock you out');
  // and on the page, in the answer phase, the warning is in red exactly then
  state.career = freshCareer('boxing'); state.career.bouts = 1; state.guide = false; state.fight = S; state.humanPhase = 'answer'; state.logs = [];
  S.f[0].hp = 5; ui.renderFight(opts);
  assert.match(p.screen.innerHTML, /class="warn"[^>]*>This volley knocks you out unless you answer/);
  S.f[0].hp = N.hp; ui.renderFight(opts);
  assert.doesNotMatch(p.screen.innerHTML, /class="warn"/);
});

test('the How to play button is on every screen, and its page holds the guide\'s six lines and a small picture of the strip', () => {
  ui.reset();
  assert.ok(p.screen.querySelector('#howto'), 'the pick screen');
  click('#howto');
  assert.match(p.where.textContent, /HOW TO PLAY/);
  const items = p.screen.querySelectorAll('[data-line]');
  assert.equal(items.length, guideLines().length, 'the page has the guide\'s lines');
  assert.ok(items.length <= 10, 'the rules in ten lines or fewer');
  for (const l of guideLines()) assert.ok(p.screen.innerHTML.includes(esc(l.text)), l.id + ' is on the page, in the coach\'s words');
  for (const w of ['KICK', 'PUNCH', 'CLINCH', 'GROUND']) assert.ok(p.screen.innerHTML.includes('>' + w + '<'), 'the picture of the strip shows ' + w);
  assert.match(rangeStrip(null, 'picture'), /KICK/, 'the picture is the strip');
  assert.equal((howtoLines().match(/class="howto-line"/g) || []).length, guideLines().length);
  click('#back');
  assert.equal(p.screen.querySelectorAll('[data-style]').length, 2, 'back to the pick');
  pick('boxing');
  assert.ok(p.screen.querySelector('#howto'), 'the training screen');
  click('#skip');
  assert.ok(p.screen.querySelector('#howto'), 'the fight screen');
  playBout();
  assert.ok(p.screen.querySelector('#howto'), 'the verdict');
});

test('the guide switch: on for a new career, off after the first bout, and it turns the coach off', () => {
  ui.reset();
  assert.equal(state.guide, true, 'a new career starts with the guide on');
  pick('boxing'); click('#skip'); playBout();
  click('#trainNext');
  assert.equal(state.guide, false, 'off after the first bout');
  click('#howto');
  assert.match(p.screen.innerHTML, /Coach lines: OFF/);
  click('#back');
  // the switch off before the bout: the coach says nothing
  ui.reset(); pick('boxing');
  click('#howto'); click('#guideSwitch');
  assert.equal(state.guide, false);
  assert.match(p.screen.innerHTML, /Coach lines: OFF/);
  click('#back'); click('#skip');
  assert.doesNotMatch(p.screen.innerHTML, /id="coach"/, 'no coach line with the switch off');
  playBout();
  assert.deepEqual(state.guideSeen, [], 'no line was said');
});

test('the first bout is against the other art at the softest club deck, and his corner plays his art', () => {
  for (const style of ['boxing', 'bjj']) {
    const c = freshCareer(style), F = rivalFighter(c, 0);
    assert.equal(F.style, style === 'boxing' ? 'bjj' : 'boxing', 'the other art');
    assert.equal(F.deck.length, 15); assert.ok(F.deck.every((id) => CARDS[id]), 'a legal deck');
    assert.ok(!F.deck.some((id) => id.includes('+')), 'a novice has no upgraded cards');
    assert.equal(rivalPilot(0, c).name, 'scripted ' + F.style, 'his corner plays his art\'s own line');
  }
  // and on the page: the first bout\'s rival is the other art, and he leads, so the coach\'s first line has its moment
  ui.reset(); pick('boxing'); click('#skip');
  assert.equal(state.fight.f[1].style, 'bjj');
  assert.equal(state.first, 1, 'the rival leads the first bout');
  assert.equal(state.humanPhase, 'answer', 'his volley is on screen first');
});

test('the first bout is not lost by a knockout before the coach\'s last line', () => {
  // the page\'s own scripted player on the engine. The boxer\'s first rival is the other art\'s novice, who has no
  // strike, so the boxer cannot be knocked out at all; a BJJ player who sits to guard is not knocked out in round one.
  const pageLine = { answer: (S, m, opts) => opts.find((o) => o) || null,
    act: (S, m) => { const C = clone(S), seq = []; for (;;) { const a = actions(C, m); const id = a.find((x) => x[0] !== '@') || a.find((x) => x[0] === '@'); if (!id) break; declare(C, m, id); seq.push(id); if (seq.length >= 9) break; } return seq; } };
  const reader = { answer: (S, m, opts) => (S.hold && S.hold.by !== m ? opts.find((o) => o && (o.id === 'escape' || o.id === '@break')) : null) || opts.find((o) => o) || null,
    act: (S, m) => { const C = clone(S), seq = []; for (;;) { const a = actions(C, m); const id = a.find((x) => x[0] !== '@') || (a.includes('@pull') ? '@pull' : a.find((x) => x[0] === '@')); if (!id) break; declare(C, m, id); seq.push(id); if (seq.length >= 9) break; } return seq; } };
  let boxerKo = 0, bjjKoRound1 = 0;
  for (let i = 0; i < 120; i++) {
    const a = freshCareer('boxing', 539 + i * 101), b = bout(playerFighter(a), rivalFighter(a, 0), [pageLine, rivalPilot(0, a)], a.seed + 1);
    if (b.S.f[0].hp <= 0) boxerKo++;
    const c = freshCareer('bjj', 539 + i * 101), d = bout(playerFighter(c), rivalFighter(c, 0), [reader, rivalPilot(0, c)], c.seed + 1);
    if (d.how === 'ko' && d.win === 1 && d.S.round === 0) bjjKoRound1++;
  }
  assert.equal(boxerKo, 0, 'the boxer is never knocked out by the other art\'s novice');
  assert.equal(bjjKoRound1, 0, 'the BJJ player is not knocked out in round one');
});
