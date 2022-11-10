package build 

import "strings"
import "path"
import "list"

import "warpsys.org:base"

#pkgconfigschema: {
	extra_pkgs: [...] | *[]
	script: string | *""
	src: base.catalogentry
	cflags: [...string]
	inputs: {...}
}

#ld: base.catalogentry & {
	module:  "warpsys.org/bootstrap/glibc"
	release: "v2.35"
	item:    "ld-amd64"
}

#glibc: base.catalogentry & {
	module:  "warpsys.org/bootstrap/glibc"
	release: "v2.35"
	item:    "amd64"
}

#default_pkgs: [
	#glibc,
	base.catalogentry & {
		module:  "warpsys.org/bootstrap/busybox"
		release: "v1.35.0"
		item:    "amd64"
	},
	base.catalogentry & {
		module:  "warpsys.org/bootstrap/ldshim"
		release: "v1.0"
		item:    "amd64"
	},
	base.catalogentry & {
		module:  "warpsys.org/bootstrap/make"
		release: "v4.3"
		item:    "amd64"
	},
	base.catalogentry & {
		module:  "warpsys.org/bootstrap/gcc"
		release: "v11.2.0"
		item:    "amd64"
	},
	base.catalogentry & {
		module:  "warpsys.org/bootstrap/grep"
		release: "v3.7"
		item:    "amd64"
	},
	base.catalogentry & {
		module:  "warpsys.org/bootstrap/coreutils"
		release: "v9.1"
		item:    "amd64"
	},
	base.catalogentry & {
		module:  "warpsys.org/bootstrap/binutils"
		release: "v2.38"
		item:    "amd64"
	},
	base.catalogentry & {
		module:  "warpsys.org/bootstrap/sed"
		release: "v4.8"
		item:    "amd64"
	},
	base.catalogentry & {
		module:  "warpsys.org/bootstrap/gawk"
		release: "v5.1.1"
		item:    "amd64"
	},
	base.catalogentry & {
		module:  "warpsys.org/findutils"
		release: "v4.9.0"
		item:    "amd64"
	},
	base.catalogentry & {
		module:  "warpsys.org/diffutils"
		release: "v3.8"
		item:    "amd64"
	},
]

let pkgs = list.Concat([#default_pkgs, #pkgconfig.extra_pkgs])

#path: base.pathstr & {items: [
	for pkg in pkgs {
		path.Join([pkg.path, "bin"], path.Unix)
	},
]}

#cpath: base.pathstr & {items: [
	path.Join([#glibc.path, "include"], path.Unix),
	path.Join([#glibc.path, "include/x86_64-linux-gnu"], path.Unix),
]}

let env_setup_script = """
	mkdir -p /bin /tmp /prefix /usr/include/
	ln -s /pkg/warpsys.org/bootstrap/glibc/lib /prefix/lib
	ln -s /pkg/warpsys.org/bootstrap/glibc/lib /lib
	ln -s /pkg/warpsys.org/bootstrap/busybox/bin/sh /bin/sh
	ln -s /pkg/warpsys.org/bootstrap/gcc/bin/cpp /lib/cpp
	"""

#inputs: {
	{
		for pkg in pkgs {
			"\(pkg.path)": pkg.as_string
		}
	} & {
		"$PATH": #path.as_string
		"$CPATH": #cpath.as_string
		"$SOURCE_DATE_EPOCH": "literal:1262304000"
		"$CFLAGS": strings.Join(["literal:", strings.Join(#pkgconfig.cflags, " ")], "")
		"$LDFLAGS": "literal:-Wl,-rpath=XORIGIN/../lib"
		"$ARFLAGS": "literal:rvD"
		"/lib64": #ld.as_string
		"/src": #pkgconfig.src.as_string
	} & #pkgconfig.inputs 
}

#steprun: {
	protoformula: base.protoformula & {
		inputs: #inputs
		action: script: {
			interpreter: "/pkg/warpsys.org/bootstrap/busybox/bin/sh"
			contents:    strings.Split(strings.Join([env_setup_script, #pkgconfig.script], "\n"), "\n")
		}
	}
}

"plot.v1": base.plot & {
	steps: {
		run: #steprun
	}
}