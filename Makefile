export TARGET		?= iphone:clang:16.5:14.0
export ARCHS		?= arm64 arm64e
export THEOS_PACKAGE_SCHEME ?= rootless

CCACHE := $(shell command -v ccache 2>/dev/null)
ifeq ($(shell uname -s),Darwin)
export TARGET_CC	:= $(CCACHE) $(shell xcrun -f clang)
export TARGET_CXX	:= $(CCACHE) $(shell xcrun -f clang++)
endif

INSTALL_TARGET_PROCESSES = SpringBoard
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = liquidass27

# 只编译弹窗模块，其他 Hooks / Tweak.x / 子工程全部不参与编译
liquidass27_FILES	= Hooks/Alerts.x \
					  $(wildcard Shared/*.[xm])
liquidass27_CFLAGS	= -fobjc-arc
liquidass27_USE_MODULES = 0
liquidass27_FRAMEWORKS = UIKit QuartzCore CoreText CoreGraphics CoreMotion
ifeq ($(THEOS_PACKAGE_SCHEME),roothide)
liquidass27_LIBRARIES += roothide
endif

include $(THEOS)/makefiles/tweak.mk
