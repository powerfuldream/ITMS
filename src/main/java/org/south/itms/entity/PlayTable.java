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
 * @author: yezilong
 */

@Entity
@Table(name = "play_table")
public class PlayTable implements java.io.Serializable { 
	
	private static final long serialVersionUID = 3203717325370760241L;
	private String pid;
	private Date createTime;
	private int deleted;
	
	//外键的id
	private String userId;
	private String terminalId;
	private String periodId;
	private String statusId;
	private String playTotalTime;
	private Date playDate;
	private String screenRate;
	private String allTime;
	private String ptableName;
	private String mark;
	//private String createName;
    private Time startTime;
	
	private Time endTime;
	
	private int min;  //时间间隔
	
	private int insertFlag; //插播  轮询
	
	private int state; //紧急or定时插播      0-轮播/1-紧急/2-定时插播(延时)
	

	
	@Id
	@Column(name = "pid")
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	public String getPid() {
		return pid;
	}

	public void setPid(String pid) {
		this.pid = pid;
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

	@Column(name = "user_id")
	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	/**
	 * @return the terminalId
	 */
	@Column(name = "terminal_id")
	public String getTerminalId() {
		return terminalId;
	}

	/**
	 * @param terminalId the terminalId to set
	 */
	public void setTerminalId(String terminalId) {
		this.terminalId = terminalId;
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

	/**
	 * @return the statusId
	 */
	@Column(name = "status_id")
	public String getStatusId() {
		return statusId;
	}

	/**
	 * @param statusId the statusId to set
	 */
	public void setStatusId(String statusId) {
		this.statusId = statusId;
	}
	
	
	@Column(name = "play_totaltime")
	public String getPlayTotalTime() {
		return playTotalTime;
	}

	public void setPlayTotalTime(String playTotalTime) {
		this.playTotalTime = playTotalTime;
	}

	@Column(name = "play_date")
	public Date getPlayDate() {
		return playDate;
	}

	public void setPlayDate(Date playDate) {
		this.playDate = playDate;
	}

	@Column(name = "screen_rate")
	public String getScreenRate() {
		return screenRate;
	}

	public void setScreenRate(String screenRate) {
		this.screenRate = screenRate;
	}

	@Column(name = "all_time")
	public String getAllTime() {
		return allTime;
	}

	public void setAllTime(String allTime) {
		this.allTime = allTime;
	}

	@Column(name = "ptable_name")
	public String getPtableName() {
		return ptableName;
	}

	public void setPtableName(String ptableName) {
		this.ptableName = ptableName;
	}

	@Column(name = "mark")
	public String getMark() {
		return mark;
	}

	public void setMark(String mark) {
		this.mark = mark;
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

	@Column(name = "min")
	public int getMin() {
		return min;
	}

	public void setMin(int min) {
		this.min = min;
	}

	@Column(name = "insert_flag")
	public int getInsertFlag() {
		return insertFlag;
	}

	public void setInsertFlag(int insertFlag) {
		this.insertFlag = insertFlag;
	}

	@Column(name = "state")
	public int getState() {
		return state;
	}

	public void setState(int state) {
		this.state = state;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return "PlayTable [pid=" + pid + ", createTime=" + createTime + ", deleted=" + deleted + ", userId=" + userId
				+ ", terminalId=" + terminalId + ", periodId=" + periodId + ", statusId=" + statusId + "]";
	}
	
	
}
