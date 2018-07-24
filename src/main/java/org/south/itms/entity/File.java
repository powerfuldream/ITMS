package org.south.itms.entity;

import java.util.Date;
import java.sql.Time;
import java.util.*;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;


@Entity
@Table(name = "files")
public class File implements java.io.Serializable {

	private static final long serialVersionUID = -5350647641515444283L;
	
	private String fileId;
	private String fileName;
	private String filePath;
	private String fileType;
	private Date uploadTime;
	private int deleted;

	private int frequency;
	private int duration;
	private String terminalId;
	private Date startTime;
	private Date endTime;
	private String materialName;
	private String md5;
	private String periodId;
	private String firstCheckName;
	private String secondCheckName;
	private Date firstCheckTime;
	private Date secondCheckTime;
	private String statusId;
	private String uploadName;
	
	@Column(name = "upload_name")
	public String getUploadName() {
		return uploadName;
	}

	public void setUploadName(String uploadName) {
		this.uploadName = uploadName;
	}

	@Column(name = "status_id")
	public String getStatusId() {
		return statusId;
	}

	public void setStatusId(String statusId) {
		this.statusId = statusId;
	}

	@Column(name = "md5")
	public String getMd5() {
		return md5;
	}

	@Column(name = "first_name")
	public String getFirstCheckName() {
		return firstCheckName;
	}

	public void setFirstCheckName(String firstCheckName) {
		this.firstCheckName = firstCheckName;
	}

	@Column(name = "second_name")
	public String getSecondCheckName() {
		return secondCheckName;
	}

	public void setSecondCheckName(String secondCheckName) {
		this.secondCheckName = secondCheckName;
	}

	@Column(name = "firstcheck_time")
	@Temporal(TemporalType.TIMESTAMP)
	public Date getFirstCheckTime() {
		return firstCheckTime;
	}

	public void setFirstCheckTime(Date firstCheckTime) {
		this.firstCheckTime = firstCheckTime;
	}

	@Column(name = "secondcheck_time")
	@Temporal(TemporalType.TIMESTAMP)
	public Date getSecondCheckTime() {
		return secondCheckTime;
	}

	public void setSecondCheckTime(Date secondCheckTime) {
		this.secondCheckTime = secondCheckTime;
	}

	public void setMd5(String md5) {
		this.md5 = md5;
	}

	

	/**
	 * @return the periodId
	 */
	@Column(name = "period_id")
	public String getPeriodId() {
		return periodId;
	}

	/**
	 * @param periodId the periodId to set
	 */
	public void setPeriodId(String periodId) {
		this.periodId = periodId;
	}

	@Column(name = "material_name")
	public String getMaterialName() {
		return materialName;
	}

	public void setMaterialName(String materialName) {
		this.materialName = materialName;
	}

	@Column(name = "start_time")
	public Date getStartTime() {
		return startTime;
	}

	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}

	@Column(name = "end_time")
	public Date getEndTime() {
		return endTime;
	}

	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}

	@Id
	@Column(name = "file_id")
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	public String getFileId() {
		return fileId;
	}

	public void setFileId(String fileId) {
		this.fileId = fileId;
	}

	@Column(name = "file_name")
	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	@Column(name = "file_path")
	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	
	@Column(name = "file_type")
	public String getFileType() {
		return fileType;
	}

	public void setFileType(String fileType) {
		this.fileType = fileType;
	}

	@Column(name = "upload_time")
	@Temporal(TemporalType.TIMESTAMP)
	public Date getUploadTime() {
		return uploadTime;
	}

	public void setUploadTime(Date uploadTime) {
		this.uploadTime = uploadTime;
	}

	
	@Column(name = "deleted")
	public int getDeleted() {
		return deleted;
	}

	public void setDeleted(int deleted) {
		this.deleted = deleted;
	}

	@Column(name = "frequency")
	public int getFrequency() {
		return frequency;
	}

	public void setFrequency(int frequency) {
		this.frequency = frequency;
	}

	
	@Column(name = "duration")
	public int getDuration() {
		return duration;
	}

	public void setDuration(int duration) {
		this.duration = duration;
	}

	@Column(name = "terminal_id")
	public String getTerminalId() {
		return terminalId;
	}

	public void setTerminalId(String terminalId) {
		this.terminalId = terminalId;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return "File [fileId=" + fileId + ", fileName=" + fileName + ", filePath=" + filePath + ", fileType=" + fileType
				+ ", uploadTime=" + uploadTime + ", deleted=" + deleted + ", frequency=" + frequency + ", duration="
				+ duration + ", terminalId=" + terminalId + ", startTime=" + startTime + ", endTime=" + endTime
				+ ", materialName=" + materialName + ", md5=" + md5 + ", periodId=" + periodId + ", firstCheckName="
				+ firstCheckName + ", secondCheckName=" + secondCheckName + ", firstCheckTime=" + firstCheckTime
				+ ", secondCheckTime=" + secondCheckTime + ", statusId=" + statusId + ", uploadName=" + uploadName
				+ "]";
	}
	
}
