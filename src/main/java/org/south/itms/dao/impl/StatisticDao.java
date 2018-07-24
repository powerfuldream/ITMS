package org.south.itms.dao.impl;

import java.util.List;

import org.south.itms.dto.PlayNumDto;
import org.south.itms.entity.PlayLog;

public interface StatisticDao {

	List<PlayNumDto> findPlayNumDto(String terminalId, String startTime, String endTime);

	List<PlayLog> findPlayLog(String terminalId, String startTime, String endTime);

	
}  