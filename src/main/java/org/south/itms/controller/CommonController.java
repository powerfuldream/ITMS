package org.south.itms.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @author: yezilong
 */

@Controller  
@RequestMapping("/common")  
public class CommonController {  //处理通用的请求
	
	
	@RequestMapping("/selectFile")
	public String selectFile() {
		return "common/selectFile";
	}
	
	@RequestMapping("/selectTerminal")
	public String selectTerminal() {
		return "common/selectTerminal";
	}
	
	

}
