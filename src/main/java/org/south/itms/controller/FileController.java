package org.south.itms.controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigInteger;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.south.itms.dao.impl.FileDao;
import org.south.itms.dao.impl.MaterialDao;
import org.south.itms.dao.impl.UserDao;
import org.south.itms.dto.Page;
import org.south.itms.dto.Result;
import org.south.itms.entity.Material;
import org.south.itms.entity.Period;
import org.south.itms.entity.Terminal;
import org.south.itms.service.impl.CommonService;
import org.south.itms.util.FileUtil;
import org.south.itms.util.StringUtil;
import org.south.itms.util.TimeUtil;
import org.south.netty.NettyChannelMap;
import org.south.netty.msg.DownloadMsg;
import org.south.netty.msg.MsgType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import io.netty.channel.Channel;

@Controller
@RequestMapping("/file")
public class FileController {

	@Autowired
	private CommonService commonService;
	
	
	@Autowired
	private MaterialDao materialDao;
	
	@Autowired
	private FileDao fileDao;
	
	@Autowired
	private UserDao userDao;	

	@RequestMapping("/transferFileList")
	public String transferFileList() {
		return "file/transfer/transferList";
	}
	
	@RequestMapping("/notifyFile")
	public void notifyFile(HttpServletRequest request, HttpServletResponse response,
			HttpSession session) throws IOException {
		int num = userDao.getAccountRecord(1);
		String oldNumStr = "" + session.getAttribute("checkNum");
		int oldNum = Integer.parseInt(oldNumStr);
//		String margin = "" + (num - oldNum);
		if((num - oldNum) > 0) {
			String tmp = "" + num;
			session.removeAttribute("checkNum");
			session.setAttribute("checkNum", tmp);
			PrintWriter out = response.getWriter();
			out.print(tmp);
			out.flush();
			out.close();
		}else {
			PrintWriter out = response.getWriter();
			out.print("0");
			out.flush();
			out.close();
		}
	}
	
	
	@RequestMapping("/notifyFileSec")
	public void notifyFileSec(HttpServletRequest request, HttpServletResponse response,
			HttpSession session) throws IOException {
		int num = userDao.getAccountRecord(2);
		String oldNumStr = "" + session.getAttribute("checkNumSec");
		int oldNum = Integer.parseInt(oldNumStr);
//		String margin = "" + (num - oldNum);
		if((num - oldNum) > 0) {
			String tmp = "" + num;
			session.removeAttribute("checkNumSec");
			session.setAttribute("checkNumSec", tmp);
			PrintWriter out = response.getWriter();
			out.print(tmp);
			out.flush();
			out.close();
		}else {
			PrintWriter out = response.getWriter();
			out.print("0");
			out.flush();
			out.close();
		}
	}
	
	
	@RequestMapping("/fileList")
	public String fileList(Model model, HttpServletRequest request) {
		List<Terminal> listTerminal = commonService.getAllTerminal();
		List<Period> listPeriod = commonService.getAllPeriod();
//		for(Terminal t:listTerminal){
//			System.out.println(t);
//		}
		request.getSession().setAttribute("terminalsOne", listTerminal.get(0).getTerminalId());
		request.getSession().setAttribute("periodOne", listPeriod.get(2).getPeriodId());
		request.getSession().setAttribute("periodList", listPeriod);
		model.addAttribute("terminals", listTerminal);
		model.addAttribute("periods", listPeriod);
		return "file/fileList";
	}
	
	@RequestMapping("/checkList")
	public String checkList(Model model, HttpServletRequest request) {
		List<Terminal> listTerminal = commonService.getAllTerminal();
//		for(Terminal t:listTerminal){
//			System.out.println(t);
//		}
		List<Period> listPeriod = commonService.getAllPeriod();
//		request.getSession().setAttribute("periodOne", listPeriod.get(2).getPeriodId());
//		request.getSession().setAttribute("periodList", listPeriod);
		model.addAttribute("periodsCheck", listPeriod);
		request.getSession().setAttribute("terminalsOne", listTerminal.get(0).getTerminalId());
		model.addAttribute("terminals", listTerminal);
		if(Integer.parseInt((String)request.getSession().getAttribute("rId")) == 5) return "check/checkFinalList";
		return "check/checkList";
	}

	@RequestMapping(value = "/searchFile")
	public @ResponseBody Result searchFile(String[] params, int currentPage, int pageSize) {
		try {
			Page page = commonService.pageSearchByTemplateHQL(params, currentPage, pageSize, "File", "uploadTime desc", null);
			return new Result(true, page);
		} catch (Exception e) {
			e.printStackTrace();
			return new Result("查询失败");
		}
	}
	
	@RequestMapping(value = "/searchCheckFile")
	public @ResponseBody Result searchCheckFile(
			Model model, HttpServletRequest request,
			String[] params, int currentPage, int pageSize) {
		System.out.println(555555);
		try {
			//Page page = commonService.pageSearchByTemplateHQL(params, currentPage, pageSize, "File", "uploadTime desc", null);
			Page page = commonService.pageSearchCheckByTemplateHQL(params, currentPage, pageSize, "File", "uploadTime desc", null);
			return new Result(true, page);
		} catch (Exception e) {
			e.printStackTrace();
			return new Result("查询失败");
		}
	}
	
	@RequestMapping(value = "/searchCheckFinalFile")
	public @ResponseBody Result searchCheckFinalFile(
			Model model, HttpServletRequest request,
			String[] params, int currentPage, int pageSize) {
		System.out.println(555555);
		try {
			//Page page = commonService.pageSearchByTemplateHQL(params, currentPage, pageSize, "File", "uploadTime desc", null);
			Page page = commonService.pageSearchCheckFinalByTemplateHQL(params, currentPage, pageSize, "File", "uploadTime desc", null);
			return new Result(true, page);
		} catch (Exception e) {
			e.printStackTrace();
			return new Result("查询失败");
		}
	}
	
	@RequestMapping(value = "/transferFile")
	public @ResponseBody Result transferFile(String[] fileIds, String[] terminalIds, boolean isOffset) {
		try {
			// 非空验证
			if (fileIds == null || fileIds.length < 1 || terminalIds == null || terminalIds.length < 1) {
				return new Result("请至少选择一个传输文件和播放端");
			}

			// 将在线的播放端和不在线的播放端分离开来
			List<String> tIdOnList = new ArrayList<String>();
			List<String> tIdOffList = new ArrayList<String>();
			for (String tId : terminalIds) {
				if (NettyChannelMap.containsKey(tId))
					tIdOnList.add(tId);
				else
					tIdOffList.add(tId);
			}

			if (tIdOnList.size() < 1)
				return new Result("传输到的播放端此时都不在线");

			// 记录哪些文件是不能传输的
			List<String> fIdNoList = new ArrayList<String>();

			// 将文件依次发送到各个播放端
			for (String mid : fileIds) {
				//org.south.itms.entity.File entityFile = fileDao.get(fileId);
				//Material material = fileDao.getById(mid);
				Material material = materialDao.getById(mid);
				String filePath = material.getFilePath();
				byte[] attachment = FileUtil.fileToBytes(filePath);
				if (attachment == null) {
					fIdNoList.add(mid);
					continue;
				}

				String fileName = StringUtil.getFileName(filePath);

				DownloadMsg downloadMsg = new DownloadMsg();
				downloadMsg.setAttachment(FileUtil.gZip(attachment));  //需要对字节数组进行压缩传输
				downloadMsg.setFileName(fileName);
				if (isOffset) { // 如果是终端检查缺少文件请求，重新下载的话
					downloadMsg.setReplyType(MsgType.OffsetFile);
				}

				// 将文件依次发送到对应的播放端
				for (String terminalId : tIdOnList) {
					try {
						Channel channel = NettyChannelMap.get(terminalId);
						channel.writeAndFlush(downloadMsg);
					} catch (Exception e) {
						e.printStackTrace();
					}
				}

			}

			Map<String, Object> map = new HashMap<String, Object>();
			map.put("fIdNoList", fIdNoList); // 无法传输的文件
			map.put("tIdOffList", tIdOffList); // 无法到达的终端
			return new Result(true, map);
		} catch (Exception e) {
			e.printStackTrace();
			return new Result("传输失败");
		}
	}
	
	
	
	@RequestMapping(value = "/uploadFile")
	public void uploadVideoFile(@RequestParam("uploadFile")CommonsMultipartFile file,
//			org.south.itms.entity.File uploadFile,
			String terminalId ,String frequency,
			String startTime, String endTime,
			String materialName,
			String periodId, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		System.out.println(terminalId + "=" + periodId);
		if ("".equals(startTime) || "".equals(endTime)) {
			PrintWriter out = response.getWriter();
			out.print("1");
			out.flush();
			out.close();
		} else {
			Date date1 = TimeUtil.translateDate(startTime);
			Date date2 = TimeUtil.translateDate(endTime);

			System.out.println(terminalId + "---" + frequency + "====");

			String fileName = file.getOriginalFilename();
			boolean check = commonService.queryByName(fileName);
			if (check) {
				PrintWriter out = response.getWriter();
				out.print("false");
				out.flush();
				out.close();
			} else {
				Calendar ca = Calendar.getInstance();
				String year = "" + ca.get(Calendar.YEAR);
				String savePath = "D:/filesystem/" + year;
				String type = fileName.substring(fileName.lastIndexOf(".") + 1);
				String fName = System.currentTimeMillis() + "." + type;
				String path = savePath + "/" + fName;
				//String rootPath = request.getRealPath("/") + "media/" + fName;
				//System.out.println(request.getRealPath("/"));
				String rootPath = this.getClass().getResource("/").getPath().replaceAll("%20", " ");
				rootPath = rootPath.substring(0, rootPath.indexOf("WEB-INF")) + "media/" + fName;
				System.out.println(rootPath);
				File f = new File(path);
				if (!f.exists()) {
					f.mkdirs();
				}
				int durTime = 1;
				try {
					file.transferTo(f);
				} catch (Exception e) {
					e.printStackTrace();
				}

				FileUtil.fileCopy(path, rootPath);
				BigInteger bigIntMD5 = FileUtil.getMD5(path);

				org.south.itms.entity.File upload = new org.south.itms.entity.File();
				if ("".equals(frequency)) {
					upload.setFrequency(10);
				} else {
					upload.setFrequency(Integer.parseInt(frequency));
				}
				if ("isNull".equals(terminalId)) {
					System.out.println((String) request.getSession().getAttribute("terminalsOne"));
					upload.setTerminalId((String) request.getSession().getAttribute("terminalsOne"));
				} else {
					upload.setTerminalId(terminalId);
				}

				if ("isNull".equals(periodId)) {
					//upload.setPeriodId((String) request.getSession().getAttribute("periodOne"));
				} else {
					upload.setPeriodId(periodId);
				}

				savePath = savePath + "/" + fName;
				System.out.println((String) request.getSession().getAttribute("userName"));
				upload.setDeleted(0);
				upload.setUploadName((String) request.getSession().getAttribute("userName"));
				upload.setFileName(fileName);
				upload.setFilePath(savePath);
				String md = bigIntMD5.toString(16);
				upload.setMd5(md);
				upload.setStartTime(date1);
				upload.setEndTime(date2);
				upload.setMaterialName(materialName);
				upload.setStatusId("1");
				int typeId = judgeType(type);
				if (typeId == 0) {
					upload.setFileType("vedio");
					durTime = FileUtil.getDurTime(path);
					upload.setDuration(durTime);
				} else if (typeId == 1) {
					upload.setFileType("picture");
					upload.setDuration(durTime);
				} else {
					upload.setFileType("other");
					upload.setDuration(durTime);
				}
				Date date = new Date();
				Timestamp timestamp = new Timestamp(date.getTime());
				upload.setUploadTime(timestamp);
				System.out.println(upload);
				commonService.saveVideoFile(upload);
				PrintWriter out = response.getWriter();
				out.print("true");
				out.flush();
				out.close();
			}		    
		}
	}
	
	public int judgeType(String type){
		String str = type.toLowerCase();
		String[] vedio = new String[]{"wmv", "asf", "rm","rmvb","mov","avi","dat","mpg","mpeg","mp4","dmv","amv","3gp"
				,"mtv","mkv","mpe","m2v","vob","divx","flv","wmvhd","3g2","qt","ogg","ogv","oga","mod"};
		String[] picture = new String[]{"jpg","png","bmp","gif","psd","jpeg","ilbm","iff","tif","tiff","mng","xpm"
				,"sai","psp","ufo","xcf","pcx","ppm","webp","wdp","tga","tpic","pct","pic","pict","jp2","j2c","ima"
				,"cdr","ai"};
		for(String s:vedio){
			if(s.equals(str)){
				return 0;
			}
		}
		for(String st:picture){
			if(st.equals(str)){
				return 1;
			}
		}
		return 3;
	}
	
	@RequestMapping(value = "/firstCheckFile")
	public void firstCheckFile(String fileId, HttpServletRequest request,
			HttpServletResponse response) throws Exception{
		System.out.println(fileId);
		String name = (String) request.getSession().getAttribute("userName");
		Date date = new Date();
		Timestamp timestamp = new Timestamp(date.getTime());
		commonService.firstCheckFile(fileId, name, timestamp);
		PrintWriter out = response.getWriter();
		out.print("true");
		out.flush();
		out.close();
	}
	
	@RequestMapping(value = "/secondCheckFile")
	public void secondCheckFile(String fileId, HttpServletRequest request,
			HttpServletResponse response) throws Exception{
		System.out.println(fileId);
		String name = (String) request.getSession().getAttribute("userName");
		Date date = new Date();
		Timestamp timestamp = new Timestamp(date.getTime());
		commonService.secondCheckFile(fileId, name, timestamp);
		PrintWriter out = response.getWriter();
		out.print("true");
		out.flush();
		out.close();
	}
	
	@RequestMapping(value = "/firstUncheckFile")
	public void firstUncheckFile(String fileId, HttpServletRequest request,
			HttpServletResponse response) throws Exception{
		System.out.println(fileId);
		String name = (String) request.getSession().getAttribute("userName");
		Date date = new Date();
		Timestamp timestamp = new Timestamp(date.getTime());
		commonService.firstUncheckFile(fileId, name, timestamp);
		PrintWriter out = response.getWriter();
		out.print("true");
		out.flush();
		out.close();
	}
	
	@RequestMapping(value = "/delFile")
	public void deleteFile(String[] fileId, HttpServletRequest request,
			HttpServletResponse response) throws Exception{
		commonService.delFile(fileId);
		PrintWriter out = response.getWriter();
		out.print("true");
		out.flush();
		out.close();
	}
	/*
	@RequestMapping(value = "/editFile")
	public void editFile(String fileId, String terminalId ,String frequency,
			String startTime, String endTime,
			String materialName, String periodId,
			HttpServletRequest request,
			HttpServletResponse response) throws Exception{
		        System.out.println(terminalId + "===" + frequency);
		        
		        org.south.itms.entity.File file = commonService.queryById(fileId);
		        
		        if(materialName.equals(file.getMaterialName())) {
					PrintWriter out = response.getWriter();
					out.print("false");
					out.flush();
					out.close();
		        }else if("2".equals(file.getStatusId()) || "3".equals(file.getStatusId())){
		        	PrintWriter out = response.getWriter();
					out.print("2");
					out.flush();
					out.close();
		        }else {
		    		if ("".equals(startTime) || "".equals(endTime)) {
		    			PrintWriter out = response.getWriter();
		    			out.print("1");
		    			out.flush();
		    			out.close();
		    		}else {
		    			org.south.itms.entity.File tempFile = new org.south.itms.entity.File();
		    			Date d1 = TimeUtil.translateDate(startTime);
		    			Date d2 = TimeUtil.translateDate(endTime);
		    			if(TimeUtil.dateValidate(d1, d2)) {
			    			tempFile.setFileId(fileId);
			    			System.out.println("materialName=" + materialName);
			    			tempFile.setMaterialName(materialName);
			    			if("".equals(frequency)) {
			    				tempFile.setFrequency(0);
			    			}else {			    				
			    				tempFile.setFrequency(Integer.parseInt(frequency));
			    			}
			    			tempFile.setEndTime(d2);
			    			tempFile.setStartTime(d1);
			    			tempFile.setPeriodId(periodId);
			    			tempFile.setTerminalId(terminalId);
			    			System.out.println(tempFile);
			    			tempFile.setStatusId("1");
			    			org.south.itms.entity.File map = StringUtil.generateFile(tempFile, file);
			    			System.out.println(map);
			    			commonService.updateFile(map);
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
			}
			*/

}
