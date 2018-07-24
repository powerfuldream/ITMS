package org.south.itms.service.impl;


import java.util.List;

import org.south.itms.entity.AcctUser;
import org.south.itms.entity.User;  
 
 
/** 
* 创建时间：2015-2-6 下午3:18:57 
*  
* @author andy 
* @version 2.2 
*  userService接口 
*/  
 
public interface AcctUserService {  
   AcctUser load(String id);  
 
   AcctUser get(String id);  
 
   List<AcctUser> findAll();  
 
   void persist(AcctUser entity);  
 
   String save(AcctUser entity);  
 
   void saveOrUpdate(AcctUser entity);  
 
   void delete(String id);  
 
   void flush();

/**
 * @return
 */
List<User> getAllUser();  
}  