# TODO: CONFIG_BOOTCOMMAND

ARM32_CROSS_GCC   ?= arm-linux-gnueabihf-
ARM64_CROSS_GCC   ?= aarch64-linux-gnu-

U_BOOT_DIR        ?= $(abspath $(CURDIR)/u-boot)
BUILD_DIR         ?= $(abspath $(CURDIR)/build)

RPI1_DIR          ?= $(abspath $(BUILD_DIR)/rpi1)
RPI2_DIR          ?= $(abspath $(BUILD_DIR)/rpi2)
RPI3_32_DIR       ?= $(abspath $(BUILD_DIR)/rpi3_32)
RPI3_64_DIR       ?= $(abspath $(BUILD_DIR)/rpi3_64)
RPI3_BPLUS_32_DIR ?= $(abspath $(BUILD_DIR)/rpi3_bplus_32)
RPI3_BPLUS_64_DIR ?= $(abspath $(BUILD_DIR)/rpi3_bplus_64)

PARALLEL          ?= $(shell expr $(shell nproc) + 2)

.PHONY: default
default: build checksum

.PHONY: build
build: $(BUILD_DIR) rpi1_uboot.bin rpi2_uboot.bin rpi3_32_uboot.bin rpi3_64_uboot.bin rpi3_bplus_32_uboot.bin rpi3_bplus_64_uboot.bin

$(BUILD_DIR):
	@mkdir -p $@

$(RPI1_DIR):
	@mkdir -p $@

$(RPI2_DIR):
	@mkdir -p $@

$(RPI3_32_DIR):
	@mkdir -p $@

$(RPI3_64_DIR):
	@mkdir -p $@

$(RPI3_BPLUS_32_DIR):
	@mkdir -p $@

$(RPI3_BPLUS_64_DIR):
	@mkdir -p $@

$(RPI1_DIR)/.config: $(RPI1_DIR)
	@cp -a "$(U_BOOT_DIR)/configs/rpi_defconfig" $@
	@touch -r "$(U_BOOT_DIR)/configs/rpi_defconfig" $@

$(RPI2_DIR)/.config: $(RPI2_DIR)
	@cp -a "$(U_BOOT_DIR)/configs/rpi_2_defconfig" $@
	@touch -r "$(U_BOOT_DIR)/configs/rpi_2_defconfig" $@

$(RPI3_32_DIR)/.config: $(RPI3_32_DIR)
	@cp -a "$(U_BOOT_DIR)/configs/rpi_3_32b_defconfig" $@
	@touch -r "$(U_BOOT_DIR)/configs/rpi_3_32b_defconfig" $@

$(RPI3_64_DIR)/.config: $(RPI3_64_DIR)
	@cp -a "$(U_BOOT_DIR)/configs/rpi_3_defconfig" $@
	@touch -r "$(U_BOOT_DIR)/configs/rpi_3_defconfig" $@

$(RPI3_BPLUS_32_DIR)/.config: $(RPI3_BPLUS_32_DIR)
	@cp -a "$(U_BOOT_DIR)/configs/rpi_3_b_plus_defconfig" $@
	@sed -i -e 's@CONFIG_TARGET_RPI_3=y@CONFIG_TARGET_RPI_3_32B=y@' $@
	@sed -i -e 's@CONFIG_SYS_TEXT_BASE=0x00080000@CONFIG_SYS_TEXT_BASE=0x00008000@' $@
	@touch -r "$(U_BOOT_DIR)/configs/rpi_3_b_plus_defconfig" $@

$(RPI3_BPLUS_64_DIR)/.config: $(RPI3_BPLUS_64_DIR)
	@cp -a "$(U_BOOT_DIR)/configs/rpi_3_b_plus_defconfig" $@
	@touch -r "$(U_BOOT_DIR)/configs/rpi_3_b_plus_defconfig" $@

$(RPI1_DIR)/u-boot.bin: $(RPI1_DIR)/.config
	@$(MAKE) -C "$(U_BOOT_DIR)" -j "$(PARALLEL)" "O=$(RPI1_DIR)" "CROSS_COMPILE=$(ARM32_CROSS_GCC)" olddefconfig
	@$(MAKE) -C "$(U_BOOT_DIR)" -j "$(PARALLEL)" "O=$(RPI1_DIR)" "CROSS_COMPILE=$(ARM32_CROSS_GCC)" all

$(RPI2_DIR)/u-boot.bin: $(RPI2_DIR)/.config
	@$(MAKE) -C "$(U_BOOT_DIR)" -j "$(PARALLEL)" "O=$(RPI2_DIR)" "CROSS_COMPILE=$(ARM32_CROSS_GCC)" olddefconfig
	@$(MAKE) -C "$(U_BOOT_DIR)" -j "$(PARALLEL)" "O=$(RPI2_DIR)" "CROSS_COMPILE=$(ARM32_CROSS_GCC)" all

$(RPI3_32_DIR)/u-boot.bin: $(RPI3_32_DIR)/.config
	@$(MAKE) -C "$(U_BOOT_DIR)" -j "$(PARALLEL)" "O=$(RPI3_32_DIR)" "CROSS_COMPILE=$(ARM32_CROSS_GCC)" olddefconfig
	@$(MAKE) -C "$(U_BOOT_DIR)" -j "$(PARALLEL)" "O=$(RPI3_32_DIR)" "CROSS_COMPILE=$(ARM32_CROSS_GCC)" all

$(RPI3_64_DIR)/u-boot.bin: $(RPI3_64_DIR)/.config
	@$(MAKE) -C "$(U_BOOT_DIR)" -j "$(PARALLEL)" "O=$(RPI3_64_DIR)" "CROSS_COMPILE=$(ARM64_CROSS_GCC)" olddefconfig
	@$(MAKE) -C "$(U_BOOT_DIR)" -j "$(PARALLEL)" "O=$(RPI3_64_DIR)" "CROSS_COMPILE=$(ARM64_CROSS_GCC)" all

$(RPI3_BPLUS_32_DIR)/u-boot.bin: $(RPI3_BPLUS_32_DIR)/.config
	@$(MAKE) -C "$(U_BOOT_DIR)" -j "$(PARALLEL)" "O=$(RPI3_BPLUS_32_DIR)" "CROSS_COMPILE=$(ARM32_CROSS_GCC)" olddefconfig
	@$(MAKE) -C "$(U_BOOT_DIR)" -j "$(PARALLEL)" "O=$(RPI3_BPLUS_32_DIR)" "CROSS_COMPILE=$(ARM32_CROSS_GCC)" all

$(RPI3_BPLUS_64_DIR)/u-boot.bin: $(RPI3_BPLUS_64_DIR)/.config
	@$(MAKE) -C "$(U_BOOT_DIR)" -j "$(PARALLEL)" "O=$(RPI3_BPLUS_64_DIR)" "CROSS_COMPILE=$(ARM64_CROSS_GCC)" olddefconfig
	@$(MAKE) -C "$(U_BOOT_DIR)" -j "$(PARALLEL)" "O=$(RPI3_BPLUS_64_DIR)" "CROSS_COMPILE=$(ARM64_CROSS_GCC)" all

rpi1_uboot.bin: $(RPI1_DIR)/u-boot.bin
	@cp $^ $@

rpi2_uboot.bin: $(RPI2_DIR)/u-boot.bin
	@cp $^ $@

rpi3_32_uboot.bin: $(RPI3_32_DIR)/u-boot.bin
	@cp $^ $@

rpi3_64_uboot.bin: $(RPI3_64_DIR)/u-boot.bin
	@cp $^ $@

rpi3_bplus_32_uboot.bin: $(RPI3_BPLUS_32_DIR)/u-boot.bin
	@cp $^ $@

rpi3_bplus_64_uboot.bin: $(RPI3_BPLUS_64_DIR)/u-boot.bin
	@cp $^ $@

.PHONY: checksum
checksum: MD5SUMS SHA1SUMS SHA256SUMS SHA512SUMS

MD5SUMS: rpi1_uboot.bin rpi2_uboot.bin rpi3_32_uboot.bin rpi3_64_uboot.bin rpi3_bplus_32_uboot.bin rpi3_bplus_64_uboot.bin
	@md5sum $^ | tee $@ > /dev/null

SHA1SUMS: rpi1_uboot.bin rpi2_uboot.bin rpi3_32_uboot.bin rpi3_64_uboot.bin rpi3_bplus_32_uboot.bin rpi3_bplus_64_uboot.bin
	@sha1sum $^ | tee $@ > /dev/null

SHA256SUMS: rpi1_uboot.bin rpi2_uboot.bin rpi3_32_uboot.bin rpi3_64_uboot.bin rpi3_bplus_32_uboot.bin rpi3_bplus_64_uboot.bin
	@sha256sum $^ | tee $@ > /dev/null

SHA512SUMS: rpi1_uboot.bin rpi2_uboot.bin rpi3_32_uboot.bin rpi3_64_uboot.bin rpi3_bplus_32_uboot.bin rpi3_bplus_64_uboot.bin
	@sha512sum $^ | tee $@ > /dev/null

.PHONY: show
show: MD5SUMS SHA1SUMS SHA256SUMS SHA512SUMS
	@echo "U-Boot Directory:                        $(U_BOOT_DIR)"
	@echo "Build Directory:                         $(BUILD_DIR)"
	@echo "  -> Raspberry Pi Model A/A+/B+/CM/Zero: $(RPI1_DIR)"
	@echo "  -> Raspberry Pi 2 Model B:             $(RPI2_DIR)"
	@echo "  -> Raspberry Pi 3 Model B (32Bit):     $(RPI3_32_DIR)"
	@echo "  -> Raspberry Pi 3 Model B (64Bit):     $(RPI3_64_DIR)"
	@echo "  -> Raspberry Pi 3 Model B+ (32Bit):    $(RPI3_BPLUS_32_DIR)"
	@echo "  -> Raspberry Pi 3 Model B+ (64Bit):    $(RPI3_BPLUS_64_DIR)"
	@echo "Parallel Build Number:                   $(PARALLEL)"
	@echo
	@echo "MD5SUMS"
	@cat MD5SUMS
	@echo
	@echo "SHA1SUMS"
	@cat SHA1SUMS
	@echo
	@echo "SHA256SUMS"
	@cat SHA256SUMS
	@echo
	@echo "SHA512SUMS"
	@cat SHA512SUMS

.PHONY: clean
clean:
	@rm -fr rpi1_uboot.bin rpi2_uboot.bin rpi3_32_uboot.bin rpi3_64_uboot.bin rpi3_bplus_32_uboot.bin rpi3_bplus_64_uboot.bin
	@rm -fr MD5SUMS SHA1SUMS SHA256SUMS SHA512SUMS

.PHONY: distclean
distclean: clean
	@rm -fr "$(BUILD_DIR)"
