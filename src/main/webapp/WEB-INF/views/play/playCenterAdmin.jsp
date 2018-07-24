<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <%@ include file="/layui/header.jsp"%>
   <title>终端连接列表</title>
   <meta name="renderer" content="webkit">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
   <%-- <script src="<%=request.getContextPath()%>/layui/jquery-1.8.2.min.js"></script> --%>
   <script type="text/javascript" defer="defer">
   $(function(){
	   init();
   });
   
      function init(){
    	  layui.use('laydate', function(){
    		  var laydate = layui.laydate;
    		  
    		  //执行一个laydate实例
    		  laydate.render({
    		    elem: '#month' //指定元素
    		  });
    		});
    	  
    	  var params = [];
		  var key, symbol, value;
		  var searchAreaCode = "86";
		  
		   //名称
		   var terminalName = $("#searchTerminalName").val();
		   value = $("#searchTerminalName").val();
		   if(value != "") {
		      key = "terminalName";
		      symbol = "like"
		      value = "%" + value + "%";
		      params.push(key);  params.push(symbol); params.push(value);
		   }
		   		   
/* 		 //区域
		   value = $("#searchAreaName").val();
		   if(value != "") {
		      key = "areaName";
		      symbol = "like"
		      value = "%" + value + "%";
		      params.push(key);  params.push(symbol); params.push(value);
		   } */
		   
		   
		   //IP地址
		   var ip = $("#searchIp").val();
		   value = $("#searchIp").val();
		   if(value != "") {
		      key = "ip";
		      symbol = "like"
		      value = "%" + value + "%";
		      params.push(key);  params.push(symbol); params.push(value);
		   }
		   
		   
		   //状态
		   var state = $("#searchStateSelect").val();
		   value = $("#searchStateSelect").val();
		   if(value != "") {
		      key = "state";
		      symbol = "="
		      params.push(key);  params.push(symbol); params.push(value);
		   }
    	  
    	  layui.use('table', function(){
    		  var table = layui.table;
    		  table.render({
    		    elem: '#table1'
    		    ,id: 'flagOne'
    		    ,url:'<%=request.getContextPath()%>/terminal/comon/searchTerminal/' + searchAreaCode + '.do'
    		    ,height: 420
    		    //,cellMinWidth: 120
    		    ,limits:[25,50,75,100]
    		    ,limit:25
    		    ,cols: [[
    		      //{field:'id', width:'1%'}
    		      {field:'deleted', width:100, event: 'set1', title: '状态', fixed: 'left'
    		    	  ,templet: function(d){
    		    		  if(d.deleted == 0){
    		    			  return '<span style="color: #FF6347;">' + '离线' + '</span>';
    		    		  }else if(d.deleted == 1){
    		    			  return '<span style="color: #90EE90;">' + '在线' + '</span>';
    		    		  }
    		    		}
    		       }
    		      ,{field:'terminalName',width:130, event: 'set2', title: '播放端名称'}
    		      ,{field:'serialNumber',width:130, event: 'set14', title: '序列号码'}
    		      ,{field:'ip',width:130, event: 'set3', title: 'IP地址'}
    		      ,{field:'resolutionLength',width:130, event: 'set4', title: '电脑分辨率-宽'}
    		      ,{field:'resolutionWidth',width:130, event: 'set5', title: '电脑分辨率-高'}
    		      ,{field:'ledLength',width:100, event: 'set6', title: 'LED-宽'}
    		      ,{field:'ledWidth',width:100, event: 'set7', title: 'LED-高'}
    		      ,{field:'startSpotTop',width:130, event: 'set8', title: 'LED起点-Top'}
    		      ,{field:'startSpotLeft',width:130, event: 'set9', title: 'LED起点-Left'}
    		      ,{field:'runStartTime',width:130, event: 'set10', title: '运行开始时间'}
    		      ,{field:'runEndTime',width:130, event: 'set11', title: '运行结束时间'}
    		      ,{field:'state',width:100, event: 'set12', title: '启用状态'}
    		      ,{fixed: 'right', width:180, event: 'set13', title: '操作', align:'center', toolbar: '#barDemo'}
    		    ]]
    		    ,page: true
    		    ,where: {"terminalName": terminalName, "ip":ip, "state":state}
    		    ,done: function(res, curr, count){
    		    	  //document.getElementById("table1").remove();
    		          changeBg();
    		      }
    		  });
    		  
    		  table.on('tool(tableEvent)', function(obj){
    			  var tmpdata = obj.data;
    			  var terminalId = tmpdata.terminalId;
    			  if(obj.event === 'restartTerminal'){
    			      layer.confirm('真的重启终端运行么', function(index){
    			         //obj.del();
    			         layer.close(index);
    			         //重启终端运行
    			         $.ajax({
    							type: "POST",
    							url: "<%=request.getContextPath()%>/playerController/restartTerminal.do",
    							data:{"terminalId":terminalId},
    							dataType: "json",
    							success: function(msg){
    								var value = msg.toString();
    								if(value == "true"){
    									layer.msg('10秒内将重启终端运行!',{icon:6,time:4000});
    								}else if(value == "false"){
    									layer.msg('终端未连接运行!',{icon:5,time:4000});
    								}
    							}
    						});
    			      });
    			  }else if(obj.event == "stopTerminal"){
    				  layer.confirm('真的要终止终端运行么', function(index){
     			         //obj.del();
     			         layer.close(index);
     			         //终止终端运行
     			        $.ajax({
     						type: "POST",
     						url: "<%=request.getContextPath()%>/playerController/stopTerminal.do",
     						data:{"terminalId":terminalId},
     						dataType: "json",
     						success: function(msg){
     							var value = msg.toString();
     							if(value == "true"){
     								layer.msg('10秒内将停止终端运行!',{icon:6,time:1500});
     							}else if(value == "false"){
     								layer.msg('终端未连接运行!',{icon:5,time:1500});
     							}
     						}
     					});
     			      });
    			  }
    		  });
    		});
      }
      
      function myTrim(x) {
    	    return x.replace(/^\s+|\s+$/gm,'');
    	}
      
      function changeBg(){
    	  var trId = document.getElementsByTagName("tr");
    	  //alert(trId.length);
    	  //alert(trId[0].cells.length);
    	  for(var i = 1; i < trId.length; i++){
    		  var value = trId[i].cells[0].innerText;
    		  var value1 = trId[i].cells[11].innerText;  //"激活" trId[i].cells[11].innerText
    		  if(value1.trim() == "激活"){
    			  if(value.trim() == "在线"){
    				  trId[i].className += " jan-green-theme";
        			  //trId[i].style.backgroundColor = "#90EE90";  //#5FB878
        		  }else if(value.trim() == "离线"){
        			  trId[i].className += " jan-yellow-theme";
        			  //trId[i].style.backgroundColor = "#FFD133";  //#FFB800
        		  }else if(value.trim() == "状态"){
        			  break;
        		  }
    		  }else if(value1.trim() == "禁用"){
    			  trId[i].className += " jan-red-theme";
    			  //trId[i].style.backgroundColor = "#FF6347";
    		  }
    	  }
      }
      
   </script>
   
</head>
<body>
	<div class="layui-fluid">
		<div class="layui-row layui-col-space1">
			<div class="layui-col-md12">
				<div class="layui-form-query">
					<form class="layui-form" id="query_form">
						<div class="layui-form-item">
							<div class="layui-inline">
								<label class="layui-form-mid">名称：</label>
								<div class="layui-input-inline"
									style="width: 120px; height: 35px;">
									<input type="tel" id="searchTerminalName" name="searchTerminalName" autocomplete="off"
										style="width: 120px; height: 35px;" placeholder="名称"
										class="layui-input input-text" />
								</div>
							</div>
							<div class="layui-inline">
								<label class="layui-form-mid">IP地址：</label>
								<div class="layui-input-inline"
									style="width: 120px; height: 35px;">
									<input type="text" id="searchIp" name="searchIp" autocomplete="off"
										style="width: 120px; height: 35px;" placeholder="ip地址"
										class="layui-input input-text" />
								</div>
							</div>
							<div class="layui-inline">
								<label class="layui-form-mid">区域：</label>
								<div class="layui-input-inline"
									style="width: 120px; height: 35px;">
									<input type="text" id="searchAreaName" name="searchAreaName" autocomplete="off"
										style="width: 120px; height: 35px;" placeholder="区域"
										class="layui-input input-text" />
								</div>
							</div>
							<div class="layui-inline">
								<label class="layui-form-mid">状态：</label>
								<div class="layui-input-inline"
									style="width: 150px; height: 35px;">
									<select id="searchStateSelect" name="searchStateSelect" style="width: 150px; height: 35px;">
										<option value="">--请选择--</option>
										<option value="激活">激活</option>
										<option value="禁用">禁用</option>
									</select>
								</div>
							</div>
							<div class="layui-inline">
								<div class="layui-input-inline">
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
 				<a class="layui-btn layui-btn-xs" lay-event="restartTerminal" >重启终端</a>
  				<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="stopTerminal" >终止运行</a>
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