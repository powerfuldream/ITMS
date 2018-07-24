package org.south.itms.dao.impl;

import java.util.List;

import org.south.itms.entity.IPTable;
import org.south.itms.entity.Material;
import org.south.itms.entity.PlayTable;
import org.south.itms.entity.Terminal;

public interface TerminalDao extends GenericDao<Terminal, String> {

	
    List<Terminal> findByArea(String areaName);

	void updateByHQL(String hql);

	Terminal findByCondition(String serialNumber, String connectPassword);

	void setPlayForTerminal(PlayTable playTable, String terminalId);

	int countBySerialNumber(Terminal entity);

	void resetTerminalPtable(String pid);

	List<PlayTable> findByTerminalId(String terminalId);

	List<IPTable> findInsertFile(String terminalId);

	Material getMaterialById(String mid);

	Terminal findBySerial(String serialNumber);

	Terminal findById(String terminalId);

	List<Material> findAllMaterial(String pid);

	List<PlayTable> findInsertByTerminalId(String terminalId);


	
}
