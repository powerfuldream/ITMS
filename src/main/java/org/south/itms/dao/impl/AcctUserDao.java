package org.south.itms.dao.impl;

import java.util.List;

import org.south.itms.entity.AcctUser;
import org.south.itms.entity.User;

public interface AcctUserDao extends GenericDao<AcctUser, String> {

	/**
	 * @return
	 */
	List<User> getAllUser();  
	  
}  