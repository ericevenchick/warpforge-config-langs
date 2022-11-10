package build

import "warpsys.org:base"

let build_script = """
cd /src/*
make defconfig
sed -e 's/.*CONFIG_SELINUXENABLED.*/CONFIG_SELINUXENABLED=n/' -i .config
sed -e 's/.*CONFIG_NANDWRITE.*/CONFIG_NANDWRITE=n/' -i .config
sed -e 's/.*CONFIG_NANDDUMP.*/CONFIG_NANDDUMP=n/' -i .config
sed -e 's/.*CONFIG_UBIATTACH.*/CONFIG_UBIATTACH=n/' -i .config
sed -e 's/.*CONFIG_UBIDETACH.*/CONFIG_UBIDETACH=n/' -i .config
sed -e 's/.*CONFIG_UBIMKVOL.*/CONFIG_UBIMKVOL=n/' -i .config
sed -e 's/.*CONFIG_UBIRMVOL.*/CONFIG_UBIRMVOL=n/' -i .config
sed -e 's/.*CONFIG_UBIRSVOL.*/CONFIG_UBIRSVOL=n/' -i .config
sed -e 's/.*CONFIG_UBIUPDATEVOL.*/CONFIG_UBIUPDATEVOL=n/' -i .config
sed -e 's/.*CONFIG_UBIRENAME.*/CONFIG_UBIRENAME=n/' -i .config
make
LDFLAGS='--static' make CONFIG_PREFIX=/out install
"""

#pkgconfig: #pkgconfigschema & {
    src: base.catalogentry & {
        module:  "warpsys.org/busybox"
        release: "v1.35.0"
        item:    "src"
    }
    script: build_script
}