package org.south.itms.service.impl;

import java.util.List;

import org.south.itms.dao.impl.PtableDao;
import org.south.itms.entity.IPTable;
import org.south.itms.entity.PlayTable;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * @author: yezilong
 */

@Service("ptableService")  
public class PtableServiceImpl implements PtableService {

	@Autowired
	private PtableDao ptableDao;
	

	@Transactional
	@Override
	public void buildPtableFileRelation(String pid, String[] fileIds) {
		// TODO Auto-generated method stub
		  //先将原先的播放表和视频文件关系删除
		  ptableDao.delPtableFileRelation(pid);
		  
		  //再添加播放表和视频文件的关联
		  if(fileIds != null) ptableDao.savePtableFileRelation(pid, fileIds);
	}
	
	
	@Override  
    public int countByName(PlayTable entity) {
		return ptableDao.countByName(entity);
	}

	
	@Transactional
	@Override
	public void deletePtable(String[] ids) {
		// TODO Auto-generated method stub
		for(String id : ids) {
			ptableDao.delete(id);
		}
	}


	@Override
	public void modifyPlayTableNum(String pid, String sortNum) {
		ptableDao.modifyPlayTableNum(pid, sortNum);
	}


	@Override
	public void updateTableStatusFinal(String pid) {
		ptableDao.updateTableStatusFinal(pid);
	}


	@Override
	public void updateTableStatus(String pid) {
		ptableDao.updateTableStatus(pid);
	}


	@Override
	public void saveInsertTable(IPTable insert) {
		ptableDao.saveInsertTable(insert);
	}


	@Override
	public void updateTableStatus(String pid, String statusId) {
		
	}


	@Override
	public void updateTableStatusFinalUn(String pid, String mark) {
		ptableDao.updateTableStatusFinalUn(pid, mark);
	}


	@Override
	public void playTableUnAccess(String pid, String statusId) {
		ptableDao.playTableUnAccess(pid, statusId);
	}


	@Override
	public List<PlayTable> getTableById(String statusId) {
		return ptableDao.getTableById(statusId);
	}  
	
	@Override
	public List<PlayTable> getTableByTwoId(String statusId1, String statusId2) {
		return ptableDao.getTableByTwoId(statusId1, statusId2);
	}

	//7.15
	@Override
	public void modifyPlayTableNumbyDelAll(String ppid, String sortNum) {
		// TODO Auto-generated method stub
		ptableDao.modifyPlayTableNumbyDelAll(ppid, sortNum);
	}  
	
	
	
}
