package org.south.itms.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

/**
* @author jan  
* @E-mail:ja.janliao@gmail.com
* @version V1.0
* @date 2017年11月16日 上午10:09:52
* 
*/

@Entity
@Table(name = "status")
public class Status {

	private String statusId;
	private String statusName;
	
	@Column(name = "status_name")
	public String getStatusName() {
		return statusName;
	}

	public void setStatusName(String statusName) {
		this.statusName = statusName;
	}

	@Id
	@Column(name = "status_id")
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	public String getstatusId() {
		return statusId;
	}

	public void setStatusId(String statusId) {
		this.statusId = statusId;
	}

	@Override
	public String toString() {
		return "Status [statusId=" + statusId + "]";
	}
}
