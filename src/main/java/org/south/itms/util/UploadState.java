package org.south.itms.util;

import java.text.NumberFormat;

/**
* @author jan  
* @E-mail:ja.janliao@gmail.com
* @version V1.0
* @date 2017年8月6日 下午8:04:10
* 
*/
public class UploadState {

	private long uploadByte;
	private long fileSizeByte;
	private int fileIndex;
	private long startTime;
	private int percent;
	private long speed;
	private long time;
	//private static final SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
	
	public UploadState(){
		super();
		startTime = System.currentTimeMillis();
		speed = 0L;
		percent = 0;
	}
	
	  // 从State状态类中取得状态的字符串，用字符串的形式拼成XML文件内容
	  public synchronized String getStateString() {
	    StringBuilder sb = new StringBuilder("<info>");
	    sb.append("<uploadByte>" + NumberFormat.getInstance().format(uploadByte/(1024*1024))
	 + "</uploadByte>");
	   sb.append("<fileSizeByte>" + NumberFormat.getInstance().format(fileSizeByte/(1024*1024))
	        + "</fileSizeByte>");
	   sb.append("<speed>" + NumberFormat.getInstance().format((speed/(1024*1024))/time)
	  + "</speed>");
	    sb.append("<fileIndex>" + fileIndex + "</fileIndex>");
	    sb.append("<percent>" + percent + "</percent>");
	    //sb.append("<startTime>" + SIMPLEFORMAT.format(startTime) + "</startTime>");
	    sb.append("</info>");
	    return sb.toString();
	  }

	  public synchronized void setState(long uploadByte, long fileSizeByte, int fileIndex) {
	    this.uploadByte = uploadByte;
	    this.fileSizeByte = fileSizeByte;
	    this.fileIndex = fileIndex;
	    this.speed=uploadByte-speed;
	    this.time=(System.currentTimeMillis()-startTime)/1000;
	    if ((Long.valueOf(uploadByte) * 100 / Long.valueOf(fileSizeByte) <= 100)) {
	      // 生成当前上传进度的公式，加入判断条件的含义在于不需要重复计算
	      percent = (int) (Long.valueOf(uploadByte) * 100 / Long.valueOf(fileSizeByte));
	    }
	  }
	
	public long getUploadByte() {
		return uploadByte;
	}
	public void setUploadByte(long uploadByte) {
		this.uploadByte = uploadByte;
	}
	public long getFileSizeByte() {
		return fileSizeByte;
	}
	public void setFileSizeByte(long fileSizeByte) {
		this.fileSizeByte = fileSizeByte;
	}
	public int getFileIndex() {
		return fileIndex;
	}
	public void setFileIndex(int fileIndex) {
		this.fileIndex = fileIndex;
	}
	public long getStartTime() {
		return startTime;
	}
	public void setStartTime(long startTime) {
		this.startTime = startTime;
	}
	public int getPercent() {
		return percent;
	}
	public void setPercent(int percent) {
		this.percent = percent;
	}
	public long getSpeed() {
		return speed;
	}
	public void setSpeed(long speed) {
		this.speed = speed;
	}
	public long getTime() {
		return time;
	}
	public void setTime(long time) {
		this.time = time;
	}

	@Override
	public String toString() {
		return "UploadState [uploadByte=" + uploadByte + ", fileSizeByte=" + fileSizeByte + ", fileIndex=" + fileIndex
				+ ", startTime=" + startTime + ", percent=" + percent + ", speed=" + speed + ", time=" + time + "]";
	}
	
	
}
