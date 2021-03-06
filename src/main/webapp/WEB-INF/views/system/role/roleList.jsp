<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <%@ include file="/layui/header.jsp"%>
   <title>角色管理列表</title>
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
    	  
    	  layui.use('table', function(){
    		  var table = layui.table;
    		  table.render({
    		    elem: '#table1'
    		    ,id: 'flagOne'
    		    ,url:'<%=request.getContextPath()%>/system/role/findAllRole.do'
    		    ,height: 410
    		    //,cellMinWidth: 120
    		    ,limits:[10,25,50,75,100]
    		    ,cols: [[
    		      //{field:'id', width:'1%'}
    		      {checkbox: true, event: 'set1', fixed: true}
    		      ,{field:'roleName',width:350, event: 'set2', title: '角色名称', fixed: true, sort: true}
      		      ,{field: 'roleDescribe',width:400, event: 'set3', title: '角色描述', sort: true}
      		      ,{field:'createDate',width:350, event: 'set4', title: '创建时间', sort: true
      		    	,templet: function(d){
    		    		  var date = new Date(d.createDate);
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
    		    ,done: function(res, curr, count){
    		    	  //document.getElementById("table1").remove();
    		      }
    		  });
    		  
    		  
    		  var active = {
    				  getDeleteData: function(){ //获取选中数据
    				      var checkStatus = table.checkStatus('flagOne')
    				      ,data = checkStatus.data;
    				      var pids = [];
    				      for(var i = 0; i < data.length; i++){
    					      pids.push(data[i].roleId);
    				      }
    				      if(pids.length == 0){
    				    	  layer.msg('请选择要删除的数据!',{icon:6,time:1500});
    				    	  return ;
    				      }
    				      //批量删除
    				      layer.confirm('真的删除所选角色吗', function(index){
    					         //obj.del();
    					         layer.close(index);
    					         //console.log(pids.length);
    					         $.ajax({
    									type: "POST",
    									url: '<%=request.getContextPath()%>/system/role/delRole.do',
			                            data:{"roleIds": pids}, 
    									traditional: true,
    									dataType : "json",
    									success : function(data){
    	
    										 if(data.success) {
    										   refresh();
										       layer.msg('删除成功!',{icon:6,time:2000});
										     } else {
										       layer.msg(data.msg, {icon:5,time:2000});
										     }
    									}
    								});
    			    	  });
    				    }
    				   ,getUpdateData: function(){ //获取选中数据
    				      var checkStatus = table.checkStatus('flagOne')
    				      ,data = checkStatus.data;
    				      if(data.length == 1){

    				    	  layer.open({
    				    			title:'修改角色',
    				    			type:2,
    				    			area:['50%','60%'],
    				    			content:'<%=request.getContextPath()%>/views/ajaxViews/role-modify.jsp',
    				    			success: function(layero, index){
    				    				var body = layer.getChildFrame('body',index);//建立父子联系
    				    	            var inputList = body.find('#applyform input');
    				    	         
    				    	          
    				    	            $(inputList[0]).val(data[0].roleId);
    				    	            $(inputList[1]).val(data[0].roleName);
    				    	            $(inputList[2]).val(data[0].roleDescribe);
    				    	           
    				    			},
    				    		});
    				      }else if(data.length == 0){
    					      layer.msg('请选择要修改的数据!',{icon:6,time:1500});
    				      }else{
    				    	  layer.msg('只能选中一条数据修改!',{icon:6,time:1500});
    				      }
    				    }
    				   ,getAddData: function(){
    					   layer.open({
				    			title:'添加角色',
				    			type:2,
				    			area:['50%','60%'],
				    			content:'<%=request.getContextPath()%>/views/ajaxViews/role-modify.jsp',
				    			success: function(){
				    				
				    			}
				    		});
    				   }
    		  };
    		  
    		  
    		  
    		  
    		   $('.operatorTable').on('click', function(){
    					  var othis = $(this);
    					  var dothing = othis.attr("function");
    					  if(dothing == "getDeleteData"){
    						  active.getDeleteData();
    					  }else if(dothing == "getUpdateData"){
    						  active.getUpdateData();
    					  }else if(dothing == "getAddData"){
    						  active.getAddData();
    					  }
    			});
    		  
    		  
    		  
    		  

    		});
      }
      
      function myTrim(x) {
    	    return x.replace(/^\s+|\s+$/gm,'');
      }
      
      
      function refresh() {
        init();
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
						</div>
					</form>
				</div>
			</div>
			
					<div class="layui-col-md12">
  	 	<div class="layui-row grid-demo">
	      <div class="layui-btn-container">
			    <button class="layui-btn layui-btn-sm operatorTable" function="getAddData">
				  <i class="layui-icon">&#xe654;</i>添加
				</button>
	        	<button class="layui-btn layui-btn-sm operatorTable" function="getUpdateData">
			      <i class="layui-icon">&#xe642;</i>修改
			    </button>
				<button class="layui-btn layui-btn-sm layui-btn-danger operatorTable" function="getDeleteData" data-type="getDeleteData">
				  <i class="layui-icon">&#xe640;</i>删除
				</button>
				<button class="layui-btn layui-btn-sm" onclick="refresh()">
				  <i class="layui-icon">&#x1002;</i>刷新
				</button>
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
	</div>
	</div>

	<script type="text/javascript">
	layui.use('form', function(){
		  var form = layui.form;
		});
	</script>
</body>
</html>