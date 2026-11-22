"""card_loop.py - run the card-game loop (ops/research/TASK_CARDLOOP.md) unattended on the API credit (S537, owner: "let the card
game continue on the plan").

Each round n: a FRESH SDK critic scores round n (ops/research/CARDPROTO<n>_CRITIC_SDK.md); if DEPTH >= 8 and PLAY >= 8 the
loop stops (the owner is asked on the board per the brief); else, if n < 6, an SDK build job does round n+1. Kalli's answers
(seat queue) are read by the build job when present. Usage: python ops/Tools/card_loop.py --from 4 [--wait-build CARDLOOP4]
"""
import argparse
import pathlib
import re
import subprocess
import sys
import time

ROOT = pathlib.Path(__file__).resolve().parents[2]
LOG = ROOT / "ops" / "AgentComms" / "credit_runs" / "credit_runs.log"
RES = ROOT / "ops" / "research"
CO = "Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"


def sdk(run_id: str, budget: float, prompt: str) -> None:
    subprocess.run([sys.executable, str(ROOT / "ops/Tools/sdk_run.py"), "--id", run_id, "--budget", str(budget), prompt],
                   cwd=ROOT, check=False)


def wait_for(run_id: str) -> None:
    while not (LOG.exists() and re.search(rf" {re.escape(run_id)} ", LOG.read_text(encoding="utf-8", errors="replace"))):
        time.sleep(60)


def scores(n: int) -> tuple[float, float]:
    f = RES / f"CARDPROTO{n}_CRITIC_SDK.md"
    if not f.exists():
        return 0.0, 0.0
    t = f.read_text(encoding="utf-8", errors="replace")
    def one(name: str) -> float:
        m = re.search(rf"{name}[^|\n]*\|\s*\**\s*([0-9.]+)\s*/\s*10", t)
        return float(m.group(1)) if m else 0.0
    return one("DEPTH"), one("PLAY")


def critic(n: int) -> None:
    sdk(f"CARDPROTO{n}CRIT", 5, (
        f"You are a FRESH critic with no author context. Read ops/research/TASK_CARDLOOP.md section 'The second critic' "
        f"and do it for round {n}: follow ops/research/TASK_CARDPROTO3_CRITIC_ARENA.md, play 20+ bouts through node on "
        f"proto/cardgame (do not edit proto/), write only ops/research/CARDPROTO{n}_CRITIC_SDK.md with a '## Scores' table "
        f"(rows DEPTH, PLAY (fun), GENERAL as '| DEPTH | **x / 10** | ... |'), evidence, missing/useless cards and an ordered "
        f"TO REACH 10/10 list. Commit that one file by pathspec with '{CO}', pull --no-rebase --no-edit, push. Report in "
        f"two lines and stop."))


def build(n: int) -> None:
    sdk(f"CARDLOOP{n}", 15, (
        f"Do round {n} of ops/research/TASK_CARDLOOP.md (S537). Critic input: ops/research/CARDPROTO{n-1}_CRITIC_SDK.md "
        f"(its TO REACH 10/10 list first) and, if present, CARDPROTO{n-1}_CRITIC_KALLI_KALLI.md and any older Kalli answer "
        f"not yet acted on. Follow the loop steps 2-6 exactly (owned files only, never weaken a test, all node tests + "
        f"balance.mjs green, commit by pathspec, queue the CARDPROTO{n} Kalli critic). Report in two lines and stop."))


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--from", dest="start", type=int, required=True)
    ap.add_argument("--wait-build", default="")
    a = ap.parse_args()
    if a.wait_build:
        wait_for(a.wait_build)
    n = a.start
    while True:
        critic(n)
        d, p = scores(n)
        print(f"CARD_LOOP round {n}: DEPTH {d} PLAY {p}", flush=True)
        if d >= 8 and p >= 8:
            print("CARD_LOOP PASS: stop, owner question per TASK_CARDLOOP 'When 8+/8+'", flush=True)
            return
        if n >= 6:
            print("CARD_LOOP round 6 under 8: ask the owner cut or keep", flush=True)
            return
        n += 1
        build(n)


if __name__ == "__main__":
    main()
