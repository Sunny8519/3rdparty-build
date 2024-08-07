
1.build with android
	Environment:ubuntu+android-ndk-r14b
	
	do follows to build
		cd 3rdparty/ffmpeg/build/android
		./build
	
	build with audio feature
		BUILD_FLAG = 1
	build with video feature
		BUILD_FLAG = 2
	build with video+audio feature
		BUILD_FLAG = 3

    (USER_MP3LAME is in build_ffmpeg.sh)

	we will find the result file in output, include inlucde dir and lib dir
	on android: copy libavcodec.a libavdevice.a libavfilter.a libavformat.a libavutil.a libpostproc.a libswresample.a libswscale.a 
	to core\builders\pcsclient\android\jni\lib_ffmpeg_mp3 or lib_ffmpeg_mp4 to build libprsproxy.a
  
2.build with ios
	Environment:mac+xcode (10.254.31.1/public/software/ios_dev/mac_10.10)

	do follows to build
		cd 3rdparty\ffmpeg\build\ios
		chomd 755 build(only if build can't exec)
		./build [param]
	
	build with mp3 feature
		./build -p all -t lame+ffmpeg+flac
	build with mp4 feature
		./build -p all -t x264+voaac+ffmpeg
	build with mp3+mp4 feature
		./build -p all -t x264+voaac+lame+ffmpeg+flac


	param show as follows:
	Usage:build [-p platform][-t target][-l][-d][-c][-f][-h]
      -p platform=armv6+armv7+i386
      -t target=x264+ffmpeg+voaac+lame+flac
      -l lipo libfiles(-p -t affect)
      -d delete not under svn control source
      -c clean
      -f force to build
      -h show help
