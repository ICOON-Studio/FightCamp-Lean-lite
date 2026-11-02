# MH1 Core Data pass: the pilot boxer from a MetaHuman Creator PRESET (Victor: brush-cut hair, dense brows), the
# athletic body constraints of mh_build_pilot.py, synthesized 1K face skin, and the groom CARDS (hair + brows) exported
# as static meshes with their atlases, plus the groom reference head they were authored on (for the Blender refit).
# Runs in the UnrealEditor-Cmd pythonscript commandlet (no Slate; see MH1_DIGEST "What failed").
import unreal, json, traceback, os
EXP = "E:/FightCamp/metahuman_pilot/export02"
OUT = EXP + "/build_report.json"
os.makedirs(EXP + "/tex", exist_ok=True)
os.makedirs(EXP + "/groom", exist_ok=True)
rep = {}
def log(k, v):
    rep[k] = v
    unreal.log("MH1B2 " + k + " = " + str(v)[:3000])

PRESET = "Victor"
HAIR = "Hair_S_BrushCut"
BROWS = "Eyebrows_M_Dense"
G = "/MetaHumanCharacter/Optional/Grooms/GroomAssets"
BODY = {"height": 183.0, "muscularity": 1.4, "fat": -1.3, "masculine/feminine": -1.6,
        "waist": 80.0, "chest": 106.0, "neck": 40.0, "bicep": 36.0, "across_shoulder": 41.0}

TEXFMT = os.environ.get("MH1_TEXFMT", "png").split(",")
EXPORTERS = {"png": "TextureExporterPNG", "dds": "TextureExporterDDS", "exr": "TextureExporterEXR", "tga": "TextureExporterTGA"}

def export_obj(obj, path, exporter=None):
    t = unreal.AssetExportTask()
    t.object = obj; t.filename = path; t.automated = True; t.prompt = False; t.replace_identical = True
    if exporter is not None:
        t.exporter = unreal.new_object(getattr(unreal, exporter))
    if path.lower().endswith(".fbx"):
        o = unreal.FbxExportOption()
        o.vertex_color = True; o.level_of_detail = True; o.collision = False
        o.export_morph_targets = False; o.export_preview_mesh = False
        t.options = o
    ok = unreal.Exporter.run_asset_export_task(t)
    return bool(ok) and os.path.exists(path), [str(e) for e in t.errors]

def export_tex(tex, stem):
    """The TGA exporter ASSERTS (EditorFactories.cpp:4610, fatal) on non-BGRA8 sources such as the synthesized face
    textures: use an explicit exporter, PNG by default (MH1_TEXFMT=png,dds,... to change the order)."""
    res = {}
    for ext in TEXFMT:
        unreal.log("MH1B2 exporting " + tex.get_name() + " as " + ext)
        ok, errs = export_obj(tex, stem + "." + ext, EXPORTERS[ext])
        res[ext] = ok if ok else errs
        if ok:
            return stem + "." + ext, res
    return None, res

ar = unreal.AssetRegistryHelpers.get_asset_registry()
try:
    ar.scan_paths_synchronous(["/MetaHumanCharacter/Optional"], True)
    sub = unreal.get_editor_subsystem(unreal.MetaHumanCharacterEditorSubsystem)
    dst = "/Game/MH/MH_Pilot02"
    if not unreal.EditorAssetLibrary.does_asset_exist(dst):
        log("duplicate", str(unreal.EditorAssetLibrary.duplicate_asset(f"/MetaHumanCharacter/Optional/Presets/{PRESET}", dst)))
    ch = unreal.load_asset(dst + ".MH_Pilot02")
    log("edit", sub.try_add_object_to_edit(ch))
    cons = sub.get_body_constraints(ch)
    log("body_before", {str(c.name): round(c.target_measurement, 2) for c in cons if c.is_active})
    m = {str(c.name).lower().replace(" ", "_"): c for c in cons}
    for k, v in BODY.items():
        if k in m:
            m[k].is_active = True; m[k].target_measurement = v
        else:
            log("missing_constraint_" + k, list(m.keys()))
    sub.set_body_constraints(ch, list(m.values()))
    sub.commit_body_state(ch)
    log("body_after", {str(c.name): round(c.target_measurement, 2) for c in sub.get_body_constraints(ch)})
    # Skin: the preset's own settings, committed again so the Core Data synthesizer runs (1K, local, no sign-in).
    ss = ch.get_editor_property("skin_settings")
    ss.skin.show_top_underwear = False
    ch.preview_material_type = unreal.MetaHumanCharacterSkinPreviewMaterial.EDITABLE
    sub.commit_skin_settings(ch, ss)
    log("skin", (ss.skin.u, ss.skin.v, ss.skin.face_texture_index, ss.skin.body_texture_index, ss.skin.roughness))
    tx = ch.get_editor_property("synthesized_face_textures")
    log("synth_face_sizes", {str(k): v.blueprint_get_size_x() for k, v in tx.items() if v})
    # The synthesized face textures are TRANSIENT (platform data only, no source): every texture exporter fails on
    # them (TGA/PNG assert fatally, DDS "ExportTextureSourceToDDS failed"). So draw each into a render target on a
    # canvas and export the render target: basecolor to an sRGB RGBA8 PNG, normal + cavity raw into RGBA16F EXR.
    world = unreal.EditorLevelLibrary.get_editor_world()
    RL = unreal.RenderingLibrary
    for k, v in tx.items():
        nm = str(k).split(".")[-1].split(":")[0].lower()
        if not (v and nm in ("basecolor", "normal", "cavity")):
            continue
        try:
            n = v.blueprint_get_size_x()
            fmt = unreal.TextureRenderTargetFormat.RTF_RGBA8_SRGB if nm == "basecolor" else unreal.TextureRenderTargetFormat.RTF_RGBA16F
            rt = RL.create_render_target2d(world, n, n, fmt, unreal.LinearColor(0, 0, 0, 1), False)
            canvas, size, ctx = RL.begin_draw_canvas_to_render_target(world, rt)
            canvas.draw_texture(v, unreal.Vector2D(0, 0), unreal.Vector2D(n, n), unreal.Vector2D(0, 0), unreal.Vector2D(1, 1),
                                unreal.LinearColor(1, 1, 1, 1), unreal.BlendMode.BLEND_OPAQUE)
            RL.end_draw_canvas_to_render_target(world, ctx)
            ext = "png" if nm == "basecolor" else "exr"
            exp = "RenderTargetExporterPNG" if ext == "png" else "RenderTargetExporterEXR"
            log("synth_export_" + nm, export_obj(rt, f"{EXP}/tex/face_{nm}.{ext}", exp))
        except Exception:
            log("synth_export_err_" + nm, traceback.format_exc())
    btx = ch.get_editor_property("body_textures")
    for k, v in btx.items():
        nm = str(k).split(".")[-1].split(":")[0].lower()
        if v and nm in ("body_basecolor", "body_normal", "body_cavity"):
            log("body_export_" + nm, (v.get_path_name(), export_tex(v, f"{EXP}/tex/{nm}")))
    # hair melanin etc. from the preset's instance parameters (assembled for preview)
    try:
        sub.assemble_for_preview(character=ch)
        col = ch.internal_collection
        for slot in ("Hair", "Eyebrows"):
            keys = col.get_item_keys_for_slot(slot)
            if keys:
                ps = col.default_instance.get_instance_parameters(item_path=unreal.MetaHumanPaletteItemPath(item_key=keys[0]))
                vals = {}
                for p in ps:
                    try:
                        if p.type == unreal.MetaHumanCharacterInstanceParameterType.FLOAT: vals[str(p.name)] = p.get_float()
                        elif p.type == unreal.MetaHumanCharacterInstanceParameterType.BOOL: vals[str(p.name)] = p.get_bool()
                        elif p.type == unreal.MetaHumanCharacterInstanceParameterType.COLOR:
                            c = p.get_color(); vals[str(p.name)] = (c.r, c.g, c.b, c.a)
                    except Exception as e:
                        vals[str(p.name)] = str(e)
                log("params_" + slot, vals)
    except Exception as e:
        log("params_err", traceback.format_exc())
    # TRAP (2026-10-02, froze the PC): the preset carries the Outfits slot WI_DefaultGarment; spawning the actor builds
    # its 4K/8K clothing textures (UE log: "AssetCompile memory estimate is greater than available ... 4289 MiB") and
    # the PC ran out of RAM. The run that froze had ALREADY written Body/Face FBX + every texture; only the brow
    # reference head was missing (Tools/metahuman/mh_export_groom_heads.py exports it without spawning). Before a
    # re-run, close other heavy jobs (watchdog GREEN with RAM headroom) or clear the Outfits slot first.
    actor = sub.spawn_meta_human_actor(ch, True)
    log("actor", str(actor))
    meshes = []
    for c in (actor.get_components_by_class(unreal.SkeletalMeshComponent) if actor else []):
        sm = c.get_skeletal_mesh_asset()
        if sm is None:
            continue
        name = str(c.get_name())
        path = f"{EXP}/{name}.fbx"
        ok, errs = export_obj(sm, path)
        meshes.append({"component": name, "mesh": sm.get_path_name(), "ok": ok, "errors": errs})
    log("meshes", meshes)
    log("groom_components", [(str(c.get_name()), c.get_class().get_name()) for c in (actor.get_components_by_class(unreal.ActorComponent) if actor else [])])
    # Grooms: the cards meshes (static meshes in the groom's authoring space = the groom head) and their atlases.
    gr = {}
    for gname, folder in ((HAIR, "Hair"), (BROWS, "Eyebrows")):
        for a in ar.get_assets_by_path(f"{G}/{folder}/{gname}", False):
            n = str(a.asset_name); cls = str(a.asset_class_path.asset_name)
            o = a.get_asset()
            if cls == "StaticMesh" and ("LOD0" in n or "LOD1" in n or "LOD2" in n):
                gr[n] = export_obj(o, f"{EXP}/groom/{n}.fbx")
            elif cls == "Texture2D":
                gr[n] = export_tex(o, f"{EXP}/groom/{n}")
                try:
                    gr[n + "_fmt"] = (o.blueprint_get_size_x(), o.blueprint_get_size_y(), str(o.get_editor_property("compression_settings")), o.get_editor_property("srgb"))
                except Exception as e:
                    gr[n + "_fmt"] = str(e)
            elif cls == "GroomAsset":
                try:
                    gr[n + "_info"] = {"groups": len(o.get_editor_property("hair_groups_info")),
                                       "cards": [(str(x.get_editor_property("source_type")), x.get_editor_property("lod_index"), x.get_editor_property("group_index")) for x in o.get_editor_property("hair_groups_cards")]}
                except Exception as e:
                    gr[n + "_info"] = str(e)
    log("grooms", gr)
    for b in (f"/MetaHumanCharacter/Optional/Grooms/Bindings/Hair/{HAIR}", f"/MetaHumanCharacter/Optional/Grooms/Bindings/Eyebrows/{BROWS}_Binding"):
        o = unreal.load_asset(b)
        if o is None:
            log("binding_missing", b); continue
        d = {"class": o.get_class().get_name()}
        for prop in ("source_skeletal_mesh", "target_skeletal_mesh", "binding_type", "num_interpolation_points"):
            try:
                v = o.get_editor_property(prop); d[prop] = v.get_path_name() if hasattr(v, "get_path_name") else str(v)
            except Exception as e:
                d[prop] = "n/a"
        log("binding_" + b.rsplit("/", 1)[1], d)
    for hn in ("MH_Groom_Head", "SKM_Groom_Head_Legacy02"):   # the heads the hair / brow cards were authored on
        gh = unreal.load_asset("/MetaHumanCharacter/Optional/Grooms/GroomMesh/" + hn)
        if gh is not None:
            log("groom_head_export_" + hn, export_obj(gh, f"{EXP}/groom/{hn}.fbx"))
    unreal.EditorAssetLibrary.save_loaded_asset(ch, False)
    sub.remove_object_to_edit(ch)
except Exception:
    log("EXC", traceback.format_exc())
json.dump(rep, open(OUT, "w"), indent=1, default=str)
