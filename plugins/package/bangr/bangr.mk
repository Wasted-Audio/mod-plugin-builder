#####################################
#
# bangr
#
######################################

BANGR_VERSION = ec25efa0a7a090a8f31dccafa02fe6ffc437aeba
BANGR_SITE = $(call github,sjaehn,BAngr,$(BANGR_VERSION))
BANGR_BUNDLES =  BAngr.lv2

CAPS_TARGET_MAKE = $(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)

define BANGR_BUILD_CMDS
	$(CAPS_TARGET_MAKE)
endef

define BANGR_INSTALL_TARGET_CMDS
	$(CAPS_TARGET_MAKE) install DESTDIR=$(TARGET_DIR) PREFIX=/usr
endef

$(eval $(generic-package))
