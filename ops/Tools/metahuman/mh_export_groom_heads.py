# MH1: export only the reference heads the groom cards were authored on (no character edit, no actor spawn - the
# spawn builds the preset's default-garment 4K/8K textures, ~4 GB each, which froze the PC on 2026-10-02).
import unreal, json, os
EXP = "E:/FightCamp/metahuman_pilot/export02/groom"
rep = {}
for hn in ("MH_Groom_Head", "SKM_Groom_Head_Legacy02"):
    path = f"{EXP}/{hn}.fbx"
    if os.path.exists(path):
        rep[hn] = "exists"; continue
    gh = unreal.load_asset("/MetaHumanCharacter/Optional/Grooms/GroomMesh/" + hn)
    t = unreal.AssetExportTask(); t.object = gh; t.filename = path; t.automated = True; t.prompt = False
    o = unreal.FbxExportOption(); o.level_of_detail = True; o.collision = False; o.export_morph_targets = False; t.options = o
    rep[hn] = (unreal.Exporter.run_asset_export_task(t), [str(e) for e in t.errors])
json.dump(rep, open(EXP + "/heads_report.json", "w"), indent=1, default=str)
