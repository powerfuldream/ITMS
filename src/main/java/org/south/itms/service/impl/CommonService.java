package org.south.itms.service.impl;

import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

import org.south.itms.entity.File;
import org.south.itms.entity.IPTable;
import org.south.itms.entity.Items;
import org.south.itms.entity.Material;
import org.south.itms.entity.Period;
import org.south.itms.entity.PlayTable;
import org.south.itms.dto.Page;
import org.south.itms.entity.Terminal;
import org.south.itms.entity.User;

public interface CommonService {

	void updateByHQL(String hql);

	void updateByTemplateHQL(String hql, Map<String, String> paramMap, Map<String, String> whereMap);

	Page pageSearchByTemplateHQL(String[] params, int currentPage, int pageSize, String className, String orderBy, String whereSuffix);
	Page pageSearchByTemplateHQL(String start, String end, String[] params, int currentPage, int pageSize, String className, String orderBy, String whereSuffix);
	Page pageSearchPtableByTemplateHQL(String start, String end, String[] params, int currentPage, int pageSize, String className, String orderBy, String whereSuffix);
	
	Page pageSearchMaterialByTemplateHQL(String[] params, int currentPage, int pageSize, String className, String orderBy, String whereSuffix);
	
	Page pageSearchByTemplateHQLTree(String[] params, int currentPage, int pageSize, String className, String orderBy, String whereSuffix);

	Page pageSearchFirstByTemplateHQL(String[] params, int currentPage, int pageSize, String className, String orderBy, String whereSuffix);
	
	Page pageSearchInsertByTemplateHQL(String[] params, int currentPage, int pageSize, String className, String orderBy, String whereSuffix);

	Page pageSearchSecondByTemplateHQL(String[] params, int currentPage, int pageSize, String className, String orderBy, String whereSuffix);
    //7.16
	Page pageSearchByTemplateHQL(String[] params, String alreadymid,int currentPage, int pageSize, String className, String orderBy, String whereSuffix);
	void saveVideoFile(org.south.itms.entity.File upload);

	void delFile(String[] fileId);

	void editFile(String fId, String newFilePath, String name);

	boolean queryByName(String fileName);

	void updateByName(String fId, String name, int fre, String terId);

	List<Terminal> getAllTerminal();

	Page pageSearchCheckByTemplateHQL(String[] params, int currentPage, int pageSize, String className, String orderBy, String whereSuffix);

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

	Page pageSearchCheckFinalByTemplateHQL(String[] params, int currentPage, int pageSize, String className, String orderBy, String whereSuffix);

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

	List<Period> getAllMaterialByTid(String string);

	boolean generateTable(String periodId, String uid);

	Page searchMaterialByPid(String string, int currentPage, int pageSize);

	List<User> getAllUser();

	List<IPTable> getAllIPTableNo();

	Terminal getTerminalById(String substring);

	Page pageSearchByTid(String tid, int page, int limit);

	Items queryByItemId(String mid);

	void updateItem(Items file);

	List<Period> getAllItemsPeriod(String string);

	boolean generateTb(String periodId, String uid, String startDate, String endDate);

	void resetPtableState(String pid);

	void saveInsetPlayTable(PlayTable ptable, String mid);

	void deleteItems(String[] itemIds);
	
	//7.14
    boolean copyOneToPlayFile(String pid, String mid,int num);
    
    //7.15
    boolean delOneFromPlayFile(String pid, String mid,int num);

 
}  