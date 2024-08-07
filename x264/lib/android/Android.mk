LOCAL_PATH := $(call my-dir)

# libx264.a
include $(CLEAR_VARS)
LOCAL_MODULE := libx264
LOCAL_SRC_FILES := $(TARGET_ARCH_ABI)/libx264.a
include $(PREBUILT_STATIC_LIBRARY)