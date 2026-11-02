---
name: reference-motorsport-manager-install
description: Motorsport Manager is installed at E:\SteamLibrary\steamapps\common\Motorsport Manager; its setup/pit logic was read from the DLL with dnfile (S96)
metadata:
  type: reference
---
Operator's own copy: `E:\SteamLibrary\steamapps\common\Motorsport Manager` (Unity; code in `MM_Data/Managed/Assembly-CSharp.dll`, UI/tutorial text in `MM_Data/resources.assets`, Modding/ folders empty). No decompiler on the PC; `pip` dnfile 0.18 reads type/field/method names and IL float constants (scratchpad scripts mm_types.py / mm_il.py pattern). Measured: SetupInput -1..1 step 0.01; GetSetupOpinion bands 0.03/0.10/0.20/0.30; knowledge band 1.0/0.75/0.3; radio feedback 20-120 s; pit safe/balanced/fast error. Study: research/S96_MOTORSPORT_MANAGER_SETUP_TO_THE_CORNER.md. Design study only - nothing from it ships.
