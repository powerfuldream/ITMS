package org.south.itms.controller;

import java.util.List;

import org.south.itms.dto.Page;
import org.south.itms.dto.PageResultData;
import org.south.itms.dto.Result;
import org.south.itms.entity.ErrorLog;
import org.south.itms.entity.HeartbeatLog;
import org.south.itms.entity.PlayLog;
import org.south.itms.entity.SysLog;
import org.south.itms.entity.TransferLog;
import org.south.itms.service.impl.CommonService;
import org.south.itms.service.impl.LogService;
import org.south.itms.util.StringUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller("logController")
@RequestMapping("/logController")
public class LogController {

	@Autowired
	private CommonService commonService;

	@Autowired
	private LogService logService;
	
	
	//系统日志
	@RequestMapping("/sysLogList")
	public String sysLogList() {
		return "log/sysLogList";
	}


	@RequestMapping(value = "/searchSysLog")
	public @ResponseBody PageResultData<SysLog> searchSysLog(String param, int page, int limit, String whereSuffix) {
		System.out.println(whereSuffix);
		String[] params = param.split(",");
//		for(String s : params) {
//			System.out.println(s + " ");
//		}
		try {
			if(StringUtil.isEmpty(whereSuffix)) whereSuffix = null;
			Page pageD = commonService.pageSearchByTemplateHQL(params, page, limit, "SysLog", "recordDate desc", whereSuffix);
			List<SysLog> list = pageD.getList();
			PageResultData<SysLog> pageResult = new PageResultData<SysLog>();
			pageResult.setCount(pageD.getTotalRecord());
			pageResult.setCode(0);
			pageResult.setMsg("");
			pageResult.setData(list);
			return pageResult;
		} catch (Exception e) {
			e.printStackTrace();
			PageResultData<SysLog> pageResult = new PageResultData<SysLog>();
			pageResult.setCount(0);
			pageResult.setCode(0);
			pageResult.setMsg("");
			return pageResult;
		}
	}
	
	
	 @RequestMapping(value="/delSysLog")  
	 public @ResponseBody Result delSysLog(String[] ids) {
		  if(ids == null || ids.length < 1) {
			  return new Result("删除错误");
		  } 
			  
		  //开始更新数据
		  try {
			  logService.delSysLog(ids);
			  return new Result(true, "");
		  } catch(Exception e) {
			  e.printStackTrace();
			  return new Result("删除错误");
		  }
		  
	  }
	 
	 
	//传输日志
	@RequestMapping("/transferLogList")
	public String transferLogList() {
		return "log/transferLogList";
	}


	@RequestMapping(value = "/searchTransferLog")
	public @ResponseBody PageResultData<TransferLog> searchTransferLog(String param, int page, int limit, String whereSuffix) {
		String[] params = param.split(",");
		try {
			if(StringUtil.isEmpty(whereSuffix)) whereSuffix = null;
			Page pageD = commonService.pageSearchByTemplateHQL(params, page, limit, "TransferLog", "transferEndTime desc", whereSuffix);
			List<TransferLog> list = pageD.getList();
			PageResultData<TransferLog> pageResult = new PageResultData<TransferLog>();
			pageResult.setCount(pageD.getTotalRecord());
			pageResult.setCode(0);
			pageResult.setMsg("");
			pageResult.setData(list);
			return pageResult;
		} catch (Exception e) {
			e.printStackTrace();
			PageResultData<TransferLog> pageResult = new PageResultData<TransferLog>();
			pageResult.setCount(0);
			pageResult.setCode(0);
			pageResult.setMsg("");
			return pageResult;
		}
	}
	
	
	 @RequestMapping(value="/delTransferLog")  
	 public @ResponseBody Result delTransferLog(String[] ids) {
		  if(ids == null || ids.length < 1) {
			  return new Result("删除错误");
		  } 
			  
		  //开始更新数据
		  try {
			  logService.delTransferLog(ids);
			  return new Result(true, "");
		  } catch(Exception e) {
			  e.printStackTrace();
			  return new Result("删除错误");
		  }
		  
	  }
 
	 
	 
	 
	//心跳日志
	@RequestMapping("/heartbeatLogList")
	public String heartbeatLogList() {
		return "log/heartbeatLogList";
	}


	@RequestMapping(value = "/searchHeartbeatLog")
	public @ResponseBody PageResultData<HeartbeatLog> searchHeartbeatLog(String param, int page, int limit, String whereSuffix) {
		String[] params = param.split(",");
		try {
			if(StringUtil.isEmpty(whereSuffix)) whereSuffix = null;
			Page pageD = commonService.pageSearchByTemplateHQL(params, page, limit, "HeartbeatLog", "recordTime desc", whereSuffix);
			List<HeartbeatLog> list = pageD.getList();
			PageResultData<HeartbeatLog> pageResult = new PageResultData<HeartbeatLog>();
			pageResult.setCount(pageD.getTotalRecord());
			pageResult.setCode(0);
			pageResult.setMsg("");
			pageResult.setData(list);
			return pageResult;
		} catch (Exception e) {
			e.printStackTrace();
			PageResultData<HeartbeatLog> pageResult = new PageResultData<HeartbeatLog>();
			pageResult.setCount(0);
			pageResult.setCode(0);
			pageResult.setMsg("");
			return pageResult;
		}
	}
	
	
	 @RequestMapping(value="/delHeartbeatLog")  
	 public @ResponseBody Result delHeartbeatLog(String[] ids) {
		  if(ids == null || ids.length < 1) {
			  return new Result("删除错误");
		  } 
			  
		  //开始更新数据
		  try {
			  logService.delHeartbeatLog(ids);
			  return new Result(true, "");
		  } catch(Exception e) {
			  e.printStackTrace();
			  return new Result("删除错误");
		  }
		  
	  }
	 
	 
	 
	//播放日志
	@RequestMapping("/playLogList")
	public String playLogList() {
		return "log/playLogList";
	}


	@RequestMapping(value = "/searchPlayLog")
	public @ResponseBody PageResultData<PlayLog> searchPlayLog(String param, int page, int limit, String whereSuffix) {
		String[] params = param.split(",");
		try {
			if(StringUtil.isEmpty(whereSuffix)) whereSuffix = null;
			Page pageD = commonService.pageSearchByTemplateHQL(params, page, limit, "PlayLog", "playEndTime desc", whereSuffix);
			List<PlayLog> list = pageD.getList();
			PageResultData<PlayLog> pageResult = new PageResultData<PlayLog>();
			pageResult.setCount(pageD.getTotalRecord());
			pageResult.setCode(0);
			pageResult.setMsg("");
			pageResult.setData(list);
			return pageResult;
		} catch (Exception e) {
			e.printStackTrace();
			PageResultData<PlayLog> pageResult = new PageResultData<PlayLog>();
			pageResult.setCount(0);
			pageResult.setCode(0);
			pageResult.setMsg("");
			return pageResult;
		}
	}
	
	
	 @RequestMapping(value="/delPlayLog")  
	 public @ResponseBody Result delPlayLog(String[] ids) {
		  if(ids == null || ids.length < 1) {
			  return new Result("删除错误");
		  } 
			  
		  //开始更新数据
		  try {
			  logService.delPlayLog(ids);
			  return new Result(true, "");
		  } catch(Exception e) {
			  e.printStackTrace();
			  return new Result("删除错误");
		  }
		  
	  }

	 
	//错误日志
	@RequestMapping("/errorLogList")
	public String errorLogList() {
		return "log/errorLogList";
	}


	@RequestMapping(value = "/searchErrorLog")
	public @ResponseBody PageResultData<ErrorLog> searchErrorLog(String param, int page, int limit, String whereSuffix) {
		String[] params = param.split(",");
		try {
			if(StringUtil.isEmpty(whereSuffix)) whereSuffix = null;
			Page pageD = commonService.pageSearchByTemplateHQL(params, page, limit, "ErrorLog", "recordDate desc", whereSuffix);
			List<ErrorLog> list = pageD.getList();
			PageResultData<ErrorLog> pageResult = new PageResultData<ErrorLog>();
			pageResult.setCount(pageD.getTotalRecord());
			pageResult.setCode(0);
			pageResult.setMsg("");
			pageResult.setData(list);
			return pageResult;
		} catch (Exception e) {
			e.printStackTrace();
			PageResultData<ErrorLog> pageResult = new PageResultData<ErrorLog>();
			pageResult.setCount(0);
			pageResult.setCode(0);
			pageResult.setMsg("");
			return pageResult;
		}
	}
	
	
	 @RequestMapping(value="/delErrorLog")  
	 public @ResponseBody Result delErrorLog(String[] ids) {
		  if(ids == null || ids.length < 1) {
			  return new Result("删除错误");
		  } 
			  
		  //开始更新数据
		  try {
			  logService.delErrorLog(ids);
			  return new Result(true, "");
		  } catch(Exception e) {
			  e.printStackTrace();
			  return new Result("删除错误");
		  }
		  
	  }
	 
	 
	 
}
