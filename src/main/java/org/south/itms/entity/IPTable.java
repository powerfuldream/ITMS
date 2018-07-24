package org.south.itms.entity;

import java.sql.Time;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * @author jan
 * @date 2017年12月10日 下午3:47:15
 * @version V1.0 
 */
@Entity
@Table(name = "ps_table")
public class IPTable implements java.io.Serializable {
	/** 
	 * @since JDK 1.6 
	 */ 
	private static final long serialVersionUID = -1354182887478692550L;

	private String tid;
	
	private String materialName;
	
	private Date insertDate;
	
	private Time startTime;
	
	private Time endTime;
	
	private int min;
	
	private int status; //瞬时or延时
	
	private String mid;
	
	private String terminalId;
	
	private String createName;
	
	private Date createTime;
	
	private int deleted;

	@Id
	@Column(name = "tid")
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	public String getTid() {
		return tid;
	}

	public void setTid(String tid) {
		this.tid = tid;
	}
		
	@Column(name = "material_name")
	public String getMaterialName() {
		return materialName;
	}

	public void setMaterialName(String materialName) {
		this.materialName = materialName;
	}

	@Column(name = "insert_date")
	public Date getInsertDate() {
		return insertDate;
	}
		

	@Column(name = "min")
	public int getMin() {
		return min;
	}

	public void setMin(int min) {
		this.min = min;
	}

	@Column(name = "status")
	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public void setInsertDate(Date insertDate) {
		this.insertDate = insertDate;
	}

	@Column(name = "start_time")
	public Time getStartTime() {
		return startTime;
	}

	public void setStartTime(Time startTime) {
		this.startTime = startTime;
	}

	@Column(name = "end_time")
	public Time getEndTime() {
		return endTime;
	}

	public void setEndTime(Time endTime) {
		this.endTime = endTime;
	}


	@Column(name = "mid")
	public String getMid() {
		return mid;
	}

	public void setMid(String mid) {
		this.mid = mid;
	}

	@Column(name = "terminal_id")
	public String getTerminalId() {
		return terminalId;
	}

	public void setTerminalId(String terminalId) {
		this.terminalId = terminalId;
	}

	@Column(name = "create_name")
	public String getCreateName() {
		return createName;
	}

	public void setCreateName(String createName) {
		this.createName = createName;
	}

	@Column(name = "create_time")
	@Temporal(TemporalType.TIMESTAMP)
	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	@Column(name = "deleted")
	public int getDeleted() {
		return deleted;
	}

	public void setDeleted(int deleted) {
		this.deleted = deleted;
	}

	/* 
	 * 
	 */
	@Override
	public String toString() {
		return "IPTable [tid=" + tid + ", insertDate=" + insertDate + ", startTime=" + startTime + ", endTime="
				+ endTime + ", min=" + min + ", fileId=" + mid + ", terminalId=" + terminalId + ", createName="
				+ createName + ", createTime=" + createTime + ", deleted=" + deleted + "]";
	}

	
}