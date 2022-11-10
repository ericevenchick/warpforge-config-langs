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
        module:  "warpsys.org/bash"
        release: "v5.1.16"
        item:    "src"
    }
    script: build_script
}