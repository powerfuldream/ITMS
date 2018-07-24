package org.south.netty.msg;

import java.io.Serializable;
import java.util.List;

/**
 * @author jan
 * @date 2017年12月24日 下午9:38:29
 * @version V1.0 
 */
public class InsertDto implements Serializable {

	/** 
	 * @since JDK 1.6 
	 */ 
	private static final long serialVersionUID = -8376726820653798888L;

	private String start;
	
	private String end;
	
	private String min;//间隔时间
	
	private String status; //瞬时or延时
	
	private List<String> mid; //素材编号
	
	private List<String> fileName;
	
	private List<String> logicName;
	
	private List<String> md5;
	 
	
	private String duration;

	public String getStart() {
		return start;
	}

	public void setStart(String start) {
		this.start = start;
	}

	public String getEnd() {
		return end;
	}

	public void setEnd(String end) {
		this.end = end;
	}

	public String getMin() {
		return min;
	}

	public void setMin(String min) {
		this.min = min;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}


	public List<String> getMid() {
		return mid;
	}

	public void setMid(List<String> mid) {
		this.mid = mid;
	}

	public List<String> getFileName() {
		return fileName;
	}

	public void setFileName(List<String> fileName) {
		this.fileName = fileName;
	}


	public String getDuration() {
		return duration;
	}

	public void setDuration(String duration) {
		this.duration = duration;
	}

	
	
	public List<String> getLogicName() {
		return logicName;
	}

	public void setLogicName(List<String> logicName) {
		this.logicName = logicName;
	}

	public List<String> getMd5() {
		return md5;
	}

	public void setMd5(List<String> md5) {
		this.md5 = md5;
	}
	

	public InsertDto(String start, String end, String min, String status, List<String> mid, List<String> fileName,
			List<String> logicName, List<String> md5, String duration) {
		super();
		this.start = start;
		this.end = end;
		this.min = min;
		this.status = status;
		this.mid = mid;
		this.fileName = fileName;
		this.logicName = logicName;
		this.md5 = md5;
		this.duration = duration;
	}

	public InsertDto() {
		super();
	}

	@Override
	public String toString() {
		return "InsertDto [start=" + start + ", end=" + end + ", min=" + min + ", status=" + status + ", mid=" + mid
				+ ", fileName=" + fileName + ", logicName=" + logicName + ", md5=" + md5 + ", duration=" + duration
				+ "]";
	}

}
