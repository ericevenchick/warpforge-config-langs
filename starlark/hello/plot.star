load("../lib.star", "plot")
load("../lib.star", "catalog_input_str")
load("../lib.star", "script_protoformula")

step_run = script_protoformula(
    {
        "/pkg/busybox": catalog_input_str("warpsys.org/busybox", "v1.35.0", "amd64-static"),
        "/pkg/bash": catalog_input_str("warpsys.org/bash", "v5.1.16", "amd64"),
    }, 
    "/pkg/bash/bin/bash",
    """
    bash --version
    echo hello, world.
    ls
    """
)

result = plot({"one": step_run})