package org.south.itms.service.impl;

import java.util.List;

import org.south.itms.entity.IPTable;
import org.south.itms.entity.PlayTable;

public interface PtableService {


	void buildPtableFileRelation(String pid, String[] fileIds);

	int countByName(PlayTable entity);

	void deletePtable(String[] ids);

	void modifyPlayTableNum(String pid, String sortNum);

	void updateTableStatusFinal(String pid);

	void updateTableStatus(String pid);

	void saveInsertTable(IPTable insert);

	void updateTableStatus(String pid, String statusId);

	void updateTableStatusFinalUn(String pid, String mark);

	void playTableUnAccess(String pid, String string);

	List<PlayTable> getTableById(String string);

	List<PlayTable> getTableByTwoId(String statusId1, String statusId2);
	
	//7.15
	void modifyPlayTableNumbyDelAll(String ppid, String sortNum);

 
}  