// FIGHTERLOOK1 stylized look (ArtStyle.gd, `art=toon`): flat colour, light in three hard bands, no specular (no glare), a
// soft rim to lift the figure off the dark hall. Keeps the material's own texture, colour, vertex colour and alpha cut.
shader_type spatial;
render_mode specular_disabled;
#include "res://assets/shaders/toon.gdshaderinc"
