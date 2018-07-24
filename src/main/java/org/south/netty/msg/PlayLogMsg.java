package org.south.netty.msg;

import java.util.Date;

public class PlayLogMsg implements java.io.Serializable {

	private static final long serialVersionUID = -7454851893628809398L;
	
	private String playStartTime;
	private String playEndTime;
	private String materialName;
	private String fileId;
    private String pid;
    private String pname;
	

	public String getPlayStartTime() {
		return playStartTime;
	}

	public void setPlayStartTime(String playStartTime) {
		this.playStartTime = playStartTime;
	}

	public String getPlayEndTime() {
		return playEndTime;
	}

	public void setPlayEndTime(String playEndTime) {
		this.playEndTime = playEndTime;
	}

	public String getMaterialName() {
		return materialName;
	}

	public void setMaterialName(String materialName) {
		this.materialName = materialName;
	}

	public String getFileId() {
		return fileId;
	}

	public void setFileId(String fileId) {
		this.fileId = fileId;
	}
	
	public String getPid() {
		return pid;
	}

	public void setPid(String pid) {
		this.pid = pid;
	}

	public String getPname() {
		return pname;
	}

	public void setPname(String pname) {
		this.pname = pname;
	}

	@Override
	public String toString() {
		return "PlayLogMsg [playStartTime=" + playStartTime + ", playEndTime=" + playEndTime + ", materialName="
				+ materialName + ", fileId=" + fileId + ", pid=" + pid + ", pname=" + pname + "]";
	}

}
