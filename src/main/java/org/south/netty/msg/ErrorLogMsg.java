package org.south.netty.msg;

import java.util.Date;

public class ErrorLogMsg implements java.io.Serializable {

	private static final long serialVersionUID = -7916664638611335270L;

	private String materialName;
	private String fileId;
	private String errorReason;
	private String recordDate;
	private String pid;
	private String pname;
	
	
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

	public String getErrorReason() {
		return errorReason;
	}

	public void setErrorReason(String errorReason) {
		this.errorReason = errorReason;
	}

	public String getRecordDate() {
		return recordDate;
	}

	public void setRecordDate(String recordDate) {
		this.recordDate = recordDate;
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
		return "ErrorLogMsg [materialName=" + materialName + ", fileId=" + fileId + ", errorReason=" + errorReason
				+ ", recordDate=" + recordDate + ", pid=" + pid + ", pname=" + pname + "]";
	}



}
