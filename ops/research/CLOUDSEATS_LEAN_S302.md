# Cloud seats on the Lean repo (S302) - what it needs from you

The new game lives in the private repo ICOON-Studio/FightCamp-Lean. The cloud seats cannot work there yet:

1. GOOSE (runs on GitHub Actions, free minutes): needs the Qwen API key as a secret on the Lean repo
   (`QWEN_API_KEY`, the same key the old repo uses). GitHub never lets anyone read a stored secret back, so it
   cannot be copied from the old repo. Either you paste it in GitHub (Lean repo > Settings > Secrets and
   variables > Actions > New secret, name QWEN_API_KEY), or you let me set it from the Qwen key already on this PC.
   Then I copy the Goose workflow into the Lean repo and Goose takes pure modules + tests in the cloud.
2. ARENA (free): only works on a PUBLIC repo. For the old game that was the code-only mirror FightCamp-lite. For
   Lean it would be a new public mirror of the code (no art, no models): anyone could read the game's code.

Until then the PC seats (Qwen, Cursor) do the Lean code work, three at a time.
