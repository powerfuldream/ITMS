package org.south.itms.dao.impl;

import java.util.List;
import java.util.Map;

//import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.south.itms.dto.Page;
import org.south.itms.dto.ValueParam;
import org.south.itms.entity.Items;
import org.south.itms.entity.Material;
import org.south.itms.entity.Period;
import org.south.itms.entity.Terminal;
import org.south.itms.util.SqlUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

/**
 * @author jan
 * @date 2017年11月23日 下午10:17:47
 * @version V1.0 
 */

@Repository("periodDao")
public class PeriodDaoImpl implements PeriodDao {

    @Autowired  
    private SessionFactory sessionFactory;  	
  
    private Session getCurrentSession() {  
        return this.sessionFactory.getCurrentSession();  
    } 
	
	@Override
	public Page pageSearchByTemplateHQL(String hql, Map<String, ValueParam> whereMap, int currentPage, int pageSize) { //分页查询
		if(pageSize < 1)  pageSize = 20;

		//先计算出在数据库总共有多少条数据
		Query countQuery = this.getCurrentSession().createQuery(SqlUtil.modifyToCountSql(hql));
		SqlUtil.setQueryParamForSearch(countQuery, whereMap);
	    int totalRecord = Integer.valueOf(countQuery.uniqueResult() + ""); 
		int totalPage = totalRecord % pageSize == 0 ? totalRecord / pageSize :  totalRecord / pageSize + 1;
		if(currentPage > totalPage) currentPage = totalPage;
		if(currentPage < 1) currentPage = 1;
		
		//再获取某页的数据
		Query query = this.getCurrentSession().createQuery(hql);
		SqlUtil.setQueryParamForSearch(query, whereMap);
		query.setFirstResult(pageSize * (currentPage-1));
		query.setMaxResults(pageSize);
		List list = query.list();
		
		//把结果包装成page返回
		return new Page(currentPage, totalPage, pageSize, totalRecord, list);
	}

	/* (non-Javadoc)
	 * @see org.south.itms.dao.impl.PeriodDao#checkName(java.lang.String)
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	public boolean checkName(String periodName) {
		String hql = "from Period where periodName = ?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, periodName);
		List<Period> list = query.list();
		if(list.size() == 0) {
			return false;
		}else {
			System.out.println(list.get(0));
			return true;
		}
	}

	/* (non-Javadoc)
	 * @see org.south.itms.dao.impl.PeriodDao#save(org.south.itms.entity.Period)
	 */
	@Override
	public void save(Period period) {
		System.out.println(period);
		this.getCurrentSession().save(period);
	}

	/* (non-Javadoc)
	 * @see org.south.itms.dao.impl.PeriodDao#delPeriod(java.lang.String[])
	 */
	@SuppressWarnings("rawtypes")
	@Override
	public void delPeriod(String[] periodId) {
		for(String id : periodId) {
			String hql = "update Period set deleted = 1 where periodId=?";
			Query query = this.getCurrentSession().createQuery(hql);
			query.setParameter(0, id);
			query.executeUpdate();
		}
	}

	/* (non-Javadoc)
	 * @see org.south.itms.dao.impl.PeriodDao#getPeriod(java.lang.String)
	 */

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public Period getPeriod(String periodId) {
		String hql = "from Period where periodId = ? and deleted = ?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, periodId);
		query.setParameter(1, 0);
		List<Period> list = query.list();
		return list.get(0);
	}

	/* (non-Javadoc)
	 * @see org.south.itms.dao.impl.PeriodDao#updatePeriod(org.south.itms.entity.Period)
	 */
	@Override
	public void updatePeriod(Period period) {
		String hql = "update Period set periodName = ? ,startInterval=? ,endInterval=?, mark=? where periodId=?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, period.getPeriodName());
		query.setParameter(1, period.getStartInterval());
		query.setParameter(2, period.getEndInterval());
		query.setParameter(3, period.getMark());
		query.setParameter(4, period.getPeriodId());
		query.executeUpdate();
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public List<Period> queryByName(String periodName) {
		String hql = "from Period where deleted = 0 and periodName like :periodName";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setString("periodName", "%"+periodName+"%");
		List<Period> list = query.list();
		return list;
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public List<Material> queryByTid(String terminalId) {
		String hql = "from Material where deleted = ? and terminalId = ?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, 0);
		query.setParameter(1, terminalId);
		List<Material> list = query.list();
		return list;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	public Period getPeriodById(String periodId) {
		String hql = "from Period where deleted = ? and periodId = ?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, 0);
		query.setParameter(1, periodId);
		List<Period> list = query.list();
		if(list.size() == 0) {
			return null;
		}
		return list.get(0);
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public List<Terminal> queryByAreaId(String areaId) {
		String hql = "from Terminal where deleted = ? and areaCode = ?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, 0);
		query.setParameter(1, areaId);
		List<Terminal> list = query.list();
		return list;
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public List<Material> getMapData(String terminalId) {
		String hql = "from Material where deleted = ? and terminalId = ?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, 0);
		query.setParameter(1, terminalId);
		List<Material> list = query.list();
		return list;
	}

	@Override
	public List<Items> getMapDataNew(String terminalId) {
		String hql = "from Items where deleted = ? and terminalId = ?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, 0);
		query.setParameter(1, terminalId);
		List<Items> list = query.list();
		return list;
	}

	@Override
	public List<Items> queryByItemTid(String terminalId) {
		String hql = "from Items where deleted = ? and terminalId = ?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, 0);
		query.setParameter(1, terminalId);
		List<Items> list = query.list();
		return list;
	}
	
	
	@Override
	public List<Period> findPeriodByTerminalId(String terminalId) {
		
    	String sql = "select * from period where terminal_id = :terminalId and deleted = 0 order by period_id desc";
    	return getCurrentSession().createNativeQuery(sql, Period.class).setParameter("terminalId", terminalId).getResultList();
    
	}
	

}
