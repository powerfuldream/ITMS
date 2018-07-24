package org.south.itms.dao.impl;

import org.south.netty.msg.ClientLogMsg;

public interface LogDao {

	void batchInsertLog(ClientLogMsg log);

	void delSysLog(String id);

	void delErrorLog(String id);

	void delPlayLog(String id);

	void delHeartbeatLog(String id);

	void delTransferLog(String id);

}
