package org.south.itms.dto;

import java.io.Serializable;


/**
 * @author: yezilong
 */

public class Result implements Serializable {

	private static final long serialVersionUID = 2801984691733329173L;

	private boolean success;
	private String msg;
	private String failType;
	private Object obj;

	public Result() {
		this.success = false;
		this.failType = "";
	}

	public Result(String msg) {
		super();
		this.msg = msg;
	}
	
	public Result(boolean success, Object obj) {
		super();
		this.success = success;
		this.obj = obj;
	}

	public boolean isSuccess() {
		return success;
	}

	public void setSuccess(boolean success) {
		this.success = success;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

	public Object getObj() {
		return obj;
	}

	public void setObj(Object obj) {
		this.obj = obj;
	}

	
	public String getFailType() {
		return failType;
	}

	public void setFailType(String failType) {
		this.failType = failType;
	}

	@Override
	public String toString() {
		return "Result [success=" + success + ", msg=" + msg + ", failType=" + failType + ", obj=" + obj + "]";
	}



}
