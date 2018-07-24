package org.south.itms.dao.impl;

import java.util.List;

import org.south.itms.entity.File;
import org.south.itms.entity.IPTable;
import org.south.itms.entity.PlayTable;

public interface PtableDao {

	PlayTable load(String id);

	int countByName(PlayTable entity);

	String save(PlayTable entity);

	void delete(String id);

	void savePtableFileRelation(String pid, String[] fileIds);

	void delPtableFileRelation(String pid);

	List<PlayTable> findAllPlayTable();

	PlayTable get(String id);

	void modifyPlayTableNum(String pid, String sortNum);

	void updateTableStatus(String pid);
	
	void updateTableStatusFinal(String pid);

	void saveInsertTable(IPTable insertTable);

	void saveTable(IPTable insert);

	void updateTableStatusFinalUn(String pid, String mark);

	void playTableUnAccess(String pid, String statusId);

	List<PlayTable> getTableById(String statusId);

	PlayTable getById(String pid);

	void resetPtableState(String pid);

	List<PlayTable> getTableByTwoId(String statusId1, String statusId2);
	
	
	//7.15
	void modifyPlayTableNumbyDelAll(String ppid, String sortNum);
	


	
}
