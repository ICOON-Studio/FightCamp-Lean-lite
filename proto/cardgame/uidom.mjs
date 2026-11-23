// A stand-in for the DOM, for node: it parses the HTML the page writes and hands back its interactive elements.
// Not a browser: no layout, no styles, no real events. Enough to click the page's own buttons and read what it wrote.
const ATTR = /([a-zA-Z_:][-\w:.]*)(?:="([^"]*)")?/g;
const camel = (k) => k.slice(5).replace(/-([a-z])/g, (_, c) => c.toUpperCase());
class El {
  constructor(tag, attrs = {}, text = '') {
    this.tag = tag; this.attrs = attrs; this.dataset = {}; this.onclick = null; this._text = text; this._html = '';
    this.disabled = 'disabled' in attrs;
    for (const [k, v] of Object.entries(attrs)) if (k.startsWith('data-')) this.dataset[camel(k)] = v;
  }
  get id() { return this.attrs.id || ''; }
  get className() { return this.attrs.class || ''; }
  set className(v) { this.attrs.class = v; }
  get textContent() { return this._text; }
  set textContent(v) { this._text = String(v); }
  get innerHTML() { return this._html; }
  set innerHTML(v) { this._html = String(v); this.nodes = parse(this._html); }
  querySelector(sel) { return this.querySelectorAll(sel)[0] || null; }
  querySelectorAll(sel) { return (this.nodes || []).filter((el) => matches(el, sel)); }
  click() { if (this.onclick) this.onclick({ currentTarget: this }); return this; }
}
function matches(el, sel) {
  if (sel[0] === '#') return el.id === sel.slice(1);
  let m = /^\[([\w-]+)\]$/.exec(sel);
  if (m) return m[1] in el.attrs;
  m = /^\[([\w-]+)="([^"]*)"\]$/.exec(sel);
  if (m) return el.attrs[m[1]] === m[2];
  m = /^([a-zA-Z][\w-]*)(\.[\w-]+)?$/.exec(sel);
  if (m) return el.tag === m[1] && (!m[2] || el.className.split(/\s+/).includes(m[2].slice(1)));
  return false;
}
function parse(html) {
  const out = [];
  for (const m of html.matchAll(/<([a-zA-Z][\w-]*)([^>]*)>/g)) {
    const attrs = {};
    for (const a of m[2].matchAll(ATTR)) attrs[a[1]] = a[2] === undefined ? '' : a[2];
    out.push(new El(m[1], attrs));
  }
  return out;
}
// the two elements the page asks for at import time
export function install() {
  const screen = new El('main', { id: 'screen' }), where = new El('div', { id: 'where' });
  globalThis.document = { querySelector: (sel) => (sel === '#screen' ? screen : sel === '#where' ? where : null) };
  return { screen, where };
}
