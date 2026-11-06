extends RefCounted
## A fighter's portrait for the camp side panel and the fighter card. S394 the whiteboard HOME that lived here is gone (the
## operator approved the dark look): HomeNeeds, HomeMatch, HomeRows and HomeSide draw HOME now.

const Faces := preload("res://scripts/rules/Faces.gd")
const BodyFigure := preload("res://scripts/ui/BodyFigure.gd")
const PromoShot := preload("res://scripts/ui/PromoShot.gd")
const CROP := Rect2(0.25, 0.0, 0.5, 0.42)


static func portrait(f: Dictionary) -> Texture2D:
	var shot := PromoShot.shot(Faces.stem(f))   # S387 head and shoulders on the slate backdrop: no crossed arms, no hands
	if shot != null:
		return shot
	var p := BodyFigure.portrait_for(Faces.glb(Faces.stem(f)), "red")
	var tex := p.get("tex") as Texture2D
	if tex == null:
		return null
	var s := tex.get_size()
	var a := AtlasTexture.new()
	a.atlas = tex
	a.region = Rect2(CROP.position * s, CROP.size * s)
	return a


## The coach's marker notes beside her picture: rank and mood, weight, condition, goal, the season road.
