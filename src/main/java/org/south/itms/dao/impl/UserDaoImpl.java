package org.south.itms.dao.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.south.itms.entity.File;
import org.south.itms.entity.Material;
import org.south.itms.entity.Resource;
import org.south.itms.entity.Role;
import org.south.itms.entity.User;
import org.south.itms.util.SqlUpdate;
import org.south.itms.util.TreeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

/**
 * @author: yezilong
 */

@Repository("userDao")  
public class UserDaoImpl implements UserDao{

    @Autowired  
    private SessionFactory sessionFactory;  
  
    private Session getCurrentSession() {  
        return this.sessionFactory.getCurrentSession();  
    }  
    
    private Session openSession() {  
        return this.sessionFactory.openSession();  
    }    
    
  //关闭Session
    private void closeSession(Session session){
        if(null != session){
            session.close();
        }
    }
    
    @Override  
    public int countUserByAccount(User entity) {
    	String hqlString = "select count(*) from User where deleted = 0 and userAccount = :userAccount and userId != :userId";  
    	Query query = this.getCurrentSession().createQuery(hqlString);  
    	query.setParameter("userAccount", entity.getUserAccount());
    	query.setParameter("userId", entity.getUserId());
    	return ((Number)query.uniqueResult()).intValue();
    }
    
    
    
    @Override  
    public List<User> findAll() {  
        return this.getCurrentSession().createQuery("from User where deleted = 0").list();  
    }  
    
    
    @Override  
    public String save(User entity) {  
    	return (String)this.getCurrentSession().save(entity);
    }  

    
	@Override
	public void delete(String id) {
		String hql = "update User set deleted = 1 where userId=:userId";
		this.getCurrentSession().createQuery(hql).setParameter("userId", id).executeUpdate();
	}  
	
	
    @Override  
    public User getUserByAccountAndPassword(String userAccount, String userPassword) {  
    	String hql = "from User where userAccount = :userAccount and userPassword = :userPassword and deleted = 0";
    	return this.getCurrentSession().createQuery(hql, User.class).setParameter("userAccount", userAccount).setParameter("userPassword", userPassword).uniqueResult();
    }



	/* (non-Javadoc)
	 * @see org.south.itms.dao.impl.UserDao#getAccountRecord(int)
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public int getAccountRecord(int i) {
		String hql = "from Material where statusId = ? and deleted = ?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, "" + i);
		query.setParameter(1, 0);
		List<File> list = query.list();
		return list.size();
	}



	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public int getAccountTable(int i) {
		String hql = "from PlayTable where statusId = ? and deleted = ?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, "" + i);
		query.setParameter(1, 0);
		List<File> list = query.list();
		return list.size();
	}



	@Override
	public Map<String, List<Resource>> getAllResource(String roleId) {
		Session session = openSession();
		List<Resource> list = new ArrayList<Resource>();
        try {
        	String sql = "select r.* from role_resource rr left join resource r on rr.resource_id = r.resource_id where r.deleted = 0 and rr.deleted = 0 and rr.role_id = :roleId";
        	list = session.createNativeQuery(sql, Resource.class).setParameter("roleId", roleId).getResultList();
        } finally {
            closeSession(session);
        }
        
        Map<String, List<Resource>> map = TreeUtil.getAllMap(list);
        return map;
	}

	@Override
	public List<Resource> findResourceById(String rid) {
		Session session = openSession();
		List<Resource> list = new ArrayList<Resource>();
        try {
        	String sql = "select r.* from role_resource rr left join resource r on rr.resource_id = r.resource_id where r.deleted = 0 and rr.deleted = 0 and rr.role_id = :roleId";
        	list = session.createNativeQuery(sql, Resource.class).setParameter("roleId", rid).getResultList();
        } finally {
            closeSession(session);
        }
		return list;
	}

	@Override
	public void updateAuthor(String roleId, String authorityList) {
		SqlUpdate update = new SqlUpdate();
		update.updateResource(roleId, authorityList);
	}
	
	
}
