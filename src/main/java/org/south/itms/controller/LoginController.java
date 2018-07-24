package org.south.itms.controller;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;
import org.south.itms.dao.impl.ResourceDao;
import org.south.itms.dao.impl.UserDao;
import org.south.itms.dto.Result;
import org.south.itms.entity.Resource;
import org.south.itms.entity.User;
import org.south.itms.util.StringUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @author: yezilong
 */

@Controller  
@RequestMapping("/login")  
public class LoginController {
  
	  @Autowired
	  private UserDao userDao;
	  
	  @Autowired
	  private ResourceDao resourceDao;
	
	  
	  
	  @RequestMapping
	  @ResponseBody
	  public String loginPage() {
		  return "forward:/views/login.jsp";
		  //System.out.println("login=====");
		  //return new Result(false, "");
	  }
	  
	  @RequestMapping(value = "/checkTimeout")
	  @ResponseBody
	  public Result checkTimeout() {
		  return new Result(true, "");
	  }
	  
	  @RequestMapping(value = "/loginIn")
	  @ResponseBody
	  public Result loginIn(String userAccount, String userPassword, HttpSession session){
		  System.out.println(userAccount + "==" + userPassword);
		  if(StringUtil.isEmpty(userPassword) || StringUtil.isEmpty(userAccount)) {
			  return new Result("登录失败, 请输入用户名和密码");
		  }
		  
		  User user = userDao.getUserByAccountAndPassword(userAccount, userPassword);
	      if(user != null) {
	    	  Map<String, List<Resource>> map = userDao.getAllResource(user.getRole().getRoleId());
	    	  String webPath = this.getClass().getResource("/").getPath().replaceAll("%20", " ");
	    	  String path = webPath.substring(0, webPath.indexOf("WEB-INF"));
	    	  System.out.println(webPath);
	    	  System.out.println(path);
	    	  user.setUserPassword("");
	    	  if(session.getAttribute("resourcesMap") != null || !"".equals(session.getAttribute("resourcesMap"))) {
	    		  session.removeAttribute("resourcesMap");
	    	  }
	    	  session.setAttribute("resourcesMap", map);
	    	  session.setAttribute("user", user);
	    	  session.setAttribute("userId", user.getUserId());
	    	  session.setAttribute("userName", user.getUserName());
	    	  session.setAttribute("roleName", user.getRole().getRoleName());
	    	  session.setAttribute("rId", user.getRole().getRoleId());
	    	  if(Integer.parseInt(user.getRole().getRoleId()) == 4) {
	    		  int num = userDao.getAccountRecord(1);
//	    		  System.out.println(num);
	    		  String n = "" + num;
	    		  session.setAttribute("checkNum", n);
	    		  
	    		  int num1 = userDao.getAccountTable(6);
	    		  int num2 = userDao.getAccountTable(7);
	    		  int nu = num1 + num2;
	    		  session.setAttribute("excepNum", "" + nu);
//	    		  System.out.println(session.getAttribute("checkNum"));
	    	  }
	    	  
	    	  if(Integer.parseInt(user.getRole().getRoleId()) == 5) {
	    		  int num = userDao.getAccountRecord(2);
	    		  System.out.println(num);
	    		  String n = "" + num;
	    		  session.setAttribute("checkNumSec", n);
	    	  }
	    	  
	    	  if(Integer.parseInt(user.getRole().getRoleId()) == 6) {
	    		  int num = userDao.getAccountTable(1);
	    		  System.out.println(num);
	    		  String n = "" + num;
	    		  session.setAttribute("playNum", n);
	    	  }
	    	  
	    	  if(Integer.parseInt(user.getRole().getRoleId()) == 7) {
	    		  int num = userDao.getAccountTable(2);
	    		  System.out.println(num);
	    		  String n = "" + num;
	    		  session.setAttribute("playNum", n);
	    	  }
	    	  
	    	  if(Integer.parseInt(user.getRole().getRoleId()) == 10) {
	    		  int num = userDao.getAccountTable(5);
	    		  int num1 = userDao.getAccountTable(7);
	    		  System.out.println(num);
	    		  int nu = num + num1;
	    		  String n = "" + nu;
	    		  session.setAttribute("broadNum", n);
	    	  }
	    	  
	    	  //加载该用户的权限
	    	  List<Resource> userResources = resourceDao.findByRole(user.getRole().getRoleId());
	    	  for(Resource r : userResources) {
	    		  System.out.println(r);
	    	  }
	    	  session.setAttribute("userResources", userResources);
	    	  //每次登录移除以下属性, 该属性是该角色运行查看的地区
	    	  session.removeAttribute("allowAreaName");
	    	  return new Result(true, "");
	      } else {  
	    	  return new Result("用户名或者密码不正确");
	      }  
	  }
	  
	  @RequestMapping(value="/reqLogin", method=RequestMethod.POST)  
	  public @ResponseBody Result reqLogin(User reqUser, HttpSession session) {
		  if(reqUser == null || StringUtil.isEmpty(reqUser.getUserAccount()) || StringUtil.isEmpty(reqUser.getUserPassword())) {
			  return new Result("登录失败, 请输入用户名和密码");
		  }
		  
		  User user = userDao.getUserByAccountAndPassword(reqUser.getUserAccount(), reqUser.getUserPassword());
	      if(user != null) {
	    	  String webPath = this.getClass().getResource("/").getPath().replaceAll("%20", " ");
	    	  String path = webPath.substring(0, webPath.indexOf("WEB-INF"));
	    	  System.out.println(webPath);
	    	  System.out.println(path);
	    	  user.setUserPassword("");
	    	  session.setAttribute("user", user);
	    	  session.setAttribute("userId", user.getUserId());
	    	  session.setAttribute("userName", user.getUserName());
	    	  session.setAttribute("roleName", user.getRole().getRoleName());
	    	  session.setAttribute("rId", user.getRole().getRoleId());
	    	  if(Integer.parseInt(user.getRole().getRoleId()) == 4) {
	    		  int num = userDao.getAccountRecord(1);
//	    		  System.out.println(num);
	    		  String n = "" + num;
	    		  session.setAttribute("checkNum", n);
	    		  
	    		  int num1 = userDao.getAccountTable(6);
	    		  int num2 = userDao.getAccountTable(7);
	    		  int nu = num1 + num2;
	    		  session.setAttribute("excepNum", "" + nu);
//	    		  System.out.println(session.getAttribute("checkNum"));
	    	  }
	    	  
	    	  if(Integer.parseInt(user.getRole().getRoleId()) == 5) {
	    		  int num = userDao.getAccountRecord(2);
	    		  System.out.println(num);
	    		  String n = "" + num;
	    		  session.setAttribute("checkNumSec", n);
	    	  }
	    	  
	    	  if(Integer.parseInt(user.getRole().getRoleId()) == 6) {
	    		  int num = userDao.getAccountTable(1);
	    		  System.out.println(num);
	    		  String n = "" + num;
	    		  session.setAttribute("playNum", n);
	    	  }
	    	  
	    	  if(Integer.parseInt(user.getRole().getRoleId()) == 7) {
	    		  int num = userDao.getAccountTable(2);
	    		  System.out.println(num);
	    		  String n = "" + num;
	    		  session.setAttribute("playNum", n);
	    	  }
	    	  
	    	  if(Integer.parseInt(user.getRole().getRoleId()) == 10) {
	    		  int num = userDao.getAccountTable(5);
	    		  int num1 = userDao.getAccountTable(7);
	    		  System.out.println(num);
	    		  int nu = num + num1;
	    		  String n = "" + nu;
	    		  session.setAttribute("broadNum", n);
	    	  }
	    	  
	    	  //加载该用户的权限
	    	  List<Resource> userResources = resourceDao.findByRole(user.getRole().getRoleId());
	    	  for(Resource r : userResources) {
	    		  System.out.println(r);
	    	  }
	    	  session.setAttribute("userResources", userResources);
	    	  //每次登录移除以下属性, 该属性是该角色运行查看的地区
	    	  session.removeAttribute("allowAreaName");
	    	  return new Result(true, "");
	      } else {  
	    	  return new Result("用户名或者密码不正确");
	      }  
	  }
	  
	  
	  @RequestMapping(value="/reqLogout")
	  @ResponseBody
	  public String reqLogout(HttpSession session) {
		   session.invalidate();  //是让当前浏览器的session销毁,也就是一个session被销毁，比如用户登录后注销就用这个，因为注销意味着该用户session中的所有属性均失效。
		   return "true";
	  }
	
}
