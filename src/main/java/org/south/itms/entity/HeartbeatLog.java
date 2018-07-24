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
@Table(name = "heartbeat_log")
public class HeartbeatLog implements java.io.Serializable {

	private static final long serialVersionUID = 8346247804196751466L;
	
	private String heartbeatLogId;
	private String terminalId;
	private String terminalName;
	private Date recordTime;
	private int deleted;

	
	@Id
	@Column(name = "heartbeat_log_id")
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	public String getHeartbeatLogId() {
		return heartbeatLogId;
	}

	public void setHeartbeatLogId(String heartbeatLogId) {
		this.heartbeatLogId = heartbeatLogId;
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

	@Column(name = "record_time")
	@Temporal(TemporalType.TIMESTAMP) 
	public Date getRecordTime() {
		return recordTime;
	}

	public void setRecordTime(Date recordTime) {
		this.recordTime = recordTime;
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
		return "HeartbeatLog [heartbeatLogId=" + heartbeatLogId + ", terminalId=" + terminalId + ", terminalName="
				+ terminalName + ", recordTime=" + recordTime + ", deleted=" + deleted + "]";
	}

}
