package org.south.itms.util;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.math.BigInteger;
import java.nio.ByteBuffer;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.channels.FileChannel.MapMode;
import java.security.MessageDigest;
import java.text.DecimalFormat;
import java.util.zip.GZIPInputStream;
import java.util.zip.GZIPOutputStream;

import it.sauronsoftware.jave.Encoder;
import it.sauronsoftware.jave.MultimediaInfo;

/**
 * @author: yezilong
 */

public class FileUtil {

	/**
	 * NIO way
	 * 
	 * @param filename
	 * @return
	 * @throws IOException
	 */
	public static byte[] fileToBytes(String filePath) {

		File f = new File(filePath);
		if (!f.exists()) {
			System.out.println("filePath: " + filePath + " file not exist");
			return null;
		}

		FileChannel channel = null;
		FileInputStream fs = null;
		try {
			fs = new FileInputStream(f);
			channel = fs.getChannel();
			ByteBuffer byteBuffer = ByteBuffer.allocate((int) channel.size());
			while ((channel.read(byteBuffer)) > 0) {
				// do nothing
			}
			return byteBuffer.array();
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		} finally {
			if (channel != null) {
				try {
					channel.close();
				} catch (IOException e) {

				}
			}
			if (fs != null) {
				try {
					fs.close();
				} catch (IOException e) {

				}
			}
		}
	}

	/**
	 * Mapped File way MappedByteBuffer 可以在处理大文件时，提升性能
	 * 
	 * @param filename
	 * @return
	 * @throws IOException
	 */
	public static byte[] fileToBytes2(String filePath) {
		/// 验证
		if (filePath == null || filePath.length() <= 0)
			return null;

		File file = new File(filePath);

		if (!file.exists()) {
			System.out.println("filePath: " + filePath + " file not exist");
			return null;
		}

		long fileSize = file.length();
		if (fileSize > Integer.MAX_VALUE) {
			System.out.println("file too big...");
			return null;
		}

		// 开始将文件转成byte数组
		FileChannel fc = null;
		try {
			fc = new RandomAccessFile(filePath, "r").getChannel();
			MappedByteBuffer byteBuffer = fc.map(MapMode.READ_ONLY, 0, fc.size()).load();
			byte[] result = new byte[(int) fc.size()];
			if (byteBuffer.remaining() > 0) {
				byteBuffer.get(result, 0, byteBuffer.remaining());
			}
			return result;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		} finally {
			try {
				fc.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	public static boolean bytesToFile(byte[] bytes, String directoryPath, String fileName) {
		FileOutputStream fos = null;
		try {
			// 判断目录是否存在，不存在就创建
			File directoryFile = new File(directoryPath);
			if (!directoryFile.exists())
				directoryFile.mkdir();

			// 如果要生成的文件，原先没有就新创建一个
			File file = new File(directoryPath + "//" + fileName);
			// if (!file.exists()) file.createNewFile();

			// 开始生成文件
			fos = new FileOutputStream(file, false); // 为false，则上述代码是重新生成文件，会覆盖之前的文件内容。为true，则表示追加到文件中写入。
			FileChannel fc = fos.getChannel();

			ByteBuffer bbf = ByteBuffer.wrap(bytes);
			bbf.put(bytes);
			bbf.flip();
			fc.write(bbf);

			fc.close();
			fos.flush();

			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		} finally {
			if (fos != null) {
				try {
					fos.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}

	}

	/***
	 * 压缩GZip
	 * 
	 * @param data
	 * @return
	 */
	public static byte[] gZip(byte[] data) {
		byte[] b = null;
		try {
			ByteArrayOutputStream bos = new ByteArrayOutputStream();
			GZIPOutputStream gzip = new GZIPOutputStream(bos);
			gzip.write(data);
			gzip.finish();
			gzip.close();
			b = bos.toByteArray();
			bos.close();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return b;
	}

	/***
	 * 解压GZip
	 * 
	 * @param data
	 * @return
	 */
	public static byte[] unGZip(byte[] data) {
		byte[] b = null;
		try {
			ByteArrayInputStream bis = new ByteArrayInputStream(data);
			GZIPInputStream gzip = new GZIPInputStream(bis);
			byte[] buf = new byte[1024];
			int num = -1;
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			while ((num = gzip.read(buf, 0, buf.length)) != -1) {
				baos.write(buf, 0, num);
			}
			b = baos.toByteArray();
			baos.flush();
			baos.close();
			gzip.close();
			bis.close();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return b;
	}
	
	public static void fileCopy(String src, String dec) throws IOException {
	    FileChannel inChannel = null;
	    FileChannel outChannel = null;
	    FileInputStream inStream = null;
	    FileOutputStream outStream = null;
	    try {
	        inStream = new FileInputStream(src);
	        outStream = new FileOutputStream(dec);
	        inChannel = inStream.getChannel();
	        outChannel = outStream.getChannel();
	        inChannel.transferTo(0, inChannel.size(), outChannel);
	    } catch (IOException e) {
	        e.printStackTrace();
	    } finally {
	    	inStream.close();
	    	inChannel.close();
	    	outStream.close();
	    	outChannel.close(); 
	    }
	}
	
	public static int getDurTime(String path) {
		int  time = 1;
        try {
        	File file = new File(path);
        	Encoder encoder = new Encoder();
            MultimediaInfo m = encoder.getInfo(file);
            long ls = m.getDuration();
            System.out.println("ls=" + ls);
            System.out.println("此视频时长为:" + ls / 60000 + "分" + ls / 1000 + "秒！");
            time = (int)ls/1000;
        }catch (Exception e) {
	            e.printStackTrace();
	        }
        return time;
        }
	
	public static BigInteger getMD5(String path) {
		BigInteger bigIntMD5 = null;
		try {
            File file = new File(path);
            FileInputStream fis = new FileInputStream(file);
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] buffer = new byte[1024];
            int length = -1;
            while ((length = fis.read(buffer, 0, 1024)) != -1) {
                md.update(buffer, 0, length);
            }
            bigIntMD5 = new BigInteger(1, md.digest());
            System.out.println("文件md5值：" + bigIntMD5.toString(16));
            fis.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return bigIntMD5;
	}
	
	public static String getResolution(String path) {
		int width = 0;
		int height = 0;
		File source = new File(path);
        Encoder encoder = new Encoder();
        try {
            MultimediaInfo m = encoder.getInfo(source);
            //long ls = m.getDuration();
            height = m.getVideo().getSize().getHeight();
            width = m.getVideo().getSize().getWidth();
            System.out.println("==" + m.getVideo().getSize());
            System.out.println(height + "---" + width);
            //System.out.println("此视频时长为:" + ls / 60000 + "分" + ls / 1000 + "秒！");
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return "" + width + "X" + height;
	}
	
	public static String getSize(String path) {
		String size = "0Mb";
		File source = new File(path);
        long fileSize = source.length();
        if(fileSize != 0) {
        	double d = (double)fileSize/1024/1024;
            DecimalFormat df = new DecimalFormat("#,###.00");
            //System.out.println(df.format(d));
            //System.out.println(fileSize);
            size = df.format(d) + "Mb";
            System.out.println(size);
        }
		return size;
	}
	

//	public static String getResolution(String path) {
//    	long width = 0;
//    	long height = 0;
//
//        // first we create a Xuggler container object
//        IContainer container = IContainer.make();
//
//        // we attempt to open up the container
//        int result = container.open(path, IContainer.Type.READ, null);
//
//        // check if the operation was successful
//        if (result<0)
//            throw new RuntimeException("Failed to open media file");
//
//        // query how many streams the call to open found
//        int numStreams = container.getNumStreams();
//
//        // query for the total duration
//        long duration = container.getDuration();
//
//        // query for the file size
//        //long fileSize = container.getFileSize();
//
//        // query for the bit rate
//        //long bitRate = container.getBitRate();
//
//        System.out.println("Number of streams: " + numStreams);
//        System.out.println("Duration (ms): " + duration);
//        IStream stream = container.getStream(0);
//        IStreamCoder coder = stream.getStreamCoder();
//        width = coder.getWidth();
//    	height = coder.getHeight();
//        //System.out.println("File Size (bytes): " + fileSize);
//        //System.out.println("Bit Rate: " + bitRate);
//
//        // iterate through the streams to print their meta data
////        for (int i=0; i<numStreams; i++) {
////
////            // find the stream object
////            IStream stream = container.getStream(i);
////
////            // get the pre-configured decoder that can decode this stream;
////            IStreamCoder coder = stream.getStreamCoder();
////
////            //System.out.println("*** Start of Stream Info ***");
////
////            //System.out.printf("stream %d: ", i);
////            //System.out.printf("type: %s; ", coder.getCodecType());
////            //System.out.printf("codec: %s; ", coder.getCodecID());
////            //System.out.printf("duration: %s; ", stream.getDuration());
////            //System.out.printf("start time: %s; ", container.getStartTime());
////            //System.out.printf("timebase: %d/%d; ",
////                 //stream.getTimeBase().getNumerator(),
////                 //stream.getTimeBase().getDenominator());
////            //System.out.printf("coder tb: %d/%d; ",
////                 //coder.getTimeBase().getNumerator(),
////                 //coder.getTimeBase().getDenominator());
////            //System.out.println();
////
////            if (coder.getCodecType() == ICodec.Type.CODEC_TYPE_AUDIO) {
////                System.out.printf("sample rate: %d; ", coder.getSampleRate());
////                System.out.printf("channels: %d; ", coder.getChannels());
////                System.out.printf("format: %s", coder.getSampleFormat());
////            } 
////            else if (coder.getCodecType() == ICodec.Type.CODEC_TYPE_VIDEO) {
////            	width = coder.getWidth();
////            	height = coder.getHeight();
////                System.out.printf("width: %d; ", coder.getWidth());
////                System.out.printf("height: %d; ", coder.getHeight());
////                //System.out.printf("format: %s; ", coder.getPixelType());
////                //System.out.printf("frame-rate: %5.2f; ", coder.getFrameRate().getDouble());
////            }
//
//            //System.out.println();
//            //System.out.println("*** End of Stream Info ***");
//
////        }
//        return "" + width + "X" + height;
//	}

	public static void main(String[] args) {
		long start=System.currentTimeMillis();   //获取开始时间  
		FileUtil.getSize("D:/迅雷下载/7号房的礼物_bd.mp4");  //测试的代码段  
		long end=System.currentTimeMillis(); //获取结束时间  
		System.out.println("程序运行时间： "+(end-start)+"ms");
		
		long start1=System.currentTimeMillis();   //获取开始时间  
		//String s = FileUtil.getResolution("C:/Users/MrLiao/Desktop/南方/视频/1024 (5).mp4"); //测试的代码段  
		long end1=System.currentTimeMillis(); //获取结束时间  
		System.out.println("程序运行时间： "+(end1-start1)+"ms");
	}
}
