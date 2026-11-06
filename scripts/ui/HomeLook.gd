extends RefCounted
## S394 the small pieces HOME shares: a row rule and a fighter's face. The operator kept the menus light ("Match the light game"):
## HOME has the approved layout in the game's own cards and colours.

const UI := preload("res://scripts/ui/UI.gd")
const PromoShot := preload("res://scripts/ui/PromoShot.gd")


static func rule() -> ColorRect:
	var line := ColorRect.new()
	line.color = UI.ROWLINE
	line.custom_minimum_size = Vector2(0, 2)   # 1 px drops out when the window scales the canvas
	return line


## A breathing head-and-shoulders picture; null when the body has no photo.
static func face(stem: String, size: Vector2) -> TextureRect:
	return PromoShot.picture(stem, size)
