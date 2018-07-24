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
@Table(name = "play_log")
public class PlayLog implements java.io.Serializable {


	private static final long serialVersionUID = 6515084727587596330L;
	
	private String playLogId;
	private String terminalId;
	private String terminalName;
	private Date playStartTime;
	private Date playEndTime;
	private String materialName;
	private String fileId;
	private String pname;
	private String pid;
	private int deleted;

	@Id
	@Column(name = "play_log_id")
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	public String getPlayLogId() {
		return playLogId;
	}

	public void setPlayLogId(String playLogId) {
		this.playLogId = playLogId;
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

	@Column(name = "play_start_time")
	@Temporal(TemporalType.TIMESTAMP) 
	public Date getPlayStartTime() {
		return playStartTime;
	}

	public void setPlayStartTime(Date playStartTime) {
		this.playStartTime = playStartTime;
	}

	@Column(name = "play_end_time")
	@Temporal(TemporalType.TIMESTAMP) 
	public Date getPlayEndTime() {
		return playEndTime;
	}

	public void setPlayEndTime(Date playEndTime) {
		this.playEndTime = playEndTime;
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

	@Column(name = "deleted")
	public int getDeleted() {
		return deleted;
	}

	public void setDeleted(int deleted) {
		this.deleted = deleted;
	}

	@Override
	public String toString() {
		return "PlayLog [playLogId=" + playLogId + ", terminalId=" + terminalId + ", terminalName=" + terminalName
				+ ", playStartTime=" + playStartTime + ", playEndTime=" + playEndTime + ", materialName=" + materialName
				+ ", fileId=" + fileId + ", pname=" + pname + ", pid=" + pid + ", deleted=" + deleted + "]";
	}



}
