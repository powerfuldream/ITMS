package org.south.itms.util;

public class VideoInfo {
/*
    private static final String filename = "C:/Users/MrLiao/Desktop/南方/视频/353d92810a9e7179cdeed0ff48b6c9cf.mp4";

    public static void main(String[] args) {
    	
    	File source = new File(filename);
        Encoder encoder = new Encoder();
        try {
            MultimediaInfo m = encoder.getInfo(source);
            long ls = m.getDuration();
            int height = m.getVideo().getSize().getHeight();
            int width = m.getVideo().getSize().getWidth();
            System.out.println("==" + m.getVideo().getSize());
            System.out.println(height + "---" + width);
            System.out.println("此视频时长为:" + ls / 60000 + "分" + ls / 1000 + "秒！");
        } catch (Exception e) {
            e.printStackTrace();
        }
    	
    	for(int i = 0; i < 0; i++) {
    		System.out.println(i);
    		System.out.println(5555);
    	}
    	
    	String str = "广东省江门市";
    	String[] s = str.split("省");
    	String[] s1 = s[1].split("市");
    	System.out.println(s1[0]);
    	
    	long width = 0;
    	long height = 0;

        // first we create a Xuggler container object
        IContainer container = IContainer.make();

        // we attempt to open up the container
        int result = container.open(filename, IContainer.Type.READ, null);

        // check if the operation was successful
        if (result<0)
            throw new RuntimeException("Failed to open media file");

        // query how many streams the call to open found
        int numStreams = container.getNumStreams();

        // query for the total duration
        long duration = container.getDuration();

        // query for the file size
        long fileSize = container.getFileSize();

        // query for the bit rate
        long bitRate = container.getBitRate();

        System.out.println("Number of streams: " + numStreams);
        System.out.println("Duration (ms): " + duration);
        System.out.println("File Size (bytes): " + fileSize);
        System.out.println("Bit Rate: " + bitRate);

        // iterate through the streams to print their meta data
        for (int i=0; i<numStreams; i++) {

            // find the stream object
            IStream stream = container.getStream(i);

            // get the pre-configured decoder that can decode this stream;
            IStreamCoder coder = stream.getStreamCoder();

            System.out.println("*** Start of Stream Info ***");

            System.out.printf("stream %d: ", i);
            System.out.printf("type: %s; ", coder.getCodecType());
            System.out.printf("codec: %s; ", coder.getCodecID());
            System.out.printf("duration: %s; ", stream.getDuration());
            System.out.printf("start time: %s; ", container.getStartTime());
            System.out.printf("timebase: %d/%d; ",
                 stream.getTimeBase().getNumerator(),
                 stream.getTimeBase().getDenominator());
            System.out.printf("coder tb: %d/%d; ",
                 coder.getTimeBase().getNumerator(),
                 coder.getTimeBase().getDenominator());
            System.out.println();

            if (coder.getCodecType() == ICodec.Type.CODEC_TYPE_AUDIO) {
                System.out.printf("sample rate: %d; ", coder.getSampleRate());
                System.out.printf("channels: %d; ", coder.getChannels());
                System.out.printf("format: %s", coder.getSampleFormat());
            } 
            else if (coder.getCodecType() == ICodec.Type.CODEC_TYPE_VIDEO) {
            	width = coder.getWidth();
            	height = coder.getHeight();
                System.out.printf("width: %d; ", coder.getWidth());
                System.out.printf("height: %d; ", coder.getHeight());
                System.out.printf("format: %s; ", coder.getPixelType());
                System.out.printf("frame-rate: %5.2f; ", coder.getFrameRate().getDouble());
            }

            System.out.println();
            System.out.println("*** End of Stream Info ***");

        }
        System.out.println(width + "=" + height);
        System.out.println("" + width + "X" + height);
    }
*/
}