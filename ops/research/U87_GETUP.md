# U87 get-up digest

GETUP body=f01 take=knockdown join_deg=6.85 follows=true
GETUP body=f01 take=knockdown#1 join_deg=22.13 follows=false
GETUP body=f09 take=knockdown join_deg=6.85 follows=true
GETUP body=f09 take=knockdown#1 join_deg=22.13 follows=false

SUITE total=23 fails=1

KnockDown02 (`knockdown#1`) did not qualify: its 22.13° mean join exceeds 2× KnockDown01's 6.85°.
