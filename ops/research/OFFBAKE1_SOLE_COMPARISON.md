# OFFBAKE1 sole gate versus ANIMFIX2 after

One completed run per seed/pair, unchanged animfix1_sole_gate.gd, as_game, native_mh_clips=1, fixed 30 fps, OpenGL, 960x540. Each foot has 1,802 samples over 60.033333 seconds. Values are ANIMFIX2 after -> OFFBAKE1. Baseline commit: `2f6ecc8127d7ce196bd69ad3fac5bae818e63730`.

Bands unchanged: lead pitch 0-12 deg / absolute roll <=10 deg; rear pitch 10-35 deg / absolute roll <=12 deg. Longest counts consecutive frames above 55 deg pitch. These are RED distributions, not a passing gate.

| Seed / body foot | Below | Above | Roll | Outside | Max pitch deg | Longest >55 |
|---|---:|---:|---:|---:|---:|---:|
| 94301 / 08 Left | 0 -> 0 | 1771 -> 1802 | 1710 -> 1798 | 1772 -> 1802 | 50.305 -> 81.783 | 0 -> 4 |
| 94301 / 08 Right | 11 -> 11 | 95 -> 12 | 1755 -> 1787 | 1766 -> 1798 | 79.965 -> 79.965 | 7 -> 6 |
| 94301 / 09 Left | 0 -> 0 | 1752 -> 1761 | 1643 -> 1757 | 1762 -> 1764 | 59.416 -> 60.187 | 2 -> 3 |
| 94301 / 09 Right | 29 -> 21 | 100 -> 55 | 1748 -> 1761 | 1780 -> 1783 | 58.371 -> 63.996 | 3 -> 6 |
| 94301 / 02 Left | 0 -> 0 | 1788 -> 1775 | 1784 -> 1768 | 1788 -> 1781 | 63.800 -> 68.962 | 4 -> 2 |
| 94301 / 02 Right | 10 -> 11 | 67 -> 77 | 1790 -> 1753 | 1800 -> 1765 | 64.035 -> 73.492 | 5 -> 6 |
| 94301 / 05 Left | 0 -> 0 | 1777 -> 1715 | 1767 -> 1722 | 1779 -> 1736 | 56.890 -> 55.618 | 4 -> 1 |
| 94301 / 05 Right | 17 -> 8 | 83 -> 51 | 1777 -> 1749 | 1795 -> 1757 | 79.337 -> 63.038 | 7 -> 6 |
| 930093 / 08 Left | 0 -> 0 | 1800 -> 1800 | 1732 -> 1790 | 1800 -> 1800 | 52.111 -> 88.445 | 0 -> 4 |
| 930093 / 08 Right | 19 -> 19 | 38 -> 41 | 1764 -> 1771 | 1783 -> 1790 | 60.138 -> 79.965 | 5 -> 6 |
| 930093 / 09 Left | 0 -> 0 | 1789 -> 1782 | 1674 -> 1779 | 1793 -> 1794 | 53.305 -> 40.818 | 0 -> 0 |
| 930093 / 09 Right | 18 -> 7 | 80 -> 38 | 1765 -> 1782 | 1784 -> 1790 | 87.978 -> 88.827 | 6 -> 6 |
| 930093 / 02 Left | 0 -> 0 | 1799 -> 1792 | 1789 -> 1780 | 1801 -> 1792 | 63.702 -> 54.045 | 6 -> 0 |
| 930093 / 02 Right | 38 -> 26 | 38 -> 105 | 1747 -> 1762 | 1785 -> 1789 | 60.870 -> 81.022 | 5 -> 10 |
| 930093 / 05 Left | 0 -> 0 | 1802 -> 1770 | 1800 -> 1784 | 1802 -> 1792 | 48.020 -> 62.995 | 0 -> 2 |
| 930093 / 05 Right | 32 -> 6 | 77 -> 27 | 1758 -> 1789 | 1792 -> 1796 | 72.810 -> 72.812 | 7 -> 6 |

Aggregate outside-band samples: 28582 -> 28529 out of 28832. Aggregation does not excuse per-foot regressions; for example seed 94301 MH08 lead peak pitch increases from 50.305 to 81.783 deg. All sixteen feet/runs remain red.

Raw per-frame CSV and JSON are under previews/offbake1/sole_<seed>_<pair>.*. Capture exit reports known ObjectDB/resource/PagedAllocator cleanup errors; no script errors or missing-body/short-run receipts. This is measured evidence, not a clean engine-exit claim.
