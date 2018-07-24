package org.south.itms.service.impl;

import java.util.List;

import org.south.itms.entity.Resource;
import org.south.itms.entity.Role;
import org.south.itms.entity.User;

public interface SystemService {

	int countResourceByNameOrUrl(Resource entity);

	List<Resource> findAllResource();

	String saveResource(Resource entity);

	void updateResource(Resource entity);

	void deleteResource(String[] ids);

	List<Role> findAllRole();

	String saveRole(Role entity);

	void deleteRole(String[] ids);

	int countRoleByName(Role entity);

	int countUserByAccount(User entity);

	List<User> findAllUser();

	String saveUser(User entity);

	void deleteUser(String[] ids);

	void buildRoleResourceRelation(String roleId, String resourceType, String[] resourceIds);

	List<Resource> findAllResourceExceptTerminal();

	String[] saveTerminalPowerUrl(String roleId, String[] urls);

	boolean checkPower(List<Resource> resources, String[] urls);
 
}  