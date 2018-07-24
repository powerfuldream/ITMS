package org.south.itms.dao.impl;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.persistence.Table;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.south.itms.dto.Page;
import org.south.itms.dto.ValueParam;
import org.south.itms.entity.File;
import org.south.itms.entity.IPTable;
import org.south.itms.entity.Items;
import org.south.itms.entity.Material;
import org.south.itms.entity.Period;
import org.south.itms.entity.PlayTable;
import org.south.itms.entity.Terminal;
import org.south.itms.entity.User;
import org.south.itms.util.SqlUpdate;
import org.south.itms.util.SqlUtil;
import org.south.netty.TableAutoGenerate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("commonDao")  
public class CommonDaoImpl implements CommonDao {

    @Autowired  
    private SessionFactory sessionFactory;  	
  
    private Session getCurrentSession() {  
        return this.sessionFactory.getCurrentSession();  
    }  
    
	@Override
	public void updateByHQL(String hql) {
		this.getCurrentSession().createQuery(hql).executeUpdate();  
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
	public void updateByTemplateHQL(String hql, Map<String, String> paramMap, Map<String, String> whereMap) {
		Query query = this.getCurrentSession().createQuery(hql);
		SqlUtil.setQueryParam(query, paramMap);
		SqlUtil.setQueryParam(query, whereMap);
		query.executeUpdate();  
	}  
	
	@Override
	public List searchByTemplateHQL(String hql, Map<String, ValueParam> whereMap) {
		Query query = this.getCurrentSession().createQuery(hql);
		SqlUtil.setQueryParamForSearch(query, whereMap);
		return query.list();
	}  
	
	public Page pageSearchByAreaCode(String areaCode, int currentPage, int pageSize) {
		if(pageSize < 1)  pageSize = 20;
		Session session = openSession();
        try {
        	String sql = "select m.* from material m left join terminal t on m.terminal_id = t.terminal_id where t.area_code = :area_code and t.deleted = 0 and m.deleted = 0";
        	String sql1 = "select m.* from material m left join terminal t on m.terminal_id = t.terminal_id where t.area_code = :area_code and t.deleted = 0 and m.deleted = 0";
        	List<Material> list = session.createNativeQuery(sql, Material.class).setParameter("area_code", areaCode).getResultList();
        	int totalRecord = list.size();
        	int totalPage = totalRecord % pageSize == 0 ? totalRecord / pageSize :  totalRecord / pageSize + 1;
    		if(currentPage > totalPage) currentPage = totalPage;
    		if(currentPage < 1) currentPage = 1;
    		List<Material> listMaterial = session.createNativeQuery(sql1, Material.class).setParameter("area_code", areaCode).setFirstResult((currentPage - 1)*pageSize).setMaxResults(pageSize).list();
    		return new Page(currentPage, totalPage, pageSize, totalRecord, listMaterial);
        } finally {
            closeSession(session);
        }
	}
	
	public Page pageSearchByTid(String tid, int currentPage, int pageSize) {
		if(pageSize < 1)  pageSize = 20;
		Session session = openSession();
        try {
        	String sql = "select m.* from material m left join terminal t on m.terminal_id = t.terminal_id where m.terminal_id = :terminal_id and t.deleted = 0 and m.deleted = 0";
        	String sql1 = "select m.* from material m left join terminal t on m.terminal_id = t.terminal_id where m.terminal_id = :terminal_id and t.deleted = 0 and m.deleted = 0";
        	List<Material> list = session.createNativeQuery(sql, Material.class).setParameter("terminal_id", tid).getResultList();
        	int totalRecord = list.size();
        	int totalPage = totalRecord % pageSize == 0 ? totalRecord / pageSize :  totalRecord / pageSize + 1;
    		if(currentPage > totalPage) currentPage = totalPage;
    		if(currentPage < 1) currentPage = 1;
    		List<Material> listMaterial = session.createNativeQuery(sql1, Material.class).setParameter("terminal_id", tid).setFirstResult((currentPage - 1)*pageSize).setMaxResults(pageSize).list();
    		return new Page(currentPage, totalPage, pageSize, totalRecord, listMaterial);
        } finally {
            closeSession(session);
        }
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
	
	//添加日期范围
	@Override
	public Page pageSearchByTemplateHQL(String start, String end, String hql, Map<String, ValueParam> whereMap, int currentPage, int pageSize) { //分页查询
		if(pageSize < 1)  pageSize = 20;

		int len = whereMap.size();
		System.out.println("pageHql=" + start + "--" + end + "=====" + hql + "--" + whereMap.size());
		String[] str = hql.split("order");
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		java.util.Date startDate = null;
		java.util.Date endDate = null;
		java.sql.Date  sqlStartDate = null;
		java.sql.Date  sqlEndDate = null;
		if(!"".equals(start)) {
			try {
				startDate = format.parse(start);
			} catch (ParseException e) {
				e.printStackTrace();
			}
			sqlStartDate  =  new java.sql.Date(startDate.getTime());
		}
		if(!"".equals(end)) {
			try {
				endDate = format.parse(end);
			} catch (ParseException e) {
				e.printStackTrace();
			}
			sqlEndDate  =  new java.sql.Date(endDate.getTime());
		}
		
		
		if(!"".equals(start) && "".equals(end)) {
			//String hqlStart = str[0] + " and uploadTime >= ? " + " order " + str[1];
			//System.out.println("startHql=" + hqlStart);
			String hqlStart = str[0] + " and uploadTime >=:start " + " order " + str[1];
			//先计算出在数据库总共有多少条数据
			Query countQuery = this.getCurrentSession().createQuery(SqlUtil.modifyToCountSql(hqlStart));
			SqlUtil.setQueryParamForSearch(countQuery, whereMap);
			//countQuery.setParameter(len, sqlStartDate);
			countQuery.setDate("start", sqlStartDate);
		    int totalRecord = Integer.valueOf(countQuery.uniqueResult() + ""); 
			int totalPage = totalRecord % pageSize == 0 ? totalRecord / pageSize :  totalRecord / pageSize + 1;
			if(currentPage > totalPage) currentPage = totalPage;
			if(currentPage < 1) currentPage = 1;
			
			//再获取某页的数据
			Query query = this.getCurrentSession().createQuery(hqlStart);
			SqlUtil.setQueryParamForSearch(query, whereMap);
			//query.setParameter(len, sqlStartDate);
			query.setDate("start", sqlStartDate);
			query.setFirstResult(pageSize * (currentPage-1));
			query.setMaxResults(pageSize);
			List list = query.list();
			
			//把结果包装成page返回
			return new Page(currentPage, totalPage, pageSize, totalRecord, list);
		}else if(!"".equals(end) && "".equals(start)) {
//			String hqlEnd = str[0] + " and uploadTime <= ? " + " order " + str[1];
//			System.out.println("endHql=" + hqlEnd);
			String hqlEnd = str[0] + " and uploadTime <=:end " + " order " + str[1];
			//先计算出在数据库总共有多少条数据
			Query countQuery = this.getCurrentSession().createQuery(SqlUtil.modifyToCountSql(hqlEnd));
			SqlUtil.setQueryParamForSearch(countQuery, whereMap);
			//countQuery.setParameter(len, sqlEndDate);
			countQuery.setDate("end", sqlEndDate);
		    int totalRecord = Integer.valueOf(countQuery.uniqueResult() + ""); 
			int totalPage = totalRecord % pageSize == 0 ? totalRecord / pageSize :  totalRecord / pageSize + 1;
			if(currentPage > totalPage) currentPage = totalPage;
			if(currentPage < 1) currentPage = 1;
			
			//再获取某页的数据
			Query query = this.getCurrentSession().createQuery(hqlEnd);
			SqlUtil.setQueryParamForSearch(query, whereMap);
			//query.setParameter(len, sqlEndDate);
			query.setDate("end", sqlEndDate);
			query.setFirstResult(pageSize * (currentPage-1));
			query.setMaxResults(pageSize);
			List list = query.list();
			
			//把结果包装成page返回
			return new Page(currentPage, totalPage, pageSize, totalRecord, list);
		}else if(!"".equals(start) && !"".equals(end)) {
			//String hqlst = str[0] + " and uploadTime >= ? and uploadTime <= ? " + " order " + str[1];
			//System.out.println("st=" + hqlst);
			String hqlst = str[0] + " and uploadTime >=:start and uploadTime <=:end " + " order " + str[1];
			//先计算出在数据库总共有多少条数据
			Query countQuery = this.getCurrentSession().createQuery(SqlUtil.modifyToCountSql(hqlst));
			SqlUtil.setQueryParamForSearch(countQuery, whereMap);
			//countQuery.setParameter(len, sqlStartDate);
			//countQuery.setParameter(len + 1, sqlEndDate);
			countQuery.setDate("start", sqlStartDate);
			countQuery.setDate("end", sqlEndDate);
		    int totalRecord = Integer.valueOf(countQuery.uniqueResult() + ""); 
			int totalPage = totalRecord % pageSize == 0 ? totalRecord / pageSize :  totalRecord / pageSize + 1;
			if(currentPage > totalPage) currentPage = totalPage;
			if(currentPage < 1) currentPage = 1;
			
			//再获取某页的数据
			Query query = this.getCurrentSession().createQuery(hqlst);
			SqlUtil.setQueryParamForSearch(query, whereMap);
			//query.setParameter(len, sqlStartDate);
			//query.setParameter(len + 1, sqlEndDate);
			query.setDate("start", sqlStartDate);
			query.setDate("end", sqlEndDate);
			query.setFirstResult(pageSize * (currentPage-1));
			query.setMaxResults(pageSize);
			List list = query.list();
			
			//把结果包装成page返回
			return new Page(currentPage, totalPage, pageSize, totalRecord, list);
		}
		
		//先计算出在数据库总共有多少条数据            //当作start and end 为空搞吧
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
	
	//添加播表日期范围
	@Override
	public Page pageSearchPtableByTemplateHQL(String start, String end, String hql, Map<String, ValueParam> whereMap, int currentPage, int pageSize) { //分页查询
		if(pageSize < 1)  pageSize = 20;

		int len = whereMap.size();
		System.out.println("pageHql=" + start + "--" + end + "=====" + hql + "--" + whereMap.size());
		String[] str = hql.split("order");
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		java.util.Date startDate = null;
		java.util.Date endDate = null;
		java.sql.Date  sqlStartDate = null;
		java.sql.Date  sqlEndDate = null;
		if(!"".equals(start)) {
			try {
				startDate = format.parse(start);
			} catch (ParseException e) {
				e.printStackTrace();
			}
			sqlStartDate  =  new java.sql.Date(startDate.getTime());
		}
		if(!"".equals(end)) {
			try {
				endDate = format.parse(end);
			} catch (ParseException e) {
				e.printStackTrace();
			}
			sqlEndDate  =  new java.sql.Date(endDate.getTime());
		}
		
		
		if(!"".equals(start) && "".equals(end)) {
			//String hqlStart = str[0] + " and uploadTime >= ? " + " order " + str[1];
			//System.out.println("startHql=" + hqlStart);
			String hqlStart = str[0] + " and playDate >=:start " + " order " + str[1];
			//先计算出在数据库总共有多少条数据
			Query countQuery = this.getCurrentSession().createQuery(SqlUtil.modifyToCountSql(hqlStart));
			SqlUtil.setQueryParamForSearch(countQuery, whereMap);
			//countQuery.setParameter(len, sqlStartDate);
			countQuery.setDate("start", sqlStartDate);
		    int totalRecord = Integer.valueOf(countQuery.uniqueResult() + ""); 
			int totalPage = totalRecord % pageSize == 0 ? totalRecord / pageSize :  totalRecord / pageSize + 1;
			if(currentPage > totalPage) currentPage = totalPage;
			if(currentPage < 1) currentPage = 1;
			
			//再获取某页的数据
			Query query = this.getCurrentSession().createQuery(hqlStart);
			SqlUtil.setQueryParamForSearch(query, whereMap);
			//query.setParameter(len, sqlStartDate);
			query.setDate("start", sqlStartDate);
			query.setFirstResult(pageSize * (currentPage-1));
			query.setMaxResults(pageSize);
			List list = query.list();
			
			//把结果包装成page返回
			return new Page(currentPage, totalPage, pageSize, totalRecord, list);
		}else if(!"".equals(end) && "".equals(start)) {
//			String hqlEnd = str[0] + " and uploadTime <= ? " + " order " + str[1];
//			System.out.println("endHql=" + hqlEnd);
			String hqlEnd = str[0] + " and playDate <=:end " + " order " + str[1];
			//先计算出在数据库总共有多少条数据
			Query countQuery = this.getCurrentSession().createQuery(SqlUtil.modifyToCountSql(hqlEnd));
			SqlUtil.setQueryParamForSearch(countQuery, whereMap);
			//countQuery.setParameter(len, sqlEndDate);
			countQuery.setDate("end", sqlEndDate);
		    int totalRecord = Integer.valueOf(countQuery.uniqueResult() + ""); 
			int totalPage = totalRecord % pageSize == 0 ? totalRecord / pageSize :  totalRecord / pageSize + 1;
			if(currentPage > totalPage) currentPage = totalPage;
			if(currentPage < 1) currentPage = 1;
			
			//再获取某页的数据
			Query query = this.getCurrentSession().createQuery(hqlEnd);
			SqlUtil.setQueryParamForSearch(query, whereMap);
			//query.setParameter(len, sqlEndDate);
			query.setDate("end", sqlEndDate);
			query.setFirstResult(pageSize * (currentPage-1));
			query.setMaxResults(pageSize);
			List list = query.list();
			
			//把结果包装成page返回
			return new Page(currentPage, totalPage, pageSize, totalRecord, list);
		}else if(!"".equals(start) && !"".equals(end)) {
			//String hqlst = str[0] + " and uploadTime >= ? and uploadTime <= ? " + " order " + str[1];
			//System.out.println("st=" + hqlst);
			String hqlst = str[0] + " and playDate >=:start and playDate <=:end " + " order " + str[1];
			//先计算出在数据库总共有多少条数据
			Query countQuery = this.getCurrentSession().createQuery(SqlUtil.modifyToCountSql(hqlst));
			SqlUtil.setQueryParamForSearch(countQuery, whereMap);
			//countQuery.setParameter(len, sqlStartDate);
			//countQuery.setParameter(len + 1, sqlEndDate);
			countQuery.setDate("start", sqlStartDate);
			countQuery.setDate("end", sqlEndDate);
		    int totalRecord = Integer.valueOf(countQuery.uniqueResult() + ""); 
			int totalPage = totalRecord % pageSize == 0 ? totalRecord / pageSize :  totalRecord / pageSize + 1;
			if(currentPage > totalPage) currentPage = totalPage;
			if(currentPage < 1) currentPage = 1;
			
			//再获取某页的数据
			Query query = this.getCurrentSession().createQuery(hqlst);
			SqlUtil.setQueryParamForSearch(query, whereMap);
			//query.setParameter(len, sqlStartDate);
			//query.setParameter(len + 1, sqlEndDate);
			query.setDate("start", sqlStartDate);
			query.setDate("end", sqlEndDate);
			query.setFirstResult(pageSize * (currentPage-1));
			query.setMaxResults(pageSize);
			List list = query.list();
			
			//把结果包装成page返回
			return new Page(currentPage, totalPage, pageSize, totalRecord, list);
		}
		
		//先计算出在数据库总共有多少条数据            //当作start and end 为空搞吧
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

	@Override
	public void saveVideoFile(File upload) {
		System.out.println(upload);
		this.getCurrentSession().save(upload);
		
	}

	@SuppressWarnings("rawtypes")
	@Override
	public void delFile(String s) {
		String hql = "update File set deleted = 1 where fileId=?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, s);
		query.executeUpdate();
	}
	
	
	@Override
	public void deleteItem(String id) {
		// TODO Auto-generated method stub
		String hql = "update Items set deleted = 1 where itemId=:itemId";
		this.getCurrentSession().createQuery(hql).setParameter("itemId", id).executeUpdate();
	}  
	
	

	@SuppressWarnings("rawtypes")
	@Override
	public void editFile(String fId, String newFilePath, String name) {
		String hql = "update File set fileName = ? ,filePath=? where fileId=?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, name);
		query.setParameter(1, newFilePath);
		query.setParameter(2, fId);
		query.executeUpdate();
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public boolean queryByName(String fileName) {
		String hql = "from File where fileName=? and deleted=?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, fileName);
		query.setParameter(1, 0);
		List<File> list = query.list();
		if(list.size()!=0){
			return true;
		}else{			
			return false;
		}
	}

	@SuppressWarnings("rawtypes")
	@Override
	public void updateByName(String fId, String name, int fre, String terId) {
		System.out.println(fId + "--" + name + "---" + fre + "---" + terId);
		String hql = null;
		if(fre > 0){
			hql = "update File set fileName=?, frequency=?, terminalId=? where fileId=?";
			Query query = this.getCurrentSession().createQuery(hql);
			query.setParameter(0, name);
			query.setParameter(1, fre);
			query.setParameter(2, terId);
			query.setParameter(3, fId);
			query.executeUpdate();
		}else{
			hql = "update File set fileName=?, terminalId=? where fileId=?";
			Query query = this.getCurrentSession().createQuery(hql);
			query.setParameter(0, name);
			query.setParameter(1, terId);
			query.setParameter(2, fId);
			query.executeUpdate();
		}
		
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	public List<Terminal> getAllTerminal() {
		String hql = "from Terminal where deleted=?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, 0);
		List<Terminal> list = query.list();
		return list;
	}  
	
	
	@Override
	public Page pageSearchCheckByTemplateHQL(String hql, Map<String, ValueParam> whereMap, int currentPage, int pageSize) { //分页查询
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
	
	@Override
	public Page pageSearchInsertByTemplateHQL(String hql, Map<String, ValueParam> whereMap, int currentPage, int pageSize) { //分页查询
		if(pageSize < 1)  pageSize = 20;
		
		String[] str = hql.split("order");
		String hqlNew = str[0] + " and insertFlag = 1 order " + str[1];
		System.out.println("hql=" + hql);
		System.out.println("hqlNew=" + hqlNew);
		

		//先计算出在数据库总共有多少条数据
		Query countQuery = this.getCurrentSession().createQuery(SqlUtil.modifyToCountSql(hqlNew));
		SqlUtil.setQueryParamForSearch(countQuery, whereMap);
	    int totalRecord = Integer.valueOf(countQuery.uniqueResult() + ""); 
		int totalPage = totalRecord % pageSize == 0 ? totalRecord / pageSize :  totalRecord / pageSize + 1;
		if(currentPage > totalPage) currentPage = totalPage;
		if(currentPage < 1) currentPage = 1;
		
		//再获取某页的数据
		Query query = this.getCurrentSession().createQuery(hqlNew);
		SqlUtil.setQueryParamForSearch(query, whereMap);
		query.setFirstResult(pageSize * (currentPage-1));
		query.setMaxResults(pageSize);
		List list = query.list();
		
		//把结果包装成page返回
		return new Page(currentPage, totalPage, pageSize, totalRecord, list);
	}
	
	@Override
	public Page pageSearchMaterialByTemplateHQL(String hql, Map<String, ValueParam> whereMap, int currentPage, int pageSize) { //分页查询
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
	 * @see org.south.itms.dao.impl.CommonDao#firstCheckFile(java.lang.String)
	 */
	@SuppressWarnings("rawtypes")
	@Override
	public void firstCheckFile(String fileId, String name, Timestamp timestamp) {
		System.out.println("name=" + name + "=" + timestamp);
		String hql = "update File set statusId=?, firstCheckName=?,firstCheckTime=? where fileId=? and deleted=?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, "2");
		query.setParameter(1, name);
		query.setParameter(2, timestamp);
		query.setParameter(3, fileId);
		query.setParameter(4, 0);
		query.executeUpdate();
	}
	
	@SuppressWarnings("rawtypes")
	@Override
	public void secondCheckFile(String fileId, String name, Timestamp timestamp) {
		String hql = "update File set statusId=?, firstCheckName=?,firstCheckTime=? where fileId=? and deleted=?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, "3");
		query.setParameter(1, name);
		query.setParameter(2, timestamp);
		query.setParameter(3, fileId);
		query.setParameter(4, 0);
		query.executeUpdate();
	}

	/* (non-Javadoc)
	 * @see org.south.itms.dao.impl.CommonDao#firstUncheckFile(java.lang.String)
	 */
	@SuppressWarnings("rawtypes")
	@Override
	public void firstUncheckFile(String fileId, String name, Timestamp timestamp) {
		String hql = "update File set statusId=?, firstCheckName=?,firstCheckTime=? where fileId=? and deleted=?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, "4");
		query.setParameter(1, fileId);
		query.setParameter(2, name);
		query.setParameter(3, timestamp);
		query.setParameter(4, 0);
		query.executeUpdate();
	}
	
	@Override
	public Page pageSearchCheckFinalByTemplateHQL(String hql, Map<String, ValueParam> whereMap, int currentPage, int pageSize) { //分页查询
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
	 * @see org.south.itms.dao.impl.CommonDao#getAllPeriod()
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public List<Period> getAllPeriod() {
		String hql = "from Period where deleted=?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, 0);
		List<Period> list = query.list();
		return list;	
		}

	/* (non-Javadoc)
	 * @see org.south.itms.dao.impl.CommonDao#queryByMaterialName(java.lang.String)
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public boolean queryByMaterialName(String materialName) {
		String hql = "from File where materialName=? and deleted=?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, materialName);
		query.setParameter(1, 0);
		List<File> list = query.list();
		if(list.size()!=0){
			return true;
		}else{			
			return false;
		}
	}

	/* (non-Javadoc)
	 * @see org.south.itms.dao.impl.CommonDao#queryById(java.lang.String)
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public Material queryById(String mid) {
		String hql = "from Material where mid=? and deleted=?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, mid);
		query.setParameter(1, 0);
		List<Material> list = query.list();
		return list.get(0);
	}

	/* (non-Javadoc)
	 * @see org.south.itms.dao.impl.CommonDao#updateFile(java.util.Map)
	 */
	@Override
	public void updateFile(Material file) {
//		File oldFile = this.getCurrentSession().get(File.class, 主键（id);
//		oldFile.setMaterialName(file.getMaterialName());
//		oldFile.setStartTime(file.getStartTime());
//		oldFile.setEndTime(file.getEndTime());
//		oldFile.setTerminalId(file.getTerminalId());
//		oldFile.setPeriodId(file.getPeriodId());
//		oldFile.setFrequency(file.getFrequency());
		this.getCurrentSession().update(file);
	}

	@Override
	public void saveInsertTable(IPTable insertTable) {
		System.out.println(insertTable);
		this.getCurrentSession().save(insertTable);
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public List<IPTable> getAllIPTable(String terminalId) {
		String hql = "from IPTable where terminalId=? and deleted=?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, terminalId);
		query.setParameter(1, 0);
		return query.list();
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public List<Material> getAllMaterialByTid(String tid) {
		String hql = "from Material where terminalId=? and deleted=?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, tid);
		query.setParameter(1, 0);
		return query.list();
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	public Period getPeriodById(String s) {
		System.out.println("periodId=" + s);
		String hql = "from Period where periodId=? and deleted=?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, s);
		query.setParameter(1, 0);
		List<Period> list = query.list();
		System.out.println(list);
		return list.get(0);
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public List<Material> getTerminalByPid(String periodId) {
		String hql = "from Material where deleted = ? and periodId = ?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, 0);
		query.setParameter(1, periodId);
		List<Material> list = query.list();
		System.out.println(list);
		return list;
	}

	@SuppressWarnings("rawtypes")
	@Override
	public void updatePeriodById(String periodId) {
		String hql = "update Period set status=? where periodId=? and deleted=?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, 1);
		query.setParameter(1, periodId);
		query.setParameter(2, 0);
		query.executeUpdate();
	}

	@SuppressWarnings("rawtypes")
	@Override
	public Material getMaterialByMid(String mid) {
		String hql = "from Material where mid = ? and deleted=?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, mid);
		query.setParameter(1, 0);
		return (Material) query.uniqueResult();
	}

	@Override
	public List<User> getAllUser() {
		String hql = "from User where deleted=?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, 0);
		List<User> list = query.list();
		return list;
	}

	@Override
	public List<IPTable> getAllIPTableNo() {
		String hql = "from IPTable where deleted=?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, 0);
		List<IPTable> list = query.list();
		return list;
	}

	@SuppressWarnings("rawtypes")
	@Override
	public Terminal getTerminalById(String terminalId) {
		String hql = "from Terminal where terminalId = ? and deleted=?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, terminalId);
		query.setParameter(1, 0);
		Terminal terminal = (Terminal) query.uniqueResult();
		return terminal;
	}

	@SuppressWarnings("rawtypes")
	@Override
	public Items queryByItemId(String itemId) {
		String hql = "from Items where itemId = ? and deleted = ?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, itemId);
		query.setParameter(1, 0);
		return (Items)query.uniqueResult();
	}

	@Override
	public void updateItem(Items items) {
		this.getCurrentSession().update(items);
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public List<Items> getAllItemsPeriod(String tid) {
		String hql = "from Items where terminalId =? and deleted = ?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, tid);
		query.setParameter(1, 0);
		List<Items> list = query.list();
		return list;
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public List<Items> getItemsByPid(String periodId) {
		String hql = "from Items where periodId =? and deleted = ?";
		Query query = this.getCurrentSession().createQuery(hql);
		query.setParameter(0, periodId);
		query.setParameter(1, 0);
		List<Items> list = query.list();
		return list;
	}

	@SuppressWarnings("rawtypes")
	@Override
	public void resetPtableState(String pid) {
		String hql1 = "from PlayTable where pid = ?";
		Query query = this.getCurrentSession().createQuery(hql1);
		query.setParameter(0, pid);
		PlayTable ptable = (PlayTable) query.uniqueResult();
		ptable.setStatusId("1");
		this.getCurrentSession().update(ptable);
	}

	@Override
	public void saveInsetPlayTable(PlayTable ptable, String mid) {
		//this.getCurrentSession().save(ptable);
		System.out.println(ptable);
		//String pid = ptable.getPid();
		String[] mids = mid.split(",");
		List<Material> list = new ArrayList<Material>();
		for(String s : mids) {
			String[] str = s.split("-");
			String hql1 = "from Material where mid = ?";
			Query query = this.getCurrentSession().createQuery(hql1);
			query.setParameter(0, str[0]);
			Material material = (Material) query.uniqueResult();
			int len = Integer.parseInt(str[1]);
			if(len > 0) {
				for(int i = 0; i < len; i++) {
					list.add(material);
				}
			}
		}
		
		SqlUpdate sql = new SqlUpdate();
		sql.savePtableFile(ptable, mid, list);
	}
	
	//7.14
		@Override
		public boolean copyOneToPlayFile(String pid, String mid,int num) {
			try {
				TableAutoGenerate TAG=new TableAutoGenerate();
				TAG.copySqlPlayFile(pid, mid, num);
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return false;
			}
			return true;
		}
		
		//7.15
	@Override
	public boolean delOneFromPlayFile(String pid, String mid, int num) {
		try {
			TableAutoGenerate TAG=new TableAutoGenerate();
			TAG.delSqlPlayFile(pid, mid, num);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}
		return true;
	}
		
		
		
	
	
}
