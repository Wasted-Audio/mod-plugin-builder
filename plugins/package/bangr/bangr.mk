#####################################
#
# bangr
#
######################################

BANGR_VERSION = dfd53a32475a7c0cb5d4ed2ba612cecd10e705fd
BANGR_SITE = $(call github,sjaehn,BAngr,$(BANGR_VERSION))
BANGR_DEPENDENCIES = cairo
BANGR_BUNDLES =  BAngr.lv2

CAPS_TARGET_MAKE = $(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)

define BANGR_BUILD_CMDS
	$(CAPS_TARGET_MAKE)
endef

define BANGR_INSTALL_TARGET_CMDS
	$(CAPS_TARGET_MAKE) install DESTDIR=$(TARGET_DIR) PREFIX=/usr
endef

$(eval $(generic-package))
