package org.south.itms.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Time;
import java.sql.Timestamp;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.south.itms.dao.impl.FileDao;
import org.south.itms.dao.impl.MaterialDao;
import org.south.itms.dao.impl.PtableDao;
import org.south.itms.dao.impl.UserDao;
import org.south.itms.dto.MaterialDto;
import org.south.itms.dto.Page;
import org.south.itms.dto.PageResultData;
import org.south.itms.dto.PtableDto;
import org.south.itms.dto.Result;
import org.south.itms.entity.File;
import org.south.itms.entity.IPTable;
import org.south.itms.entity.Items;
import org.south.itms.entity.Material;
import org.south.itms.entity.Period;
import org.south.itms.entity.PlayTable;
import org.south.itms.entity.Terminal;
import org.south.itms.entity.User;
import org.south.itms.service.impl.AcctUserService;
import org.south.itms.service.impl.CommonService;
import org.south.itms.service.impl.PtableService;
import org.south.itms.service.impl.TerminalService;
import org.south.itms.util.Constant;
import org.south.itms.util.EntityUtil;
import org.south.itms.util.SqlUtil;
import org.south.itms.util.StringUtil;
import org.south.itms.util.TimeUtil;
import org.south.netty.PlayTableTask;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @author: yezilong
 */

@Controller
@RequestMapping("/ptable")
public class PtableController {

	@Autowired
	private UserDao userDao;

	@Autowired
	private CommonService commonService;

	@Autowired
	private TerminalService terminalService;

	@Autowired
	private PtableService ptableService;

	@Autowired
	private AcctUserService userService;

	@Autowired
	private PtableDao ptableDao;

	@Autowired
	private FileDao fileDao;

	@Autowired
	private MaterialDao materialDao;

	@RequestMapping("/ptableList")
	public String ptableList(Model model, HttpServletRequest request) {
		List<Terminal> listTerminal = commonService.getAllTerminal();
		model.addAttribute("terminalPtable", listTerminal);
		// request.getSession().setAttribute("terminalPtable", listTerminal);
		List<Period> listPeriod = commonService.getAllPeriod();
		List<User> listUser = userService.getAllUser();
		request.getSession().setAttribute("periodList", listPeriod);
		model.addAttribute("periodL", listPeriod);
		model.addAttribute("userL", listUser);
		return "ptable/ptableList";
	}

	@RequestMapping("/insteadPtable")
	public String insteadPtable(Model model, HttpServletRequest request) {
		List<Terminal> listTerminal = commonService.getAllTerminal();
		model.addAttribute("terminalPtable", listTerminal);
		return "instead/insteadPtableList";
	}

	@RequestMapping("/addInsertMaterial")
	@ResponseBody
	public String addInsertMaterial(String mid, String terminalId, String intervalTime, String dateTime,
			String testDate, String stat, HttpServletRequest request) throws ParseException {

		// commonService.resetPtableState(pid);

		String[] time = testDate.split("-");
		java.sql.Time startTime = TimeUtil.translateTime(time[0].trim());
		java.sql.Time endTime = TimeUtil.translateTime(time[1].trim());
		if (TimeUtil.timeValidate(startTime, endTime)) {
			savePtable(terminalId, dateTime, startTime, endTime, stat, mid, request, intervalTime);
		} else {
			return "1";
		}
		return "true";
	}

	private void savePtable(String terminalId, String dateTime, Time startTime, Time endTime, String stat, String mid,
			HttpServletRequest request, String intervalTime) throws ParseException {
		Terminal terminal = commonService.getTerminalById(terminalId);
		Date d = TimeUtil.translateDate(dateTime);
		PlayTable ptable = new PlayTable();
		ptable.setCreateTime(new Timestamp(new Date().getTime()));
		String userId = (String) request.getSession().getAttribute("userId");
		ptable.setUserId(userId);
		ptable.setStartTime(startTime);
		ptable.setEndTime(endTime);
		ptable.setPlayDate(d);
		ptable.setDeleted(0);
		ptable.setInsertFlag(1);
		ptable.setState(Integer.parseInt(stat));
		ptable.setTerminalId(terminalId);
		ptable.setStatusId(Constant.uncheck);
		ptable.setPtableName(terminal.getTerminalName() + " 插播  (" + dateTime + ")");
		ptable.setMin(Integer.parseInt(intervalTime));
		commonService.saveInsetPlayTable(ptable, mid);
	}

	@RequestMapping("/resetPLayTableState")
	@ResponseBody
	public String resetPtableState(String pid, HttpServletRequest request) {
		System.out.println("pid=" + pid);
		commonService.resetPtableState(pid);
		return "true";
	}

	@RequestMapping("/ptableCheckFirstList")
	public String ptableCheckFirstList(Model model, HttpServletRequest request) {
		List<Period> listPeriod = commonService.getAllPeriod();
		List<User> listUser = userService.getAllUser();
		request.getSession().setAttribute("periodList", listPeriod);
		model.addAttribute("periodL", listPeriod);
		model.addAttribute("userL", listUser);
		if ((Constant.adminValue).equals((String) request.getSession().getAttribute("rId"))) {
			return "ptable/ptableCheckFinalListAdmin";
		}
		return "ptable/ptableCheckList";
	}

	@RequestMapping("/ptableCheckSecondList")
	public String ptableCheckSecondList(Model model, HttpServletRequest request) {
		List<Period> listPeriod = commonService.getAllPeriod();
		List<User> listUser = userService.getAllUser();
		request.getSession().setAttribute("periodList", listPeriod);
		model.addAttribute("periodL", listPeriod);
		model.addAttribute("userL", listUser);
		if ((Constant.adminValue).equals((String) request.getSession().getAttribute("rId"))) {
			return "ptable/ptableCheckFinalListAdmin";
		}
		return "ptable/ptableCheckFinalList";
	}

	@RequestMapping("/goAddPtable")
	public String goAddPtable(Model model, HttpServletRequest request) {
		List<Terminal> listTerminal = commonService.getAllTerminal();
		model.addAttribute("terminals", listTerminal);
		List<IPTable> listInsert = commonService.getAllIPTable(listTerminal.get(0).getTerminalId());
		model.addAttribute("insertTables", listInsert);
		request.getSession().setAttribute("tableNum", listInsert.size());
		// return "ptable/insertPtableOld";
		return "ptable/insertPtable";
	}

	@RequestMapping("/generatePtable")
	public String generatePtable(Model model, HttpServletRequest request) {
		// List<Period> list = commonService.getAllMaterialByTid("9");
		List<Period> list = commonService.getAllItemsPeriod("9");
		request.getSession().setAttribute("periodTwice", list);
		return "ptable/generatePtable";
	}

	@RequestMapping("/generatePtableExcep")
	public String generatePtableExcep(Model model, HttpServletRequest request) {
		List<Period> list = commonService.getAllMaterialByTid("9");
		request.getSession().setAttribute("periodTwice", list);
		return "ptable/generatePtableExcep";
	}

	@RequestMapping("/generateTable")
	public void generateTable(Model model, HttpServletRequest request, String periodId, String startDate,
			String endDate, HttpServletResponse response) throws IOException {
		System.out.println(periodId);

		String uid = (String) request.getSession().getAttribute("userId");
		if (uid == null || "".equals(uid)) {
			PrintWriter out = response.getWriter();
			out.print("1");
			out.flush();
			out.close();
		} else {
			if ("".equals(startDate) || "".equals(endDate)) {
				PrintWriter out = response.getWriter();
				out.print("2");
				out.flush();
				out.close();
			} else if (TimeUtil.checkTime(startDate, endDate)) {
				if (commonService.generateTb(periodId, uid, startDate, endDate)) {
					PrintWriter out = response.getWriter();
					out.print("true");
					out.flush();
					out.close();
				} else {

					PrintWriter out = response.getWriter();
					out.print("false");
					out.flush();
					out.close();
				}
			} else {
				PrintWriter out = response.getWriter();
				out.print("3");
				out.flush();
				out.close();
				// if(commonService.generateTable(periodId, uid)) {
			}
		}
	}

	@RequestMapping("/fildIPtable")
	@ResponseBody
	public PageResultData<PtableDto> fildIPtable(String terminalId, int page, int limit) {
		// List<IPTable> list = new ArrayList<IPTable>();
		List<Terminal> list = commonService.getAllTerminal();
		List<Period> listPeriod = commonService.getAllPeriod();
		List<User> listUser = commonService.getAllUser();
		if ("".equals(terminalId) || terminalId == null) {
			String[] params = new String[0];
			try {
				Page pageD = commonService.pageSearchInsertByTemplateHQL(params, page, limit, "PlayTable", "pid asc",
						null);
				List<PlayTable> listPtable = pageD.getList();
				List<PtableDto> listDto = EntityUtil.ptableDto(list, listPeriod, listUser, listPtable);
				PageResultData<PtableDto> pageResult = new PageResultData<PtableDto>();
				pageResult.setCount(pageD.getTotalRecord());
				pageResult.setCode(0);
				pageResult.setMsg("");
				pageResult.setData(listDto);
				return pageResult;
			} catch (Exception e) {
				e.printStackTrace();
				PageResultData<PtableDto> pageResult1 = new PageResultData<PtableDto>();
				pageResult1.setCount(0);
				pageResult1.setCode(0);
				pageResult1.setFail(1);
				pageResult1.setMsg("查询失败");
				return pageResult1;
			}
		} else {
			String[] params = new String[3];
			params[0] = "terminalId";
			params[1] = "=";
			params[2] = terminalId;
			try {
				Page pageD = commonService.pageSearchInsertByTemplateHQL(params, page, limit, "PlayTable", "pid asc",
						null);
				List<PlayTable> listPtable = pageD.getList();
				List<PtableDto> listDto = EntityUtil.ptableDto(list, listPeriod, listUser, listPtable);
				PageResultData<PtableDto> pageResult = new PageResultData<PtableDto>();
				pageResult.setCount(pageD.getTotalRecord());
				pageResult.setCode(0);
				pageResult.setMsg("");
				pageResult.setData(listDto);
				return pageResult;
			} catch (Exception e) {
				e.printStackTrace();
				PageResultData<PtableDto> pageResult1 = new PageResultData<PtableDto>();
				pageResult1.setCount(0);
				pageResult1.setCode(0);
				pageResult1.setFail(1);
				pageResult1.setMsg("查询失败");
				return pageResult1;
			}
		}
	}

	@RequestMapping("/resetPtable")
	public void resetPtable(HttpServletResponse response) throws IOException, ParseException {
		PlayTableTask ps = new PlayTableTask();
		ps.getFileMessage();
		ps.generateTable();
		PrintWriter out = response.getWriter();
		out.print("true");
		out.flush();
		out.close();
	}

	@RequestMapping(value = "/searchPtable")
	public @ResponseBody PageResultData<PtableDto> searchPtable(String terminalId, String statusId, String startDate,
			String endDate, int page, int limit) throws ParseException {
		String[] param = initParam(terminalId, statusId);
		List<Terminal> list = commonService.getAllTerminal();
		List<Period> listPeriod = commonService.getAllPeriod();
		List<User> listUser = commonService.getAllUser();
		if (!"".equals(startDate) && !"".equals(endDate)) {
			Date d1 = TimeUtil.translateDate(startDate);
			Date d2 = TimeUtil.translateDate(endDate);
			if (!TimeUtil.dateValidate(d1, d2)) {
				PageResultData<PtableDto> pageResult1 = new PageResultData<PtableDto>();
				pageResult1.setCount(0);
				pageResult1.setFail(1);
				pageResult1.setCode(0);
				pageResult1.setMsg("时间前后有误!!");
				return pageResult1;
			}
		}
		try {
			Page pageD = commonService.pageSearchPtableByTemplateHQL(startDate, endDate, param, page, limit,
					"PlayTable", "pid desc", null);
			List<PlayTable> listPtable = pageD.getList();
			List<PtableDto> listDto = EntityUtil.ptableDto(list, listPeriod, listUser, listPtable);
			PageResultData<PtableDto> pageResult = new PageResultData<PtableDto>();
			pageResult.setCount(pageD.getTotalRecord());
			pageResult.setCode(0);
			pageResult.setMsg("");
			pageResult.setData(listDto);
			return pageResult;
		} catch (Exception e) {
			e.printStackTrace();
			PageResultData<PtableDto> pageResult1 = new PageResultData<PtableDto>();
			pageResult1.setCount(0);
			pageResult1.setCode(0);
			pageResult1.setFail(1);
			pageResult1.setMsg("查询失败");
			return pageResult1;
		}
		// try {
		// Page page = commonService.pageSearchByTemplateHQL(params, currentPage,
		// pageSize, "PlayTable", "pid asc", null);
		// return new Result(true, page);
		// } catch (Exception e) {
		// e.printStackTrace();
		// return new Result("查询失败");
		// }
	}

	private String[] initParam(String terminalId, String statusId) {
		int k = 0;
		if (!"".equals(terminalId)) {
			k++;
		}
		if (!"".equals(statusId)) {
			k++;
		}
		String[] param = new String[k * 3];
		int len = 0;
		if (!"".equals(terminalId)) {
			param[len] = "terminalId";
			len++;
			param[len] = "=";
			len++;
			param[len] = terminalId;
			len++;
		}
		if (!"".equals(statusId)) {
			param[len] = "statusId";
			len++;
			param[len] = "=";
			len++;
			param[len] = statusId;
			len++;
		}
		return param;
	}

	@RequestMapping(value = "/searchUnckeckFirstPtable")
	public @ResponseBody PageResultData<PtableDto> searchUnckeckFirstPtable(String statusId, int page, int limit) {
		String[] param = initUncheckParam(statusId);
		List<Terminal> list = commonService.getAllTerminal();
		List<Period> listPeriod = commonService.getAllPeriod();
		List<User> listUser = commonService.getAllUser();
		try {
			Page pageD = commonService.pageSearchFirstByTemplateHQL(param, page, limit, "PlayTable", "createTime desc",
					null);
			List<PlayTable> listPtable = pageD.getList();
			List<PtableDto> listDto = EntityUtil.ptableDto(list, listPeriod, listUser, listPtable);
			PageResultData<PtableDto> pageResult = new PageResultData<PtableDto>();
			pageResult.setCount(pageD.getTotalRecord());
			pageResult.setCode(0);
			pageResult.setMsg("");
			pageResult.setData(listDto);
			return pageResult;
		} catch (Exception e) {
			e.printStackTrace();
			PageResultData<PtableDto> pageResult1 = new PageResultData<PtableDto>();
			pageResult1.setCount(0);
			pageResult1.setCode(0);
			pageResult1.setFail(1);
			pageResult1.setMsg("查询失败");
			return pageResult1;
		}
	}

	private String[] initUncheckParam(String statusId) {
		int k = 0;
		if (!"".equals(statusId)) {
			k++;
		}
		String[] param = new String[k * 3];
		int len = 0;
		if (!"".equals(statusId)) {
			param[len] = "statusId";
			len++;
			param[len] = "=";
			len++;
			param[len] = statusId;
			len++;
		}
		return param;
	}

	@RequestMapping(value = "/searchUnckeckSecondPtable")
	public @ResponseBody Result searchUnckeckSecondPtable(String[] params, int currentPage, int pageSize) {
		try {
			Page page = commonService.pageSearchSecondByTemplateHQL(params, currentPage, pageSize, "PlayTable",
					"pid asc", null);
			return new Result(true, page);
		} catch (Exception e) {
			e.printStackTrace();
			return new Result("查询失败");
		}
	}

	@RequestMapping(value = "/insertPtable")
	public @ResponseBody Result insertPtable(String insertDate, String intervalTime, String interval, String terminalId,
			String materialName, String status, String[] fids, HttpSession session) {
		try {
			// 后台校验
			if (fids == null || fids.length == 0 || fids.length > 1)
				return new Result("插播保存失败,缺少相关参数");
			if ("".equals(insertDate))
				return new Result("插播保存失败,缺少相关参数");
			if ("".equals(intervalTime))
				return new Result("插播保存失败,缺少相关参数");
			if ("".equals(interval))
				return new Result("插播保存失败,缺少相关参数");
			if ("".equals(terminalId))
				return new Result("插播保存失败,缺少相关参数");

			IPTable insert = new IPTable();
			Date d = TimeUtil.translateDate(insertDate);
			insert.setInsertDate(d);
			String[] time = intervalTime.split("-");
			java.sql.Time startTime = TimeUtil.translateTime(time[0].trim());
			java.sql.Time endTime = TimeUtil.translateTime(time[1].trim());
			if (TimeUtil.timeValidate(startTime, endTime)) {
				insert.setMaterialName(materialName);
				insert.setStartTime(startTime);
				insert.setEndTime(endTime);
				insert.setMin(Integer.parseInt(interval));
				insert.setStatus(Integer.parseInt(status));
				insert.setMid(fids[0]);
				insert.setTerminalId(terminalId);
				String name = (String) session.getAttribute("userName");
				insert.setCreateName(name);
				// Date date = new Date();
				// Timestamp timestamp = new Timestamp(date.getTime());
				insert.setCreateTime(new Timestamp(System.currentTimeMillis()));
				insert.setDeleted(0);
				System.out.println(insert);
				// ptableDao.saveInsertTable(insert);
				ptableService.saveInsertTable(insert);
				return new Result(true, "");
			} else {
				return new Result("插播时段有误");
			}

			// 唯一性验证
			// if(ptableService.countByName(playTable) > 0) return new Result("播表名称已经被占用");

			// 先插入一条播放表记录
			// ptableDao.save(playTable);

			// 建立播放表与视频文件的关系
			// ptableService.buildPtableFileRelation(playTable.getPid(), fids);

		} catch (Exception e) {
			e.printStackTrace();
			return new Result("插播保存失败");
		}
	}

	@RequestMapping(value = "/modifyPtable")
	public @ResponseBody Result modifyPtable(String pid, String pname, String[] fids) {
		try {
			// 后台校验
			if (StringUtil.isEmpty(pid) || StringUtil.isEmpty(pname) || fids == null || fids.length == 0)
				return new Result("修改播表失败,缺少相关参数");

			// 先检验播表名称有无占用
			PlayTable playTable = ptableDao.load(pid);
			if (ptableService.countByName(playTable) > 0)
				return new Result("播表名称已经被占用");

			// 开始更新播表的数据
			// 更新的参数
			Map<String, String> paramMap = new HashMap<String, String>();
			paramMap.put("pname", pname);
			// 更新的where条件
			Map<String, String> whereMap = new HashMap<String, String>();
			whereMap.put("pid", pid);
			// 开始更新数据
			commonService.updateByTemplateHQL(SqlUtil.growUpdateHqlTemplate("PlayTable", paramMap, whereMap), paramMap,
					whereMap);
			// 建立播放表与视频文件的关系
			ptableService.buildPtableFileRelation(pid, fids);

			// 如果更新了播表的名称，需要级联更新终端的播表
			// if(!pname.equals(oldPname)) {
			// paramMap = new HashMap<String, String>();
			// paramMap.put("pname", pname);
			// //更新的where条件
			// whereMap = new HashMap<String, String>();
			// whereMap.put("pid", pid);
			// //开始更新播放表数据
			// commonService.updateByTemplateHQL(SqlUtil.growUpdateHqlTemplate("Terminal",
			// paramMap, whereMap), paramMap, whereMap);
			// }

			return new Result(true, "");
		} catch (Exception e) {
			e.printStackTrace();
			return new Result("修改播表失败");
		}
	}

	@RequestMapping(value = "/delPtable")
	public @ResponseBody Result delPtable(String[] ids) {
		if (ids == null || ids.length < 1) {
			return new Result("删除错误");
		}

		// 开始更新数据
		try {
			ptableService.deletePtable(ids);

			return new Result(true, "");
		} catch (Exception e) {
			e.printStackTrace();
			return new Result("删除错误");
		}

	}
	
	//7.15
	@RequestMapping(value = "/goModifyPtable/{pid}/{periodName}/{tid}")
	public String goModifyPtable(@PathVariable String pid, @PathVariable String periodName,@PathVariable String tid,ModelMap modelMap) {
		modelMap.addAttribute("pid", pid);
		modelMap.addAttribute("periodName", periodName);
		modelMap.addAttribute("tid", tid);
		return "ptable/addPtable";
	}

	@RequestMapping(value = "/goCheckPtableFirst/{pid}")
	public String goCheckPtable(@PathVariable String pid, ModelMap modelMap, HttpServletRequest request) {
		modelMap.addAttribute("pid", pid);
		List<Material> files = fileDao.findByPtable(pid);
		request.getSession().setAttribute("tableFirst", files);
		String rid = (String) request.getSession().getAttribute("rId");
		request.getSession().setAttribute("modifyPid", pid);
		return "ptable/checkPtable";
	}

	@RequestMapping(value = "/goCheckPtableFinal/{pid}")
	public String goCheckPtableFinal(@PathVariable String pid, ModelMap modelMap, HttpServletRequest request) {
		modelMap.addAttribute("pid", pid);
		List<Material> files = fileDao.findByPtable(pid);
		request.getSession().setAttribute("tableFirst", files);
		String rid = (String) request.getSession().getAttribute("rId");
		request.getSession().setAttribute("modifyPid", pid);
		return "ptable/checkPtableFinal";
	}

	@RequestMapping(value = "/getTableSortNum")
	public void getTableSortNum(String ppid, ModelMap modelMap, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		modelMap.addAttribute("pid", ppid);
		List<Material> files = fileDao.findByPtable(ppid);
		request.getSession().setAttribute("tableFirst", files);
		String rid = (String) request.getSession().getAttribute("rId");
		request.getSession().setAttribute("modifyPid", ppid);
		PrintWriter out = response.getWriter();
		out.print("true");
		out.flush();
		out.close();
	}

	@RequestMapping(value = "/getPtableById")
	public @ResponseBody PageResultData<Items> getPtableById(HttpServletRequest request, String pid) {
		if (StringUtil.isEmpty(pid)) {
			PageResultData<Items> pageResult1 = new PageResultData<Items>();
			pageResult1.setCount(0);
			pageResult1.setCode(0);
			pageResult1.setFail(1);
			pageResult1.setMsg("获取失败, 没有传入参数");
			return pageResult1;
		}
		try {
			System.out.println(pid);
			// PlayTable playTable = ptableDao.get(pid);
			PlayTable playTable = ptableDao.getById(pid);
			System.out.println(playTable.getPtableName());
			String name = playTable.getPtableName();
			if (playTable.getInsertFlag() == 0) {
				List<Items> files = materialDao.findByPtable(pid);
				request.getSession().setAttribute("modifyPid", pid);
				System.out.println(files);
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("playTable", playTable);
				map.put("files", files);
				PageResultData<Items> pageResult = new PageResultData<Items>();
				pageResult.setCount(files.size());
				pageResult.setCode(0);
				pageResult.setMsg(name);
				pageResult.setFail(0);
				pageResult.setData(files);
				return pageResult;
			} else if (playTable.getInsertFlag() == 1) {
				List<Material> files = materialDao.findMaterialByPtable(pid);
				List<Items> files1 = EntityUtil.createNewItems(files);
				request.getSession().setAttribute("modifyPid", pid);
				System.out.println(files);
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("playTable", playTable);
				map.put("files", files);
				PageResultData<Items> pageResult = new PageResultData<Items>();
				pageResult.setCount(files.size());
				pageResult.setCode(0);
				pageResult.setMsg(name);
				pageResult.setFail(0);
				pageResult.setData(files1);
				return pageResult;
			} else {
				PageResultData<Items> pageResult1 = new PageResultData<Items>();
				pageResult1.setCount(0);
				pageResult1.setCode(0);
				pageResult1.setMsg("");
				return pageResult1;
			}
		} catch (Exception e) {
			e.printStackTrace();
			PageResultData<Items> pageResult1 = new PageResultData<Items>();
			pageResult1.setCount(0);
			pageResult1.setCode(0);
			pageResult1.setFail(1);
			pageResult1.setMsg("获取失败");
			return pageResult1;
		}
	}

	@RequestMapping(value = "/modifyPlayTableNum")
	public void modifyPlayTableNum(String ppid, Model model, HttpServletRequest request, HttpServletResponse response,
			String sortNum) throws IOException {
		System.out.println(ppid + "=" + sortNum);
		// System.out.println("pid=" + (String)
		// request.getSession().getAttribute("modifyPid"));
		if ("".equals(sortNum)) {
			// String pid = (String) request.getSession().getAttribute("modifyPid");
			ptableService.updateTableStatus(ppid);
			PrintWriter out = response.getWriter();
			out.print("true");
			out.flush();
			out.close();
		} else {
			// String pid = (String) request.getSession().getAttribute("modifyPid");
			// System.out.println(pid);
			ptableService.modifyPlayTableNum(ppid, sortNum);
			ptableService.updateTableStatus(ppid);
			// int num = Integer.parseInt((String)
			// request.getSession().getAttribute("playNum"));
			// request.getSession().setAttribute("playNum", num - 1);
			int num = userDao.getAccountTable(1);
			String n = "" + num;
			request.getSession().setAttribute("playNum", n);
			PrintWriter out = response.getWriter();
			out.print("true");
			out.flush();
			out.close();
		}
	}

	// 添加仅修改播表顺序的接口
	@RequestMapping(value = "/modifyPlayTableNumFromaddPtable")
	public void modifyPlayTableNumFromaddPtable(String ppid, Model model, HttpServletRequest request,
			HttpServletResponse response, String sortNum) throws IOException {
		System.out.println(ppid + "=" + sortNum);
		// System.out.println("pid=" + (String)
		// request.getSession().getAttribute("modifyPid"));
		if ("".equals(sortNum)) {
			// String pid = (String) request.getSession().getAttribute("modifyPid");

			PrintWriter out = response.getWriter();
			out.print("false");
			out.flush();
			out.close();
		} else {
			// String pid = (String) request.getSession().getAttribute("modifyPid");
			// System.out.println(pid);
			ptableService.modifyPlayTableNum(ppid, sortNum);
			// ptableService.updateTableStatus(ppid);
			// int num = Integer.parseInt((String)
			// request.getSession().getAttribute("playNum"));
			// request.getSession().setAttribute("playNum", num - 1);
			int num = userDao.getAccountTable(1);
			String n = "" + num;
			request.getSession().setAttribute("playNum", n);
			PrintWriter out = response.getWriter();
			out.print("true");
			out.flush();
			out.close();
		}
	}

	@RequestMapping(value = "/modifyPlayTableFinalNum")
	public void modifyPlayTableFinalNum(String ppid, Model model, HttpServletRequest request,
			HttpServletResponse response, String sortNum) throws IOException {
		System.out.println(ppid + "=" + sortNum);
		if ("".equals(sortNum)) {
			// String pid = (String) request.getSession().getAttribute("modifyPid");
			ptableService.updateTableStatusFinal(ppid);
			PrintWriter out = response.getWriter();
			out.print("true");
			out.flush();
			out.close();
		} else {
			// String pid = (String) request.getSession().getAttribute("modifyPid");
			// List<File> list = (List<File>)
			// request.getSession().getAttribute("tableFirst");
			// System.out.println(list);
			// System.out.println(pid);
			ptableService.modifyPlayTableNum(ppid, sortNum);
			ptableService.updateTableStatusFinal(ppid);
			// int num = Integer.parseInt((String)
			// request.getSession().getAttribute("playNum"));
			// request.getSession().setAttribute("playNum", num - 1);
			int num = userDao.getAccountTable(2);
			request.getSession().setAttribute("playNum", "" + num);
			PrintWriter out = response.getWriter();
			out.print("true");
			out.flush();
			out.close();
		}
	}

	@RequestMapping(value = "/modifyPlayTableFinalNumUn")
	public void modifyPlayTableFinalNumUn(String ppid, Model model, String mark, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		System.out.println(ppid + "=");
		// String pid = (String) request.getSession().getAttribute("modifyPid");
		ptableService.updateTableStatusFinalUn(ppid, mark);
		PrintWriter out = response.getWriter();
		out.print("true");
		out.flush();
		out.close();
	}

	@RequestMapping(value = "/playTableUnAccess")
	public void playTableUnAccess(String ppid, Model model, String[] checkArray, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		System.out.println(ppid + "=");
		// String pid = (String) request.getSession().getAttribute("modifyPid");
		System.out.println(checkArray.length);
		if (checkArray.length == 0) {
			PrintWriter out = response.getWriter();
			out.print("false");
			out.flush();
			out.close();
		} else {
			if (checkArray.length == 2) {
				ptableService.playTableUnAccess(ppid, "7");
			} else if (checkArray.length == 1 && "1".equals(checkArray[0])) {
				ptableService.playTableUnAccess(ppid, "5");
			} else if (checkArray.length == 1 && "2".equals(checkArray[0])) {
				ptableService.playTableUnAccess(ppid, "6");
			}
			PrintWriter out = response.getWriter();
			out.print("true");
			out.flush();
			out.close();
		}
	}

	@RequestMapping("/broadCheckList")
	public String broadCheckList(Model model, HttpServletRequest request) {
		List<PlayTable> list = new ArrayList<PlayTable>();
		List<PlayTable> list1 = ptableService.getTableById("7");
		List<PlayTable> list2 = ptableService.getTableById("5");
		if (list1.size() != 0) {
			for (PlayTable pt : list1) {
				list.add(pt);
			}
		}
		if (list2.size() != 0) {
			for (PlayTable pt : list2) {
				list.add(pt);
			}
		}

		List<Terminal> listTerminal = commonService.getAllTerminal();
		List<Period> listPeriod = commonService.getAllPeriod();
		model.addAttribute("terminals", listTerminal);
		model.addAttribute("periods", listPeriod);
		model.addAttribute("ptableNameOne", list);
		return "file/ptableExcepList";
	}

	@RequestMapping("/checkExcepList")
	public String checkExcepList(Model model, HttpServletRequest request) {
		List<PlayTable> list = new ArrayList<PlayTable>();
		List<PlayTable> list1 = ptableService.getTableById("7");
		List<PlayTable> list2 = ptableService.getTableById("6");
		if (list1.size() != 0) {
			for (PlayTable pt : list1) {
				list.add(pt);
			}
		}
		if (list2.size() != 0) {
			for (PlayTable pt : list2) {
				list.add(pt);
			}
		}

		List<Terminal> listTerminal = commonService.getAllTerminal();
		List<Period> listPeriod = commonService.getAllPeriod();
		model.addAttribute("terminals", listTerminal);
		model.addAttribute("periods", listPeriod);
		model.addAttribute("ptableNameOne", list);

		String rid = (String) request.getSession().getAttribute("rId");
		if (rid != null && rid.equals(Constant.adminValue)) {
			model.addAttribute("showDeleteBtn", true);
		} else {
			model.addAttribute("showDeleteBtn", false);
		}

		return "file/checkExcepList";
	}

	// 7.14

	@RequestMapping(value = "/copyOneToPlayFile")
	public void copyOneToPlayFile(String ppid, HttpServletRequest request, HttpServletResponse response, String mmid,
			String num) throws IOException {
		if (StringUtil.isEmpty(ppid)) {
			PrintWriter out = response.getWriter();
			out.print("获取失败，没有传入ppid");
			out.flush();
			out.close();
		}
		if (StringUtil.isEmpty(mmid)) {
			PrintWriter out = response.getWriter();
			out.print("获取失败，没有传入mmid");
			out.flush();
			out.close();
		}

		if (StringUtil.isEmpty(num)) {
			PrintWriter out = response.getWriter();
			out.print("获取失败，没有传入num");
			out.flush();
			out.close();
		} else {
			int insertnum = Integer.parseInt(num) + 1;
			if (commonService.copyOneToPlayFile(ppid, mmid, insertnum)) {
				PrintWriter out = response.getWriter();
				out.print("true");
				out.flush();
				out.close();
			}
		}

	}

	// 7.15
	@RequestMapping(value = "/delOneFromPlayFile")
	public void delOneFromPlayFile(String ppid, HttpServletRequest request, HttpServletResponse response, String mmid,
			String num) throws IOException {
		if (StringUtil.isEmpty(ppid)) {
			PrintWriter out = response.getWriter();
			out.print("失败，没有传入ppid");
			out.flush();
			out.close();
		}
		if (StringUtil.isEmpty(mmid)) {
			PrintWriter out = response.getWriter();
			out.print("失败，没有传入mmid");
			out.flush();
			out.close();
		}

		if (StringUtil.isEmpty(num)) {
			PrintWriter out = response.getWriter();
			out.print("失败，没有传入num");
			out.flush();
			out.close();
		} else {
			int deltnum = Integer.parseInt(num) + 1;
			if (commonService.delOneFromPlayFile(ppid, mmid, deltnum)) {
				
				// 删除成功后，更新file表的序号
				List<Items> files = materialDao.findByPtable(ppid);// 获取播表id对应剩余的所有素材item
				String sortNum = "";// 当前ppid所存在的所有素材mid
				for (int i = 0; i < files.size(); i++) {
					sortNum += "," + files.get(i).getMaterial().getMid();
				}
				sortNum=sortNum.substring(1);
				ptableService.modifyPlayTableNumbyDelAll(ppid, sortNum);
				PrintWriter out = response.getWriter();
				out.print("true");
				out.flush();
				out.close();
			}
		}

	}

}
