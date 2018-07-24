package org.south.itms.dto;

import java.util.List;

/**
 * @author jan
 * @date 2018年1月12日 下午10:59:56
 * @version V1.0 
 */
public class PageResultData<T> {
	
    private int code;
    
    private int fail;
	
	private String msg;
	
	private int count;
	
	private List<T> data;
	
	public PageResultData() {
		super();
	}

	@Override
	public String toString() {
		return "PageData [code=" + code + ", msg=" + msg + ", count=" + count + ", data=" + data + "]";
	}

	public PageResultData(int code, String msg, int count, List<T> data) {
		super();
		this.code = code;
		this.msg = msg;
		this.count = count;
		this.data = data;
	}


	public int getFail() {
		return fail;
	}

	public void setFail(int fail) {
		this.fail = fail;
	}

	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

	public int getCount() {
		return count;
	}

	public void setCount(int count) {
		this.count = count;
	}

	public List<T> getData() {
		return data;
	}

	public void setData(List<T> data) {
		this.data = data;
	}
}
