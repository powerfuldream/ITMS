package org.south.itms.dao.impl;

import java.util.List;

import org.south.itms.entity.Resource;
import org.south.itms.entity.Role;

public interface RoleDao {


	List<Role> findAll();

	String save(Role entity);

	void delete(String id);

	int countByRoleName(Role entity);

	void delRoleResourceRelation(String roleId, String resourceType);

	void saveRoleResourceRelation(String roleId, String[] resourceIds);

}
