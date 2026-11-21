"""BODYTEX1 (S535): 2K body skin maps for one boxer from the MetaHuman Creator's own body 'SurfaceDetail' set.
    python ops/Tools/metahuman/bodytex1_make.py <dds_dir> <boxer e.g. mh_boxer_01> [chr id, default 0023] [normal gain, default 1.0]
<dds_dir> holds the uncompressed DDS files a headless UE 5.8 pythonscript run wrote with TextureExporterDDS from
/MetaHumanCharacter/Optional/BodyTextures (T_Chr<id>_Body_N, T_Chr<id>_Body_Ca, T_Skin_V1_Body_BC), 2048 x 2048 BGRA8.
Why: the S299 build took the Creator's DEFAULT body detail (Chr0005, the flattest of the nine) and halved it to a 1024
JPEG. Chr0023 is the lean athletic one: its normal carries the abdominal wall, the serratus and the chest line.
Writes <boxer>_mh02_body_normal_2k.png (OpenGL green, blue rebuilt) and <boxer>_mh02_body_albedo_2k.png (the body's own
1K skin tone, plus the 2K skin detail, plus a cavity pass from the normal's curvature)."""
import sys, os, numpy as np
from PIL import Image, ImageFilter
SRC = sys.argv[1].rstrip("/") + "/"
BOXER = sys.argv[2]
CHR = sys.argv[3] if len(sys.argv) > 3 else "0023"
GAIN = float(sys.argv[4]) if len(sys.argv) > 4 else 1.0
DST = os.path.join(os.path.dirname(os.path.abspath(__file__)), "../../../assets/models/metahuman/")
N = 2048


def dds(name):
    a = np.fromfile(SRC + name + ".dds", np.uint8)[148:148 + N * N * 4].reshape(N, N, 4)
    return a[..., [2, 1, 0, 3]].astype(np.float32)


def blur(a, r):
    return np.asarray(Image.fromarray(np.clip(a, 0, 255).astype(np.uint8)).filter(ImageFilter.GaussianBlur(r)), np.float32)


# pores out (blur 1.5 px): the game's tiled micro normal already draws them, and without them the PNG is a third the size
n = blur(dds("T_Chr%s_Body_N" % CHR)[..., :3], 1.5) / 127.5 - 1.0
x, y = n[..., 0] * GAIN, -n[..., 1] * GAIN            # UE (DirectX, +Y down) -> Godot (OpenGL, +Y up)
z = np.sqrt(np.clip(1.0 - x * x - y * y, 0.05, 1.0))
out = np.stack([x, y, z], 2)
out /= np.linalg.norm(out, axis=2, keepdims=True)
Image.fromarray(np.clip(out * 127.5 + 127.5, 0, 255).astype(np.uint8)).save(DST + BOXER + "_mh02_body_normal_2k.png", optimize=True)

# cavity from the normal's curvature (a groove darkens, a ridge lifts a little): what a character artist bakes as AO
curv = np.gradient(x, axis=1) - np.gradient(y, axis=0)
curv = (blur(curv * 2000.0 + 127.5, 6) - 127.5) / 2000.0                  # muscle-sized grooves only
cav = 1.0 + np.clip(curv * 14.0, -0.20, 0.07)
base = np.asarray(Image.open(DST + BOXER + "_mh02_body_albedo.jpg").convert("RGB").resize((N, N), Image.BICUBIC), np.float32)
bc = dds("T_Skin_V1_Body_BC")[..., :3].mean(2)
bc = blur(bc, 1.0)
detail = np.clip(bc / np.maximum(blur(bc, 6), 1.0), 0.93, 1.07)            # the 2K skin detail the 1K JPEG lost
alb = base * (cav * detail)[..., None]
Image.fromarray(np.clip(alb, 0, 255).astype(np.uint8)).save(DST + BOXER + "_mh02_body_albedo_2k.png", optimize=True)
for f in ("_mh02_body_normal_2k.png", "_mh02_body_albedo_2k.png"):
    print(BOXER + f, os.path.getsize(DST + BOXER + f) // 1024, "KB")
