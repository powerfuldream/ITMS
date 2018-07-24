package org.south.itms.dto;

import java.util.ArrayList;
import java.util.List;

/**
 * @author: yezilong
 */

public class EasyuiDatagrid<T> {

	private int total;
	private List<T> rows;
	
	public EasyuiDatagrid() {
		this.total = 0;
		this.rows = new ArrayList<T>();		
	}
	

	public EasyuiDatagrid(List<T> rows) {
		super();
		this.rows = rows;
		this.total = rows.size();
	}




	public int getTotal() {
		return total;
	}

	public void setTotal(int total) {
		this.total = total;
	}

	public List<T> getRows() {
		return rows;
	}

	public void setRows(List<T> rows) {
		this.rows = rows;
	}

	@Override
	public String toString() {
		return "EasyuiDatagrid [total=" + total + ", rows=" + rows + "]";
	}

	
}
