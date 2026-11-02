[user t161u] # TASK K88 - who sponsors a small boxing club (game design, Kalli)

You are the game designer of FightCamp, a boxing-gym management game (the player owns a small boxing club and builds fighters).
Answer in plain text in this chat. No research report: a design answer and a data list.

## The problem
Today the club's sponsor offers come from a list of real fight ORGANISATIONS (UFC, ONE, national federations). A small boxing club in
London was offered the "Cyprus Mixed Martial Arts Federation" as its sponsor - wrong sport, wrong country, and a federation is not a
sponsor. Real small clubs are sponsored by LOCAL BUSINESSES (a car dealer, a supplement shop, a builder, a pub, a physio clinic), later
by regional brands, and only a famous gym attracts a national or sports brand.

## What I need from you
1. Three to five sentences: how sponsorship should feel in the first hour and later (what the player does, what it pays, what it asks).
2. A list of 15 FICTIONAL sponsors, in four tiers (C local = reputation 0+, B regional = 25+, A national = 60+, S global = 100), as
   lines in exactly this form (one per line, | separated):
   `tier | name | kind of business | weekly pay in dollars | what they ask (one condition) | one-line pitch the owner says`
   - Names must be invented, generic enough to fit any country (no real brands, no real people, no place names).
   - Weekly pay: C 150-300, B 350-500, A 600-800, S 900-1200.
   - Conditions must be things the game already tracks: "keep 2 fighters fit", "a fighter on a card every 4 weeks", "a win in the next
     8 weeks", "gym reputation stays above N", "no fighter fails a weigh-in".
   - Mix kinds: at least 2 food/drink, 2 cars/transport, 2 health/fitness, 1 trades, 1 media; a boxing-equipment brand only at A or S.
3. One sentence: should sponsors ever come from the fight organisations at all (and if yes, when)?

Keep it short. The game is boxing first; the same list must also work for an MMA or kickboxing gym later.
[send-message t161s1046] 1. In the first hour a local business walks into the gym and offers a small weekly cheque for a simple ask you already do (keep fighters fit, put someone on a card). Later the offers get bigger and the asks get sharper: a win by a date, reputation held, weigh-ins made. You pick one sponsor at a time, they pay every week while the condition holds, and a miss freezes the pay for a stretch or ends the deal. The player never shops a catalogue; the gym earns the next tier by reputation, then the offers arrive.

2. Sponsors
C | Corner Cup Coffee | food/drink | 180 | keep 2 fighters fit | "We back the kids who train here. Keep two of them fit and the till stays open."
C | Steady Hands Physio | health/fitness | 220 | no fighter fails a weigh-in | "We tape ankles. You keep every fighter on weight and we keep paying."
C | Brick & Beam Builders | trades | 250 | gym reputation stays above 10 | "Local gym, local crew. Hold the gym's name above ten and we stay."
C | Nightshift Diner | food/drink | 160 | a fighter on a card every 4 weeks | "Feed the corner after sparring. Put a fighter on a card every month and we chip in."
C | North Loop Auto Care | cars/transport | 280 | keep 2 fighters fit | "We fix vans for free on fight week if two of your fighters stay fit."
B | Riverline Motors | cars/transport | 420 | a fighter on a card every 4 weeks | "Regional dealer. One of yours on a card every four weeks and the cheque hits."
B | Peak Form Supplements | health/fitness | 380 | keep 2 fighters fit | "Bars and shakes for the floor. Two fit fighters, every week, or the deal cools."
B | Echo Local Radio | media | 450 | gym reputation stays above 25 | "We run a weekly spot if your gym reputation holds at twenty-five."
B | Iron Lane Gym Kit | health/fitness | 500 | a win in the next 8 weeks | "Pads and wraps at cost. Land a win in eight weeks and we stay."
A | Crown Circuit Apparel | boxing equipment | 720 | gym reputation stays above 60 | "Kit with your colours. Reputation stays above sixty or we pull the patch."
A | Horizon Transit Co. | cars/transport | 650 | a fighter on a card every 4 weeks | "Team vans for weigh-in week. Keep a fighter on a card every month."
A | Vital Edge Clinics | health/fitness | 780 | no fighter fails a weigh-in | "Medical checks and ice baths. Nobody fails a weigh-in on our watch."
A | Metro Daily Sports Desk | media | 700 | a win in the next 8 weeks | "Front-page ink after a win. Deliver one in eight weeks and the column stays."
S | Aether Athletics | boxing equipment | 1100 | gym reputation stays above 100 | "Global kit deal. Hold reputation at one hundred and the shipment keeps coming."
S | Apex Fuel Bars | food/drink | 950 | keep 2 fighters fit | "Fight-week meals worldwide. Two fighters fit every week or the crate stops."

3. Fight organisations should never be weekly club sponsors; they book cards and pay purses. A sanctioning body or promoter can only appear later as a one-off title or broadcast partner once a fighter is national-tier, never as the gym's day-to-day sponsor.
