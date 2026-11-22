"""CASCTEST1: list strings tool_auto_physics.dll carries about its actions and its 'Apply AutoPhysics' dialog."""
import re, sys
b = open(r'C:/Program Files/Cascadeur/tool_auto_physics.dll', 'rb').read()
s = set(m.group().decode() for m in re.finditer(rb'[ -~]{4,160}', b))
s |= set(m.group().decode('utf-16le') for m in re.finditer(rb'(?:[ -~]\x00){4,160}', b))
keys = sys.argv[1:] or ['AutoPhysicsTool.', 'Snap', 'Apply', 'apply']
for x in sorted(x for x in s if any(k in x for k in keys)):
    print(x)
