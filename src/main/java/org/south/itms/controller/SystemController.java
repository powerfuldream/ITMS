package org.south.itms.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.south.itms.dao.impl.AreaDao;
import org.south.itms.dao.impl.ResourceDao;
import org.south.itms.dao.impl.UserDao;
import org.south.itms.dto.AuthorityRole;
import org.south.itms.dto.EasyuiDatagrid;
import org.south.itms.dto.Page;
import org.south.itms.dto.PageResultData;
import org.south.itms.dto.PageResultDataOne;
import org.south.itms.dto.Result;
import org.south.itms.dto.TreeDate;
import org.south.itms.dto.UserDto;
import org.south.itms.entity.Area;
import org.south.itms.entity.Resource;
import org.south.itms.entity.Role;
import org.south.itms.entity.SysLog;
import org.south.itms.entity.User;
import org.south.itms.interceptor.CoreInterceptor;
import org.south.itms.service.impl.CommonService;
import org.south.itms.service.impl.SystemService;
import org.south.itms.util.Constant;
import org.south.itms.util.EntityUtil;
import org.south.itms.util.SqlUtil;
import org.south.itms.util.StringUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @author: yezilong
 */

@Controller  
@RequestMapping("/system")  
public class SystemController {  

	 @Autowired
	 private CommonService commonService;
	 
	 @Autowired
	 private SystemService systemService;
	
	
	 @Autowired
	 private ResourceDao resourceDao;
	 
	 @Autowired  
	 private AreaDao areaDao;
	 
	 @Autowired
	 private UserDao userDao;
	 
	 
	  @RequestMapping("/resource/resourceList")  
	  public String resourceList(){  
	     return "system/resource/resourceList";
	  }
	  
	  
	  @RequestMapping("/role/roleList")  
	  public String roleList(){  
	     return "system/role/roleList";
	  }
	  
	  @RequestMapping("/role/authList")  
	  public String authList(HttpSession session){
		  List<Role> roles = systemService.findAllRole();
//		  List<AuthorityRole> listAR = new ArrayList<AuthorityRole>();
		  List<Resource> resources = systemService.findAllResource();
		  List<Resource> listRs = new ArrayList<Resource>();
		  for(Resource r : resources) {
			  if(r.getParentName() == null || "".equals(r.getParentName())) {
			  }else {
				  listRs.add(r);
			  }
		  }
//		  for(Resource r:resources) {
//			  System.out.println(r);
//		  }
//		  System.out.println("listR=" + listRs);
//		  for(Role r : roles) {
//			  Map<String, List<Resource>> map = userDao.getAllResource(r.getRoleId());
//			  AuthorityRole ar = new AuthorityRole(r.getRoleName(), map, r.getRoleId());
//			  listAR.add(ar);
//		  }
//		  if(session.getAttribute("listAR") != null || !"".equals(session.getAttribute("listAR"))) {
//    		  session.removeAttribute("listAR");
//    	  }
//    	  session.setAttribute("listAR", listAR);
    	  session.setAttribute("listRs", listRs);
    	  session.setAttribute("RoleOnce", roles);
	      return "system/author/authorList";
	  }
	  
	  @RequestMapping(value="/treeRole")  
	  public @ResponseBody List<TreeDate> treeRole() {
		  List<Role> roles = systemService.findAllRole();
		  List<TreeDate> list = new ArrayList<TreeDate>();
		  Map<String, List<Resource>> mapAll = new HashMap<String, List<Resource>>();
		  for(Role r : roles) {
			  Map<String, List<Resource>> map = userDao.getAllResource(r.getRoleId());
			  TreeDate tree = EntityUtil.getTreeData(r.getRoleName(), map);
			  list.add(tree);
		  }
		  return list;
	  }
	  
	  @RequestMapping(value="/changeRole")  
	  public @ResponseBody PageResultDataOne<Resource> changeRole(String rid) {
		  System.out.println("rid=" + rid);
		  List<Resource> rs = userDao.findResourceById(rid);
		  List<Resource> resources = systemService.findAllResource();
		  List<Resource> listRs = new ArrayList<Resource>();
		  for(Resource r : resources) {
			  if(r.getParentName() == null || "".equals(r.getParentName())) {
			  }else {
				  listRs.add(r);
			  }
		  }
		  System.out.println("Rs=" + rs);
		  System.out.println("listRs=" + listRs);
		  List<Integer> list = new ArrayList<Integer>();
		  for(Resource r : listRs) {
			  //System.out.println("name=" + r.getResourceName());
			  if(checkFlag(r.getResourceName(), rs)) {
				  list.add(1);
			  }else {
				  list.add(0);
			  }
		  }
		  PageResultDataOne<Resource> pageResult = new PageResultDataOne<Resource>();
		  pageResult.setCode(0);
		  pageResult.setMsg("true");
		  pageResult.setCount(rs.size());
		  pageResult.setData(listRs);
		  pageResult.setFlag(list);
		  return pageResult;
	  }
	  
	  private boolean checkFlag(String resourceName, List<Resource> rs) {
		  boolean flag = false;
		  for(int i = 0; i < rs.size(); i++) {
			  if(resourceName.equals(rs.get(i).getResourceName())) {
				  flag = true;
				  break;
			  }else {
				  flag = false;
			  }
		  }
		return flag;
	  }
	  
	  @RequestMapping("updateAuthority")  
	  public @ResponseBody String updateAuthority(String roleId, String authorityList){
		  System.out.println(roleId + "=" + authorityList);
		  if("".equals(roleId) || "".equals(authorityList)) {
			  return "false";
		  }else {
			  userDao.updateAuthor(roleId, authorityList);
		  }
	      return "true";
	  }


	@RequestMapping("/user/userList")  
	  public String userList(){  
	     return "system/user/userList";
	  }
	  
	  
	  @RequestMapping(value="/resource/addResource")  
	  public @ResponseBody Result addResource(Resource resource) {
		  if(resource == null || StringUtil.isEmpty(resource.getResourceName()) || StringUtil.isEmpty(resource.getResourceUrl())) {
			  return new Result("添加错误");
		  }
		  
		  
		  //resource.setResourceId(UUID.randomUUID().toString());
		  resource.setDeleted(0);
		  
		  //验证唯一性,资源的名和url必须是唯一的
		  if(systemService.countResourceByNameOrUrl(resource) > 0) {
			  return new Result("添加失败,资源名或者url已经存在");
		  }
		  
		  systemService.saveResource(resource); 
		  if("public".equals(resource.getResourceType())) {  //如果添加的是公共资源,刷新拦截器持有的公共资源
			  List<Resource> publicResources = CoreInterceptor.getPublicResources();
			  publicResources.add(resource);
			  CoreInterceptor.updatePublicResources(publicResources);
		  }
		  return new Result(true, "");
	  }
	  
	  
	  @RequestMapping(value="/resource/delResource")  
	  public @ResponseBody Result delResource(String[] resourceIds) {
		  if(resourceIds == null || resourceIds.length < 1) {
			  System.out.println("服务器接收参数有误！！");
			  return new Result("删除错误");
		  } 
			  
		  //开始更新数据
		  try {
			  systemService.deleteResource(resourceIds);
			  CoreInterceptor.updatePublicResources(resourceDao.findByType("public"));   //可能删除了公共资源,刷新拦截器持有的公共资源
			  return new Result(true, "");
		  } catch(Exception e) {
			  e.printStackTrace();
			  return new Result("删除错误");
		  }
		  
	  }
	  
	  
	  @RequestMapping(value="/resource/findAll")  
	  public @ResponseBody EasyuiDatagrid resourceFindAll() {
		 List<Resource> resources = systemService.findAllResource();
		 return new EasyuiDatagrid<Resource>(resources);
	  }
	  
	  
	  @RequestMapping(value="/resource/searchResource")  
	  public @ResponseBody PageResultData<Resource> searchResource(String param, int page, int limit) {
		  String[] params = param.split(",");  
		  try {
			   Page pageD = commonService.pageSearchByTemplateHQL(params, page, limit, "Resource", null, null);
			   PageResultData<Resource> pageResult = new PageResultData<Resource>();
			   pageResult.setCount(pageD.getTotalRecord());
			   pageResult.setCode(0);
			   pageResult.setMsg("");
			   pageResult.setData(pageD.getList());
			   return pageResult;
		   } catch(Exception e) {
			   e.printStackTrace();
			   PageResultData<Resource> pageResult = new PageResultData<Resource>();
				pageResult.setCount(0);
				pageResult.setFail(1);
				pageResult.setCode(0);
				pageResult.setMsg("查询失败");
				return pageResult;
		   }
	  }
	  
	  
	  
	  @RequestMapping(value="/resource/findAllExceptTerminal")  
	  public @ResponseBody EasyuiDatagrid resourceFindAllExceptTerminal() {
		 List<Resource> resources = systemService.findAllResourceExceptTerminal();
		 return new EasyuiDatagrid<Resource>(resources);
	  }
	  
	  
	  @RequestMapping(value="/resource/editResource")  
	  public @ResponseBody Result editResource(Resource resource) {
		  if(resource == null || StringUtil.isEmpty(resource.getResourceName()) || StringUtil.isEmpty(resource.getResourceUrl()) || StringUtil.isEmpty(resource.getResourceId())) {
			  return new Result("修改错误");
		  }
		  
		  //验证唯一性,资源的名和url必须是唯一的
		  if(systemService.countResourceByNameOrUrl(resource) > 0) {
			  return new Result("修改失败,资源名或者url已经存在");
		  }
		  
		  systemService.updateResource(resource);
		  CoreInterceptor.updatePublicResources(resourceDao.findByType("public"));   //可能修改了公共资源,刷新拦截器持有的公共资源
		  return new Result(true, "");
	  }
	  
	  
	  @RequestMapping(value="/resource/getResourceByRoleAndType")  
	  public @ResponseBody Result getResourceByRoleAndType(String roleId, String resourceType) {
		  if(StringUtil.isEmpty(roleId) || StringUtil.isEmpty(resourceType)) {
			  return new Result("获取资源错误");
		  }
		  
		  List<Resource> resources = resourceDao.findByRoleAndType(roleId, resourceType);
		  
		  return new Result(true, resources);
	  }
	  
	  
	  @RequestMapping(value="/resource/findResourceByType")  
	  public @ResponseBody Result findResourceByType(String resourceType) {
		  if(StringUtil.isEmpty(resourceType)) {
			  return new Result("获取资源错误");
		  }
		  
		  List<Resource> resources = resourceDao.findByType(resourceType);
		  
		  return new Result(true, resources);
	  }
	  
	  
	  
	  
	  @RequestMapping(value="/user/addUser")  
	  public @ResponseBody Result addUser(User user) {
		  if(user == null || StringUtil.isEmpty(user.getUserAccount()) || user.getRole() == null || StringUtil.isEmpty(user.getRole().getRoleId())) {
			  return new Result("添加错误");
		  }
		  
		 // user.setUserId(UUID.randomUUID().toString());
		  user.setState("激活");
		  user.setDeleted(0);
		  
		  //验证唯一性,账号必须是唯一的
		  if(systemService.countUserByAccount(user) > 0) {
			  return new Result("添加失败,账号已经存在");
		  }
		  
		  systemService.saveUser(user);
		  return new Result(true, "");
	  }
	  
	  
	  @RequestMapping(value="/user/delUser")  
	  public @ResponseBody Result delUser(String[] userIds) {
		  if(userIds == null || userIds.length < 1) {
			  System.out.println("服务器接收参数有误！！");
			  return new Result("删除错误");
		  } 
			  
		  //开始更新数据
		  try {
			  systemService.deleteUser(userIds);
			  return new Result(true, "");
		  } catch(Exception e) {
			  e.printStackTrace();
			  return new Result("删除错误");
		  }
		  
	  }
	  

	  @RequestMapping(value="/user/searchUser")  
	  public @ResponseBody PageResultData<UserDto> searchUser(String param, int page, int limit) {
		  String[] params = param.split(","); 
		  try {
			   Page pageD = commonService.pageSearchByTemplateHQL(params, page, limit, "User", "userAccount asc", null);
			   List<User> listU = pageD.getList();
			   List<UserDto> list = EntityUtil.getUserDto(listU);
			   PageResultData<UserDto> pageResult = new PageResultData<UserDto>();
			   pageResult.setCount(pageD.getTotalRecord());
			   pageResult.setCode(0);
			   pageResult.setMsg("");
			   pageResult.setData(list);
			   return pageResult;
		   } catch(Exception e) {
			   e.printStackTrace();
			   PageResultData<UserDto> pageResult = new PageResultData<UserDto>();
				pageResult.setCount(0);
				pageResult.setFail(1);
				pageResult.setCode(0);
				pageResult.setMsg("查询失败");
				return pageResult;
		   }
	  }
	  
	  
	  @RequestMapping(value="/user/editUser")  
	  public @ResponseBody Result editUser(User user) {
		  System.out.println(user);
		  if(user == null || StringUtil.isEmpty(user.getUserAccount()) || user.getRole() == null  || StringUtil.isEmpty(user.getRole().getRoleId())) {
			  return new Result("修改错误");
		  }
		  
		  //验证唯一性,账号必须是唯一的
		  if(systemService.countUserByAccount(user) > 0) {
			  return new Result("修改失败,账号已经存在");
		  }
		  
		  
		  
		  //更新的参数
		  Map<String, String> paramMap = new HashMap<String, String>();
		  paramMap.put("userAccount", user.getUserAccount());
		  paramMap.put("userName", user.getUserName());
		  paramMap.put("role.roleId", user.getRole().getRoleId());
		  paramMap.put("cellphone", user.getCellphone());
		  paramMap.put("email", user.getEmail());
		  //更新的where条件
		  Map<String, String> whereMap = new HashMap<String, String>();
		  whereMap.put("userId", user.getUserId());
		  //开始更新数据
		  try {
			  commonService.updateByHQL(SqlUtil.growUpdateHql("User", paramMap, whereMap));
			  return new Result(true, "");
		  } catch(Exception e) {
			  e.printStackTrace();
			  return new Result("修改错误");
		  }
		
	  }
	 
	  
	  
	  
	  @RequestMapping(value="/user/editPassword")  
	  public @ResponseBody Result editPassword(User user) {
		  if(user == null || StringUtil.isEmpty(user.getUserId()) || StringUtil.isEmpty(user.getUserPassword())) {
			  return new Result("修改错误");
		  }
		  
		  //更新的参数
		  Map<String, String> paramMap = new HashMap<String, String>();
		  paramMap.put("userPassword", user.getUserPassword());
		  //更新的where条件
		  Map<String, String> whereMap = new HashMap<String, String>();
		  whereMap.put("userId", user.getUserId());
		  //开始更新数据
		  try {
			  commonService.updateByTemplateHQL(SqlUtil.growUpdateHqlTemplate("User", paramMap, whereMap), paramMap, whereMap);
			  return new Result(true, "");
		  } catch(Exception e) {
			  e.printStackTrace();
			  return new Result("修改错误");
		  }
		
	  }
	  
	  //author 张一鸣
	  //2018.5.8 增加右上角修改密码 
	  @RequestMapping(value="/user/editUserPassword")  
	  public @ResponseBody Result editUserPassword(User user,HttpSession session) {
		  if(user == null || StringUtil.isEmpty(user.getUserPassword())) {
			  return new Result("修改错误");
		  }
		  
		  //更新的参数
		  Map<String, String> paramMap = new HashMap<String, String>();
		  paramMap.put("userPassword", user.getUserPassword());
		  //更新的where条件
		  Map<String, String> whereMap = new HashMap<String, String>();
		  
		  whereMap.put("userId", (String)session.getAttribute("userId"));
		  //开始更新数据
		  try {
			  commonService.updateByTemplateHQL(SqlUtil.growUpdateHqlTemplate("User", paramMap, whereMap), paramMap, whereMap);
			  return new Result(true, "");
		  } catch(Exception e) {
			  e.printStackTrace();
			  return new Result("修改错误");
		  }
		
	  }
	  
	  
	  @RequestMapping(value="/role/addRole")  
	  public @ResponseBody Result addRole(Role role) {
		  if(role == null || StringUtil.isEmpty(role.getRoleName())) {
			  return new Result("添加错误");
		  }
		  
		  
		  //role.setRoleId(UUID.randomUUID().toString());
		  role.setCreateDate(new Date());
		  role.setDeleted(0);
		  
		  //验证唯一性,资源的名和url必须是唯一的
		  if(systemService.countRoleByName(role) > 0) {
			  return new Result("添加失败,角色名已经存在");
		  }
		  
		  systemService.saveRole(role);
		  return new Result(true, "");
	  }
	  
	  
	  
	  @RequestMapping(value="/role/delRole")  
	  public @ResponseBody Result delRole(String[] roleIds) {
		  if(roleIds == null || roleIds.length < 1) {
			  System.out.println("服务器接收参数有误！！");
			  return new Result("删除错误");
		  } 
			  
		  //开始更新数据
		  try {
			  systemService.deleteRole(roleIds);
			  return new Result(true, "");
		  } catch(Exception e) {
			  e.printStackTrace();
			  return new Result("删除错误");
		  }
		  
	  }
	  
	  
	  @RequestMapping(value="/role/findAll")  
	  public @ResponseBody EasyuiDatagrid roleFindAll() {
		 List<Role> roles = systemService.findAllRole();
		 return new EasyuiDatagrid<Role>(roles);
	  }
	  
	  @RequestMapping(value="/role/findAllRole")  
	  public @ResponseBody PageResultData<Role> findAllRole(int page, int limit) {
		  String[] params = new String[0];
		  try {
			   Page pageD = commonService.pageSearchByTemplateHQL(params, page, limit, "Role", "", null);
			   PageResultData<Role> pageResult = new PageResultData<Role>();
			   pageResult.setCount(pageD.getTotalRecord());
			   pageResult.setCode(0);
			   pageResult.setMsg("");
			   pageResult.setData(pageD.getList());
			   return pageResult;
		   } catch(Exception e) {
			   e.printStackTrace();
			   PageResultData<Role> pageResult = new PageResultData<Role>();
				pageResult.setCount(0);
				pageResult.setFail(1);
				pageResult.setCode(0);
				pageResult.setMsg("查询失败");
				return pageResult;
		   }
	  }
	  
	  
	  @RequestMapping(value="/role/editRole")  
	  public @ResponseBody Result editRole(Role role) {
		  if(role == null || StringUtil.isEmpty(role.getRoleName()) || StringUtil.isEmpty(role.getRoleId())) {
			  return new Result("修改错误");
		  }
		  
		  //验证唯一性,资源的名和url必须是唯一的
		  if(systemService.countRoleByName(role) > 0) {
			  return new Result("修改失败,角色名已经存在");
		  }
		  
		  //更新的参数
		  Map<String, String> paramMap = new HashMap<String, String>();
		  paramMap.put("roleName", role.getRoleName());
		  paramMap.put("roleDescribe", role.getRoleDescribe());
		  //更新的where条件
		  Map<String, String> whereMap = new HashMap<String, String>();
		  whereMap.put("roleId", role.getRoleId());
		  //开始更新数据
		  try {
			  commonService.updateByTemplateHQL(SqlUtil.growUpdateHqlTemplate("Role", paramMap, whereMap), paramMap, whereMap);
			  return new Result(true, "");
		  } catch(Exception e) {
			  e.printStackTrace();
			  return new Result("修改错误");
		  }
		
	  }
	  
	  
	  @RequestMapping(value="/role/setResourceInit")  
	  public @ResponseBody Result setResourceInit(String roleId, String resourceType) {
		  if(StringUtil.isEmpty(roleId) || StringUtil.isEmpty(resourceType)) {
			  return new Result("获取资源错误, 没有传递参数");
		  }
		  
		  try {
			  List<Resource> resources = resourceDao.findByType(resourceType);
			  List<Resource> roleResources = resourceDao.findByRoleAndType(roleId, resourceType);
			  List<Object> list = new ArrayList<Object>();
			  list.add(resources);
			  list.add(roleResources);
			  return new Result(true, list); 
		  } catch(Exception e) {
			  e.printStackTrace();
			  return new Result("获取资源错误");
		  }
	  }
	  
	  
	  @RequestMapping(value="/role/setResource")  
	  public @ResponseBody Result setResource(String roleId, String resourceType, String[] resourceIds) {
		  if(StringUtil.isEmpty(roleId) || StringUtil.isEmpty(resourceType)) { //非空验证
			  return new Result("配置资源错误, 没有传递参数");
		  }
	
		  try {
			  systemService.buildRoleResourceRelation(roleId, resourceType, resourceIds);
			  return new Result(true, ""); 
		  } catch(Exception e) {
			  e.printStackTrace();
			  return new Result("配置资源发生错误");
		  }
	  }
	  
	  
	  
	  
	  @RequestMapping(value="/goTerminalPowerJsp")  
	  public String goTerminalPowerJsp() {
		  return "system/terminalPower/terminalPower";
	  }
	  
	  
	  
	  
	  @RequestMapping(value="/setPlayTerminalInit")  
	  public @ResponseBody Result setPlayTerminalInit(String roleId) {
		  if(StringUtil.isEmpty(roleId)) { //非空验证
			  return new Result("初始化配置管理播放端权限错误, 没有传递参数");
		  }
	
		  try {
			  List<Resource> resources = resourceDao.findByRoleAndType(roleId, Constant.terminalResourceType);
			  return new Result(true, resources); 
		  } catch(Exception e) {
			  e.printStackTrace();
			  return new Result("初始化配置管理播放端权限错误");
		  }
	  }
	  
	  
	  @RequestMapping(value="/setPlayTerminal")  
	  public @ResponseBody Result setPlayTerminal(String roleId, String[] urls) {  //设置播放端权限
		  if(StringUtil.isEmpty(roleId)) { //非空验证
			  return new Result("配置管理播放端权限错误, 没有传递参数");
		  }
	
		  try {
			  //先将播放端的权限url插入数据库资源表
			  String[] resourceIds = systemService.saveTerminalPowerUrl(roleId, urls);
			  //建立角色与对应资源的关系
			  systemService.buildRoleResourceRelation(roleId, Constant.terminalResourceType, resourceIds);
			  return new Result(true, ""); 
		  } catch(Exception e) {
			  e.printStackTrace();
			  return new Result("配置管理播放端权限错误");
		  }
	  }
	  
  
}  
