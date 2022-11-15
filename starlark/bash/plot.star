load("../lib.star", "plot")
load("../lib.star", "catalog_input_str")
load("../lib.star", "gnu_build_step")

step_build = gnu_build_step(
    catalog_input_str("warpsys.org/bash", "v5.1.16", "src"),
    """
    cd /src/*
    ./configure --prefix=/warpsys-placeholder-prefix 
    make
    make DESTDIR=/out install
    sed -i '0,/XORIGIN/{s/XORIGIN/$ORIGIN/}' /out/warpsys-placeholder-prefix/bin/*
    """
)

result = plot({"one": step_build})