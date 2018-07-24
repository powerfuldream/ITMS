package org.south.itms.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.south.itms.dto.MaterialDto;
import org.south.itms.dto.Page;
import org.south.itms.dto.PageResultData;
import org.south.itms.dto.Result;
import org.south.itms.entity.Material;
import org.south.itms.entity.Period;
import org.south.itms.entity.Terminal;
import org.south.itms.service.impl.CommonService;
import org.south.itms.service.impl.PeriodService;
import org.south.itms.util.EntityUtil;
import org.south.itms.util.StringUtil;
import org.south.itms.util.TimeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @author jan
 * @date 2017年11月23日 下午5:15:43
 * @version V1.0
 */

@Controller
@RequestMapping("/period")
public class PeriodController {
	
	@Autowired
	private CommonService commonService;

	@Autowired
	private PeriodService periodService;

	@RequestMapping("/periodList")
	public String periodList(Model model, HttpServletRequest request) {
		return "period/periodList";
	}
	
	@RequestMapping("/selectPeriod")
	public String selectPeriod(Model model, HttpServletRequest request) {
		
		String terminalId = request.getParameter("terminalId");
		List<Period> listPeriod = new ArrayList<Period>();
		if(StringUtil.isEmpty(terminalId)) {  //没有terminalId就查询全部的时段
			listPeriod = commonService.getAllPeriod();
		} else {
			listPeriod = periodService.findPeriodByTerminalId(terminalId);
		}
		model.addAttribute("periodOnce", listPeriod);
		return "forward:/file/periodList.jsp";
	}
	
	
	
	
	
	@RequestMapping("/periodTable")
	public String periodTable(String periodName, Model model, HttpServletRequest request) {
		System.out.println(periodName);
		if("".equals(periodName)) {
			List<Period> listPeriod = commonService.getAllPeriod();
			request.getSession().setAttribute("periodOnce", listPeriod);
		}else {
			List<Period> list = periodService.queryByName(periodName);
			System.out.println(list);
			request.getSession().setAttribute("periodOnce", list);
		}		
		return "period/periodTable";
	}
	
	@RequestMapping("/periodChangeTable")
	@ResponseBody
	public List<Period> periodChangeTable(String terminalId,
			 Model model, HttpServletRequest request) {
		System.out.println(terminalId);
		List<Period> listP = new ArrayList<Period>();
		if("".equals(terminalId)) {
			List<Period> list = periodService.queryByTid("9");
			return list;
//			if(list.size() == 0 || list == null) {
//				return listP;
//			}else {
//				PageResultData<Period> pageResult = new PageResultData<Period>();
//				pageResult.setCount(list.size());
//				pageResult.setCode(0);
//				pageResult.setMsg("");
//				pageResult.setData(list);
//				return pageResult;
//			}
		}else {
			if(terminalId.charAt(0) == 't') {
				terminalId = terminalId.substring(1);
				List<Period> list = periodService.queryByTid(terminalId);
				return list;
			}else if(terminalId.charAt(0) == 'p'){
				String areaId = terminalId.substring(1);
				List<Period> list = periodService.queryByAreaId(areaId);
				System.out.println(list);
				return list;
		}else {
			return listP;
		}
	}
	}

	@RequestMapping(value = "/searchPeriod")
	public @ResponseBody PageResultData<Period> searchFile(String[] params, int page, int limit) {
		try {
			Page pageD = periodService.pageSearchByTemplateHQL(params, page, limit, "Period", "periodId desc",
					null);
			List<Period> listM = pageD.getList();
		     PageResultData<Period> pageResult = new PageResultData<Period>();
			 pageResult.setCount(pageD.getTotalRecord());
			 pageResult.setCode(0);
			 pageResult.setMsg("");
			 pageResult.setData(listM);
			 return pageResult;
		} catch (Exception e) {
			e.printStackTrace();
			PageResultData<Period> pageResult1 = new PageResultData<Period>();
			pageResult1.setCount(0);
			pageResult1.setCode(0);
			pageResult1.setMsg("");
			return pageResult1;
		}
	}

	@RequestMapping(value = "/addPeriod")
	public void addPeriod(String periodName, String timeStr, String mark, String terminalId, String terminalName,
			HttpServletRequest request, HttpServletResponse response)
			throws IOException, ParseException {
		System.out.println(periodName +"=" + timeStr + "=" + mark);
		if ("".equals(periodName) || "".equals(timeStr) || "".equals(terminalId)) {
			PrintWriter out = response.getWriter();
			out.print("err");
			out.flush();
			out.close();
		} else {
			boolean check = periodService.checkName(periodName);
			System.out.println(check);
			if (check) {
				System.out.println("name is common");
				PrintWriter out = response.getWriter();
				out.print("false");
				out.flush();
				out.close();
			} else {
				String[] time = timeStr.split("-");
				java.sql.Time startInterval = TimeUtil.translateTime(time[0].trim());
				java.sql.Time endInterval = TimeUtil.translateTime(time[1].trim());
				if(TimeUtil.timeValidate(startInterval, endInterval)) {
					Period period = new Period();
					period.setPeriodName(periodName);
					period.setStartInterval(startInterval);
					period.setEndInterval(endInterval);
					period.setDeleted(0);
					period.setMark(mark);
					period.setStatus(0);
					period.setTerminalId(terminalId);
					period.setTerminalName(terminalName);
					periodService.save(period);
					PrintWriter out = response.getWriter();
					out.print("true");
					out.flush();
					out.close();
				}else {
					System.out.println(6666);
					PrintWriter out = response.getWriter();
					out.print("1");
					out.flush();
					out.close();
				}
			}
		}
	}

	@RequestMapping(value = "/delPeriod")
	public void deletePeriod(String[] periodId, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		if (periodId.length == 0) {
			PrintWriter out = response.getWriter();
			out.print("false");
			out.flush();
			out.close();
		} else {
			periodService.delPeriod(periodId);
			PrintWriter out = response.getWriter();
			out.print("true");
			out.flush();
			out.close();
		}
	}

	@RequestMapping(value = "/editPeriod")
	public void editPeriod(Period period, String timeStr,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		Period sqlPeriod = periodService.getPeriod(period.getPeriodId());
		if("".equals(period.getPeriodName())) {
			period.setPeriodName(sqlPeriod.getPeriodName());
			update(period, timeStr, sqlPeriod, request, response);
		}else {
			if("".equals(period.getPeriodName())) {
				period.setPeriodName(sqlPeriod.getPeriodName());
				update(period, timeStr, sqlPeriod, request, response);
			}else {
				update(period, timeStr, sqlPeriod, request, response);
			}
		}
	}
	
	public void update(Period period, String timeStr, Period sqlPeriod,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		if("".equals(period.getMark())) {
			period.setMark(sqlPeriod.getMark());
		}
		if("".equals(timeStr)) {
			period.setStartInterval(sqlPeriod.getStartInterval());
			period.setEndInterval(sqlPeriod.getEndInterval());
			periodService.updatePeriod(period);
			PrintWriter out = response.getWriter();
			out.print("true");
			out.flush();
			out.close();
		}else {
			String[] time = timeStr.split("-");
			java.sql.Time startInterval = TimeUtil.translateTime(time[0].trim());
			java.sql.Time endInterval = TimeUtil.translateTime(time[1].trim());
			if(TimeUtil.timeValidate(startInterval, endInterval)) {
				period.setStartInterval(startInterval);
				period.setEndInterval(endInterval);
				periodService.updatePeriod(period);
				PrintWriter out = response.getWriter();
				out.print("true");
				out.flush();
				out.close();
			}else {
				PrintWriter out = response.getWriter();
				out.print("1");
				out.flush();
				out.close();
			}
		}
	}
	
	@RequestMapping(value = "/getMapData")
	@ResponseBody
	public List<Integer> getMapData(String terminalId, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		System.out.println(terminalId);
		terminalId = terminalId.substring(1);
		List<Integer> list = periodService.getMapData(terminalId);
		return list;
	}
}
