// pc_metrics.js - live PC metrics tiles, Task Manager style (S379, operator with a Task Manager screenshot: "can i have this
// metrics on board"). Draws into <section id="pcMetrics"> on / (roadmap.html) and /pc (pc.html). Reads /api/pc_metrics every
// 2 s - written by Tools/pc_metrics.ps1 (scheduled task "FightCamp PC Metrics", one hidden Get-Counter loop) - and draws each
// tile's 2-minute history as an inline SVG sparkline. No chart library.
// Colours are the watchdog's own lines (Tools/pc_watchdog.ps1 - change them THERE first, then here):
//   CPU     AMBER >= 60 %, RED >= 80 % (averaged: here over the last 10 s)   temperature AMBER >= 74 C, RED >= 84 C (88 at once)
//   memory  AMBER >= 85 %, RED >= 93 %; commit free AMBER < 8 GB, RED < 4 GB
//   C:      AMBER < 15 GB free, RED < 6 GB free
//   E:      AMBER < 15 % free or response >= 100 ms; RED < 5 % free, or response >= 250 ms while the disk is > 90 % busy (S366)
// Network and GPU have no watchdog line, so they never turn amber/red.
(function () {
  const R = { cpuW: 60, cpuC: 80, tW: 74, tC: 84, ramW: 85, ramC: 93, comW: 8, comC: 4, cW: 15, cC: 6, eW: 15, eC: 5, msW: 100, msC: 250 };
  const COL = { cpu: "#58a6ff", temp: "#e0703a", mem: "#bc8cff", com: "#d2a8ff", act: "#3fb950", rd: "#58a6ff", wr: "#e0703a",
                rx: "#e3b341", tx: "#ff7b72", gpu: "#56d4dd" };
  const css = `
.pcm{margin:12px 0 14px}
.pcm-top{display:flex;flex-wrap:wrap;gap:4px 14px;align-items:baseline;justify-content:space-between;margin-bottom:8px}
.pcm-top h2{margin:0;border:0;padding:0}
.pcm-top .meta a{color:var(--next,#e3b341)}
.pcm-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(250px,1fr));gap:10px}
.pcm-t{display:flex;flex-direction:column;min-width:0;background:var(--panel,#1e1a17);border:1px solid var(--line,#3a332d);border-left:4px solid var(--line,#3a332d);border-radius:8px;padding:9px 11px}
.pcm-t.pcm-GREEN{border-left-color:var(--run,#3fb950)}.pcm-t.pcm-AMBER{border-left-color:var(--next,#e3b341)}.pcm-t.pcm-RED{border-left-color:var(--out,#f85149)}
.pcm-t.off{opacity:.55}
.pcm-h{display:flex;justify-content:space-between;gap:8px;font-size:13px;white-space:nowrap}
.pcm-h b{overflow:hidden;text-overflow:ellipsis}.pcm-h span{color:var(--dim,#a39a8e)}
.pcm-n{font-size:11.5px;color:var(--dim,#a39a8e);white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.pcm-v{font-size:24px;font-weight:700;line-height:1.15;margin-top:2px;font-variant-numeric:tabular-nums}
.pcm-v small{font-size:12.5px;font-weight:400;color:var(--dim,#a39a8e);margin-left:4px}
.pcm-s{font-size:12.5px;color:var(--dim,#a39a8e);font-variant-numeric:tabular-nums}
.pcm-s b{color:var(--ink,#efe9e1);font-weight:600}
.pcm-why{font-size:12px;margin-top:3px}
.pcm-t.pcm-AMBER .pcm-why{color:var(--next,#e3b341)}.pcm-t.pcm-RED .pcm-why{color:var(--out,#f85149)}
.pcm-a{color:var(--next,#e3b341)!important}.pcm-r{color:var(--out,#f85149)!important}
.pcm-bar{position:relative;height:7px;background:#2b2520;border-radius:99px;margin:6px 0 2px}
.pcm-bar i{position:absolute;left:0;top:0;bottom:0;border-radius:99px;background:var(--run,#3fb950)}
.pcm-t.pcm-AMBER .pcm-bar i{background:var(--next,#e3b341)}.pcm-t.pcm-RED .pcm-bar i{background:var(--out,#f85149)}
.pcm-bar u{position:absolute;top:-3px;bottom:-3px;width:2px;background:var(--ink,#efe9e1)}
.pcm-ch{margin-top:auto;padding-top:6px}
.pcm-c{margin-top:4px}
.pcm-c div{display:flex;justify-content:space-between;font-size:11px;color:var(--dim,#a39a8e)}
.pcm-c svg{display:block;width:100%;height:34px;background:#171310;border:1px solid var(--line,#3a332d);border-radius:4px}
.pcm-k i{display:inline-block;width:8px;height:2px;vertical-align:middle;margin:0 3px 0 6px}
.pcm.stale .pcm-grid{opacity:.45}
.pcm[data-compact="1"] .pcm-v{font-size:21px}
.pcm[data-compact="1"] .pcm-c svg{height:30px}
.pcm[data-compact="1"] .pcm-grid{grid-template-columns:repeat(auto-fit,minmax(165px,1fr))}
.pcm[data-compact="1"] .pcm-s{white-space:nowrap;overflow:hidden;text-overflow:ellipsis}`;
  const st = document.createElement("style"); st.textContent = css; document.head.appendChild(st);

  const esc = s => String(s == null ? "" : s).replace(/[&<>"']/g, c => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c]));
  const num = v => typeof v === "number" && isFinite(v);
  const f1 = v => num(v) ? v.toFixed(1) : "–";
  const f0 = v => num(v) ? Math.round(v).toString() : "–";
  const bytes = v => !num(v) ? "–" : v >= 1048576 ? (v / 1048576).toFixed(v >= 104857600 ? 0 : 1) + " MB/s" : Math.round(v / 1024) + " KB/s";
  const bits = v => !num(v) ? "–" : v * 8 >= 1e6 ? (v * 8 / 1e6).toFixed(1) + " Mbps" : Math.round(v * 8 / 1e3) + " Kbps";
  const lvl = (v, w, c, below) => !num(v) ? "" : below ? (v < c ? "RED" : v < w ? "AMBER" : "GREEN") : (v >= c ? "RED" : v >= w ? "AMBER" : "GREEN");
  const worst = (...a) => a.includes("RED") ? "RED" : a.includes("AMBER") ? "AMBER" : a.includes("GREEN") ? "GREEN" : "";
  const cls = s => s === "RED" ? "pcm-r" : s === "AMBER" ? "pcm-a" : "";

  // One sparkline: series [{v:[...], c:colour, area:bool, dash:bool}], fixed or auto scale; nulls break the line.
  function spark(series, keep, lo, hi) {
    const W = 120, H = 34;
    let svg = `<svg viewBox="0 0 ${W} ${H}" preserveAspectRatio="none" aria-hidden="true">` +
      `<line x1="0" y1="${H / 2}" x2="${W}" y2="${H / 2}" stroke="#2b2520" stroke-width="1" vector-effect="non-scaling-stroke"/>`;
    for (const s of series) {
      const n = s.v.length, off = keep - n;
      let d = "", pen = false, first = null, last = null;
      s.v.forEach((v, i) => {
        if (!num(v)) { pen = false; return; }
        const x = ((off + i) / (keep - 1)) * W, y = H - 1 - Math.max(0, Math.min(1, (v - lo) / (hi - lo || 1))) * (H - 2);
        d += (pen ? "L" : "M") + x.toFixed(1) + "," + y.toFixed(1); pen = true;
        if (first === null) first = x; last = x;
      });
      if (!d) continue;
      if (s.area && !d.slice(1).includes("M")) svg += `<path d="${d}L${last.toFixed(1)},${H}L${first.toFixed(1)},${H}Z" fill="${s.c}" opacity=".18"/>`;
      svg += `<path d="${d}" fill="none" stroke="${s.c}" stroke-width="1.5" vector-effect="non-scaling-stroke"${s.dash ? ' stroke-dasharray="3 2"' : ""}/>`;
    }
    return svg + "</svg>";
  }
  const chart = (label, right, svg) => `<div class="pcm-c"><div><span>${label}</span><span>${right || ""}</span></div>${svg}</div>`;
  // One tile. Full (/pc): model name, every detail line, the reasons, two charts. Compact (data-compact="1", the top of the
  // roadmap page): value, two short lines, the main chart; the reasons sit in the tooltip and the left border's colour.
  let compact = false;
  function tile(o) {
    const why = (o.why || []).filter(Boolean).join(" · ");
    const lines = compact ? (o.short || []) : (o.lines || []);
    return `<div class="pcm-t${o.state ? " pcm-" + o.state : ""}${o.off ? " off" : ""}"${why ? ` title="${esc(why)}"` : ""}>` +
      `<div class="pcm-h"><b>${o.head}</b><span>${o.sub || ""}</span></div>` +
      (!compact && o.name ? `<div class="pcm-n" title="${esc(o.name)}">${esc(o.name)}</div>` : "") +
      `<div class="pcm-v ${o.vcls || ""}">${o.big}</div>` + lines.map(l => `<div class="pcm-s">${l}</div>`).join("") +
      (compact ? "" : (o.extra || "")) + (!compact && why ? `<div class="pcm-why">${esc(why)}</div>` : "") +
      `<div class="pcm-ch">${[].concat(o.charts || []).slice(0, compact ? 1 : 2).join("")}</div></div>`;
  }

  function draw(box, d) {
    if (!d || !d.latest) {
      box.innerHTML = `<div class="pcm-top"><h2>PC live</h2><span class="meta pcm-r">${esc((d && d.why) || "no reading from /api/pc_metrics")}</span></div>`;
      return;
    }
    compact = box.dataset.compact === "1";
    const H = d.history || [], L = d.latest, S = d.static || {}, keep = d.keep || 60;
    const col = k => H.map(s => s[k]);
    const last10 = H.slice(-5).map(s => s.cpu).filter(num);
    const cpuAvg = last10.length ? last10.reduce((a, b) => a + b, 0) / last10.length : L.cpu;
    const bad = s => s === "RED" || s === "AMBER";
    const t = [], notes = [];

    // CPU
    const sCpu = lvl(cpuAvg, R.cpuW, R.cpuC), sTmp = lvl(L.cpu_c, R.tW, R.tC);
    const tMax = Math.max(95, ...col("cpu_c").filter(num));
    const ghz = num(L.ghz) ? L.ghz.toFixed(2) + " GHz" : "";
    t.push(tile({ state: worst(sCpu, sTmp), head: "CPU", sub: compact ? "" : ghz, name: S.cpu_name,
      big: `${f0(L.cpu)}<small>%</small>`, vcls: cls(sCpu),
      lines: [`Temperature <b class="${cls(sTmp)}">${f0(L.cpu_c)} °C</b> · 10 s avg <b>${f0(cpuAvg)}%</b>`],
      short: [`<b>${ghz}</b>`, `Temp <b class="${cls(sTmp)}">${f0(L.cpu_c)} °C</b>`],
      why: [bad(sCpu) && `Busy: ${f0(cpuAvg)}% over 10 s (amber 60, red 80)`, bad(sTmp) && `Hot: ${f0(L.cpu_c)} °C (amber 74, red 84 held 2 min or 88)`],
      charts: [chart("Utilisation", "0-100%", spark([{ v: col("cpu"), c: COL.cpu, area: true }], keep, 0, 100)),
               chart("Temperature", "30-" + Math.round(tMax) + " °C", spark([{ v: col("cpu_c"), c: COL.temp }], keep, 30, tMax))] }));

    // Memory
    const comFree = num(L.commit_limit_gb) && num(L.commit_gb) ? L.commit_limit_gb - L.commit_gb : null;
    const sRam = lvl(L.mem_pct, R.ramW, R.ramC), sCom = lvl(comFree, R.comW, R.comC, true);
    t.push(tile({ state: worst(sRam, sCom), head: "Memory", sub: f1(S.ram_gb) + " GB",
      big: `${f1(L.mem_gb)}<small>/ ${f1(S.ram_gb)} GB${compact ? "" : " (" + f0(L.mem_pct) + "%)"}</small>`, vcls: cls(sRam),
      lines: [`Committed <b>${f1(L.commit_gb)} / ${f1(L.commit_limit_gb)} GB</b> · free <b class="${cls(sCom)}">${f1(comFree)} GB</b>`],
      short: [`<b>${f0(L.mem_pct)}%</b> used`, `Commit free <b class="${cls(sCom)}">${f1(comFree)} GB</b>`],
      why: [bad(sRam) && `Memory ${f0(L.mem_pct)}% used (amber 85, red 93)`, bad(sCom) && `Commit free ${f1(comFree)} GB (amber < 8, red < 4) - Godot jobs crash here`],
      charts: [chart("In use", "0-100%", spark([{ v: col("mem_pct"), c: COL.mem, area: true }], keep, 0, 100)),
               chart("Committed", "of the limit", spark([{ v: H.map(s => num(s.commit_gb) && s.commit_limit_gb ? 100 * s.commit_gb / s.commit_limit_gb : null), c: COL.com, area: true }], keep, 0, 100))] }));

    // Disks: E: first, then C:, then the rest (the offline HDD) - each with active time + transfer rate.
    const sd = S.disks || [], ld = L.disks || [];
    const rank = x => /E:/.test(x.letters || "") ? 0 : /C:/.test(x.letters || "") ? 1 : 2;
    sd.slice().sort((a, b) => rank(a) - rank(b) || a.n - b.n).forEach(info => {
      const cur = ld.find(x => x.n === info.n) || {}, hist = H.map(s => (s.disks || []).find(x => x.n === info.n) || {});
      const isE = /E:/.test(info.letters || ""), isC = /C:/.test(info.letters || "");
      const head = `Disk ${info.n}${info.letters ? " (" + esc(info.letters) + ")" : ""}`;
      const sub = esc(info.type) + (info.bus && info.type === "SSD" ? " (" + esc(info.bus) + ")" : "");
      if (info.offline) {
        if (compact) { notes.push(`Disk ${info.n} (${esc(info.type)}) offline`); return; }
        t.push(tile({ off: true, head, sub, name: info.model, big: "Offline",
          lines: ["Failing drive, kept offline since S190 (758 read errors). Its folders are backed up on E:."] }));
        return;
      }
      let sFree = "", sResp = "", why = [];
      if (isE) {
        sFree = lvl(cur.free_pct, R.eW, R.eC, true);
        sResp = num(cur.ms) && cur.ms >= R.msC && cur.act > 90 ? "RED" : num(cur.ms) && cur.ms >= R.msW ? "AMBER" : "GREEN";
        why = [sFree === "RED" ? `Only ${f1(cur.free_pct)}% free - the E: SSD stalls this full (red < 5%)` :
               sFree === "AMBER" ? `${f1(cur.free_pct)}% free - keep E: under 85% used (amber < 15%)` : "",
               bad(sResp) && `Slow: ${f0(cur.ms)} ms a transfer (amber 100, red 250 while > 90% busy)`];
      } else if (isC) {
        sFree = lvl(cur.free_gb, R.cW, R.cC, true);
        why = [bad(sFree) && `C: ${f1(cur.free_gb)} GB free (amber < 15, red < 6) - Windows lags when full`];
      }
      const used = num(cur.free_pct) ? 100 - cur.free_pct : null;
      const trMax = Math.max(1048576, ...hist.map(x => Math.max(num(x.rd) ? x.rd : 0, num(x.wr) ? x.wr : 0)));
      t.push(tile({ state: worst(sFree, sResp) || "GREEN", head, sub: compact ? esc(info.type) : sub, name: info.model,
        big: `${f0(cur.act)}<small>% active</small>`,
        lines: [`Response <b class="${cls(sResp)}">${f1(cur.ms)} ms</b>`, `Read <b>${bytes(cur.rd)}</b> · Write <b>${bytes(cur.wr)}</b>`],
        short: [`<b class="${cls(sResp)}">${f1(cur.ms)} ms</b> · <b class="${cls(sFree)}">${f1(cur.free_gb)} GB</b> free`, `R <b>${bytes(cur.rd)}</b> · W <b>${bytes(cur.wr)}</b>`],
        extra: used === null ? "" :
          `<div class="pcm-bar" title="${f0(used)}% used${isE ? " - the white line is 85% used, E:'s ceiling" : ""}"><i style="width:${used.toFixed(1)}%"></i>${isE ? '<u style="left:85%"></u>' : ""}</div>` +
          `<div class="pcm-s"><b class="${cls(sFree)}">${f1(cur.free_gb)} GB</b> free of ${f0(info.size_gb)} GB (${f1(cur.free_pct)}%)</div>`,
        why,
        charts: [chart("Active time", "0-100%", spark([{ v: hist.map(x => x.act), c: COL.act, area: true }], keep, 0, 100)),
                 chart(`<span class="pcm-k"><i style="background:${COL.rd}"></i>read<i style="background:${COL.wr}"></i>write</span>`, "max " + bytes(trMax),
                   spark([{ v: hist.map(x => x.rd), c: COL.rd }, { v: hist.map(x => x.wr), c: COL.wr, dash: true }], keep, 0, trMax))] }));
    });

    // Network (no watchdog line: never amber/red)
    const nic = S.nic || "", wifi = /wi-?fi|wireless|wlan|802\.11/i.test(nic + " " + (S.nic_desc || ""));
    const nMax = Math.max(125000, ...col("net_rx").filter(num), ...col("net_tx").filter(num));
    t.push(tile({ head: esc(S.nic_desc ? nic : (wifi ? "Wi-Fi" : "Ethernet")), sub: compact ? "" : "all adapters", name: S.nic_desc || nic,
      big: `${bits(L.net_rx)}<small>in</small>`,
      lines: [`Receive <b>${bits(L.net_rx)}</b> · Send <b>${bits(L.net_tx)}</b>`], short: [`Send <b>${bits(L.net_tx)}</b>`],
      charts: chart(`<span class="pcm-k"><i style="background:${COL.rx}"></i>in<i style="background:${COL.tx}"></i>out</span>`, "max " + bits(nMax),
        spark([{ v: col("net_rx"), c: COL.rx, area: true }, { v: col("net_tx"), c: COL.tx, dash: true }], keep, 0, nMax)) }));

    // GPU (no watchdog line)
    const gMax = Math.max(100, ...col("gpu_hot").filter(num), ...col("gpu_c").filter(num));
    t.push(tile({ head: "GPU 0", sub: compact ? "" : "3D engine", name: S.gpu_name, big: `${f0(L.gpu)}<small>% 3D</small>`,
      lines: [`Temperature <b>${f0(L.gpu_c)} °C</b> · hot spot <b>${f0(L.gpu_hot)} °C</b>`],
      short: [`Temp <b>${f0(L.gpu_c)} °C</b>`, `Hot spot <b>${f0(L.gpu_hot)} °C</b>`],
      charts: [chart("3D", "0-100%", spark([{ v: col("gpu"), c: COL.gpu, area: true }], keep, 0, 100)),
               chart(`<span class="pcm-k"><i style="background:${COL.temp}"></i>core<i style="background:#ff7b72"></i>hot spot</span>`, "30-" + Math.round(gMax) + " °C",
                 spark([{ v: col("gpu_c"), c: COL.temp }, { v: col("gpu_hot"), c: "#ff7b72", dash: true }], keep, 30, gMax))] }));

    const ago = num(d.age_s) ? d.age_s.toFixed(1) + " s ago" : "";
    const onPc = location.pathname === "/pc" || location.pathname === "/pc.html";
    box.classList.toggle("stale", !d.ok);
    box.innerHTML = `<div class="pcm-top"><h2>PC live</h2><span class="meta">${d.ok ? "" : `<b class="pcm-r">${esc(d.why)}</b> · `}every ${esc(d.every_s || 2)} s · ` +
      `trail ${Math.round(keep * (d.every_s || 2) / 60)} min · sampled ${esc(String(d.at || "").slice(11))} (${ago})${notes.length ? " · " + notes.join(" · ") : ""}` +
      ` · colours = the watchdog's lines${onPc ? "" : ' · <a href="/pc">full page</a>'}</span></div><div class="pcm-grid">${t.join("")}</div>`;
  }

  async function load(force) {
    const box = document.getElementById("pcMetrics"); if (!box) return;
    if (!force && document.visibilityState === "hidden") return;
    let d = null;
    try { const r = await fetch("/api/pc_metrics", { cache: "no-store" }); d = await r.json(); } catch (e) { d = { ok: false, why: "board not answering (" + e + ")" }; }
    try { draw(box, d); } catch (e) { box.innerHTML = `<div class="meta pcm-r">PC live: draw failed (${esc(e)})</div>`; }
  }
  load(true); setInterval(load, 2000);
  document.addEventListener("visibilitychange", () => { if (document.visibilityState === "visible") load(true); });
})();
