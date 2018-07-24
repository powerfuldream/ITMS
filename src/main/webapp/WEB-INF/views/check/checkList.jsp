<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <%@ include file="/layui/header.jsp"%>
   <title>素材审核列表</title>
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
		  
		  //名称
		   var materialName = $("#materialName").val();
		   
		   //类型
		   var fileType = $("#fileType").val();
		   
		   //状态
		   var statusId = $("#statusId").val();
    	  
    	  layui.use('table', function(){
    		  var table = layui.table;
    		  table.render({
    		    elem: '#table1'
    		    ,id: 'flagOne'
    		    ,url:'<%=request.getContextPath()%>/material/searchCheckFile.do'
    		    ,height: 550
    		    //,cellMinWidth: 120
    		    ,limits:[10,25,50,75,100]
    		    ,cols: [[
    		      //{field:'id', width:'1%'}
    		      {field:'materialName',width:320, event: 'set1', title: '素材名', fixed: true, sort: true}
    		      ,{field:'terminalName',width:120, event: 'set2', title: '终端名'
    		    	  ,templet: function(d){
    		    		  var name = d.terminal;
    		    		  var tis = d.tis;
    		    		  if(tis == '0'){
    		    			  return '<span style="color: #FF6347;">' + '未选择' + '</span>';
    		    		  }else{
    		    			  return '<span style="color: #1E9FFF;">' + name.terminalName + '</span>';
    		    		  }
    		    	  }
    		      }
      		      ,{field:'resolution',width:120, event: 'set3', title: '分辨率'}
      		      ,{field:'size',width:120, event: 'set4', title: '大小', sort: true}
      		      ,{field:'duration',width:120, event: 'set5', title: '时长(秒)', sort: true}
      		      ,{field:'statusId',width:120, event: 'set6', title: '审核状态', sort: true
      		    	  ,templet: function(d){
      		    		  var state = d.statusId;
      		    		  if(state == 1){
      		    			  return "未审核";
      		    		  }else if(state == 2){
      		    			  return "已初审";
      		    		  }else if(state == 3){
      		    			  return "已通过";
      		    		  }else if(state == 4){
      		    			  return "未通过";
      		    		  }
      		    	  }
      		      }
      		      ,{field:'uploadName',width:120, event: 'set7', title: '上传人', sort: true}
      		      ,{fixed: 'right', width:100, event: 'set8', title: '操作', align:'center', toolbar: '#barDemo'}
      		    ]]
    		    ,page: true
    		    ,where: {"materialName": materialName, "fileType":fileType, "statusId":statusId}
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
								<label class="layui-form-mid">素材名：</label>
								<div class="layui-input-inline"
									style="width: 160px; height: 35px;">
									<input type="tel" id="materialName" name="materialName" autocomplete="off"
										style="width: 160px; height: 35px;" placeholder="素材名"
										class="layui-input input-text" />
								</div>
							</div>
							
							<div class="layui-inline">
								<label class="layui-form-mid">类型：</label>
								<div class="layui-input-inline"
									style="width: 150px; height: 35px;">
									<select id="fileType" name="fileType" style="width: 150px; height: 35px;">
										<option value="">请选择</option>
										<option value="vedio">视频</option>
										<option value="picture">图片</option>
										<option value="other">其他</option>
									</select>
								</div>
							</div>
							
							<div class="layui-inline">
								<label class="layui-form-mid">状态：</label>
								<div class="layui-input-inline"
									style="width: 150px; height: 35px;">
									<select id="statusId" name="statusId" style="width: 150px; height: 35px;">
										<option value="1" selected>未审核</option>
										<option value="4">未通过</option>
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