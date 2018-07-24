<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <%@ include file="/layui/header.jsp"%>
   <title>用户管理列表</title>
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
    	  
    	  var value;
    	  
    	  value = $("#searchUserAccount").val();
		   if(value != "") {
			   params = params + "userAccount" + ",like,%" + value + "%,";
		   }
		   
		   value = $("#searchUserName").val();
		   if(value != "") {
			   params = params + "userName" + ",like,%" + value + "%,";
		   }
    	  
    	  layui.use('table', function(){
    		  var table = layui.table;
    		  table.render({
    		    elem: '#table1'
    		    ,id: 'flagOne'
    		    ,url:'<%=request.getContextPath()%>/system/user/searchUser.do'
    		    ,height: 365
    		    //,cellMinWidth: 120
    		    ,limits:[10,25,50,75,100]
    		    ,cols: [[
    		      //{field:'id', width:'1%'}
    		      {checkbox: true, event: 'set1', fixed: true}
    		      ,{field:'userAccount',width:200, event: 'set2', title: '账号', fixed: true, sort: true}
      		      ,{field: 'userName',width:200, event: 'set3', title: '昵称', sort: true}
      		      ,{field:'roleName',width:180, event: 'set4', title: '角色', sort: true}
      		     ,{field:'cellphone',width:200, event: 'set5', title: '电话', sort: true}
      		     ,{field:'email',width:200, event: 'set6', title: '邮箱', sort: true}
      		     ,{field:'state',width:100, event: 'set7', title: '状态', sort: true}
      		    ]]
    		    ,page: true
    		    ,where: {"param": params}
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
    					      pids.push(data[i].userId);
    				      }
    				      if(pids.length == 0){
    				    	  layer.msg('请选择要删除的数据!',{icon:6,time:1500});
    				    	  return ;
    				      }
    				      //批量删除
    				      layer.confirm('真的删除所选用户吗', function(index){
    					         //obj.del();
    					         layer.close(index);
    					         //console.log(pids.length);
    					         $.ajax({
    									type: "POST",
    									url: '<%=request.getContextPath()%>/system/user/delUser.do',
			                            data:{"userIds": pids}, 
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
    				    			title:'修改用户',
    				    			type:2,
    				    			area:['50%','98%'],
    				    			content:'<%=request.getContextPath()%>/views/ajaxViews/user-modify.jsp',
    				    			success: function(layero, index){
    				    				var body = layer.getChildFrame('body',index);//建立父子联系
    				    	            var inputList = body.find('#applyform input');
    				    	            body.find("#roleNameInput").val(data[0].roleName);
    				    	          
    				    	            $(inputList[0]).val(data[0].userId);
    				    	            $(inputList[1]).val(data[0].userAccount);
    				    	            $(inputList[2]).val(data[0].userPassword);
    				    	            $(inputList[3]).val(data[0].userPassword);
    				    	           // $(inputList[5]).val(data[0].roleId);
    				    	            //body.find("#winRoleSelect option[text='jQuery']").attr("selected", true);  
    				    	           
    				    	            $(inputList[4]).val(data[0].userName);
    				    	            $(inputList[5]).val(data[0].cellphone);
    				    	            $(inputList[6]).val(data[0].email);
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
				    			title:'添加用户',
				    			type:2,
				    			area:['50%','98%'],
				    			content:'<%=request.getContextPath()%>/views/ajaxViews/user-modify.jsp',
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
							
							<div class="layui-inline">
								<label class="layui-form-mid">账号：</label>
								<div class="layui-input-inline"
									style="width: 100px; height: 35px;">
									<input type="tel" id="searchUserAccount" name="searchUserAccount" autocomplete="off"
										style="width: 100px; height: 35px;" placeholder="账号"
										class="layui-input input-text" />
								</div>
							</div>
							
							<div class="layui-inline">
								<label class="layui-form-mid">昵称：</label>
								<div class="layui-input-inline"
									style="width: 110px; height: 35px;">
									<input type="tel" id="searchUserName" name="searchUserName" autocomplete="off"
										style="width: 110px; height: 35px;" placeholder="昵称"
										class="layui-input input-text" />
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
  	 	<div class="layui-row grid-demo">
	      <div class="layui-btn-container">
			    <button class="layui-btn layui-btn-sm operatorTable" function="getAddData">
				  <i class="layui-icon">&#xe654;</i>添加
				</button>
	        	<button class="layui-btn layui-btn-sm operatorTable"  function="getUpdateData">
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