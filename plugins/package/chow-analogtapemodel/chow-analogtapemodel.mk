######################################
#
# chow-analogtapemodel
#
######################################

CHOW_ANALOGTAPEMODEL_VERSION = 139ab8b5c2030d432ec258887f852a274582a862
CHOW_ANALOGTAPEMODEL_SITE = $(call github,jatinchowdhury18,AnalogTapeModel,$(CHOW_ANALOGTAPEMODEL_VERSION))
# TODO make some libs optional
CHOW_ANALOGTAPEMODEL_DEPENDENCIES = freetype xlib_libXcursor xlib_libXinerama xlib_libXrandr host-cmake
CHOW_ANALOGTAPEMODEL_BUNDLES = CHOWTapeModel.lv2

# call make with the current arguments and path. "$(@D)" is the build directory.
CHOW_ANALOGTAPEMODEL_TARGET_MAKE = $(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/Plugin

# needed for git submodules
define CHOW_ANALOGTAPEMODEL_EXTRACT_CMDS
	rm -rf $(@D)
	git clone --recursive git://github.com/jatinchowdhury18/AnalogTapeModel $(@D)
	(cd $(@D) && \
		git reset --hard $(CHOW_ANALOGTAPEMODEL_VERSION) && \
		git submodule update)
	touch $(@D)/.stamp_downloaded
endef

define CHOW_ANALOGTAPEMODEL_CONFIGURE_CMDS
	(cd $(@D)/Plugin && \
		rm -f CMakeCache.txt && \
		"$(HOST_DIR)/usr/bin/cmake" . \
			-DCMAKE_C_COMPILER=$(TARGET_CC) \
			-DCMAKE_CXX_COMPILER=$(TARGET_CXX) \
			-DCMAKE_INSTALL_PREFIX="/usr" \
			-DCMAKE_BUILD_TYPE=Release \
			-DRTNEURAL_EIGEN=ON)
endef

define CHOW_ANALOGTAPEMODEL_BUILD_CMDS
	$(CHOW_ANALOGTAPEMODEL_TARGET_MAKE) -k
endef

define CHOW_ANALOGTAPEMODEL_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib/lv2/CHOWTapeModel.lv2
	cp -rL $($(PKG)_PKGDIR)/CHOWTapeModel.lv2/* $(TARGET_DIR)/usr/lib/lv2/CHOWTapeModel.lv2/
	cp -rL $(@D)/Plugin/CHOWTapeModel_artefacts/Release/LV2/CHOWTapeModel.lv2/* $(TARGET_DIR)/usr/lib/lv2/CHOWTapeModel.lv2/
endef

$(eval $(generic-package))
