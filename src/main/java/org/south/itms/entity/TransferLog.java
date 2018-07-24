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
@Table(name = "transfer_log")
public class TransferLog implements java.io.Serializable {

	private static final long serialVersionUID = -5448805097266982346L;
	
	private String transferLogId;
	private String terminalId;
	private String terminalName;
	private Date transferStartTime;
	private Date transferEndTime;
	private String transferFileName;
	private String transferFileId;
	private String finished;
	private String note;
	private String pname;
	private int deleted;

	@Id
	@Column(name = "transfer_log_id")
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	public String getTransferLogId() {
		return transferLogId;
	}

	public void setTransferLogId(String transferLogId) {
		this.transferLogId = transferLogId;
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

	@Column(name = "transfer_start_time")
	@Temporal(TemporalType.TIMESTAMP) 
	public Date getTransferStartTime() {
		return transferStartTime;
	}

	public void setTransferStartTime(Date transferStartTime) {
		this.transferStartTime = transferStartTime;
	}

	@Column(name = "transfer_end_time")
	@Temporal(TemporalType.TIMESTAMP) 
	public Date getTransferEndTime() {
		return transferEndTime;
	}

	public void setTransferEndTime(Date transferEndTime) {
		this.transferEndTime = transferEndTime;
	}

	
	@Column(name = "transfer_file_name")
	public String getTransferFileName() {
		return transferFileName;
	}

	public void setTransferFileName(String transferFileName) {
		this.transferFileName = transferFileName;
	}

	@Column(name = "transfer_file_id")
	public String getTransferFileId() {
		return transferFileId;
	}

	public void setTransferFileId(String transferFileId) {
		this.transferFileId = transferFileId;
	}

	
	@Column(name = "finished")
	public String getFinished() {
		return finished;
	}

	public void setFinished(String finished) {
		this.finished = finished;
	}

	@Column(name = "note")
	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
	}


	
	@Column(name = "pname")
	public String getPname() {
		return pname;
	}

	public void setPname(String pname) {
		this.pname = pname;
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
		return "TransferLog [transferLogId=" + transferLogId + ", terminalId=" + terminalId + ", terminalName="
				+ terminalName + ", transferStartTime=" + transferStartTime + ", transferEndTime=" + transferEndTime
				+ ", transferFileName=" + transferFileName + ", transferFileId=" + transferFileId + ", finished="
				+ finished + ", note=" + note + ", pname=" + pname + ", deleted=" + deleted + "]";
	}



}
