ROOTLESS = 1
ifeq ($(ROOTLESS),1)
 THEOS_PACKAGE_SCHEME=rootless
endif
ifeq ($(THEOS_PACKAGE_SCHEME), rootless)
 TARGET = iphone:clang:latest:15.0
else
 TARGET = iphone:clang:latest:12.0
endif

include $(THEOS)/makefiles/common.mk

TOOL_NAME = openapp

openapp_FILES = main.m
openapp_CFLAGS = -fobjc-arc
openapp_CODESIGN_FLAGS = -Sentitlements.plist
openapp_INSTALL_PATH = /usr/local/bin

include $(THEOS_MAKE_PATH)/tool.mk
