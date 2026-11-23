// The play log (plan section 7): every decision the player makes, the seconds from the start of the career, and
// where the player stopped. The page keeps it and one button copies it, so "where it dragged" is read from the log,
// not asked. Pure: no document, no game state, so the tests and the probe can import it next to the page.
const nowMs = () => (typeof performance !== 'undefined' ? performance.now() : Date.now());
export function newLog(t0 = nowMs()) { return { t0, entries: [] }; }
export function logEntry(log, phase, text) {
  const e = { t: +((nowMs() - log.t0) / 1000).toFixed(1), phase, text };
  log.entries.push(e);
  return e;
}
// where the player stopped: a career ended (cut, complete, or his New career) is the last line of the log
export function stopAt(log, phase, text) { return logEntry(log, 'stopped', `${text} at ${phase}`); }
export function playLogText(log) {
  const lines = log.entries.map((e) => `${String(e.t).padStart(7)} s  [${e.phase.padEnd(8)}] ${e.text}`);
  return `FightCamp card ladder - play log (seconds from the start of the career)\n${lines.join('\n')}`;
}
