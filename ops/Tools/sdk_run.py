"""sdk_run.py - run ONE worker brief through the Claude Agent SDK, billed to the Console's $200 "API credit (Ultra)" (S537).

Why the SDK: that credit applies to "Agent SDK, API, Batch API, Playground, Managed Agents" - NOT Claude Code, so
`claude -p` (ops/Tools/claude_credit.ps1) is refused with "Credit balance is too low". The key lives OUTSIDE the repo
(%USERPROFILE%\\.fightcamp\\console_api_key.txt) and is passed to this run only; an own config dir keeps the claude.ai login
from winning over the key.

Usage (repo root):  python ops/Tools/sdk_run.py --id TURNPRO15 --budget 12 "Read and do ops/research/TASK_X.md ..."
                    [--model claude-fable-5-2]
Log: ops/AgentComms/credit_runs/<id>.json (result, cost) + one line in credit_runs.log.
"""
import argparse
import asyncio
import datetime
import json
import os
import pathlib

from claude_agent_sdk import ClaudeAgentOptions, ResultMessage, query

ROOT = pathlib.Path(__file__).resolve().parents[2]
HOME = pathlib.Path(os.environ["USERPROFILE"]) / ".fightcamp"


async def run(args) -> dict:
    key = (HOME / "console_api_key.txt").read_text(encoding="utf-8").strip()
    cfg = HOME / "claude_credit_cfg"
    cfg.mkdir(parents=True, exist_ok=True)
    opts = ClaudeAgentOptions(
        model=args.model,
        cwd=str(ROOT),
        permission_mode=args.mode,
        max_budget_usd=args.budget,
        setting_sources=["project"],
        system_prompt={"type": "preset", "preset": "claude_code"},
        env={
            "ANTHROPIC_API_KEY": key,
            "CLAUDE_CONFIG_DIR": str(cfg),
            "CLAUDE_CODE_EXPERIMENTAL_CODE_MODE": "1",  # a worker: idle_guard lets it stop when done
        },
    )
    out = {}
    async for msg in query(prompt=args.prompt, options=opts):
        if isinstance(msg, ResultMessage):
            out = {"subtype": msg.subtype, "is_error": msg.is_error, "result": msg.result,
                   "total_cost_usd": msg.total_cost_usd, "num_turns": msg.num_turns}
    return out


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--id", required=True)
    ap.add_argument("--budget", type=float, default=20)
    ap.add_argument("--model", default="claude-fable-5-2")
    ap.add_argument("--mode", default="auto")  # the classifier stays on, as with claude_credit's old `claude -p` runs
    ap.add_argument("prompt")
    args = ap.parse_args()
    start = datetime.datetime.now().isoformat(timespec="seconds")
    try:
        out = asyncio.run(run(args))
    except Exception as e:  # noqa: BLE001 - log every failure
        out = {"is_error": True, "result": f"{type(e).__name__}: {e}"}
    d = ROOT / "ops" / "AgentComms" / "credit_runs"
    d.mkdir(parents=True, exist_ok=True)
    (d / f"{args.id}.json").write_text(json.dumps(out, indent=2, ensure_ascii=False), encoding="utf-8")
    cost = out.get("total_cost_usd", "?")
    with open(d / "credit_runs.log", "a", encoding="utf-8") as f:
        f.write(f"{start} {args.id} {args.model} sdk budget={args.budget} cost={cost} error={out.get('is_error')}\n")
    print(f"SDK_RUN_DONE {args.id} cost={cost} error={out.get('is_error')} {str(out.get('result'))[:200]}")


if __name__ == "__main__":
    main()
