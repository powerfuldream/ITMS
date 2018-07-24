package org.south.itms.dao.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.south.itms.entity.IPTable;
import org.south.itms.entity.Material;
import org.south.itms.entity.PlayTable;
import org.south.itms.entity.Terminal;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;


/**
 * @author: yezilong
 */

@Repository("terminalDao")  
public class TerminalDaoImpl implements TerminalDao {

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
    public int countBySerialNumber(Terminal entity) {
    	String hqlString = "select count(*) from Terminal where deleted = 0 and serialNumber = :serialNumber and terminalId != :terminalId";  
    	Query query = this.getCurrentSession().createQuery(hqlString);  
    	query.setParameter("serialNumber", entity.getSerialNumber());
    	query.setParameter("terminalId", entity.getTerminalId());
    	return ((Number)query.uniqueResult()).intValue();
    }
    
    
    
    @Override  
    public Terminal load(String id) {  
        return (Terminal) this.getCurrentSession().load(Terminal.class, id);  
    }  
      
    @Override  
    public Terminal get(String id) {  
        return (Terminal) this.getCurrentSession().get(Terminal.class, id);  
    }  
  
   
    @Override  
    public List<Terminal> findAll() {  
        List<Terminal> Terminals = this.getCurrentSession().createQuery("from Terminal where deleted = 0").list();  
        return Terminals;  
    }  
    
    @Override  
    public List<Terminal> findByArea(String areaName) {  
        String hql = "from Terminal where deleted = 0 and areaName like :areaName order by areaCode asc";
        List<Terminal> Terminals = this.getCurrentSession().createQuery(hql, Terminal.class).setParameter("areaName", "%" + areaName + "%").getResultList();
        return Terminals;  
    }  
    
    
    @Override  
    public Terminal findByCondition(String serialNumber, String connectPassword) {  
    	Session session = openSession();
        List<Terminal> Terminals = session.createQuery("from Terminal where deleted = 0 and state = '激活' and serialNumber = :serialNumber and connectPassword = :connectPassword").setParameter("serialNumber", serialNumber).setParameter("connectPassword", connectPassword).getResultList(); 
        closeSession(session);
        if(Terminals.size() == 0) {
        	return null;
        } else {
        	return Terminals.get(0);
        }
    }
    
    
  
    @Override  
    public void persist(Terminal entity) {  
        this.getCurrentSession().persist(entity);  
  
    }  
  
    @Override  
    public String save(Terminal entity) {  
//    	Session session = this.getCurrentSession();
//    	session.beginTransaction();//这是开启Transaction的操作
//    	session.save(entity);  
//    	session.getTransaction().commit();//此处才是真正与数据库交互的语句
//    	return "ok";
    	return (String)this.getCurrentSession().save(entity);
    }  
  
    @Override  
    public void saveOrUpdate(Terminal entity) {  
        this.getCurrentSession().saveOrUpdate(entity);  
    }  
  
    @Override  
    public void delete(String id) {  
        Terminal entity = this.load(id);  
        this.getCurrentSession().delete(entity);  
    }  
  
    @Override  
    public void flush() {  
        this.getCurrentSession().flush();  
  
    }

   
	@Override
	public void update(Terminal entity) {
		// TODO Auto-generated method stub
		this.getCurrentSession().update(entity);  
	}  
  
	
	@Override
	public void updateByHQL(String hql) {
		// TODO Auto-generated method stub
		this.getCurrentSession().createQuery(hql).executeUpdate();  
	}  
    
    
    @Override  
    public void setPlayForTerminal(PlayTable playTable, String terminalId) {  
    	String hql = "update Terminal set pid = :pid where terminalId = :terminalId";
		this.getCurrentSession().createQuery(hql).setParameter("pid", playTable.getPid()).setParameter("terminalId", terminalId).executeUpdate();
    }  

    @Override  
    public void resetTerminalPtable(String pid) {  
    	String hql = "update Terminal set pname = '', pid = '-1' where pid=:pid";
		this.getCurrentSession().createQuery(hql).setParameter("pid", pid).executeUpdate();
    }
    
    @Override
	public List<PlayTable> findInsertByTerminalId(String terminalId) {
//		String hql = "from PlayTable where terminalId = ? and deleted = ? and playDate = ? and statusId = ?";
//		Query query = this.getCurrentSession().createQuery(hql);
//		query.setParameter(0, terminalId);
//		query.setParameter(1, 0);
//		java.sql.Date sqlDate = new java.sql.Date(new Date().getTime());
//		System.out.println(sqlDate);
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		Date d = null;
		try {
			d = df.parse(df.format(new Date()));
		} catch (ParseException e) {
			e.printStackTrace();
		}
//		query.setParameter(2, d);
//		query.setParameter(3, "3");
//		return query.list();
		
		Session session = openSession();
        List<PlayTable> list = session.createQuery("from PlayTable where deleted = 0 and terminalId = :terminalId and playDate = :playDate and insertFlag = :insertFlag and statusId = :statusId")
        		.setParameter("terminalId", terminalId)
        		.setParameter("playDate", d)
        		.setParameter("insertFlag", 1)
        		.setParameter("statusId", "3")
        		.getResultList(); 
        closeSession(session);
        return list;
	}

	@Override
	public List<PlayTable> findByTerminalId(String terminalId) {
//		String hql = "from PlayTable where terminalId = ? and deleted = ? and playDate = ? and statusId = ?";
//		Query query = this.getCurrentSession().createQuery(hql);
//		query.setParameter(0, terminalId);
//		query.setParameter(1, 0);
//		java.sql.Date sqlDate = new java.sql.Date(new Date().getTime());
//		System.out.println(sqlDate);
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		Date d = null;
		try {
			d = df.parse(df.format(new Date()));
		} catch (ParseException e) {
			e.printStackTrace();
		}
//		query.setParameter(2, d);
//		query.setParameter(3, "3");
//		return query.list();
		
		Session session = openSession();
        List<PlayTable> list = session.createQuery("from PlayTable where deleted = 0 and terminalId = :terminalId and playDate = :playDate and statusId = :statusId")
        		.setParameter("terminalId", terminalId)
        		.setParameter("playDate", d)
        		.setParameter("statusId", "3")
        		.getResultList(); 
        closeSession(session);
        return list;
	}

	@Override
	public List<IPTable> findInsertFile(String terminalId) {
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		Date d = null;
		try {
			d = df.parse(df.format(new Date()));
		} catch (ParseException e) {
			e.printStackTrace();
		}

		Session session = openSession();
        List<IPTable> list = session.createQuery("from IPTable where deleted = 0 and terminalId = :terminalId and insertDate = :insertDate")
        		.setParameter("terminalId", terminalId)
        		.setParameter("insertDate", d)
        		.getResultList(); 
        closeSession(session);
        return list;
	}

	@Override
	public Material getMaterialById(String mid) {
		Session session = openSession();
        List<Material> list = session.createQuery("from Material where deleted = 0 and mid = :mid")
        		.setParameter("mid", mid)
        		.getResultList(); 
        closeSession(session);
        return list.get(0);
	}

	@Override
	public Terminal findBySerial(String serialNumber) {
		Session session = openSession();
        List<Terminal> Terminals = session.createQuery("from Terminal where deleted = 0 and state = '激活' and serialNumber = :serialNumber").setParameter("serialNumber", serialNumber).getResultList(); 
        closeSession(session);
        if(Terminals.size() == 0) {
        	return null;
        } else {
        	return Terminals.get(0);
        }
	}

	@Override
	public Terminal findById(String terminalId) {
		Session session = openSession();
        List<Terminal> Terminals = session.createQuery("from Terminal where deleted = 0 and state = '激活' and terminalId = :terminalId").setParameter("terminalId", terminalId).getResultList(); 
        closeSession(session);
        if(Terminals.size() == 0) {
        	return null;
        } else {
        	return Terminals.get(0);
        }
	}

	@Override
	public List<Material> findAllMaterial(String pid) {
		Session session = openSession();
		try {
        	String sql = "select m.* from material m left join ptable_file pf on m.mid = pf.mid where pf.pid = :pid and pf.deleted = 0 and m.deleted = 0";
        	List<Material> listMaterial = session.createNativeQuery(sql, Material.class).setParameter("pid", pid).list();
        	return listMaterial;
		} finally {
            closeSession(session);
        }
	}
    
}
