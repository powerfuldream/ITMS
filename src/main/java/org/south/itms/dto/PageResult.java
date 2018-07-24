package org.south.itms.dto;

import java.util.List;

/**
 * @author jan
 * @date 2017年12月17日 下午3:45:25
 * @version V1.0 
 */
public class PageResult<T> {

	private int code;
	
	private int fail;
	
	private String msg;
	
	private List<T> data;

	public PageResult() {
		super();
	}

	public PageResult(int code, int fail, String msg, List<T> data) {
		super();
		this.code = code;
		this.fail = fail;
		this.msg = msg;
		this.data = data;
	}

	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public int getFail() {
		return fail;
	}

	public void setFail(int fail) {
		this.fail = fail;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

	public List<T> getData() {
		return data;
	}

	public void setData(List<T> data) {
		this.data = data;
	}

	/* 
	 * 
	 */
	@Override
	public String toString() {
		return "PageResult [code=" + code + ", fail=" + fail + ", msg=" + msg + ", data=" + data + "]";
	}
	
	
	
}
