<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <%@ include file="/layui/header.jsp"%>
   <title>权限管理列表</title>
   <meta name="renderer" content="webkit">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/layui/css/jquery.treemenu.css" />
  <script src="<%=request.getContextPath()%>/layui/jquery.treemenu.js"></script>
   
</head>
<body>
   <div class="row cl">
	  <label>&nbsp;&nbsp;角色菜单树：</label>
   </div>
   <TABLE border=0 height=600px align=left>
	<TR>
	    <TD width=50px align=left  valign=top></TD>
		<TD width=260px align=left valign=top style="BORDER-RIGHT: #999999 1px dashed">
		   <div>
		      <c:forEach var="role" items="${listAR}">
		         <li><span>${role.rName}</span>
		            <ul>
		               <c:forEach var="item" items="${role.map}">
		                 <li>${item.key}
		                    <ul>
		                       <c:forEach items="${item.value}" var="col">
		                          <li>${col.resourceName}</li>
		                       </c:forEach>
		                    </ul>
		                 </li>
		               </c:forEach>
		            </ul>
		         </li>
		      </c:forEach>
		   </div>
		</TD>
		<TD width=770px align=left  valign=top>
		<div>
		  <select name="roleName" id="roleName" style="width: 140px; height: 35px;">
			<c:forEach items="${listAR}" var = "role" varStatus = "status">
              <option value="${role.rId}">${role.rName}</option>
            </c:forEach>
		  </select>
		</div>
		<div>
		    <form class="layui-form" id="query_form">
				<div class="layui-form-item">
				   <c:forEach items="${listRs}" var = "rs" varStatus = "status">
		              <input id="" type="checkbox" name="" title="${rs.resourceName}" lay-skin="primary">
		           </c:forEach>
				</div>
			</form>
		</div>
		<div>
		    <input type="button" onclick="saveRs()" id="btn-jan" value="保存">
		</div>
		</TD>
	</TR>
	</TABLE>
</body>
</html>