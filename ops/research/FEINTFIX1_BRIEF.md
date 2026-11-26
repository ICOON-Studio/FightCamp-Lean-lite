# FEINTFIX1 - one design question: the feint that opens the overhand (Puncher's chance, boxing)

You are a boxing game designer. Answer in plain words, no code. One page at most.

## The game, as much as you need
Two boxers plan a "beat" at the same time, then it plays. In a beat each man may use his lead hand, his rear hand and his
feet, in an order he picks (up to three moments). A hand that does not punch is HELD high or low and stops one kind of punch:
- lead hand high: straight punches to the head (jab, cross); lead hand low: body punches;
- rear hand high: punches from the side (lead hook, overhand); rear hand low: uppercuts.
Three ranges: Inside, Mid, Long. Health 16-18, stamina 8 (a held hand gives 1 back, a punch costs 1-3).
The punches (damage / stamina / ranges): jab 1 / 1 / Mid, Long; body jab 1 / 1 / Mid, Long; lead hook 3 / 2 / Inside, Mid;
lead uppercut 3 / 2 / Inside; body hook 2 / 2 / Inside, Mid; cross 3 / 2 / Inside, Mid; overhand 4 / 3 / Inside, Mid (slow);
rear uppercut 4 / 3 / Inside (slow); body cross 2 / 2 / Inside, Mid.
The FEINT (lead hand, 1 stamina, no damage): if the other man is holding a hand against the line you then punch on, the
feint pulls that hand away for the rest of the beat, so the next punch finds the line open.

## The problem, measured
- One loop wins too much: step in, FEINT, OVERHAND, then clinch to get stamina back. A bot playing only that beats the three
  opponents in 38%, 63% and 70% of bouts (the bar is under 30%). Without the clinch it wins 7-13%, so the feint-then-overhand
  is the real exploit: nobody can cover it. The overhand after a feint lands 83-94% of the time.
- Three fixes were measured and each one killed the feint itself:
  - D: the feint opens the overhand only at Inside -> the feint and the overhand both drop to 1-2% of all beats (floor 3%).
  - E: a punch that lands on you in the moment you feint wastes the feint -> feint 1-2% of beats; the nearest (8 of 9 bars).
  - F: both -> the loop falls to 22-25% (passes), but the feint and the overhand are nearly never chosen.
- So the fix must cut the feint -> overhand opening WITHOUT making the feint worthless.

## The question
Give your THREE best rule changes, best first. For each one:
1. the rule in one or two sentences, exact enough to build (numbers included);
2. what a real boxer does that it copies;
3. why the feint stays worth choosing (what it still opens) and why the overhand stays worth throwing;
4. what could go wrong, and the one number you would watch.
Ideas already on our list, to judge or beat: the feint pulls only ONE hand (the one that reacts) and the other man chooses
nothing; the overhand after a feint only against a man who is tired (stamina 3 or less); the feint opens only a punch of 3
damage or less; a man who was feinted on in the last beat is not fooled twice running; the overhand costs 4 or reaches Mid only.

## Feedback loops
A weaker feint is chosen less, so the men hold their guards more, so every power punch lands less and bouts go long: say
what stops that in your rule. A stronger counter to the feint makes the jab safer, so Long range grows: say the cap.
