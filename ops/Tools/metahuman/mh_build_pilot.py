# MH1 build: create the pilot MetaHuman (male athletic boxer) and export its meshes + bundled eye/skin-detail
# textures to E:/FightCamp/metahuman_pilot/export. Runs in the UnrealEditor-Cmd pythonscript commandlet
# (no Slate: export_geometry() crashes there on SyncBrowserToAssets, so the preview actor's meshes are exported).
import unreal, json, traceback, os
EXP = "E:/FightCamp/metahuman_pilot/export"
OUT = EXP + "/build_report.json"
os.makedirs(EXP, exist_ok=True)
rep = {}
def log(k, v):
    rep[k] = v
    unreal.log("MH1 " + k + " = " + str(v)[:2000])

# Athletic male boxer, 183 cm (welterweight-to-middleweight frame). Body constraints are the MetaHuman Creator's
# parametric body measurements (cm), plus its three macro sliders.
BODY = {"height": 183.0, "muscularity": 1.4, "fat": -1.3, "masculine/feminine": -1.6,
        "waist": 80.0, "chest": 106.0, "neck": 40.0, "bicep": 36.0, "across_shoulder": 41.0}

def export_obj(obj, path, exporter=None):
    t = unreal.AssetExportTask()
    t.object = obj
    t.filename = path
    t.automated = True
    t.prompt = False
    t.replace_identical = True
    if exporter is not None:
        t.exporter = exporter
    if path.lower().endswith(".fbx"):
        o = unreal.FbxExportOption()
        o.vertex_color = True
        o.level_of_detail = True
        o.collision = False
        o.export_morph_targets = False
        o.export_preview_mesh = False
        t.options = o
    ok = unreal.Exporter.run_asset_export_task(t)
    return ok, [str(e) for e in t.errors]

try:
    sub = unreal.get_editor_subsystem(unreal.MetaHumanCharacterEditorSubsystem)
    at = unreal.AssetToolsHelpers.get_asset_tools()
    ch = unreal.load_asset("/Game/MH/MH_Pilot01.MH_Pilot01")
    if ch is None:
        ch = at.create_asset(asset_name="MH_Pilot01", package_path="/Game/MH",
            asset_class=unreal.MetaHumanCharacter, factory=unreal.new_object(type=unreal.MetaHumanCharacterFactoryNew))
    log("edit", sub.try_add_object_to_edit(ch))
    cons = sub.get_body_constraints(ch)
    m = {str(c.name).lower().replace(" ", "_"): c for c in cons}
    for k, v in BODY.items():
        if k in m:
            m[k].is_active = True
            m[k].target_measurement = v
        else:
            log("missing_constraint_" + k, list(m.keys()))
    sub.set_body_constraints(ch, list(m.values()))
    sub.commit_body_state(ch)
    after = sub.get_body_constraints(ch)
    log("body_after", {str(c.name): round(c.target_measurement, 2) for c in after})
    # Skin: with the MetaHuman Creator Core Data installed this synthesizes 1K face textures locally (no sign-in).
    # Without it the synthesizer is disabled and the face textures stay 128 px placeholders (MH1: the PC today).
    sp = unreal.MetaHumanCharacterSkinProperties()
    sp.u = 0.55; sp.v = 0.55; sp.roughness = 1.0; sp.show_top_underwear = False
    ss = unreal.MetaHumanCharacterSkinSettings(); ss.skin = sp
    try:
        sub.commit_skin_settings(ch, ss)
    except Exception as e:
        log("skin_err", str(e))
    actor = sub.spawn_meta_human_actor(ch, True)
    log("actor", str(actor))
    comps = actor.get_components_by_class(unreal.SkeletalMeshComponent) if actor else []
    meshes = []
    for c in comps:
        sm = c.get_editor_property("skeletal_mesh_asset") if hasattr(c, "skeletal_mesh_asset") else c.get_skeletal_mesh_asset()
        if sm is None:
            continue
        name = str(c.get_name())
        mats = []
        try:
            mats = [(str(x.material_slot_name), x.material_interface.get_path_name() if x.material_interface else None) for x in sm.get_editor_property("materials")]
        except Exception as e:
            mats = [str(e)]
        path = f"{EXP}/{name}.fbx"
        ok, errs = export_obj(sm, path)
        meshes.append({"component": name, "mesh": sm.get_path_name(), "fbx": path, "ok": ok, "errors": errs,
                       "materials": mats,
                       "bones": sm.get_editor_property("skeleton").get_path_name() if sm.get_editor_property("skeleton") else None})
    log("meshes", meshes)
    # Bundled textures that need no Core Data: eye iris/sclera, skin micro normal, cavity.
    tex_paths = [
        "/MetaHumanCharacter/Lookdev_UHM/Eye/Textures/T_EyeSclera_D", "/MetaHumanCharacter/Lookdev_UHM/Eye/Textures/T_EyeSclera_N",
        "/MetaHumanCharacter/Lookdev_UHM/Eye/Textures/T_Iris001_01_D", "/MetaHumanCharacter/Lookdev_UHM/Eye/Textures/Iris/T_Iris_H_M",
        "/MetaHumanCharacter/Lookdev_UHM/Eye/Textures/T_Veins_D", "/MetaHumanCharacter/Lookdev_UHM/Skin/Textures/T_SkinMicroNormal",
        "/MetaHumanCharacter/Lookdev_UHM/Skin/Textures/T_skinMicro3_CAV", "/MetaHumanCharacter/Textures/T_Gray_Head_D",
        "/MetaHumanCharacter/Textures/T_Gray_Body_D", "/MetaHumanCharacter/Textures/T_MH_BentNormal_AO",
        "/MetaHumanCharacter/Lookdev_UHM/Skin/Textures/T_BakedGroomDefault",
    ]
    texrep = {}
    for p in tex_paths:
        t = unreal.load_asset(p)
        if t is None:
            texrep[p] = "missing"; continue
        fn = f"{EXP}/tex/{p.rsplit('/',1)[1]}.tga"
        os.makedirs(EXP + "/tex", exist_ok=True)
        texrep[p] = export_obj(t, fn)
    log("textures", texrep)
    # synthesized face textures: exported when real (> 128 px), i.e. once the Core Data option is installed.
    # UNTESTED on this PC (no Core Data); make_textures.py uses face_basecolor.tga instead of the placeholder when present.
    tx = ch.get_editor_property("synthesized_face_textures")
    sizes = {str(k): v.blueprint_get_size_x() for k, v in tx.items() if v}
    log("synth_face_sizes", sizes)
    for k, v in tx.items():
        if v and v.blueprint_get_size_x() > 128 and str(k).split(".")[-1].split(":")[0] in ("BASECOLOR", "NORMAL", "CAVITY"):
            name = str(k).split(".")[-1].split(":")[0].lower()
            log("synth_export_" + name, export_obj(v, f"{EXP}/tex/face_{name}.tga"))
    unreal.EditorAssetLibrary.save_loaded_asset(ch, False)
    sub.remove_object_to_edit(ch)
except Exception:
    log("EXC", traceback.format_exc())
json.dump(rep, open(OUT, "w"), indent=1, default=str)
