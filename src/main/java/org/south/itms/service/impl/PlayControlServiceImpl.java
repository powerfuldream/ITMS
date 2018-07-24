package org.south.itms.service.impl;

import java.util.List;

import org.south.itms.dao.impl.PtableDao;
import org.south.itms.dao.impl.TerminalDao;
import org.south.itms.entity.PlayTable;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * @author: yezilong
 */

@Service("playControlService")  
public class PlayControlServiceImpl implements PlayControlService {

	
	@Autowired
	private PtableDao ptableDao;
	
	@Autowired
	private TerminalDao terminalDao;
	
	
	@Override
	public List<PlayTable> findAllPlayTable() {
	   return ptableDao.findAllPlayTable();
	}

	
	
	@Transactional
	@Override
	public void setPlayForTerminal(String[] terminalIds, PlayTable playTable) {
		// TODO Auto-generated method stub
		  for(String terminalId : terminalIds) {
			  terminalDao.setPlayForTerminal(playTable, terminalId);
		  }
	}  
	
}
