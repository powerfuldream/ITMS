package org.south.netty.msg;

import java.io.Serializable;
import java.util.Date;

public class SysLogMsg implements Serializable {

	private static final long serialVersionUID = 3490100493684807411L;

	private String logContent;
	private String recordDate;

	public String getLogContent() {
		return logContent;
	}

	public void setLogContent(String logContent) {
		this.logContent = logContent;
	}

	public String getRecordDate() {
		return recordDate;
	}

	public void setRecordDate(String recordDate) {
		this.recordDate = recordDate;
	}

	@Override
	public String toString() {
		return "SysLogMsg [logContent=" + logContent + ", recordDate=" + recordDate + "]";
	}

}
