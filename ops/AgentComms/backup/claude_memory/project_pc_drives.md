---
name: project-pc-drives
description: Operator's drives - C NVMe SSD (system, keep free), E SATA SSD, D old 1.5 TB WD Green HDD; use D whenever speed does not matter (operator 2026-09-26)
metadata:
  type: project
---
Measured 2026-09-26 (Get-PhysicalDisk): **C: = Crucial P310 NVMe SSD, 465 GB** (Windows; it filled to 3.7 GB free on
2026-09-26 and lagged the PC - operator moved New World off it). **E: = SanDisk SATA SSD, 447 GB** (~76 GB free).
**D: = WD Green WD15EARS 1.5 TB HDD, old and slow** (~912 GB free). Operator 2026-09-26: "try to use d when ssd and old
hdd dont matter".

**Why:** C: must keep room for Windows (page file, temp); the HDD has space but is slow. **How to apply:** downloads,
archives, caches, old scratch, installers, datasets, video captures -> D:. Things read hot and often (a Godot project,
a venv or model loaded every run, a build cache) -> E: if speed matters, not C:. Nothing new on C: beyond what must
live there. ACE-Step sits on D:\AI (model load is once per run - acceptable). See
[[feedback-check-pc-before-heavy-jobs]].
