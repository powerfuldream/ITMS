package org.south.itms.dto;
/**
 * @author jan
 * @date 2018年1月24日 上午2:30:19
 * @version V1.0 
 */

import java.util.List;
import java.util.Map;

import org.south.itms.entity.Resource;

public class AuthorityRole {

	private String rId;
	
	private String rName;
	
	private Map<String, List<Resource>> map;

	public String getrName() {
		return rName;
	}

	public void setrName(String rName) {
		this.rName = rName;
	}

	public Map<String, List<Resource>> getMap() {
		return map;
	}

	public void setMap(Map<String, List<Resource>> map) {
		this.map = map;
	}

	public String getrId() {
		return rId;
	}

	public void setrId(String rId) {
		this.rId = rId;
	}

	public AuthorityRole(String rName, Map<String, List<Resource>> map, String rId) {
		super();
		this.rName = rName;
		this.map = map;
		this.rId = rId;
	}

	public AuthorityRole() {
		super();
	}

	@Override
	public String toString() {
		return "AuthorityRole [rName=" + rName + ", map=" + map + "]";
	}
}
