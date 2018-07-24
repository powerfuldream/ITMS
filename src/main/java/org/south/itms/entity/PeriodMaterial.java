package org.south.itms.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * @author jan
 * @date 2017年12月19日 下午8:23:59
 * @version V1.0 
 */
@Entity
@Table(name = "p_material")
public class PeriodMaterial {

	private String pmid;
	
	private String periodId;
	
	private String materialId;

	@Id
	@Column(name = "pmid")
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	public String getPmid() {
		return pmid;
	}

	public void setPmid(String pmid) {
		this.pmid = pmid;
	}

	@Column(name = "period_id")
	public String getPeriodId() {
		return periodId;
	}

	public void setPeriodId(String periodId) {
		this.periodId = periodId;
	}

	@Column(name = "material_id")
	public String getMaterialId() {
		return materialId;
	}

	public void setMaterialId(String materialId) {
		this.materialId = materialId;
	}

	@Override
	public String toString() {
		return "PeriodMaterial [pmid=" + pmid + ", periodId=" + periodId + ", materialId=" + materialId + "]";
	}
	
	
}
