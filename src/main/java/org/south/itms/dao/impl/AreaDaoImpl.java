package org.south.itms.dao.impl;

import java.util.List;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.south.itms.entity.Area;
import org.south.itms.entity.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

/**
 * @author: yezilong
 */

@Repository("areaDao")  
public class AreaDaoImpl implements AreaDao {

    @Autowired  
    private SessionFactory sessionFactory;  
  
    private Session getCurrentSession() {  
        return this.sessionFactory.getCurrentSession();  
    }  
  
    @Override  
    public Area load(String id) {  
        return (Area) this.getCurrentSession().load(Area.class, id);  
    }  
      
    @Override  
    public Area get(String id) {  
        return (Area) this.getCurrentSession().get(Area.class, id);  
    }  
  
   
    @Override  
    public List<Area> findAll() {  
        List<Area> Areas = this.getCurrentSession().createQuery("from Area where deleted = 0").list();  
        return Areas;  
    }  
    
    
    @Override  
    public List<Area> findInTerminalTable() {  //获取在终端表出现的地区
    	String sql = "select a.*, count(distinct a.code) from terminal t left join sys_area a on t.area_code = a.code where t.deleted = 0 and a.deleted = 0 group by a.code";
    	return this.getCurrentSession().createNativeQuery(sql, Area.class).getResultList();
    }  
    
  
    @Override  
    public void persist(Area entity) {  
        this.getCurrentSession().persist(entity);  
  
    }  
  
    @Override  
    public String save(Area entity) {  
        return (String) this.getCurrentSession().save(entity);  
    }  
  
    @Override  
    public void saveOrUpdate(Area entity) {  
        this.getCurrentSession().saveOrUpdate(entity);  
    }  
  
    @Override  
    public void delete(String id) {  
        Area entity = this.load(id);  
        this.getCurrentSession().delete(entity);  
    }  
  
    @Override  
    public void flush() {  
        this.getCurrentSession().flush();  
  
    }

	@Override
	public void update(Area entity) {
		// TODO Auto-generated method stub
		
	}  
  
    
    
    

}
