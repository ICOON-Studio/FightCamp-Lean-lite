extends RefCounted
## SPLIT500: modal and toast flow lifted out of Main.gd so it stays under the 500-line limit.
## Every function here is static and takes `main: Node` (the Main instance) for the state it needs.

const UI := preload("res://scripts/ui/UI.gd")
const FightView := preload("res://scripts/fight3d/FightView.gd")
const INTERVIEW := preload("res://scenes/modals/Interview.tscn")
const REVIEW := preload("res://scenes/modals/WeekReview.tscn")
const INFO := preload("res://scenes/modals/InfoModal.tscn")
const CAMP := preload("res://scenes/modals/Camp.tscn")
const WEIGH := preload("res://scenes/modals/WeighIn.tscn")
const FIGHT := preload("res://scenes/modals/FightNight.tscn")
const GOALTALK := preload("res://scenes/modals/GoalTalk.tscn")
const TRIAL := preload("res://scenes/modals/Trial.tscn")
const PROOFFER := preload("res://scenes/modals/ProOffer.tscn")
const POSTER := preload("res://scenes/modals/PosterReveal.tscn")
const OPEN_NIGHT := preload("res://scenes/modals/OpenNight.tscn")


static func render_modal(main: Node) -> void:
	if main.no_render:
		return
	UI.clear(main._modal_layer)
	main._modal_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if FightView.sync(main, main._fight_layer) or main.modal.is_empty():
		return
	main._modal_layer.mouse_filter = Control.MOUSE_FILTER_STOP
	var scrim := ColorRect.new()
	scrim.color = Color(0.04, 0.027, 0.02, 0.72)
	scrim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	main._modal_layer.add_child(scrim)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	main._modal_layer.add_child(center)
	var scene: PackedScene = {"interview": INTERVIEW, "review": REVIEW, "info": INFO, "camp": CAMP, "weighin": WEIGH,
		"fight": FIGHT, "goaltalk": GOALTALK, "trial": TRIAL, "prooffer": PROOFFER, "poster": POSTER, "open": OPEN_NIGHT}[main.modal["type"]]
	var node := scene.instantiate()
	center.add_child(node)
	node.build(main, main.modal)
	preload("res://scripts/ui/WoodKit.gd").ink(center)   # S417 words on a slate pop-up take the chalk inks


static func redraw_modal(main: Node) -> void:
	render_modal(main)


static func modal_node(main: Node) -> Node:
	if main._modal_layer.get_child_count() < 2:
		return null
	return main._modal_layer.get_child(1).get_child(0)


static func open_modal(main: Node, m: Dictionary) -> void:
	if main.running:
		main.pause()
	main.modal = m
	drop_old_toast(main)
	render_modal(main)


static func close_modal(main: Node) -> void:
	main.modal = {}
	render_modal(main)
	main.render()


static func toast(main: Node, text: String) -> void:
	UI.clear(main._toast_layer)
	var p := PanelContainer.new()
	p.theme_type_variation = "Toast"
	p.add_child(UI.label(text, UI.BODY, UI.TOP_INK))   # S417 the toast is a dark plate
	p.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	p.grow_horizontal = Control.GROW_DIRECTION_BOTH
	p.grow_vertical = Control.GROW_DIRECTION_BEGIN
	p.offset_bottom = -24
	main._toast_layer.add_child(p)
	main._toast_timer.start(2.6)
	main._toast_frame = Engine.get_process_frames()


static func clear_toast(main: Node) -> void:
	main._toast_timer.stop()
	UI.clear(main._toast_layer)


static func drop_old_toast(main: Node) -> void:
	if Engine.get_process_frames() != main._toast_frame:
		clear_toast(main)
