#include $(T)
BUILD_DIRECTORY := build
X264_BUILD_DIRECTORY := $(BUILD_DIRECTORY)/x264


all :
	echo 'start build $(T)'
	./build_x264.sh $(T)

clean :
	@if [ -f x264_src/config.mak ]; then $(MAKE) -C x264_src clean; fi;
	@if [ -d build ]; then rm -rf build; fi;
	
install :
	
	echo 'start install $(T)'

	mkdir -p ../../../../x264/lib/ohos/$(T);
	cp -av $(X264_BUILD_DIRECTORY)/$(T)/lib/libx264.a ../../../../x264/lib/ohos/$(T);
	
