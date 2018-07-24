package org.south.itms.controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.south.itms.util.UploadState;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
/**
 * @author jan
 * @date 2018年1月17日 下午4:25:45
 * @version V1.0 
 */
@Controller
@RequestMapping("/progress")
public class ProgressListenerController {

	@RequestMapping("/getProgress")
	public void progressUpload(HttpServletResponse response, HttpServletRequest request) throws IOException {
		 // 从session中取得名称为uploadState的State对象
		UploadState state = (UploadState) request.getSession().getAttribute("uploadState");
        System.out.println("tempState=" + state);
        if (state != null) {
        	if(state.getPercent() == 100) {
        		request.getSession().removeAttribute("uploadState");
        	}
        	System.out.println("percent()=" + state.getPercent());
        	PrintWriter out=response.getWriter();
        	out.print(state.getPercent());
			out.flush();
			out.close();
        }else {
        	PrintWriter out=response.getWriter();
        	out.print(0);
			out.flush();
			out.close();
        }
	}
}
