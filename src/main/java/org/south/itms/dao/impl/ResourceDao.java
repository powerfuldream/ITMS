package org.south.itms.dao.impl;

import java.util.List;

import org.south.itms.entity.Resource;

public interface ResourceDao {

	int countByNameOrUrl(Resource entity);

	List<Resource> findAll();

	String save(Resource entity);

	void update(Resource entity);

	void delete(String id);

	List<Resource> findByRoleAndType(String roleId, String resourceType);

	List<Resource> findByType(String resourceType);

	List<Resource> findByRole(String roleId);

	List<Resource> findAllExceptTerminal();

	List<Resource> findByUrlPrefixAndType(String roleId, String urlPrefix, String resourceType);

}
