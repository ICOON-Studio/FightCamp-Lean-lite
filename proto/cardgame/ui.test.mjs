// The page, played by script. node --test proto/cardgame/   (also run by engine.test.mjs's link smoke)
import test from 'node:test';
import assert from 'node:assert/strict';
import { CARDS, fighter, STYLES } from './cards.mjs';
import { names, cardText, card, previewTraining } from './ui-text.mjs';
import { TRAINING, RUNGS, TITLE_SHOT, CUT_AT_LOSSES, freshCareer, takesTitle, rivalFighter } from './career.mjs';
import { install } from './uidom.mjs';

const p = install();
const ui = await import('./ui.js');
const { state } = ui;
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

test('the page links and renders the art pick', () => {
  assert.match(p.where.textContent, /PICK YOUR ART/i);
  assert.equal(p.screen.querySelectorAll('[data-style]').length, 2);
  assert.match(p.screen.innerHTML, /card ladder/i);
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

test('a career ends at the cut, and the page offers another one', () => {
  ui.reset(); pick('bjj');
  state.career.rung = 0; state.career.losses = CUT_AT_LOSSES - 1;
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
