package org.south.itms.service.impl;

import org.south.itms.dao.impl.LogDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * @author: yezilong
 */

@Service("logService")  
public class LogServiceImpl implements LogService {

	@Autowired
	private LogDao logDao;
	
	
	@Transactional
	@Override
	public void delSysLog(String[] ids) {
		// TODO Auto-generated method stub
		for(String id : ids) {
			logDao.delSysLog(id);
		}
	}  
	
	
	@Transactional
	@Override
	public void delTransferLog(String[] ids) {
		// TODO Auto-generated method stub
		for(String id : ids) {
			logDao.delTransferLog(id);
		}
	}  
	
	
	
	
	@Transactional
	@Override
	public void delHeartbeatLog(String[] ids) {
		// TODO Auto-generated method stub
		for(String id : ids) {
			logDao.delHeartbeatLog(id);
		}
	}  
	
	
	
	@Transactional
	@Override
	public void delPlayLog(String[] ids) {
		// TODO Auto-generated method stub
		for(String id : ids) {
			logDao.delPlayLog(id);
		}
	}  
	
	
	
	@Transactional
	@Override
	public void delErrorLog(String[] ids) {
		// TODO Auto-generated method stub
		for(String id : ids) {
			logDao.delErrorLog(id);
		}
	}  
	
	
	
}
