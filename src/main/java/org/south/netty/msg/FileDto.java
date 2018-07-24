package org.south.netty.msg;

import java.io.Serializable;

/**
 * @author: yezilong
 */

public class FileDto implements Serializable {

	private static final long serialVersionUID = -3791501173482809115L;
	private String fileId;
	private String fileName;
	private String logicName;
	private String md5;


	public FileDto(String fileId, String fileName) {
		super();
		this.fileId = fileId;
		this.fileName = fileName;
	}

	public FileDto(String fileId, String fileName, String logicName, String md5) {
		super();
		this.fileId = fileId;
		this.fileName = fileName;
		this.logicName = logicName;
		this.md5 = md5;
	}

	public String getFileId() {
		return fileId;
	}

	public void setFileId(String fileId) {
		this.fileId = fileId;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
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
		return "FileDto [fileId=" + fileId + ", fileName=" + fileName + ", logicName=" + logicName + ", md5=" + md5
				+ "]";
	}

}
