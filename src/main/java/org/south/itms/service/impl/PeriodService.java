package org.south.itms.service.impl;

import java.util.List;

import org.south.itms.dto.Page;
import org.south.itms.entity.Period;
import org.south.itms.entity.Terminal;

/**
 * @author jan
 * @date 2017年11月23日 下午6:18:01
 * @version V1.0 
 */
public interface PeriodService {

	Page pageSearchByTemplateHQL(String[] params, int currentPage, int pageSize, String className, String orderBy, String whereSuffix);

	/**
	 * @param periodName
	 * @return
	 */
	boolean checkName(String periodName);

	/**
	 * @param period
	 */
	void save(Period period);

	/**
	 * @param periodId
	 */
	void delPeriod(String[] periodId);

	/**
	 * @param periodId
	 * @return
	 */
	Period getPeriod(String periodId);

	/**
	 * @param period
	 */
	void updatePeriod(Period period);

	List<Period> queryByName(String periodName);

	List<Period> queryByTid(String terminalId);

	List<Period> queryByAreaId(String areaId);

	List<Integer> getMapData(String terminalId);

	List<Period> findPeriodByTerminalId(String terminalId);


}
