import sys
import collections
from portage.util.configparser import (read_configs, SafeConfigParser)

p=SafeConfigParser({}, collections.defaultdict)
read_configs(p, sys.argv[1:])
first=True
for sect in sorted(p.sections()):
	if first:
		first=False
	else:
		print()
	print("[{}]".format(sect))
	for itm in sorted(p.items(sect)):
		print("{} = {}".format(itm[0],itm[1]))
