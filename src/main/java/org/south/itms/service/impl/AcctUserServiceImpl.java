package org.south.itms.service.impl;


import java.util.List;

import org.south.itms.dao.impl.AcctUserDao;
import org.south.itms.entity.AcctUser;
import org.south.itms.entity.User;
import org.springframework.beans.factory.annotation.Autowired;  
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;  

/**
 * @author: yezilong
 */

@Service("userService")  
public class AcctUserServiceImpl implements AcctUserService {  

  @Autowired  
  private AcctUserDao userDao;  

  @Override  
  public AcctUser load(String id) {  
      return userDao.load(id);  
  }  

  @Override  
  public AcctUser get(String id) {  
      return userDao.get(id);  
  }  

  @Override  
  public List<AcctUser> findAll() {  
      return userDao.findAll();  
  }  

  @Override  
  public void persist(AcctUser entity) {  
      userDao.persist(entity);  
  }  

  @Override  
  public String save(AcctUser entity) {  
      return userDao.save(entity);  
  }  

  @Override  
  public void saveOrUpdate(AcctUser entity) {  
      userDao.saveOrUpdate(entity);  
  }  

  @Override  
  public void delete(String id) {  
      userDao.delete(id);  
  }  

  @Override  
  public void flush() {  
      userDao.flush();  
  }

/* (non-Javadoc)
 * @see org.south.itms.service.impl.AcctUserService#getAllUser()
 */
@Override
public List<User> getAllUser() {
	return userDao.getAllUser();
}  

}  