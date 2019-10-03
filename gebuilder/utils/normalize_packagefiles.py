import portage.env.config as pec
import sys

dict={}
type=sys.argv[1]

if type == "mask":
	type=pec.PackageMaskFile
elif type == "use":
	type=pec.PackageUseFile
elif type == "accept_keywords":
	type=pec.PackageKeywordsFile
elif type == "unmask":
	type=pec.PackageMaskFile
else:
	raise Exception("Filetype {} unknown".format(type))

for file in sys.argv[2:]:
	pf=type(file)
	pf.load()
	for k,v in pf.items():
		if k not in dict:
			dict[k]=set()
		if v is not None:
			dict[k]|=set([x for x in v if x is not None])


for k,vs in sorted(dict.items()):
	print(k, " ", " ".join(sorted(vs)))

