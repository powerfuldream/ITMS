package org.south.itms.util;

/**
 * @author: yezilong
 */


public class Constant {
	public static final String adminRoleName = "系统管理员";
	
	
	public static final String terminalResourceType = "terminal";
	public static final String searchTerminalUrlPrefix = "searchTerminal";
	public static final String delTerminalUrlPrefix = "delTerminal";
	public static final String updateTerminalStateUrlPrefix = "updateTerminalState";
	
	//状态常量
	public static final String uncheck = "1";   //未审核
	public static final String firstCheck = "2";  //初审通过
	public static final String secondCheck = "3";  //已通过
	public static final String unaccess = "4";  //未通过
	public static final String broadErr = "5";  //异常播表素材排播信息
	public static final String materialErr = "6";  //异常播表素材敏感信息
	public static final String Allerr = "7";  //播表异常信息
	
	//排播常量
	public static final String noBroad = "0";
	public static final String yesBroad = "1";
	
	//角色常量
	public static final String adminValue = "1";  //超级管理员
	public static final String uploadValue = "3";  //上传
	public static final String materialCheckValue = "4";  //素材审核
	public static final String ptableFirstValue = "6";  //超级管理员
	public static final String ptableSecondValue = "7";  //超级管理员
	public static final String broadValue = "10";  //排播
	
	
	//上传的文件保存的目录
	public static final String UploadDirecory = "D:/itmsServer";
	//excel导出的目录
	public static String ExcelPath = "D:/itmsServer/Excel";
	
    // 在服务器端创建打包下载的临时文件
	public static final String TmpZipPath = "D:/itmsServer/tmp/";  
	
}
