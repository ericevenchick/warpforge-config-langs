def plot(steps):
    plot = {
        "inputs": {},
        "steps": steps,
        "outputs": {}}
    return plot

def catalog_input_str(module, release, item):
    return "catalog:{module}:{release}:{item}".format(module=module, release=release, item=item)

def script_protoformula(inputs, interp, script):
    pathstr = "literal:"
    for i in inputs.keys():
        pathstr = pathstr + "{path}/bin:".format(path=i)
    inputs["$PATH"] = pathstr
    protoformula = {"protoformula": {
            "inputs": inputs,
            "action": {"script": {"interpreter": interp, "contents": script.split("\n")}},
            "outputs": {}}}
    return protoformula

def gnu_build_step(src, script):

    build_deps = [
	    ("warpsys.org/bootstrap/glibc", "v2.35", "amd64"),
	    ("warpsys.org/bootstrap/busybox", "v1.35.0", "amd64"),
		("warpsys.org/bootstrap/ldshim", "v1.0", "amd64"),
		("warpsys.org/bootstrap/make", "v4.3", "amd64"),
	    ("warpsys.org/bootstrap/gcc", "v11.2.0", "amd64"),
		("warpsys.org/bootstrap/grep", "v3.7", "amd64"),
	    ("warpsys.org/bootstrap/coreutils", "v9.1", "amd64"),
		("warpsys.org/bootstrap/binutils", "v2.38", "amd64"),
		("warpsys.org/bootstrap/sed", "v4.8", "amd64"),
		("warpsys.org/bootstrap/gawk", "v5.1.1", "amd64"),
		("warpsys.org/findutils", "v4.9.0", "amd64"),
		("warpsys.org/diffutils", "v3.8", "amd64"),
    ]    

    inputs = {}
    for dep in build_deps:
        inputs["/pkg/" + dep[0]] = catalog_input_str(dep[0], dep[1], dep[2])

    inputs["/src"] = src
    
    return {"protoformula": {
        "inputs": inputs,
        "action": {"script": {"interpreter": "/pkg/warpsys.org/bootstrap/busybox/bin/sh", 
                              "contents": script.split("\n")}},
        "outputs": {}
    }}
