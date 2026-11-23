// The page, played by script. node --test proto/cardgame/   (also run by engine.test.mjs's link smoke)
import test from 'node:test';
import assert from 'node:assert/strict';
import { CARDS, fighter, STYLES } from './cards.mjs';
import { names, cardText, card, previewTraining, esc, printedProblems } from './ui-text.mjs';
import { TRAINING, RUNGS, TITLE_SHOT, CUT_AT_LOSSES, freshCareer, takesTitle, rivalFighter } from './career.mjs';
import { install } from './uidom.mjs';

const p = install();
const ui = await import('./ui.js');
const { state, copyPlayLog, oneCardFirstVolley } = ui;
const enabled = (sel) => p.screen.querySelectorAll(sel).filter((b) => !b.disabled);
const click = (sel) => { const b = p.screen.querySelector(sel); assert.ok(b, 'the page offers ' + sel); b.click(); return b; };
function pick(style) { click('[data-style="' + style + '"]'); }
// play the human's turns until the verdict: the first card it may lay, else the first answer, else end the turn
function playBout() {
  for (let guard = 0; guard < 4000; guard++) {
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
  assert.match(p.screen.innerHTML, /End turn/);
  playBout();
  assert.ok(state.result, 'a verdict'); assert.ok(['ko', 'lead', 'tap', 'pin', 'cards', 'points'].includes(state.result.how));
  assert.ok(state.logs.length > 0, 'the fight log has lines');
  assert.equal(state.career.bouts, 1); assert.ok(p.screen.innerHTML.includes('Victory') || p.screen.innerHTML.includes('Defeat'));
  const rungAfter = state.career.rung, rankAfter = state.career.rank;
  click('#trainNext'); // the ladder step: verdict -> training -> the next bout
  assert.match(p.screen.innerHTML, /Training turn/);
  click('#skip');
  assert.match(p.screen.innerHTML, /End turn/, 'the second bout is on the table');
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
  const readFirst = () => { for (let g = 0; g < 4000; g++) { if (p.screen.querySelector('#trainNext')) return; const stop = enabled('[data-answer]').find((b) => ['sprawl', 'escape', '@break'].includes(b.dataset.id)); const b = stop || ['[data-card]', '[data-floor]', '[data-answer]'].map((sel) => enabled(sel)[0]).find(Boolean); if (b) { b.click(); continue; } const end = p.screen.querySelector('#endTurn'); if (end && !end.disabled) { end.click(); continue; } assert.fail('the page is stuck'); } assert.fail('the bout never reached a verdict'); };
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

test('a rival is his art with better cards at every rung, and a club novice is the weakest', () => {
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
  assert.match(p.screen.innerHTML, /End turn/);
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
