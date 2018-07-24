package org.south.itms.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.south.itms.dto.PageResultData;
import org.south.itms.dto.PlayNumDto;
import org.south.itms.entity.PlayLog;
import org.south.itms.entity.Terminal;
import org.south.itms.service.impl.CommonService;
import org.south.itms.service.impl.StatisticService;
import org.south.itms.util.Constant;
import org.south.itms.util.StringUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller  
@RequestMapping("/statistic")  
public class StatisticController {

	@Autowired
	private CommonService commonService;
	
	@Autowired
	private StatisticService statisticService;
	
	
	@RequestMapping("/showReport")
	public String showReport(Model model) {
		List<Terminal> listTerminal = commonService.getAllTerminal();
		model.addAttribute("terminalPtable", listTerminal);
		return "statistic/statisticalReport";
	}
	
	
	@RequestMapping(value = "/searchPlayNum")
	public @ResponseBody PageResultData<PlayNumDto> searchPlayNum(String terminalId, String dateTime) {
		//System.out.println("+asdasdasdasdasdasda+++++");
		if(StringUtil.isEmpty(terminalId) || StringUtil.isEmpty(dateTime)) {
		    return null;
		}
		
		try {
			String[] time = dateTime.split(" ");
			String startTime = time[0] + " " + time[1];
			String endTime = time[3] + " " + time[4];

			
			List<PlayNumDto> list = statisticService.findPlayNumDto(terminalId, startTime, endTime);
			PageResultData<PlayNumDto> pageResult = new PageResultData<PlayNumDto>();
			pageResult.setCount(list.size());
			pageResult.setCode(0);
			pageResult.setMsg("");
			pageResult.setData(list);
			return pageResult;
		} catch (Exception e) {
			e.printStackTrace();
			PageResultData<PlayNumDto> pageResult = new PageResultData<PlayNumDto>();
			pageResult.setCount(0);
			pageResult.setCode(0);
			pageResult.setMsg("查询出错");
			return pageResult;
		}
		
		
	}
	
	
	 
	@RequestMapping(value = "/searchPlayDetail")
	public @ResponseBody PageResultData<PlayLog> searchPlayDetail(String terminalId, String dateTime) {
		if(StringUtil.isEmpty(terminalId) || StringUtil.isEmpty(dateTime)) {
		    return null;
		}
		
		try {
			String[] time = dateTime.split(" ");
			String startTime = time[0] + " " + time[1];
			String endTime = time[3] + " " + time[4];

			
			List<PlayLog> list = statisticService.findPlayLog(terminalId, startTime, endTime);
			PageResultData<PlayLog> pageResult = new PageResultData<PlayLog>();
			pageResult.setCount(list.size());
			pageResult.setCode(0);
			pageResult.setMsg("");
			pageResult.setData(list);
			return pageResult;
		} catch (Exception e) {
			e.printStackTrace();
			PageResultData<PlayLog> pageResult = new PageResultData<PlayLog>();
			pageResult.setCount(0);
			pageResult.setCode(0);
			pageResult.setMsg("查询出错");
			return pageResult;
		}
		
		
	}
	
	
	
	
	@RequestMapping(value = "/generateExcel")
	public void generateExcel(String terminalId, String dateTime, String type, HttpServletResponse response) {
		if(StringUtil.isEmpty(terminalId) || StringUtil.isEmpty(dateTime) || StringUtil.isEmpty(type)) {
			return;
		}
		
		try {
			
			String[] time = dateTime.split(" ");
			String startTime = time[0] + " " + time[1];
			String endTime = time[3] + " " + time[4];
			
			
			
	        // 第一步，创建一个webbook，对应一个Excel文件  
	        HSSFWorkbook wb = new HSSFWorkbook();  
	        // 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet  
	        HSSFSheet sheet = wb.createSheet("表一");  
	        // 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short  
	        HSSFRow row = sheet.createRow((int) 0);   
	       
	        // 第四步，创建单元格，并设置值表头
			if("1".equals(type)) {   //播放日志详细表
				
			    HSSFCell cell = row.createCell((short) 0);  
		        cell.setCellValue("播放端名称");  
		        
		        cell = row.createCell((short) 1);  
		        cell.setCellValue("播放的视频名称");  
		        
		        cell = row.createCell((short) 2);  
		        cell.setCellValue("开始播放时间");  
		        
		        cell = row.createCell((short) 3); 
		        cell.setCellValue("结束播放时间");  
		        
		        cell = row.createCell((short) 4); 
		        cell.setCellValue("所属播表");  
		        
	
		  
		        // 第五步，写入实体数据 实际应用中这些数据从数据库得到，  
		        List<PlayLog> list = statisticService.findPlayLog(terminalId, startTime, endTime);
		  
		        for (int i = 0; i < list.size(); i++)  
		        {  
		            row = sheet.createRow((int) i + 1);  
		            PlayLog playLog = list.get(i); 
		            
		            row.createCell((short) 0).setCellValue(playLog.getTerminalName());  
		            row.createCell((short) 1).setCellValue(playLog.getMaterialName());  
		            
		            cell = row.createCell((short) 2);  
		            cell.setCellValue(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(playLog.getPlayStartTime()));  
		            
		            cell = row.createCell((short) 3);  
		            cell.setCellValue(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(playLog.getPlayEndTime()));
		            
		            row.createCell((short) 4).setCellValue(playLog.getPname());  
		        }  	
				
			} else if("2".equals(type)) {  //播放次数统计表
				    HSSFCell cell = row.createCell((short) 0);  
			        cell.setCellValue("素材名称");  
			        
			        cell = row.createCell((short) 1);  
			        cell.setCellValue("总播放次数");  
			        
			        cell = row.createCell((short) 2);  
			        cell.setCellValue("开始播放时间");  
			        
			        cell = row.createCell((short) 3); 
			        cell.setCellValue("结束播放时间");  
			        
	
			  
			        // 第五步，写入实体数据 实际应用中这些数据从数据库得到，  
			        List<PlayNumDto> list = statisticService.findPlayNumDto(terminalId, startTime, endTime);
			  
			        for (int i = 0; i < list.size(); i++)  
			        {  
			            row = sheet.createRow((int) i + 1);  
			            PlayNumDto playNumDto = list.get(i); 
			            
			            row.createCell((short) 0).setCellValue(playNumDto.getMaterialName());  
			            row.createCell((short) 1).setCellValue(playNumDto.getPlayNum());  
			            row.createCell((short) 2).setCellValue(playNumDto.getStartPlayTime());  
			            row.createCell((short) 3).setCellValue(playNumDto.getEndPlayTime()); 
			            
	//		            cell = row.createCell((short) 2);  
	//		            cell.setCellValue(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(playLog.getPlayStartTime()));  
	//		            
	//		            cell = row.createCell((short) 3);  
	//		            cell.setCellValue(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(playLog.getPlayEndTime()));
			            
			
			        }  	
			}
			
			
			
	        // 第六步，将文件存到指定位置  
	    	File file = new File(Constant.ExcelPath);
	    	if(!file.exists()) file.mkdirs();
	    	String excelFileName = Constant.ExcelPath + "/" + UUID.randomUUID().toString() + ".xls";
	        FileOutputStream fout = new FileOutputStream(excelFileName);  
	        wb.write(fout);  
	        fout.close();  
	         
	        new DownloadController().downloadFile(new File(excelFileName), response, true);
	       
		} catch(Exception e) {
			e.printStackTrace();
		}
		
	}
	
	
	
}
