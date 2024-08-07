LOCAL_PATH := $(call my-dir)

# libavformat.a
include $(CLEAR_VARS)
LOCAL_MODULE := libavformat
LOCAL_SRC_FILES := $(TARGET_ARCH_ABI)/libavformat.a
include $(PREBUILT_STATIC_LIBRARY)

# libavcodec.a
include $(CLEAR_VARS)
LOCAL_MODULE := libavcodec
LOCAL_SRC_FILES := $(TARGET_ARCH_ABI)/libavcodec.a
include $(PREBUILT_STATIC_LIBRARY)

# libavfilter.a
include $(CLEAR_VARS)
LOCAL_MODULE := libavfilter
LOCAL_SRC_FILES := $(TARGET_ARCH_ABI)/libavfilter.a
include $(PREBUILT_STATIC_LIBRARY)

# libavutil.a
include $(CLEAR_VARS)
LOCAL_MODULE := libavutil
LOCAL_SRC_FILES := $(TARGET_ARCH_ABI)/libavutil.a
include $(PREBUILT_STATIC_LIBRARY)

# libpostproc.a
include $(CLEAR_VARS)
LOCAL_MODULE := libpostproc
LOCAL_SRC_FILES := $(TARGET_ARCH_ABI)/libpostproc.a
include $(PREBUILT_STATIC_LIBRARY)

# libswscale.a
include $(CLEAR_VARS)
LOCAL_MODULE := libswscale
LOCAL_SRC_FILES := $(TARGET_ARCH_ABI)/libswscale.a
include $(PREBUILT_STATIC_LIBRARY)

# libswresample.a
include $(CLEAR_VARS)
LOCAL_MODULE := libswresample
LOCAL_SRC_FILES := $(TARGET_ARCH_ABI)/libswresample.a
include $(PREBUILT_STATIC_LIBRARY)
