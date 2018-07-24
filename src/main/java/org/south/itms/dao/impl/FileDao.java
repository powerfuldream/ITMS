package org.south.itms.dao.impl;

import java.util.List;

import org.south.itms.entity.File;
import org.south.itms.entity.Material;
import org.south.itms.entity.Period;
import org.south.itms.entity.PlayTable;

public interface FileDao {

	

	List<Material> findByPtable(String pid);

	File get(String id);

	File load(String id);
	
	List<File> getAllFile();

	List<PlayTable> findByTerminalId(String terminalId);

	Period findByPeriod(String periodId);

	Material getById(String mid);

	File get2(String id);


	
}
