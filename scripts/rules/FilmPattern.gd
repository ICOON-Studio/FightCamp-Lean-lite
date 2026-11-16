extends RefCounted
## FILMPATTERN1 - the film game's rules: what can be marked, the coach's check,
## the words and figures, which claim finds which tell. Pure module; no class_name,
## static funcs only, preload nothing. Map: ops/research/FIGHTFILM1_MAP_V3_S495.md
## sections 3.1-3.6.

## WHEN ids and words (9)
const WHEN_IDS: Array = [
	"jab", "cross", "hook", "combo", "hurt", "last_min", "round1", "after_body", "walked"]
const WHEN_WORDS: Array = [
	"their jab", "their cross", "their hook", "their combination lands",
	"they are hurt", "the last minute of a round", "round 1",
	"the 30 seconds after a body shot lands on them",
	"an exchange where the other walks them down"]

## THEN ids and words (8)
const THEN_IDS: Array = [
	"right_low", "lunged", "stood", "to_body", "wild", "countered", "fewer", "outlanded"]
const THEN_WORDS: Array = [
	"right hand low", "lunged in", "stood still", "throws to the body",
	"a wild swing", "the other's counter lands", "throws fewer", "gets out-landed"]

## Bars
const PASS_Z := 2.33
const MAYBE_Z := 1.28
const PASS_K := 3
const MAYBE_K := 2
const MIN_N := 3
const PASS_P := 0.01
const MAYBE_P := 0.10
const AFTER_PASS_P := 0.03  # S503: the after-a-moment pass also needs the exact tail

## Figures
const ONE_FILM := 0.70
const TWO_FILMS := 0.85
const MAYBE_ONE := 0.30
const MAYBE_POOLED := 0.20
const ALONE := 0.30

## Checks
const PER_FILM_CAP := 2
const COACH_SECOND_TELL := 70


## The 72 WHEN x THEN pairs as {when, then, words}.
static func claims() -> Array:
	var out: Array = []
	for i in WHEN_IDS.size():
		for j in THEN_IDS.size():
			out.append({
				"when": WHEN_IDS[i],
				"then": THEN_IDS[j],
				"words": "%s -> %s" % [WHEN_WORDS[i], THEN_WORDS[j]]
			})
	return out


## Tonight's checks: min(rating checks, 2 x opp_films - used_on_opp), never below 0.
static func checks(coach_rating: int, has_coach: bool, used_on_opp: int, opp_films: int) -> int:
	var cap: int = 2 * opp_films
	var remaining: int = cap - used_on_opp
	if remaining < 0:
		remaining = 0
	var rating_checks: int
	if not has_coach:
		rating_checks = 2
	elif coach_rating < 60:
		rating_checks = 2
	elif coach_rating < 80:
		rating_checks = 3
	else:
		rating_checks = 4
	if rating_checks < remaining:
		return rating_checks
	return remaining


## The "fact after a moment" bar (map 3.3).
## rate_rest = rest_k / max(rest_n, 1); E = n * rate_rest;
## spread = sqrt(E + E * n / max(rest_n, 1)) (rest count at least 1);
## z = (k - E) / spread (spread 0 -> z = 0 when k == E, else 99.0).
static func after_moment(k: int, n: int, rest_k: int, rest_n: int) -> Dictionary:
	if n < MIN_N:
		return {"word": "not_enough", "k": k, "n": n, "e": 0.0, "z": 0.0, "p": 1.0}
	var safe_rest_n: int = rest_n if rest_n >= 1 else 1
	var rate_rest: float = float(rest_k) / float(safe_rest_n)
	var e: float = float(n) * rate_rest
	var raw_spread2: float = e + e * float(n) / float(safe_rest_n)
	var spread2: float = raw_spread2 if raw_spread2 > 0.0 else 0.0
	var spread: float = sqrt(spread2)
	var z: float
	if spread == 0.0:
		if k == int(round(e)):
			z = 0.0
		else:
			z = 99.0
	else:
		z = (float(k) - e) / spread
	var p: float = tail_p(k, n, rest_k, rest_n) if rest_n >= 1 else 1.0
	var word: String
	if rest_n < 1:
		word = "nothing"
	elif k >= PASS_K and z >= PASS_Z and p <= AFTER_PASS_P:  # S503: the exact tail too - z alone passed rare THENs (k=3, rest_k=0 -> z 99)
		word = "pass"
	elif k >= MAYBE_K and z >= MAYBE_Z:
		word = "maybe"
	else:
		word = "nothing"
	return {"word": word, "k": k, "n": n, "e": e, "z": z, "p": p}


## throws_fewer: conditional binomial test of two rates.
## Under H0: inside_rate = slowdown * outside_rate (r0 = slowdown).
## q = (inside_min * r0) / (inside_min * r0 + outside_min).
## Given total = inside + outside, under H0: inside ~ Binomial(total, q).
## Test: P(X <= inside) - the lower tail (fewer throws inside).
## E and z kept byte-for-byte from round 1 for backwards compatibility.
static func throws_fewer(inside: int, inside_min: float, outside: int, outside_min: float, slowdown: float) -> Dictionary:
	var n: int = inside + outside
	if n < MIN_N:
		return {"word": "not_enough", "k": 0, "n": n, "e": 0.0, "z": 0.0, "p": 1.0}
	var safe_out_min: float = outside_min if outside_min > 0.01 else 0.01
	var e: float = (float(outside) / safe_out_min) * inside_min * slowdown
	var safe_out: int = outside if outside >= 1 else 1
	var raw_spread2: float = e + (e * e) / float(safe_out)
	var spread2: float = raw_spread2 if raw_spread2 > 0.0 else 0.0
	var spread: float = sqrt(spread2)
	var k_val: int = roundi(e - float(inside))
	var z: float
	if spread == 0.0:
		if k_val == 0:
			z = 0.0
		else:
			z = 99.0
	else:
		z = (e - float(inside)) / spread
	var r0: float = slowdown
	var q: float = (inside_min * r0) / (inside_min * r0 + outside_min)
	var p: float = binom_tail_low(inside, n, q)
	var word: String
	if k_val >= PASS_K and p <= PASS_P:
		word = "pass"
	elif k_val >= MAYBE_K and p <= MAYBE_P:
		word = "maybe"
	else:
		word = "nothing"
	return {"word": word, "k": k_val, "n": n, "e": e, "z": z, "p": p}


## outlanded: conditional binomial test of two rates.
## Under H0: in_rate = out_rate (r0 = 1.0).
## q = in_min / (in_min + out_min).
## Given total = in_landed + out_landed, under H0: in_landed ~ Binomial(total, q).
## Test: P(X >= in_landed) - the upper tail (more landed inside).
## E and z kept byte-for-byte from round 1 for backwards compatibility.
static func outlanded(in_landed: int, in_min: float, out_landed: int, out_min: float) -> Dictionary:
	var n: int = in_landed + out_landed
	if n < MIN_N:
		return {"word": "not_enough", "k": 0, "n": n, "e": 0.0, "z": 0.0, "p": 1.0}
	var safe_out_min: float = out_min if out_min > 0.01 else 0.01
	var e: float = (float(out_landed) / safe_out_min) * in_min
	var safe_out: int = out_landed if out_landed >= 1 else 1
	var raw_spread2: float = e + (e * e) / float(safe_out)
	var spread2: float = raw_spread2 if raw_spread2 > 0.0 else 0.0
	var spread: float = sqrt(spread2)
	var k_val: int = roundi(float(in_landed) - e)
	var z: float
	if spread == 0.0:
		if k_val == 0:
			z = 0.0
		else:
			z = 99.0
	else:
		z = (float(in_landed) - e) / spread
	var r0: float = 1.0
	var q: float = (in_min * r0) / (in_min * r0 + out_min)
	var p: float = binom_tail_high(in_landed, n, q)
	var word: String
	if k_val >= PASS_K and p <= PASS_P:
		word = "pass"
	elif k_val >= MAYBE_K and p <= MAYBE_P:
		word = "maybe"
	else:
		word = "nothing"
	return {"word": word, "k": k_val, "n": n, "e": e, "z": z, "p": p}


## Two films' raw counts added key by key; numbers add, anything else from a.
static func pool(a: Dictionary, b: Dictionary) -> Dictionary:
	var out: Dictionary = {}
	for key in a:
		out[key] = a[key]
	for key in b:
		var va = a.get(key, null)
		var vb = b[key]
		if va is int and vb is int:
			out[key] = int(va) + int(vb)
		elif va is float and vb is float:
			out[key] = float(va) + float(vb)
		elif va == null:
			out[key] = vb
		# else keep a's value
	return out


## The game with most exchanges; "pass" when share >= 0.40, else "nothing".
static func report_game(mode_counts: Dictionary) -> Dictionary:
	var best_game := ""
	var best_count: int = 0
	var total: int = 0
	for g in mode_counts:
		var c: int = int(mode_counts[g])
		total += c
		if c > best_count:
			best_count = c
			best_game = str(g)
	var share: float = 0.0
	if total > 0:
		share = float(best_count) / float(total)
	var word: String = "pass" if share >= 0.40 else "nothing"
	return {"word": word, "game": best_game, "share": share}


## The punch landing clean most; "pass" when >= 3 AND strictly more than any other.
static func report_weapon(clean_counts: Dictionary) -> Dictionary:
	var best_punch := ""
	var best_count: int = 0
	var second_count: int = 0
	for p in clean_counts:
		var c: int = int(clean_counts[p])
		if c > best_count:
			second_count = best_count
			best_count = c
			best_punch = str(p)
		elif c > second_count:
			second_count = c
	var word: String = "nothing"
	if best_count >= 3 and best_count > second_count:
		word = "pass"
	return {"word": word, "punch": best_punch, "count": best_count}


## Figure for a word x films x alone.
static func figure(word: String, films: int, alone: bool) -> float:
	if alone:
		if word == "pass":
			return ALONE
		return 0.0
	if word == "pass":
		if films >= 2:
			return TWO_FILMS
		return ONE_FILM
	if word == "maybe":
		if films >= 2:
			return MAYBE_POOLED
		return MAYBE_ONE
	return 0.0


## Word text: "That's it", "Maybe", "Not enough moments", "Nothing there" (S498: no her/him in a script's text - the
## house rule no_pronoun_test keeps; `pronoun` stays in the signature for its callers).
static func word_text(word: String, _pronoun: String = "") -> String:
	if word == "pass":
		return "That's it"
	if word == "maybe":
		return "Maybe"
	if word == "not_enough":
		return "Not enough moments"
	return "Nothing there"


## Which real tell a claim finds (map 3.6), "" for noise.
## habits are FighterProfile habit ids.
static func matches(habits: Array, weak_words: String, claim: Dictionary) -> String:
	var weak: String = weak_words.to_lower()  # the scout writes "Fades after round 2"
	var w: String = str(claim.get("when", ""))
	var t: String = str(claim.get("then", ""))
	# jab + right_low -> habit:drops_right_after_jab
	if w == "jab" and t == "right_low":
		if habits.has("drops_right_after_jab"):
			return "habit:drops_right_after_jab"
		return ""
	# jab + lunged -> habit:lunges_with_jab
	if w == "jab" and t == "lunged":
		if habits.has("lunges_with_jab"):
			return "habit:lunges_with_jab"
		return ""
	# combo + stood -> habit:admires_her_work
	if w == "combo" and t == "stood":
		if habits.has("admires_her_work"):
			return "habit:admires_her_work"
		return ""
	# hurt + to_body -> habit:digs_body_when_hurt
	if w == "hurt" and t == "to_body":
		if habits.has("digs_body_when_hurt"):
			return "habit:digs_body_when_hurt"
		return ""
	# hurt + wild -> habit:loads_up_when_hurt
	if w == "hurt" and t == "wild":
		if habits.has("loads_up_when_hurt"):
			return "habit:loads_up_when_hurt"
		return ""
	# last_min + fewer -> habit:fades_late or weakness
	if w == "last_min" and t == "fewer":
		if habits.has("fades_late"):
			return "habit:fades_late"
		if weak.contains("fade") or weak.contains("legs late"):
			return "weakness"
		return ""
	# round1 + fewer -> habit:slow_starter or weakness
	if w == "round1" and t == "fewer":
		if habits.has("slow_starter"):
			return "habit:slow_starter"
		if weak.contains("slow to start") or weak.contains("round 1"):
			return "weakness"
		return ""
	# after_body + fewer -> weakness when weak contains "body"
	if w == "after_body" and t == "fewer":
		if weak.contains("body"):
			return "weakness"
		return ""
	# walked + outlanded -> weakness when weak contains pressure words
	if w == "walked" and t == "outlanded":
		if weak.contains("backed up") or weak.contains("backs straight") or weak.contains("pressure"):
			return "weakness"
		return ""
	return ""


## "Let the coach watch": the first one (rating < 70) or two (70+) hidden tells
## in tape order, each {id, figure: 0.70}.
static func coach_watch(tells_in_order: Array, rating: int) -> Array:
	var limit: int = 2 if rating >= COACH_SECOND_TELL else 1
	var out: Array = []
	for t in tells_in_order:
		if out.size() >= limit:
			break
		var tid: String = str(t.get("id", ""))
		var state: String = str(t.get("state", ""))
		if state == "hidden":
			out.append({"id": tid, "figure": 0.70})
	return out


## Log-factorial for exact tests (counts stay under a few thousand).
static func _lnfact(n: int) -> float:
	var s: float = 0.0
	for i in range(2, n + 1):
		s += log(float(i))
	return s


## One-sided Fisher exact tail: P(X >= k) for hypergeometric(n, k+rest_k, n+rest_n).
## k=0 -> 1.0; any empty side (n=0, rest_n=0) -> 1.0.
static func tail_p(k: int, n: int, rest_k: int, rest_n: int) -> float:
	if n <= 0 or rest_n <= 0:
		return 1.0
	var total_n: int = n + rest_n
	var total_k: int = k + rest_k
	if total_k <= 0:
		return 1.0
	if k <= 0:
		return 1.0
	var max_x: int = mini(n, total_k)
	if k > max_x:
		return 0.0
	var ln_total: float = _lnfact(total_n)
	var p: float = 0.0
	for x in range(k, max_x + 1):
		var ln_p_x: float = (_lnfact(total_k) - _lnfact(x) - _lnfact(total_k - x)
			+ _lnfact(total_n - total_k) - _lnfact(n - x) - _lnfact(total_n - total_k - n + x)
			+ _lnfact(n) + _lnfact(total_n - n) - ln_total)
		p += exp(ln_p_x)
	if p > 1.0:
		p = 1.0
	return p


## Poisson lower tail: P(X <= obs) for parameter lambda.
static func poisson_tail_low(obs: int, lam: float) -> float:
	if lam <= 0.0:
		if obs >= 0:
			return 1.0
		return 0.0
	var term: float = exp(-lam)
	var cdf: float = term
	for i in range(1, obs + 1):
		term *= lam / float(i)
		cdf += term
	if cdf > 1.0:
		cdf = 1.0
	return cdf


## Poisson upper tail: P(X >= obs) for parameter lambda.
static func poisson_tail_high(obs: int, lam: float) -> float:
	if lam <= 0.0:
		if obs <= 0:
			return 1.0
		return 0.0
	if obs <= 0:
		return 1.0
	return 1.0 - poisson_tail_low(obs - 1, lam)


## Binomial lower tail: P(X <= k) for X ~ Binomial(n, q).
## Computed term by term in log space to avoid overflow.
static func binom_tail_low(k: int, n: int, q: float) -> float:
	if q <= 0.0:
		return 1.0
	if q >= 1.0:
		if k >= n:
			return 1.0
		return 0.0
	if k < 0:
		return 0.0
	if k >= n:
		return 1.0
	var ln_q: float = log(q)
	var ln_1mq: float = log(1.0 - q)
	var cdf: float = 0.0
	for i in range(0, k + 1):
		var ln_term: float = _lnfact(n) - _lnfact(i) - _lnfact(n - i) + float(i) * ln_q + float(n - i) * ln_1mq
		cdf += exp(ln_term)
	if cdf > 1.0:
		cdf = 1.0
	return cdf


## Binomial upper tail: P(X >= k) for X ~ Binomial(n, q).
## Computed term by term in log space to avoid overflow.
static func binom_tail_high(k: int, n: int, q: float) -> float:
	if q <= 0.0:
		if k <= 0:
			return 1.0
		return 0.0
	if q >= 1.0:
		return 1.0
	if k <= 0:
		return 1.0
	if k > n:
		return 0.0
	var ln_q: float = log(q)
	var ln_1mq: float = log(1.0 - q)
	var tail: float = 0.0
	for i in range(k, n + 1):
		var ln_term: float = _lnfact(n) - _lnfact(i) - _lnfact(n - i) + float(i) * ln_q + float(n - i) * ln_1mq
		tail += exp(ln_term)
	if tail > 1.0:
		tail = 1.0
	return tail
