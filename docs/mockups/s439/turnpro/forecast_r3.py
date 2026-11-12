import random, statistics, sys
H1, H2 = 182, 364
GRID = [33,61,103,131,173,201,243,271,313,341]
DUES_WK = 35/4.33
def dues_win(t,H): return 89 + 3*DUES_WK*max(0,(H-t))/7 if t < H else 0
def dues_loss(t,H): return -1.2*DUES_WK*max(0,(H-t))/7 if t < H else 0
LIC = 1245
def debut_gym(wins, titles, terms, members=96):
    sold = min(100, 20 + members//2 + 2*wins + 10*titles)
    return 0.25*0.5*50*max(0,sold-60)*terms
def sat_after(day, weeks):  # day rel to d0 (Mon=0)
    return day - (day % 7) + 5 + weeks*7

class Run:
    def __init__(s, job): s.job=job; s.m={H1:0.0,H2:0.0}; s.log=[]; s.pro_day=None; s.seated_by=None; s.prow=0; s.title=False; s.bouts=0; s.wins=0
    def add(s, t, v):
        for H in (H1,H2):
            if t < H: s.m[H]+=v
    def weekly(s, t0, t1, v):
        for H in (H1,H2):
            a,b=max(0,t0),min(H,t1)
            if b>a: s.m[H]+= v*(b-a)/7
    def result(s, t, won):
        s.bouts += 1
        for H in (H1,H2):
            s.m[H] += dues_win(t,H) if won else dues_loss(t,H)

def pro_road(r, rng, sign_day, debut_weeks, terms, seated_at_debut, wins_am, titles, debut_p, stipend_on, flat_after_loss):
    # licences now; stipend to the debut (NEW); debut; ladder every 8 weeks (ESTIMATE gap -4)
    r.add(sign_day, -LIC)
    debut = sat_after(sign_day, debut_weeks)
    r.weekly(sign_day, debut, -250)  # NEW: the club pays the stipend from signing to the debut
    r.pro_day = debut
    won = rng.random() < debut_p
    r.result(debut, won); r.add(debut, debut_gym(wins_am, titles, terms))
    if won: r.prow += 1
    fans = 1 if won else 0
    seated = seated_at_debut
    if seated: r.seated_by = debut
    t = debut + 56; lost_last = not won
    pw, pl = r.prow, (0 if won else 1)
    ducks = 0
    while t < H2:
        p = 0.82 - (0.03 if (lost_last and flat_after_loss) else 0.0)
        purse = 1900 if seated else 1500
        tickets = 150*(fans+5)*0.733
        r.add(t, 0.19*(purse+tickets)*terms)
        w = rng.random() < p
        r.result(t, w)
        r.ladder = getattr(r,'ladder',0) + (1 if t < H1 else 0)
        if w: pw += 1; fans += 1
        else: pl += 1; fans = max(0,fans-1)
        if ducks < 2: ducks += 1; fans = max(0, fans-1)   # a tune-up taken over the step up: a duck, one fan (CODE)
        lost_last = not w
        if not seated and pw >= 5 and pw > pl: seated = True; r.seated_by = t
        t += 56
    r.prow = pw

def sim(answer, job=False, sub="enter", debut_weeks=4, n=40000, seed=7, W0=7, champ=(0.65,0.55,0.5), dp=(0.63,0.67), club_p=0.65):
    rng = random.Random(seed)
    stip = not job
    pc = (lambda t: club_p) if not job else (lambda t: club_p-0.01 if t<70 else (club_p-0.03 if t<182 else club_p-0.05))
    psemi, pfin, pnat = champ if not job else (champ[0]-0.03,champ[1]-0.05,champ[2]-0.04)
    runs=[]
    for _ in range(n):
        r = Run(job); wins=W0; rank=2
        if answer=="pro":
            # Jade wish nationals -> overruled 64->49, debut booking +5 -> 54 Steady (no ring change); a debut loss -> Flat
            pro_road(r, rng, 0, debut_weeks, 1.0, False, wins, 0, (dp[0] if debut_weeks==4 else dp[1]), stip, True)
            runs.append(r); continue
        hold = answer=="hold"
        enter = hold or sub=="enter"
        declines = 0 if hold else 1
        t_cursor=0; turned=False
        retainer_end=None
        def club(t):
            nonlocal wins
            if stip: pass
            r.add(t,450); w = rng.random()<pc(t); r.result(t,w)
            if w: wins+=1
            return w
        sched = [33,61] if enter else GRID[:]
        miss_streak_needed=None; streak=0; wins_at_miss=None
        def ready():
            if declines>=3: return False
            if declines>=2: return rank==1 and wins>=wins_at_miss+2
            return (wins>=W0+2 and rank<=3) or wins>=W0+4
        end_amateur=H2
        for t in sched:
            club(t)
            if not enter and ready():
                pro_road(r, rng, t+2, 4, 0.9, False, wins, 0, 0.66, stip, False); end_amateur=t+2; turned=True; break
        if enter and not turned:
            run_end=84; regional=False
            if rng.random()<psemi:
                wins+=1; r.result(77,True)
                if rng.random()<pfin:
                    wins+=1; r.result(84,True); regional=True; r.title=True; rank=1; titles=1
                    for d in (106,112,113):
                        run_end=d
                        if rng.random()<pnat: wins+=1; r.result(d,True)
                        else: r.result(d,False); break
                    else: titles=2
                else: r.result(84,False)
            else:
                r.result(77,False); run_end=77
            if hold:
                
                if stip: r.weekly(0, run_end, 150)   # Bow Lane's holding money toward the stipend (NEW)
                if regional:
                    sign = run_end - (run_end%7) + 7  # the Monday after
                    pro_road(r, rng, sign, 4, 1.0, True, wins, titles, 0.68, stip, False); end_amateur=sign; turned=True
                else:
                    declines=2; wins_at_miss=wins
            else:
                if ready():
                    sign = run_end - (run_end%7) + 7
                    pro_road(r, rng, sign, 4, 0.9, False, wins, (titles if regional else 0), 0.68 if regional else 0.66, stip, False); end_amateur=sign; turned=True
            if not turned:
                for t in [g for g in GRID if g >= run_end+17]:
                    w=club(t)
                    if declines>=2:
                        streak = streak+1 if w else 0
                        if streak>=4: rank=1
                    if ready():
                        pro_road(r, rng, t+2, 4, 0.9, False, wins, 0, 0.66, stip, False); end_amateur=t+2; turned=True; break
        if stip: r.weekly(0, end_amateur, -250)
        runs.append(r)
    def E(f): return statistics.mean(f(x) for x in runs)
    out = dict(jul=E(lambda x:x.m[H1]), jan=E(lambda x:x.m[H2]),
        pro_jul=E(lambda x: x.pro_day is not None and x.pro_day< H1), pro_jan=E(lambda x: x.pro_day is not None and x.pro_day<H2),
        seat_jan=E(lambda x: x.seated_by is not None and x.seated_by<H2), title=E(lambda x:x.title), bouts=E(lambda x:x.bouts), prow=E(lambda x:x.prow))
    if answer=="hold" or (answer=="notyet" and sub=="enter"):
        T=[x for x in runs if x.title]; M=[x for x in runs if not x.title]
        out["title_jul"]=statistics.mean(x.m[H1] for x in T); out["title_jan"]=statistics.mean(x.m[H2] for x in T)
        out["miss_jul"]=statistics.mean(x.m[H1] for x in M); out["miss_jan"]=statistics.mean(x.m[H2] for x in M)
        out["miss_pro_jan"]=statistics.mean((x.pro_day is not None and x.pro_day<H2) for x in M)
    return out

def show(tag, **kw):
    print("==",tag)
    for a,sub,dw in [("pro","",4),("pro","",8),("hold","",4),("notyet","enter",4),("notyet","clubs",4)]:
        o=sim(a,sub=sub,debut_weeks=dw,**kw)
        print(" ",a,sub,dw, {k:round(v,2) for k,v in o.items()})
show("A Jade stipend (overruled on pro)")
show("A2 Jade day job (wish pro: pro heard)", job=True, dp=(0.66,0.70))
show("B 9-1 No1 stipend, no wish", W0=9, champ=(0.72,0.62,0.55), dp=(0.70,0.74), club_p=0.72)
