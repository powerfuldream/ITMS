package org.south.itms.entity;

import java.util.Date;

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

/**
 * @author jan
 * @date 2018年1月20日 上午10:57:52
 * @version V1.0 
 */
@Entity
@Table(name = "material")
public class Material implements java.io.Serializable {

/** 
	 * @since JDK 1.6 
	 */ 
	private static final long serialVersionUID = -712729945398469188L;

    private String mid;
	
	private String materialName;
	
	private String fileName;
	
	private String fileType;
	
	private String filePath;
	
	private String uploadName;
	
	private Date uploadTime;
	
	private int deleted;
	
	private int duration;
	
	private String size;
	
	private String md5;
	
	private String checkName;
	
	private Date checkTime;
	
	private String statusId;
	
	private Terminal terminal;
	
	private String resolution;
	
	private String info;
	
	private int usedNum;
	
	private String tis;

	@Id
	@Column(name = "mid")
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	public String getMid() {
		return mid;
	}

	public void setMid(String mid) {
		this.mid = mid;
	}

	@Column(name = "material_name")
	public String getMaterialName() {
		return materialName;
	}

	public void setMaterialName(String materialName) {
		this.materialName = materialName;
	}

	@Column(name = "file_name")
	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	@Column(name = "file_type")
	public String getFileType() {
		return fileType;
	}

	public void setFileType(String fileType) {
		this.fileType = fileType;
	}

	@Column(name = "file_path")
	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	@Column(name = "upload_name")
	public String getUploadName() {
		return uploadName;
	}

	public void setUploadName(String uploadName) {
		this.uploadName = uploadName;
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

	@Column(name = "duration")
	public int getDuration() {
		return duration;
	}

	public void setDuration(int duration) {
		this.duration = duration;
	}

	@Column(name = "size")
	public String getSize() {
		return size;
	}

	public void setSize(String size) {
		this.size = size;
	}

	@Column(name = "md5")
	public String getMd5() {
		return md5;
	}

	public void setMd5(String md5) {
		this.md5 = md5;
	}

	@Column(name = "check_name")
	public String getCheckName() {
		return checkName;
	}

	public void setCheckName(String checkName) {
		this.checkName = checkName;
	}

	@Column(name = "check_time")
	@Temporal(TemporalType.TIMESTAMP)
	public Date getCheckTime() {
		return checkTime;
	}

	public void setCheckTime(Date checkTime) {
		this.checkTime = checkTime;
	}

	@Column(name = "status_id")
	public String getStatusId() {
		return statusId;
	}

	public void setStatusId(String statusId) {
		this.statusId = statusId;
	}

	@OneToOne
	@JoinColumn(name = "terminal_id")
	public Terminal getTerminal() {
		return terminal;
	}

	public void setTerminal(Terminal terminal) {
		this.terminal = terminal;
	}

	@Column(name = "resolution")
	public String getResolution() {
		return resolution;
	}

	public void setResolution(String resolution) {
		this.resolution = resolution;
	}

	@Column(name = "info")
	public String getInfo() {
		return info;
	}

	public void setInfo(String info) {
		this.info = info;
	}

	@Column(name = "used_num")
	public int getUsedNum() {
		return usedNum;
	}

	public void setUsedNum(int usedNum) {
		this.usedNum = usedNum;
	}

	@Column(name = "tis")
	public String getTis() {
		return tis;
	}

	public void setTis(String tis) {
		this.tis = tis;
	}

	public Material() {
		super();
	}

	public Material(String mid, String materialName, String fileName, String fileType, String filePath,
			String uploadName, Date uploadTime, int deleted, int duration, String size, String md5, String checkName,
			Date checkTime, String statusId, Terminal terminal, String resolution, String info, int usedNum) {
		super();
		this.mid = mid;
		this.materialName = materialName;
		this.fileName = fileName;
		this.fileType = fileType;
		this.filePath = filePath;
		this.uploadName = uploadName;
		this.uploadTime = uploadTime;
		this.deleted = deleted;
		this.duration = duration;
		this.size = size;
		this.md5 = md5;
		this.checkName = checkName;
		this.checkTime = checkTime;
		this.statusId = statusId;
		this.terminal = terminal;
		this.resolution = resolution;
		this.info = info;
		this.usedNum = usedNum;
	}

	@Override
	public String toString() {
		return "Material [mid=" + mid + ", materialName=" + materialName + ", fileName=" + fileName + ", fileType="
				+ fileType + ", filePath=" + filePath + ", uploadName=" + uploadName + ", uploadTime=" + uploadTime
				+ ", deleted=" + deleted + ", duration=" + duration + ", size=" + size + ", md5=" + md5 + ", checkName="
				+ checkName + ", checkTime=" + checkTime + ", statusId=" + statusId + ", terminal=" + terminal
				+ ", resolution=" + resolution + ", info=" + info + "]";
	}
}
