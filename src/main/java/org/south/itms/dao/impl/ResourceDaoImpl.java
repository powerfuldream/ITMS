package org.south.itms.dao.impl;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.south.itms.entity.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;


/**
 * @author: yezilong
 */

@Repository("resourceDao")  
public class ResourceDaoImpl implements ResourceDao {

    @Autowired  
    private SessionFactory sessionFactory;  
  
    private Session getCurrentSession() {  
        return this.sessionFactory.getCurrentSession();  
    }  
    
    @Override  
    public int countByNameOrUrl(Resource entity) {
    	String hqlString = "select count(*) from Resource where deleted = 0 and (resourceName = :resourceName or resourceUrl = :resourceUrl) and resourceId != :resourceId";  
    	Query query = this.getCurrentSession().createQuery(hqlString);  
    	query.setParameter("resourceName", entity.getResourceName());
    	query.setParameter("resourceUrl", entity.getResourceUrl());
    	query.setParameter("resourceId", entity.getResourceId());
    	return ((Number)query.uniqueResult()).intValue();
    }
    
    
    @Override  
    public List<Resource> findByRoleAndType(String roleId, String resourceType) {  
    	String sql = "select r.* from role_resource rr left join resource r on rr.resource_id = r.resource_id where r.deleted = 0 and rr.deleted = 0 and rr.role_id = :roleId and r.resource_type = :resourceType";
    	return this.getCurrentSession().createNativeQuery(sql, Resource.class).setParameter("roleId", roleId).setParameter("resourceType", resourceType).getResultList();
    }  
    
    
    @Override  
    public List<Resource> findByUrlPrefixAndType(String roleId, String urlPrefix, String resourceType) {  
    	String sql = "select r.* from role_resource rr left join resource r on rr.resource_id = r.resource_id where r.deleted = 0 and rr.deleted = 0 and rr.role_id = :roleId and r.resource_type = :resourceType and r.resource_url like :urlPrefix";
    	return this.getCurrentSession().createNativeQuery(sql, Resource.class).setParameter("roleId", roleId).setParameter("resourceType", resourceType).setParameter("urlPrefix", urlPrefix + "%").getResultList();
    }  
    
    
    
    @Override  
    public List<Resource> findByRole(String roleId) {  
    	String sql = "select r.* from role_resource rr left join resource r on rr.resource_id = r.resource_id where r.deleted = 0 and rr.deleted = 0 and rr.role_id = :roleId";
    	return this.getCurrentSession().createNativeQuery(sql, Resource.class).setParameter("roleId", roleId).getResultList();
    }
    
    
    
    @Override  
    public List<Resource> findByType(String resourceType) {  
    	String hql = "from Resource where deleted = 0 and resourceType = :resourceType";
    	return this.getCurrentSession().createQuery(hql).setParameter("resourceType", resourceType).list();
    }  
  
  
    
    @Override  
    public List<Resource> findAll() {  
        return this.getCurrentSession().createQuery("from Resource where deleted = 0").list();  
    }  
    
    
    @Override  
    public List<Resource> findAllExceptTerminal() {  
        return this.getCurrentSession().createQuery(" from Resource where deleted = 0 and resourceType != 'terminal' ").list();  
    }  
    
    
    
    @Override  
    public String save(Resource entity) {  
    	return (String)this.getCurrentSession().save(entity);
    }  

    
	@Override
	public void update(Resource entity) {
		// TODO Auto-generated method stub
		this.getCurrentSession().update(entity);  
	}  
	
	
	@Override
	public void delete(String id) {
		// TODO Auto-generated method stub
		String hql = "update Resource set deleted = 1 where resourceId=:resourceId";
		this.getCurrentSession().createQuery(hql).setParameter("resourceId", id).executeUpdate();
	}  
	
	
}
