package org.south.netty.msg;


/**
 * @author: yezilong
 */

public enum MsgType {
	Heartbeat, Validate, Result, Request, UnKnow, Download, OffsetFile, OffsetComplete, stopTerminal, restartTerminal, InsertMaterial, ClientLogMsg, LogicClose, UpdatePtable
}
