package org.south.itms.service.impl;

import java.util.List;

import org.south.itms.entity.PlayTable;

public interface PlayControlService {

	List<PlayTable> findAllPlayTable();

	void setPlayForTerminal(String[] terminalIds, PlayTable playTable);

}
