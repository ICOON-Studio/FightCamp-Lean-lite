# K_MEN1 - Kalli - the men's opponents (16) + world news (S371 collected from the gbot Kalli thread, inline text)

**PART 1 of 2: the opponents**

There are 16 rows below. The last row in each division is the mismatch. I took the club names from memory and haven't checked them against England Boxing's register, so treat them as NOT COMPUTED. A real boxer's name could also overlap with one of these by chance, so a name search is worth doing before ship.

```json
[
{"div":"m_fly57","name":"Callum Reid","first":"Callum","club":"Repton ABC","age":19,"stance":"orthodox","style":"Out-boxer","w":7,"l":3,"rating":55,"threat":"A long jab that keeps you at the end of it all night.","weak":"Steps straight back in a line; cut the ring and he runs out of room."},
{"div":"m_fly57","name":"Tariq Hussain","first":"Tariq","club":"Birtley ABC","age":22,"stance":"southpaw","style":"Counter-puncher","w":9,"l":4,"rating":58,"threat":"A straight left that lands every time you lead with the right.","weak":"Waits too long; keep throwing first and he loses the round on work rate."},
{"div":"m_fly57","name":"Owen Pritchard","first":"Owen","club":"Lynn AC","age":24,"stance":"orthodox","style":"Volume puncher","w":11,"l":6,"rating":60,"threat":"Never stops throwing; judges see him busy every round.","weak":"Arms only, little power; walk through it and hit back hard."},
{"div":"m_fly57","name":"Kofi Mensah","first":"Kofi","club":"West Ham ABC","age":26,"stance":"orthodox","style":"Pressure fighter","w":24,"l":3,"rating":69,"threat":"Walks you down and breaks the body by round two.","weak":"Drops his right hand when he throws the left hook."},
{"div":"m_light60","name":"Liam Doherty","first":"Liam","club":"Rotunda ABC","age":20,"stance":"orthodox","style":"Slugger","w":6,"l":4,"rating":54,"threat":"One right hand can end it.","weak":"Slow to start and loads up; a quick jab beats him to everything."},
{"div":"m_light60","name":"Arjun Patel","first":"Arjun","club":"Finchley ABC","age":23,"stance":"southpaw","style":"Out-boxer","w":10,"l":3,"rating":59,"threat":"Moves well and scores clean from range.","weak":"Fades in round three; pressure early and keep it on him."},
{"div":"m_light60","name":"Dean Clarke","first":"Dean","club":"Everton Red Triangle ABC","age":21,"stance":"orthodox","style":"Counter-puncher","w":8,"l":5,"rating":57,"threat":"Times your jab and counters over it.","weak":"Rarely leads; feint and he freezes."},
{"div":"m_light60","name":"Mateusz Kowalski","first":"Mateusz","club":"Fisher ABC","age":27,"stance":"orthodox","style":"Volume puncher","w":26,"l":5,"rating":70,"threat":"Five-punch combinations that bury you on points.","weak":"His chin goes straight up after the last punch of a combo."},
{"div":"m_welter67","name":"Jordan Ashby","first":"Jordan","club":"Collyhurst and Moston Lads Club","age":22,"stance":"orthodox","style":"Pressure fighter","w":9,"l":4,"rating":58,"threat":"Crowds you onto the ropes and works the body.","weak":"Comes in straight with his head down; uppercuts find him."},
{"div":"m_welter67","name":"Samir Haddad","first":"Samir","club":"Dale Youth ABC","age":25,"stance":"southpaw","style":"Counter-puncher","w":12,"l":5,"rating":61,"threat":"A sharp left counter whenever you reach.","weak":"Weak on the inside; get close and he holds."},
{"div":"m_welter67","name":"Ryan McBride","first":"Ryan","club":"Birtley ABC","age":19,"stance":"orthodox","style":"Out-boxer","w":5,"l":2,"rating":53,"threat":"Fast feet and long arms keep him hard to catch.","weak":"Green; lose a round to him and he panics into a brawl."},
{"div":"m_welter67","name":"Darnell Okafor","first":"Darnell","club":"Repton ABC","age":28,"stance":"orthodox","style":"Slugger","w":28,"l":4,"rating":69,"threat":"Stops people. Two standing counts and it's over.","weak":"Tires if the fight goes three full rounds at pace."},
{"div":"m_middle75","name":"Ben Hollis","first":"Ben","club":"Lynn AC","age":24,"stance":"orthodox","style":"Slugger","w":7,"l":5,"rating":55,"threat":"Heavy hooks from both hands.","weak":"Flat-footed; move side to side and he swings at air."},
{"div":"m_middle75","name":"Ewan Fraser","first":"Ewan","club":"Rotunda ABC","age":21,"stance":"southpaw","style":"Volume puncher","w":9,"l":3,"rating":58,"threat":"Busy right jab that wins rounds on the cards.","weak":"Leaves the body open every time he throws."},
{"div":"m_middle75","name":"Marcus Bell","first":"Marcus","club":"West Ham ABC","age":26,"stance":"orthodox","style":"Counter-puncher","w":13,"l":6,"rating":62,"threat":"Patient and accurate; makes you pay for every mistake.","weak":"Gives away early rounds by doing too little."},
{"div":"m_middle75","name":"Adebayo Sule","first":"Adebayo","club":"Fisher ABC","age":29,"stance":"orthodox","style":"Pressure fighter","w":30,"l":6,"rating":70,"threat":"Strong, relentless, and never takes a backward step.","weak":"Wide right hand; a straight shot gets in first."}
]
```

Division ids follow the task's four limits. I wrote `m_fly57` for the 57 kg featherweight by mistake. Rename it `m_feather57`.

**PART 2 of 2: the world news**

```json
[
"Kofi Mensah (West Ham ABC) stops his man in round two to keep his featherweight run going.",
"UPSET: Ryan McBride, 5 bouts in, outpoints a seeded welterweight at the regional championships.",
"Mateusz Kowalski takes a split decision at lightweight. The Fisher ABC corner calls it a robbery the other way.",
"Darnell Okafor scores his third stoppage of the season. No one in the welterweight top five has called him out.",
"Repton ABC sends six men to the national championships, the most from any club this year.",
"Rival gym watch: Lynn AC has opened a second evening class, and two of the area's prospects have already moved over."
]
```

Kit gaps and open points:
- The club names aren't checked against the register (NOT COMPUTED).
- The division limits wait on J_MEN1.
- In the welterweight row, Okafor's "two standing counts" assumes amateur counting rules. John should confirm the current England Boxing rule (NOT COMPUTED).
