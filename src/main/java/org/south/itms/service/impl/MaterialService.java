package org.south.itms.service.impl;

import java.sql.Timestamp;
import java.util.List;

import org.south.itms.dto.TreeDate;
import org.south.itms.entity.Items;
import org.south.itms.entity.Material;
import org.south.itms.entity.Terminal;

/**
 * @author jan
 * @date 2017年12月16日 下午11:58:26
 * @version V1.0 
 */
public interface MaterialService {

	boolean checkFileName(String fileName);

	void saveFile(Material material);

	List<TreeDate> getAllTreeData();

	Material checkMaterial(String mid);

	Terminal getTerminalInfo(String terminalId);

	void checkAccess(String mid, String name, Timestamp timestamp);

	void checkUnAccess(String mid, String name, Timestamp timestamp);

	int getAllRecord(String string);

	Material getById(String mid);

	void updateMaterial(Material material);

	void delFile(String[] mid);

	int getExcepTaable();

	int getExcepTaableMaterial();

	void tidMaterial(String[] tid);

	void saveItem(Items item);

	void resetMaterial(String mid);

	int getAllRecord2(String str);

	List<Material> findMaterialByPtable(String pid);

	List<Items> findItemByPtable(String pid);

	int getFirstCheckTable();

	int getSecondCheckTable();

	void delFile2(String[] mid);

}
