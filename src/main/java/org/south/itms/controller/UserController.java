package org.south.itms.controller;


import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.apache.log4j.Logger;
import org.south.itms.dto.Result;
import org.south.itms.entity.AcctUser;
import org.south.itms.service.impl.AcctUserService;
import org.springframework.beans.factory.annotation.Autowired;  
import org.springframework.stereotype.Controller;  
import org.springframework.ui.ModelMap;  
import org.springframework.web.bind.annotation.PathVariable;  
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;  

/**
 * @author: yezilong
 */

@Controller  
@RequestMapping("/user")  
public class UserController {  

  private static final Logger LOGGER = Logger.getLogger(UserController.class);  
    
  @Autowired  
  private AcctUserService userService;  
    
  
  
  @RequestMapping("/index")  
  public void index(){  
     
      AcctUser acctUser = new AcctUser();  
      acctUser.setId(UUID.randomUUID().toString());  
      acctUser.setNickName("andy");  
//      acctUser.setRegisterTime(new Date());  
      acctUser.setTelephone("13022221111");  
      String id = userService.save(acctUser);  
      LOGGER.info("====");  
      LOGGER.info(JSON.toJSONString(id));  
  }  
  
  
  
  
  @RequestMapping("/showInfo/{userId}")  
  public  @ResponseBody AcctUser showUserInfo(ModelMap modelMap, @PathVariable String userId){  
      LOGGER.info("查询用户：" + userId);  
      AcctUser userInfo = userService.load(userId);  
      modelMap.addAttribute("userInfo", userInfo);  
      return userInfo;
  }  
    
  @RequestMapping("/showInfos")  
  public @ResponseBody List<AcctUser> showUserInfos(){  
      LOGGER.info("查询用户全部用户");  
      List<AcctUser> userInfos = userService.findAll();  
      return userInfos;  
  }  
  
  
  @RequestMapping(value="/addUser", method=RequestMethod.POST)  
  public @ResponseBody Result addUser(AcctUser acctUser){  
	  System.out.println(acctUser);
     return new Result();
  }  
}  
