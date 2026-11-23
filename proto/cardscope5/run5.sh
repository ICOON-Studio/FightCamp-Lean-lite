#!/bin/sh
# round 5 chain as it was run: size on sizing seeds (300000 + 1000003 * s), freeze, test, then the measured run ONCE on other seeds
cd "$(dirname "$0")"
# sizing: eleven passes of tune.mjs (first improvement, one seed each), then tune2.mjs (batch screened on seeds 21-23,
# kept only if better on validation seeds 31-34; numbers and deck counts). The last pass:
# node tune2.mjs rounds=70 per=40 s=21,22,23 vper=150 v=31,32,33,34 batch=30 procs=6 in=sized.json out=tuned_o.json > out/tune_o.log 2>&1
# cp out/tuned_o.json sized.json
node --test engine.test.mjs > out/test.log 2>&1
node probe.mjs all per=200 seed=500000000 tag=m_all > out/m_all.log 2>&1
cp out/m_all.txt measured/m_all.txt; cp out/m_all.json measured/m_all.json
node report.mjs > measured/cards_as_sized.md
