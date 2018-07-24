package org.south.itms.controller;

import org.south.itms.dto.Result;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @author: yezilong
 */

@Controller  
@RequestMapping("/front")  
public class FrontController {   //浏览前台的controller
	

	  @RequestMapping("/index")    
	  public String index() {  
	     return "forward:/views/index.jsp";
	  }
	  
	
	  
	  @RequestMapping(value="/noAuthority")  
	  public @ResponseBody Result noAuthority() {  //没有权限的提示
		  Result result =  new Result("对不起, 你没有对应的权限");
		  result.setFailType("noAuthority");
		  return result;
	  }
	  
  
}  
