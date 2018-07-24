package org.south.itms.dto;

import org.south.itms.entity.Items;

/**
 * @author jan
 * @date 2018年1月22日 上午10:44:25
 * @version V1.0 
 */

/**
 * @author zym
 * @date 2018年7月14日 
 * @version V1.1
 */
public class ItemsDto extends Items {

	/** 
	 * @since JDK 1.6 
	 */ 
	private static final long serialVersionUID = -8034219217880100805L;
	private String periodName;
	private String playDate;
	public String getPeriodName() {
		return periodName;
	}

	public void setPeriodName(String periodName) {
		this.periodName = periodName;
	}

	public String getPlayDate() {
		return playDate;
	}

	public void setPlayDate(String playDate) {
		this.playDate = playDate;
	}

	public ItemsDto(String periodName, String playDate) {
		super();
		this.periodName = periodName;
		this.playDate = playDate;
	}
	
	
	

	@Override
	public String toString() {
		return "ItemsDto [periodName=" + periodName + ", getItemId()=" + getItemId() + ", getPeriodId()="
				+ getPeriodId() + ", getMaterialName()=" + getMaterialName() + ", getItemName()=" + getItemName()
				+ ", getStartDate()=" + getStartDate() + ", getEndDate()=" + getEndDate() + ", getDuration()="
				+ getDuration() + ", getFrequency()=" + getFrequency() + ", getCreateTime()=" + getCreateTime()
				+ ", getCreateName()=" + getCreateName() + ", getDeleted()=" + getDeleted() + ", getMaterial()="
				+ getMaterial() + ", getTerminalId()=" + getTerminalId() + ", toString()=" + super.toString()
				+ ", getClass()=" + getClass() + ", hashCode()=" + hashCode() + "]";
	}
	
	
}
