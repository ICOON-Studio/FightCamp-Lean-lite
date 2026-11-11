extends RefCounted
## A fighter's portrait for the camp side panel and the fighter card. S394 the whiteboard HOME that lived here is gone (the
## operator approved the dark look): HomeNeeds, HomeMatch, HomeRows and HomeSide draw HOME now.

const Faces := preload("res://scripts/rules/Faces.gd")
const BodyFigure := preload("res://scripts/ui/BodyFigure.gd")
const PromoShot := preload("res://scripts/ui/PromoShot.gd")


## The whole photo. The caller frames the head with FaceFrame; this does not crop.
static func portrait(f: Dictionary) -> Texture2D:
	var shot := PromoShot.source(Faces.stem(f))
	if shot != null:
		return shot
	return BodyFigure.portrait_for(Faces.glb(Faces.stem(f)), "red").get("tex") as Texture2D
