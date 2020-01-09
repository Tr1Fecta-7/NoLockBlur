FINALPACKAGE=1
include $(THEOS)/makefiles/common.mk

ARCHS = arm64 arm64e

TWEAK_NAME = NoLockBlur

NoLockBlur_FILES = Tweak.xm
NoLockBlur_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "sbreload"
