package org.south.itms.entity;

import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity
@Table(name = "sys_log")
public class SysLog implements java.io.Serializable {

	private static final long serialVersionUID = -8807653716819838444L;
	
	private String sysLogId;
	private String terminalId;
	private String terminalName;
	private String logContent;
	private Date recordDate;
	private String locateIp;
	private int deleted;

	
	@Id
	@Column(name = "sys_log_id")
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	public String getSysLogId() {
		return sysLogId;
	}

	public void setSysLogId(String sysLogId) {
		this.sysLogId = sysLogId;
	}

	
	@Column(name = "terminal_id")
	public String getTerminalId() {
		return terminalId;
	}

	public void setTerminalId(String terminalId) {
		this.terminalId = terminalId;
	}

	@Column(name = "terminal_name")
	public String getTerminalName() {
		return terminalName;
	}

	public void setTerminalName(String terminalName) {
		this.terminalName = terminalName;
	}

	@Column(name = "log_content")
	public String getLogContent() {
		return logContent;
	}

	public void setLogContent(String logContent) {
		this.logContent = logContent;
	}

	
	@Column(name = "record_date")
	@Temporal(TemporalType.TIMESTAMP) 
	public Date getRecordDate() {
		return recordDate;
	}

	public void setRecordDate(Date recordDate) {
		this.recordDate = recordDate;
	}

	@Column(name = "locate_ip")
	public String getLocateIp() {
		return locateIp;
	}

	public void setLocateIp(String locateIp) {
		this.locateIp = locateIp;
	}

	@Column(name = "deleted")
	public int getDeleted() {
		return deleted;
	}

	public void setDeleted(int deleted) {
		this.deleted = deleted;
	}

	@Override
	public String toString() {
		return "SysLog [sysLogId=" + sysLogId + ", terminalId=" + terminalId + ", terminalName=" + terminalName
				+ ", logContent=" + logContent + ", recordDate=" + recordDate + ", locateIp=" + locateIp + ", deleted="
				+ deleted + "]";
	}

}
