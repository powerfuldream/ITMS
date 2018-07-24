package org.south.itms.dao.impl;

import java.util.List;
import java.util.Map;

import org.south.itms.entity.Resource;
import org.south.itms.entity.User;

public interface UserDao {

	int countUserByAccount(User entity);

	List<User> findAll();

	String save(User entity);

	void delete(String id);

	User getUserByAccountAndPassword(String userAccount, String userPassword);

	int getAccountRecord(int i);

	int getAccountTable(int i);

	Map<String, List<Resource>> getAllResource(String roleId);

	List<Resource> findResourceById(String rid);

	void updateAuthor(String roleId, String authorityList);



}
