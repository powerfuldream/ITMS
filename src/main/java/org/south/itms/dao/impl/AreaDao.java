package org.south.itms.dao.impl;

import java.util.List;

import org.south.itms.entity.Area;

public interface AreaDao extends GenericDao<Area, String> {

	List<Area> findInTerminalTable();

}
