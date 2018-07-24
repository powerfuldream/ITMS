package org.south.itms.dto;

import java.util.List;

/**
 * @author jan
 * @date 2017年12月18日 下午10:27:04
 * @version V1.0 
 */
public class TreeDate {

	private String id;
	
	private String name;
	
	private boolean spread;
	
	private List<TreeDate> children;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public boolean isSpread() {
		return spread;
	}

	public void setSpread(boolean spread) {
		this.spread = spread;
	}

	public TreeDate(String id, String name) {
		super();
		this.id = id;
		this.name = name;
	}

	public TreeDate(String id, String name, List<TreeDate> children) {
		super();
		this.id = id;
		this.name = name;
		this.children = children;
	}

	public TreeDate() {
		super();
	}

	public List<TreeDate> getChildren() {
		return children;
	}

	public void setChildren(List<TreeDate> children) {
		this.children = children;
	}

	@Override
	public String toString() {
		return "TreeDate [id=" + id + ", name=" + name + ", children=" + children + "]";
	}

}
