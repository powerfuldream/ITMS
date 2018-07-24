package org.south.itms.dao.impl;

import java.sql.Timestamp;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.hibernate.query.Query;
import org.south.itms.entity.File;
import org.south.itms.entity.Items;
import org.south.itms.entity.Material;
import org.south.itms.entity.Terminal;

/**
 * @author jan
 * @date 2017年12月17日 下午5:14:36
 * @version V1.0 
 */
@Repository("materialDao")
public class MaterialDaoImpl implements MaterialDao {

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
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public boolean checkFileName(String fileName) {
		String hql = "from Material where fileName = ? and deleted = ?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, fileName);
		query.setParameter(1, 0);
		List<Material> list = query.list();
		if(list.size() != 0) {
			return true;
		}else {
			return false;
		}
	}

	@Override
	public void saveFile(Material material) {
		System.out.println("material=" + material);
		this.getCurrentSession().save(material);
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public List<Terminal> getAllTerminal() {
		String hql = "from Terminal where state = ? and deleted = ?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, "激活");
		query.setParameter(1, 0);
		List<Terminal> list = query.list();
		return list;
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public Terminal getTerminalInfo(String terminalId) {
		String hql = "from Terminal where terminalId = ?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, terminalId);
		List<Terminal> list = query.list();
		return list.get(0);
	}

	@SuppressWarnings("rawtypes")
	@Override
	public Material checkMaterial(String mid) {
		String hql = "from Material where mid = ?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, mid);
		return (Material) query.uniqueResult();
	}

	@SuppressWarnings("rawtypes")
	@Override
	public void checkAccess(String mid, String name, Timestamp timestamp) {
		String hql = "update Material set statusId=?, checkName=?,checkTime=? where mid=? and deleted=?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, "3");
		query.setParameter(1, name);
		query.setParameter(2, timestamp);
		query.setParameter(3, mid);
		query.setParameter(4, 0);
		query.executeUpdate();
	}

	@SuppressWarnings("rawtypes")
	@Override
	public void checkUnAccess(String mid, String name, Timestamp timestamp) {
		String hql = "update Material set statusId=?, checkName=?,checkTime=? where mid=? and deleted=?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, "4");
		query.setParameter(1, name);
		query.setParameter(2, timestamp);
		query.setParameter(3, mid);
		query.setParameter(4, 0);
		query.executeUpdate();
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public int getAllRecord(String str) {
		String hql = "from Material where statusId = ? and deleted = ?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, str);
		query.setParameter(1, 0);
		List<File> list = query.list();
		return list.size();
	}

	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public int getAllRecord2(String str) {
		String hql = "select count(*) from Material where statusId = ? and deleted = 0 and tis = 1";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, str);
		return ((Number)query.uniqueResult()).intValue();  
	}
	
	
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public Material getById(String mid) {
		String hql = "from Material where mid=? and deleted = ?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, mid);
		query.setParameter(1, 0);
		List<Material> list = query.list();
		return list.get(0);
	}

	@Override
	public void updateMaterial(Material material) {
		this.getCurrentSession().update(material);
	}

	@SuppressWarnings("rawtypes")
	@Override
	public void delMaterial(String id) {
		String hql = "update Material set deleted = 1 where mid=?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, id);
		query.executeUpdate();
	}
	
	
	
	@Override
	public int delMaterial2(String id) {
		String hql = "update Material set deleted = 1 where mid=? and statusId != 3";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, id);
		return query.executeUpdate();
	}
	
	
	@Override
	public int updateItemDelMsg(String id) {  
		String sql = "update items set item_name = CONCAT(item_name,' (对应素材已删除)')  where mid=:mid and deleted = '0'";
		Query query = this.getCurrentSession().createNativeQuery(sql);
		query.setParameter("mid", id);
		return query.executeUpdate();
	}
	
	

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public int getExcepTable(String statusId) {
//		String hql = "from PlayTable where statusId = ? and deleted = ?";
//		Query query = this.getCurrentSession().createQuery(hql);
//		query.setParameter(0, statusId);
//		query.setParameter(1, 0);
//		List<File> list = query.list();
//		return list.size();
		
		String hql = "select count(*) from PlayTable where statusId = ? and deleted = 0";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, statusId);
		return ((Number)query.uniqueResult()).intValue();  
	}

	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public int getExcepTable(String statusId1, String statusId2) {
//		String hql = "from PlayTable where statusId = ? and deleted = ?";
//		Query query = this.getCurrentSession().createQuery(hql);
//		query.setParameter(0, statusId);
//		query.setParameter(1, 0);
//		List<File> list = query.list();
//		return list.size();
		
		String hql = "select count(*) from PlayTable where (statusId = ? or statusId = ?) and deleted = 0";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, statusId1);
		query.setParameter(1, statusId2);
		return ((Number)query.uniqueResult()).intValue();  
	}
	
	
	
	
	@SuppressWarnings("rawtypes")
	@Override
	public void tidMaterial(String mid, String tid) {
		String hql1 = "from Terminal where terminalId = ? and deleted = ?";
		Query query = this.getCurrentSession().createQuery(hql1);
		query.setParameter(0, tid);
		query.setParameter(1, 0);
		Terminal terminal = (Terminal) query.uniqueResult();
		
		String hql2 = "from Material where mid = ? and deleted = ?";
		query = this.getCurrentSession().createQuery(hql2);
		query.setParameter(0, mid);
		query.setParameter(1, 0);
		Material material = (Material) query.uniqueResult();
		
		material.setTerminal(terminal);
		material.setTis("1");
		this.getCurrentSession().update(material);
	}

	@Override
	public void saveItem(Items item) {
		this.getCurrentSession().save(item);
	}

	@Override
	public List<Items> findByPtable(String pid) {
		Session session = openSession();
        try {
        	//String sql = "select it.* from ptable_file pf left join items it on pf.mid = it.mid where it.deleted = 0 and pf.deleted = 0 and pf.pid = :pid and it.period_id = (select p.period_id from play_table p where p.deleted = 0 and p.pid = :pid)  order by pf.num asc";
        	String sql = "select it.* from ptable_file pf left join items it on pf.mid = it.mid where it.deleted = 0 and pf.deleted = 0 and pf.pid = :pid and it.period_id = (select p.period_id from play_table p where p.deleted = 0 and p.pid = :pid) and (select p.play_date from play_table p where p.deleted = 0 and p.pid = :pid) between it.start_date and it.end_date order by pf.num asc";
        	return session.createNativeQuery(sql, Items.class).setParameter("pid", pid).getResultList();
        } finally {
            closeSession(session);
        }
	}

	
	
	@Override
	public List<Items> findItemByPtable(String pid) {
		Session session = openSession();
        try {
        	String sql = "select DISTINCT it.* from ptable_file pf left join items it on pf.mid = it.mid where it.deleted = 0 and pf.deleted = 0 and pf.pid = :pid and it.period_id = (select p.period_id from play_table p where p.deleted = 0 and p.pid = :pid) order by pf.num asc";
        	//String sql = "select DISTINCT it.* from ptable_file pf left join items it on pf.mid = it.mid where it.deleted = 0 and pf.deleted = 0 and pf.pid = :pid and it.period_id = (select p.period_id from play_table p where p.deleted = 0 and p.pid = :pid) and (select p.play_date from play_table p where p.deleted = 0 and p.pid = :pid) between it.start_date and it.end_date order by pf.num asc";
        	return session.createNativeQuery(sql, Items.class).setParameter("pid", pid).getResultList();
        } finally {
            closeSession(session);
        }
	}
	
	@Override
	public List<Items> findalreadyItemByPtable(String pid) {
		Session session = openSession();
        try {
        	//String sql = "select DISTINCT it.* from ptable_file pf left join items it on pf.mid = it.mid where it.deleted = 0 and pf.deleted = 0 and pf.pid = :pid and it.period_id = (select p.period_id from play_table p where p.deleted = 0 and p.pid = :pid) order by pf.num asc";
        	//String sql = "select DISTINCT it.* from ptable_file pf left join items it on pf.mid = it.mid where it.deleted = 0 and pf.deleted = 0 and pf.pid = :pid and it.period_id = (select p.period_id from play_table p where p.deleted = 0 and p.pid = :pid) and (select p.play_date from play_table p where p.deleted = 0 and p.pid = :pid) between it.start_date and it.end_date order by pf.num asc";
        	String sql = "select DISTINCT it.* from  items it where it.deleted = 0 and  it.period_id = (select p.period_id from play_table p where p.deleted = 0 and p.pid = :pid) and (select p.play_date from play_table p where p.deleted = 0 and p.pid = :pid) between it.start_date and it.end_date order by it.mid asc";
        	return session.createNativeQuery(sql, Items.class).setParameter("pid", pid).getResultList();
        } finally {
            closeSession(session);
        }
	}
	
	@Override
	public List<Material> findMaterialByPtable(String pid) {
		Session session = openSession();
        try {
        	String sql = "select DISTINCT m.* from ptable_file pf left join material m on pf.mid = m.mid where m.deleted = 0 and pf.deleted = 0 and pf.pid = :pid order by pf.num asc";
        	return session.createNativeQuery(sql, Material.class).setParameter("pid", pid).getResultList();
        } finally {
            closeSession(session);
        }
	}
	
	@SuppressWarnings("rawtypes")
	@Override
	public void resetMaterial(String mid) {
		String hql1 = "from Material where mid = ?";
		Query query = this.getCurrentSession().createQuery(hql1);
		query.setParameter(0, mid);
		Material material = (Material) query.uniqueResult();
		material.setStatusId("1");
		this.getCurrentSession().update(material);
	}
	
	//7.14
	

	
	
	
	
}
