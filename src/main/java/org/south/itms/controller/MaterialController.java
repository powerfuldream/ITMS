package org.south.itms.controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigInteger;
import java.sql.Timestamp;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.south.itms.dao.impl.MaterialDao;
import org.south.itms.dto.ItemsDto;
import org.south.itms.dto.MaterialDto;
import org.south.itms.dto.Page;
import org.south.itms.dto.PageResult;
import org.south.itms.dto.PageResultData;
import org.south.itms.dto.Result;
import org.south.itms.dto.TreeDate;
import org.south.itms.entity.Items;
import org.south.itms.entity.Material;
import org.south.itms.entity.Period;
import org.south.itms.entity.Terminal;
import org.south.itms.service.impl.CommonService;
import org.south.itms.service.impl.MaterialService;
import org.south.itms.util.Constant;
import org.south.itms.util.EntityUtil;
import org.south.itms.util.FileUtil;
import org.south.itms.util.StringUtil;
import org.south.itms.util.TimeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

/**
 * @author jan
 * @date 2017年12月16日 下午11:53:46
 * @version V1.0
 */
@Controller
@RequestMapping("/material")
public class MaterialController {

	// private String rootPath1;

	@Autowired
	private MaterialService materialService;

	@Autowired
	private CommonService commonService;
	
	@Autowired
	private MaterialDao materialDao;

	@RequestMapping("/materialList")
	public String fileList(Model model, HttpServletRequest request) {
		List<Terminal> listTerminal = commonService.getAllTerminal();
		model.addAttribute("terminals", listTerminal);
		String rid = (String) request.getSession().getAttribute("rId");
		if (rid.equals(Constant.adminValue)) {
			return "file/materialListAdmin";
		}
		// else if(rid.equals(Constant.uploadValue)) {
		// return "file/materialListUpload";
		// }
		return "file/materialList";
	}

	@RequestMapping("/myMaterialList")
	public String myMaterialList(Model model, HttpServletRequest request) {
		List<Terminal> listTerminal = commonService.getAllTerminal();
		model.addAttribute("terminals", listTerminal);
		String rid = (String) request.getSession().getAttribute("rId");
		if (rid.equals(Constant.uploadValue)) {
			return "file/myMaterialListUpload";
		}
		return "file/myMaterialList";
	}

	@RequestMapping("/getMaterialInfo")
	public String queryMaterial(Model model, HttpServletRequest request) {
		return "file/queryMaterial";
	}

	// 7.16
	@RequestMapping(value = "/getMaterialInfoBytid/{terminalId}/{ppid}")
	public String getMaterialInfoBytid(@PathVariable String terminalId,@PathVariable String ppid, ModelMap modelMap,HttpServletRequest request) {
		modelMap.addAttribute("resterminalid", terminalId);
		
		List<Items> files = materialDao.findalreadyItemByPtable(ppid);// 获取播表id对应的所有素材item
		String sortNum = "";// 当前ppid所存在的所有素材mid
		for (int i = 0; i < files.size(); i++) {
			sortNum += "," + files.get(i).getMaterial().getMid();
		}
		sortNum=sortNum.substring(1);
		
		modelMap.addAttribute("alreadymid", sortNum);
		
		return "file/queryMaterialbybroadclist";
	}

	@RequestMapping("/addMaterialInfo")
	public String addMaterialInfo(Model model, HttpServletRequest request) {
		return "file/addMaterialInfo";
	}

	@RequestMapping("/addMaterialInfo2")
	public String addMaterialInfo2(Model model, String terminalId) {
		model.addAttribute("terminalId", terminalId);
		return "file/addMaterialInfo";
	}

	@RequestMapping("/insteadMaterial")
	public String insteadMaterial(Model model, HttpServletRequest request) {
		return "instead/insteadMaterialList";
	}

	@RequestMapping("/findAllTerminal")
	@ResponseBody
	public PageResultData<Terminal> findAllTerminal() {
		List<Terminal> listTerminal = commonService.getAllTerminal();
		PageResultData<Terminal> pageResult1 = new PageResultData<Terminal>();
		pageResult1.setCount(0);
		pageResult1.setCode(0);
		pageResult1.setMsg("");
		pageResult1.setFail(1);
		pageResult1.setData(listTerminal);
		return pageResult1;
	}

	@RequestMapping("/resetMaterial")
	@ResponseBody
	public String resetMaterial(String mid, HttpServletRequest request) {
		System.out.println("mid=" + mid);
		materialService.resetMaterial(mid);
		return "true";
	}

	@RequestMapping("/searchMyFile")
	@ResponseBody
	public PageResultData<MaterialDto> searchMyFile(int page, int limit, Model model, HttpServletRequest request,
			String param, String dateTime) {
		// String[] params = new String[3];
		String name = (String) request.getSession().getAttribute("userName");
		if (name == null || "".equals(name)) {
			PageResultData<MaterialDto> pageResult1 = new PageResultData<MaterialDto>();
			pageResult1.setCount(0);
			pageResult1.setCode(0);
			pageResult1.setMsg("登陆超时,重新登陆查询!");
			pageResult1.setFail(1);
			return pageResult1;
		} else {
			List<Terminal> listTerminal = commonService.getAllTerminal();
			model.addAttribute("listTerminal", listTerminal);
			param = param + "uploadName," + "=" + "," + name;
			String[] params = param.split(",");
			if (dateTime == null || "".equals(dateTime)) {
				try {
					Page pageD = commonService.pageSearchByTemplateHQL(params, page, limit, "Material",
							"uploadTime desc", null);
					List<Material> listM = pageD.getList();
					System.out.println(listM);
					List<MaterialDto> list = EntityUtil.getMaterialDtoInfo(listM, listTerminal);
					PageResultData<MaterialDto> pageResult = new PageResultData<MaterialDto>();
					pageResult.setCount(pageD.getTotalRecord());
					pageResult.setCode(0);
					pageResult.setMsg("");
					pageResult.setData(list);
					return pageResult;
				} catch (Exception e) {
					e.printStackTrace();
					PageResultData<MaterialDto> pageResult1 = new PageResultData<MaterialDto>();
					pageResult1.setCount(0);
					pageResult1.setCode(0);
					pageResult1.setMsg("查询异常");
					pageResult1.setFail(1);
					return pageResult1;
				}
			} else {
				// List<Terminal> listTerminal1 = commonService.getAllTerminal();
				String[] time = dateTime.split(" ");
				String startDate = time[0];
				String endDate = time[2];

				try {
					Page pageD = commonService.pageSearchByTemplateHQL(startDate, endDate, params, page, limit,
							"Material", "uploadTime desc", null);
					List<Material> listM = pageD.getList();
					List<MaterialDto> list = EntityUtil.getMaterialDtoInfo(listM, listTerminal);
					// System.out.println("listM" + listM);
					// System.out.println("size=" + pageD.getTotalRecord());
					PageResultData<MaterialDto> pageResult = new PageResultData<MaterialDto>();
					pageResult.setCount(pageD.getTotalRecord());
					pageResult.setCode(0);
					pageResult.setMsg("");
					pageResult.setData(list);
					return pageResult;
				} catch (Exception e) {
					e.printStackTrace();
					PageResultData<MaterialDto> pageResult1 = new PageResultData<MaterialDto>();
					pageResult1.setCount(0);
					pageResult1.setCode(0);
					pageResult1.setMsg("查询异常");
					pageResult1.setFail(1);
					return pageResult1;
				}
			}
		}
	}

	@RequestMapping("/getAllMaterialInfo")
	@ResponseBody
	public PageResultData<Material> getAllMaterialInfo(String param, int page, int limit, Model model,
			HttpServletRequest request) {
		System.out.println(param);
		String[] params = param.split(",");
		try {
			Page pageD = commonService.pageSearchByTemplateHQL(params, page, limit, "Material", "uploadTime desc",
					null);
			List<Material> listM = pageD.getList();
			for (Material m : listM) {
				System.out.println(m);
			}
			PageResultData<Material> pageResult = new PageResultData<Material>();
			pageResult.setCount(pageD.getTotalRecord());
			pageResult.setCode(0);
			pageResult.setMsg("");
			pageResult.setData(listM);
			return pageResult;
		} catch (Exception e) {
			e.printStackTrace();
			PageResultData<Material> pageResult1 = new PageResultData<Material>();
			pageResult1.setCount(0);
			pageResult1.setCode(0);
			pageResult1.setMsg("查询异常");
			pageResult1.setFail(1);
			return pageResult1;
		}
	}

	@RequestMapping("/broadcastList")
	public String broadcastList(Model model, HttpServletRequest request) {
		List<Terminal> listTerminal = commonService.getAllTerminal();
		List<Period> listPeriod = commonService.getAllPeriod();
		model.addAttribute("terminals", listTerminal);
		model.addAttribute("periods", listPeriod);
		request.getSession().setAttribute("periodOnce", listPeriod);
		// model.addAttribute("periodOnce", listPeriod);
		return "file/broadcastList";
	}

	@RequestMapping("/goUpload")
	public String goUpload(Model model, HttpServletRequest request) {
		return "file/upload";
	}

	@RequestMapping(value = "/searchFile")
	public @ResponseBody PageResultData<MaterialDto> searchFile(Model model, String param, String dateTime, int page,
			int limit) throws ParseException {
		System.out.println("param=" + param + " dateTime=" + dateTime);
		List<Terminal> listTerminal = commonService.getAllTerminal();
		model.addAttribute("listTerminal", listTerminal);
		String[] params = param.split(",");
		if (dateTime == null || "".equals(dateTime)) {
			try {
				Page pageD = commonService.pageSearchByTemplateHQL(params, page, limit, "Material", "uploadTime desc",
						null);
				List<Material> listM = pageD.getList();
				System.out.println(listM);
				List<MaterialDto> list = EntityUtil.getMaterialDtoInfo(listM, listTerminal);
				PageResultData<MaterialDto> pageResult = new PageResultData<MaterialDto>();
				pageResult.setCount(pageD.getTotalRecord());
				pageResult.setCode(0);
				pageResult.setMsg("");
				pageResult.setData(list);
				return pageResult;
			} catch (Exception e) {
				e.printStackTrace();
				PageResultData<MaterialDto> pageResult1 = new PageResultData<MaterialDto>();
				pageResult1.setCount(0);
				pageResult1.setCode(0);
				pageResult1.setMsg("查询异常");
				pageResult1.setFail(1);
				return pageResult1;
			}
		} else {
			// List<Terminal> listTerminal1 = commonService.getAllTerminal();
			String[] time = dateTime.split(" ");
			String startDate = time[0];
			String endDate = time[2];

			try {
				Page pageD = commonService.pageSearchByTemplateHQL(startDate, endDate, params, page, limit, "Material",
						"uploadTime desc", null);
				List<Material> listM = pageD.getList();
				List<MaterialDto> list = EntityUtil.getMaterialDtoInfo(listM, listTerminal);
				// System.out.println("listM" + listM);
				// System.out.println("size=" + pageD.getTotalRecord());
				PageResultData<MaterialDto> pageResult = new PageResultData<MaterialDto>();
				pageResult.setCount(pageD.getTotalRecord());
				pageResult.setCode(0);
				pageResult.setMsg("");
				pageResult.setData(list);
				return pageResult;
			} catch (Exception e) {
				e.printStackTrace();
				PageResultData<MaterialDto> pageResult1 = new PageResultData<MaterialDto>();
				pageResult1.setCount(0);
				pageResult1.setCode(0);
				pageResult1.setMsg("查询异常");
				pageResult1.setFail(1);
				return pageResult1;
			}
		}
	}

	@RequestMapping(value = "/wrapSearchFile")
	public @ResponseBody PageResultData<MaterialDto> wrapSearchFile(Model model, String terminalIdStr, String param,
			String dateTime, int page, int limit) throws ParseException {
		if (StringUtil.isEmpty(terminalIdStr)) {
			return searchFile(model, param, dateTime, page, limit);
		}
		String[] terminalIds = terminalIdStr.split(",");
		if (terminalIds.length == 1) {
			return searchFile(model, param + "terminalId" + ",=," + terminalIds[0] + ",", dateTime, page, limit);
		} else {
			List<MaterialDto> listDto = new ArrayList<MaterialDto>();
			PageResultData<MaterialDto> pageResult = searchFile(model, param, dateTime, page, limit);
			for (MaterialDto itemsDto : pageResult.getData()) {
				for (String terminalId : terminalIds) {
					if (itemsDto.getTerminal().getTerminalId().equals(terminalId)) {
						listDto.add(itemsDto);
						break;
					}

				}
			}
			pageResult.setData(listDto);
			pageResult.setCount(listDto.size());
			return pageResult;
		}
	}

	@RequestMapping(value = "/wrapSearchBroadItem")
	public @ResponseBody PageResultData<ItemsDto> wrapSearchBroadItem(String terminalIdStr, String params,
			String dateTime, int page, int limit) {

		if (!StringUtil.isEmpty(dateTime)) {
			String[] time = dateTime.split(" ");
			String startDate = time[0];
			String endDate = time[2];
			dateTime = " and str_to_date(startDate, '%Y-%m-%d') >= '" + startDate
					+ "' and str_to_date(endDate, '%Y-%m-%d') <= '" + endDate + "'";
		} else {
			dateTime = null;
		}

		if (StringUtil.isEmpty(terminalIdStr)) {
			return searchBroadItem2(params, dateTime, page, limit);
		}
		String[] terminalIds = terminalIdStr.split(",");
		if (terminalIds.length == 1) {
			return searchBroadItem2(params + "terminalId" + ",=," + terminalIds[0] + ",", dateTime, page, limit);
		} else {
			List<ItemsDto> listDto = new ArrayList<ItemsDto>();
			PageResultData<ItemsDto> pageResult = searchBroadItem2(params, dateTime, page, limit);
			for (ItemsDto itemsDto : pageResult.getData()) {
				for (String terminalId : terminalIds) {
					if (itemsDto.getTerminalId().equals(terminalId)) {
						listDto.add(itemsDto);
						break;
					}

				}
			}
			pageResult.setData(listDto);
			pageResult.setCount(listDto.size());
			return pageResult;
		}

	}

	private PageResultData<ItemsDto> searchBroadItem2(String params, String whereSuffix, int page, int limit) {
		String[] param = params.split(",");
		List<Period> listPeriod = commonService.getAllPeriod();
		Page pageD = commonService.pageSearchByTemplateHQL(param, page, limit, "Items", "createTime desc", whereSuffix);
		List<Items> listM = pageD.getList();
		List<ItemsDto> listDto = EntityUtil.getItemsDto(listM, listPeriod);
		PageResultData<ItemsDto> pageResult = new PageResultData<ItemsDto>();
		pageResult.setCount(pageD.getTotalRecord());
		pageResult.setCode(0);
		pageResult.setMsg("");
		pageResult.setData(listDto);
		return pageResult;
	}

	@RequestMapping(value = "/searchBroadItem")
	public @ResponseBody PageResultData<ItemsDto> searchBroadItem(String params, String dateTime, int page, int limit) {
		String[] param = params.split(",");
		System.out.println("params: " + params);

		List<Period> listPeriod = commonService.getAllPeriod();
		if (dateTime == null || "".equals(dateTime)) {
			Page pageD = commonService.pageSearchByTemplateHQL(param, page, limit, "Items", "createTime desc", null);
			List<Items> listM = pageD.getList();
			List<ItemsDto> listDto = EntityUtil.getItemsDto(listM, listPeriod);
			PageResultData<ItemsDto> pageResult = new PageResultData<ItemsDto>();
			pageResult.setCount(pageD.getTotalRecord());
			pageResult.setCode(0);
			pageResult.setMsg("");
			pageResult.setData(listDto);
			return pageResult;
		} else {
			String[] time = dateTime.split(" ");
			String startDate = time[0];
			String endDate = time[2];

			try {
				Page pageD = commonService.pageSearchByTemplateHQL(startDate, endDate, param, page, limit, "Items",
						"createTime desc", null);
				List<Items> listM = pageD.getList();
				List<ItemsDto> listDto = EntityUtil.getItemsDto(listM, listPeriod);
				PageResultData<ItemsDto> pageResult = new PageResultData<ItemsDto>();
				pageResult.setCount(pageD.getTotalRecord());
				pageResult.setCode(0);
				pageResult.setMsg("");
				pageResult.setData(listDto);
				return pageResult;
			} catch (Exception e) {
				e.printStackTrace();
				PageResultData<ItemsDto> pageResult1 = new PageResultData<ItemsDto>();
				pageResult1.setCount(0);
				pageResult1.setCode(0);
				pageResult1.setMsg("");
				return pageResult1;
			}
		}
	}

	// @RequestMapping(value = "/searchBroadFile")
	// public @ResponseBody PageResultData<MaterialDto> searchBroadFile(String[]
	// params,String materialName, String terminalId,
	// String info, String dateTime, int page, int limit) throws ParseException {
	// System.out.println("dateTime=" + dateTime);
	// String[] param = initParamInfo(materialName, terminalId, info);
	// List<Terminal> list = commonService.getAllTerminal();
	// List<Period> listPeriod = commonService.getAllPeriod();
	// if(dateTime == null || "".equals(dateTime)) {
	// Page pageD = commonService.pageSearchByTemplateHQL(param, page, limit,
	// "Material", "uploadTime desc", null);
	// List<Material> listM = pageD.getList();
	// List<MaterialDto> listDto = EntityUtil.materialChange(list, listM,
	// listPeriod);
	// PageResultData<MaterialDto> pageResult = new PageResultData<MaterialDto>();
	// pageResult.setCount(pageD.getTotalRecord());
	// pageResult.setCode(0);
	// pageResult.setMsg("");
	// pageResult.setData(listDto);
	// return pageResult;
	// }else {
	// String[] time = dateTime.split(" ");
	// String startDate = time[0];
	// String endDate = time[2];
	//
	// try {
	// Page pageD = commonService.pageSearchByTemplateHQL(startDate, endDate, param,
	// page, limit, "Material", "uploadTime desc", null);
	// List<Material> listM = pageD.getList();
	// List<MaterialDto> listDto = EntityUtil.materialChange(list, listM,
	// listPeriod);
	// PageResultData<MaterialDto> pageResult = new PageResultData<MaterialDto>();
	// pageResult.setCount(pageD.getTotalRecord());
	// pageResult.setCode(0);
	// pageResult.setMsg("");
	// pageResult.setData(listDto);
	// return pageResult;
	// } catch (Exception e) {
	// e.printStackTrace();
	// PageResultData<MaterialDto> pageResult1 = new PageResultData<MaterialDto>();
	// pageResult1.setCount(0);
	// pageResult1.setCode(0);
	// pageResult1.setMsg("");
	// return pageResult1;
	// }
	// }
	// }

	public String[] initParamInfo(String materialName, String terminalId, String info) {
		int k = 0;
		if (!"".equals(materialName)) {
			k++;
		}
		if (!"".equals(terminalId)) {
			k++;
		}
		if (!"".equals(info)) {
			k++;
		}
		String[] param = new String[(k + 1) * 3];
		int len = 0;
		if (!"".equals(materialName)) {
			param[len] = "materialName";
			len++;
			param[len] = "like";
			len++;
			param[len] = "%" + materialName + "%";
			len++;
		}
		if (!"".equals(terminalId)) {
			param[len] = "terminalId";
			len++;
			param[len] = "=";
			len++;
			param[len] = terminalId;
			len++;
		}
		if (!"".equals(info)) {
			param[len] = "info";
			len++;
			param[len] = "=";
			len++;
			param[len] = info;
			len++;
		}
		param[len] = "statusId";
		len++;
		param[len] = "=";
		len++;
		param[len] = Constant.secondCheck;
		return param;
	}

	private String[] initParam(String materialName, String fileType, String statusId) {
		int k = 0;
		if (!"".equals(materialName)) {
			k++;
		}
		if (!"".equals(fileType)) {
			k++;
		}
		if (!"".equals(statusId)) {
			k++;
		}
		String[] param = new String[(k + 1) * 3];
		int len = 0;
		if (!"".equals(materialName)) {
			param[len] = "materialName";
			len++;
			param[len] = "like";
			len++;
			param[len] = "%" + materialName + "%";
			len++;
		}
		if (!"".equals(fileType)) {
			param[len] = "fileType";
			len++;
			param[len] = "=";
			len++;
			param[len] = fileType;
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
		param[len] = "tis";
		len++;
		param[len] = "=";
		len++;
		param[len] = "1";
		return param;
	}

	@RequestMapping(value = "/searchMaterial")
	public @ResponseBody Result searchMaterial(String[] params, String startDate, String endDate, int currentPage,
			int pageSize) throws ParseException {
		// System.out.println(params.length);
		// for(String s:params) {
		// System.out.print(" " + s + " ");
		// }
		// System.out.println();
		// try {
		// Page page = commonService.pageSearchMaterialByTemplateHQL(params,
		// currentPage, pageSize, "Material", "uploadTime desc", null);
		// return new Result(true, page);
		// } catch (Exception e) {
		// e.printStackTrace();
		// return new Result("查询失败");
		// }

		System.out.println(startDate + "=" + endDate);
		if (!"".equals(startDate) && !"".equals(endDate)) {
			Date d1 = TimeUtil.translateDate(startDate);
			Date d2 = TimeUtil.translateDate(endDate);
			if (!TimeUtil.dateValidate(d1, d2)) {
				return new Result("日期范围有误");
			}
		}
		try {
			Page page = commonService.pageSearchByTemplateHQL(startDate, endDate, params, currentPage, pageSize,
					"Material", "uploadTime desc", null);
			return new Result(true, page);
		} catch (Exception e) {
			e.printStackTrace();
			return new Result("查询失败");
		}
	}

	// @RequestMapping(value = "/searchMaterialByPid")
	// public @ResponseBody PageResultData<MaterialDto> searchMaterialByPid(String
	// pid, int page, int limit) {
	//
	// if("".equals(pid) || pid == null) {
	// PageResultData<MaterialDto> pageResult1 = new PageResultData<MaterialDto>();
	// pageResult1.setCount(0);
	// pageResult1.setCode(0);
	// pageResult1.setFail(1);
	// pageResult1.setMsg("无敏感素材");
	// return pageResult1;
	// }else {
	// List<Terminal> list = commonService.getAllTerminal();
	// List<Period> listPeriod = commonService.getAllPeriod();
	// try {
	// Page pageD = commonService.searchMaterialByPid(pid, page, limit);
	// List<Material> listM = pageD.getList();
	// List<MaterialDto> listDto = EntityUtil.materialChange(list, listM,
	// listPeriod);
	// PageResultData<MaterialDto> pageResult = new PageResultData<MaterialDto>();
	// pageResult.setCount(pageD.getTotalRecord());
	// pageResult.setCode(0);
	// pageResult.setMsg("");
	// pageResult.setData(listDto);
	// return pageResult;
	// } catch (Exception e) {
	// e.printStackTrace();
	// PageResultData<MaterialDto> pageResult1 = new PageResultData<MaterialDto>();
	// pageResult1.setCount(0);
	// pageResult1.setCode(0);
	// pageResult1.setMsg("");
	// return pageResult1;
	// }
	// }
	// }

	@RequestMapping(value = "/searchMaterialByPid2")
	public @ResponseBody PageResultData<Material> searchMaterialByPid2(String pid, int page, int limit) {
		// 后台计算出页码、页数(页大小)
		// int curPage = 2;
		// int pageSize = 10;
		// int startRow = (curPage - 1) * pageSize;

		System.out.println("pid" + pid + " page " + page + " limit " + limit);

		if (StringUtil.isEmpty(pid)) {
			PageResultData<Material> pageResult1 = new PageResultData<Material>();
			pageResult1.setCount(0);
			pageResult1.setCode(0);
			pageResult1.setFail(1);

			return pageResult1;
		} else {
			List<Material> listM = materialService.findMaterialByPtable(pid);
			PageResultData<Material> pageResult = new PageResultData<Material>();
			pageResult.setCount(listM.size());
			pageResult.setCode(0);
			pageResult.setMsg("");
			pageResult.setData(listM);
			return pageResult;
		}

	}

	@RequestMapping(value = "/searchItemByPid2")
	public @ResponseBody PageResultData<ItemsDto> searchItemByPid2(String pid, int page, int limit) {

		if (StringUtil.isEmpty(pid)) {
			PageResultData<ItemsDto> pageResult1 = new PageResultData<ItemsDto>();
			pageResult1.setCount(0);
			pageResult1.setCode(0);
			pageResult1.setFail(1);
			pageResult1.setMsg("无排播错误");
			return pageResult1;
		} else {

			List<Period> listPeriod = commonService.getAllPeriod();
			List<Items> listM = materialService.findItemByPtable(pid);
			List<ItemsDto> listDto = EntityUtil.getItemsDto(listM, listPeriod);
			PageResultData<ItemsDto> pageResult = new PageResultData<ItemsDto>();
			pageResult.setCount(listDto.size());
			pageResult.setCode(0);
			pageResult.setMsg("");
			pageResult.setData(listDto);
			return pageResult;
		}

	}

	@RequestMapping(value = "/searchTreeFile")
	public @ResponseBody PageResultData searchTreeFile(Model model, String treeId, int page, int limit) {
		System.out.println("treeId=" + treeId);
		List<Terminal> list = commonService.getAllTerminal();
		model.addAttribute("listTerminal", list);
		if (treeId.charAt(0) == 'p') {
			String areaCode = treeId.substring(1);
			try {
				Page pageD = commonService.pageSearchByAreaCode(areaCode, page, limit);
				List<Material> listM = pageD.getList();
				List<MaterialDto> listDto = EntityUtil.getMaterialDtoInfo(listM, list);
				PageResultData<MaterialDto> pageResult = new PageResultData<MaterialDto>();
				pageResult.setCount(pageD.getTotalRecord());
				pageResult.setCode(0);
				pageResult.setMsg("");
				pageResult.setData(listDto);
				return pageResult;
			} catch (Exception e) {
				e.printStackTrace();
				PageResultData<MaterialDto> pageResult1 = new PageResultData<MaterialDto>();
				pageResult1.setCount(0);
				pageResult1.setCode(0);
				pageResult1.setMsg("");
				return pageResult1;
			}
		} else if (treeId.charAt(0) == 't') {
			String tid = treeId.substring(1);
			System.out.println(tid);
			// Terminal terminal = materialService.getTerminalInfo(tid);
			try {
				// Page pageD = commonService.pageSearchByTemplateHQL(params1, page, limit,
				// "Material", "uploadTime desc", null);
				Page pageD = commonService.pageSearchByTid(tid, page, limit);
				List<Material> listM = pageD.getList();
				List<MaterialDto> listDto = EntityUtil.getMaterialDtoInfo(listM, list);
				PageResultData<MaterialDto> pageResult = new PageResultData<MaterialDto>();
				pageResult.setCount(pageD.getTotalRecord());
				pageResult.setCode(0);
				pageResult.setMsg("");
				pageResult.setData(listDto);
				return pageResult;
			} catch (Exception e) {
				e.printStackTrace();
				PageResultData<MaterialDto> pageResult1 = new PageResultData<MaterialDto>();
				pageResult1.setCount(0);
				pageResult1.setCode(0);
				pageResult1.setMsg("");
				return pageResult1;
			}
		} else {
			PageResultData<MaterialDto> pageResult1 = new PageResultData<MaterialDto>();
			pageResult1.setCount(0);
			pageResult1.setCode(0);
			pageResult1.setMsg("");
			return pageResult1;
		}
	}

	@RequestMapping(value = "/treeDate")
	@ResponseBody
	public List<TreeDate> getTreeData() {
		System.out.println(1111);
		List<TreeDate> list = materialService.getAllTreeData();
		System.out.println(list);
		return list;
	}

	@RequestMapping(value = "/checkMaterial")
	@ResponseBody
	public String checkMaterial(String mid, HttpServletRequest request) {
		try {
			Material material = materialService.checkMaterial(mid);
			File file = new File(material.getFilePath());
			if (!file.exists()) {
				request.getSession().setAttribute("materialExist", "false");
				return "true";
			}
			request.getSession().setAttribute("materialExist", "true");
			request.getSession().setAttribute("materialPath", material.getFilePath()); // 视频的路径

			Terminal terminal = material.getTerminal();
			request.getSession().setAttribute("sizeOnce", material.getSize());
			request.getSession().setAttribute("materialIdOnce", material.getMid());
			request.getSession().setAttribute("materialNameOnce", material.getMaterialName());
			request.getSession().setAttribute("terminalNameOnce", terminal.getTerminalName());
			request.getSession().setAttribute("typeOnce", material.getFileType() + "/mp4");
			request.getSession().setAttribute("resolutionOnce", material.getResolution());
			request.getSession().setAttribute("durationOnce", material.getDuration());
			request.getSession().setAttribute("terminalLWOnce", terminal.getLedLength() + "X" + terminal.getLedWidth());
			return "true";
		} catch (Exception e) {
			e.printStackTrace();
			request.getSession().setAttribute("materialExist", "false");
			return "true";
		}

	}

	@RequestMapping(value = "/deposeMaterial")
	@ResponseBody
	public String deposeMaterial(String mid, HttpServletRequest request) {
		try {
			Material material = materialService.getById(mid);
			File file = new File(material.getFilePath());
			if (!file.exists()) {
				request.getSession().setAttribute("materialExist", "false");
				return "false";
			}
			request.getSession().setAttribute("materialExist", "true");
			request.getSession().setAttribute("materialPath", material.getFilePath()); // 视频的路径

			request.getSession().setAttribute("materialThree", material);
			request.getSession().setAttribute("materialIdThree", mid);
			String rid = (String) request.getSession().getAttribute("rId");
			if (rid.equals(Constant.adminValue)) {
				return "true";
			}
			return "false";
		} catch (Exception e) {
			e.printStackTrace();
			request.getSession().setAttribute("materialExist", "false");
			return "false";
		}

	}

	@RequestMapping(value = "/viMaterial")
	@ResponseBody
	public String viMaterial(String mid, HttpServletRequest request) {
		Material material = materialService.getById(mid);
		request.getSession().setAttribute("materialThree", material);
		request.getSession().setAttribute("materialIdThree", mid);
		String rid = (String) request.getSession().getAttribute("rId");
		System.out.println("rid=" + rid);
		return "true";
	}

	@RequestMapping(value = "/checkAccess")
	@ResponseBody
	public String checkAccess(String mid, HttpServletRequest request) {
		String name = (String) request.getSession().getAttribute("userName");
		System.out.println(name);
		Date date = new Date();
		Timestamp timestamp = new Timestamp(date.getTime());
		materialService.checkAccess(mid, name, timestamp);
		return "true";
	}

	@RequestMapping(value = "/checkUnAccess")
	@ResponseBody
	public String checkUnAccess(String mid, HttpServletRequest request) {
		String name = (String) request.getSession().getAttribute("userName");
		Date date = new Date();
		Timestamp timestamp = new Timestamp(date.getTime());
		materialService.checkUnAccess(mid, name, timestamp);
		return "true";
	}

	@RequestMapping("/checkList")
	public String checkList(Model model, HttpServletRequest request) {
		return "check/checkList";
	}

	@RequestMapping("/notifyFile")
	public void notifyFile(HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws IOException {
		// int num = materialService.getAllRecord("1");
		int num = materialService.getAllRecord2("1");
		// int num = userDao.getAccountRecord(1);
		String oldNumStr = "";
		int oldNum = 0;
		if (session.getAttribute("checkNum") == null) {
			oldNum = num;
		} else {
			oldNumStr = "" + session.getAttribute("checkNum");
			oldNum = Integer.parseInt(oldNumStr);
		}
		// String margin = "" + (num - oldNum);
		if ((num - oldNum) > 0) {
			String tmp = "" + num;
			session.removeAttribute("checkNum");
			session.setAttribute("checkNum", tmp);
			PrintWriter out = response.getWriter();
			out.print(tmp);
			out.flush();
			out.close();
		} else {
			session.removeAttribute("checkNum");
			session.setAttribute("checkNum", "" + num);
			PrintWriter out = response.getWriter();
			out.print("0");
			out.flush();
			out.close();
		}
	}

	@RequestMapping("/notifyBroad")
	public void notifyBroad(HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws IOException {
		int num = materialService.getExcepTaable();
		String oldNumStr = "";
		int oldNum = 0;
		if (session.getAttribute("broadNum") == null) {
			oldNum = num;
		} else {
			oldNumStr = "" + session.getAttribute("broadNum");
			oldNum = Integer.parseInt(oldNumStr);
		}
		// String margin = "" + (num - oldNum);
		if ((num - oldNum) > 0) {
			String tmp = "" + num;
			session.removeAttribute("broadNum");
			session.setAttribute("broadNum", tmp);
			PrintWriter out = response.getWriter();
			out.print(tmp);
			out.flush();
			out.close();
		} else {
			session.removeAttribute("broadNum");
			session.setAttribute("broadNum", "" + num);
			PrintWriter out = response.getWriter();
			out.print("0");
			out.flush();
			out.close();
		}
	}

	@RequestMapping("/notifyExcep")
	public void notifyExcep(HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws IOException {
		int num = materialService.getExcepTaableMaterial();
		String oldNumStr = "";
		int oldNum = 0;
		if (session.getAttribute("excepNum") == null) {
			oldNum = num;
		} else {
			oldNumStr = "" + session.getAttribute("excepNum");
			oldNum = Integer.parseInt(oldNumStr);
		}
		// String margin = "" + (num - oldNum);
		if ((num - oldNum) > 0) {
			String tmp = "" + num;
			session.removeAttribute("excepNum");
			session.setAttribute("excepNum", tmp);
			PrintWriter out = response.getWriter();
			out.print(tmp);
			out.flush();
			out.close();
		} else {
			session.removeAttribute("excepNum");
			session.setAttribute("excepNum", "" + num);
			PrintWriter out = response.getWriter();
			out.print("0");
			out.flush();
			out.close();
		}
	}

	@RequestMapping("/notifyFirstCheckTable")
	public void notifyFirstCheckTable(HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws IOException {
		int num = materialService.getFirstCheckTable();
		String oldNumStr = "";
		int oldNum = 0;
		if (session.getAttribute("FirstCheckNum") == null) {
			oldNum = num;
		} else {
			oldNumStr = "" + session.getAttribute("FirstCheckNum");
			oldNum = Integer.parseInt(oldNumStr);
		}
		// String margin = "" + (num - oldNum);
		if ((num - oldNum) > 0) {
			String tmp = "" + num;
			session.removeAttribute("FirstCheckNum");
			session.setAttribute("FirstCheckNum", tmp);
			PrintWriter out = response.getWriter();
			out.print(tmp);
			out.flush();
			out.close();
		} else {
			session.removeAttribute("FirstCheckNum");
			session.setAttribute("FirstCheckNum", "" + num);
			PrintWriter out = response.getWriter();
			out.print("0");
			out.flush();
			out.close();
		}
	}

	@RequestMapping("/notifySecondCheckTable")
	public void notifySecondCheckTable(HttpServletRequest request, HttpServletResponse response, HttpSession session)
			throws IOException {
		int num = materialService.getSecondCheckTable();
		String oldNumStr = "";
		int oldNum = 0;
		if (session.getAttribute("SecondCheckNum") == null) {
			oldNum = num;
		} else {
			oldNumStr = "" + session.getAttribute("SecondCheckNum");
			oldNum = Integer.parseInt(oldNumStr);
		}
		// String margin = "" + (num - oldNum);
		if ((num - oldNum) > 0) {
			String tmp = "" + num;
			session.removeAttribute("SecondCheckNum");
			session.setAttribute("SecondCheckNum", tmp);
			PrintWriter out = response.getWriter();
			out.print(tmp);
			out.flush();
			out.close();
		} else {
			session.removeAttribute("SecondCheckNum");
			session.setAttribute("SecondCheckNum", "" + num);
			PrintWriter out = response.getWriter();
			out.print("0");
			out.flush();
			out.close();
		}
	}

	@RequestMapping(value = "/searchCheckFile")
	public @ResponseBody PageResultData<Material> searchCheckFile(Model model, HttpServletRequest request,
			String materialName, String fileType, String statusId, int page, int limit) {
		String[] param = initParam(materialName, fileType, statusId);
		try {
			// Page page = commonService.pageSearchByTemplateHQL(params, currentPage,
			// pageSize, "File", "uploadTime desc", null);
			Page pageD = commonService.pageSearchCheckByTemplateHQL(param, page, limit, "Material", "uploadTime desc",
					null);
			List<Material> listM = pageD.getList();
			PageResultData<Material> pageResult = new PageResultData<Material>();
			pageResult.setCount(pageD.getTotalRecord());
			pageResult.setCode(0);
			pageResult.setMsg("");
			pageResult.setData(listM);
			return pageResult;
		} catch (Exception e) {
			e.printStackTrace();
			PageResultData<Material> pageResult1 = new PageResultData<Material>();
			pageResult1.setCount(0);
			pageResult1.setCode(0);
			pageResult1.setMsg("");
			return pageResult1;
		}
	}

	@RequestMapping(value = "/upload")
	@ResponseBody
	public void upload(@RequestParam("file") CommonsMultipartFile file, HttpServletRequest request,
			HttpServletResponse response, String tid) throws IOException {
		String fileName = file.getOriginalFilename();
		String ffname = file.getName();
		System.out.println(ffname);
		System.out.println(fileName);
		System.out.println("tid = " + tid);
		String name = (String) request.getSession().getAttribute("userName");
		if (name == null || "".equals(name)) {
			PrintWriter out = response.getWriter();
			out.print("false");
			out.flush();
			out.close();
		} else {
			if (materialService.checkFileName(fileName)) {
				PrintWriter out = response.getWriter();
				out.print(1);
				out.flush();
				out.close();
			} else {
				// Calendar ca = Calendar.getInstance();
				// String year = "" + ca.get(Calendar.YEAR);
				// String savePath = "D:/materialFile/" + year;
				String type = fileName.substring(fileName.lastIndexOf(".") + 1);
				String fName = System.currentTimeMillis() + "." + type;

				// String rootPath =
				// this.getClass().getResource("/").getPath().replaceAll("%20", " ");
				// rootPath = rootPath.substring(0, rootPath.indexOf("WEB-INF")) + "media/" +
				// year;
				String rootPath = Constant.UploadDirecory;
				File ff = new File(rootPath);
				if (!ff.exists()) {
					ff.mkdir();
				}
				rootPath = rootPath + "/" + fName;
				// String path = savePath + "/" + fName;
				try {
					// 方式1
					// File f = new File(rootPath);
					// BufferedInputStream in = new BufferedInputStream(file.getInputStream());
					// BufferedOutputStream out = new BufferedOutputStream(new FileOutputStream(f));
					// byte[] bb = new byte[1024*1024*10];// 用来存储每次读取到的字节数组
					// int n = 0;// 每次读取到的字节数组的长度
					// while ((n = in.read(bb)) != -1) {
					// out.write(bb, 0, n);// 写入到输出流
					// out.flush();
					// }
					// out.close();// 关闭流
					// in.close();

					// FileInputStream is = (FileInputStream) file.getInputStream();
					// FileOutputStream fos = new FileOutputStream(f);
					// byte[] by = new byte[1024*1024*10];
					// int leng = 0;
					// while((leng = is.read(by))>0){
					// fos.write(by, 0, leng);
					// }
					// fos.flush();
					// fos.close();
					// is.close();

					// 方式2
					// File f = new File(rootPath);
					// FileOutputStream fos = new FileOutputStream(f);
					// InputStream is = file.getInputStream();
					// byte[] bts = new byte[1024*1024];
					// //一个一个字节的读取并写入
					// while(is.read(bts)!=-1)
					// {
					// fos.write(bts);
					// }
					// fos.flush();
					// fos.close();
					// is.close();

					// 方式3
					File f = new File(rootPath);
					file.transferTo(f);
				} catch (IOException e) {
					e.printStackTrace();
				}
				if ("".equals(tid) || tid.charAt(0) == 'p' || tid == null) {
					tid = "";
				}
				Material material = setMaterialParameter(fileName, fName, name, request, tid);
				materialService.saveFile(material);
				PrintWriter out = response.getWriter();
				out.print("true");
				out.flush();
				out.close();
			}
		}
	}

	public Material setMaterialParameter(String fileName, String fName, String name, HttpServletRequest request,
			String tid) throws IOException {
		// Calendar ca = Calendar.getInstance();
		// String year = "" + ca.get(Calendar.YEAR);
		// String savePath = "D:/materialFile/" + year;
		String type = fileName.substring(fileName.lastIndexOf(".") + 1);
		// String path = savePath + "/" + fName;

		// String rootPath =
		// this.getClass().getResource("/").getPath().replaceAll("%20", " ");
		// rootPath = rootPath.substring(0, rootPath.indexOf("WEB-INF")) + "media/" +
		// year;
		String rootPath = Constant.UploadDirecory;
		System.out.println("rootPath=" + rootPath);
		File f = new File(rootPath);
		if (!f.exists()) {
			f.mkdir();
		}
		rootPath = rootPath + "/" + fName;
		// rootPath1 = rootPath;
		int durTime = 1;
		BigInteger bigIntMD5 = FileUtil.getMD5(rootPath);
		String md = bigIntMD5.toString(16);
		// savePath = savePath + "/" + fName;
		Material material = new Material();
		material.setDeleted(0);
		material.setTis("0");
		material.setFileName(fileName);
		material.setFilePath(rootPath);
		String materialName = fileName.substring(0, fileName.lastIndexOf("."));
		System.out.println(materialName);
		material.setMaterialName(materialName);
		material.setMd5(md);
		material.setUploadName(name);
		material.setStatusId("1");
		material.setInfo("0");
		material.setUsedNum(0);
		if (!"".equals(tid)) {
			Terminal terminal = commonService.getTerminalById(tid.substring(1));
			material.setTerminal(terminal);
			material.setTis("1");
		}
		material.setUploadTime(new Timestamp(new Date().getTime()));
		int typeId = judgeType(type);
		String resolution = "1X1";
		String size = "0kb";
		if (typeId == 0) {
			material.setFileType("vedio");
			durTime = FileUtil.getDurTime(rootPath);
			resolution = FileUtil.getResolution(rootPath);
			size = FileUtil.getSize(rootPath);
			material.setResolution(resolution);
			material.setSize(size);
			material.setDuration(durTime);
		} else if (typeId == 1) {
			material.setFileType("picture");
			material.setDuration(durTime);
			material.setResolution(resolution);
			material.setSize(size);
		} else {
			material.setFileType("other");
			material.setDuration(durTime);
			material.setSize(size);
			material.setResolution(resolution);
		}
		return material;
	}

	public int judgeType(String type) {
		String str = type.toLowerCase();
		String[] vedio = new String[] { "wmv", "asf", "rm", "rmvb", "mov", "avi", "dat", "mpg", "mpeg", "mp4", "dmv",
				"amv", "3gp", "mtv", "mkv", "mpe", "m2v", "vob", "divx", "flv", "wmvhd", "3g2", "qt", "ogg", "ogv",
				"oga", "mod" };
		String[] picture = new String[] { "jpg", "png", "bmp", "gif", "psd", "jpeg", "ilbm", "iff", "tif", "tiff",
				"mng", "xpm", "sai", "psp", "ufo", "xcf", "pcx", "ppm", "webp", "wdp", "tga", "tpic", "pct", "pic",
				"pict", "jp2", "j2c", "ima", "cdr", "ai" };
		for (String s : vedio) {
			if (s.equals(str)) {
				return 0;
			}
		}
		for (String st : picture) {
			if (st.equals(str)) {
				return 1;
			}
		}
		return 3;
	}

	@RequestMapping(value = "/addMaterial")
	public void addMaterial(String frequency, String testDate, String periodId, String mid, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		System.out.println(mid + " " + periodId + " " + frequency + " ");
		Material material = materialService.getById(mid);
		System.out.println("material=" + material);
		String startTime = "";
		String endTime = "";
		if (!"".equals(testDate) && testDate != null) {
			String[] date = testDate.split(" ");
			startTime = date[0];
			endTime = date[2];
		}
		Items item = new Items();
		if ("".equals(startTime) || "".equals(endTime)) {
			PrintWriter out = response.getWriter();
			out.print("1");
			out.flush();
			out.close();
		} else {
			Date d1 = TimeUtil.translateDate(startTime);
			Date d2 = TimeUtil.translateDate(endTime);
			if (TimeUtil.dateValidate(d1, d2)) {
				String name = (String) request.getSession().getAttribute("userName");
				if (name == null || "".equals(name) || request.getSession().getAttribute("userName") == null) {
					PrintWriter out = response.getWriter();
					out.print("2");
					out.flush();
					out.close();
				} else {
					if ("".equals(frequency)) {
						item.setFrequency(60);
					} else {
						item.setFrequency(Integer.parseInt(frequency));
					}
					item.setEndDate(d2);
					item.setStartDate(d1);
					item.setPeriodId(periodId);
					item.setMaterial(material);
					item.setCreateName(name);
					item.setCreateTime(new Timestamp(new Date().getTime()));
					item.setTerminalId(material.getTerminal().getTerminalId());
					item.setMaterialName(material.getMaterialName());
					item.setDeleted(0);
					item.setDuration(material.getDuration());
					item.setItemName(material.getMaterialName());
					System.out.println("item=" + item);
					materialService.saveItem(item);
					material.setInfo("1"); // 是否排播
					material.setUsedNum(material.getUsedNum() + 1);
					materialService.updateMaterial(material);
					PrintWriter out = response.getWriter();
					out.print("true");
					out.flush();
					out.close();
				}
			} else {
				PrintWriter out = response.getWriter();
				out.print("1");
				out.flush();
				out.close();
			}
		}
	}

	@RequestMapping(value = "/delMaterial")
	public @ResponseBody String delMaterial(String[] mid, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String rid = (String) request.getSession().getAttribute("rId");
		if (rid.equals(Constant.adminValue)) { // 是系统管理员的话
			materialService.delFile(mid); // 直接逻辑删除
		} else {
			materialService.delFile2(mid);
		}
		return "true";
	}

	@RequestMapping(value = "/delItem")
	public @ResponseBody Result delItem(String[] itemIds) {
		if (itemIds == null || itemIds.length < 1) {
			return new Result("删除错误");
		}

		// 开始更新数据
		try {
			commonService.deleteItems(itemIds);
			return new Result(true, "");
		} catch (Exception e) {
			e.printStackTrace();
			return new Result("删除错误");
		}

	}

	@RequestMapping(value = "/tidMaterial")
	public void tidMaterial(String[] tid, HttpServletRequest request, HttpServletResponse response) throws Exception {
		materialService.tidMaterial(tid);
		PrintWriter out = response.getWriter();
		out.print("true");
		out.flush();
		out.close();
	}

	@RequestMapping(value = "/editMaterial")
	public void editFile(String mid, String materialName, String newTerminalId, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		System.out.println(mid + "=" + materialName);
		if ("".equals(mid) || mid == null) {
			PrintWriter out = response.getWriter();
			out.print("1");
			out.flush();
			out.close();
		} else {
			Material file = commonService.queryById(mid);
			// 如果materialName为空,就按照原先的素材名称
			if (StringUtil.isEmpty(materialName))
				materialName = file.getMaterialName();
			String rid = (String) request.getSession().getAttribute("rId");

			if ((Constant.secondCheck).equals(file.getStatusId())) {
				if ((Constant.uploadValue).equals(rid)) {
					PrintWriter out = response.getWriter();
					out.print("2");
					out.flush();
					out.close();
				} else if ((Constant.adminValue).equals(rid)) {
					if (!"".equals(materialName)) {
						file.setMaterialName(materialName);
						if (!"".equals(newTerminalId) && !file.getTerminal().getTerminalId().equals(newTerminalId)) {
							Terminal terminal = commonService.getTerminalById(newTerminalId);
							file.setTerminal(terminal);
						}
						commonService.updateFile(file);
						System.out.println(file);
						PrintWriter out = response.getWriter();
						out.print("true");
						out.flush();
						out.close();
					}
				}
			} else {
				if (!"".equals(materialName)) {
					file.setMaterialName(materialName);
					if (!"".equals(newTerminalId) && !file.getTerminal().getTerminalId().equals(newTerminalId)) {
						Terminal terminal = commonService.getTerminalById(newTerminalId);
						file.setTerminal(terminal);
					}
					commonService.updateFile(file);
					PrintWriter out = response.getWriter();
					out.print("true");
					out.flush();
					out.close();
				}
			}

		}
	}

	@RequestMapping(value = "/editFile")
	public void editFile(String mid, String frequency, String testDate, String periodId, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		System.out.println("===" + mid + "=" + frequency + "=" + periodId + "=" + testDate);
		String startTime = "";
		String endTime = "";
		if ("".equals(mid) || mid == null) {
			PrintWriter out = response.getWriter();
			out.print("1");
			out.flush();
			out.close();
		} else {
			// Material file = commonService.queryById(mid);
			Items file = commonService.queryByItemId(mid);
			if (!"".equals(frequency)) {
				file.setFrequency(Integer.parseInt(frequency));
			}

			if (!"".equals(periodId)) {
				file.setPeriodId(periodId);
			}
			if (!"".equals(testDate)) {
				String[] date = testDate.split(" ");
				startTime = date[0];
				endTime = date[2];
				Date d1 = TimeUtil.translateDate(startTime);
				Date d2 = TimeUtil.translateDate(endTime);
				if (TimeUtil.dateValidate(d1, d2)) {
					file.setStartDate(d1);
					file.setEndDate(d2);
					commonService.updateItem(file);
					PrintWriter out = response.getWriter();
					out.print("true");
					out.flush();
					out.close();
				} else {
					commonService.updateItem(file);
					PrintWriter out = response.getWriter();
					out.print("1");
					out.flush();
					out.close();
				}
			} else {
				commonService.updateItem(file);
				PrintWriter out = response.getWriter();
				out.print("true");
				out.flush();
				out.close();
			}
		}
	}
	
	//7.16
	@RequestMapping("/getPidMaterialInfo")
	@ResponseBody
	public PageResultData<Material> getPidMaterialInfo(String param,String alreadymid, int page, int limit, Model model,
			HttpServletRequest request) {
		System.out.println(param);
		String[] params = param.split(",");
		try {
			Page pageD = commonService.pageSearchByTemplateHQL(params, alreadymid,page, limit, "Material", "uploadTime desc",
					null);
			List<Material> listM = pageD.getList();
			for (Material m : listM) {
				System.out.println(m);
			}
			PageResultData<Material> pageResult = new PageResultData<Material>();
			pageResult.setCount(pageD.getTotalRecord());
			pageResult.setCode(0);
			pageResult.setMsg("");
			pageResult.setData(listM);
			return pageResult;
		} catch (Exception e) {
			e.printStackTrace();
			PageResultData<Material> pageResult1 = new PageResultData<Material>();
			pageResult1.setCount(0);
			pageResult1.setCode(0);
			pageResult1.setMsg("查询异常");
			pageResult1.setFail(1);
			return pageResult1;
		}
	}
}
