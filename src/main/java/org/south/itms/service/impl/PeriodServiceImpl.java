package org.south.itms.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.south.itms.dao.impl.CommonDao;
import org.south.itms.dao.impl.PeriodDao;
import org.south.itms.dto.Page;
import org.south.itms.dto.ValueParam;
import org.south.itms.entity.Items;
import org.south.itms.entity.Material;
import org.south.itms.entity.Period;
import org.south.itms.entity.Terminal;
import org.south.itms.util.SqlUtil;
import org.south.itms.util.StringUtil;
import org.south.itms.util.TimeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author jan
 * @date 2017年11月23日 下午6:43:54
 * @version V1.0 
 */
@Service("periodService")
public class PeriodServiceImpl implements PeriodService {

	@Autowired
	private PeriodDao periodDao;
	

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
			  return periodDao.pageSearchByTemplateHQL(SqlUtil.growSearchHqlTemplate(className, whereMap, "") + whereSuffix, whereMap, currentPage, pageSize);
		  }
		  
		  
		 //获取查询的结果
		 return periodDao.pageSearchByTemplateHQL(SqlUtil.growSearchHqlTemplate(className, whereMap, orderBy), whereMap, currentPage, pageSize);
	}


	/* (non-Javadoc)
	 * @see org.south.itms.service.impl.PeriodService#checkName(java.lang.String)
	 */
	@Override
	public boolean checkName(String periodName) {
		return periodDao.checkName(periodName);
	}


	/* (non-Javadoc)
	 * @see org.south.itms.service.impl.PeriodService#save(org.south.itms.entity.Period)
	 */
	@Override
	public void save(Period period) {
		periodDao.save(period);
	}


	/* (non-Javadoc)
	 * @see org.south.itms.service.impl.PeriodService#delPeriod(java.lang.String[])
	 */
	@Override
	public void delPeriod(String[] periodId) {
		periodDao.delPeriod(periodId);
	}


	/* (non-Javadoc)
	 * @see org.south.itms.service.impl.PeriodService#getPeriod(java.lang.String)
	 */
	@Override
	public Period getPeriod(String periodId) {
		return periodDao.getPeriod(periodId);
	}


	/* (non-Javadoc)
	 * @see org.south.itms.service.impl.PeriodService#updatePeriod(org.south.itms.entity.Period)
	 */
	@Override
	public void updatePeriod(Period period) {
		periodDao.updatePeriod(period);
	}


	@Override
	public List<Period> queryByName(String periodName) {
		return periodDao.queryByName(periodName);
	}


	@Override
	public List<Period> queryByTid(String terminalId) {
		System.out.println(terminalId);
		List<Items> list = periodDao.getMapDataNew(terminalId);
		Set<String> set = new HashSet<String>();
		List<Period> listP = new ArrayList<Period>();
		if(list.size() != 0) {
			for(Items m : list) {
				set.add(m.getPeriodId());
			}
			System.out.println(list.size());
			if(set.size() == 0) {
				return listP;
			}else {
				for(String periodId : set) {
					Period p = periodDao.getPeriodById(periodId);
					if(p == null) {
						
					}else {
						listP.add(p);
					}
				}
				return listP;
			}
		}else {
			return listP;
		}
	}


	@Override
	public List<Period> queryByAreaId(String areaId) {
		List<Terminal> list = periodDao.queryByAreaId(areaId);
		Set<String> set = new HashSet<String>();
		List<Period> listP = new ArrayList<Period>();
		if(list.size() == 0) {
			return listP;
		}else {
			for(Terminal t : list) {
				List<Items> listM = periodDao.getMapDataNew(t.getTerminalId());
				for(Items m : listM) {
					set.add(m.getPeriodId());
				}
			}
		}
		if(set.size() == 0) {
			return listP;
		}else {
			for(String periodId : set) {
				System.out.println(periodId);
				Period p = periodDao.getPeriodById(periodId);
				if(p == null) {
					
				}else {
					listP.add(p);
				}
			}
			return listP;
		}
	}


	@Override
	public List<Integer> getMapData(String terminalId) {
		List<Integer> data = new ArrayList<Integer>();
		List<Items> list = periodDao.getMapDataNew(terminalId);
		if(list.size() == 0) {
			for(int i = 0; i < 7; i++) {
				data.add(0);
			}
			return data;
		}else {
			for(int i = 0; i < 7; i++) {
				int sum = 0;
				for(Items m : list) {
					try {
						if(m.getStartDate() == null || m.getEndDate() == null) {
							
						}else {
							if(TimeUtil.checkDate(i, m.getStartDate(), m.getEndDate())) {
								sum = sum + m.getFrequency() * m.getDuration();
							}
						}
					}catch(Exception e) {
						e.printStackTrace();
					}
				}
				System.out.println(i + "=" + sum);
				int min = (int)sum/60;
				data.add(min);
			}
			return data;
		}
	}
	
	
	@Override
	public List<Period> findPeriodByTerminalId(String terminalId) {
    	return periodDao.findPeriodByTerminalId(terminalId);
	}
	

}
