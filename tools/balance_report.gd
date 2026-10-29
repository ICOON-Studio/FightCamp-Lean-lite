extends SceneTree
## Balance report: prints the win-share grid and the round-by-round shares as plain text and quits 0.

const H := preload("res://scripts/rules/BalanceHarness.gd")
const Data := preload("res://scripts/state/Data.gd")


func _initialize() -> void:
	print("=== BALANCE REPORT (seed=42, n=400) ===")
	print("")
	print("%-5s %-8s %-5s %-5s %-7s %-8s" % ["avg", "protocol", "film", "opp", "edge", "win_sh"])
	print("----------------------------------------------------")
	var rows: Array = H.grid(42, 400)
	for row in rows:
		var avg: int = int(row["avg"])
		var proto: int = int(row["protocol"])
		var film: int = int(row["film_depth"])
		var opp_r: int = int(row["opp_rating"])
		var e: float = float(row["edge"])
		var ws: float = float(row["win_share"])
		var proto_name: String = ""
		match proto:
			0: proto_name = "None"
			1: proto_name = "Light"
			2: proto_name = "Standard"
			3: proto_name = "Hard"
			_: proto_name = "?"
		print("%-5d %-8s %-5d %-5d %7.2f %8.3f" % [avg, proto_name, film, opp_r, e, ws])
	print("")
	_round_by_round_table()
	_sweep_table()
	print("=== END ===")
	quit(0)


## Second table: round-by-round win share through the game's real round path (Bouts._energy + BoutRules.play_round).
## Rows: conditioning 50/65/80 x combos {none, first two combos at mastery 60} x opponents 0..2.
## Corners: round 1 = "", rounds 2-3 = "body" (the strong call for a power-leaning profile).
func _round_by_round_table() -> void:
	print("=== ROUND-BY-ROUND SHARES (seed=42, n=500, corners=[body, body]) ===")
	print("")
	print("%-5s %-22s %-20s %7s %7s %7s %7s %8s" % ["cond", "combos", "opponent", "r1", "r2", "r3", "bout", "bell3_e"])
	print("-----------------------------------------------------------------------------------------------")
	var conds: Array = [50, 65, 80]
	var combo_setups: Array = [
		{"label": "none", "combos": {}},
		{"label": "1-1+1-2 @60", "combos": {"1-1": 60.0, "1-2": 60.0}},
	]
	var corners: Array = ["", "body", "body"]
	var row_seed: int = 42
	for cond in conds:
		for cs in combo_setups:
			for opp_i in 3:
				var f: Dictionary = H.make_fighter(60, float(cond), cs["combos"], opp_i)
				var rs: Dictionary = H.round_shares(f, corners, 500, row_seed)
				var opp_name: String = str(Data.OPPONENTS[opp_i]["name"])
				print("%-5d %-22s %-20s %7.3f %7.3f %7.3f %7.3f %8.1f" % [
						cond, cs["label"], opp_name,
						float(rs["r1"]), float(rs["r2"]), float(rs["r3"]),
						float(rs["bout"]), float(rs["bell3_energy"])])
				row_seed += 1
	print("")


## Third table: BALANCE3 what-if sweep - spread x tired x conditioning x rating edge.
func _sweep_table() -> void:
	print("=== WHAT-IF SWEEP (seed=42, n=400) ===")
	print("")
	print("%-6s %-5s %-5s %-5s %7s %7s %7s %7s" % ["spread", "tired", "cond", "avg", "edge", "r1", "r3", "bout"])
	print("--------------------------------------------------------------------")
	var rows: Array = H.sweep(42, 400)
	for row in rows:
		var sp: float = float(row["spread"])
		var tm: String = str(row["tired"])
		var cond: int = int(row["cond"])
		var avg: int = int(row["avg"])
		var e: float = float(row["edge"])
		var r1: float = float(row["r1"])
		var r3: float = float(row["r3"])
		var bout: float = float(row["bout"])
		print("%-6.0f %-5s %-5d %-5d %7.2f %7.3f %7.3f %7.3f" % [sp, tm, cond, avg, e, r1, r3, bout])
	print("")
