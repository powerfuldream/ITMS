package org.south.itms.controller;

import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.south.itms.dao.impl.AreaDao;
import org.south.itms.dao.impl.CommonDao;
import org.south.itms.dao.impl.ResourceDao;
import org.south.itms.dao.impl.TerminalDao;
import org.south.itms.dto.Page;
import org.south.itms.dto.PageResultData;
import org.south.itms.dto.Result;
import org.south.itms.dto.ValueParam;
import org.south.itms.entity.Area;
import org.south.itms.entity.Role;
import org.south.itms.entity.Terminal;
import org.south.itms.entity.User;
import org.south.itms.service.impl.CommonService;
import org.south.itms.service.impl.SystemService;
import org.south.itms.service.impl.TerminalService;
import org.south.itms.util.Constant;
import org.south.itms.util.SqlUtil;
import org.south.itms.util.StringUtil;
import org.south.netty.NettyChannelMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @author: yezilong
 */

@Controller  
@RequestMapping("/terminal")  
public class TerminalController {  

  @Autowired  
  private TerminalService terminalService;
  
  @Autowired  
  private SystemService systemService;
  
  
  @Autowired 
  private TerminalDao terminalDao;
  
  @Autowired 
  private AreaDao areaDao;
  
  @Autowired 
  private CommonDao commonDao;
  
  @Autowired 
  private ResourceDao resourceDao;
  
  
  @Autowired
  private CommonService commonService;
  
  @RequestMapping("/center")  
  public String center() {  
     return "terminal/center";
  }   
  
  

  //查询播放端的方式
  @RequestMapping(value="/searchTerminal2")  
  public @ResponseBody PageResultData<Terminal> searchTerminal2(String param, int page, int limit) {
	  String[] params = param.split(",");  
	  try {
		   Page pageD = commonService.pageSearchByTemplateHQL(params, page, limit, "Terminal", "terminalName asc", null);
		   PageResultData<Terminal> pageResult = new PageResultData<Terminal>();
		   pageResult.setCount(pageD.getTotalRecord());
		   pageResult.setCode(0);
		   pageResult.setMsg("");
		   pageResult.setData(pageD.getList());
		   return pageResult;
	   } catch(Exception e) {
		    e.printStackTrace();
		    PageResultData<Terminal> pageResult = new PageResultData<Terminal>();
			pageResult.setCount(0);
			pageResult.setFail(1);
			pageResult.setCode(0);
			pageResult.setMsg("查询失败");
			return pageResult;
	   }
  }
  
  
  
  //获取全部播放端的方式
  @RequestMapping(value="/getAllTerminal")  
  public @ResponseBody Result getAllTerminal() {
	  System.out.println("getAllTerminal()");
	  List<Terminal> listTerminal = commonService.getAllTerminal();
	  
	  return new Result(true, listTerminal);
  }
  
  
  @RequestMapping(value="/delTerminal2")  
  public @ResponseBody Result delTerminal2(String[] terminalIds) {
	  if(terminalIds == null || terminalIds.length < 1) {
		  System.out.println("服务器接收参数有误！！");
		  return new Result("删除错误");
	  } 
	  
  

	  try { 
		  //开始更新数据
		  terminalService.deleteByHQL(terminalIds);
		  return new Result(true, "");
	  } catch(Exception e) {
		  e.printStackTrace();
		  return new Result("删除错误");
	  }
  } 
  
  
  
  @RequestMapping(value="/updateTerminalState2")  
  public @ResponseBody Result updateTerminalState2(String[] terminalIds, boolean state, String[] areaCodes) {
	  if(terminalIds == null || terminalIds.length < 1) {
		  System.out.println("服务器接收参数有误！！");
		  return new Result("修改状态失败");
	  }
	  
	  try {
		  //开始更新数据
		  terminalService.updateTerminalState(terminalIds, state);
		  return new Result(true, "");
	  } catch(Exception e) {
		  e.printStackTrace();
		  return new Result("修改状态失败");
	  }
  } 
  
  @RequestMapping(value="/updateTerminalPwd2")  
  public @ResponseBody Result updateTerminalPwd2(String terminalId, String oldPwd, String newPwd, boolean force, HttpSession session) {
	  if(StringUtil.isEmpty(terminalId) || StringUtil.isEmpty(newPwd)) {
		  return new Result("新密码不能为空");
	  }
	  
	  try {
		  if(!force) {
			  Terminal terminal = terminalDao.get(terminalId);
			  if(!terminal.getConnectPassword().equals(oldPwd)) {
				  return new Result("修改失败, 旧连接密码不正确");
			  }
				  
		  } else {   //强制修改密码
			  
			  Role role = ((User) session.getAttribute("user")).getRole();
			  if(!Constant.adminRoleName.equals(role.getRoleName())) {
				  return new Result("只有系统管理员才拥有此权限");
			  }
			  
		  }
		  
		  
		  //修改密码
		   //更新的参数
		  Map<String, String> paramMap = new HashMap<String, String>();
		  paramMap.put("connectPassword", newPwd);
		  //更新的where条件
		  Map<String, String> whereMap = new HashMap<String, String>();
		  whereMap.put("terminalId", terminalId);
		  //开始更新数据
		  terminalService.updateByHQL(SqlUtil.growUpdateHql("Terminal", paramMap, whereMap));
		  
		  
		  return new Result(true, "");
	  } catch(Exception e) {
		  e.printStackTrace();
		  return new Result("修改密码失败");
	  }
  } 
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  //查询某个地区下的播放端(用于查看终端上线与否)
  @RequestMapping("/comon/searchTerminal/{areaCode1}")  
  public @ResponseBody PageResultData<Terminal> commonSearchTerminal(@PathVariable String areaCode1, String[] params,
		  String terminalName, String ip, String state,
		  int page, int limit, HttpSession session) {
      System.out.println(terminalName + "=" + ip + "=" + state);
      String[] param = initParam(terminalName, ip, state);
      
	  Result result = searchTerminal(areaCode1, param, page, limit, session);
  	
  	if(result.isSuccess()) {  //如果有查询到结果
  		Page pageD = (Page) result.getObj();
  		List<Terminal> terminals = pageD.getList();
  		for(Terminal terminal : terminals) {  //检查每个终端，检查其是否在线与否
  			if(NettyChannelMap.containsKey(terminal.getTerminalId())) terminal.setDeleted(1);
  		}
  	}
  	
  	PageResultData<Terminal> pageResult = new PageResultData<Terminal>();
  	Page pp = (Page)result.getObj();
  	System.out.println("what is=" + pp);
	pageResult.setCount(pp.getTotalRecord());
	pageResult.setCode(0);
	pageResult.setMsg("");
	pageResult.setData(pp.getList());
	return pageResult;
  	
  }
  
  
  
  

  private String[] initParam(String terminalName, String ip, String state) {
	  int k = 0;
      if(!"".equals(terminalName)) {
    	  k++;
      }
      if(!"".equals(ip)) {
    	  k++;
      }
      if(!"".equals(state)) {
    	  k++;
      }
      String[] param = new String[k*3];
	  int len = 0;
	  if(!"".equals(terminalName)) {
		  param[len] = "terminalName";
		  len++;
		  param[len] = "like";
		  len++;
		  param[len] = "%" + terminalName + "%";
		  len++;
	  }
	  if(!"".equals(ip)) {
		  param[len] = "ip";
		  len++;
		  param[len] = "like";
		  len++;
		  param[len] = "%" + ip + "%";
		  len++;
	  }
	  if(!"".equals(state)) {
		  param[len] = "state";
		  len++;
		  param[len] = "=";
		  len++;
		  param[len] = state;
		  len++;
	  }
	return param;
}



//查询某个地区下的播放端
  @RequestMapping("/searchTerminal/{areaCode1}")  
  public @ResponseBody Result searchTerminal(@PathVariable String areaCode1, String[] params, int currentPage, int pageSize, HttpSession session) {
	  
	  if(StringUtil.isEmpty(areaCode1))  { //非空验证
		  return new Result("没有输入查询地区"); 
	  }
	  
	  
	  try {
		  //组装查询条件
		  Map<String, ValueParam> whereMap = new HashMap<String, ValueParam>();
		  if(params != null && (params.length % 3 == 0)) {
			  for(int i = 0; i < params.length; i+=3) {
				  whereMap.put(params[i], new ValueParam(params[i + 1], params[i + 2]));
			  }
		  }
		  
		  if(!"86".equals(areaCode1)) { //如果这个地区不是全国的话
			  whereMap.put("areaName", new ValueParam("like", "%" + areaDao.load(areaCode1).getFullName() + "%"));
		  } else {
//			  //如果查询的地区是全国，根据该角色的权限，返回可以查看的播放端
//			  Role role = ((User) session.getAttribute("user")).getRole();
//			  if(!Constant.adminRoleName.equals(role.getRoleName())) {  //特别  if start
//				  //如果不是最高权限的系统管理员查看, 就要检查权限
//				  String allowAreaName = (String) session.getAttribute("allowAreaName");
//				  if(allowAreaName == null) { //第一次获取该角色允许的地区名的话,就先初始化操作
//				      //找出该角色运行查看的地区,然后生成or子句
//					  StringBuilder str = new StringBuilder(" and ( ");
//					  List<Resource> allowLookAreaResource = resourceDao.findByUrlPrefixAndType(role.getRoleId(), Constant.searchTerminalUrlPrefix, Constant.terminalResourceType);
//					  if(allowLookAreaResource.size() == 0) return new Result("你没有权限查看任何的播放端信息!");
//					  for(Resource resource : allowLookAreaResource) {
//						 String areaCode = resource.getResourceUrl().split("/")[1];
//						 str.append("areaName like \'%");
//						 str.append(areaDao.load(areaCode).getFullName());
//						 str.append("%\' or ");
//					  }
//					  str.setLength(str.length() - 3);
//					  str.append(" ) order by areaCode asc");
//					  allowAreaName = str.toString();
//					  session.setAttribute("allowAreaName", allowAreaName);
//				  } 
//				  Page page = commonDao.pageSearchByTemplateHQL(SqlUtil.growSearchHqlTemplate("Terminal", whereMap, "") + allowAreaName, whereMap, currentPage, pageSize);
//				  return new Result(true, page);
//			  } //特别 if end
			  
			  
		  } 
		  
		  //获取查询的结果
		  Page page = commonDao.pageSearchByTemplateHQL(SqlUtil.growSearchHqlTemplate("Terminal", whereMap, "areaCode asc"), whereMap, currentPage, pageSize);
		  return new Result(true, page);
		  
	  } catch(Exception e) {
		  e.printStackTrace();
		  return new Result("查询失败");
	  }
	  
	  
  }  
  
  
  
  @RequestMapping(value="/addTerminal/{areaCode1}")  
  public @ResponseBody Result addTerminal(Terminal terminal, @PathVariable String areaCode1) {
	  if(!StringUtil.isEmpty(areaCode1)) { //非空判断
		  if("86".equals(areaCode1)) { //如果这个地区是全国的话
			  return new Result("播放端不能直接放在中国目录下");
		  }
		 
		  if(terminalService.countBySerialNumber(terminal) > 0)  return new Result("序列号码已存在");
		  
		  
		  
		  Area area = areaDao.load(areaCode1); //加载出地区的对象
		  if(area != null) {
			// terminal.setTerminalId(UUID.randomUUID().toString()); //生成主键
			 terminal.setAreaCode(areaCode1);
			 terminal.setAreaName(area.getFullName());
			 terminal.setState("激活");
			 terminal.setDeleted(0);
			 
			 //初始化三个属性
			 //terminal.setPid("-1");
			 //terminal.setPname("");
			 //terminal.setConnectPassword("");
			 
			 terminalService.save(terminal);
			 return new Result(true, terminal);
		  }
	  }
	  return new Result("添加错误");
  }  
  
  
  
  @RequestMapping(value="/editTerminal/{areaCode1}")  
  public @ResponseBody Result editTerminal(Terminal terminal, @PathVariable String areaCode1) {
	  if(StringUtil.isEmpty(areaCode1) || terminal == null || StringUtil.isEmpty(terminal.getAreaCode())) {
		  System.out.println("服务器接收参数有误！！");
		  return new Result("修改错误");
	  } else if("86".equals(terminal.getAreaCode())) { //如果这个地区是全国的话,则不行
		  return new Result("播放端不能直接放在中国目录下");
	  }
	  
	  if(terminalService.countBySerialNumber(terminal) > 0)  return new Result("序列号码已存在");
		  
      //更新的参数
	  Map<String, String> paramMap = new HashMap<String, String>();
	  paramMap.put("serialNumber", terminal.getSerialNumber());
	  paramMap.put("terminalName", terminal.getTerminalName());
	  paramMap.put("detailAddress", terminal.getDetailAddress());
	  paramMap.put("terminalDescribe", terminal.getTerminalDescribe());
	  paramMap.put("ip", terminal.getIp());
	  paramMap.put("macAddr", terminal.getMacAddr());
	  paramMap.put("resolutionLength", terminal.getResolutionLength() + "");
	  paramMap.put("resolutionWidth", terminal.getResolutionWidth() + "");
	  paramMap.put("ledLength", terminal.getLedLength() + "");
	  paramMap.put("ledWidth", terminal.getLedWidth() + "");
	  paramMap.put("startSpotTop", terminal.getStartSpotTop() + "");
	  paramMap.put("startSpotLeft", terminal.getStartSpotLeft() + "");
	  SimpleDateFormat simpleDateFormat = new SimpleDateFormat("HH:mm:ss");
	  paramMap.put("runStartTime", simpleDateFormat.format(terminal.getRunStartTime()));
	  paramMap.put("runEndTime", simpleDateFormat.format(terminal.getRunEndTime()));
	
	  Area area = areaDao.load(terminal.getAreaCode()); //加载出新地区的对象
	  if(area != null) {
		  terminal.setAreaName(area.getFullName());
		  paramMap.put("areaCode", terminal.getAreaCode());
		  paramMap.put("areaName", terminal.getAreaName());
	  } else {
		  return new Result("修改错误,不存在修改后的地区");
	  }

	  
	  //更新的where条件
	  Map<String, String> whereMap = new HashMap<String, String>();
	  whereMap.put("terminalId", terminal.getTerminalId());
	  //开始更新数据
	  try {
		  terminalService.updateByHQL(SqlUtil.growUpdateHql("Terminal", paramMap, whereMap));
		  return new Result(true, "");
	  } catch(Exception e) {
		  e.printStackTrace();
		  return new Result("修改错误");
	  }
	
	
  }  
  
  
  
  @RequestMapping(value="/delTerminal/{areaCode1}")  
  public @ResponseBody Result delTerminal(String[] terminalIds, String[] areaCodes, @PathVariable String areaCode1, HttpSession session) {
	  if(StringUtil.isEmpty(areaCode1) || terminalIds == null || terminalIds.length < 1) {
		  System.out.println("服务器接收参数有误！！");
		  return new Result("删除错误");
	  } 
	  
  

	  try {
		  
		  //如果areaCode1=86的话, 意味着从中国处选择删除某些播放端, 此时需要验证权限(系统管理员除外)
		  if("86".equals(areaCode1)) { 
			  Role role = ((User) session.getAttribute("user")).getRole();
			  if(!Constant.adminRoleName.equals(role.getRoleName())) {  
				  if(!systemService.checkPower(resourceDao.findByUrlPrefixAndType(role.getRoleId(), Constant.delTerminalUrlPrefix, Constant.terminalResourceType), areaCodes)) return new Result("你的权限不足");
			  }
		  }
		  
		  //开始更新数据
		  terminalService.deleteByHQL(terminalIds);
		  return new Result(true, "");
	  } catch(Exception e) {
		  e.printStackTrace();
		  return new Result("删除错误");
	  }
  } 
  
  
  
  @RequestMapping(value="/updateTerminalState/{areaCode1}")  
  public @ResponseBody Result updateTerminalState(String[] terminalIds, boolean state, String[] areaCodes, @PathVariable String areaCode1, HttpSession session) {
	  if(StringUtil.isEmpty(areaCode1) || terminalIds == null || terminalIds.length < 1) {
		  System.out.println("服务器接收参数有误！！");
		  return new Result("修改状态失败");
	  }
	  
	  try {
		  
		  //如果areaCode1=86的话, 意味着从中国处选择删除某些播放端, 此时需要验证权限(系统管理员除外)
		  if("86".equals(areaCode1)) { 
			  Role role = ((User) session.getAttribute("user")).getRole();
			  if(!Constant.adminRoleName.equals(role.getRoleName())) {  
				  if(!systemService.checkPower(resourceDao.findByUrlPrefixAndType(role.getRoleId(), Constant.updateTerminalStateUrlPrefix, Constant.terminalResourceType), areaCodes)) return new Result("你的权限不足");
			  }
		  }
		  
		  //开始更新数据
		  terminalService.updateTerminalState(terminalIds, state);
		  return new Result(true, "");
	  } catch(Exception e) {
		  e.printStackTrace();
		  return new Result("修改状态失败");
	  }
  } 
  
  
  
}  
