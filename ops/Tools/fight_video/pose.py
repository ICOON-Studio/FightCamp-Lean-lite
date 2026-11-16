"""Stage 1 - every person's body pose in every frame of a video -> <out>.npz.  (Claude, S495)
usage: python pose.py <video> <out.npz> [--start S] [--end S] [--stride N] [--cpu] [--max-people 10] [--detector rfdetr.onnx]

Models: YOLOX-m (person boxes) + RTMPose-m (17 COCO keypoints per person), the Apache-2.0 OpenMMLab ONNX files rtmlib
downloads once to ~/.cache/rtmlib. They run on the graphics card through DirectML when onnxruntime-directml is the
installed onnxruntime (the venv in E:/FightCamp/fight_video_data/venv), else on the CPU.

Saved (F frames, P = max people, 17 keypoints):
  frame (F,) source frame numbers; t (F,) seconds; box (F,P,5) x1,y1,x2,y2,score; kpt (F,P,17,3) x,y,score;
  col (F,P,2,3) median L,a,b of a strip down the trunk and one down the shorts (for telling the two boxers apart);
  n (F,) people found; cutdiff (F,) mean grey change against the previous kept frame on a 48x27 thumbnail (a camera
  cut or a jump in an edited video shows as a spike); fps (of the frames kept); src_fps; size (w,h).
People are stored in detector order. Who is who across frames is decided in track.py, never here."""
import os
import sys
import time

import cv2
import numpy as np

KPT = dict(nose=0, l_eye=1, r_eye=2, l_ear=3, r_ear=4, l_sh=5, r_sh=6, l_el=7, r_el=8, l_wr=9, r_wr=10,
           l_hip=11, r_hip=12, l_knee=13, r_knee=14, l_ank=15, r_ank=16)


def _session(path, use_gpu):
    import onnxruntime as ort
    providers = ["CPUExecutionProvider"]
    if use_gpu and "DmlExecutionProvider" in ort.get_available_providers():
        providers = [("DmlExecutionProvider", {"performance_preference": "high_performance"}), "CPUExecutionProvider"]
    opts = ort.SessionOptions()
    opts.intra_op_num_threads = 4  # the CPU path stays at 4 threads: the PC must remain usable and cool
    opts.log_severity_level = 3
    return ort.InferenceSession(path, sess_options=opts, providers=providers)


def load_models(use_gpu=True, mode="balanced", detector=None):
    """Returns (detector, pose_model, device_name). rtmlib does the pre/post-processing; we own the ONNX sessions.
    detector = the path of an RF-DETR .onnx (detector.py: weights that may be sold) instead of the default YOLOX-m
    "humanart" (trained on a non-commercial set: research only)."""
    from rtmlib import YOLOX, RTMPose
    from rtmlib.tools.solution.body import Body
    cfg = Body.MODE[mode]
    pose = RTMPose(cfg["pose"], model_input_size=cfg["pose_input_size"], backend="onnxruntime", device="cpu")
    if detector:
        from detector import RFDetrPerson
        det = RFDetrPerson(detector, use_gpu)
    else:
        det = YOLOX(cfg["det"], model_input_size=cfg["det_input_size"], backend="onnxruntime", device="cpu")
    name = "cpu"
    if use_gpu:
        from rtmlib.tools.file import download_checkpoint
        for tool, url in ((det, cfg["det"]), (pose, cfg["pose"])) if not detector else ((pose, cfg["pose"]),):
            tool.session = _session(download_checkpoint(url), True)
        name = det.session.get_providers()[0]
    return det, pose, name


def strip_colour(lab_img, p0, p1, scale=1.0):
    """Median L,a,b (OpenCV 8-bit Lab) of 40 pixels on a strip from p0 to p1, 30% as wide as it is long. A strip down
    the middle of the trunk stays on the vest; a box around the shoulders and hips would take in arms and background."""
    h, w = lab_img.shape[:2]
    p0, p1 = np.asarray(p0, np.float32) * scale, np.asarray(p1, np.float32) * scale
    axis = p1 - p0
    side = np.array([-axis[1], axis[0]], np.float32) * 0.15
    u = np.linspace(0.15, 0.85, 8, dtype=np.float32)[:, None, None]
    v = np.linspace(-1.0, 1.0, 5, dtype=np.float32)[None, :, None]
    pts = (p0 + u * axis + v * side).reshape(-1, 2)
    x = np.clip(pts[:, 0].round().astype(int), 0, w - 1)
    y = np.clip(pts[:, 1].round().astype(int), 0, h - 1)
    return np.median(lab_img[y, x].astype(np.float32), axis=0)


def person_colours(lab_img, k, scale=1.0):
    """(2,3): trunk strip (shoulder midpoint -> hip midpoint) and shorts strip (hip midpoint -> 60% of the way to the knees)."""
    sh, hip, knee = (k[5] + k[6]) / 2, (k[11] + k[12]) / 2, (k[13] + k[14]) / 2
    return np.stack([strip_colour(lab_img, sh, hip, scale), strip_colour(lab_img, hip, hip + (knee - hip) * 0.6, scale)])


def small_lab(img):
    return cv2.cvtColor(cv2.resize(img, None, fx=0.5, fy=0.5, interpolation=cv2.INTER_AREA), cv2.COLOR_BGR2LAB)


def recolour(video, npz_path, log=print):
    """Rebuild the colour and cut arrays of an existing pose file from the video (decode only, no pose model)."""
    z = dict(np.load(npz_path))
    cap = cv2.VideoCapture(video)
    want = {int(f): i for i, f in enumerate(z["frame"])}
    cap.set(cv2.CAP_PROP_POS_FRAMES, int(z["frame"][0]))
    col = np.zeros(z["kpt"].shape[:2] + (2, 3), np.float32)
    cutdiff, prev_thumb = np.zeros(len(z["frame"]), np.float32), None
    f = int(z["frame"][0])
    while f <= int(z["frame"][-1]):
        ok, img = cap.read()
        if not ok:
            break
        i = want.get(f)
        if i is not None:
            lab = small_lab(img)
            for p in range(int(z["n"][i])):
                col[i, p] = person_colours(lab, z["kpt"][i, p, :, :2], 0.5)
            thumb = cv2.cvtColor(cv2.resize(img, (48, 27), interpolation=cv2.INTER_AREA), cv2.COLOR_BGR2GRAY).astype(np.float32)
            cutdiff[i] = 0.0 if prev_thumb is None else float(np.abs(thumb - prev_thumb).mean())
            prev_thumb = thumb
        f += 1
    z["col"], z["cutdiff"] = col, cutdiff
    z.pop("hsv", None)
    np.savez_compressed(npz_path, **z)
    log("recolour: %s done" % os.path.basename(npz_path))


def run(video, out, start_s=0.0, end_s=1e9, stride=1, use_gpu=True, max_people=10, log=print, detector=None):
    cap = cv2.VideoCapture(video)
    src_fps = cap.get(cv2.CAP_PROP_FPS) or 30.0
    w, h = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH)), int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
    total = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    first = int(round(start_s * src_fps))
    last = min(total - 1, int(round(end_s * src_fps))) if total > 0 else int(round(end_s * src_fps))
    if first:
        cap.set(cv2.CAP_PROP_POS_FRAMES, first)
    det, pose, device = load_models(use_gpu, detector=detector)
    log("pose: %s %dx%d %.2f fps, frames %d..%d stride %d on %s" % (os.path.basename(video), w, h, src_fps, first, last, stride, device))
    frames, boxes, kpts, cols, counts, cutdiff = [], [], [], [], [], []
    prev_thumb = None
    began = time.time()
    f = first
    while f <= last:
        ok, img = cap.read()
        if not ok:
            break
        if (f - first) % stride == 0:
            thumb = cv2.cvtColor(cv2.resize(img, (48, 27), interpolation=cv2.INTER_AREA), cv2.COLOR_BGR2GRAY).astype(np.float32)
            cutdiff.append(0.0 if prev_thumb is None else float(np.abs(thumb - prev_thumb).mean()))
            prev_thumb = thumb
            b = det(img)
            b = np.asarray(b, np.float32).reshape(-1, 4)
            # biggest people first: the boxers are rarely the smallest boxes, and P caps the crowd
            order = np.argsort(-(b[:, 2] - b[:, 0]) * (b[:, 3] - b[:, 1]))[:max_people]
            b = b[order]
            box = np.zeros((max_people, 5), np.float32)
            kp = np.zeros((max_people, 17, 3), np.float32)
            cl = np.zeros((max_people, 2, 3), np.float32)
            if len(b):
                k, s = pose(img, bboxes=b.tolist())
                k, s = np.asarray(k, np.float32), np.asarray(s, np.float32)
                lab = small_lab(img)
                for i in range(len(b)):
                    box[i, :4], box[i, 4] = b[i], 1.0
                    kp[i, :, :2], kp[i, :, 2] = k[i], s[i]
                    cl[i] = person_colours(lab, k[i], 0.5)
            frames.append(f), boxes.append(box), kpts.append(kp), cols.append(cl), counts.append(len(b))
            if len(frames) % 500 == 0:
                log("  %d frames, %.1f fps" % (len(frames), len(frames) / (time.time() - began)))
        f += 1
    fr = np.array(frames, np.int32)
    np.savez_compressed(out, frame=fr, t=fr / src_fps, box=np.array(boxes), kpt=np.array(kpts), col=np.array(cols),
                        n=np.array(counts, np.int16), cutdiff=np.array(cutdiff, np.float32), fps=src_fps / stride, src_fps=src_fps, size=(w, h))
    took = time.time() - began
    log("pose: %d frames in %.0f s (%.1f fps), median %d people a frame -> %s" % (
        len(fr), took, len(fr) / max(1e-6, took), int(np.median(counts)) if counts else 0, out))
    return out


if __name__ == "__main__":
    a = sys.argv
    if a[1] == "--recolour":
        recolour(a[2], a[3])
        sys.exit(0)
    opt = lambda k, d: type(d)(a[a.index(k) + 1]) if k in a else d
    run(a[1], a[2], opt("--start", 0.0), opt("--end", 1e9), opt("--stride", 1), "--cpu" not in a, opt("--max-people", 10), detector=opt("--detector", "") or None)
