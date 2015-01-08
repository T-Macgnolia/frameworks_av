LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES:= \
    AudioParameter.cpp
LOCAL_MODULE:= libmedia_helper
LOCAL_MODULE_TAGS := optional

include $(BUILD_STATIC_LIBRARY)

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
include $(CLEAR_VARS)

LOCAL_SRC_FILES:= AudioParameter.cpp
LOCAL_MODULE:= libaudioparameter
LOCAL_MODULE_TAGS := optional
LOCAL_SHARED_LIBRARIES := libutils libcutils

include $(BUILD_SHARED_LIBRARY)
endif

include $(CLEAR_VARS)

LOCAL_SRC_FILES:= \
    AudioTrack.cpp \
    AudioTrackShared.cpp \
    IAudioFlinger.cpp \
    IAudioFlingerClient.cpp \
    IAudioTrack.cpp \
    IAudioRecord.cpp \
    ICrypto.cpp \
    IDrm.cpp \
    IDrmClient.cpp \
    IHDCP.cpp \
    AudioRecord.cpp \
    AudioSystem.cpp \
    mediaplayer.cpp \
    IMediaCodecList.cpp \
    IMediaHTTPConnection.cpp \
    IMediaHTTPService.cpp \
    IMediaLogService.cpp \
    IMediaPlayerService.cpp \
    IMediaPlayerClient.cpp \
    IMediaRecorderClient.cpp \
    IMediaPlayer.cpp \
    IMediaRecorder.cpp \
    IRemoteDisplay.cpp \
    IRemoteDisplayClient.cpp \
    IStreamSource.cpp \
    MediaCodecInfo.cpp \
    Metadata.cpp \
    mediarecorder.cpp \
    IMediaMetadataRetriever.cpp \
    mediametadataretriever.cpp \
    MidiIoWrapper.cpp \
    ToneGenerator.cpp \
    JetPlayer.cpp \
    IOMX.cpp \
    IAudioPolicyService.cpp \
    IAudioPolicyServiceClient.cpp \
    MediaScanner.cpp \
    MediaScannerClient.cpp \
    CharacterEncodingDetector.cpp \
    IMediaDeathNotifier.cpp \
    MediaProfiles.cpp \
    IEffect.cpp \
    IEffectClient.cpp \
    AudioEffect.cpp \
    Visualizer.cpp \
    MemoryLeakTrackUtil.cpp \
    SoundPool.cpp \
    SoundPoolThread.cpp \
    StringArray.cpp \
    AudioPolicy.cpp

LOCAL_SRC_FILES += ../libnbaio/roundup.c

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
ifneq ($(filter msm7x30 msm8660 msm8960,$(TARGET_BOARD_PLATFORM)),)
ifeq ($(BOARD_USES_LEGACY_ALSA_AUDIO),true)
LOCAL_SRC_FILES += \
    IDirectTrack.cpp \
    IDirectTrackClient.cpp
endif
endif
endif

#QTI Resampler
ifeq ($(call is-vendor-board-platform,QCOM),true)
ifeq ($(strip $(AUDIO_FEATURE_ENABLED_EXTN_RESAMPLER)),true)
LOCAL_CFLAGS += -DQTI_RESAMPLER
endif
endif
#QTI Resampler

ifeq ($(TARGET_ENABLE_QC_AV_ENHANCEMENTS),true)
    LOCAL_CFLAGS += -DENABLE_AV_ENHANCEMENTS
    LOCAL_C_INCLUDES += $(TOP)/frameworks/av/include/media
    LOCAL_C_INCLUDES += $(TOP)/$(call project-path-for,qcom-media)/mm-core/inc
endif

# for <cutils/atomic-inline.h>
ifeq ($(TARGET_CPU_SMP),true)
  LOCAL_CFLAGS += -DANDROID_SMP=1
else
  ifeq ($(TARGET_CPU_SMP),false)
    LOCAL_CFLAGS += -DANDROID_SMP=0
  else
    $(warning TARGET_CPU_SMP should be (true|false), found $(TARGET_CPU_SMP))
    # Make sure we emit barriers for the worst case.
    LOCAL_CFLAGS += -DANDROID_SMP=1
  endif
endif

LOCAL_SRC_FILES += SingleStateQueue.cpp
LOCAL_CFLAGS += -DSINGLE_STATE_QUEUE_INSTANTIATIONS='"SingleStateQueueInstantiations.cpp"'
# Consider a separate a library for SingleStateQueueInstantiations.

LOCAL_SHARED_LIBRARIES := \
	libui liblog libcutils libutils libbinder libsonivox libicuuc libicui18n libexpat \
        libcamera_client libstagefright_foundation \
        libgui libdl libaudioutils libnbaio

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
LOCAL_SHARED_LIBRARIES += \
        libaudioparameter
endif

LOCAL_STATIC_LIBRARIES += libinstantssq

LOCAL_WHOLE_STATIC_LIBRARIES := libmedia_helper

LOCAL_MODULE:= libmedia

LOCAL_ADDITIONAL_DEPENDENCIES := $(LOCAL_PATH)/Android.mk

LOCAL_C_INCLUDES := \
    $(TOP)/frameworks/native/include/media/openmax \
    $(TOP)/frameworks/av/include/media/ \
    $(TOP)/frameworks/av/media/libstagefright \
    $(call include-path-for, audio-effects) \
    $(call include-path-for, audio-utils)

include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)

LOCAL_SRC_FILES += SingleStateQueue.cpp
LOCAL_CFLAGS += -DSINGLE_STATE_QUEUE_INSTANTIATIONS='"SingleStateQueueInstantiations.cpp"'

LOCAL_MODULE := libinstantssq
LOCAL_MODULE_TAGS := optional

include $(BUILD_STATIC_LIBRARY)
