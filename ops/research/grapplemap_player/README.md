# GrappleMap's own player - reference source (public domain, see LICENSE)

Copied S379 from the GrappleMap repo (https://eel.is/GrappleMap, Eelis) for the BJJ9 loop. The operator: "why on
grapplemap the clips played fine, why you dont use them straight in the game". This is how GrappleMap's player plays the
same data we load (assets/grapplemap/GrappleMap.txt):
- playback.cpp/.hpp - how a transition is stepped and frames are interpolated between keyframes.
- positions.cpp/.hpp, math.hpp - joint positions, the between() interpolation, mirroring/reorienting a position.
- players.hpp - the joints and each joint's radius (the tube figures' thickness - thinner than our MetaHuman bodies).
- playerdrawer.cpp/.hpp - how the tube figures are drawn from the joints (no retarget: the figure IS the joints).
- gm.js - the web viewer's JavaScript side.
Read it; do not port C++ line by line. Our job: the same smoothness on MetaHuman skeletons (other bone lengths, thicker).
