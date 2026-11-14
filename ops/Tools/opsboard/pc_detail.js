// pc_detail.js - the /pc page's watchdog verdict (top) and its lower half (S379, operator: "you have way more info on metrics for the
// pc live"). Reads /api/pc_detail every 6 s - AgentComms/pc_detail.json, written by Tools/pc_metrics.ps1 Write-Detail; nothing is
// measured on a page load - plus the tiles' own /api/pc_metrics reading (window.pcmLatest, set by pc_metrics.js) for the live disks.
//   #pcVerdict  the GREEN / AMBER / RED pill, every reason line exactly as `pc_watchdog.ps1 -Once` printed it, when the colour changed
//   #pcDetail   what is using the PC (top 8 by CPU and by memory, each process named), agents and jobs running, memory + page file,
//               disks + the biggest folders under E:\FightCamp (hourly), heat (10 min with the watchdog's 74 / 84 / 88 C lines)
// No chart library: inline SVG. Colours and lines are the watchdog's (pc_watchdog.ps1 writes its limits into pc_verdict.json).
(function () {
  const css = `
.pcv{margin:12px 0 4px}
.pcv-box{background:var(--panel,#1e1a17);border:1px solid var(--line,#3a332d);border-left:6px solid var(--wait,#8b949e);border-radius:10px;padding:12px 16px}
.pcv-box.pcv-GREEN{border-left-color:var(--run,#3fb950)}.pcv-box.pcv-AMBER{border-left-color:var(--next,#e3b341)}.pcv-box.pcv-RED{border-left-color:var(--out,#f85149)}
.pcv-head{display:flex;gap:16px;align-items:center;flex-wrap:wrap}
.pcv-pill{font-size:22px;font-weight:800;letter-spacing:.06em;padding:6px 18px;border-radius:99px;background:var(--wait,#8b949e);color:#14110f}
.pcv-GREEN .pcv-pill{background:var(--run,#3fb950)}.pcv-AMBER .pcv-pill{background:var(--next,#e3b341)}.pcv-RED .pcv-pill{background:var(--out,#f85149)}
.pcv-when{flex:1;min-width:260px;font-size:15px}
.pcv-rs{margin:10px 0 6px;display:grid;gap:4px}
.pcv-r{display:flex;gap:10px;align-items:baseline;font:13.5px/1.4 ui-monospace,Consolas,monospace}
.pcv-r b{flex:none;width:58px;font-size:11.5px;text-align:center;border-radius:4px;padding:1px 0;color:#14110f;background:var(--wait,#8b949e)}
.pcv-r.pcv-RED b{background:var(--out,#f85149)}.pcv-r.pcv-AMBER b{background:var(--next,#e3b341)}.pcv-r.pcv-GREEN b{background:var(--run,#3fb950)}
.pcv-line{font:11.5px/1.4 ui-monospace,Consolas,monospace;color:var(--dim,#a39a8e);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;margin-top:4px}
.pcd{margin-top:8px}
.pcd-grid{display:grid;grid-template-columns:repeat(12,minmax(0,1fr));gap:12px}
.pcd-c{grid-column:span 4;min-width:0;background:var(--panel,#1e1a17);border:1px solid var(--line,#3a332d);border-radius:8px;padding:11px 13px}
.pcd-c.w6{grid-column:span 6}.pcd-c.w12{grid-column:span 12}
@media (max-width:1180px){.pcd-c,.pcd-c.w6{grid-column:span 12}}
.pcd-c h3{margin:0 0 8px;font-size:14px;display:flex;justify-content:space-between;gap:10px;align-items:baseline}
.pcd-c h3 span{font-size:12px;font-weight:400;color:var(--dim,#a39a8e);white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.pcd-t{width:100%;border-collapse:collapse;table-layout:fixed;font-size:13px;font-variant-numeric:tabular-nums}
.pcd-t th{text-align:left;font-size:11.5px;font-weight:600;color:var(--dim,#a39a8e);padding:2px 6px 4px;border-bottom:1px solid var(--line,#3a332d)}
.pcd-t td{padding:4px 6px;border-bottom:1px solid #2b2520;vertical-align:middle}
.pcd-t tr:last-child td{border-bottom:0}
.pcd-t .n{text-align:right;width:76px;white-space:nowrap}
.pcd-t .w{width:118px;white-space:nowrap}
.pcd-t td.hi{color:var(--ink,#efe9e1);font-weight:700}
.pcd-t td{color:var(--ink,#efe9e1)}.pcd-t td.n:not(.hi){color:var(--dim,#a39a8e)}
.pcd-name{white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.pcd-name small{color:var(--dim,#a39a8e);font-size:12px}
.pcd-bar{height:3px;background:#2b2520;border-radius:99px;margin-top:3px;overflow:hidden}
.pcd-bar i{display:block;height:100%;background:var(--accent,#e0703a);border-radius:99px}
.pcd-k{display:inline-block;font-size:11px;font-weight:700;padding:1px 7px;border-radius:99px;background:#2b2520;color:var(--ink,#efe9e1)}
.pcd-k.film,.pcd-k.render{background:#5a2d17;color:#ffb98a}.pcd-k.test{background:#1d3a4f;color:#9fd2ff}.pcd-k.seat{background:#2f2650;color:#cdb8ff}
.pcd-k.editor,.pcd-k.game{background:#21402a;color:#9be3ae}.pcd-k.other{background:#3a3a3a;color:#d0d0d0}
.pcd-s{font-size:12.5px;color:var(--dim,#a39a8e);margin:3px 0}
.pcd-s b{color:var(--ink,#efe9e1);font-weight:600}
.pcd-v{font-size:22px;font-weight:700;font-variant-numeric:tabular-nums;line-height:1.2}
.pcd-v small{font-size:12.5px;font-weight:400;color:var(--dim,#a39a8e);margin-left:4px}
.pcd-row{display:flex;gap:18px;flex-wrap:wrap;margin-bottom:6px}
.pcd-row>div{min-width:0}
.pcd-plain{margin-top:8px;padding:7px 10px;border-radius:6px;background:#171310;border:1px solid var(--line,#3a332d);font-size:13px}
.pcd-plain.AMBER{border-color:var(--next,#e3b341)}.pcd-plain.RED{border-color:var(--out,#f85149)}
.pcd-meter{position:relative;height:12px;background:#2b2520;border-radius:4px;margin:6px 0 3px;overflow:hidden}
.pcd-meter i{position:absolute;left:0;top:0;bottom:0;background:var(--run,#3fb950)}
.pcd-meter.AMBER i{background:var(--next,#e3b341)}.pcd-meter.RED i{background:var(--out,#f85149)}
.pcd-meter u{position:absolute;top:0;bottom:0;width:2px;background:var(--ink,#efe9e1)}
.pcd-sub{margin-top:10px;padding-top:8px;border-top:1px solid var(--line,#3a332d)}
.pcd-sub h4{margin:0 0 4px;font-size:12px;letter-spacing:.06em;text-transform:uppercase;color:var(--dim,#a39a8e);font-weight:600}
.pcd-f{display:grid;grid-template-columns:minmax(0,1fr) 70px;gap:1px 10px;font-size:13px;font-variant-numeric:tabular-nums}
.pcd-f .n{text-align:right}
.pcd-f .k{grid-column:1 / span 2;font-size:11.5px;color:var(--dim,#a39a8e);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;margin:-1px 0 3px 12px}
.pcd-chart{position:relative;margin-top:6px}
.pcd-chart svg{display:block;width:100%;height:170px;background:#171310;border:1px solid var(--line,#3a332d);border-radius:4px}
.pcd-chart .pl{position:relative;padding-right:30px}
.pcd-chart .lb{position:absolute;right:0;width:27px;font-size:11px;font-weight:700;line-height:1;transform:translateY(-50%)}
.pcd-chart .ax{display:flex;justify-content:space-between;font-size:11px;color:var(--dim,#a39a8e);margin:2px 30px 0 0}
.pcd-chart .lg{display:flex;flex-wrap:wrap;gap:3px 12px;font-size:11.5px;color:var(--dim,#a39a8e);margin-top:4px}
.pcd-chart .lg i{display:inline-block;width:16px;height:0;border-top:2px solid;vertical-align:middle;margin-right:5px}
.pcd-chart .lg i.d{border-top-style:dashed}
.pcd-a{color:var(--next,#e3b341)!important}.pcd-r{color:var(--out,#f85149)!important}.pcd-g{color:var(--run,#3fb950)!important}
.pcd-empty{font-size:13px;color:var(--dim,#a39a8e);padding:4px 0}
.pcd.stale .pcd-grid{opacity:.5}`;
  const st = document.createElement("style"); st.textContent = css; document.head.appendChild(st);

  const esc = s => String(s == null ? "" : s).replace(/[&<>"']/g, c => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c]));
  const num = v => typeof v === "number" && isFinite(v);
  const f0 = v => num(v) ? Math.round(v).toString() : "–";
  const f1 = v => num(v) ? v.toFixed(1) : "–";
  const mb = v => !num(v) ? "–" : v >= 1024 ? (v / 1024).toFixed(1) + " GB" : Math.round(v) + " MB";
  const gbB = v => !num(v) ? "–" : v >= 1e9 ? (v / 1073741824).toFixed(1) + " GB" : Math.round(v / 1048576) + " MB";
  const dur = s => !num(s) ? "–" : s < 90 ? Math.round(s) + " s" : s < 5400 ? Math.round(s / 60) + " min" :
    Math.floor(s / 3600) + " h " + String(Math.round((s % 3600) / 60)).padStart(2, "0") + " min";
  const hhmm = t => { const d = new Date(t * 1000); return String(d.getHours()).padStart(2, "0") + ":" + String(d.getMinutes()).padStart(2, "0"); };
  const lv = (v, w, c, below) => !num(v) ? "" : below ? (v < c ? "RED" : v < w ? "AMBER" : "GREEN") : (v >= c ? "RED" : v >= w ? "AMBER" : "GREEN");
  const tc = s => s === "RED" ? "pcd-r" : s === "AMBER" ? "pcd-a" : "";
  const card = (cls, title, sub, body) => `<div class="pcd-c ${cls}"><h3>${title}<span>${sub || ""}</span></h3>${body}</div>`;

  // ---- 1. the watchdog's verdict (top of the page) --------------------------------------------------------------------------
  function verdictHtml(d) {
    const v = d && d.verdict;
    if (!v) return `<div class="pcv-box"><div class="pcv-head"><span class="pcv-pill">?</span><div class="pcv-when">No watchdog verdict yet ` +
      `(AgentComms/pc_verdict.json is written by every <code>pc_watchdog.ps1 -Once</code>).<div class="pcv-line">${esc((d && d.health) || "")}</div></div></div></div>`;
    const now = Date.now() / 1000, age = d.verdict_age_s, stale = num(age) && age > 180;
    const what = v.state === "RED" ? "RED = do not start a test, render or agent; close what the reasons name."
      : v.state === "AMBER" ? "AMBER = agents and tests may start (operator rule); watch the reasons."
      : "GREEN = free to start work; tests may run 4 at a time.";
    const reasons = (v.reasons || []).map(r => {
      const l = /^RED/.test(r) ? "RED" : "AMBER";
      return `<div class="pcv-r pcv-${l}"><b>${l}</b><span>${esc(r.replace(/^(RED|AMBER)\s+/, ""))}</span></div>`;
    }).join("") || `<div class="pcv-r pcv-GREEN"><b>GREEN</b><span>No reason lines - every reading is under the watchdog's lines.</span></div>`;
    const ch = (v.changes || []).slice(0, 5).map(c => `${esc(String(c.at || "").slice(11, 16))} ${esc(c.from)} &rarr; ${esc(c.to)}`).join(" · ");
    return `<div class="pcv-box pcv-${esc(v.state)}"><div class="pcv-head"><span class="pcv-pill">${esc(v.state)}</span>` +
      `<div class="pcv-when"><b>${esc(v.state)} since ${esc(String(v.since || "").slice(11, 16))}</b> (${dur(now - v.since_t)})${v.prev ? ", before that " + esc(v.prev) : ""}` +
      `<div class="meta">Watchdog verdict from <code>pc_watchdog.ps1 -Once</code>, checked ${dur(age)} ago` +
      `${stale ? ' <b class="pcd-r">- stale: is the heat governor task running?</b>' : " (the heat governor runs it every ~15-40 s)"}. ${what}</div></div></div>` +
      `<div class="pcv-rs">${reasons}</div><div class="pcv-line" title="${esc(v.line)}">${esc(v.line)}</div>` +
      (ch ? `<div class="meta" style="margin-top:4px">Colour changes: ${ch}</div>` : "") + `</div>`;
  }

  // ---- 2. what is using the PC --------------------------------------------------------------------------------------------
  function procTable(rows, by) {
    if (!rows || !rows.length) return `<div class="pcd-empty">No reading yet.</div>`;
    const val = r => by === "cpu" ? r.cpu : r.mb, max = Math.max(1e-9, ...rows.map(val));
    return `<table class="pcd-t"><thead><tr><th>What</th><th class="n">CPU</th><th class="n">Memory</th></tr></thead><tbody>` +
      rows.map(r => `<tr><td><div class="pcd-name" title="${esc(r.l)}${r.n > 1 ? " - " + r.n + " processes" : ""}">${esc(r.l)}${r.n > 1 ? ` <small>(${r.n})</small>` : ""}</div>` +
        `<div class="pcd-bar"><i style="width:${Math.max(0, 100 * val(r) / max).toFixed(1)}%"></i></div></td>` +
        `<td class="n${by === "cpu" ? " hi" : ""}">${f1(r.cpu)}%</td><td class="n${by === "ram" ? " hi" : ""}">${mb(r.mb)}</td></tr>`).join("") + `</tbody></table>`;
  }

  // ---- 3. agents and jobs ------------------------------------------------------------------------------------------------
  const KIND = { film: ["film", "writes a video: GPU + disk"], render: ["render", "draws frames: GPU + disk"], test: ["test", "headless: CPU only"],
    editor: ["editor", "Godot editor: GPU"], game: ["window", "a Godot window: GPU"], seat: ["agent", "agent CLI"], encode: ["encode", "video encode: CPU + disk"],
    other: ["other", "another project's Godot: GPU"] };
  function jobsHtml(d) {
    const now = Date.now() / 1000, runs = d.runs || [], jobs = (d.procs && d.procs.jobs) || [];
    const rr = runs.length ? `<table class="pcd-t"><thead><tr><th class="w">Seat</th><th>Task</th><th class="n">Running</th><th class="n">Due</th></tr></thead><tbody>` +
      runs.map(r => `<tr><td class="w"><span class="pcd-k seat">${esc(r.agent)}</span></td><td><div class="pcd-name" title="${esc(r.title)}"><b>${esc(r.id)}</b> <small>${esc(r.title)}</small></div></td>` +
        `<td class="n hi">${dur(num(r.mins) ? r.mins * 60 : null)}</td><td class="n">${esc(String(r.eta || "").slice(11, 16)) || "–"}</td></tr>`).join("") + `</tbody></table>`
      : `<div class="pcd-empty">No agent run is marked running in live_runs.json.</div>`;
    const jr = jobs.length ? `<table class="pcd-t"><thead><tr><th class="w">Kind</th><th>What</th><th class="n">Running</th><th class="n">CPU</th><th class="n">Memory</th></tr></thead><tbody>` +
      jobs.map(j => { const k = KIND[j.kind] || [j.kind, ""];
        return `<tr><td class="w"><span class="pcd-k ${esc(j.kind)}" title="${esc(k[1])}">${esc(k[0])}</span></td>` +
          `<td><div class="pcd-name" title="${esc(j.l)} - pid ${esc(j.pid)}${j.detail ? " - " + esc(j.detail) : ""}">${esc(j.l)}${j.n > 1 ? ` <small>(${j.n})</small>` : ""}` +
          `${j.detail ? ` <small>&rarr; ${esc(j.detail)}</small>` : ` <small>${esc(k[1])}</small>`}</div></td>` +
          `<td class="n hi">${dur(now - j.start)}</td><td class="n">${f1(j.cpu)}%</td><td class="n">${mb(j.mb)}</td></tr>`; }).join("") + `</tbody></table>`
      : `<div class="pcd-empty">No Godot film, render, test or agent CLI is running.</div>`;
    return `<div class="pcd-sub" style="margin-top:0;padding-top:0;border:0"><h4>Agent runs (live_runs.json)</h4>${rr}</div>` +
      `<div class="pcd-sub"><h4>Doing work now - why the disk or GPU may be busy</h4>${jr}</div>`;
  }

  // ---- 4. memory + page file ---------------------------------------------------------------------------------------------
  function memHtml(m, v) {
    if (!m || !num(m.limit_gb)) return `<div class="pcd-empty">No reading yet.</div>`;
    const lim = v && v.limits ? v.limits : { commit_warn_gb: 8, commit_crit_gb: 4 };
    const pct = 100 * m.commit_gb / m.limit_gb, free = m.limit_gb - m.commit_gb, s = lv(free, lim.commit_warn_gb, lim.commit_crit_gb, true);
    const files = m.files || [], pfGb = files.reduce((a, f) => a + f.alloc_mb, 0) / 1024;
    const grow = files.filter(f => f.max_mb > f.alloc_mb);
    const roomGb = grow.reduce((a, f) => a + (f.max_mb - f.alloc_mb), 0) / 1024;
    const growNames = grow.map(f => f.name).join(" and ");
    const now = Date.now() / 1000, grew = (m.events || []).find(e => e.to_mb > e.from_mb && now - e.t < 3600);
    let plain, pc = "";
    if (grew) { plain = `Commit pushed the page file to grow at ${esc(grew.at)}: ${(grew.from_mb / 1024).toFixed(1)} &rarr; ${(grew.to_mb / 1024).toFixed(1)} GB - Windows took that space from the drive. Close browser tabs or a Godot job to stop it.`; pc = "AMBER"; }
    else if (pct >= 90 && grow.length) { plain = `Commit is at ${f0(pct)}% of its limit - Windows is about to grow ${esc(growNames)} (up to ${roomGb.toFixed(0)} GB more), taking that space from the drive.`; pc = "AMBER"; }
    else if (pct >= 90) { plain = `Commit is at ${f0(pct)}% and the page files cannot grow any more - programs (Godot first) will fail to get memory.`; pc = "RED"; }
    else if (m.commit_gb > m.ram_gb) plain = `Programs have reserved ${f1(m.commit_gb)} GB, ${f1(m.commit_gb - m.ram_gb)} GB more than the RAM holds; the page files back the rest. ` +
      (grow.length ? `${esc(growNames)} grows (up to ${roomGb.toFixed(0)} GB more) only when commit nears the limit - now ${f0(pct)}%, so it is not growing.` : `The page files are fixed in size.`);
    else plain = `Commit fits in the RAM; the page files are not growing.`;
    return `<div class="pcd-row"><div><div class="pcd-v ${tc(s)}">${f1(m.commit_gb)}<small>/ ${f1(m.limit_gb)} GB committed (${f0(pct)}%)</small></div>` +
      `<div class="pcd-s">Free to commit <b class="${tc(s)}">${f1(free)} GB</b> (watchdog: amber &lt; ${lim.commit_warn_gb}, red &lt; ${lim.commit_crit_gb}) · RAM in use <b>${f1(m.used_gb)} / ${f1(m.ram_gb)} GB</b></div></div></div>` +
      `<div class="pcd-meter ${s}" title="committed of the limit; the white line is the RAM (${f1(m.ram_gb)} GB) - past it, the page files hold the rest">` +
      `<i style="width:${Math.min(100, pct).toFixed(1)}%"></i><u style="left:${Math.min(100, 100 * m.ram_gb / m.limit_gb).toFixed(1)}%"></u></div>` +
      `<div class="pcd-s">Limit = RAM ${f1(m.ram_gb)} GB + page files ${pfGb.toFixed(1)} GB</div>` +
      `<div class="pcd-sub"><h4>Page files</h4>` + (files.length ? files.map(f => `<div class="pcd-s"><b>${esc(f.name)}</b> ${(f.alloc_mb / 1024).toFixed(1)} GB now` +
        (f.max_mb > f.alloc_mb ? `, may grow to ${(f.max_mb / 1024).toFixed(0)} GB` : f.max_mb ? ", fixed size" : ", Windows-managed") +
        ` · in use ${mb(f.use_mb)} (peak ${mb(f.peak_mb)})</div>`).join("") : `<div class="pcd-empty">None read yet.</div>`) + `</div>` +
      `<div class="pcd-plain ${pc}">${plain}</div>`;
  }

  // ---- 5. disks + biggest folders -----------------------------------------------------------------------------------------
  function diskHtml(d, v) {
    const pm = window.pcmLatest, lim = v && v.limits ? v.limits : { e_warn_gb: 20, e_crit_gb: 10, c_warn_gb: 15, c_crit_gb: 6, e_write_warn_ms: 100, e_write_crit_ms: 250 };
    const rd = v && v.reading ? v.reading : {};
    let out = "";
    for (const L of ["E:", "C:"]) {
      const info = pm && pm.static && (pm.static.disks || []).find(x => (x.letters || "").split(" ").includes(L));
      const cur = info && pm.latest && (pm.latest.disks || []).find(x => x.n === info.n);
      if (!info || !cur) { out += `<div class="pcd-s">${L} no reading yet</div>`; continue; }
      const isE = L === "E:", used = 100 - cur.free_pct;
      const sFree = isE ? lv(cur.free_gb, lim.e_warn_gb || 20, lim.e_crit_gb || 10, true) : lv(cur.free_gb, lim.c_warn_gb, lim.c_crit_gb, true);
      const sW = isE ? lv(rd.e_write_ms, lim.e_write_warn_ms, lim.e_write_crit_ms) : "";
      out += `<div class="pcd-sub" style="${L === "E:" ? "margin-top:0;padding-top:0;border:0" : ""}"><h4>${L} ${esc(info.model)} (${esc(info.type)})</h4>` +
        `<div class="pcd-v ${tc(sFree)}">${f1(cur.free_gb)}<small>GB free of ${f0(info.size_gb)} GB (${f1(cur.free_pct)}%)</small></div>` +
        `<div class="pcd-meter ${sFree}" title="${f0(used)}% used${isE ? " - the white line is 85% used, E:'s ceiling" : ""}"><i style="width:${used.toFixed(1)}%"></i>${isE ? '<u style="left:85%"></u>' : ""}</div>` +
        (isE ? `<div class="pcd-s">Write delay (watchdog E_write) <b class="${tc(sW)}">${f0(rd.e_write_ms)} ms</b> (amber ${lim.e_write_warn_ms}, red ${lim.e_write_crit_ms}; normal under 5)` +
          `${rd.packers && rd.packers.length ? ` · <b class="pcd-a">git packer: ${esc(rd.packers.join(", "))}</b>` : ""}</div>` : "") +
        `<div class="pcd-s">Now: response <b>${f1(cur.ms)} ms</b> · ${f0(cur.act)}% active · write ${gbB(cur.wr)}/s · read ${gbB(cur.rd)}/s</div>` +
        `<div class="pcd-s">${isE ? `The E: SSD stalls when full (watchdog amber &lt; ${lim.e_warn_gb || 20} GB free, red &lt; ${lim.e_crit_gb || 10} GB).` : `Windows lags when full (amber &lt; ${lim.c_warn_gb} GB, red &lt; ${lim.c_crit_gb} GB).`}</div></div>`;
    }
    const f = d.folders;
    out += `<div class="pcd-sub"><h4>Largest folders under E:\\FightCamp</h4>`;
    if (f && f.top) {
      out += `<div class="pcd-f">` + f.top.slice(0, 5).map(x => `<div class="pcd-name">${esc(x.name)}</div><div class="n"><b>${gbB(x.bytes)}</b></div>` +
        ((x.kids || []).length ? (k3 => `<div class="k" title="${k3}">${k3}</div>`)(x.kids.slice(0, 3).map(k => esc(k.name) + " " + gbB(k.bytes)).join(" · ")) : "")).join("") + `</div>` +
        `<div class="pcd-s">All of E:\\FightCamp: <b>${gbB(f.bytes)}</b> in ${Math.round(f.files / 1000)}k files · measured ${hhmm(f.at)} (hourly, in the background${d.folders_running ? ", measuring now" : ""})</div>`;
    } else out += `<div class="pcd-empty">${d.folders_running ? "Measuring now (background, about a second)…" : "Not measured yet - the sampler measures once an hour."}</div>`;
    return out + `</div>`;
  }

  // ---- 6. heat ------------------------------------------------------------------------------------------------------------
  function heatHtml(h, v) {
    const lim = v && v.limits ? v.limits : { temp_warn_c: 74, temp_crit_c: 84, temp_hard_c: 88, temp_hold_s: 120 };
    const t = (h && h.temps) || [], every = (h && h.every_s) || 2, keep = Math.round(600 / every);
    const vals = t.filter(num), lo = Math.min(50, ...vals.map(x => x - 3)), hi = Math.max(92, ...vals.map(x => x + 3));
    const W = 600, H = 170, y = c => H - ((c - lo) / (hi - lo)) * H, x = i => ((keep - t.length + i) / (keep - 1)) * W;
    let d = "", pen = false;
    t.forEach((c, i) => { if (!num(c)) { pen = false; return; } d += (pen ? "L" : "M") + x(i).toFixed(1) + "," + y(c).toFixed(1); pen = true; });
    const line = (c, col, dash) => `<line x1="0" x2="${W}" y1="${y(c).toFixed(1)}" y2="${y(c).toFixed(1)}" stroke="${col}" stroke-width="1.5"${dash ? ' stroke-dasharray="6 4"' : ""} vector-effect="non-scaling-stroke"/>`;
    // The limit numbers sit in a gutter right of the plot (never over a reading); the legend under it says what each line means.
    const lab = (c, col) => `<span class="lb" style="top:${(100 * y(c) / H).toFixed(1)}%;color:${col}">${c}</span>`;
    const leg = (col, dash, text) => `<span><i class="${dash ? "d" : ""}" style="border-color:${col}"></i>${text}</span>`;
    const sNow = lv(h && h.now, lim.temp_warn_c, lim.temp_crit_c), sPk = lv(h && h.peak, lim.temp_warn_c, lim.temp_crit_c);
    const svg = `<svg viewBox="0 0 ${W} ${H}" preserveAspectRatio="none" aria-label="CPU temperature, last 10 minutes">` +
      line(lim.temp_warn_c, "#e3b341", true) + line(lim.temp_crit_c, "#f85149", false) + line(lim.temp_hard_c, "#ff7b72", true) +
      (d ? `<path d="${d}" fill="none" stroke="#e0703a" stroke-width="2" vector-effect="non-scaling-stroke"/>` : "") + `</svg>`;
    return `<div class="pcd-row"><div><div class="pcd-s">CPU now</div><div class="pcd-v ${tc(sNow)}">${f0(h && h.now)}<small>°C</small></div></div>` +
      `<div><div class="pcd-s">10-min peak</div><div class="pcd-v ${tc(sPk)}">${f0(h && h.peak)}<small>°C${h && num(h.peak_ago_s) ? ", " + dur(h.peak_ago_s) + " ago" : ""}</small></div></div></div>` +
      `<div class="pcd-chart"><div class="pl">${svg}${lab(lim.temp_hard_c, "#ff7b72")}${lab(lim.temp_crit_c, "#f85149")}${lab(lim.temp_warn_c, "#e3b341")}</div>` +
      `<div class="ax"><span>-10 min</span><span>-5 min</span><span>now</span></div>` +
      `<div class="lg">${leg("#e0703a", false, "CPU °C")}${leg("#ff7b72", true, lim.temp_hard_c + " °C hard stop")}${leg("#f85149", false, lim.temp_crit_c + " °C limit, RED if held " + Math.round(lim.temp_hold_s / 60) + " min")}${leg("#e3b341", true, lim.temp_warn_c + " °C amber")}</div></div>` +
      `<div class="pcd-s" style="margin-top:6px">Heat governor (every 15 s): on RED it pauses the newest Godot job, resumes it 60 s after RED clears. ` +
      `Holding <b class="${h && h.held ? "pcd-a" : ""}">${h ? h.held : 0}</b> job${h && h.held === 1 ? "" : "s"} now.</div>` +
      (h && h.gov ? `<div class="pcv-line" title="${esc(h.gov)}">last action: ${esc(h.gov)}</div>` : "");
  }

  function draw(d) {
    const top = document.getElementById("pcVerdict"), box = document.getElementById("pcDetail");
    if (top) top.innerHTML = d && d.verdict !== undefined ? verdictHtml(d) : `<div class="pcv-box"><b class="pcd-r">${esc((d && d.why) || "no reading from /api/pc_detail")}</b></div>`;
    if (!box) return;
    if (!d || !d.procs) { box.innerHTML = `<h2>More detail</h2><div class="meta pcd-r">${esc((d && d.why) || "no reading from /api/pc_detail")}</div>`; return; }
    box.classList.toggle("stale", !d.ok);
    const v = d.verdict, p = d.procs;
    const cpuNote = `share of all ${p.ncpu || 16} threads (Task Manager's CPU), over the last ${f0(p.span_s)} s · ${p.n} processes`;
    box.innerHTML = `<h2>What is using the PC</h2><div class="pcd-grid">` +
      card("w6", "Top 8 by CPU", esc(cpuNote), procTable(p.cpu, "cpu")) +
      card("w6", "Top 8 by memory", "private memory (Task Manager's Memory)", procTable(p.ram, "ram")) + `</div>` +
      `<h2>Agents and jobs running</h2><div class="pcd-grid">${card("w12", "Who is working", (d.runs || []).length + " agent run(s) · " + ((p.jobs || []).length) + " job(s)", jobsHtml(d))}</div>` +
      `<h2>Memory, disks and heat</h2><div class="pcd-grid">` +
      card("", "Memory and page file", "commit = what programs reserved", memHtml(d.mem, v)) +
      card("", "Disks", "E: = work drive, C: = Windows", diskHtml(d, v)) +
      card("", "Heat", "CPU temperature, last 10 min", heatHtml(d.heat, v)) + `</div>` +
      `<p class="meta">Detail every ${esc(d.every_s || 6)} s from <code>pc_metrics.ps1</code> (sampled ${esc(String(d.at || "").slice(11))}, ${f1(d.age_s)} s ago)` +
      `${d.ok ? "" : ` · <b class="pcd-r">${esc(d.why)}</b>`} · the sampler itself uses <b>${num(d.cost_pct) ? d.cost_pct.toFixed(1) + "%" : "–"}</b> of one CPU core.</p>`;
  }

  let lastD = null, hadDisks = false;
  window.addEventListener("pcm", () => { if (lastD && !hadDisks) { hadDisks = true; try { draw(lastD); } catch (e) {} } });   // the tiles' first reading came in
  async function load(force) {
    if (!force && document.visibilityState === "hidden") return;
    let d = null;
    try { const r = await fetch("/api/pc_detail", { cache: "no-store" }); d = await r.json(); } catch (e) { d = { ok: false, why: "board not answering (" + e + ")" }; }
    lastD = d; hadDisks = !!window.pcmLatest;
    try { draw(d); } catch (e) { const b = document.getElementById("pcDetail"); if (b) b.innerHTML = `<div class="meta pcd-r">PC detail: draw failed (${esc(e)})</div>`; }
  }
  load(true); setInterval(load, 6000);
  document.addEventListener("visibilitychange", () => { if (document.visibilityState === "visible") load(true); });
})();
