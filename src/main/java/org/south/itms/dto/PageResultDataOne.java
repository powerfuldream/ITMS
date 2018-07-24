package org.south.itms.dto;

import java.util.List;

/**
 * @author jan
 * @date 2018年1月24日 下午1:14:14
 * @version V1.0 
 */
public class PageResultDataOne<T> {

    private int code;
    
    private int fail;
	
	private String msg;
	
	private int count;
	
	private List<T> data;
	
	private List<Integer> flag;
	
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

	public List<Integer> getFlag() {
		return flag;
	}

	public void setFlag(List<Integer> flag) {
		this.flag = flag;
	}
}
