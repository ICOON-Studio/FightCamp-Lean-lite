// S538 LOOKMOCK538: the office frame both office mockups share (top bar, desk, icon rail). on = the lit rail icon.
function frame(on, title) {
  var icons = [["Desktop", "M5 6h22v16H5zM11 3v6M21 3v6M11 15l4 4 7-7"], ["Mail", "M4 8h24v18H4zM4 9l12 9 12-9"], ["Schedule", "M5 7h22v20H5zM5 13h22M11 3v6M21 3v6"],
    ["Fighters", "M10 16c0-6 3-10 8-10s7 3 7 8v4c0 3-2 5-5 5h-5c-3 0-5-2-5-5zM10 16c-3 0-3-5 0-6M14 23v4h8v-4"], ["Staff", "M16 4a4 4 0 110 8 4 4 0 010-8zM9 28l3-12h8l3 12M12 21h8"],
    ["Finance", "M16 3a13 13 0 110 26 13 13 0 010-26zM20 11c-1-2-7-3-7 1s7 2 7 6-6 3-8 1M16 7v18"], ["Records", "M8 3h12l6 6v20H8zM20 3v6h6M12 16h10M12 21h10"]];
  var rail = icons.map(function (i) {
    return '<div class="ri' + (i[0] == on ? ' on' : '') + '"><svg width="32" height="32" viewBox="0 0 32 32" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="' + i[1] + '"/></svg>' + i[0] + (i[0] == "Mail" ? '<span class="bad">5</span>' : '') + '</div>';
  }).join("");
  document.write('<div class="top"><div class="wbtn" style="left:18px;top:20px;width:36px">&lt;</div><div class="wbtn m" style="left:66px;top:20px;width:36px">&gt;</div>' +
    '<div class="name">ANVIL STREET GYM</div><div class="abs" style="left:402px;top:16px;font-weight:700;font-size:19px">Sat 14 Feb 2026<div class="m" style="font-size:15px;font-weight:500">Week 6 · test club</div></div>' +
    '<div class="wbtn" style="left:656px;top:18px;width:124px">Gym</div><div class="wbtn" style="left:790px;top:18px;width:124px">Mail (5 new)</div>' +
    '<div class="abs" style="left:1380px;top:12px;width:164px;text-align:right"><div class="y" style="font-size:25px;font-weight:700">$15,298</div><div class="m" style="font-size:14px">running -$309 a week</div></div>' +
    '<div class="abs" style="left:1558px;top:12px;width:268px;height:54px;background:var(--warn);border-radius:5px;color:#1d140f;padding:5px 14px;font-weight:700">NEEDS YOU (2)<div style="font-size:14px;font-weight:600">A bout offer ends in 6 days</div></div>' +
    '<div class="wbtn" style="left:1842px;top:20px;width:58px;font-size:15px">Menu</div></div>' +
    '<div class="desk"><div class="abs" style="left:70px;top:12px;font-weight:700;letter-spacing:3px;font-size:21px">ANVIL STREET GYM</div>' +
    '<div class="abs" style="right:22px;top:14px;font-weight:700">Sat 14 Feb 2026 · <span class="y">Week 6</span> &nbsp; Cash <span class="g">$15,298</span></div>' +
    '<div class="rail">' + rail + '</div><div class="title">' + title + '</div></div>');
}
