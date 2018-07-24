package org.south.netty.msg;

import java.util.List;

/**
 * @author: yezilong
 */

public class OffsetFileMsg extends BaseMsg {

	private List<String> nofileIds; // 不存在的视频文件
	private String terminalId;

	public OffsetFileMsg(List<String> nofileIds, String terminalId) {
		this.nofileIds = nofileIds;
		this.terminalId = terminalId;
		setMsgType(MsgType.OffsetFile);
	}

	public List<String> getNofileIds() {
		return nofileIds;
	}

	public void setNofileIds(List<String> nofileIds) {
		this.nofileIds = nofileIds;
	}

	public String getTerminalId() {
		return terminalId;
	}

	public void setTerminalId(String terminalId) {
		this.terminalId = terminalId;
	}

	@Override
	public String toString() {
		return "OffsetFileMsg [nofileIds=" + nofileIds + ", terminalId=" + terminalId + "]";
	}

}
