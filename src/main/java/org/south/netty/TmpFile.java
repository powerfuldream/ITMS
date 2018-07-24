package org.south.netty;

/**
 * @author jan
 * @date 2017年11月29日 下午2:14:51
 * @version V1.0 
 */
public class TmpFile {

	private int fileId;
	
	private int periodId;
	
	private int terminalId;
	
	private Integer frequency;
	
	private String startTime;
	
	private String endTime;
	
	private Integer duration;
		
	

	public Integer getDuration() {
		return duration;
	}

	public void setDuration(Integer duration) {
		this.duration = duration;
	}

	/**
	 * @return the startTime
	 */
	public String getStartTime() {
		return startTime;
	}

	/**
	 * @param startTime the startTime to set
	 */
	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	/**
	 * @return the endTime
	 */
	public String getEndTime() {
		return endTime;
	}

	/**
	 * @param endTime the endTime to set
	 */
	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	/**
	 * @return the fileId
	 */
	public int getFileId() {
		return fileId;
	}

	/**
	 * @param fileId the fileId to set
	 */
	public void setFileId(int fileId) {
		this.fileId = fileId;
	}

	/**
	 * @return the periodId
	 */
	public int getPeriodId() {
		return periodId;
	}

	/**
	 * @param periodId the periodId to set
	 */
	public void setPeriodId(int periodId) {
		this.periodId = periodId;
	}

	/**
	 * @return the terminalId
	 */
	public int getTerminalId() {
		return terminalId;
	}

	/**
	 * @param terminalId the terminalId to set
	 */
	public void setTerminalId(int terminalId) {
		this.terminalId = terminalId;
	}

	/**
	 * @return the frequency
	 */
	public Integer getFrequency() {
		return frequency;
	}

	/**
	 * @param frequency the frequency to set
	 */
	public void setFrequency(Integer frequency) {
		this.frequency = frequency;
	}

	/**
	 * @param fileId
	 * @param periodId
	 * @param terminalId
	 * @param frequency
	 */
	public TmpFile(int fileId, int periodId, int terminalId, Integer frequency) {
		super();
		this.fileId = fileId;
		this.periodId = periodId;
		this.terminalId = terminalId;
		this.frequency = frequency;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return "TmpFile [fileId=" + fileId + ", periodId=" + periodId + ", terminalId=" + terminalId + ", frequency="
				+ frequency + "]";
	}

	/**
	 * 
	 */
	public TmpFile() {
		super();
	}
	
	
}
