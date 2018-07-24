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
<script type="text/javascript" src="<%=request.getContextPath()%>/highCharts/highcharts.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/highCharts/highcharts-3d.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/highCharts/exporting.js"></script>
</head>
<body>

		<div id="periodTable" class="layui-upload-list" >
					<table class="layui-table" lay-skin="line">
						<thead>
							<tr>
								<th>时段名</th>
								<th>开始时间</th>
								<th>结束时间</th>
								<th>状态</th>
								<th>操作</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${periodTwice}" var="period" varStatus="status">
								<tr>
									<td>${period.periodName}</td>
									<td>${period.startInterval}</td>
									<td>${period.endInterval}</td>
									<td>
									<span style="color: #5FB878;">
									<label id='p${period.periodId}'>
									<c:choose>
									<c:when test="${period.status == 0}">等待生成播表
                             </c:when>
                             <c:otherwise> 已生成播表
                             </c:otherwise>
                          </c:choose>
									</label>
									</span>
									</td>
									<td>
									<c:choose>
									<c:when test="${period.status == 0}">
									<input id='b${period.periodId}' type="button" class="layui-btn" onclick="generateTable('${period.periodId}')" style="margin: 2px;" value="生成播表" />	
                             </c:when>
                             <c:otherwise>
									<input id='b${period.periodId}' type="button" class="layui-btn" onclick="generateTable('${period.periodId}')" style="margin: 2px;" value="重新生成"/>	
                             </c:otherwise>
                          </c:choose>
                          <%-- <input id='bp${period.periodId}' type="button" class="layui-btn" onclick="periodForcast('${period.periodId}')" style="margin: 5px;" value="播表预测" disabled/>	 --%>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
		</div>
	<script type="text/javascript">
/* 		function queryPeriod() {
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
					url : "/ITMS/period/periodTable.do",
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
	} */

	layui.use('layer', function(){
		  var layer = layui.layer;
		});
	
		function selectPeriod() {
			obj = document.getElementsByName("periodCheck");
			serialData = [];
			for (k in obj) {
				if (obj[k].checked) {
					serialData.push(obj[k].value);
				}
			}
			var index = parent.layer.getFrameIndex(window.name);
			if (serialData.length == 1) {
				parent.$('#assoSerial').val(serialData);
				parent.layer.closeAll();
			} else {
				layer.msg('请至少选择一个文件!!', {
					icon : 7,
					time : 3000
				});
			}
		}

/* 		function goBack() {
			parent.layer.closeAll();
		} */
	</script>

</body>
</html>