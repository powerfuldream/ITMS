package org.south.itms.dao.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.south.itms.entity.AcctUser;
import org.south.itms.entity.File;
import org.south.itms.entity.Material;
import org.south.itms.entity.Period;
import org.south.itms.entity.PlayTable;
import org.south.itms.entity.Resource;
import org.south.itms.entity.Terminal;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

/**
 * @author: yezilong
 */


@Repository("fileDao")
public class FileDaoImpl implements FileDao {

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
    public File get(String id) {  
    	//return (File) this.getCurrentSession().load(File.class, id);  
    	Session session = openSession();
        try {
        	return (File) session.get(File.class, id);  
        } finally {
            closeSession(session);
        }
    }  
    
    
    @Override  
    public File get2(String id) {  
    	return (File) this.getCurrentSession().get(File.class, id);  
    }  
    
    
    @Override  
    public Material getById(String mid) {  
    	//return (File) this.getCurrentSession().load(File.class, id);  
    	Session session = openSession();
        try {
        	return (Material) session.get(Material.class, mid);  
        } finally {
            closeSession(session);
        }
    }  

    
    @Override  
    public File load(String id) {  
    	return (File) this.getCurrentSession().load(File.class, id);  
    }  
    
    
    @Override  
    public List<Material> findByPtable(String pid) {  //查找某个播放表的视频文件
    	System.out.println("pid:" + pid);
    	Session session = openSession();
        try {
        	String sql = "select m.* from ptable_file pf left join material m on pf.mid = m.mid where m.deleted = 0 and pf.deleted = 0 and pf.pid = :pid order by pf.num asc";
        	return session.createNativeQuery(sql, Material.class).setParameter("pid", pid).getResultList();
        } finally {
            closeSession(session);
        }
    }
    
    @SuppressWarnings({ "unchecked", "rawtypes" })
	public List<File> getAllFile(){
    	String hql = "from File where deleted = ?";
    	Query query = this.getCurrentSession().createQuery(hql);
    	query.setParameter(0, 0);
    	return query.list();
    }


	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public List<PlayTable> findByTerminalId(String terminalId) {
		String hql = "from PlayTable where terminalId = ? and deleted = ? and playDate = ? and statusId = ?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, terminalId);
		query.setParameter(1, 0);
		java.sql.Date sqlDate = new java.sql.Date(new Date().getTime());
		System.out.println(sqlDate);
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		Date d = null;
		try {
			d = df.parse(df.format(new Date()));
		} catch (ParseException e) {
			e.printStackTrace();
		}
		query.setParameter(2, d);
		query.setParameter(3, "3");
		return query.list();
	}


	@SuppressWarnings("rawtypes")
	@Override
	public Period findByPeriod(String periodId) {
		
		Session session = openSession();
        List<Period> list = session.createQuery("from Period where deleted = 0 and periodId = :periodId")
        		.setParameter("periodId", periodId)
        		.getResultList(); 
        closeSession(session);
        return list.get(0);
        
//		String hql = "from Period where periodId = ? and deleted = ?";
//		Query query = this.getCurrentSession().createQuery(hql);
//		query.setParameter(0, periodId);
//		query.setParameter(1, 0);
//		return (Period) query.list().get(0);
	}
    
    
}
