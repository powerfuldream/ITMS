<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <%@ include file="/layui/header.jsp"%>
   <title>播表列表</title>
   <meta name="renderer" content="webkit">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
   <%-- <script src="<%=request.getContextPath()%>/layui/jquery-1.8.2.min.js"></script> --%>
   <script type="text/javascript" defer="defer">
   $(function(){
	   init();
   });
   
      function init(){
    	  layui.use('layer', function(){
    		  var layer = layui.layer;
    		});
    	  layui.use('laydate', function(){
    		  var laydate = layui.laydate;
    		  
    		  laydate.render({
      		    elem: '#startTime' //指定元素
      		  });
    		  //执行一个laydate实例
    		  laydate.render({
    		    elem: '#endTime' //指定元素
    		  });
    		});
		  
		  //名称
		  var terminalId = $("#terminal").val();
		  
		  //日期
		  var startTime = $("#startTime").val();
		  var endTime = $("#endTime").val();
		   		   
		   //状态
		   var statusId = $("#statusId").val();
    	  
    	  layui.use('table', function(){
    		  var table = layui.table;
    		  table.render({
    		    elem: '#table1'
    		    ,id: 'flagOne'
    		    ,url:'<%=request.getContextPath()%>/ptable/searchPtable.do'
    		    ,height: 550
    		    //,cellMinWidth: 120
    		    ,limits:[10,25,50,75,100]
    		    ,cols: [[
    		      //{field:'id', width:'1%'}
    		      {field:'ptableName',width:250, event: 'set1', title: '播表名', fixed: true, sort: true}
      		      ,{field:'playDate',width:110, event: 'set2', title: '播放日期', sort: true
      		    	,templet: function(d){
    		    		  var date = new Date(d.playDate);
    		    		  var Y = date.getFullYear() + '-';
    		    		  var M = (date.getMonth()+1 < 10 ? '0'+(date.getMonth()+1) : date.getMonth()+1) + '-';
    		    		  var D = (date.getDate() < 10 ? '0' + (date.getDate()) : date.getDate()) + ' ';    		   		 
    		    		  return Y+M+D;
    		    	  } 
      		      }
      		      //,{field:'periodName',width:130, event: 'set4', title: '时段名', sort: true}
      		      ,{field:'periodTime',width:260, event: 'set3', title: '时段范围', sort: true
      		    	,templet: function(d){
      		    		var periodName = d.periodName;
      		    		var periodTime = d.periodTime;
      		    		return periodName + " " + periodTime;
      		    	}
      		      }
      		      ,{field:'insertFlag',width:100, event: 'set4', title: '播表类型', sort: true
      		    	,templet: function(d){
      		    		var flag = d.insertFlag;
      		    		if(flag == '0'){
      		    			return '<span style="color: #90EE90;">周期轮播</span>';
      		    		}else if(flag == '1'){
      		    			return '<span style="color: #FF6347;">插播</span>';
      		    		}
      		    	}
      		      }
      		      ,{field:'statusId',width:100, event: 'set5', title: '审核状态', sort: true
      		    	  ,templet: function(d){
      		    		  var state = d.statusId;
      		    		if(state == 1){
  		    			  return '<span style="color: #FF6347;">' + '未审核' + '</span>';
  		    		  }else if(state == 2){
  		    			  return '<span style="color: #90EE90;">' + '已初审' + '</span>';
  		    		  }else if(state == 3){
  		    			  return '<span style="color: #90EE90;">' + '已通过' + '</span>';
  		    		  }else if(state == 4){
  		    			  return '<span style="color: #FF6347;">' + '未通过' + '</span>';
  		    		  }else if(state == 5){
  		    			  return '<span style="color: #FF6347;">' + '未通过(排播有误)' + '</span>';
  		    		  }else if(state == 6){
  		    			  return '<span style="color: #FF6347;">' + '未通过(素材敏感)' + '</span>';
  		    		  }else if(state == 7){
  		    			  return '<span style="color: #FF6347;">' + '未通过(排播有误、素材敏感)' + '</span>';
  		    		  }
      		    	  }
      		      }
      		      ,{field:'playTotalTime',width:120, event: 'set6', title: '播表时长', sort: true}
      		      ,{field:'allTime',width:120, event: 'set7', title: '可播时长'}
      		      ,{field:'screenRate',width:100, event: 'set8', title: '占屏比', sort: true}
      		      ,{field:'terminalName',width:120, event: 'set9', title: '终端名', sort: true
      		    	  ,templet:function(d){
      		    		return '<span style="color: #1E9FFF;">' + d.terminalName + '</span>';
      		    	  }
      		      }
      		      ,{field:'createName',width:120, event: 'set10', title: '创建人', sort: true}
      		      ,{field:'createTime',width:180, event: 'set11', title: '创建时间', sort: true
      		    	,templet: function(d){
  		    		  var date = new Date(d.createTime);
  		    		  var Y = date.getFullYear() + '-';
  		    		  var M = (date.getMonth()+1 < 10 ? '0'+(date.getMonth()+1) : date.getMonth()+1) + '-';
  		    		  var D = (date.getDate() < 10 ? '0' + (date.getDate()) : date.getDate()) + ' ';
  		    		  var h = (date.getHours() < 10 ? '0' + date.getHours() : date.getHours()) + ':';
  		    		  var m = (date.getMinutes() <10 ? '0' + date.getMinutes() : date.getMinutes()) + ':';
  		    		  var s = (date.getSeconds() <10 ? '0' + date.getSeconds() : date.getSeconds());
  		    		  return Y+M+D+h+m+s;
  		    	  }
      		      }
      		      ,{fixed: 'right', width:130, event: 'set12', title: '操作', align:'center', toolbar: '#barDemo'}
      		    ]]
    		    ,page: true
    		    ,where: {"terminalId": terminalId, "statusId":statusId, "startDate":startTime, "endDate":endTime}
    		    ,done: function(res, curr, count){
    		    	  //document.getElementById("table1").remove();
    		    	  if(res.fail == 1){
    		    	      layer.msg(res.msg,{icon:5,time:2000});
    		    	  }
    		    	  //console.log(res.msg);
    		      }
    		  });
    		  
    		  table.on('tool(tableEvent)', function(obj){
    			  var tmpdata = obj.data;
    			  var pid = tmpdata.pid;
    			  if(obj.event === 'resetPtable'){
    				  layer.confirm('真的重置该播表么', function(index){
    					  layer.close(index);
    					  $.ajax({
								type: "POST",
								url: "<%=request.getContextPath()%>/ptable/resetPLayTableState.do",
								data: {"pid":pid},
								traditional: true,
								dataType : "json",
								success : function(msg){
									var value = msg.toString();
									if(value=="true"){
										init();
										layer.msg('重置成功!',{icon:6,time:4000});
									}
								}
							});
    			       });
    			  }
    		  });
    		});
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
								<label class="layui-form-mid">终端：</label>
								<div class="layui-input-inline"
									style="width: 140px; height: 35px;">
									<select name="terminal" id="terminal" lay-verify="required" lay-search="" style="width: 140px; height: 35px;">
										<option value="">直接选择或搜索</option>
										<c:forEach items="${terminalPtable}" var = "terminal" varStatus = "status">
                                        <option value="${terminal.terminalId}">${terminal.terminalName}</option>
                                        </c:forEach>
									</select>
								</div>
							</div>
							
							<div class="layui-inline">
			                    <label class="layui-form-mid">播放日期范围：</label>
			                    <div class="layui-inline" style="">
				                    <input type="text" id="startTime" name="startTime" autocomplete="off" style="width: 100px; height: 36px;" class="layui-input fsDate" dateRange="1" />
			                    </div>
		                    </div>
		                    
		                    <div class="layui-inline">
			                    <div class="layui-inline" style="">
			                    <label class="layui-form-mid">-&nbsp;&nbsp;&nbsp;</label>
				                   <input type="text" id="endTime" name="endTime" autocomplete="off" style="width: 100px; height: 36px;" class="layui-input fsDate" dateRange="1" />
			                    </div>
		                    </div>
							
							<div class="layui-inline">
								<label class="layui-form-mid">状态：</label>
								<div class="layui-input-inline"
									style="width: 150px; height: 35px;">
									<select id="statusId" name="statusId" style="width: 150px; height: 35px;">
										<option value="">-请选择-</option>
										<option value="1">未审核</option>
										<option value="4">未通过</option>
										<option value="2">已初审</option>
										<option value="3">通过</option>
									</select>
								</div>
							</div>
							
							<div class="layui-inline">
								<div class="layui-inline">
									<button class="layui-btn" type="button" onclick="init()">
										<i class="layui-icon">&#xe615;</i>查询
									</button>
								</div>
							</div>
						</div>
					</form>
				</div>
			</div>
			
		 <div class="layui-col-md12">
            <table class="layui-table" id="table1" lay-filter="tableEvent"></table>
			<!-- <a class="layui-btn layui-btn-primary layui-btn-xs" lay-event="top" topUrl="views/datagrid2/one.html" topMode="readonly" topWidth="800px" topHeight="600px" topTitle="查看demo" inputs="id:">查看</a> -->
			<script type="text/html" id="barDemo">
 				<a class="layui-btn layui-btn-sm" lay-event="resetPtable">
                <i class="layui-icon">&#xe620;</i>播表重置</a>
			</script>
			<script type="text/html" id="barDemo1">
 				<a class="layui-btn layui-btn-sm layui-btn-danger" lay-event="md5" >MD5</a>
			</script>
	      </div>
			
		</div>
	</div>

	<script type="text/javascript">
	layui.use('form', function(){
		  var form = layui.form;
		});
	</script>
</body>
</html>