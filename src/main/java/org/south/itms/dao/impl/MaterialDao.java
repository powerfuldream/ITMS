package org.south.itms.dao.impl;

import java.sql.Timestamp;
import java.util.List;


import org.south.itms.entity.Items;
import org.south.itms.entity.Material;
import org.south.itms.entity.Terminal;

/**
 * @author jan
 * @date 2017年12月17日 下午5:13:30
 * @version V1.0 
 */
public interface MaterialDao {

	boolean checkFileName(String fileName);

	void saveFile(Material material);

	List<Terminal> getAllTerminal();

	Terminal getTerminalInfo(String terminalId);

	Material checkMaterial(String mid);

	void checkAccess(String mid, String name, Timestamp timestamp);

	void checkUnAccess(String mid, String name, Timestamp timestamp);

	int getAllRecord(String str);

	Material getById(String mid);

	void updateMaterial(Material material);

	void delMaterial(String id);

	int getExcepTable(String statusId);

	void tidMaterial(String string, String string2);

	void saveItem(Items item);

	List<Items> findByPtable(String pid);

	void resetMaterial(String mid);

	int getAllRecord2(String str);

	List<Material> findMaterialByPtable(String pid);

	List<Items> findItemByPtable(String pid);

	int getExcepTable(String statusId1, String statusId2);

	int delMaterial2(String id);

	int updateItemDelMsg(String id);
	
	//7.16
	List<Items> findalreadyItemByPtable(String pid);
}
