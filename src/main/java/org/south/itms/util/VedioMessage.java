package org.south.itms.util;

/**
 * @author jan
 * @date 2017年12月25日 下午4:27:23
 * @version V1.0 
 */
public class VedioMessage {
/*	
	public static void getVedioInfo(String filename){  
		   
	       
        // first we create a Xuggler container object  
        IContainer container = IContainer.make();  

        // we attempt to open up the container  
        int result = container.open(filename, IContainer.Type.READ, null);  

        // check if the operation was successful  
        if (result<0)  
            return ;  
          
        // query how many streams the call to open found  
        int numStreams = container.getNumStreams();  
        // query for the total duration  
        long duration = container.getDuration();  
        // query for the file size  
        long fileSize = container.getFileSize();  
        long secondDuration = duration/1000000;  
          
        System.out.println("时长："+secondDuration+"秒");  
        System.out.println("文件大小:"+fileSize+"M");  
       
    
        for (int i=0; i<numStreams; i++) {
            IStream stream = container.getStream(i);  
            IStreamCoder coder = stream.getStreamCoder();  
            if (coder.getCodecType() == ICodec.Type.CODEC_TYPE_VIDEO) {  
            System.out.println("视频宽度："+coder.getWidth());  
            System.out.println("视频高度："+coder.getHeight());  
            }  
        }  
  
}  

	
	public static void main(String[] args) { 
		String filename = "C:/Users/MrLiao/Desktop/南方/视频/353d92810a9e7179cdeed0ff48b6c9cf.mp4";
		  VedioMessage.getVedioInfo(filename);
	    }  
	*/	
}
