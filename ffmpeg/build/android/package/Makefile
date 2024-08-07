#include $(T)
BUILD_DIRECTORY := build
FFMPEG_BUILD_DIRECTORY := $(BUILD_DIRECTORY)/ffmpeg
X264_BUILD_DIRECTORY := $(BUILD_DIRECTORY)/x264


all :
	echo 'start build $(T)'
	./build_x264.sh $(T)
	./build_ffmpeg.sh $(T)

clean :
	@if [ -f ffmpeg_src/config.mak ]; then $(MAKE) -C ffmpeg_src clean; fi;
	@if [ -f x264_src/config.mak ]; then $(MAKE) -C x264_src clean; fi;
	@if [ -d build ]; then rm -rf build; fi;
	
install :
	
	echo 'start install $(T)'

	cp -avrp $(FFMPEG_BUILD_DIRECTORY)/$(T)/include ../../../

	mkdir -p ../../../lib/android/with-mp4/$(T);
	cp -av $(FFMPEG_BUILD_DIRECTORY)/$(T)/lib/lib*.a ../../../lib/android/with-mp4/$(T);
	mkdir -p ../../../../x264/lib/android/$(T);
	cp -av $(X264_BUILD_DIRECTORY)/$(T)/lib/libx264.a ../../../../x264/lib/android/$(T);
	
