package org.south.itms.util;

import java.util.HashMap;
import java.util.Map;

import org.south.itms.entity.File;

/**
 * @author: yezilong
 */

public class StringUtil {

	
	public static boolean isEmpty(String s) {  //字符串非空验证
		if(s == null || s.length() <= 0) {
			return true;
		} else {
			return false;
		}
	}
	
	
	public static String getFileName(String filePath) {  //通过文件路径获取文件名
		try {
			String fileName = filePath.substring(filePath.lastIndexOf("/") + 1);
			return fileName;
		} catch(Exception e) {
			return null;
		}
	}


	/**
	 * @param tempFile
	 * @param file
	 * @return
	 */
	public static File generateHql(File tempFile, File file) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("startTime", tempFile.getStartTime());
		map.put("endTime", tempFile.getEndTime());
		if("".equals(tempFile.getMaterialName())) {
			tempFile.setMaterialName(file.getMaterialName());
		}else {
			map.put("materialName", tempFile.getMaterialName());
		}
		
		if("isNull".equals(tempFile.getTerminalId())) {
			tempFile.setTerminalId(file.getTerminalId());
		}else {
			map.put("terminalId", tempFile.getTerminalId());
		}
		
		if("isNull".equals(tempFile.getPeriodId())) {
			tempFile.setPeriodId(file.getPeriodId());
		}else {
			map.put("periodId", tempFile.getPeriodId());
		}
		
		if(tempFile.getFrequency() == 0) {
			tempFile.setFrequency(file.getFrequency());
		}else {
			map.put("frequency", tempFile.getFrequency());
		}
		return tempFile;
	}
	
	public static File generateFile(File tempFile, File file) {
		file.setStartTime(tempFile.getStartTime());
		file.setEndTime(tempFile.getEndTime());
		if("".equals(tempFile.getMaterialName())) {
			
		}else {
			file.setMaterialName(tempFile.getMaterialName());
		}
		
		if("isNull".equals(tempFile.getTerminalId())) {
			tempFile.setTerminalId(file.getTerminalId());
		}else {
			
		}
		
		if("isNull".equals(tempFile.getPeriodId())) {
			tempFile.setPeriodId(file.getPeriodId());
		}else {
			
		}
		
		if(tempFile.getFrequency() == 0) {
			
		}else {
			file.setFrequency(tempFile.getFrequency());
		}
		
		return file;
	}
	
	
}
