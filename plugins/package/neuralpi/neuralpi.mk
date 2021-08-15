######################################
#
# neuralpi
#
######################################

NEURALPI_VERSION = 114f86d6d69bf84c05d9971a59854580a5f97fab
NEURALPI_SITE = $(call github,GuitarML,NeuralPi,$(NEURALPI_VERSION))
# TODO make some libs optional
NEURALPI_DEPENDENCIES = freetype jack2mod xlib_libXcursor xlib_libXinerama xlib_libXrandr host-cmake
NEURALPI_BUNDLES = NeuralPi.lv2

# call make with the current arguments and path. "$(@D)" is the build directory.
NEURALPI_TARGET_MAKE = $(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)

# needed for git submodules
define NEURALPI_EXTRACT_CMDS
	rm -rf $(@D)
	git clone --recursive git://github.com/GuitarML/NeuralPi $(@D)
	(cd $(@D) && \
		git reset --hard $(NEURALPI_VERSION) && \
		git submodule update)
	touch $(@D)/.stamp_downloaded
endef

define NEURALPI_CONFIGURE_CMDS
	(cd $(@D) && \
		rm -f CMakeCache.txt && \
		"$(HOST_DIR)/usr/bin/cmake" . \
			-DCMAKE_C_COMPILER=$(TARGET_CC) \
			-DCMAKE_CXX_COMPILER=$(TARGET_CXX) \
			-DCMAKE_INSTALL_PREFIX="/usr" \
			-DCMAKE_BUILD_TYPE=Release)
endef

define NEURALPI_BUILD_CMDS
	$(NEURALPI_TARGET_MAKE)
endef

define NEURALPI_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib/lv2/NeuralPi.lv2
#	cp -rL $($(PKG)_PKGDIR)/NeuralPi.lv2/* $(TARGET_DIR)/usr/lib/lv2/NeuralPi.lv2/
	cp -rL $(@D)/NeuralPi_artefacts/Release/LV2/NeuralPi.lv2/* $(TARGET_DIR)/usr/lib/lv2/NeuralPi.lv2/
endef

$(eval $(generic-package))
