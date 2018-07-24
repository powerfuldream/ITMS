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
@Table(name = "error_log")
public class ErrorLog implements java.io.Serializable {

	private static final long serialVersionUID = 3558730330273134171L;
	
	private String errorLogId;
	private String terminalId;
	private String terminalName;
	private String materialName;
	private String fileId;
	private String pname;
	private String pid;
	private String errorReason;
	private Date recordDate;
	private int deleted;

	
	@Id
	@Column(name = "error_log_id")
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	public String getErrorLogId() {
		return errorLogId;
	}

	public void setErrorLogId(String errorLogId) {
		this.errorLogId = errorLogId;
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

	@Column(name = "material_name")
	public String getMaterialName() {
		return materialName;
	}

	public void setMaterialName(String materialName) {
		this.materialName = materialName;
	}

	@Column(name = "file_id")
	public String getFileId() {
		return fileId;
	}

	public void setFileId(String fileId) {
		this.fileId = fileId;
	}

	@Column(name = "pname")
	public String getPname() {
		return pname;
	}

	public void setPname(String pname) {
		this.pname = pname;
	}

	@Column(name = "pid")
	public String getPid() {
		return pid;
	}

	public void setPid(String pid) {
		this.pid = pid;
	}

	@Column(name = "error_reason")
	public String getErrorReason() {
		return errorReason;
	}

	public void setErrorReason(String errorReason) {
		this.errorReason = errorReason;
	}
	

	@Column(name = "record_date")
	@Temporal(TemporalType.TIMESTAMP) 
	public Date getRecordDate() {
		return recordDate;
	}

	public void setRecordDate(Date recordDate) {
		this.recordDate = recordDate;
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
		return "ErrorLog [errorLogId=" + errorLogId + ", terminalId=" + terminalId + ", terminalName=" + terminalName
				+ ", materialName=" + materialName + ", fileId=" + fileId + ", pname=" + pname + ", pid=" + pid
				+ ", errorReason=" + errorReason + ", deleted=" + deleted + "]";
	}

}
