# TODO: CONFIG_BOOTCOMMAND

ARM32_CROSS_GCC := "arm-linux-gnueabihf-"
ARM64_CROSS_GCC := "aarch64-linux-gnu-"

U_BOOT_DIR      := $(abspath $(CURDIR)/u-boot)

RPI1_DIR        := $(abspath $(CURDIR)/rpi1)
RPI2_DIR        := $(abspath $(CURDIR)/rpi2)
RPI3_32_DIR     := $(abspath $(CURDIR)/rpi3_32)
RPI3_64_DIR     := $(abspath $(CURDIR)/rpi3_64)

PARALLEL        := $(shell nproc)

.PHONY: default
default: build dts checksum

.PHONY: build
build: rpi1_uboot.bin rpi2_uboot.bin rpi3_32_uboot.bin rpi3_64_uboot.bin
	@echo
	@echo "U-Boot Directory:                       $(U_BOOT_DIR)"
	@echo "Raspberry Pi 1 Build Directory:         $(RPI1_DIR)"
	@echo "Raspberry Pi 2 Build Directory:         $(RPI2_DIR)"
	@echo "Raspberry Pi 3 (32Bit) Build Directory: $(RPI3_32_DIR)"
	@echo "Raspberry Pi 3 (64Bit) Build Directory: $(RPI3_64_DIR)"
	@echo "Parallel Build Number:                  $(PARALLEL)"
	@echo

$(RPI1_DIR)/u-boot:
	@$(MAKE) -C "$(U_BOOT_DIR)" -j "$(PARALLEL)" "O=$(RPI1_DIR)" "CROSS_COMPILE=$(ARM32_CROSS_GCC)" rpi_defconfig
	@$(MAKE) -C "$(U_BOOT_DIR)" -j "$(PARALLEL)" "O=$(RPI1_DIR)" "CROSS_COMPILE=$(ARM32_CROSS_GCC)" all

$(RPI2_DIR)/u-boot:
	@$(MAKE) -C "$(U_BOOT_DIR)" -j "$(PARALLEL)" "O=$(RPI2_DIR)" "CROSS_COMPILE=$(ARM32_CROSS_GCC)" rpi_2_defconfig
	@$(MAKE) -C "$(U_BOOT_DIR)" -j "$(PARALLEL)" "O=$(RPI2_DIR)" "CROSS_COMPILE=$(ARM32_CROSS_GCC)" all

$(RPI3_32_DIR)/u-boot:
	@$(MAKE) -C "$(U_BOOT_DIR)" -j "$(PARALLEL)" "O=$(RPI3_32_DIR)" "CROSS_COMPILE=$(ARM32_CROSS_GCC)" rpi_3_32b_defconfig
	@$(MAKE) -C "$(U_BOOT_DIR)" -j "$(PARALLEL)" "O=$(RPI3_32_DIR)" "CROSS_COMPILE=$(ARM32_CROSS_GCC)" all

$(RPI3_64_DIR)/u-boot:
	@$(MAKE) -C "$(U_BOOT_DIR)" -j "$(PARALLEL)" "O=$(RPI3_64_DIR)" "CROSS_COMPILE=$(ARM64_CROSS_GCC)" rpi_3_defconfig
	@$(MAKE) -C "$(U_BOOT_DIR)" -j "$(PARALLEL)" "O=$(RPI3_64_DIR)" "CROSS_COMPILE=$(ARM64_CROSS_GCC)" all

rpi1_uboot.bin: $(RPI1_DIR)/u-boot
	@cp "$(RPI1_DIR)/u-boot" "rpi1_uboot.bin"

rpi2_uboot.bin: $(RPI2_DIR)/u-boot
	@cp "$(RPI2_DIR)/u-boot" "rpi2_uboot.bin"

rpi3_32_uboot.bin: $(RPI3_32_DIR)/u-boot
	@cp "$(RPI3_32_DIR)/u-boot" "rpi3_32_uboot.bin"

rpi3_64_uboot.bin: $(RPI3_64_DIR)/u-boot
	@cp "$(RPI3_64_DIR)/u-boot" "rpi3_64_uboot.bin"

.PHONY: dts
dts: bcm2835-rpi-b.dtb bcm2836-rpi-2-b.dtb bcm2837-rpi-3-b.dtb

bcm2835-rpi-b.dtb: $(RPI1_DIR)/u-boot
	@cp "$(RPI1_DIR)/arch/arm/dts/$@" $@

bcm2836-rpi-2-b.dtb: $(RPI2_DIR)/u-boot
	@cp "$(RPI2_DIR)/arch/arm/dts/$@" $@

bcm2837-rpi-3-b.dtb: $(RPI3_32_DIR)/u-boot
	@cp "$(RPI3_32_DIR)/arch/arm/dts/$@" $@

.PHONY: checksum
checksum: MD5SUMS SHA1SUMS SHA256SUMS SHA512SUMS
	@echo
	@cat MD5SUMS
	@echo
	@cat SHA1SUMS
	@echo
	@cat SHA256SUMS
	@echo
	@cat SHA512SUMS
	@echo

MD5SUMS: rpi1_uboot.bin rpi2_uboot.bin rpi3_32_uboot.bin rpi3_64_uboot.bin bcm2835-rpi-b.dtb bcm2836-rpi-2-b.dtb bcm2837-rpi-3-b.dtb
	@md5sum $^ | tee $@ > /dev/null

SHA1SUMS: rpi1_uboot.bin rpi2_uboot.bin rpi3_32_uboot.bin rpi3_64_uboot.bin bcm2835-rpi-b.dtb bcm2836-rpi-2-b.dtb bcm2837-rpi-3-b.dtb
	@sha1sum $^ | tee $@ > /dev/null

SHA256SUMS: rpi1_uboot.bin rpi2_uboot.bin rpi3_32_uboot.bin rpi3_64_uboot.bin bcm2835-rpi-b.dtb bcm2836-rpi-2-b.dtb bcm2837-rpi-3-b.dtb
	@sha256sum $^ | tee $@ > /dev/null

SHA512SUMS: rpi1_uboot.bin rpi2_uboot.bin rpi3_32_uboot.bin rpi3_64_uboot.bin bcm2835-rpi-b.dtb bcm2836-rpi-2-b.dtb bcm2837-rpi-3-b.dtb
	@sha512sum $^ | tee $@ > /dev/null

.PHONY: clean
clean:
	@rm -fr rpi1_uboot.bin rpi2_uboot.bin rpi3_32_uboot.bin rpi3_64_uboot.bin
	@rm -fr bcm2835-rpi-b.dtb bcm2836-rpi-2-b.dtb bcm2837-rpi-3-b.dtb
	@rm -fr MD5SUMS SHA1SUMS SHA256SUMS SHA512SUMS

.PHONY: distclean
distclean: clean
	@rm -fr "$(RPI1_DIR)" "$(RPI2_DIR)" "$(RPI3_32_DIR)" "$(RPI3_64_DIR)"
