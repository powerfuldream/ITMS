package org.south.netty;

import java.util.List;

/**
 * @author jan
 * @date 2017年11月29日 下午3:04:14
 * @version V1.0 
 */
public class AutoPlayTable {

	private int terminalId;
	
	private int periodId;
	
	private List<Ad> listAd;

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
	 * @return the listAd
	 */
	public List<Ad> getListAd() {
		return listAd;
	}

	/**
	 * @param listAd the listAd to set
	 */
	public void setListAd(List<Ad> listAd) {
		this.listAd = listAd;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return "AutoPlayTable [terminalId=" + terminalId + ", periodId=" + periodId + ", listAd=" + listAd + "]";
	}
	
	
}
