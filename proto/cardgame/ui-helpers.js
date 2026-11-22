/* FightCamp page helpers: DOM builders and words. No game decisions. */
(function () {
  'use strict';
  var R = window.FightCampRules;
  function h(tag, cls, text) {
    var el = document.createElement(tag);
    if (cls) el.className = cls;
    if (text !== undefined && text !== null) {
      if (text.nodeType === 1) el.appendChild(text); else el.textContent = text;
    }
    return el;
  }
  function clear(el) { while (el.firstChild) el.removeChild(el.firstChild); }
  function add(parent) { for (var i = 1; i < arguments.length; i++) if (arguments[i]) parent.appendChild(arguments[i]); return parent; }
  function bar(cls, ratio) {
    var b = h('div', 'bar ' + cls), i = h('i');
    i.style.width = Math.max(0, Math.min(100, Math.round(ratio * 100))) + '%';
    return add(b, i);
  }
  function meter(label, ratio, cls, word) {
    return add(h('div', 'meter'), h('span', 'lab', label), bar(cls, ratio), h('span', 'val', word));
  }
  function windWord(side) {
    var r = side.stamina / side.maxStamina;
    return side.stamina <= 0 ? 'empty' : r < 0.2 ? 'reeling' : r < 0.45 ? 'breathing hard' : r < 0.75 ? 'working' : 'fresh';
  }
  function headWord(side) { return side.head >= 70 ? 'badly hurt' : side.head >= 40 ? 'hurt' : side.head >= 18 ? 'marked up' : 'clean'; }
  function bodyWord(side) { return side.body >= 60 ? 'body badly hurt' : side.body >= 30 ? 'sore' : side.body >= 10 ? 'working' : 'fresh'; }
  function statWords(key, v) {
    var bands = {
      power: ['feather-fisted', 'ordinary', 'heavy hands', 'one-punch power'],
      speed: ['slow', 'ordinary', 'quick hands', 'lightning'],
      stamina: ['short wind', 'ordinary', 'big engine', 'relentless'],
      chin: ['glass jaw', 'ordinary', 'good chin', 'granite'],
      technique: ['raw', 'ordinary', 'sharp', 'textbook'],
      defence: ['easy to hit', 'ordinary', 'hard to hit', 'elusive']
    };
    var idx = v >= 80 ? 3 : v >= 66 ? 2 : v >= 52 ? 1 : 0;
    return bands[key][idx];
  }
  function deckCounts(deck) {
    var out = {}, order = [];
    deck.forEach(function (id) { if (!out[id]) { out[id] = 0; order.push(id); } out[id]++; });
    return { out: out, order: order };
  }
  function deckPeek(deck, extra) {
    var wrap = h('div', 'deckpeek'), c = deckCounts(deck);
    c.order.forEach(function (id) {
      var n = c.out[id] - ((extra && extra[id]) || 0);
      if (n > 0) wrap.appendChild(h('span', null, R.CARDS[id].name + ' x' + n));
    });
    for (var id in (extra || {})) if (extra[id] > 0) wrap.appendChild(h('span', null, '+' + R.CARDS[id].name + ' x' + extra[id]));
    return wrap;
  }
  function cardFace(id, opts) {
    opts = opts || {};
    var c = R.CARDS[id];
    var el = h(opts.tag || 'button', 'card ' + c.kind + (opts.small ? ' small' : ''));
    if (el.tagName === 'BUTTON') el.type = 'button';
    add(el,
      h('div', 'kind', R.KIND_LABEL[c.kind]),
      h('div', 'name', c.name),
      h('div', 'effect', c.effect),
      h('div', 'cost', String(opts.cost || c.cost)));
    if (opts.onClick) el.addEventListener('click', opts.onClick);
    if (opts.chosen) el.classList.add('chosen');
    return el;
  }
  function button(label, opts) {
    opts = opts || {};
    var b = h('button', 'btn' + (opts.primary ? ' primary' : ''), label);
    b.type = 'button';
    if (opts.onClick) b.addEventListener('click', opts.onClick);
    if (opts.disabled) b.disabled = true;
    return b;
  }
  window.FC = { h: h, clear: clear, add: add, bar: bar, meter: meter, windWord: windWord, headWord: headWord, bodyWord: bodyWord, statWords: statWords, deckCounts: deckCounts, deckPeek: deckPeek, cardFace: cardFace, button: button };
})();
