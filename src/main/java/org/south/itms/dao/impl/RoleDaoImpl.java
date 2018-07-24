package org.south.itms.dao.impl;

import java.util.List;
import java.util.UUID;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.south.itms.entity.Resource;
import org.south.itms.entity.Role;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

/**
 * @author: yezilong
 */

@Repository("roleDao")  
public class RoleDaoImpl implements RoleDao{

    @Autowired  
    private SessionFactory sessionFactory;  
  
    private Session getCurrentSession() {  
        return this.sessionFactory.getCurrentSession();  
    }  
    
    
    
    @Override  
    public int countByRoleName(Role entity) {
    	String hqlString = "select count(*) from Role where deleted = 0 and roleName = :roleName and roleId != :roleId";  
    	Query query = this.getCurrentSession().createQuery(hqlString);  
    	query.setParameter("roleName", entity.getRoleName());
    	query.setParameter("roleId", entity.getRoleId());
    	return ((Number)query.uniqueResult()).intValue();
    }
    
    
    
    
    
    @Override  
    public List<Role> findAll() {  
        return this.getCurrentSession().createQuery("from Role where deleted = 0").list();  
    }  
    
    
    @Override  
    public String save(Role entity) {  
    	return (String)this.getCurrentSession().save(entity);
    }  

    
	@Override
	public void delete(String id) {
		// TODO Auto-generated method stub
		String hql = "update Role set deleted = 1 where roleId=:roleId";
		this.getCurrentSession().createQuery(hql).setParameter("roleId", id).executeUpdate();
	}  
	
	
	@Override
	public void delRoleResourceRelation(String roleId, String resourceType) {
		// TODO Auto-generated method stub
		String sql = "delete rr from role_resource rr left join resource r on rr.resource_id = r.resource_id where rr.role_id = :roleId and r.resource_type = :resourceType";
		this.getCurrentSession().createNativeQuery(sql).setParameter("roleId", roleId).setParameter("resourceType", resourceType).executeUpdate();
	}  
	
	
	/*
	@Override
	public void saveRoleResourceRelation(String roleId, String[] resourceIds) {  //使用uuid作为主键，所以废弃
		// TODO Auto-generated method stub
		String sql = "insert into role_resource(role_resource_id, role_id, resource_id, deleted) values (:roleResourceId, :roleId, :resourceId, 0)";
		Query query = this.getCurrentSession().createNativeQuery(sql);
		query.setParameter("roleId", roleId);
		for(String resourceId : resourceIds) {
			query.setParameter("roleResourceId", UUID.randomUUID().toString());
			query.setParameter("resourceId", resourceId);
			query.executeUpdate();
		}
	} 
	*/
	
	@Override
	public void saveRoleResourceRelation(String roleId, String[] resourceIds) {  
		// TODO Auto-generated method stub
		String sql = "insert into role_resource(role_id, resource_id, deleted) values (:roleId, :resourceId, 0)";
		Query query = this.getCurrentSession().createNativeQuery(sql);
		query.setParameter("roleId", roleId);
		for(String resourceId : resourceIds) {
			query.setParameter("resourceId", resourceId);
			query.executeUpdate();
		}
	} 
	
}
