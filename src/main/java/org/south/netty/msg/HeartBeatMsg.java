package org.south.netty.msg;

/**
 * @author: yezilong
 */

public class HeartBeatMsg extends BaseMsg {

	public HeartBeatMsg() {
      setMsgType(MsgType.Heartbeat);
	}
	

}
