package org.south.itms.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.south.itms.dao.impl.TerminalDao;
import org.south.itms.entity.Terminal;
import org.south.itms.util.SqlUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;  

/**
 * @author: yezilong
 */

@Service("terminalService")  
public class TerminalServiceImpl implements TerminalService {  

  @Autowired  
  private TerminalDao terminalDao;  

  @Override  
  public int countBySerialNumber(Terminal entity) {
  	 return terminalDao.countBySerialNumber(entity);
  }
  
  
  @Override  
  public Terminal load(String id) {  
      return terminalDao.load(id);  
  }  

  @Override  
  public Terminal get(String id) {  
      return terminalDao.get(id);  
  }  

  @Override  
  public List<Terminal> findAll() {  
      return terminalDao.findAll();  
  }  

  @Override  
  public void persist(Terminal entity) {  
      terminalDao.persist(entity);  
  }  

  @Transactional
  @Override  
  public String save(Terminal entity) {  
      return terminalDao.save(entity);  
  }  
  
  @Transactional
  @Override
  public void updateByHQL(String hql) {
	  terminalDao.updateByHQL(hql);  
  }  
  
  
  @Transactional
  @Override
  public void deleteByHQL(String[] terminalIds) {
	   //更新的参数
	   Map<String, String> paramMap = new HashMap<String, String>();
	   paramMap.put("deleted", "1");
		
	   //更新的where条件
	   Map<String, String> whereMap = new HashMap<String, String>();
	   
	   for(String terminalId : terminalIds) {
		   whereMap.put("terminalId", terminalId);
		   terminalDao.updateByHQL(SqlUtil.growUpdateHql("Terminal", paramMap, whereMap));
	   }
	   
  }  
  
  
  
  @Transactional
  @Override
  public void updateTerminalState(String[] terminalIds, boolean state) {
	  
	   //更新的参数
	   Map<String, String> paramMap = new HashMap<String, String>();
	   if(state == true) {
		   paramMap.put("state", "激活");
	   } else {
		   paramMap.put("state", "禁用");
	   }
		
	   //更新的where条件
	   Map<String, String> whereMap = new HashMap<String, String>();
	   
	   for(String terminalId : terminalIds) {
		   whereMap.put("terminalId", terminalId);
		   terminalDao.updateByHQL(SqlUtil.growUpdateHql("Terminal", paramMap, whereMap));
	   }
	   
  }  
 
  
  @Override  
  public void resetTerminalPtable(String pid) {
	  terminalDao.resetTerminalPtable(pid);
  }
  

  @Override  
  public void saveOrUpdate(Terminal entity) {  
      terminalDao.saveOrUpdate(entity);  
  }  

  @Override  
  public void delete(String id) {  
      terminalDao.delete(id);  
  }  

  @Override  
  public void flush() {  
      terminalDao.flush();  
  }  

}  