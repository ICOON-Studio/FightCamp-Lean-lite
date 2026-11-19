# GUARDPROBE4 - guard posture against an opponent whose aim persists

Run: `godot --headless --audio-driver Dummy --path . --script res://tools/guard_probe4.gd`.
Seeds 7000-7199, 200 bouts a cell, 12 cells (guard_probe3's: 6 styles x am3 + pro6).
Her aim: held HIGH N full rounds -> +S to the body (stays); held LOW N rounds -> -S (stays); NEUTRAL moves nothing.
Damage = through-guard leak split head/body by her current body share x GuardWear.posture_damage.

Cell am3_pressure: body share 0.369
Cell am3_slugger: body share 0.213
Cell am3_outboxer: body share 0.209
Cell am3_counter: body share 0.209
Cell am3_volume: body share 0.213
Cell am3_boxpunch: body share 0.211
Cell pro6_pressure: body share 0.394
Cell pro6_slugger: body share 0.249
Cell pro6_outboxer: body share 0.218
Cell pro6_counter: body share 0.221
Cell pro6_volume: body share 0.245
Cell pro6_boxpunch: body share 0.231
(bouts played in 64.1 s)

## N=1 S=0.15  best counts { "HIGH": 5, "LOW": 0, "NEUTRAL": 0, "SWITCH": 7, "READ": 0 }  fixed max 5/12 -> PASS
  am3_pressure   best SWITCH  | HIGH -3.5%, LOW +5.7%, NEUTRAL +0.0%, SWITCH -7.8%, READ -7.8%
  am3_slugger    best SWITCH  | HIGH -9.0%, LOW +11.2%, NEUTRAL +0.0%, SWITCH -9.6%, READ -9.0%
  am3_outboxer   best SWITCH  | HIGH -9.2%, LOW +11.2%, NEUTRAL +0.0%, SWITCH -9.8%, READ -9.2%
  am3_counter    best SWITCH  | HIGH -9.2%, LOW +11.2%, NEUTRAL +0.0%, SWITCH -9.7%, READ -9.2%
  am3_volume     best SWITCH  | HIGH -9.0%, LOW +11.0%, NEUTRAL +0.0%, SWITCH -9.7%, READ -9.0%
  am3_boxpunch   best SWITCH  | HIGH -9.1%, LOW +11.2%, NEUTRAL +0.0%, SWITCH -9.7%, READ -9.1%
  pro6_pressure  best SWITCH  | HIGH -1.9%, LOW +5.6%, NEUTRAL +0.0%, SWITCH -6.9%, READ -6.9%
  pro6_slugger   best HIGH    | HIGH -6.9%, LOW +10.6%, NEUTRAL +0.0%, SWITCH -6.9%, READ -6.9%
  pro6_outboxer  best HIGH    | HIGH -8.0%, LOW +11.7%, NEUTRAL +0.0%, SWITCH -6.8%, READ -8.0%
  pro6_counter   best HIGH    | HIGH -8.0%, LOW +11.6%, NEUTRAL +0.0%, SWITCH -7.0%, READ -8.0%
  pro6_volume    best HIGH    | HIGH -7.1%, LOW +10.8%, NEUTRAL +0.0%, SWITCH -7.0%, READ -7.1%
  pro6_boxpunch  best HIGH    | HIGH -7.6%, LOW +11.3%, NEUTRAL +0.0%, SWITCH -6.9%, READ -7.6%

## N=1 S=0.25  best counts { "HIGH": 0, "LOW": 0, "NEUTRAL": 0, "SWITCH": 12, "READ": 0 }  fixed max 0/12 -> PASS
  am3_pressure   best SWITCH  | HIGH -1.1%, LOW +8.1%, NEUTRAL +0.0%, SWITCH -10.2%, READ -10.2%
  am3_slugger    best SWITCH  | HIGH -6.5%, LOW +12.2%, NEUTRAL +0.0%, SWITCH -11.3%, READ -6.5%
  am3_outboxer   best SWITCH  | HIGH -6.8%, LOW +12.1%, NEUTRAL +0.0%, SWITCH -11.3%, READ -6.8%
  am3_counter    best SWITCH  | HIGH -6.9%, LOW +12.1%, NEUTRAL +0.0%, SWITCH -11.3%, READ -6.9%
  am3_volume     best SWITCH  | HIGH -6.7%, LOW +12.1%, NEUTRAL +0.0%, SWITCH -11.4%, READ -6.7%
  am3_boxpunch   best SWITCH  | HIGH -6.7%, LOW +12.1%, NEUTRAL +0.0%, SWITCH -11.3%, READ -6.7%
  pro6_pressure  best SWITCH  | HIGH +1.0%, LOW +8.5%, NEUTRAL +0.0%, SWITCH -9.8%, READ -9.8%
  pro6_slugger   best SWITCH  | HIGH -4.0%, LOW +12.9%, NEUTRAL +0.0%, SWITCH -9.6%, READ -4.0%
  pro6_outboxer  best SWITCH  | HIGH -5.0%, LOW +13.2%, NEUTRAL +0.0%, SWITCH -9.2%, READ -5.0%
  pro6_counter   best SWITCH  | HIGH -5.1%, LOW +13.1%, NEUTRAL +0.0%, SWITCH -9.3%, READ -5.1%
  pro6_volume    best SWITCH  | HIGH -4.2%, LOW +12.9%, NEUTRAL +0.0%, SWITCH -9.6%, READ -4.2%
  pro6_boxpunch  best SWITCH  | HIGH -4.6%, LOW +13.1%, NEUTRAL +0.0%, SWITCH -9.4%, READ -4.6%

## N=1 S=0.35  best counts { "HIGH": 0, "LOW": 0, "NEUTRAL": 0, "SWITCH": 12, "READ": 0 }  fixed max 0/12 -> PASS
  am3_pressure   best SWITCH  | HIGH +1.3%, LOW +10.5%, NEUTRAL +0.0%, SWITCH -12.5%, READ -12.5%
  am3_slugger    best SWITCH  | HIGH -4.1%, LOW +12.2%, NEUTRAL +0.0%, SWITCH -12.4%, READ -12.4%
  am3_outboxer   best SWITCH  | HIGH -4.5%, LOW +12.1%, NEUTRAL +0.0%, SWITCH -12.4%, READ -12.4%
  am3_counter    best SWITCH  | HIGH -4.5%, LOW +12.1%, NEUTRAL +0.0%, SWITCH -12.4%, READ -12.4%
  am3_volume     best SWITCH  | HIGH -4.3%, LOW +12.1%, NEUTRAL +0.0%, SWITCH -12.5%, READ -12.5%
  am3_boxpunch   best SWITCH  | HIGH -4.3%, LOW +12.1%, NEUTRAL +0.0%, SWITCH -12.4%, READ -12.4%
  pro6_pressure  best SWITCH  | HIGH +3.9%, LOW +11.4%, NEUTRAL +0.0%, SWITCH -12.7%, READ -12.7%
  pro6_slugger   best SWITCH  | HIGH -1.1%, LOW +12.9%, NEUTRAL +0.0%, SWITCH -11.3%, READ -11.3%
  pro6_outboxer  best SWITCH  | HIGH -2.1%, LOW +13.2%, NEUTRAL +0.0%, SWITCH -10.9%, READ -10.9%
  pro6_counter   best SWITCH  | HIGH -2.2%, LOW +13.1%, NEUTRAL +0.0%, SWITCH -11.0%, READ -11.0%
  pro6_volume    best SWITCH  | HIGH -1.3%, LOW +12.9%, NEUTRAL +0.0%, SWITCH -11.3%, READ -11.3%
  pro6_boxpunch  best SWITCH  | HIGH -1.7%, LOW +13.1%, NEUTRAL +0.0%, SWITCH -11.1%, READ -11.1%

## N=2 S=0.15  best counts { "HIGH": 5, "LOW": 0, "NEUTRAL": 0, "SWITCH": 7, "READ": 0 }  fixed max 5/12 -> PASS
  am3_pressure   best SWITCH  | HIGH -5.2%, LOW +4.0%, NEUTRAL +0.0%, SWITCH -5.6%, READ -5.6%
  am3_slugger    best HIGH    | HIGH -10.7%, LOW +9.4%, NEUTRAL +0.0%, SWITCH -7.2%, READ -10.7%
  am3_outboxer   best HIGH    | HIGH -10.8%, LOW +9.5%, NEUTRAL +0.0%, SWITCH -7.4%, READ -10.8%
  am3_counter    best HIGH    | HIGH -10.9%, LOW +9.5%, NEUTRAL +0.0%, SWITCH -7.4%, READ -10.9%
  am3_volume     best HIGH    | HIGH -10.7%, LOW +9.4%, NEUTRAL +0.0%, SWITCH -7.3%, READ -10.7%
  am3_boxpunch   best HIGH    | HIGH -10.7%, LOW +9.5%, NEUTRAL +0.0%, SWITCH -7.3%, READ -10.7%
  pro6_pressure  best SWITCH  | HIGH -2.8%, LOW +4.7%, NEUTRAL +0.0%, SWITCH -7.2%, READ -7.2%
  pro6_slugger   best SWITCH  | HIGH -7.8%, LOW +9.8%, NEUTRAL +0.0%, SWITCH -8.9%, READ -7.8%
  pro6_outboxer  best SWITCH  | HIGH -8.9%, LOW +10.9%, NEUTRAL +0.0%, SWITCH -9.2%, READ -8.9%
  pro6_counter   best SWITCH  | HIGH -8.9%, LOW +10.7%, NEUTRAL +0.0%, SWITCH -9.2%, READ -8.9%
  pro6_volume    best SWITCH  | HIGH -8.0%, LOW +9.9%, NEUTRAL +0.0%, SWITCH -8.8%, READ -8.0%
  pro6_boxpunch  best SWITCH  | HIGH -8.4%, LOW +10.4%, NEUTRAL +0.0%, SWITCH -9.1%, READ -8.4%

## N=2 S=0.25  best counts { "HIGH": 5, "LOW": 0, "NEUTRAL": 0, "SWITCH": 7, "READ": 0 }  fixed max 5/12 -> PASS
  am3_pressure   best SWITCH  | HIGH -3.9%, LOW +5.3%, NEUTRAL +0.0%, SWITCH -6.9%, READ -6.9%
  am3_slugger    best HIGH    | HIGH -9.4%, LOW +10.0%, NEUTRAL +0.0%, SWITCH -8.5%, READ -9.4%
  am3_outboxer   best HIGH    | HIGH -9.6%, LOW +10.0%, NEUTRAL +0.0%, SWITCH -8.6%, READ -9.6%
  am3_counter    best HIGH    | HIGH -9.6%, LOW +10.0%, NEUTRAL +0.0%, SWITCH -8.7%, READ -9.6%
  am3_volume     best HIGH    | HIGH -9.4%, LOW +9.9%, NEUTRAL +0.0%, SWITCH -8.5%, READ -9.4%
  am3_boxpunch   best HIGH    | HIGH -9.5%, LOW +10.0%, NEUTRAL +0.0%, SWITCH -8.5%, READ -9.5%
  pro6_pressure  best SWITCH  | HIGH -0.4%, LOW +7.0%, NEUTRAL +0.0%, SWITCH -9.5%, READ -9.5%
  pro6_slugger   best SWITCH  | HIGH -5.5%, LOW +11.6%, NEUTRAL +0.0%, SWITCH -11.0%, READ -5.5%
  pro6_outboxer  best SWITCH  | HIGH -6.5%, LOW +12.0%, NEUTRAL +0.0%, SWITCH -11.0%, READ -6.5%
  pro6_counter   best SWITCH  | HIGH -6.6%, LOW +11.8%, NEUTRAL +0.0%, SWITCH -10.9%, READ -6.6%
  pro6_volume    best SWITCH  | HIGH -5.7%, LOW +11.6%, NEUTRAL +0.0%, SWITCH -10.8%, READ -5.7%
  pro6_boxpunch  best SWITCH  | HIGH -6.1%, LOW +11.8%, NEUTRAL +0.0%, SWITCH -11.0%, READ -6.1%

## N=2 S=0.35  best counts { "HIGH": 0, "LOW": 0, "NEUTRAL": 0, "SWITCH": 12, "READ": 0 }  fixed max 0/12 -> PASS
  am3_pressure   best SWITCH  | HIGH -2.6%, LOW +6.6%, NEUTRAL +0.0%, SWITCH -8.2%, READ -8.2%
  am3_slugger    best SWITCH  | HIGH -8.2%, LOW +10.0%, NEUTRAL +0.0%, SWITCH -9.7%, READ -9.7%
  am3_outboxer   best SWITCH  | HIGH -8.4%, LOW +10.0%, NEUTRAL +0.0%, SWITCH -9.8%, READ -9.8%
  am3_counter    best SWITCH  | HIGH -8.4%, LOW +10.0%, NEUTRAL +0.0%, SWITCH -9.9%, READ -9.9%
  am3_volume     best SWITCH  | HIGH -8.2%, LOW +9.9%, NEUTRAL +0.0%, SWITCH -9.8%, READ -9.8%
  am3_boxpunch   best SWITCH  | HIGH -8.3%, LOW +10.0%, NEUTRAL +0.0%, SWITCH -9.8%, READ -9.8%
  pro6_pressure  best SWITCH  | HIGH +1.9%, LOW +9.3%, NEUTRAL +0.0%, SWITCH -11.8%, READ -11.8%
  pro6_slugger   best SWITCH  | HIGH -3.2%, LOW +11.6%, NEUTRAL +0.0%, SWITCH -12.1%, READ -12.1%
  pro6_outboxer  best SWITCH  | HIGH -4.2%, LOW +12.0%, NEUTRAL +0.0%, SWITCH -12.2%, READ -12.2%
  pro6_counter   best SWITCH  | HIGH -4.3%, LOW +11.8%, NEUTRAL +0.0%, SWITCH -12.1%, READ -12.1%
  pro6_volume    best SWITCH  | HIGH -3.4%, LOW +11.6%, NEUTRAL +0.0%, SWITCH -12.0%, READ -12.0%
  pro6_boxpunch  best SWITCH  | HIGH -3.8%, LOW +11.8%, NEUTRAL +0.0%, SWITCH -12.1%, READ -12.1%

## N=3 S=0.15  best counts { "HIGH": 11, "LOW": 0, "NEUTRAL": 0, "SWITCH": 1, "READ": 0 }  fixed max 11/12 -> fail
  am3_pressure   best HIGH    | HIGH -7.1%, LOW +2.1%, NEUTRAL +0.0%, SWITCH -7.1%, READ -7.1%
  am3_slugger    best HIGH    | HIGH -12.6%, LOW +7.6%, NEUTRAL +0.0%, SWITCH -12.6%, READ -12.6%
  am3_outboxer   best HIGH    | HIGH -12.7%, LOW +7.7%, NEUTRAL +0.0%, SWITCH -12.7%, READ -12.7%
  am3_counter    best HIGH    | HIGH -12.7%, LOW +7.7%, NEUTRAL +0.0%, SWITCH -12.7%, READ -12.7%
  am3_volume     best HIGH    | HIGH -12.5%, LOW +7.5%, NEUTRAL +0.0%, SWITCH -12.5%, READ -12.5%
  am3_boxpunch   best HIGH    | HIGH -12.6%, LOW +7.6%, NEUTRAL +0.0%, SWITCH -12.6%, READ -12.6%
  pro6_pressure  best SWITCH  | HIGH -3.7%, LOW +3.8%, NEUTRAL +0.0%, SWITCH -5.1%, READ -5.1%
  pro6_slugger   best HIGH    | HIGH -8.7%, LOW +8.9%, NEUTRAL +0.0%, SWITCH -5.2%, READ -8.7%
  pro6_outboxer  best HIGH    | HIGH -9.7%, LOW +10.0%, NEUTRAL +0.0%, SWITCH -5.1%, READ -9.7%
  pro6_counter   best HIGH    | HIGH -9.8%, LOW +9.8%, NEUTRAL +0.0%, SWITCH -5.4%, READ -9.8%
  pro6_volume    best HIGH    | HIGH -8.9%, LOW +9.0%, NEUTRAL +0.0%, SWITCH -5.3%, READ -8.9%
  pro6_boxpunch  best HIGH    | HIGH -9.3%, LOW +9.5%, NEUTRAL +0.0%, SWITCH -5.2%, READ -9.3%

## N=3 S=0.25  best counts { "HIGH": 11, "LOW": 0, "NEUTRAL": 0, "SWITCH": 1, "READ": 0 }  fixed max 11/12 -> fail
  am3_pressure   best HIGH    | HIGH -7.1%, LOW +2.1%, NEUTRAL +0.0%, SWITCH -7.1%, READ -7.1%
  am3_slugger    best HIGH    | HIGH -12.6%, LOW +7.6%, NEUTRAL +0.0%, SWITCH -12.6%, READ -12.6%
  am3_outboxer   best HIGH    | HIGH -12.7%, LOW +7.7%, NEUTRAL +0.0%, SWITCH -12.7%, READ -12.7%
  am3_counter    best HIGH    | HIGH -12.7%, LOW +7.7%, NEUTRAL +0.0%, SWITCH -12.7%, READ -12.7%
  am3_volume     best HIGH    | HIGH -12.5%, LOW +7.5%, NEUTRAL +0.0%, SWITCH -12.5%, READ -12.5%
  am3_boxpunch   best HIGH    | HIGH -12.6%, LOW +7.6%, NEUTRAL +0.0%, SWITCH -12.6%, READ -12.6%
  pro6_pressure  best SWITCH  | HIGH -1.9%, LOW +5.5%, NEUTRAL +0.0%, SWITCH -6.9%, READ -6.9%
  pro6_slugger   best HIGH    | HIGH -6.9%, LOW +10.3%, NEUTRAL +0.0%, SWITCH -6.9%, READ -6.9%
  pro6_outboxer  best HIGH    | HIGH -8.0%, LOW +10.8%, NEUTRAL +0.0%, SWITCH -6.9%, READ -8.0%
  pro6_counter   best HIGH    | HIGH -8.1%, LOW +10.6%, NEUTRAL +0.0%, SWITCH -7.1%, READ -8.1%
  pro6_volume    best HIGH    | HIGH -7.2%, LOW +10.3%, NEUTRAL +0.0%, SWITCH -7.0%, READ -7.2%
  pro6_boxpunch  best HIGH    | HIGH -7.6%, LOW +10.6%, NEUTRAL +0.0%, SWITCH -6.9%, READ -7.6%

## N=3 S=0.35  best counts { "HIGH": 6, "LOW": 0, "NEUTRAL": 0, "SWITCH": 6, "READ": 0 }  fixed max 6/12 -> PASS
  am3_pressure   best HIGH    | HIGH -7.1%, LOW +2.1%, NEUTRAL +0.0%, SWITCH -7.1%, READ -7.1%
  am3_slugger    best HIGH    | HIGH -12.6%, LOW +7.6%, NEUTRAL +0.0%, SWITCH -12.6%, READ -12.6%
  am3_outboxer   best HIGH    | HIGH -12.7%, LOW +7.7%, NEUTRAL +0.0%, SWITCH -12.7%, READ -12.7%
  am3_counter    best HIGH    | HIGH -12.7%, LOW +7.7%, NEUTRAL +0.0%, SWITCH -12.7%, READ -12.7%
  am3_volume     best HIGH    | HIGH -12.5%, LOW +7.5%, NEUTRAL +0.0%, SWITCH -12.5%, READ -12.5%
  am3_boxpunch   best HIGH    | HIGH -12.6%, LOW +7.6%, NEUTRAL +0.0%, SWITCH -12.6%, READ -12.6%
  pro6_pressure  best SWITCH  | HIGH -0.2%, LOW +7.2%, NEUTRAL +0.0%, SWITCH -8.6%, READ -8.6%
  pro6_slugger   best SWITCH  | HIGH -5.2%, LOW +10.3%, NEUTRAL +0.0%, SWITCH -8.6%, READ -8.6%
  pro6_outboxer  best SWITCH  | HIGH -6.2%, LOW +10.8%, NEUTRAL +0.0%, SWITCH -8.6%, READ -8.6%
  pro6_counter   best SWITCH  | HIGH -6.4%, LOW +10.6%, NEUTRAL +0.0%, SWITCH -8.8%, READ -8.8%
  pro6_volume    best SWITCH  | HIGH -5.5%, LOW +10.3%, NEUTRAL +0.0%, SWITCH -8.7%, READ -8.7%
  pro6_boxpunch  best SWITCH  | HIGH -5.9%, LOW +10.6%, NEUTRAL +0.0%, SWITCH -8.7%, READ -8.7%

RESULT: tools/guard_probe4.gd -> PASS at N=1 S=0.15 (all: N=1 S=0.15, N=1 S=0.25, N=1 S=0.35, N=2 S=0.15, N=2 S=0.25, N=2 S=0.35, N=3 S=0.35)
