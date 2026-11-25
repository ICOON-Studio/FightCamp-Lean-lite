# RINGSWITCH_IDEAS2_BRIEF_JOHN - John answer (seat queue SQ330)

Brief: research/RINGSWITCH_IDEAS2_BRIEF.md
Sent: 2026-11-25 05:40 | collected: 2026-11-25 06:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it. I'm working through the five changes now, starting with long range.

Here are five changes, most important first. Each is a day's work on the current prototype, and every number in them is a starting value to tune.

## 1. The jab can go to the head or the body (fixes problem 1, helps problem 2)

**The rule**
1. The lead hand gets one new choice, **Body jab**. It's as fast as the jab, reaches Long and Mid, costs the same and does 1 damage.
2. Like every body punch, it shortens the stamina bar.
3. A lead hand held **low** blocks it. A lead hand held high does not.
4. A body jab that lands also keeps the opponent out next beat. That keep-out can't happen two beats running, whichever jab caused it.

**One beat**
- **The setup:** you're the Jabber at Long. The opponent has walked in behind a high lead hand for two beats.
- **What you set:** Body jab, rear hand high, back off.
- **What the opponent sets:** step in, lead hand high, rear hand high.
- **What happens:** the body jab goes under the high hand and lands. The opponent loses 1 Health and some stamina bar, and the step in fails. You still pay the cost of the back-off, and you've given up a square.
- **Next beat:** the opponent has to guess again, high or low, and this time can step in, because the keep-out can't repeat.

**What it adds**
- **For the man coming forward:** at Long, the walker now has a real guess with the lead hand: high stops the head jab, low stops the body jab.
- **For the Jabber:** after a high guard, go to the body. After a low guard, go to the head.
- **Where the habit rule comes in:** the habit reader already punishes a man who always guesses the same way, so mixing is the right play for both sides.

**How it can break**
- **The lazy plan:** jab, jab, jab at Long and win every round on 1-point jabs while the walker never arrives.
- **The cap:** a jab can't keep a man out two beats running. So every second beat the walker gets a real try at Mid.

**The real boxing:** Pernell Whitaker and Larry Holmes jabbed to the body to bring the guard down, then went back up top.

---

## 2. Hurt (fixes problem 3)

**The rule**
1. A man is **Hurt** for the next beat if a big punch lands on him as a counter, or if he loses 5 or more Health in one beat.
2. While Hurt, he can't step in, his punches do 1 less damage, and every punch that lands on him does 1 more.
3. Hurt lasts one beat, and nobody can be Hurt two beats running.
4. The Hurt man has three choices: clinch (the existing rule, not twice running), back off, or fire back.

**One beat**
- **The beat before:** your lead hook made the opponent's cross miss, so your overhand landed as a counter. The opponent is Hurt.
- **This beat, you set:** step in, Lead uppercut, Rear uppercut, at Inside.
- **The opponent sets:** Clinch.
- **What happens:** nothing lands and the opponent gets stamina back, so you've wasted 4 stamina. If the opponent had backed off instead, you'd have followed and both uppercuts would have landed at +1 each.

**What it adds**
- **When you've hurt someone:** go all in, or stay at Mid and pick shots because you expect the clinch.
- **When you're the one who's Hurt:** clinch (safe, but you can't do it next time), back off (but that costs ground) or fire back (punches weaker, but it can catch a careless finisher).
- **Why bouts can end early now:** a good guess at the right moment can finish a bout.

**How it can break**
- **The lazy plan:** chase counters and pile on, landing one Hurt after another.
- **The cap:** no Hurt two beats running, plus the clinch. Hurt is a window, not a lock.

**The real boxing:** Fury hurting Wilder and following up in their third fight. Usyk trapping a hurt Fury on the ropes in round 9 of their first fight.

## 3. Each opponent asks one question and changes plan when behind (the opponents)

**The rule**
1. Each opponent gets one rule that's theirs alone:
   - **The Jabber** mixes head and body jabs and circles away from a man who steps in twice running.
   - **The Slugger's** big punches do 1 more damage.
   - **The Body Snatcher's** body punches take 2 off your stamina bar, not 1, but do half damage at Mid.
2. Each opponent also has a second plan for the third round. It starts only if they're behind after round 2:
   - the Jabber starts walking in;
   - the Slugger throws two big punches every beat;
   - the Body Snatcher clinches at Long to get inside.

**One beat**
- **The setup:** round 3, and you're ahead of the Slugger, so the second plan is on.
- **The Slugger sets:** step in, Overhand, Lead hook.
- **You set:** lead hand high, rear hand high, back off.
- **What happens:** the rear hand high blocks both the overhand and the hook. The back-off keeps you at Mid.
- **If you'd jabbed instead:** the hand that punched wouldn't have been there to block, and the overhand would have landed for 4 (3 plus the Slugger's extra 1).

**What it adds**
- **A different question per opponent:**
  - the Jabber asks if you can get in without eating jabs;
  - the Slugger asks if you can stay safe and still win rounds;
  - the Body Snatcher asks if you can keep the fight at Long or Mid.
- **The third round:** the third round changes, so a lead isn't safe until the bell.

**How it can break**
- **The lazy plan:** one fixed plan beats each opponent, since each now asks only one question.
- **The cap:** the round 3 second plan beats that fixed plan. The habit reader stays on for all three.

**The real boxing:** Larry Holmes's jab, Mike Tyson's power, and Julio César Chávez working the body.

---

## 4. Circle off: a new feet choice (fixes problem 2, out-boxing)

**The rule**
1. FEET gets a fifth choice, **Circle**. It costs 2 stamina, keeps the range the same, and wins back one square of ground, which also gets you off the ropes.
2. If the opponent stepped in that beat, the step is wasted and your punches that beat count as counters.
3. While circling, you can only jab, body jab or hold.
4. If the opponent held their ground instead, their punches that beat count as counters on you.

**One beat**
- **The setup:** you're on the ropes against the Body Snatcher, at Mid.
- **You set:** Circle, Jab, rear hand low.
- **The opponent sets:** step in, Body hook, Body cross.
- **What happens:** the step is wasted, so the range stays Mid. Your jab lands first, as a counter, for 2. The body hook and body cross land, because only the lead hand held low blocks body punches. You're off the ropes with a square back.

**What it adds**
- **Each choice beats one of the others:**
  - against a man stepping in, circle;
  - against a man holding ground, back off or hold;
  - against a man backing off, step in.
- **Jab and move now has a real tool.** It no longer just loses ground until it hits the ropes.

**How it can break**
- **The lazy plan:** circle every beat and stay off the ropes forever.
- **The cap:** the 2-stamina cost means it can't be done more than every other beat. The opponent standing still punishes it with counters.

**The real boxing:** Muhammad Ali's "stick and move" and Vasyl Lomachenko stepping around a man who charges in.

---

## 5. Blocks aren't free

**The rule**
1. A held hand gives 1 stamina back only if nothing hit it that beat.
2. A big punch that's blocked (cross, overhand, hooks, uppercuts) costs the blocker 1 stamina.

**One beat**
- **You set:** both hands held, high and high.
- **The Slugger sets:** Overhand, Lead hook.
- **What happens:** both are blocked, and you pay 2 stamina.
- **The old rule:** you'd have gained 2 back.
- **Three beats like that:** you're out of stamina and can't throw.

**What it adds**
- **Holding all day loses.** Before, holding both hands was the stamina-safe answer to everything. Now it's right only against small punches.
- **Against big punches:** move out of range or punch first.

**How it can break**
- **The lazy plan:** the Slugger throws big punches into a guard to drain it.
- **The cap:** big punches cost the thrower up to 3, so they lose more than the blocker.

**The real boxing:** the old saying that you can tire a man by hitting the gloves. It's the reason fighters slip and move instead of holding a shell.

## What I'd build first: the body jab (1)

It's one new lead-hand choice and one blocking rule, using pictures you already have. It's the only change that fixes problem 1 directly, because the walker finally has to guess. It also fixes most of problem 2, since the Jabber now has two jabs to mix, and it gets the strongest use out of your new keep-out rule.

The measurement to re-run: the Jabber's 96% loss rate against the sensible bot. You'll also want jab use well above the 5% of beats you see now.

## What I'd cut: the guard bar

In 1,800 bouts it never broke, so it adds nothing a player has to think about. Change 5 does its job better, because a block costs you stamina now instead of filling a bar that never empties.

One caveat: these are design ideas, not tested results, so the numbers are starting values to try out with your bots.
