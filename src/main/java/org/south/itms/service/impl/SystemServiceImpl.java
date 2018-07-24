package org.south.itms.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.south.itms.dao.impl.ResourceDao;
import org.south.itms.dao.impl.RoleDao;
import org.south.itms.dao.impl.UserDao;
import org.south.itms.dto.Result;
import org.south.itms.entity.Resource;
import org.south.itms.entity.Role;
import org.south.itms.entity.User;
import org.south.itms.util.Constant;
import org.south.itms.util.StringUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;  

/**
 * @author: yezilong
 */

@Service("systemService")  
public class SystemServiceImpl implements SystemService {  
   

	@Autowired
	private ResourceDao resourceDao;
	
	
	@Autowired
	private RoleDao roleDao;
	
	
	@Autowired
	private UserDao userDao;
	
	
	
	@Override
	public boolean checkPower(List<Resource> resources, String[] urls) { //检查用户的权限, 即检查urls 是否都存在 resource。getResourceUrl() 路径中
		if(urls == null) return true;
		if(resources.size() == 0) return false;
		for(String url : urls) {
			int i;
			for(i = 0; i < resources.size(); i++) {
				if(resources.get(i).getResourceUrl().contains(url)) break;
			}
			if(i == resources.size()) return false;
		}
		return true;
	}
	
	
	@Override
	public int countResourceByNameOrUrl(Resource entity) {
		return resourceDao.countByNameOrUrl(entity);
	}

	@Override
	public List<Resource> findAllResource() {
	   return resourceDao.findAll();
	}
	
	@Override
	public List<Resource> findAllResourceExceptTerminal() {
	   return resourceDao.findAllExceptTerminal();
	}
	

	@Transactional
	@Override
	public String saveResource(Resource entity) {
	    return resourceDao.save(entity);
	}

	@Transactional
	@Override
	public void updateResource(Resource entity) {
		// TODO Auto-generated method stub
		resourceDao.update(entity);  
	}  
	
	@Transactional
	@Override
	public void deleteResource(String[] ids) {
		// TODO Auto-generated method stub
		for(String id : ids) {
			resourceDao.delete(id);
		}
	}  
	
	
	
	@Override
	public int countRoleByName(Role entity) {
		return roleDao.countByRoleName(entity);
	}


	@Override
	public List<Role> findAllRole() {
	   return roleDao.findAll();
	}

	@Transactional
	@Override
	public String saveRole(Role entity) {
	    return roleDao.save(entity);
	}

	
	@Transactional
	@Override
	public void deleteRole(String[] ids) {
		// TODO Auto-generated method stub
		for(String id : ids) {
			roleDao.delete(id);
		}
	}  
	
	


	@Override
	public int countUserByAccount(User entity) {
		return userDao.countUserByAccount(entity);
	}


	@Override
	public List<User> findAllUser() {
	   return userDao.findAll();
	}

	@Transactional
	@Override
	public String saveUser(User entity) {
	    return userDao.save(entity);
	}

	
	@Transactional
	@Override
	public void deleteUser(String[] ids) {
		// TODO Auto-generated method stub
		for(String id : ids) {
			userDao.delete(id);
		}
	}  
	
	
	@Transactional
	@Override
	public void buildRoleResourceRelation(String roleId, String resourceType, String[] resourceIds) {
		  //先将原先的角色资源关系删除
		  roleDao.delRoleResourceRelation(roleId, resourceType);
		  
		  //再添加角色和资源的信息
		  if(resourceIds != null) roleDao.saveRoleResourceRelation(roleId, resourceIds);
	}  
	
	
	
	@Transactional
	@Override
	public String[] saveTerminalPowerUrl(String roleId, String[] urls) {  
		List<String> resourceIdList = new ArrayList<>(); //收集需要关联的资源主键
		if(urls != null) {
          //先从数据库获取所有的资源,判断url是否已经在数据库,不存在对应的url就插入数据库资源表
		  List<Resource> resources = resourceDao.findByType(Constant.terminalResourceType);
		  for(String url : urls) {  
			  boolean find = false;
			  for(Resource resource : resources) {
				  if(url.equals(resource.getResourceUrl())) {
					  find = true;
					  resourceIdList.add(resource.getResourceId());
					  break;
				  }
			  }
			  if(find == false) { //不存在url对应的url就插入数据库
				  Resource resource = new Resource();
				  //resource.setResourceId(UUID.randomUUID().toString());
				  resource.setResourceName("");
				  resource.setResourceUrl(url);
				  resource.setResourceType(Constant.terminalResourceType);
				  resource.setDeleted(0);
				  resourceDao.save(resource);
				  resourceIdList.add(resource.getResourceId());
			  }
		  }
		  
		}
		
		
	    //将 list 转成  数组
	    String[] resourceIds = null;
		if(resourceIdList.size() > 0)  {
			resourceIds = new String[resourceIdList.size()];
			resourceIdList.toArray(resourceIds);
		}

		return resourceIds;
	}  
	
	
	
	
}  