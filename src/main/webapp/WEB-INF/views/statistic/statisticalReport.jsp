<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <%@ include file="/layui/header.jsp"%>
   <title>统计报表</title>
   <meta name="renderer" content="webkit">
   <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
   <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
   <script type="text/javascript" defer="defer">
   $(function(){
	    //昨天的时间
		var day1 = new Date();
		day1.setTime(day1.getTime()-24*60*60*1000);
		var s1 = day1.getFullYear()+"-" + (day1.getMonth()+1) + "-" + day1.getDate();
		
		//今天的时间
		var day2 = new Date();
		day2.setTime(day2.getTime());
		var s2 = day2.getFullYear()+"-" + (day2.getMonth()+1) + "-" + day2.getDate();
		
		var timeStr = s1 + " 23:00:00 - " + s2 + " 00:00:00";
		$("#statisTime").val(timeStr);
		search();
   });
   
  
   
    function search() {
      var statisType = $("#statisType").val();
      if(statisType == "1") {
        searchPlayDetail();
      } else if(statisType == "2") {
        searchPlayNum();
      }
      
    }
   
   
    function searchPlayNum(){
    	  
    	  layui.use('table', function(){
    		  var table = layui.table;
    		  table.render({
    		    elem: '#table1'
    		    ,id: 'flagTwo'
    		    ,url:'<%=request.getContextPath()%>/statistic/searchPlayNum.do'
    		    ,height: 500
    		    //,cellMinWidth: 120
    		    ,limits:[10,25,50,75,100]
    		    ,cols: [[
    		       {field:'materialName',width:350, event: 'set1', title: '素材名称', fixed: true, sort: true}
      		      ,{field: 'playNum',width:200, event: 'set2', title: '总播放次数', sort: true}
      		      ,{field:'startPlayTime',width:200, event: 'set3', title: '开始播放时间', sort: true}
      		      ,{field:'endPlayTime',width:200, event: 'set4', title: '结束播放时间', sort: true}
      		     
      		    ]]
    		    ,page: true
    		    ,where: {"terminalId": $("#terminal").val(), "dateTime": $("#statisTime").val()}
    		    ,done: function(res, curr, count){	
    		      }
    		  });
    		  
    		});
      }
   
   
   
   
   
   
      function searchPlayDetail(){

    	  
    	  layui.use('table', function(){
    		  var table = layui.table;
    		  table.render({
    		    elem: '#table1'
    		    ,id: 'flagOne'
    		    ,url:'<%=request.getContextPath()%>/statistic/searchPlayDetail.do'
    		    ,height: 500
    		    //,cellMinWidth: 120
    		    ,limits:[10,25,50,75,100]
    		    ,cols: [[
    		      //{field:'id', width:'1%'}
    		       {field:'terminalName',width:350, event: 'set1', title: '播放端名称', fixed: true, sort: true}
      		      ,{field:'materialName',width:350, event: 'set2', title: '播放的视频名称', sort: true}
      		      ,{field:'playStartTime',width:210, event: 'set3', title: '开始播放时间', sort: true
      		    	,templet: function(d){
  		    		  var date = new Date(d.playStartTime);
  		    		  var Y = date.getFullYear() + '-';
  		    		  var M = (date.getMonth()+1 < 10 ? '0'+(date.getMonth()+1) : date.getMonth()+1) + '-';
  		    		  var D = (date.getDate() < 10 ? '0' + (date.getDate()) : date.getDate()) + ' ';
  		    		  var h = (date.getHours() < 10 ? '0' + date.getHours() : date.getHours()) + ':';
  		    		  var m = (date.getMinutes() <10 ? '0' + date.getMinutes() : date.getMinutes()) + ':';
  		    		  var s = (date.getSeconds() <10 ? '0' + date.getSeconds() : date.getSeconds());
  		    		  return Y+M+D+h+m+s;
  		    	    }
      		      }
      		      ,{field:'playEndTime',width:210, event: 'set4', title: '结束播放时间', sort: true
      		    	,templet: function(d){
  		    		  var date = new Date(d.playEndTime);
  		    		  var Y = date.getFullYear() + '-';
  		    		  var M = (date.getMonth()+1 < 10 ? '0'+(date.getMonth()+1) : date.getMonth()+1) + '-';
  		    		  var D = (date.getDate() < 10 ? '0' + (date.getDate()) : date.getDate()) + ' ';
  		    		  var h = (date.getHours() < 10 ? '0' + date.getHours() : date.getHours()) + ':';
  		    		  var m = (date.getMinutes() <10 ? '0' + date.getMinutes() : date.getMinutes()) + ':';
  		    		  var s = (date.getSeconds() <10 ? '0' + date.getSeconds() : date.getSeconds());
  		    		  return Y+M+D+h+m+s;
  		    	    }
      		      }
      		      ,{field: 'pname',width:350, event: 'set5', title: '所属播表', sort: true}
      		    ]]
    		    ,page: true
    		    ,where: {"terminalId": $("#terminal").val(), "dateTime": $("#statisTime").val()}
    		    ,done: function(res, curr, count){
    		    	 
    		     }
    		  });
    		  
    		});
      }
      
      
      function generateExcel() {
          	  var url = '<%=request.getContextPath()%>/statistic/generateExcel.do?terminalId=' + $("#terminal").val() + '&dateTime=' + $("#statisTime").val() +'&type=' + $("#statisType").val();
			  var xhr = new XMLHttpRequest(); 
			  xhr.open('GET', url, true);    // 也可以使用POST方式，根据接口
			  xhr.responseType = "blob";  // 返回类型blob
			  // 定义请求完成的处理函数，请求前也可以增加加载框/禁用下载按钮逻辑
			  xhr.onload = function () {
			    // 请求完成
			    if (this.status === 200) {
			      // 返回200
			      var blob = this.response;
			      var reader = new FileReader();
			      reader.readAsDataURL(blob);  // 转换为base64，可以直接放入a表情href
			      reader.onload = function (e) {
			        // 转换完成，创建一个a标签用于下载
			        var a = document.createElement('a');
			        a.download = 'data.xls';
			        a.href = e.target.result;
			        $("body").append(a);  // 修复firefox中无法触发click
			        a.click();
			        $(a).remove();
			      }
			    }
			  };
			  // 发送ajax请求
			  xhr.send()
      }
      
      
   </script>
   
</head>
<body>
	<input type="hidden" id="videoView" value="">
	<div class="layui-fluid">
		<div class="layui-row layui-col-space1">
			<div class="layui-col-md12">
				<div class="layui-form-query">
					<form class="layui-form" id="query_form">
						<div class="layui-form-item">
						
							<div class="layui-inline">
								<label class="layui-form-mid">播放端名称：</label>
								<div class="layui-input-inline"
									style="width: 150px; height: 35px;">
									<select name="terminal" id="terminal" lay-verify="required" lay-search="" style="width: 140px; height: 35px;">
										
										<c:forEach items="${terminalPtable}" var = "terminal" varStatus = "status">
                                          <option value="${terminal.terminalId}">${terminal.terminalName}</option>
                                        </c:forEach>
									</select>
								</div>
							</div>
							
							
				
							
							<div class="layui-inline">
								<label class="layui-form-mid">统计类型：</label>
								<div class="layui-input-inline" style="width: 140px; height: 35px;">
									<select id="statisType">
			                          <option value="1">播放日志详细表</option>
			                          <option value="2">播放次数统计表</option>
			                        </select>
								</div>
							</div>
							
							
							
							<div class="layui-inline">
						      <label class="layui-form-label">统计时间：</label>
						      <div class="layui-input-inline"  style="width: 300px; height: 35px;">
						        <input type="text" class="layui-input" id="statisTime" placeholder=" - ">
						      </div>
						    </div>
							
							<div class="layui-inline">
								<div class="layui-inline">
									<button class="layui-btn" type="button" onclick="search()">
										<i class="layui-icon">&#xe615;</i>查询
									</button>
								</div>
							</div>
						</div>
					</form>
				</div>
			</div>
	
	
	
	
	
			<div class="layui-col-md12">
		  	 	<div class="layui-row grid-demo">
			        <div class="layui-btn-container">
			        	<button class="layui-btn operatorTable" onclick="generateExcel()">
					      <i class="layui-icon">&#xe642;</i>导出为EXCEL
					    </button>
			
				      </div>
					
					 <div class="layui-col-md12">
			            <table class="layui-table" id="table1" lay-filter="tableEvent"></table>
				     </div>
				</div>
			</div>
	
			
		</div>
	</div>

	<script type="text/javascript">
	layui.use(['form', 'laydate'], function(){
		  var form = layui.form;
		  var laydate = layui.laydate;
		  //时间选择器
		  laydate.render({
		    elem: '#statisTime'
		    ,type: 'datetime'
		    ,range: true
		  });
		  
		});
	</script>

	
</body>
</html>