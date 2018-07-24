package org.south.itms.dao.impl;

import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

import org.south.itms.dto.Page;
import org.south.itms.dto.ValueParam;
import org.south.itms.entity.File;
import org.south.itms.entity.IPTable;
import org.south.itms.entity.Items;
import org.south.itms.entity.Material;
import org.south.itms.entity.Period;
import org.south.itms.entity.PlayTable;
import org.south.itms.entity.Terminal;
import org.south.itms.entity.User;

public interface CommonDao {

	void updateByHQL(String hql);

	void updateByTemplateHQL(String hql, Map<String, String> paramMap, Map<String, String> whereMap);

	List searchByTemplateHQL(String hql, Map<String, ValueParam> whereMap);

	Page pageSearchByTemplateHQL(String hql, Map<String, ValueParam> whereMap, int currentPage, int pageSize);
	Page pageSearchByTemplateHQL(String start, String end, String hql, Map<String, ValueParam> whereMap, int currentPage, int pageSize);
	Page pageSearchPtableByTemplateHQL(String start, String end, String hql, Map<String, ValueParam> whereMap, int currentPage, int pageSize);
	
	Page pageSearchMaterialByTemplateHQL(String hql, Map<String, ValueParam> whereMap, int currentPage, int pageSize);

	void saveVideoFile(File upload);

	void delFile(String s);

	void editFile(String fId, String newFilePath, String name);

	boolean queryByName(String fileName);

	void updateByName(String fId, String name, int fre, String terId);

	List<Terminal> getAllTerminal();

	Page pageSearchCheckByTemplateHQL(String hql, Map<String, ValueParam> whereMap, int currentPage, int pageSize);
	
	Page pageSearchInsertByTemplateHQL(String hql, Map<String, ValueParam> whereMap, int currentPage, int pageSize);

	/**
	 * @param fileId
	 * @param timestamp 
	 * @param name 
	 */
	void firstCheckFile(String fileId, String name, Timestamp timestamp);

	/**
	 * @param fileId
	 * @param timestamp 
	 * @param name 
	 */
	void firstUncheckFile(String fileId, String name, Timestamp timestamp);

	Page pageSearchCheckFinalByTemplateHQL(String hql, Map<String, ValueParam> whereMap, int currentPage, int pageSize);

	/**
	 * @param fileId
	 * @param timestamp 
	 * @param name 
	 */
	void secondCheckFile(String fileId, String name, Timestamp timestamp);

	/**
	 * @return
	 */
	List<Period> getAllPeriod();

	/**
	 * @param materialName
	 * @return
	 */
	boolean queryByMaterialName(String materialName);

	/**
	 * @param fileId
	 * @return
	 */
	Material queryById(String mid);

	/**
	 * @param map
	 */
	void updateFile(Material map);

	void saveInsertTable(IPTable insertTable);

	List<IPTable> getAllIPTable(String terminalId);

	Page pageSearchByAreaCode(String areaCode, int currentPage, int pageSize);

	List<Material> getAllMaterialByTid(String tid);

	Period getPeriodById(String s);

	List<Material> getTerminalByPid(String periodId);

	void updatePeriodById(String periodId);

	Material getMaterialByMid(String mid);

	List<User> getAllUser();

	List<IPTable> getAllIPTableNo();

	Terminal getTerminalById(String terminalId);

	Page pageSearchByTid(String tid, int page, int limit);

	Items queryByItemId(String itemId);

	void updateItem(Items items);

	List<Items> getAllItemsPeriod(String tid);

	List<Items> getItemsByPid(String periodId);

	void resetPtableState(String pid);

	void saveInsetPlayTable(PlayTable ptable, String mid);

	void deleteItem(String id);
	
	//7.14
	boolean copyOneToPlayFile(String pid, String mid,int num);
	
	//7.15
    boolean delOneFromPlayFile(String pid, String mid, int num);

}
