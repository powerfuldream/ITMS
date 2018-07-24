package org.south.itms.service.impl;

import java.util.List;

import org.south.itms.dao.impl.StatisticDao;
import org.south.itms.dto.PlayNumDto;
import org.south.itms.entity.PlayLog;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author: yezilong
 */

@Service("statisticService")  
public class StatisticServiceImpl implements StatisticService {

	@Autowired
	private StatisticDao statisticDao;

	@Override
	public List<PlayNumDto> findPlayNumDto(String terminalId, String startTime, String endTime) {
		// TODO Auto-generated method stub
		return statisticDao.findPlayNumDto(terminalId, startTime, endTime);
	}

	@Override
	public List<PlayLog> findPlayLog(String terminalId, String startTime, String endTime) {
		// TODO Auto-generated method stub
		return statisticDao.findPlayLog(terminalId, startTime, endTime);
	}
	
	
	
}
