"""MH1 Core Data pass: game textures for mh_pilot_02 from the REAL MetaHuman Creator outputs (no placeholder).
    python Tools/metahuman/make_textures02.py [export02_dir] [work_dir]
Inputs (written by mh_build_pilot02.py + Tools/metahuman/bl_exr2npy.py):
  tex/face_basecolor.png       1K synthesized face skin (Core Data texture synthesis, sRGB)
  work/face_normal.npy         1K synthesized face normal (UE/DirectX convention, packed 0..1)
  tex/body_basecolor.dds       2K body detail map (neutral grey; the Creator tints it by the skin tone)
  tex/body_normal.dds          2K body normal
  groom/Hair_S_Brushcut_baked.dds, groom/Eyebrows_M_Dense_baked.dds   4K baked grooms in FACE UV (A = coverage)
  groom/Hair_S_BrushCut_CardsAtlas_Attribute.dds  4K cards atlas: R = strand coverage, B = per-strand seed
  groom/Hair_S_BrushCut_CardsAtlas_Tangent.dds    4K: A = root->tip coordinate
  groom/Eyebrows_M_Dense_CardsAtlas_Attribute.dds 2K brow cards atlas (same packing)
Outputs (work/game/): head albedo (skin + baked brush-cut shadow + baked brows), head normal (OpenGL), body albedo
(skin tone matched to the face at the neck seam x detail map), body normal, hair + brow card RGBA."""
import numpy as np, sys, os, struct
from PIL import Image, ImageFilter
EXP = (sys.argv[1] if len(sys.argv) > 1 else "E:/FightCamp/metahuman_pilot/export02").rstrip("/") + "/"
WORK = (sys.argv[2] if len(sys.argv) > 2 else "E:/FightCamp/metahuman_pilot/work02").rstrip("/") + "/"
OUT = WORK + "game/"
os.makedirs(OUT, exist_ok=True)
# Hair colour: dark brown (sRGB). Victor's own melanin could not be read (the commandlet's collection is not built).
HAIR = np.array([42, 31, 24], np.float32)
BROW = np.array([34, 25, 20], np.float32)


def dds(path):
    """Uncompressed B8G8R8A8 DDS (DX10 header, DXGI 87) -> RGBA uint8."""
    h = open(path, "rb").read(20)
    hh, w = struct.unpack("<II", h[12:20])
    return np.fromfile(path, np.uint8)[148:148 + w * hh * 4].reshape(hh, w, 4)[..., [2, 1, 0, 3]]


def rs(a, n, mode=Image.BICUBIC):
    return np.asarray(Image.fromarray(a).resize((n, n), mode))


N = 1024
face = np.asarray(Image.open(EXP + "tex/face_basecolor.png").convert("RGB"), np.float32)
hb = rs(dds(EXP + "groom/Hair_S_Brushcut_baked.dds"), N, Image.LANCZOS).astype(np.float32) / 255.0
bb = rs(dds(EXP + "groom/Eyebrows_M_Dense_baked.dds"), N, Image.LANCZOS).astype(np.float32) / 255.0
# baked hair: the scalp under the cards reads as a dense short crop (UE uses the same texture at far LODs)
cov = np.clip(hb[..., 3] * 1.1, 0, 1)[..., None]
shade = (0.75 + 0.5 * (hb[..., 0:1] - 0.5))
head = face * (1 - 0.92 * cov) + HAIR * shade * 0.92 * cov
cb = np.clip(bb[..., 3] * 1.2, 0, 1)[..., None]
head = head * (1 - 0.85 * cb) + BROW * 0.85 * cb
Image.fromarray(np.clip(head, 0, 255).astype(np.uint8)).save(OUT + "mh02_head_albedo.jpg", quality=92)
nrm = np.load(WORK + "face_normal.npy")[..., :3]
nrm[..., 1] = 1.0 - nrm[..., 1]          # UE (DirectX, +Y down) -> glTF/Godot (OpenGL, +Y up)
Image.fromarray(np.clip(nrm * 255 + 0.5, 0, 255).astype(np.uint8)).save(OUT + "mh02_head_normal.jpg", quality=92)

# body: the Creator's body base colour is a neutral detail map; tint it with the face skin at the neck seam
# (face UV bottom-centre rows = lower neck) so the seam does not show.
neck = face[int(N * 0.86):int(N * 0.96), int(N * 0.35):int(N * 0.65)].reshape(-1, 3)
tone = np.median(neck, 0)
bd = dds(EXP + "tex/body_basecolor.dds")[..., :3].astype(np.float32)
bd = rs(bd.astype(np.uint8), 1024).astype(np.float32)
lum = bd.mean(2, keepdims=True)
med = np.median(bd.reshape(-1, 3), 0)[None, None, :]
ratio = 0.75 * (lum / lum.mean()) + 0.25 * (bd / med)   # mostly luminance: the per-channel ratio over-reddens
body = tone[None, None, :] * np.clip(ratio, 0, 2) ** 0.8
if os.path.exists(OUT + "seam_uv.json"):   # written by bl_build_glb02.py: head-boundary UV + body UV under it (body UVs live in tile u 1..2)
    import json
    pairs = json.load(open(OUT + "seam_uv.json"))
    def samp(img, uv):
        n = img.shape[0]
        x = min(n - 1, max(0, int((uv[0] % 1.0) * n))); y = min(n - 1, max(0, int((1 - uv[1]) * n)))
        return img[max(0, y - 2):y + 3, max(0, x - 2):x + 3].reshape(-1, 3).mean(0)
    hs = np.array([samp(head, a) for a, b in pairs]); bs = np.array([samp(body, b) for a, b in pairs])
    gain = np.median(hs, 0) / np.median(bs, 0)
    body = body * gain[None, None, :]
    print("seam samples", len(pairs), "head", np.median(hs, 0).round(1), "body", np.median(bs, 0).round(1), "gain", gain.round(3))
Image.fromarray(np.clip(body, 0, 255).astype(np.uint8)).save(OUT + "mh02_body_albedo.jpg", quality=90)
bn = rs(dds(EXP + "tex/body_normal.dds")[..., :3], 1024).astype(np.float32)
bn[..., 1] = 255.0 - bn[..., 1]
Image.fromarray(bn.astype(np.uint8)).save(OUT + "mh02_body_normal.jpg", quality=90)


def cards(attr_path, tan_path, n, col, name):
    at = dds(attr_path)
    a = rs(at, n, Image.LANCZOS).astype(np.float32) / 255.0
    u = rs(dds(tan_path), n, Image.LANCZOS)[..., 3:4].astype(np.float32) / 255.0 if tan_path else 0.5
    var = 0.8 + 0.4 * a[..., 2:3]                       # per-strand seed
    rgb = col[None, None, :] * var * (0.8 + 0.35 * u)    # a little lighter toward the tips
    alpha = np.clip(a[..., 0] * 1.6, 0, 1)               # strand coverage, thickened for the downscale
    rgb = np.round(rgb / 6.0) * 6.0                      # posterize: keeps the PNG small inside the 5 MB GLB
    rgb = np.where(alpha[..., None] < 0.02, col[None, None, :], rgb)
    alpha = np.round(alpha * 24) / 24                    # 25 coverage levels: invisible after the alpha clip
    img = np.concatenate([np.clip(rgb, 0, 255), alpha[..., None] * 255], 2).astype(np.uint8)
    Image.fromarray(img, "RGBA").save(OUT + name)
    return float((alpha > 0.3).mean())


print("hair cards coverage", cards(EXP + "groom/Hair_S_BrushCut_CardsAtlas_Attribute.dds",
      EXP + "groom/Hair_S_BrushCut_CardsAtlas_Tangent.dds", 1024, HAIR, "mh02_hair_cards.png"))
print("brow cards coverage", cards(EXP + "groom/Eyebrows_M_Dense_CardsAtlas_Attribute.dds", None, 512, BROW, "mh02_brow_cards.png"))
print("skin tone at neck", tone, "files", {f: os.path.getsize(OUT + f) // 1024 for f in os.listdir(OUT)})
