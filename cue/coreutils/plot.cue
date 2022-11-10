package build

import "warpsys.org:base"

let build_script = """
cd /src/*
./configure --prefix=/warpsys-placeholder-prefix 
make
make DESTDIR=/out install
sed -i '0,/XORIGIN/{s/XORIGIN/$ORIGIN/}' /out/warpsys-placeholder-prefix/bin/*
"""

#pkgconfig: #pkgconfigschema & {
	src: base.catalogentry & {
		module:  "warpsys.org/coreutils"
		release: "v9.1"
		item:    "src"
	}
	inputs: {
		"$FORCE_UNSAFE_CONFIGURE": "literal:1"
	}
	script: build_script
}