<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
   <link href="<%=request.getContextPath()%>/assets/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
      <link href="<%=request.getContextPath()%>/layui/css/layui.css" rel="stylesheet">
   <script type="text/javascript" src="<%=request.getContextPath()%>/layui/layui.js"></script>
</head>
<body>
			<table class="layui-table" lay-skin="line">
				<thead>
					<tr>
						<th></th>
						<th>时段名</th>
						<th>开始时间</th>
						<th>结束时间</th>
						<th>备注</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${periodOnce}" var="period" varStatus="status">
						<tr>
							<%-- <td><input type="checkbox"
								value="${period.periodName},${period.periodId}"
								name="periodCheck" /></td> --%>
							<td>
						    <input type="checkbox" name="periodCheck" value="${period.periodName},${period.periodId}" lay-skin="primary">
						    </td>
							<td>${period.periodName}</td>
							<td>${period.startInterval}</td>
							<td>${period.endInterval}</td>
							<td>${period.mark}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
</body>
</html>