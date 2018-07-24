package org.south.itms.entity;

import java.sql.Time;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * @author jan
 * @date 2017年11月23日 下午4:57:49
 * @version V1.0 
 */

@Entity
@Table(name = "period")
public class Period implements java.io.Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 9085994977273383992L;

	private String periodId;
	
	private String periodName;
	
	private Time startInterval;
	
	private Time endInterval;
	
	private String mark;
	
	private int status;
	
	private int deleted;
	
	
	private String terminalId;  //该时段对应的播放端
	
	private String terminalName;

	/**
	 * @return the periodId
	 */
	@Id
	@Column(name = "period_id")
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	public String getPeriodId() {
		return periodId;
	}

	/**
	 * @param periodId the periodId to set
	 */
	public void setPeriodId(String periodId) {
		this.periodId = periodId;
	}
	
	

	/**
	 * @return the periodName
	 */
	@Column(name = "period_name")
	public String getPeriodName() {
		return periodName;
	}

	/**
	 * @param periodName the periodName to set
	 */
	public void setPeriodName(String periodName) {
		this.periodName = periodName;
	}

	/**
	 * @return the startInterval
	 */
	@Column(name = "start_interval")
	public Time getStartInterval() {
		return startInterval;
	}

	/**
	 * @param startInterval the startInterval to set
	 */
	public void setStartInterval(Time startInterval) {
		this.startInterval = startInterval;
	}

	/**
	 * @return the endInterval
	 */
	@Column(name = "end_interval")
	public Time getEndInterval() {
		return endInterval;
	}

	/**
	 * @param endInterval the endInterval to set
	 */
	public void setEndInterval(Time endInterval) {
		this.endInterval = endInterval;
	}

	/**
	 * @return the mark
	 */
	@Column(name = "mark")
	public String getMark() {
		return mark;
	}

	/**
	 * @param mark the mark to set
	 */
	public void setMark(String mark) {
		this.mark = mark;
	}

	@Column(name = "deleted")
	public int getDeleted() {
		return deleted;
	}

	public void setDeleted(int deleted) {
		this.deleted = deleted;
	}
	
	@Column(name = "status")
	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
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

	
	@Override
	public String toString() {
		return "Period [periodId=" + periodId + ", periodName=" + periodName + ", startInterval=" + startInterval
				+ ", endInterval=" + endInterval + ", mark=" + mark + ", status=" + status + ", deleted=" + deleted
				+ ", terminalId=" + terminalId + ", terminalName=" + terminalName + "]";
	}

	
}
