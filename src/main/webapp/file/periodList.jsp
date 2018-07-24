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
<%-- <%@ include file="/layui/header.jsp"%> --%>
<title>Insert title here</title>
   <link href="<%=request.getContextPath()%>/layui/css/bootstrap.min.css" rel="stylesheet">
   <script type="text/javascript" src="<%=request.getContextPath()%>/layui/layui.js"></script>
   <link href="<%=request.getContextPath()%>/layui/css/layui.css" rel="stylesheet">
   <script type="text/javascript" src="<%=request.getContextPath()%>/layui/jquery-1.8.2.min.js"></script>
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
  <legend>时段列表</legend>
</fieldset>
	<div align="center">
	   <!--  
		<div>
			<div class="layui-inline">
				<label>查询条件:</label>&nbsp;&nbsp;&nbsp;&nbsp;
				<div class="layui-input-inline">
					<input type="text" id="selectPeriodName" name="selectPeriodName"
						placeholder=" 时段名" class="layui-input">
				</div>
				<button name="" id="" class="btn btn-success" type="button"
					onclick="queryPeriod()">
					<i class="layui-icon">&#xe615;</i> 查询
				</button>
			</div>
		</div>
        -->
        
		<div id="periodTable" style="width: 90%;" align="center">
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
		</div>
		<button type="button" class="layui-btn" id="selectPeriod"
			onclick="selectPeriod()">确定</button>
		<button type="button" class="layui-btn" style="margin: 5px;"
			onclick="goBack()">关闭</button>
	</div>
	<script type="text/javascript">
		function queryPeriod() {
			layui.use('layer', function(){
				  var layer = layui.layer;
			var periodName = document.getElementById("selectPeriodName").value;
			if (periodName == "") {
				layer.msg('未输入参数!!', {
					icon : 7,
					time : 3000
				});
			} 
				layer.msg(periodName);
				$.ajax({
					type : "POST",
					url : "<%=request.getContextPath()%>/period/periodTable.do",
					data : {
						"periodName" : periodName
					},
					dataType : "html",
					success : function(dmsg) {
						layer.msg('查询成功!', {
							icon : 6,
							time : 2000
						});
						$("#periodTable").html(dmsg);
					}
				});
		});
	}

		function selectPeriod() {
			obj = document.getElementsByName("periodCheck");
			var serialData = [];
			for (k in obj) {
				if (obj[k].checked) {
					serialData.push(obj[k].value);
				}
			}
			var index = parent.layer.getFrameIndex(window.name);
			if (serialData.length == 1) {
				var idName = serialData[0].split(",");
				parent.$('#periodName').val(idName[0]);
				parent.$("#ppid").val(idName[1]);
				parent.layer.closeAll();
			} else {
				layer.msg('请至少选择一个时段!!', {
					icon : 7,
					time : 3000
				});
			}
		}

		function goBack() {
			parent.layer.closeAll();
		}
	</script>

</body>
</html>