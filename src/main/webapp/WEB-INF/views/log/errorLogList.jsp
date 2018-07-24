<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <%@ include file="/layui/header.jsp"%>
   <title>错误日志列表</title>
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
    		    elem: '#searchRecordDate' //指定元素
    		  });
    		});
    	  
    	  var params = "";
    	  var whereSuffix = "";
    	  
    	  var value;
    	  
    	  value = $("#searchTerminalName").val();
		   if(value != "") {
			   params = params + "terminalName" + ",like,%" + value + "%,";
		   }
		   
		   value = $("#searchMaterialName").val();
		   if(value != "") {
			   params = params + "searchMaterialName" + ",like,%" + value + "%,";
		   }
		   
		   value = $("#searchErrorReason").val();
		   if(value != "") {
			   params = params + "searchErrorReason" + ",like,%" + value + "%,";
		   }
		   
		   value = $("#searchRecordDate").val();
		   if(value != "") {
		     whereSuffix += " AND DATE_FORMAT(recordDate, '%Y-%m-%d') = '" + value + "'";
		   }
    	  
    	  layui.use('table', function(){
    		  var table = layui.table;
    		  table.render({
    		    elem: '#table1'
    		    ,id: 'flagOne'
    		    ,url:'<%=request.getContextPath()%>/logController/searchErrorLog.do'
    		    ,height: 410
    		    //,cellMinWidth: 120
    		    ,limits:[10,25,50,75,100]
    		    ,cols: [[
    		      //{field:'id', width:'1%'}
    		      {field:'terminalName',width:320, event: 'set1', title: '播放端名称', fixed: true, sort: true}
      		      ,{field: 'materialName',width:300, event: 'set2', title: '播放的视频名称', sort: true}
      		      ,{field:'locateIp',width:250, event: 'set3', title: '错误原因', sort: true}
      		      ,{field:'recordDate',width:250, event: 'set4', title: '记录日期', sort: true
      		    	,templet: function(d){
  		    		  var date = new Date(d.recordDate);
  		    		  var Y = date.getFullYear() + '-';
  		    		  var M = (date.getMonth()+1 < 10 ? '0'+(date.getMonth()+1) : date.getMonth()+1) + '-';
  		    		  var D = (date.getDate() < 10 ? '0' + (date.getDate()) : date.getDate()) + ' ';
  		    		  var h = (date.getHours() < 10 ? '0' + date.getHours() : date.getHours()) + ':';
  		    		  var m = (date.getMinutes() <10 ? '0' + date.getMinutes() : date.getMinutes()) + ':';
  		    		  var s = (date.getSeconds() <10 ? '0' + date.getSeconds() : date.getSeconds());
  		    		  return Y+M+D+h+m+s;
  		    	     }
      		      }
      		    ]]
    		    ,page: true
    		    ,where: {"param": params, "whereSuffix": whereSuffix}
    		    ,done: function(res, curr, count){
    		    	  //document.getElementById("table1").remove();
    		      }
    		  });
    		  
    		  table.on('tool(tableEvent)', function(obj){
    			  var tmpdata = obj.data;
    			  var mid = tmpdata.mid;
    			  var md5 = tmpdata.md5;
    			  var filePath = tmpdata.filePath;
    			  var name = filePath.split("/");
    			  var realname = name[name.length - 1];
    			  document.getElementById("videoView").value = realname;
    			  if(obj.event === 'mediaView'){
    				  $.ajax({
    						type:"POST",
    					    url: '<%=request.getContextPath()%>/material/checkMaterial.do',
    					    data: {"mid": mid},
    					    dataType : "json",
    					    success: function(msg){
    					    	var value = msg.toString();
    							if(value=="true"){
    								window.open('<%=request.getContextPath()%>/file/checkVideo.jsp',"_blank","toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes,left=300,top=20, width=800, height=620");
    							}
    					    }
    					});
    			  }else if(obj.event == "md5"){
    				  layer.open({
    					  title: 'MD5'
    					  ,content: md5
    					});
    			  }
    		  });
    		});
      }
      
      function myTrim(x) {
    	    return x.replace(/^\s+|\s+$/gm,'');
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
									style="width: 100px; height: 35px;">
									<input type="tel" id="searchTerminalName" name="searchTerminalName" autocomplete="off"
										style="width: 100px; height: 35px;" placeholder="播放端名称"
										class="layui-input input-text" />
								</div>
							</div>
							
							<div class="layui-inline">
								<label class="layui-form-mid">播放的视频名称：</label>
								<div class="layui-input-inline"
									style="width: 110px; height: 35px;">
									<input type="tel" id="searchMaterialName" name="searchMaterialName" autocomplete="off"
										style="width: 110px; height: 35px;" placeholder="播放的视频名称"
										class="layui-input input-text" />
								</div>
							</div>
							
							<div class="layui-inline">
								<label class="layui-form-mid">错误原因：</label>
								<div class="layui-input-inline"
									style="width: 100px; height: 35px;">
									<input type="tel" id="searchErrorReason" name="searchErrorReason" autocomplete="off"
										style="width: 100px; height: 35px;" placeholder="日志内容"
										class="layui-input input-text" />
								</div>
							</div>
							
							<div class="layui-inline">
			                    <label class="layui-form-mid">记录日期：</label>
			                    <div class="layui-inline" style="">
				                    <input type="text" id="searchRecordDate" name="searchRecordDate" autocomplete="off" style="width: 170px; height: 36px;" class="layui-input fsDate" dateRange="1" placeholder=" - "/>
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
 				<a class="layui-btn layui-btn-sm" lay-event="mediaView" >审核</a>
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