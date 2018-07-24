package org.south.itms.dao.impl;


import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.type.StandardBasicTypes;
import org.south.itms.dto.PlayNumDto;
import org.south.itms.entity.PlayLog;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;  
  
/**
 * @author: yezilong
 */
@Repository("statisticDao")  
public class StatisticDaoImpl implements StatisticDao {  
  
    @Autowired  
    private SessionFactory sessionFactory;  
  
    private Session getCurrentSession() {  
        return this.sessionFactory.getCurrentSession();  
    }  
  
    private Session openSession() {  
        return this.sessionFactory.openSession();  
    }  
    
    
    @Override 
    public List<PlayNumDto> findPlayNumDto(String terminalId, String startTime, String endTime) {
    	String sql = "select material_name materialName, count(*) playNum, min(play_start_time) startPlayTime, max(play_end_time) endPlayTime from play_log where deleted = 0  and terminal_id = :terminalId and str_to_date(play_start_time, '%Y-%m-%d %H:%i:%S') >= :startTime and str_to_date(play_end_time, '%Y-%m-%d %H:%i:%S') <= :endTime group by file_id";
        List list = getCurrentSession().createSQLQuery(sql).setParameter("terminalId",terminalId).setParameter("startTime",startTime).setParameter("endTime",endTime).
                addScalar("materialName",StandardBasicTypes.STRING).  
                addScalar("playNum", StandardBasicTypes.INTEGER).  
                addScalar("startPlayTime",StandardBasicTypes.STRING).
                addScalar("endPlayTime",StandardBasicTypes.STRING).list();  
        
        List<PlayNumDto> result = new ArrayList<PlayNumDto>();
        for(Iterator iterator = list.iterator();iterator.hasNext();){  
               //每个集合元素都是一个数组
              Object[] objects = (Object[]) iterator.next();  
              result.add(new PlayNumDto((String)objects[0], (Integer)objects[1], (String)objects[2], (String)objects[3]));
        }

        return result;
    }
    
    
    @Override 
    public List<PlayLog> findPlayLog(String terminalId, String startTime, String endTime) {
    	String sql = "select * from play_log where deleted = 0 and terminal_id = :terminalId and str_to_date(play_start_time, '%Y-%m-%d %H:%i:%S') >= :startTime and str_to_date(play_end_time, '%Y-%m-%d %H:%i:%S') <= :endTime ORDER BY play_end_time desc";
    	return getCurrentSession().createNativeQuery(sql, PlayLog.class).setParameter("terminalId", terminalId).setParameter("startTime", startTime).setParameter("endTime", endTime).getResultList();
    }
  
    
  
}  