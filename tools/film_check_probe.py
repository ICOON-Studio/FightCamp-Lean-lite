"""FIGHTFILM1 v2 probe (S495): how often the coach's check says "That's her" for a true claim and for a noise claim.
A design probe on the map's own numbers (ops/research/FIGHTFILM1_MAP_V2_S495.md section 3), not the game code:
FilmBout does not exist yet. Re-run it on FilmBout's real output once it is built.
Usage: python tools/film_check_probe.py [films=1000]"""
import random
import sys

# One film = one 3 x 3 min amateur bout of hers: about 80 of her punches (RoundScript ~9 beats an exchange for both corners).
WHENS = {  # event claims: how many times the trigger happens in one film (mean)
    "her jab": 31, "her cross": 18, "her hook": 12, "her combination lands": 5, "she is hurt": 2, "a body shot lands on her": 6,
}
THENS = {  # base rate a THEN follows ANY of her punches/moments within 2 s, from other causes (P; John's "1 in 15" for a low right)
    "her right hand is low": 1 / 15, "she lunges in": 1 / 12, "she stands still": 1 / 10, "she goes to the body": 1 / 6,
    "she loads up wild": 1 / 12, "the other's counter lands": 1 / 4,
}
TRUE = {  # real habits: the share of their trigger they fire on (HabitBeats fires a habit about twice a round)
    ("her jab", "her right hand is low"): 0.20, ("her jab", "she lunges in"): 0.20,
    ("her combination lands", "she stands still"): 0.60, ("she is hurt", "she goes to the body"): 0.80,
    ("she is hurt", "she loads up wild"): 0.80,
}
OTHERS = 80  # her other moments a film (the "rest" the contrast is taken against)


def poisson(rng, lam):
    # small-lambda Poisson by multiplication (Knuth)
    import math
    l, k, p = math.exp(-lam), 0, 1.0
    while True:
        p *= rng.random()
        if p <= l:
            return k
        k += 1


def counts(rng, when, then, films):
    k = n = rk = rn = 0
    for _ in range(films):
        nw = max(1, poisson(rng, WHENS[when])) if WHENS[when] >= 5 else poisson(rng, WHENS[when])
        fire = TRUE.get((when, then), 0.0)
        for _ in range(nw):
            n += 1
            if rng.random() < fire or rng.random() < THENS[then]:
                k += 1
        for _ in range(OTHERS - nw):
            rn += 1
            if rng.random() < THENS[then]:
                rk += 1
    return k, n, rk, rn


def word(k, n, rk, rn):
    """The coach's word (map v2 3.3): That's her = k >= 3 and k/n at least 3x the rest's rate (the rest's count floored at 1)."""
    if n == 0 or k <= 1:
        return "nothing"
    contrast = (k / n) / (max(rk, 1) / rn)
    if k >= 3 and contrast >= 3.0:
        return "hers"
    return "maybe"


def main(films_n):
    rng = random.Random(495)
    out = {}
    for when in WHENS:
        for then in THENS:
            for films in (1, 2):
                tally = {"hers": 0, "maybe": 0, "nothing": 0}
                for _ in range(films_n):
                    tally[word(*counts(rng, when, then, films))] += 1
                out[(when, then, films)] = tally
    for films in (1, 2):
        print("== %d film%s ==" % (films, "s" if films > 1 else ""))
        tp = [out[(w, t, films)] for (w, t) in TRUE]
        fp = [out[(w, t, films)] for w in WHENS for t in THENS if (w, t) not in TRUE]
        for (w, t) in TRUE:
            o = out[(w, t, films)]
            print("TRUE  %-26s -> %-26s hers %5.1f%%  maybe %5.1f%%" % (w, t, 100 * o["hers"] / films_n, 100 * o["maybe"] / films_n))
        rate_fp = sum(o["hers"] for o in fp) / (len(fp) * films_n)
        rate_fp_maybe = sum(o["maybe"] for o in fp) / (len(fp) * films_n)
        worst = max(fp, key=lambda o: o["hers"])
        print("NOISE %d claims: hers %.2f%% each (worst %.1f%%), maybe %.1f%%" % (len(fp), 100 * rate_fp, 100 * worst["hers"] / films_n, 100 * rate_fp_maybe))
        tp_rate = sum(o["hers"] for o in tp) / (len(tp) * films_n)
        # How sure a "That's her" is when the player checks claims that look likely: 1 true in 3 checked (a reader), 1 in 10 (a guesser).
        for prior, who in ((1 / 3, "reader"), (1 / 10, "guesser")):
            sure = tp_rate * prior / (tp_rate * prior + rate_fp * (1 - prior))
            print("  a 'That's her' is right %.0f%% of the time for a %s (1 true claim in %d checked)" % (100 * sure, who, round(1 / prior)))
        for prior, who in ((1 / 3, "reader"),):
            tpm = sum(o["maybe"] for o in tp) / (len(tp) * films_n)
            sure = tpm * prior / (tpm * prior + rate_fp_maybe * (1 - prior))
            print("  a 'Maybe' is right %.0f%% of the time for a %s" % (100 * sure, who))


if __name__ == "__main__":
    main(int(sys.argv[1]) if len(sys.argv) > 1 else 1000)
