"""make_head.py - head.html: the head-movement page, BUILT from order.html (S570, ONERULES1).

Owner S569: "shouldnt kicks and everything else get worked all at once ? because how it knows the current changes ?"
head.html was a hand-kept copy of order.html (S559 HEADMOVE1, S561 HEADPICS1) and missed the rules fixed on order.html after
it (the v0.568.12 feint fix, the S560 pull counter). Now it is order.html + the head rules as text pairs
(ops/research/s558_balance/head_page.json). Same builder as make_kick.py.

    python proto/twohands/tools/make_head.py [a measured tweak .json applied after the head rules]
"""
from __future__ import annotations

import sys
from pathlib import Path

from make_kick import HERE, ROOT, build

if __name__ == "__main__":
    build(ROOT / "ops/research/s558_balance/head_page.json", HERE.parent / "head.html", "MAKE_HEAD",
          Path(sys.argv[1]) if len(sys.argv) > 1 else None)
