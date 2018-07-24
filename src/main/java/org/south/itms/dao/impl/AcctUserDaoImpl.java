package org.south.itms.dao.impl;


import java.util.List;  
import org.hibernate.Session;  
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.south.itms.entity.AcctUser;
import org.south.itms.entity.User;
import org.springframework.beans.factory.annotation.Autowired;  
import org.springframework.stereotype.Repository;  
  
/**
 * @author: yezilong
 */
@Repository("acctUserDao")  
public class AcctUserDaoImpl implements AcctUserDao {  
  
    @Autowired  
    private SessionFactory sessionFactory;  
  
    private Session getCurrentSession() {  
        return this.sessionFactory.getCurrentSession();  
    }  
  
    @Override  
    public AcctUser load(String id) {  
        return (AcctUser) this.getCurrentSession().load(AcctUser.class, id);  
    }  
      
    @Override  
    public AcctUser get(String id) {  
        return (AcctUser) this.getCurrentSession().get(AcctUser.class, id);  
    }  
  
    @SuppressWarnings("unchecked")  
    @Override  
    public List<AcctUser> findAll() {  
        List<AcctUser> acctUsers = this.getCurrentSession().createQuery("from AcctUser").setCacheable(true).list();  
        return acctUsers;  
    }  
  
    @Override  
    public void persist(AcctUser entity) {  
        this.getCurrentSession().persist(entity);  
  
    }  
  
    @Override  
    public String save(AcctUser entity) {  
    	System.out.println("====save=======");
        return (String) this.getCurrentSession().save(entity);  
    }  
  
    @Override  
    public void saveOrUpdate(AcctUser entity) {  
        this.getCurrentSession().saveOrUpdate(entity);  
    }  
  
    @Override  
    public void delete(String id) {  
        AcctUser entity = this.load(id);  
        this.getCurrentSession().delete(entity);  
    }  
  
    @Override  
    public void flush() {  
        this.getCurrentSession().flush();  
  
    }

	@Override
	public void update(AcctUser entity) {
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see org.south.itms.dao.impl.AcctUserDao#getAllUser()
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public List<User> getAllUser() {
		String hql = "from User where deleted = 0";
		Query query = this.getCurrentSession().createQuery(hql);
		List<User> list = query.list();
		return list;
	}  
    
    
    
  
}  