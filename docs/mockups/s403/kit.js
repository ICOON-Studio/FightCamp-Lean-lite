/* S403 round 4: the shared parts of every menu mockup, so pages cannot disagree.
   Load at the end of <body>: <script src="facts.js"></script><script src="kit.js"></script>
   <span data-f="lucy.weight"></span>        a fact from facts.json or the roster
   <i data-ic="camp"></i>                    one icon, with its tooltip; add title="" on the element to give a more exact tooltip
   <div data-kit="top"></div>                the top bar, identical on every page
   <nav data-kit="rail" data-on="Home"></nav> the left rail, identical on every page (Home, Fighters, Fights, Club, World)
   <span data-face="lucy" style="width:40px;height:48px"></span>  a fighter's portrait
   <p data-t="Fights {lucy.opp} on {lucy.fight}"></p>   a sentence with facts in it
   <b data-tip="Booked: {lucy.opp}, {lucy.fight}">x</b>  a tooltip with facts in it */
(function () {
  const F = window.FACTS;
  // One icon per meaning, on every page. 24x24, line, no fill.
  const I = {
    // fighter state (the same eight on Home, Fighters, Fights, Profile, World)
    booked: ['<rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18M9 16l2 2 4-4"/>', 'Fight booked'],
    camp: ['<path d="M4 3v18M20 3v18M4 8h16M4 13h16M4 18h16"/><circle cx="4" cy="3" r=".5"/><circle cx="20" cy="3" r=".5"/>', 'In camp'],
    injured: ['<rect x="2" y="7" width="20" height="10" rx="3" transform="rotate(-45 12 12)"/><path d="M10 10h.01M14 14h.01M14 10h.01M10 14h.01"/>', 'Injured'],
    offer: ['<rect x="2" y="4" width="20" height="16" rx="2"/><path d="m22 7-10 6L2 7"/>', 'Fight offer waiting'],
    contract: ['<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><path d="M14 2v6h6M8 13h8M8 17h5"/>', 'Contract ending'],
    free: ['<rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18M9 16h6"/>', 'No fight booked'],
    leaving: ['<path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4M16 17l5-5-5-5M21 12H9"/>', 'Another gym wants this fighter'],
    retiring: ['<path d="M5 22h14M5 2h14M17 22v-4.2a2 2 0 0 0-.6-1.4L12 12l-4.4 4.4A2 2 0 0 0 7 17.8V22M7 2v4.2a2 2 0 0 0 .6 1.4L12 12l4.4-4.4A2 2 0 0 0 17 6.2V2"/>', 'Talking about retiring'],
    // common facts
    money: ['<circle cx="12" cy="12" r="9"/><path d="M15 8.5c-.7-1-1.8-1.5-3-1.5-1.7 0-3 1-3 2.4 0 3.2 6 1.8 6 5 0 1.5-1.3 2.6-3 2.6-1.3 0-2.5-.6-3.2-1.6M12 5v14"/>', 'Money'],
    runway: ['<path d="M12 14l4-5"/><path d="M3.5 18a10 10 0 1 1 17 0"/><circle cx="12" cy="14" r="1.5"/>', 'Runway: how many weeks of costs the cash covers'],
    calendar: ['<rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/>', 'Date'],
    clock: ['<circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/>', 'Time'],
    weight: ['<path d="M12 3v18M5 21h14M3 7h18M5 7l-3 8a3 3 0 0 0 6 0zM19 7l-3 8a3 3 0 0 0 6 0z"/>', 'Weight now / class limit'],
    fresh: ['<path d="M22 12h-4l-3 9L9 3l-3 9H2"/>', 'Freshness, 0 to 100'],
    mood: ['<circle cx="12" cy="12" r="9"/><path d="M8 14s1.500 2 4 2 4-2 4-2M9 9h.01M15 9h.01"/>', 'Mood'],
    fatigue: ['<path d="M12 2c1 4 6 6 6 12a6 6 0 0 1-12 0c0-2 1-3.500 2-4.500 0 2 1 3 2 3 1-3 0-7 2-10.500z"/>', 'Fatigue this adds'],
    energy: ['<rect x="2" y="7" width="17" height="10" rx="2"/><path d="M22 11v2M6 11v2M10 11v2M14 11v2"/>', 'Energy left in this fight'],
    lock: ['<rect x="4" y="11" width="16" height="10" rx="2"/><path d="M8 11V7a4 4 0 0 1 8 0v4"/>', 'Not available yet'],
    warn: ['<path d="M12 3 2 21h20zM12 10v5M12 18v.5"/>', 'Not built yet'],
    members: ['<path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.900M16 3.100a4 4 0 0 1 0 7.800"/>', 'Members, of the places you have'],
    reputation: ['<path d="m12 3 2.800 5.700 6.200.900-4.500 4.400 1.100 6.200L12 17.300 6.400 20.200l1.100-6.200L3 9.600l6.200-.900z"/>', 'Reputation: how far the gym\'s name carries'],
    coach: ['<circle cx="12" cy="6" r="4"/><path d="M5 22v-3a7 7 0 0 1 14 0v3M9 14l3 4 3-4"/>', 'Coach'],
    // rankings and scouting
    champion: ['<path d="M3 18h18L19 7l-4 4-3-7-3 7-4-4zM4 21h16"/>', 'Champion'],
    challenger: ['<path d="M4 21v-5h5v-5h5V6h6"/><path d="M17 3l3 3-3 3"/>', 'Next in line for the title'],
    next_opp: ['<path d="M5 5l14 14M19 5 5 19"/><circle cx="5" cy="5" r="2"/><circle cx="19" cy="5" r="2"/>', 'Your next opponent'],
    scouted: ['<path d="M2 12s4-7 10-7 10 7 10 7-4 7-10 7-10-7-10-7z"/><circle cx="12" cy="12" r="3"/>', 'Scouted: part of this fighter is known'],
    unscouted: ['<path d="M3 3l18 18M10.600 5.200A10 10 0 0 1 22 12a14 14 0 0 1-3 3.800M6.300 6.800A14 14 0 0 0 2 12s4 7 10 7c1.500 0 2.900-.4 4.100-1"/>', 'Not scouted'],
    up: ['<path d="M3 17l6-6 4 4 8-8M15 7h6v6"/>', 'Rising'],
    down: ['<path d="M3 7l6 6 4-4 8 8M15 17h6v-6"/>', 'Falling'],
    // attributes (the same in every sport)
    Strength: ['<path d="M6 7v10M18 7v10M3 10v4M21 10v4M6 12h12"/>', 'Strength: how hard the fighter can push, pull and hit'],
    Explosiveness: ['<path d="M13 2 4 14h7l-1 8 9-12h-7z"/>', 'Explosiveness: power in a sudden burst'],
    Speed: ['<path d="M3 8h11a3 3 0 1 0-3-3M3 12h16a3 3 0 1 1-3 3M3 16h8a3 3 0 1 1-3 3"/>', 'Speed: how fast the hands and feet move'],
    Stamina: ['<rect x="2" y="7" width="17" height="10" rx="2"/><path d="M22 11v2M6 11v2M10 11v2"/>', 'Stamina: how long the fighter holds the pace'],
    Recovery: ['<path d="M3 12a9 9 0 1 0 3-6.700L3 8"/><path d="M3 3v5h5"/>', 'Recovery: how fast fatigue and damage go away'],
    Flexibility: ['<path d="M4 20c4-1 5-6 8-8s7-1 8-8"/><circle cx="4" cy="20" r="1.500"/><circle cx="20" cy="4" r="1.500"/>', 'Flexibility: range of the hips and shoulders'],
    Durability: ['<path d="M12 2l8 3v6c0 5-3.500 9-8 11-4.500-2-8-6-8-11V5z"/>', 'Durability: how much damage the body takes'],
    'Fight IQ': ['<path d="M9 3a3 3 0 0 0-3 3 3 3 0 0 0-2 5 3 3 0 0 0 2 5 3 3 0 0 0 6 2V5a2 2 0 0 0-3-2zM15 3a3 3 0 0 1 3 3 3 3 0 0 1 2 5 3 3 0 0 1-2 5 3 3 0 0 1-6 2"/>', 'Fight IQ: reading the fight'],
    Composure: ['<circle cx="12" cy="5" r="2.500"/><path d="M12 7.500V21M5 12H3a9 9 0 0 0 18 0h-2"/>', 'Composure: staying calm when it goes wrong'],
    Heart: ['<path d="M20.800 5.600a5.500 5.500 0 0 0-7.800 0L12 6.700l-1-1.100a5.500 5.500 0 0 0-7.800 7.800L12 22l8.800-8.600a5.500 5.500 0 0 0 0-7.800z"/>', 'Heart: not giving up'],
    // sessions
    roadwork: ['<path d="M7 16c-2 0-3-1.500-3-4s1-5 3-5 3 2.500 3 5-1 4-3 4zM5 19h4M17 13c-2 0-3-1.500-3-4s1-5 3-5 3 2.500 3 5-1 4-3 4zM15 16h4"/>', 'Roadwork'],
    intervals: ['<circle cx="12" cy="14" r="8"/><path d="M12 14V9M9 2h6M12 2v4"/>', 'Intervals'],
    weights: ['<path d="M6 7v10M18 7v10M3 10v4M21 10v4M6 12h12"/>', 'Weights'],
    bag: ['<path d="M12 2v3M8 5h8v14a4 4 0 0 1-8 0zM8 10h8"/>', 'Heavy bag'],
    pads: ['<circle cx="12" cy="12" r="9"/><circle cx="12" cy="12" r="4"/><path d="M12 12h.01"/>', 'Pad work with a coach'],
    sparring: ['<path d="M6 11V8a5 5 0 0 1 5-5h3a5 5 0 0 1 5 5v5a5 5 0 0 1-5 5H9a3 3 0 0 1-3-3zM6 11H5a2 2 0 0 0 0 5h1M8 21h9M11 8h4"/>', 'Sparring'],
    mat: ['<rect x="2" y="14" width="20" height="6" rx="1"/><circle cx="8" cy="9" r="2.500"/><path d="M11 12l6-2 3 3"/>', 'Mat rounds: live grappling'],
    takedown: ['<circle cx="7" cy="5" r="2.500"/><path d="M7 8l5 4 6-2M12 12l-2 8M4 21h17"/>', 'Takedown drills'],
    cage: ['<path d="M3 3v18M9 3v18M15 3v18M21 3v18M3 9h18M3 15h18"/>', 'Cage work'],
    mobility: ['<path d="M4 20c4-1 5-6 8-8s7-1 8-8"/><circle cx="4" cy="20" r="1.500"/><circle cx="20" cy="4" r="1.500"/>', 'Mobility'],
    rest: ['<path d="M21 13A9 9 0 1 1 11 3a7 7 0 0 0 10 10z"/>', 'Rest'],
    film: ['<rect x="3" y="4" width="18" height="16" rx="2"/><path d="M8 4v16M16 4v16M3 9h5M3 15h5M16 9h5M16 15h5"/>', 'Film study'],
    // corner jobs
    water: ['<path d="M12 3s7 7 7 12a7 7 0 0 1-14 0c0-5 7-12 7-12z"/>', 'Water'],
    ice: ['<path d="M12 2v20M4 7l16 10M20 7 4 17M12 6 9 3M12 6l3-3M12 18l-3 3M12 18l3 3"/>', 'Ice'],
    guard: ['<path d="M8 21V10a2 2 0 1 1 4 0M12 10V8a2 2 0 1 1 4 0v13M4 21h16"/>', 'Hands up'],
    // move groups
    hands: ['<path d="M6 11V8a5 5 0 0 1 5-5h3a5 5 0 0 1 5 5v5a5 5 0 0 1-5 5H9a3 3 0 0 1-3-3zM6 11H5a2 2 0 0 0 0 5h1M8 21h9M11 8h4"/>', 'Punches'],
    kicks: ['<path d="M8 3v8l-4 7c-.6 1.200.3 3 2 3h4c1 0 1.700-.5 2-1.300l1-2.700h5a2 2 0 0 0 0-4h-5l-3-2V3"/>', 'Kicks'],
    knees: ['<path d="M6 3l6 8-1 10M12 11l7-3"/><circle cx="12" cy="11" r="2"/>', 'Knees and elbows'],
    submissions: ['<path d="M4 16c4-8 12-8 16 0M9 16a3 3 0 0 0 6 0M4 16l-1 4M20 16l1 4"/>', 'Submissions'],
    clinch: ['<circle cx="7" cy="5" r="2.500"/><circle cx="17" cy="5" r="2.500"/><path d="M7 8v6l5-3 5 3V8M7 14l-2 7M17 14l2 7"/>', 'Clinch'],
    ground: ['<path d="M2 20h20"/><circle cx="6" cy="14" r="2.500"/><path d="M9 15h7l4 2"/>', 'On the ground'],
    // actions
    swap: ['<path d="M7 4 3 8l4 4M3 8h14M17 20l4-4-4-4M21 16H7"/>', 'Change this answer'],
    clear: ['<circle cx="12" cy="12" r="9"/><path d="M9 9l6 6M15 9l-6 6"/>', 'Clear this line'],
    test: ['<path d="M9 3h6M10 3v6L4.500 18.500A2 2 0 0 0 6.200 21.500h11.600a2 2 0 0 0 1.700-3L14 9V3M7 15h10"/>', 'Test the plan: limited tries'],
    drag: ['<path d="M9 5h.01M9 12h.01M9 19h.01M15 5h.01M15 12h.01M15 19h.01"/>', 'Drag'],
    train: ['<path d="M5 12h14M13 6l6 6-6 6"/>', 'Train this'],
    star: ['<path d="m12 3 2.800 5.700 6.200.900-4.500 4.400 1.100 6.200L12 17.300 6.400 20.200l1.100-6.200L3 9.600l6.200-.900z"/>', 'One of this fighter\'s three best']
  };
  function get(path) {
    let o = F;
    for (const k of path.split('.')) {
      if (o == null || !(k in o)) { console.error('NO FACT ' + path); document.title = 'NOFACT ' + path; return '??' + path; }
      o = o[k];
    }
    return o;
  }
  function svg(name, tip) {
    const e = I[name];
    if (!e) { console.error('NO ICON ' + name); document.title = 'NOICON ' + name; return '??'; }
    return '<svg viewBox="0 0 24 24" width="100%" height="100%" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><title>' + (tip || e[1]) + '</title>' + e[0] + '</svg>';
  }
  const root = 'file:///E:/FightCamp/Lean/';
  const css = document.createElement('style');
  css.textContent = `
[data-ic]{display:inline-block;width:1.15em;height:1.15em;vertical-align:-.2em;font-style:normal}
.top{height:76px;display:flex;align-items:center;padding:0 22px;gap:14px;background:#f6ead3 url(${root}assets/ui/warm/paper.png) 0 0/600px auto;box-shadow:0 4px 0 rgba(90,60,25,.35);position:relative;z-index:5}
.top .nb{border:1.5px solid #b9a27d;border-radius:8px;padding:6px 13px;font-family:BarlowB;font-size:17px;color:#555;background:#fffaf0}
.top .gym{font-family:Marker;font-size:32px;color:#2F6FDB;margin-left:6px}
.top .date{font-family:BarlowB;font-size:19px;line-height:1.1}.top .date small{display:block;font-family:Barlow;font-size:14px;color:#5b554a}
.top .sp{flex:1}
.top .cash{text-align:right;font-family:BarlowB;font-size:27px;color:#2A8F5E;line-height:1}.top .cash small{display:block;font-family:Barlow;font-size:14px;color:#5b554a;margin-top:3px}
.top .go{background:#D93F34;color:#fff;font-family:BarlowB;font-size:20px;padding:8px 24px;border-radius:30px;line-height:1.1;width:560px;box-shadow:0 3px 0 #9d2a22}.top .go small{display:block;font-family:Barlow;font-size:14px;opacity:.95}
nav[data-kit=rail]{width:200px;padding:14px 11px;display:flex;flex-direction:column;gap:11px;flex:none}
nav[data-kit=rail] a{display:flex;justify-content:space-between;align-items:center;padding:13px 16px;border-radius:12px;background:#f8efdc url(${root}assets/ui/warm/paper.png) 0 0/300px auto;font-family:BarlowB;font-size:20px;border-left:8px solid #a48c66;box-shadow:0 3px 5px rgba(60,35,10,.3);color:#22262E}
nav[data-kit=rail] a.on{border-left-color:#D93F34}
nav[data-kit=rail] .b{background:#D93F34;color:#fff;border-radius:10px;font-size:14px;padding:1px 7px}
[data-face]{display:inline-block;overflow:hidden;position:relative;flex:none;border-radius:6px;background:#111}
[data-face] img{position:absolute;left:0;top:0;width:100%;height:auto;transform:scale(1.85);transform-origin:50% 9%}`;
  document.head.appendChild(css);
  document.querySelectorAll('[data-kit=top]').forEach((e) => {
    e.className = 'top';
    e.innerHTML = `<span class="nb">&lt;</span><span class="nb" style="opacity:.5">&gt;</span><span class="gym">${F.gym}</span><div class="date">${F.today}<small>${F.week}</small></div><div class="sp"></div><div class="cash" title="Cash in the tin">${F.cash}<small>growing ${F.net} a week</small></div><div class="go" title="Opens the first need. Time stops on each date until you answer">NEEDS YOU (${F.needs.count})<small>${F.needs.next}</small></div><span class="nb">Menu</span>`;
  });
  document.querySelectorAll('[data-kit=rail]').forEach((e) => {
    e.innerHTML = ['Home', 'Fighters', 'Fights', 'Club', 'World'].map((n) => `<a${e.dataset.on === n ? ' class="on"' : ''}>${n}${F.badges[n] ? `<span class="b">${F.badges[n]}</span>` : ''}</a>`).join('');
  });
  const fill = (t) => t.replace(/\{([^}]+)\}/g, (m, k) => get(k));
  document.querySelectorAll('[data-f]').forEach((e) => { e.textContent = get(e.dataset.f); });
  document.querySelectorAll('[data-t]').forEach((e) => { e.textContent = fill(e.dataset.t); });
  document.querySelectorAll('[data-tip]').forEach((e) => { e.title = fill(e.dataset.tip); });
  document.querySelectorAll('[data-ic]').forEach((e) => { e.innerHTML = svg(e.dataset.ic, e.getAttribute('title')); });
  document.querySelectorAll('[data-face]').forEach((e) => { e.innerHTML = '<img src="' + root + get(e.dataset.face + '.portrait') + '">'; });
  window.KIT_ICONS = I;
})();
