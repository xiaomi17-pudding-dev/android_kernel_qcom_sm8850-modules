load(":repo_paths.bzl", "modules_label", "soc_label")
load("//build/kernel/kleaf:kernel.bzl", "ddk_module")
load("@rules_pkg//pkg:install.bzl", "pkg_install")
load("@rules_pkg//pkg:mappings.bzl", "pkg_files", "strip_prefix")

def define_modules(target, variant):
    tv = "{}_{}".format(target, variant)

    copts = []
    deps = [
        soc_label("all_headers"),
        soc_label("{}/drivers/pinctrl/qcom/pinctrl-msm".format(tv)),
    ]
    kernel_build = soc_label("{}_base_kernel".format(tv))
    if target == "sun":
        copts.append("-DNFC_SECURE_PERIPHERAL_ENABLED")
        deps += [
            modules_label("qcom/opensource/securemsm-kernel:smcinvoke_kernel_headers"),
            modules_label("qcom/opensource/securemsm-kernel:{}_smcinvoke_dlkm".format(tv)),
        ]

    if target == "malabar":
        copts.append("-DCONFIG_NFC_BOB1")

    if target == "canoe":
        copts.append("-DCONFIG_NFC_BOB1")
        copts.append("-DNFC_SECURE_PERIPHERAL_ENABLED")
        deps += [
            modules_label("qcom/opensource/securemsm-kernel:smcinvoke_kernel_headers"),
            modules_label("qcom/opensource/securemsm-kernel:{}_smcinvoke_dlkm".format(tv)),
        ]

    if target == "bengal":
        copts.append("-DNFC_CLK_REQ_GPIO_WAKEUP")

    if target == "waipio":
        copts.append("-DNFC_CLK_REQ_GPIO_WAKEUP")

    if target == "chora":
        copts.append("-DCONFIG_NFC_BOB1")

    ddk_module(
        name = "{}_stm_nfc_i2c".format(tv),
        out = "stm_nfc_i2c.ko",
        srcs = [
            "nfc/st21nfc.c",
            "nfc/st21nfc.h",
        ],
        hdrs = ["include/uapi/linux/nfc/st_uapi.h"],
        includes = [".", "linux", "nfc", "include/uapi/linux/nfc"],
        copts = copts,
        deps = deps,
        kernel_build = kernel_build,
        visibility = ["//visibility:public"],
    )

    pkg_files(
        name = "{tv}_stm_nfc_i2c_dist_files".format(tv = tv),
        srcs = [":{tv}_stm_nfc_i2c".format(tv = tv)],
        visibility = ["//visibility:private"],
        strip_prefix = strip_prefix.files_only(),
    )

    pkg_install(
        name = "{tv}_stm_nfc_i2c_dist".format(tv = tv),
        srcs = [":{tv}_stm_nfc_i2c_dist_files".format(tv = tv)],
        destdir = "out/target/product/{}/dlkm/lib/modules/".format(target),
    )
