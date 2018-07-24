package org.south.itms.service.impl;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.south.itms.dao.impl.CommonDao;
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
import org.south.itms.util.StringUtil;
import org.south.netty.PlayTableTask;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;  

@Service("commonService")  
public class CommonServiceImpl implements CommonService {  
   
	@Autowired
	private CommonDao commonDao;
	

	@Transactional
	@Override
	public void updateByHQL(String hql) {
		commonDao.updateByHQL(hql);
	}

	@Transactional
	@Override
	public void updateByTemplateHQL(String hql, Map<String, String> paramMap, Map<String, String> whereMap) {
		commonDao.updateByTemplateHQL(hql, paramMap, whereMap);
	}
	
	
	@Override
	public Page pageSearchByTemplateHQL(String[] params, int currentPage, int pageSize, String className, String orderBy, String whereSuffix) {
		  //组装查询条件
		  Map<String, ValueParam> whereMap = new HashMap<String, ValueParam>();
		  if(params != null && (params.length % 3 == 0)) {
			  for(int i = 0; i < params.length; i+=3) {
				  whereMap.put(params[i], new ValueParam(params[i + 1], params[i + 2]));
			  }
		  }
		  
		  if(!StringUtil.isEmpty(whereSuffix)) {  //whereSuffix不为空，表示需要额外增加where的条件筛选
			  if(!StringUtil.isEmpty(orderBy)) whereSuffix += " order by " + orderBy;
			  return commonDao.pageSearchByTemplateHQL(SqlUtil.growSearchHqlTemplate(className, whereMap, "") + whereSuffix, whereMap, currentPage, pageSize);
		  }
		  
		  
		 //获取查询的结果
		 return commonDao.pageSearchByTemplateHQL(SqlUtil.growSearchHqlTemplate(className, whereMap, orderBy), whereMap, currentPage, pageSize);
	}
	//7.16
	@Override
	public Page pageSearchByTemplateHQL(String[] params, String alreadymid,int currentPage, int pageSize, String className, String orderBy, String whereSuffix) {
		  //组装查询条件
		  Map<String, ValueParam> whereMap = new HashMap<String, ValueParam>();
		  if(params != null && (params.length % 3 == 0)) {
			  for(int i = 0; i < params.length; i+=3) {
				  whereMap.put(params[i], new ValueParam(params[i + 1], params[i + 2]));
			  }
		  }
		  
		  if(!StringUtil.isEmpty(whereSuffix)) {  //whereSuffix不为空，表示需要额外增加where的条件筛选
			  if(!StringUtil.isEmpty(orderBy)) whereSuffix += " order by " + orderBy;
			  return commonDao.pageSearchByTemplateHQL(SqlUtil.growSearchHqlTemplate(className, whereMap, "") + whereSuffix, whereMap, currentPage, pageSize);
		  }
		  
		  
		 //获取查询的结果
		 return commonDao.pageSearchByTemplateHQL(SqlUtil.growSearchHqlTemplate(className, whereMap, alreadymid,orderBy), whereMap, currentPage, pageSize);
	}
	
	@Override
	public Page pageSearchByTemplateHQL(String start, String end, String[] params, int currentPage, int pageSize, String className, String orderBy, String whereSuffix) {
		  //组装查询条件
		  Map<String, ValueParam> whereMap = new HashMap<String, ValueParam>();
		  if(params != null && (params.length % 3 == 0)) {
			  for(int i = 0; i < params.length; i+=3) {
				  whereMap.put(params[i], new ValueParam(params[i + 1], params[i + 2]));
			  }
		  }
		  
		  if(!StringUtil.isEmpty(whereSuffix)) {  //whereSuffix不为空，表示需要额外增加where的条件筛选
			  if(!StringUtil.isEmpty(orderBy)) whereSuffix += " order by " + orderBy;
			  return commonDao.pageSearchByTemplateHQL(start, end, SqlUtil.growSearchHqlTemplate(start, end, className, whereMap, "") + whereSuffix, whereMap, currentPage, pageSize);
		  }
		  
		  
		 //获取查询的结果
		 return commonDao.pageSearchByTemplateHQL(start, end, SqlUtil.growSearchHqlTemplate(start, end, className, whereMap, orderBy), whereMap, currentPage, pageSize);
	}
	
	//播表查询
	@Override
	public Page pageSearchPtableByTemplateHQL(String start, String end, String[] params, int currentPage, int pageSize, String className, String orderBy, String whereSuffix) {
		  //组装查询条件
		  Map<String, ValueParam> whereMap = new HashMap<String, ValueParam>();
		  if(params != null && (params.length % 3 == 0)) {
			  for(int i = 0; i < params.length; i+=3) {
				  whereMap.put(params[i], new ValueParam(params[i + 1], params[i + 2]));
			  }
		  }
		  
		  if(!StringUtil.isEmpty(whereSuffix)) {  //whereSuffix不为空，表示需要额外增加where的条件筛选
			  if(!StringUtil.isEmpty(orderBy)) whereSuffix += " order by " + orderBy;
			  return commonDao.pageSearchPtableByTemplateHQL(start, end, SqlUtil.growSearchHqlTemplate(start, end, className, whereMap, "") + whereSuffix, whereMap, currentPage, pageSize);
		  }
		  
		  
		 //获取查询的结果
		 return commonDao.pageSearchPtableByTemplateHQL(start, end, SqlUtil.growSearchHqlTemplate(start, end, className, whereMap, orderBy), whereMap, currentPage, pageSize);
	}
	
	@Override
	public Page pageSearchByTemplateHQLTree(String[] params, int currentPage, int pageSize, String className, String orderBy, String whereSuffix) {
		  //组装查询条件
		  Map<String, ValueParam> whereMap = new HashMap<String, ValueParam>();
		  if(params != null && (params.length % 3 == 0)) {
			  for(int i = 0; i < params.length; i+=3) {
				  whereMap.put(params[i], new ValueParam(params[i + 1], params[i + 2]));
			  }
		  }
		  
		  if(!StringUtil.isEmpty(whereSuffix)) {  //whereSuffix不为空，表示需要额外增加where的条件筛选
			  if(!StringUtil.isEmpty(orderBy)) whereSuffix += " order by " + orderBy;
			  return commonDao.pageSearchByTemplateHQL(SqlUtil.growSearchHqlTemplate(className, whereMap, "") + whereSuffix, whereMap, currentPage, pageSize);
		  }
		  
		  
		 //获取查询的结果
		 return commonDao.pageSearchByTemplateHQL(SqlUtil.growSearchHqlTemplate(className, whereMap, orderBy), whereMap, currentPage, pageSize);
	}

	@Override
	public void saveVideoFile(File upload) {
		commonDao.saveVideoFile(upload);
		
	}

	@Override
	public void delFile(String[] fileId) {
		for(String s:fileId){
			commonDao.delFile(s);
		}
		
	}

	

	@Transactional
	@Override
	public void deleteItems(String[] itemIds) {
		// TODO Auto-generated method stub
		for(String id : itemIds) {
			commonDao.deleteItem(id);
		}
	}  
	
	

	@Override
	public void editFile(String fId, String newFilePath, String name) {
		commonDao.editFile(fId, newFilePath, name);
	}

	@Override
	public boolean queryByName(String fileName) {
		return commonDao.queryByName(fileName);
	}

	@Override
	public void updateByName(String fId, String name, int fre, String terId) {
		commonDao.updateByName(fId, name, fre, terId);
	}

	@Override
	public List<Terminal> getAllTerminal() {
		return commonDao.getAllTerminal();
	}

	/* (non-Javadoc)
	 * @see org.south.itms.service.impl.CommonService#pageSearchCheckByTemplateHQL(java.lang.String[], int, int, java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public Page pageSearchCheckByTemplateHQL(String[] params, int currentPage, int pageSize, String className, String orderBy, String whereSuffix) {
		  //组装查询条件
		  Map<String, ValueParam> whereMap = new HashMap<String, ValueParam>();
		  if(params != null && (params.length % 3 == 0)) {
			  for(int i = 0; i < params.length; i+=3) {
				  whereMap.put(params[i], new ValueParam(params[i + 1], params[i + 2]));
			  }
		  }
		  
		  //whereMap.put("statusId", new ValueParam("=", "1"));
		  
		  if(!StringUtil.isEmpty(whereSuffix)) {  //whereSuffix不为空，表示需要额外增加where的条件筛选
			  if(!StringUtil.isEmpty(orderBy)) whereSuffix += " order by " + orderBy;
			  return commonDao.pageSearchCheckByTemplateHQL(SqlUtil.growSearchHqlTemplate(className, whereMap, "") + whereSuffix, whereMap, currentPage, pageSize);
		  }
		  
		  
		 //获取查询的结果
		 return commonDao.pageSearchCheckByTemplateHQL(SqlUtil.growSearchHqlTemplate(className, whereMap, orderBy), whereMap, currentPage, pageSize);
	}
	
	@Override
	public Page pageSearchFirstByTemplateHQL(String[] params, int currentPage, int pageSize, String className, String orderBy, String whereSuffix) {
		  //组装查询条件
		  Map<String, ValueParam> whereMap = new HashMap<String, ValueParam>();
		  if(params != null && (params.length % 3 == 0)) {
			  for(int i = 0; i < params.length; i+=3) {
				  whereMap.put(params[i], new ValueParam(params[i + 1], params[i + 2]));
			  }
		  }
		  
		  //whereMap.put("statusId", new ValueParam("=", "1"));
		  
		  if(!StringUtil.isEmpty(whereSuffix)) {  //whereSuffix不为空，表示需要额外增加where的条件筛选
			  if(!StringUtil.isEmpty(orderBy)) whereSuffix += " order by " + orderBy;
			  return commonDao.pageSearchCheckByTemplateHQL(SqlUtil.growSearchHqlTemplate(className, whereMap, "") + whereSuffix, whereMap, currentPage, pageSize);
		  }
		  
		  
		 //获取查询的结果
		 return commonDao.pageSearchCheckByTemplateHQL(SqlUtil.growSearchHqlTemplate(className, whereMap, orderBy), whereMap, currentPage, pageSize);
	}
	
	@Override
	public Page pageSearchInsertByTemplateHQL(String[] params, int currentPage, int pageSize, String className, String orderBy, String whereSuffix) {
		  //组装查询条件
		  Map<String, ValueParam> whereMap = new HashMap<String, ValueParam>();
		  if(params != null && (params.length % 3 == 0)) {
			  for(int i = 0; i < params.length; i+=3) {
				  whereMap.put(params[i], new ValueParam(params[i + 1], params[i + 2]));
			  }
		  }
		  
		  //whereMap.put("statusId", new ValueParam("=", "1"));
		  
		  if(!StringUtil.isEmpty(whereSuffix)) {  //whereSuffix不为空，表示需要额外增加where的条件筛选
			  if(!StringUtil.isEmpty(orderBy)) whereSuffix += " order by " + orderBy;
			  return commonDao.pageSearchInsertByTemplateHQL(SqlUtil.growSearchHqlTemplate(className, whereMap, "") + whereSuffix, whereMap, currentPage, pageSize);
		  }
		  
		  
		 //获取查询的结果
		 return commonDao.pageSearchInsertByTemplateHQL(SqlUtil.growSearchHqlTemplate(className, whereMap, orderBy), whereMap, currentPage, pageSize);
	}

	/* (non-Javadoc)
	 * @see org.south.itms.service.impl.CommonService#firstCheckFile(java.lang.String)
	 */
	@Override
	public void firstCheckFile(String fileId, String name, Timestamp timestamp) {
		commonDao.firstCheckFile(fileId, name, timestamp);
	}
	
	@Override
	public void secondCheckFile(String fileId, String name, Timestamp timestamp) {
		commonDao.secondCheckFile(fileId, name, timestamp);
	}

	/* (non-Javadoc)
	 * @see org.south.itms.service.impl.CommonService#firstUncheckFile(java.lang.String)
	 */
	@Override
	public void firstUncheckFile(String fileId, String name, Timestamp timestamp) {
		commonDao.firstUncheckFile(fileId, name, timestamp);
	}
	
	@Override
	public Page pageSearchCheckFinalByTemplateHQL(String[] params, int currentPage, int pageSize, String className, String orderBy, String whereSuffix) {
		  //组装查询条件
		  Map<String, ValueParam> whereMap = new HashMap<String, ValueParam>();
		  if(params != null && (params.length % 3 == 0)) {
			  for(int i = 0; i < params.length; i+=3) {
				  whereMap.put(params[i], new ValueParam(params[i + 1], params[i + 2]));
			  }
		  }
		  
		  whereMap.put("statusId", new ValueParam("=", "2"));
		  
		  if(!StringUtil.isEmpty(whereSuffix)) {  //whereSuffix不为空，表示需要额外增加where的条件筛选
			  if(!StringUtil.isEmpty(orderBy)) whereSuffix += " order by " + orderBy;
			  return commonDao.pageSearchCheckFinalByTemplateHQL(SqlUtil.growSearchHqlTemplate(className, whereMap, "") + whereSuffix, whereMap, currentPage, pageSize);
		  }
		  
		  
		 //获取查询的结果
		 return commonDao.pageSearchCheckFinalByTemplateHQL(SqlUtil.growSearchHqlTemplate(className, whereMap, orderBy), whereMap, currentPage, pageSize);
	}
	
	@Override
	public Page pageSearchMaterialByTemplateHQL(String[] params, int currentPage, int pageSize, String className, String orderBy, String whereSuffix) {
		  //组装查询条件
		  Map<String, ValueParam> whereMap = new HashMap<String, ValueParam>();
		  if(params != null && (params.length % 3 == 0)) {
			  for(int i = 0; i < params.length; i+=3) {
				  whereMap.put(params[i], new ValueParam(params[i + 1], params[i + 2]));
			  }
		  }
		 
		  //whereMap.put("info", new ValueParam("=", "0"));
		  whereMap.put("statusId", new ValueParam("=", "3"));
		  
		  if(!StringUtil.isEmpty(whereSuffix)) {  //whereSuffix不为空，表示需要额外增加where的条件筛选
			  if(!StringUtil.isEmpty(orderBy)) whereSuffix += " order by " + orderBy;
			  return commonDao.pageSearchMaterialByTemplateHQL(SqlUtil.growSearchHqlTemplate(className, whereMap, "") + whereSuffix, whereMap, currentPage, pageSize);
		  }
		  
		  
		 //获取查询的结果
		 return commonDao.pageSearchMaterialByTemplateHQL(SqlUtil.growSearchHqlTemplate(className, whereMap, orderBy), whereMap, currentPage, pageSize);
	}
	
	@Override
	public Page pageSearchSecondByTemplateHQL(String[] params, int currentPage, int pageSize, String className, String orderBy, String whereSuffix) {
		  //组装查询条件
		  Map<String, ValueParam> whereMap = new HashMap<String, ValueParam>();
		  if(params != null && (params.length % 3 == 0)) {
			  for(int i = 0; i < params.length; i+=3) {
				  whereMap.put(params[i], new ValueParam(params[i + 1], params[i + 2]));
			  }
		  }
		  
		  whereMap.put("statusId", new ValueParam("=", "2"));
		  
		  if(!StringUtil.isEmpty(whereSuffix)) {  //whereSuffix不为空，表示需要额外增加where的条件筛选
			  if(!StringUtil.isEmpty(orderBy)) whereSuffix += " order by " + orderBy;
			  return commonDao.pageSearchCheckFinalByTemplateHQL(SqlUtil.growSearchHqlTemplate(className, whereMap, "") + whereSuffix, whereMap, currentPage, pageSize);
		  }
		  
		  
		 //获取查询的结果
		 return commonDao.pageSearchCheckFinalByTemplateHQL(SqlUtil.growSearchHqlTemplate(className, whereMap, orderBy), whereMap, currentPage, pageSize);
	}

	/* (non-Javadoc)
	 * @see org.south.itms.service.impl.CommonService#getAllPeriod()
	 */
	@Override
	public List<Period> getAllPeriod() {
		return commonDao.getAllPeriod();
	}

	/* (non-Javadoc)
	 * @see org.south.itms.service.impl.CommonService#queryByMaterialName(java.lang.String)
	 */
	@Override
	public boolean queryByMaterialName(String materialName) {
		return commonDao.queryByMaterialName(materialName);
	}

	/* (non-Javadoc)
	 * @see org.south.itms.service.impl.CommonService#queryById(java.lang.String)
	 */
	@Override
	public Material queryById(String mid) {
		return commonDao.queryById(mid);
	}

	/* (non-Javadoc)
	 * @see org.south.itms.service.impl.CommonService#updateFile(java.util.Map)
	 */
	@Override
	public void updateFile(Material map) {
		commonDao.updateFile(map);
	}

	@Override
	public void saveInsertTable(IPTable insertTable) {
		commonDao.saveInsertTable(insertTable);
	}

	@Override
	public List<IPTable> getAllIPTable(String terminalId) {
		return commonDao.getAllIPTable(terminalId);
	}

	@Override
	public Page pageSearchByAreaCode(String areaCode, int currentPage, int pageSize) {
		return commonDao.pageSearchByAreaCode(areaCode, currentPage, pageSize);
	}

	@Override
	public List<Period> getAllMaterialByTid(String tid) {
		List<Material> list = commonDao.getAllMaterialByTid(tid);
		List<Period> listPeriod = new ArrayList<Period>();
		Set<String> set = new HashSet<String>();
		for(Material m : list) {
			//set.add(m.getPeriod);
		}
		for(String s : set) {
			if(s == null) {
				
			}else {
				Period period = commonDao.getPeriodById(s);
				listPeriod.add(period);
			}
		}
		return listPeriod;
	}

	@Override
	public boolean generateTable(String periodId, String uid) {
		if("".equals(periodId) || periodId == null) {
			return false;
		}else {
			List<Material> list = commonDao.getTerminalByPid(periodId);
			int length = 0;
			if(list == null || list.size() == 0) {
				return false;
			}else {
				//length = fromListMaterial(list);
				PlayTableTask task = new PlayTableTask();
				try {
					if(length <= 0) {
						return false;
					}else {
						//task.generateManyTable(list.get(0).getTerminalId(), periodId, uid, length);
						commonDao.updatePeriodById(periodId);
						return true;
					}
				}catch(Exception e) {
					e.printStackTrace();
					return false;
				}
			}
		}
	}
	
	@Override
	public boolean generateTb(String periodId, String uid, String startDate, String endDate) {
		if("".equals(periodId) || periodId == null) {
			return false;
		}else {
			List<Items> list = commonDao.getItemsByPid(periodId);
			int length = 0;
			int start = 0;
			int end = 0;
			if(list == null || list.size() == 0) {
				return false;
			}else {
				length = fromListMaterial(list);
				start = fromListItems(startDate);
				end = fromListItems(endDate);
				PlayTableTask task = new PlayTableTask();
				System.out.println("length " + length + " start " + start + " end " + end);
				if(end < 0) return false;
				if(start > length) return false;
				if(length <= 0) return false;
				if(start <= 0 && end < length) {
					try {
						task.generateTb(list.get(0).getTerminalId(), periodId, uid, 0, end);
					} catch (ParseException e) {
						e.printStackTrace();
						return false;
					}
				}else if(start >= 0 && end <= length) {
					try {
						task.generateTb(list.get(0).getTerminalId(), periodId, uid, start, end);
					} catch (ParseException e) {
						e.printStackTrace();
						return false;
					}
				}else if(start >= 0 && end > length) {
					try {
						task.generateTb(list.get(0).getTerminalId(), periodId, uid, start, length);
					} catch (ParseException e) {
						e.printStackTrace();
						return false;
					}
				}else if(start <= 0 && end > length) {
					try {
						task.generateTb(list.get(0).getTerminalId(), periodId, uid, 0, length);
					} catch (ParseException e) {
						e.printStackTrace();
						return false;
					}
				}
//				try {
//					if(length <= 0) {
//						return false;
//					}else {
//						task.generateManyTable(list.get(0).getTerminalId(), periodId, uid, length);
//						return true;
//					}
//				}catch(Exception e) {
//					e.printStackTrace();
//					return false;
//				}
				return true;
			}
		}
	}
	
	private int fromListItems(String dateTime) {
		SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
		Date date = null;
		try {
			date = f.parse(f.format(new Date()));
		} catch (ParseException e) {
			e.printStackTrace();
		}
		Date d = null;
		try {
			d = f.parse(dateTime);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		int width = (int)(((d.getTime() - date.getTime())) / 1000 / 60 / 60 / 24);
		return width;
	}

	//获取素材最晚日期离现在天数
	public int fromListMaterial(List<Items> list) {
		SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
		Date date = null;
		try {
			date = f.parse(f.format(new Date()));
		} catch (ParseException e) {
			e.printStackTrace();
		}
		int len = 0;
		for(Items m : list) {
			int width = (int)(((m.getEndDate().getTime() - date.getTime())) / 1000 / 60 / 60 / 24);
			if(width > len) {
				len = width;
			}
		}
		return len;
	}
	
	public static int getDate() {
		SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
		Date date1 = null;
		Date date2 = null;
		try {
			date1 = f.parse(f.format(new Date()));
			date2 = f.parse("2017-12-29");
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return (int)(((date2.getTime() - date1.getTime())) / 1000 / 60 / 60 / 24);
	}
	
	public static void main(String[] args) {
		System.out.println(getDate());
	}

	@SuppressWarnings("rawtypes")
	@Override
	public Page searchMaterialByPid(String pid, int currentPage, int pageSize) {
		SqlUpdate sql = new SqlUpdate();
		Set<String> set = sql.getMidById(pid);		
		List<Material> list = new ArrayList<Material>();
		if(set.size() != 0) {
			String[] num = new String[set.size()];
		    Iterator it = set.iterator();
		    int len = 0;
			 while(it.hasNext()){
				 num[len] = (String) it.next();
				 len++;
			}
			 List<Material> listM = new ArrayList<Material>();
			 for(int i = 0; i < num.length; i++) {
				 Material material = commonDao.getMaterialByMid(num[i]);
				 if(material != null) {
						listM.add(material);
					}
			 }
			int totalRecord = listM.size(); 
			int totalPage = totalRecord % pageSize == 0 ? totalRecord / pageSize :  totalRecord / pageSize + 1;
			if(currentPage > totalPage) currentPage = totalPage;
			if(currentPage < 1) currentPage = 1;
			int total = pageSize*(currentPage - 1) + pageSize;
			if(total < listM.size()) {
				for(int i = pageSize*(currentPage - 1); i < total; i++) {
//					Material material = commonDao.getMaterialByMid(num[i]);
//					if(material != null) {
//						list.add(material);
//					}
					list.add(listM.get(i));
					//System.out.println(1 + "=" + num[i]);
					//System.out.println(1 + "=" + material);
				}
			}else {
				for(int i = pageSize*(currentPage - 1); i < totalRecord; i++) {
//					Material material = commonDao.getMaterialByMid(num[i]);
//					//System.out.println(2 + "=" + num[i]);
//					//System.out.println(2 + "=" + material);
//					if(material != null) {
//						list.add(material);
//					}
					list.add(listM.get(i));
				}
			}			
			
			return new Page(currentPage, totalPage, pageSize, list.size(), list);
		}else {
			return new Page(currentPage, 0, pageSize, 0, list);
		}
	}

	@Override
	public List<User> getAllUser() {
		return commonDao.getAllUser();
	}

	@Override
	public List<IPTable> getAllIPTableNo() {
		return commonDao.getAllIPTableNo();
	}

	@Override
	public Terminal getTerminalById(String terminalId) {
		return commonDao.getTerminalById(terminalId);
	}

	@Override
	public Page pageSearchByTid(String tid, int page, int limit) {
		return commonDao.pageSearchByTid(tid, page, limit);
	}

	@Override
	public Items queryByItemId(String itemId) {
		return commonDao.queryByItemId(itemId);
	}

	@Override
	public void updateItem(Items items) {
		commonDao.updateItem(items);
	}

	@Override
	public List<Period> getAllItemsPeriod(String tid) {
		List<Items> list = commonDao.getAllItemsPeriod(tid);
		Set<String> set = new HashSet<String>();
		List<Period> listP = new ArrayList<Period>();
		if(list == null || list.size() == 0) {
			return listP;
		}else {
			for(Items m : list) {
				set.add(m.getPeriodId());
			}
			for(String s : set) {
				Period period = commonDao.getPeriodById(s);
				listP.add(period);
			}
		}
		return listP;
	}

	@Override
	public void resetPtableState(String pid) {
		commonDao.resetPtableState(pid);
	}

	@Override
	public void saveInsetPlayTable(PlayTable ptable, String mid) {
		commonDao.saveInsetPlayTable(ptable, mid);
	}

	
	//7.14
	@Override
	public boolean copyOneToPlayFile(String pid, String mid, int num) {
		if(commonDao.copyOneToPlayFile(pid, mid, num))
			return true;
		return false;
	}
	
	//7.15
	@Override
	public boolean delOneFromPlayFile(String pid, String mid, int num) {
		if(commonDao.delOneFromPlayFile(pid, mid, num))
			return true;
		return false;
	}
	
	
}  