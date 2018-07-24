package org.south.netty.msg;

import java.io.Serializable;

public class InsertVedioDto implements Serializable{   //为插播临时保存的视频信息
	
	private static final long serialVersionUID = -1920077155661215155L;

	private String mid;
	
	private String logicName;  //素材的逻辑名
	
	private String md5;


	public InsertVedioDto() {

	}
	

	public InsertVedioDto(String mid, String logicName, String md5) {
		super();
		this.mid = mid;
		this.logicName = logicName;
		this.md5 = md5;
	}

	public String getMid() {
		return mid;
	}

	public void setMid(String mid) {
		this.mid = mid;
	}

	public String getLogicName() {
		return logicName;
	}

	public void setLogicName(String logicName) {
		this.logicName = logicName;
	}

	public String getMd5() {
		return md5;
	}

	public void setMd5(String md5) {
		this.md5 = md5;
	}

	@Override
	public String toString() {
		return "InsertVedioDto [mid=" + mid + ", logicName=" + logicName + ", md5=" + md5 + "]";
	}

}
