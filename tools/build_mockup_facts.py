"""Builds docs/mockups/s403/facts.js from facts.json + roster_mma8.json (S403 round 4), so every menu mockup reads one set of facts.
Usage: python tools/build_mockup_facts.py"""
import json
import pathlib

HERE = pathlib.Path(__file__).resolve().parent.parent / "docs" / "mockups" / "s403"


def build() -> dict:
    facts = json.loads((HERE / "facts.json").read_text(encoding="utf-8"))
    roster = json.loads((HERE / "roster_mma8.json").read_text(encoding="utf-8"))
    extra = facts.pop("extra")
    facts.pop("_doc", None)
    for f in roster["fighters"]:
        key = f["name"].split()[0].lower()
        row = {k: f[k] for k in ("name", "age", "class", "record", "rank", "base", "read", "tag", "stance", "height_cm", "reach_cm", "portrait")}
        row["first"] = f["name"].split()[0]
        row["p"] = {k: v["now"] for k, v in f["primary"].items()}
        row["p_cap"] = {k: v["cap"] for k, v in f["primary"].items()}
        row["s"] = {k: v["now"] for k, v in f["skills"].items()}
        row["s_cap"] = {k: v["cap"] for k, v in f["skills"].items()}
        row["moves"] = f["moves"]
        row.update(extra.get(key, {}))
        facts[key] = row
    facts["primary"] = roster["primary"]
    facts["skills"] = roster["skills"]
    return facts


if __name__ == "__main__":
    out = HERE / "facts.js"
    out.write_text("window.FACTS=" + json.dumps(build(), ensure_ascii=False, indent=0) + ";\n", encoding="utf-8")
    print(out)
