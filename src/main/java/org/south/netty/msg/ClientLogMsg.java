package org.south.netty.msg;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class ClientLogMsg extends BaseMsg {

	private static final long serialVersionUID = 4063443105928239265L;

	private String terminalId;
	private String terminalName;
	private String heartRecordTime;
	private String locateIp;

	private List<SysLogMsg> sysLogs;
	private List<ErrorLogMsg> errorLogs;
	private List<PlayLogMsg> playLogs;
	private List<TransferLogMsg> transferLogs;

	public ClientLogMsg() {
		super();
		setMsgType(MsgType.ClientLogMsg);
		heartRecordTime = null;
		sysLogs = new ArrayList<>();
		errorLogs = new ArrayList<>();
		playLogs = new ArrayList<>();
		transferLogs = new ArrayList<>();
	}

	public String getTerminalId() {
		return terminalId;
	}

	public void setTerminalId(String terminalId) {
		this.terminalId = terminalId;
	}

	public String getTerminalName() {
		return terminalName;
	}

	public void setTerminalName(String terminalName) {
		this.terminalName = terminalName;
	}
	
	public String getHeartRecordTime() {
		return heartRecordTime;
	}

	public void setHeartRecordTime(String heartRecordTime) {
		this.heartRecordTime = heartRecordTime;
	}

	public List<SysLogMsg> getSysLogs() {
		return sysLogs;
	}

	public void setSysLogs(List<SysLogMsg> sysLogs) {
		this.sysLogs = sysLogs;
	}

	public List<ErrorLogMsg> getErrorLogs() {
		return errorLogs;
	}

	public void setErrorLogs(List<ErrorLogMsg> errorLogs) {
		this.errorLogs = errorLogs;
	}

	public List<PlayLogMsg> getPlayLogs() {
		return playLogs;
	}

	public void setPlayLogs(List<PlayLogMsg> playLogs) {
		this.playLogs = playLogs;
	}

	public List<TransferLogMsg> getTransferLogs() {
		return transferLogs;
	}

	public void setTransferLogs(List<TransferLogMsg> transferLogs) {
		this.transferLogs = transferLogs;
	}

	public String getLocateIp() {
		return locateIp;
	}

	public void setLocateIp(String locateIp) {
		this.locateIp = locateIp;
	}

	
	@Override
	public String toString() {
		return "ClientLogMsg [terminalId=" + terminalId + ", terminalName=" + terminalName + ", heartRecordTime="
				+ heartRecordTime + ", locateIp=" + locateIp + ", sysLogs=" + sysLogs + ", errorLogs=" + errorLogs
				+ ", playLogs=" + playLogs + ", transferLogs=" + transferLogs + "]";
	}




}
