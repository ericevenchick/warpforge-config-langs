package build

import "warpsys.org:base"

let build_script = """
ln -s /pkg/warpsys.org/bootstrap/gcc/bin/gcc /bin/cc
ln -s /pkg/warpsys.org/bootstrap/gcc/bin/cpp /lib/cpp
cd /src/*
sh Configure -Dcc=/pkg/warpsys.org/bootstrap/gcc/bin/gcc -Dprefix=/warpsys-placeholder-prefix -Aldflags=-Wl,-rpath=XORIGIN/../lib -Aarflags=rvD -de
make
make DESTDIR=/out install
sed -i '0,/XORIGIN/{s/XORIGIN/$ORIGIN/}' /out/warpsys-placeholder-prefix/bin/*
"""

#pkgconfig: #pkgconfigschema & {
    src: base.catalogentry & {
        module:  "warpsys.org/perl"
        release: "v5.36.0"
        item:    "src"
    }
    script: build_script
}