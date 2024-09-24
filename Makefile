TARGET := iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

TOOL_NAME = openapp

openapp_FILES = main.m
openapp_CFLAGS = -fobjc-arc
openapp_CODESIGN_FLAGS = -Sentitlements.plist
openapp_INSTALL_PATH = /usr/local/bin

include $(THEOS_MAKE_PATH)/tool.mk
