package org.south.itms.service.impl;

import java.sql.Timestamp;
import java.util.List;

import org.south.itms.dao.impl.MaterialDao;
import org.south.itms.dto.TreeDate;
import org.south.itms.entity.Items;
import org.south.itms.entity.Material;
import org.south.itms.entity.Terminal;
import org.south.itms.util.TreeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author jan
 * @date 2017年12月16日 下午11:58:53
 * @version V1.0 
 */
@Service("materialService")
public class MaterialServiceImpl implements MaterialService {

	@Autowired
	private MaterialDao materialDao;
	
	@Override
	public boolean checkFileName(String fileName) {
		return materialDao.checkFileName(fileName);
	}

	@Override
	public void saveFile(Material material) {
		materialDao.saveFile(material);
	}

	@Override
	public List<TreeDate> getAllTreeData() {
		List<Terminal> list = materialDao.getAllTerminal();
		List<TreeDate> listTree = TreeUtil.getTreeDate(list);
		return listTree;
	}

	@Override
	public Material checkMaterial(String mid) {
		return materialDao.checkMaterial(mid);
	}

	@Override
	public Terminal getTerminalInfo(String terminalId) {
		return materialDao.getTerminalInfo(terminalId);
	}

	@Override
	public void checkAccess(String mid, String name, Timestamp timestamp) {
		materialDao.checkAccess(mid, name, timestamp);
	}

	@Override
	public void checkUnAccess(String mid, String name, Timestamp timestamp) {
		materialDao.checkUnAccess(mid, name, timestamp);
	}

	@Override
	public int getAllRecord(String str) {
		return materialDao.getAllRecord(str);
	}
	
	
	@Override
	public int getAllRecord2(String str) {
		return materialDao.getAllRecord2(str);
	}

	@Override
	public Material getById(String mid) {
		return materialDao.getById(mid);
	}

	@Override
	public void updateMaterial(Material material) {
		materialDao.updateMaterial(material);
	}

	@Override
	public void delFile(String[] mid) {
		for(String id:mid) {
			materialDao.delMaterial(id);
			//已经被删除的素材, 其对应的节目需要提示素材已被删除
			materialDao.updateItemDelMsg(id);
		}
	}
	
	
	@Override
	public void delFile2(String[] mid) {
		for(String id:mid) {
			if(materialDao.delMaterial2(id) == 1) {
				//已经被删除的素材, 其对应的节目需要提示素材已被删除
				materialDao.updateItemDelMsg(id);
			}
		}
	}

	

	@Override
	public int getExcepTaable() {
//		int num1 = materialDao.getExcepTable("5");
//		int num2 = materialDao.getExcepTable("7");
//		return num1 + num2;ur
		return materialDao.getExcepTable("5", "7");
	}

	@Override
	public int getExcepTaableMaterial() {
//		int num1 = materialDao.getExcepTable("6");
//		int num2 = materialDao.getExcepTable("7");
//		return num1 + num2;
		return materialDao.getExcepTable("6", "7");
	}
	
	@Override
	public int getFirstCheckTable() {
		return materialDao.getExcepTable("1");
	}
	
	@Override
	public int getSecondCheckTable() {
		return materialDao.getExcepTable("2");
	}
	
	

	@Override
	public void tidMaterial(String[] tid) {
		for(String m : tid) {
			System.out.println(m);
			String[] mt = m.split("-");
			materialDao.tidMaterial(mt[0], mt[1]);
		}
	}

	@Override
	public void saveItem(Items item) {
		materialDao.saveItem(item);
	}

	@Override
	public void resetMaterial(String mid) {
		materialDao.resetMaterial(mid);
	}
	
	
	@Override
	public List<Material> findMaterialByPtable(String pid) {
		return materialDao.findMaterialByPtable(pid);
	}
	
	@Override
	public List<Items> findItemByPtable(String pid) {
		return materialDao.findItemByPtable(pid);
	}
	

}
