# TODO: CONFIG_BOOTCOMMAND

ARM32_CROSS_GCC   := "arm-linux-gnueabihf-"
ARM64_CROSS_GCC   := "aarch64-linux-gnu-"

U_BOOT_DIR        := $(abspath $(CURDIR)/u-boot)

RPI1_DIR          := $(abspath $(CURDIR)/rpi1)
RPI2_DIR          := $(abspath $(CURDIR)/rpi2)
RPI3_32_DIR       := $(abspath $(CURDIR)/rpi3_32)
RPI3_64_DIR       := $(abspath $(CURDIR)/rpi3_64)
RPI3_BPLUS_32_DIR := $(abspath $(CURDIR)/rpi3_bplus_32)
RPI3_BPLUS_64_DIR := $(abspath $(CURDIR)/rpi3_bplus_64)

PARALLEL          := $(shell expr $(shell nproc) + 2)

.PHONY: default
default: build checksum

.PHONY: build
build: rpi1_uboot.bin rpi2_uboot.bin rpi3_32_uboot.bin rpi3_64_uboot.bin rpi3_bplus_32_uboot.bin rpi3_bplus_64_uboot.bin

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

$(RPI3_BPLUS_32_DIR)/u-boot:
	@cp "$(U_BOOT_DIR)/configs/rpi_3_b_plus_defconfig" "$(U_BOOT_DIR)/configs/rpi_3_b_plus_32b_defconfig"
	@sed -i -e 's@CONFIG_TARGET_RPI_3=y@CONFIG_TARGET_RPI_3_32B=y@' "$(U_BOOT_DIR)/configs/rpi_3_b_plus_32b_defconfig"
	@sed -i -e 's@CONFIG_SYS_TEXT_BASE=0x00080000@CONFIG_SYS_TEXT_BASE=0x00008000@' "$(U_BOOT_DIR)/configs/rpi_3_b_plus_32b_defconfig"
	@$(MAKE) -C "$(U_BOOT_DIR)" -j "$(PARALLEL)" "O=$(RPI3_BPLUS_32_DIR)" "CROSS_COMPILE=$(ARM32_CROSS_GCC)" rpi_3_b_plus_32b_defconfig
	@$(MAKE) -C "$(U_BOOT_DIR)" -j "$(PARALLEL)" "O=$(RPI3_BPLUS_32_DIR)" "CROSS_COMPILE=$(ARM32_CROSS_GCC)" all

$(RPI3_BPLUS_64_DIR)/u-boot:
	@$(MAKE) -C "$(U_BOOT_DIR)" -j "$(PARALLEL)" "O=$(RPI3_BPLUS_64_DIR)" "CROSS_COMPILE=$(ARM64_CROSS_GCC)" rpi_3_b_plus_defconfig
	@$(MAKE) -C "$(U_BOOT_DIR)" -j "$(PARALLEL)" "O=$(RPI3_BPLUS_64_DIR)" "CROSS_COMPILE=$(ARM64_CROSS_GCC)" all

rpi1_uboot.bin: $(RPI1_DIR)/u-boot
	@cp "$(RPI1_DIR)/u-boot" "rpi1_uboot.bin"

rpi2_uboot.bin: $(RPI2_DIR)/u-boot
	@cp "$(RPI2_DIR)/u-boot" "rpi2_uboot.bin"

rpi3_32_uboot.bin: $(RPI3_32_DIR)/u-boot
	@cp "$(RPI3_32_DIR)/u-boot" "rpi3_32_uboot.bin"

rpi3_64_uboot.bin: $(RPI3_64_DIR)/u-boot
	@cp "$(RPI3_64_DIR)/u-boot" "rpi3_64_uboot.bin"

rpi3_bplus_32_uboot.bin: $(RPI3_BPLUS_32_DIR)/u-boot
	@cp "$(RPI3_BPLUS_32_DIR)/u-boot" "rpi3_bplus_32_uboot.bin"

rpi3_bplus_64_uboot.bin: $(RPI3_BPLUS_64_DIR)/u-boot
	@cp "$(RPI3_BPLUS_64_DIR)/u-boot" "rpi3_bplus_64_uboot.bin"

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
	@echo "U-Boot Directory:                                $(U_BOOT_DIR)"
	@echo "Raspberry Pi 1 Model B Build Directory:          $(RPI1_DIR)"
	@echo "Raspberry Pi 2 Model B Build Directory:          $(RPI2_DIR)"
	@echo "Raspberry Pi 3 Model B (32Bit) Build Directory:  $(RPI3_32_DIR)"
	@echo "Raspberry Pi 3 Model B (64Bit) Build Directory:  $(RPI3_64_DIR)"
	@echo "Raspberry Pi 3 Model B+ (32Bit) Build Directory: $(RPI3_BPLUS_32_DIR)"
	@echo "Raspberry Pi 3 Model B+ (64Bit) Build Directory: $(RPI3_BPLUS_64_DIR)"
	@echo "Parallel Build Number:                           $(PARALLEL)"
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
	@rm -fr "$(RPI1_DIR)" "$(RPI2_DIR)" "$(RPI3_32_DIR)" "$(RPI3_64_DIR)" "$(RPI3_BPLUS_32_DIR)" "$(RPI3_BPLUS_64_DIR)"
