MKBOOTIMG_BIN := out/host/linux-x86/bin/mkbootimg

$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) \
		$(recovery_ramdisk) \
		$(recovery_kernel)
	@echo ----- Creating ramdisk ------
	#rm -f out/target/product/v1a3g/recovery/root/init
	#cp device/samsung/v1a3g/recovery/init out/target/product/v1a3g/recovery/root/init
	chmod 644 out/target/product/v1a3g/recovery/root/init.rc
	chmod 644 out/target/product/v1a3g/recovery/root/default.prop
	chmod 644 out/target/product/v1a3g/recovery/root/init.recovery.universal5420.rc
	(cd out/target/product/v1a3g/recovery/root/ && find * | sort | cpio -o -H newc) | gzip > $(recovery_ramdisk)
	@echo ----- Making recovery image ------
	$(MKBOOTIMG_BIN) --kernel $(TARGET_PREBUILT_KERNEL) --ramdisk $(recovery_ramdisk) --base $(BOARD_KERNEL_BASE) --pagesize $(BOARD_KERNEL_PAGESIZE) $(BOARD_MKBOOTIMG_ARGS) --output $@
	@echo ----- Made recovery image -------- $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_RECOVERYIMAGE_PARTITION_SIZE),raw)


$(INSTALLED_BOOTIMAGE_TARGET): $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_FILES)
	$(call pretty,"Target boot image: $@")
	$(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_ARGS) --output $@
	#$(hide) $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_ARGS) --output $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_BOOTIMAGE_PARTITION_SIZE),raw)
