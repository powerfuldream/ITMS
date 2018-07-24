package org.south.itms.dto;

import java.io.Serializable;
import java.util.List;

/**
 * @author: yezilong
 */

public class Page implements Serializable {

	private static final long serialVersionUID = -6611182380689514551L;

	private int currentPage; // 当前页码
	private int totalPage; // 总共的页数
	private int pageSize; // 每页多少条数据
	private int totalRecord; // 数据库总共有多少条数据
	private List list; // 当前页码的数据

	public Page() {
		super();
	}

	public Page(int currentPage, int totalPage, int pageSize, int totalRecord, List list) {
		super();
		this.currentPage = currentPage;
		this.totalPage = totalPage;
		this.pageSize = pageSize;
		this.totalRecord = totalRecord;
		this.list = list;
	}

	public int getCurrentPage() {
		return currentPage;
	}

	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
	}

	public int getTotalPage() {
		return totalPage;
	}

	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public int getTotalRecord() {
		return totalRecord;
	}

	public void setTotalRecord(int totalRecord) {
		this.totalRecord = totalRecord;
	}

	public List getList() {
		return list;
	}

	public void setList(List list) {
		this.list = list;
	}

	@Override
	public String toString() {
		return "Page [currentPage=" + currentPage + ", totalPage=" + totalPage + ", pageSize=" + pageSize
				+ ", totalRecord=" + totalRecord + ", list=" + list + "]";
	}

}
