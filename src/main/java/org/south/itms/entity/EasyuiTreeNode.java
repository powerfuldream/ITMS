package org.south.itms.entity;

import javax.persistence.Entity;
import javax.persistence.Table;

/**
 * @author: yezilong
 */

public class EasyuiTreeNode implements java.io.Serializable {

	private static final long serialVersionUID = 9116365118453129770L;
	
	private String id;
	private String _parentId;
	private String name;
	

    private String showTerminal;
    private String addTerminal;
    private String editTerminal;
    private String delTerminal;
    private String updateTerminalState;
    
	private String state;

	public EasyuiTreeNode() {
		showTerminal = "showTerminal";
		addTerminal = "addTerminal";
		editTerminal = "editTerminal";
		
	}

	
	
	
	
	
}
