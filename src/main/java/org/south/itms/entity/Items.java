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
 * @date 2018年1月20日 上午10:59:49
 * @version V1.0 
 */
@Entity
@Table(name = "items")
public class Items implements java.io.Serializable {

	/** 
	 * @since JDK 1.6 
	 */ 
	private static final long serialVersionUID = -5278665950149717258L;
	
	private String itemId;
	
	private String periodId;
	
	private String materialName;
	
	private String itemName;
	
	private Date startDate;
	
	private Date endDate;
	
	private int duration;
	
	private int frequency;
	
	private Date createTime;
	
	private String createName;
	
	private int deleted;
	
	private Material material;
	
	private String terminalId;

	@Id
	@Column(name = "item_id")
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	public String getItemId() {
		return itemId;
	}

	public void setItemId(String itemId) {
		this.itemId = itemId;
	}

	@Column(name = "period_id")
	public String getPeriodId() {
		return periodId;
	}

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

	@Column(name = "item_name")
	public String getItemName() {
		return itemName;
	}

	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

	@Column(name = "start_date")
	public Date getStartDate() {
		return startDate;
	}

	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}

	@Column(name = "end_date")
	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

	@Column(name = "duration")
	public int getDuration() {
		return duration;
	}

	public void setDuration(int duration) {
		this.duration = duration;
	}

	@Column(name = "frequency")
	public int getFrequency() {
		return frequency;
	}

	public void setFrequency(int frequency) {
		this.frequency = frequency;
	}

	@Column(name = "create_time")
	@Temporal(TemporalType.TIMESTAMP)
	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	@Column(name = "create_name")
	public String getCreateName() {
		return createName;
	}

	public void setCreateName(String createName) {
		this.createName = createName;
	}

	@Column(name = "deleted")
	public int getDeleted() {
		return deleted;
	}

	public void setDeleted(int deleted) {
		this.deleted = deleted;
	}

	@OneToOne  
    @JoinColumn(name = "mid")
	public Material getMaterial() {
		return material;
	}

	public void setMaterial(Material material) {
		this.material = material;
	}
	
	
	@Column(name = "terminal_id")
	public String getTerminalId() {
		return terminalId;
	}

	public void setTerminalId(String terminalId) {
		this.terminalId = terminalId;
	}

	public Items() {
		super();
	}

	public Items(String itemId, String periodId, String materialName, String itemName, Date startDate,
			Date endDate, int duration, int frequency, Date createTime, String createName, int deleted, Material material) {
		super();
		this.itemId = itemId;
		this.periodId = periodId;
		this.materialName = materialName;
		this.itemName = itemName;
		this.startDate = startDate;
		this.endDate = endDate;
		this.duration = duration;
		this.frequency = frequency;
		this.createTime = createTime;
		this.createName = createName;
		this.deleted = deleted;
		this.material = material;
	}

	@Override
	public String toString() {
		return "Items [itemId=" + itemId + ", period=" + periodId + ", materialName=" + materialName
				+ ", itemName=" + itemName + ", startDate=" + startDate + ", endDate=" + endDate + ", duration="
				+ duration + ", frequency=" + frequency + ", createTime=" + createTime + ", createName=" + createName
				+ ", deleted=" + deleted + "]";
	}
}
