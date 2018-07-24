package org.south.itms.interceptor;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.south.itms.dao.impl.ResourceDao;
import org.south.itms.entity.Resource;
import org.south.itms.entity.User;
import org.south.itms.util.Constant;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

/**
 * @author: yezilong
 */

public class CoreInterceptor implements HandlerInterceptor {

	@Autowired
	private ResourceDao resourceDao;

	private static List<Resource> publicResources = null; // 公共资源列表

	private void refreshPublicResources() { // 刷新公共资源, 意味从数据库重新加载公共资源, 用于拦截器
		publicResources = resourceDao.findByType("public");
	}

	public static List<Resource> getPublicResources() {
		return publicResources;
	}

	public static void setPublicResources(List<Resource> publicResources) {
		CoreInterceptor.publicResources = publicResources;
	}

	// 外部更新拦截器持有的公告资源,当公共资源在客户端更新，拦截器持有的公共资源也更新
	public static void updatePublicResources(List<Resource> resources) {
		publicResources = resources;
	}

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handle) throws Exception {
		// TODO Auto-generated method stub

		// 获取session
		HttpSession session = request.getSession();
		// 获取请求地址
		String url = request.getRequestURL().toString();
		// System.out.println("url:" + url);
		String[] actionDo = url.split("/");
		// System.out.println(actionDo[actionDo.length - 1]);
		if ("downloadZip.do".equals(actionDo[actionDo.length - 1])
				|| "deposeMaterial.do".equals(actionDo[actionDo.length - 1])
				|| "getProgress.do".equals(actionDo[actionDo.length - 1])) {
			// System.out.println(99999);
			return true;
		}
		// 请求的是公共资源就放行
		User user = (User) session.getAttribute("user");
		if (publicResources == null)
			refreshPublicResources();
		
		if (user == null) {
			// request.getRequestDispatcher("/login.do").forward(request, response);
			response.sendRedirect("../views/login.jsp");
			return false;
		}
		for (Resource resource : publicResources) {
			// System.out.println("==" + resource.getResourceUrl());
			if (url.contains(resource.getResourceUrl()))
				return true;
			
		}
		// 如果登录的角色是"系统管理员", 即最高权限, 一切放行
		if (Constant.adminRoleName.equals(user.getRole().getRoleName()))
			return true;

		/*
		   //请求的是公共资源就放行
    	if(publicResources == null) refreshPublicResources();
        for(Resource resource : publicResources) {
        	//System.out.println("==" + resource.getResourceUrl());
        	if(url.contains(resource.getResourceUrl())) return true;
        }*/
        
       /* //先验证是否有登录
        User user = (User) session.getAttribute("user");
        if(user == null) {
		   request.getRequestDispatcher("/login.do").forward(request, response);
           //response.sendRedirect("/ITMS/login/reqLogout.do");
	       return false;
        }
        
        
        //如果登录的角色是"系统管理员", 即最高权限, 一切放行
        if(Constant.adminRoleName.equals(user.getRole().getRoleName())) return true;
        
        
        //验证该用户有权限访问对应的url
        List<Resource> userResources = (List<Resource>) session.getAttribute("userResources");
        for(Resource resource : userResources) {
        	if(url.contains(resource.getResourceUrl())) return true;
        }*/

		
		// //没有权限提示
		// if (request.getHeader("x-requested-with") != null &&
		// request.getHeader("x-requested-with").equalsIgnoreCase("XMLHttpRequest")) {
		// //如果是ajax请求响应头会有，x-requested-with
		// request.getRequestDispatcher("/front/noAuthority.do").forward(request,
		// response);//转发到没有权限界面
		// } else {
		// request.getRequestDispatcher("/views/noAuthority.jsp").forward(request,
		// response);//转发到没有权限界面
		// }
		return false;
	}

	@Override
	public void afterCompletion(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, Exception arg3)
			throws Exception {
		// TODO Auto-generated method stub

	}

	@Override
	public void postHandle(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, ModelAndView arg3)
			throws Exception {
		// TODO Auto-generated method stub

	}

}
