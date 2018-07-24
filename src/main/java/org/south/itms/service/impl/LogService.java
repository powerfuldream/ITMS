package org.south.itms.service.impl;

public interface LogService {

	void delSysLog(String[] ids);

	void delTransferLog(String[] ids);

	void delHeartbeatLog(String[] ids);

	void delPlayLog(String[] ids);

	void delErrorLog(String[] ids);



}
