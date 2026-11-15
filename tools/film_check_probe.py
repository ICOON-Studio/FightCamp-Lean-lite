"""FIGHTFILM1 probe (S495, v3): how the coach's check behaves on all 72 claims, one film and two films pooled.
A design probe on the map's own numbers (ops/research/FIGHTFILM1_MAP_V3_S495.md section 3), not the game code: FilmBout does
not exist yet. Rerun it on FilmBout's real output once it is built.

v3 rules (critic John, v2 round):
- the camera sees an opponent's AFTER fact on CAMERA_SEEN of punches (blank otherwise); the coach's check counts all of them;
- an evidence bar instead of "3 times the rest": z = (k - E) / sd with E = n x the rest's rate and sd counting both
  counts; PASS at z >= 2.33 and k >= 3, MAYBE at z >= 1.28 and k >= 2;
- "throws fewer" compares the opponent's drop inside the window with the OTHER corner's drop in the same windows, so a
  boxer who tires like everyone else does not read as a fader; the same z bars;
- "loses the exchange": exchanges lost in the situation against the rest, the same evidence bar;
- fewer than 3 trigger moments on the film = "not enough moments" (never Nothing there).
Usage: python tools/film_check_probe.py [films=1000] [seed=495]"""
import math
import random
import sys

CAMERA_SEEN = 2 / 3
ROUND_S, ROUNDS, EXCH = 180, 3, 18
HER_PUNCHES = 80                    # about 80 of the opponent's punches a 3 x 3 min amateur bout (RoundScript, 9 beats an exchange)
TRIGGERS = {"jab": 31, "cross": 18, "hook": 12, "combo": 5, "hurt": 2}         # moments a film (means)
WINDOWS = {"lastmin": 3 * 60, "round1": 180, "afterbody": 6 * 30}           # seconds a film inside the window
FACTS = {"right_low": 1 / 15, "lunged": 1 / 12, "stood": 1 / 10, "to_body": 1 / 6, "wild_right": 1 / 12, "counter": 1 / 4}
THENS = list(FACTS) + ["fewer", "loses"]
WHENS = list(TRIGGERS) + list(WINDOWS) + ["walked"]
TRUE = {("jab", "right_low"): 0.20, ("jab", "lunged"): 0.20, ("combo", "stood"): 0.60, ("hurt", "to_body"): 0.80,
        ("hurt", "wild_right"): 0.80, ("lastmin", "fewer"): 0.60, ("round1", "fewer"): 0.60, ("afterbody", "fewer"): 0.60,
        ("walked", "loses"): 0.80}
FATIGUE = {"lastmin": 0.90, "round1": 1.05, "afterbody": 1.0}   # everyone throws a little less late in a round (both corners)
LOSE_BASE = 0.5
LANDED_ON_HER = 25          # the other corner lands about 25 a bout (mockup: 25 of 74)
Z_PASS, Z_MAYBE = 2.33, 1.28   # one-sided 1% and 10%


def pois(rng, lam):
    if lam > 30:
        return max(0, int(round(rng.gauss(lam, math.sqrt(lam)))))
    l, k, p = math.exp(-lam), 0, 1.0
    while True:
        p *= rng.random()
        if p <= l:
            return k
        k += 1


def binom(rng, n, p):
    return rng.binomialvariate(n, p) if n > 0 else 0


def word_up(k, n, rk, rn):
    """Evidence bar for 'more often after WHEN': z = (k - E) / sd, E = n x the rest's rate, sd from both counts."""
    if n < 3:
        return "short"
    rate = max(rk, 1) / max(rn, 1)
    e = n * rate
    z = (k - e) / math.sqrt(e + e * n / max(rn, 1))
    if k >= 3 and z >= Z_PASS:
        return "pass"
    if k >= 2 and z >= Z_MAYBE:
        return "maybe"
    return "nothing"


def word_down(inside, e, var):
    """Evidence bar for 'throws fewer inside the window': z = (E - inside) / sd (E from her outside rate x the other corner's
    inside/outside ratio; var counts every count it is made of)."""
    if e < 3:
        return "short"
    z = (e - inside) / math.sqrt(max(var, 1e-9))
    if z >= Z_PASS:
        return "pass"
    if z >= Z_MAYBE:
        return "maybe"
    return "nothing"


def film_counts(rng, when, then, seen):
    """The counts one film gives a claim: (k, n, rk, rn) for 'up' claims or ('down', inside, e) for 'fewer'."""
    fire = TRUE.get((when, then), 0.0)
    if then == "fewer":
        win = WINDOWS.get(when, 0)
        if when in TRIGGERS:
            win = pois(rng, TRIGGERS[when]) * 10
        if when == "walked":
            win = binom(rng, EXCH, 1 / 3) * 30
        if win < 20:
            return ("down", 0, 0.0, 0.0)
        total = ROUND_S * ROUNDS
        rate = HER_PUNCHES / total
        fat = FATIGUE.get(when, 1.0)
        mult = 0.6 if fire else 1.0
        her_in = pois(rng, rate * win * fat * mult)
        her_out = pois(rng, rate * (total - win))
        # The coach knows how much every boxer slows late in a round (the game's own fatigue number, FATIGUE), so the
        # expected count is her own outside rate x that known factor: no second corner's noise in it.
        e = her_out / (total - win) * win * fat
        var = e + e * e / max(her_out, 1)
        return ("down", her_in, e, var)
    if then == "loses":
        # "Gets out-landed": the other corner's landed punches a minute in the situation against the rest (more data than
        # six exchange results). A true pressure weakness: the other lands 1.8 times as often there.
        total = ROUND_S * ROUNDS
        win = {"walked": binom(rng, EXCH, 1 / 3) * 30, "lastmin": WINDOWS["lastmin"], "round1": WINDOWS["round1"],
               "afterbody": WINDOWS["afterbody"]}.get(when, pois(rng, TRIGGERS.get(when, 5)) * 10)
        if win < 20 or win > total - 20:
            return ("rate_up", 0, 0, 0, 1)
        rate = LANDED_ON_HER / total
        k = pois(rng, rate * win * (1.8 if fire else 1.0))
        rk = pois(rng, rate * (total - win))
        return ("rate_up", k, rk, win, total - win)
    base = FACTS[then]
    if when in TRIGGERS:
        n = pois(rng, TRIGGERS[when])
        rn = max(0, HER_PUNCHES - n)
    elif when == "walked":
        n = binom(rng, HER_PUNCHES, 1 / 3)
        rn = HER_PUNCHES - n
    else:
        n = binom(rng, HER_PUNCHES, WINDOWS[when] / (ROUND_S * ROUNDS))
        rn = HER_PUNCHES - n
    k = binom(rng, n, fire) if fire else 0
    k += binom(rng, n - k, base)
    rk = binom(rng, rn, base)
    if seen:   # the camera's view: each AFTER fact seen 2 times in 3, the punches themselves always
        k, rk = binom(rng, k, CAMERA_SEEN), binom(rng, rk, CAMERA_SEEN)
    return (k, n, rk, rn)


def word_rate_up(k, rk, win, wout):
    """Evidence bar for 'happens more often per minute inside the situation'."""
    e = max(rk, 1) / max(wout, 1) * win
    if e < 1:
        return "short"
    z = (k - e) / math.sqrt(e + e * e / max(rk, 1))
    if k >= 3 and z >= Z_PASS:
        return "pass"
    if k >= 2 and z >= Z_MAYBE:
        return "maybe"
    return "nothing"


def judge(rng, when, then, films, seen):
    parts = [film_counts(rng, when, then, seen) for _ in range(films)]
    if parts[0][0] == "rate_up":
        return word_rate_up(*[sum(p[i] for p in parts) for i in range(1, 5)])
    if parts[0][0] == "down":
        return word_down(sum(p[1] for p in parts), sum(p[2] for p in parts), sum(p[3] for p in parts))
    return word_up(*[sum(p[i] for p in parts) for i in range(4)])


def main(n_films, seed):
    rng = random.Random(seed)
    res = {}
    for when in WHENS:
        for then in THENS:
            for films in (1, 2):
                for seen in (False, True):
                    t = {"pass": 0, "maybe": 0, "nothing": 0, "short": 0}
                    for _ in range(n_films):
                        t[judge(rng, when, then, films, seen)] += 1
                    res[(when, then, films, seen)] = {k: v / n_films for k, v in t.items()}
    noise = [(w, t) for w in WHENS for t in THENS if (w, t) not in TRUE]
    print("claims: %d (true %d, noise %d), %d films each, seed %d" % (len(WHENS) * len(THENS), len(TRUE), len(noise), n_films, seed))
    for films in (1, 2):
        print("\n== %d film%s: the coach's check (every punch) | what the screen shows (camera-seen AFTER facts) ==" % (films, "s" if films > 1 else ""))
        for (w, t) in TRUE:
            a, b = res[(w, t, films, False)], res[(w, t, films, True)]
            print("TRUE  %-9s -> %-10s pass %5.1f%% maybe %5.1f%% short %5.1f%% | screen pass %5.1f%%" % (
                w, t, 100 * a["pass"], 100 * a["maybe"], 100 * a["short"], 100 * b["pass"]))
        for seen, who in ((False, "check"), (True, "screen")):
            fp = [res[(w, t, films, seen)]["pass"] for (w, t) in noise]
            fm = [res[(w, t, films, seen)]["maybe"] for (w, t) in noise]
            worst = max(range(len(noise)), key=lambda i: fp[i])
            tp = sum(res[(w, t, films, seen)]["pass"] for (w, t) in TRUE) / len(TRUE)
            tm = sum(res[(w, t, films, seen)]["maybe"] for (w, t) in TRUE) / len(TRUE)
            mean_fp, mean_fm = sum(fp) / len(fp), sum(fm) / len(fm)
            print("NOISE %-6s pass %.2f%% on average, worst %.1f%% (%s -> %s); maybe %.1f%%" % (who, 100 * mean_fp, 100 * fp[worst], noise[worst][0], noise[worst][1], 100 * mean_fm))
            for prior, label in ((1 / 3, "reader (1 true in 3 checked)"), (1 / 10, "guesser (1 in 10)")):
                sure = tp * prior / (tp * prior + mean_fp * (1 - prior))
                msure = tm * prior / (tm * prior + mean_fm * (1 - prior)) if tm + mean_fm else 0
                print("   %-6s a pass is right %3.0f%%, a maybe %3.0f%% for a %s" % (who, 100 * sure, 100 * msure, label))


if __name__ == "__main__":
    a = sys.argv[1:]
    main(int(a[0]) if a else 1000, int(a[1]) if len(a) > 1 else 495)
