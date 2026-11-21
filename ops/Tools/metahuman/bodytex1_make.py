"""BODYTEX1/2 (S535): 2K body skin maps for the boxers from the MetaHuman Creator's own body 'SurfaceDetail' sets.
    python ops/Tools/metahuman/bodytex1_make.py export <dds_dir> [scratch project dir]   the sets out of UE 5.8 (headless, ~50 s)
    python ops/Tools/metahuman/bodytex1_make.py <dds_dir> all                           every boxer, by the SETS table below
    python ops/Tools/metahuman/bodytex1_make.py <dds_dir> <boxer e.g. mh_boxer_01> [chr id] [normal gain]
<dds_dir> holds the uncompressed DDS files of /MetaHumanCharacter/Optional/BodyTextures (T_Chr<id>_Body_N,
T_Skin_V1_Body_BC), 2048 x 2048 BGRA8, written with TextureExporterDDS.
Why: the S299 build took the Creator's DEFAULT body detail (Chr0005, the flattest of the nine) and halved it to a 1024
JPEG. Writes <boxer>_mh02_body_normal_2k.jpg (OpenGL green, blue rebuilt, no chroma subsampling) and
<boxer>_mh02_body_albedo_2k.jpg (the body's own 1K skin tone with its 32 px blocks smoothed, plus the 2K skin detail,
plus a cavity pass from the normal's curvature). JPEG quality 92: about 1.2 MB a body (PNG was 5.4 MB)."""
import sys, os, subprocess, numpy as np
from PIL import Image, ImageFilter
DST = os.path.join(os.path.dirname(os.path.abspath(__file__)), "../../../assets/models/metahuman/")
N = 2048
# Which of Epic's nine sets each body wears, and how hard its normal reads. Looked at side by side (BODYTEX2_RESULT.md):
# Chr0023 = a trained man (abdominal wall, serratus, chest line); Chr0035 = a man's abdominal grid, softer;
# Chr0012 = the lean woman (centre line, rib hints, a flat belly; 0011 and 0013 carry belly folds, 0018 is flat).
# Dark skin shows relief only in its highlights, so the dark bodies get more of it.
MEN_23, MEN_35, WOMEN = "0023", "0035", "0012"
SETS = {"mh_boxer_01": (MEN_23, 1.0), "mh_boxer_02": (MEN_23, 1.25), "mh_boxer_03": (MEN_35, 1.15),
        "mh_boxer_07": (MEN_23, 1.25), "mh_boxer_08": (MEN_23, 1.0)}
SETS.update({"mh_boxer_%d" % n: (WOMEN, 1.0) for n in range(10, 24)})

UE_SCRIPT = '''import unreal, json
OUT = r"%s"
ar = unreal.AssetRegistryHelpers.get_asset_registry()
ar.scan_paths_synchronous(["/MetaHumanCharacter/Optional/BodyTextures"], True)
rep = {}
for a in ar.get_assets_by_path("/MetaHumanCharacter/Optional/BodyTextures", True):
    n = str(a.asset_name)
    if str(a.asset_class_path.asset_name) != "Texture2D" or n.endswith("_VT") or not ("_Body_" in n or "_Chest_" in n):
        continue
    t = unreal.AssetExportTask()
    t.object = a.get_asset(); t.filename = OUT + "/" + n + ".dds"; t.automated = True; t.prompt = False; t.replace_identical = True
    t.exporter = unreal.new_object(unreal.TextureExporterDDS)
    rep[n] = bool(unreal.Exporter.run_asset_export_task(t))
json.dump(rep, open(OUT + "/report.json", "w"), indent=1)
'''


def export(dds_dir, proj_dir):
    """A scratch copy of ue_project (UE writes Saved/ and Intermediate/ beside the .uproject), then the commandlet."""
    here = os.path.dirname(os.path.abspath(__file__))
    os.makedirs(proj_dir + "/Config", exist_ok=True)
    os.makedirs(dds_dir, exist_ok=True)
    for src, dst in (("ue_project/MHPilot.uproject", "BT.uproject"), ("ue_project/Config/DefaultEngine.ini", "Config/DefaultEngine.ini")):
        open(os.path.join(proj_dir, dst), "wb").write(open(os.path.join(here, src), "rb").read())
    script = os.path.join(proj_dir, "export_body.py")
    open(script, "w").write(UE_SCRIPT % dds_dir.replace("\\", "/"))
    return subprocess.call(["C:/Program Files/Epic Games/UE_5.8/Engine/Binaries/Win64/UnrealEditor-Cmd.exe",
                            os.path.join(proj_dir, "BT.uproject"), "-run=pythonscript", "-script=" + script,
                            "-unattended", "-nullrhi", "-nosplash", "-nopause", "-NoSound"],
                           creationflags=subprocess.CREATE_NO_WINDOW | subprocess.BELOW_NORMAL_PRIORITY_CLASS)


def dds(src, name):
    a = np.fromfile(src + name + ".dds", np.uint8)[148:148 + N * N * 4].reshape(N, N, 4)
    return a[..., [2, 1, 0, 3]].astype(np.float32)


def blur(a, r):
    return np.asarray(Image.fromarray(np.clip(a, 0, 255).astype(np.uint8)).filter(ImageFilter.GaussianBlur(r)), np.float32)


def make(src, boxer, chr_id, gain):
    # pores out (blur 1.5 px): the game's tiled micro normal already draws them
    n = blur(dds(src, "T_Chr%s_Body_N" % chr_id)[..., :3], 1.5) / 127.5 - 1.0
    x, y = n[..., 0] * gain, -n[..., 1] * gain            # UE (DirectX, +Y down) -> Godot (OpenGL, +Y up)
    z = np.sqrt(np.clip(1.0 - x * x - y * y, 0.05, 1.0))
    out = np.stack([x, y, z], 2)
    out /= np.linalg.norm(out, axis=2, keepdims=True)
    Image.fromarray(np.clip(out * 127.5 + 127.5, 0, 255).astype(np.uint8)).save(
        DST + boxer + "_mh02_body_normal_2k.jpg", quality=92, subsampling=0, optimize=True)

    # cavity from the normal's curvature (a groove darkens, a ridge lifts a little): what a character artist bakes as AO
    curv = np.gradient(x, axis=1) - np.gradient(y, axis=0)
    curv = (blur(curv * 2000.0 + 127.5, 6) - 127.5) / 2000.0                  # muscle-sized grooves only
    cav = 1.0 + np.clip(curv * 14.0, -0.20, 0.07)
    base = np.asarray(Image.open(DST + boxer + "_mh02_body_albedo.jpg").convert("RGB").resize((N, N), Image.BICUBIC), np.float32)
    # Most bodies' 1K tone map is 32 px blocks (hard steps of a few levels): smooth those, keep real edges (palms, soles).
    soft = blur(base, 24)
    keep = np.clip((np.abs(base - soft).max(2) - 8.0) / 6.0, 0.0, 1.0)[..., None]
    base = soft + (base - soft) * keep
    bc = dds(src, "T_Skin_V1_Body_BC")[..., :3].mean(2)
    bc = blur(bc, 1.0)
    detail = np.clip(bc / np.maximum(blur(bc, 6), 1.0), 0.93, 1.07)            # the 2K skin detail the 1K JPEG lost
    alb = base * (cav * detail)[..., None]
    Image.fromarray(np.clip(alb, 0, 255).astype(np.uint8)).save(DST + boxer + "_mh02_body_albedo_2k.jpg", quality=92, optimize=True)
    sizes = [os.path.getsize(DST + boxer + f) // 1024 for f in ("_mh02_body_normal_2k.jpg", "_mh02_body_albedo_2k.jpg")]
    print("%s Chr%s gain %.2f: normal %d KB, albedo %d KB" % (boxer, chr_id, gain, sizes[0], sizes[1]))
    return sum(sizes)


if __name__ == "__main__":
    if sys.argv[1] == "export":
        sys.exit(export(os.path.abspath(sys.argv[2]), os.path.abspath(sys.argv[3] if len(sys.argv) > 3 else sys.argv[2] + "/../bodytex_ue")))
    SRC = sys.argv[1].rstrip("/") + "/"
    if sys.argv[2] == "all":
        print("total %d KB" % sum(make(SRC, b, *SETS[b]) for b in sorted(SETS)))
    else:
        one = SETS.get(sys.argv[2], (MEN_23, 1.0))
        make(SRC, sys.argv[2], sys.argv[3] if len(sys.argv) > 3 else one[0], float(sys.argv[4]) if len(sys.argv) > 4 else one[1])
