---
name: reference_pc_footage_tools
description: "Footage on the operator's PC: yt-dlp is `python -m yt_dlp`, ffmpeg only via imageio-ffmpeg; partial downloads, AV1 decode, MediaPipe two-man tracking speed, 'delete after' via the Recycle Bin"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 5a7d1b2f-c085-4027-8915-a7f0e2ac0dd7
  modified: 2026-09-14T21:01:20.339Z
---

Measured 2026-09-14 (UFC pilot):
- **yt-dlp** is a Python module (`python -m yt_dlp`, 2026.08.19); there is NO `yt-dlp` or `ffmpeg` on PATH. Partial downloads
  (`--download-sections "*0:00-7:30"`) need ffmpeg: `python -m pip install imageio-ffmpeg`, then
  `--ffmpeg-location C:/Python314/Lib/site-packages/imageio_ffmpeg/binaries/ffmpeg-win-x86_64-v7.1.exe`. The same binary can
  encode H.264 phone copies.
- Format **398** (AV1 720p mp4) decodes in OpenCV and tracks fine; a UFC Free Fight 720p is ~10 MB a minute. `-F` lists sizes
  before asking the operator (every download is named and approved per batch; `yt_dlp --print "%(title)s | %(channel)s"` names it).
- `Tools/footage/track_pairs.py` ran 13,487 frames of 720p broadcast in 484 s (27.9 fps); `pair_events.py` then found 34
  two-man segments / 126.8 s of a 300 s round because broadcast camera cuts break segments - pick windows inside one shot.
- **"Delete after" = Recycle Bin, never a hard delete** (hard deletes are not Claude's to do): PowerShell
  `Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($path, 'OnlyErrorDialogs', 'SendToRecycleBin')`.
  Keep the numbers (track .npz, events JSON); recycle the video and any frame strips/sheets taken from it.
- Blender's portable build prints "Failed to remove ... cryptography ... _rust.pyd PermissionError" at exit when the
  Higgsfield add-on ran - harmless extension cleanup.
Related: [[feedback_learn_moves_from_video_not_studies]], [[reference_pc_animation_tools]], [[reference_higgsfield]].
