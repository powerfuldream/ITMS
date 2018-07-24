package org.south.itms.dao.impl;

import java.util.List;
import java.util.Map;

import org.south.itms.dto.Page;
import org.south.itms.dto.ValueParam;
import org.south.itms.entity.Items;
import org.south.itms.entity.Material;
import org.south.itms.entity.Period;
import org.south.itms.entity.Terminal;

/**
 * @author jan
 * @date 2017年11月23日 下午10:16:25
 * @version V1.0 
 */
public interface PeriodDao {

	Page pageSearchByTemplateHQL(String hql, Map<String, ValueParam> whereMap, int currentPage, int pageSize);

	/**
	 * @param periodName
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

	List<Material> queryByTid(String terminalId);

	Period getPeriodById(String periodId);

	List<Terminal> queryByAreaId(String areaId);

	List<Material> getMapData(String terminalId);

	List<Items> getMapDataNew(String terminalId);

	List<Items> queryByItemTid(String terminalId);

	List<Period> findPeriodByTerminalId(String terminalId);
	
}
