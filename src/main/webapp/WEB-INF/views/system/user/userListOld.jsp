<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <%@ include  file="/assets/header.jsp"%>
   <title>用户管理</title>
   <script type="text/javascript">
		$(function(){
		   initGrid();
		   initRoleSelct();
		   doSearch();
		});
		
		
		
		function initRoleSelct() {
		 
		    $.ajax({
			    url: '<%=request.getContextPath()%>/system/role/findAll.do',
			    type: "get",
			    dataType : "json",
			  })
			  .done(function( data ) {
			      for(var i = 0; i < data.rows.length; i++) {
			         var role = data.rows[i];
			         //添加或者修改用户时让其选择角色框
			         $("#winRoleSelect").append('<option value="' + role.roleId + '">' + role.roleName +  '</option>');
			         //查询时，让用户选择查询的角色
			         //$("#searchRoleIdSelect").append('<option value="' + role.roleId + '">' + role.roleName +  '</option>');    
			         
			      }
			  })
			  .fail(function( xhr, status, errorThrown ) {
			    alert( "Sorry, there was a problem!" );
			    console.log( "Error: " + errorThrown );
			    console.log( "Status: " + status );
			    console.dir( xhr );
			  })
		
		}
		
		
		//实现对DataGird控件的绑定操作  
		function initGrid() {  
		    $('#MyDatagrid').datagrid({   //定位到Table标签，Table标签的ID是grid   
		        title: '用户列表',  
		        iconCls: 'icon-save',  
		        nowrap: true,  
		        singleSelect : false,// 如果为true，则只允许选择一行。
		        autoRowHeight: false,  
		        striped: true,  
		        collapsible: true,  
		        fit : true,// datagrid自适应宽高
                fitColumns : true,// 使列自动展开/收缩到合适的数据表格宽度。
		        pagination: true,  
		        rownumbers: false,  
		        idField: 'userId',   
		        columns: [[  
		             { field: 'ck', checkbox: true },   //选择  
		             { title: '账号', field: 'userAccount', width: 100},  
		             { title: '昵称', field: 'userName', width: 200 },  
		             { title: '角色', field: 'role.roleName', width: 100, 
		                formatter: function(value,row,index){
						  return row['role']['roleName'];
						}
					 },
		             { title: '电话', field: 'cellphone', width: 100},
		             { title: '邮箱', field: 'email', width: 100},
		             { title: '状态', field: 'state', width: 100}
		        ]],  
                toolbar: '#tb'
		    });
		    
		    pageSearchInit();
		};  
		
		
	
	
		function validateForm() {
	      // 在键盘按下并释放及提交后验证提交表单
	      return $("#applyform").validate({
		    rules: {
		      userAccount: "required",
		      userPassword: "required",
		      userPassword2: {
		        required: true,
		        equalTo: "#userPasswordId"
		      },
		      'role.roleId': "required",
		      userName: "required",
		      cellphone: {
		         required: true
		      },
		      email: {
                  required: true,
                  email: true
               }
		    },
		    messages: {
		      userAccount: "不能为空",
		      userPassword: "不能为空",
		      userPassword2: {
		        required: "不能为空",
		        equalTo: "两次密码不一样"
		      },
		      'role.roleId': "不能为空",
		      userName: "不能为空",
		      cellphone: {
		         required: "不能为空"
		      },
		      email: {
                  required: "不能为空",
                  email: "邮箱格式错误"
               }
		    }}).form();
		}
	
	
	
	
	
		function addUserInit() {
		    $('.window .panel-title').html("添加用户");
		    $("#applyform").form('clear');
		    $("#saveBtn").attr("onclick", "addUser()");
		    $("#userPasswordTrId").show();
		    $("#userPasswordTrId2").show();
		    $('#win').window('open');
		}
		
		
		function addUser() { 
		    if(!validateForm()) {
			   return ;
			}
		
             $.ajax({
			    url: '<%=request.getContextPath()%>/system/user/addUser.do',
			    data:$("#applyform").serialize(), 
			    type: "post",
			    dataType : "json",
			  })
			  .done(function( data ) {
			     if(data.success) {
			       doSearch(); //刷新当前页
			       $('#win').window('close'); // close a window
			       $.messager.alert('提示', '添加成功');
			     } else {
			         $.messager.alert('提示', data.msg);
			     }
			  })
			  .fail(function( xhr, status, errorThrown ) {
			    alert( "Sorry, there was a problem!" );
			    console.log( "Error: " + errorThrown );
			    console.log( "Status: " + status );
			    console.dir( xhr );
			  })
		
		}
		
		
		
		function editUserInit() {
		    var rows = $('#MyDatagrid').datagrid('getSelections');
		    if(rows.length < 1) {
		       $.messager.alert('提示', "请选择一行数据");
		       return;
		    } else if(rows.length > 1) {
		       $.messager.alert('提示', "不能选择多行数据同时编辑, 请只选择一行数据");
		       return;
		    }
		
			var row = rows[0];
			if (row){
				$('.window .panel-title').html("修改用户");
			    $("#applyform").form('load', row);
			    $("#saveBtn").attr("onclick", "editUser()");
			    $("#userPasswordTrId").hide();
		        $("#userPasswordTrId2").hide();
		        $("#winRoleSelect").val(row['role']['roleId']);
			    $('#win').window('open');
			}
		}
		
	
	
		function editUser() { 
		    if(!validateForm()) {
			   return ;
			}
		
             $.ajax({
			    url: '<%=request.getContextPath()%>/system/user/editUser.do',
			    data:$("#applyform").serialize(), 
			    type: "post",
			    dataType : "json",
			  })
			  .done(function( data ) {
			     if(data.success) {
			       //刷新表单
			        doSearch();  //刷新当前页
			       //关闭原先的弹窗
			       $('#win').window('close'); // close a window
			       //提示修改成功
			       $.messager.alert('消息', "修改成功");
			     
			     } else {
			         $.messager.alert('消息', data.msg);
			     }
			  })
			  .fail(function( xhr, status, errorThrown ) {
			    alert( "Sorry, there was a problem!" );
			    console.log( "Error: " + errorThrown );
			    console.log( "Status: " + status );
			    console.dir( xhr );
			  })
		
		}
		
		function delUser() {
		    var rows = $('#MyDatagrid').datagrid('getSelections');
		    if(rows.length < 1) {
		       $.messager.alert('提示', "请选择一行数据");
		       return;
		    } 
		
		    
		    var userIds = [];
		    for(var i = 0; i < rows.length; i++) {
		      userIds.push(rows[i].userId);
		    }
		    
	
		    
		     $.ajax({
			    url: '<%=request.getContextPath()%>/system/user/delUser.do',
			    data:{"userIds": userIds}, 
			    type: "post",
			    traditional: true,  
			    dataType : "json"
			  })
			  .done(function( data ) {
			     if(data.success) {
			       //提示修改成功
			       $.messager.alert('消息', "删除成功");
			     
			       //刷新表单
			       doSearch();  //刷新当前页
			     
			     } else {
			         $.messager.alert('消息', data.msg);
			     }
			  })
			  .fail(function( xhr, status, errorThrown ) {
			    alert( "Sorry, there was a problem!" );
			    console.log( "Error: " + errorThrown );
			    console.log( "Status: " + status );
			    console.dir( xhr );
			  })
			  .always(function( xhr, status ) {
				//取消选择行  
				$('#MyDatagrid').datagrid('clearSelections');
			  });
		
		}
		
		
		function validateEditPasswordForm() {
		
			 return $("#applyform1").validate({
			    rules: {
			      userPassword: "required",
			      userPassword2: {
			        required: true,
			        equalTo: "#editUserPasswordId"
			      }
			    },
			    messages: {
			      userPassword: "不能为空",
			      userPassword2: {
			        required: "不能为空",
			        equalTo: "两次密码不一样"
			      }
			    }}).form();
		}
		
		
		function editPasswordInit() {
		   var rows = $('#MyDatagrid').datagrid('getSelections');
		    if(rows.length < 1) {
		       $.messager.alert('提示', "请选择一行数据");
		       return;
		    } else if(rows.length > 1) {
		       $.messager.alert('提示', "不能选择多行数据同时编辑, 请只选择一行数据");
		       return;
		    }
		
			var row = rows[0];
			if (row){
			    $("#applyform1").form('clear');
			    $('.window .panel-title').html("重置密码");
			    $("#applyform1 input[name='userId']").val(row.userId);
			    $('#editPasswordWin').window('open');
			}
		}
		
		
		function editPassword() {
		
		     if(!validateEditPasswordForm()) {
			   return ;
			 }
			
             $.ajax({
			    url: '<%=request.getContextPath()%>/system/user/editPassword.do',
			    data:$("#applyform1").serialize(), 
			    type: "post",
			    dataType : "json",
			  })
			  .done(function( data ) {
			     if(data.success) {
			       $('#editPasswordWin').window('close'); // close a window
			       //提示修改成功
			       $.messager.alert('消息', "修改成功");
			     
			     } else {
			         $.messager.alert('消息', data.msg);
			     }
			  })
			  .fail(function( xhr, status, errorThrown ) {
			    alert( "Sorry, there was a problem!" );
			    console.log( "Error: " + errorThrown );
			    console.log( "Status: " + status );
			    console.dir( xhr );
			  })
		}
		
		
		
		
		var page = {
		   "currentPage" : "1", // 当前页码
	       "pageSize" : "20" // 每页多少条数据
		};
		
		
		function pageSearchInit() {  
		    var p = $("#MyDatagrid").datagrid('getPager');
            //设置分页组件参数
            $(p).pagination({
                pageSize: 20,
                pageNumber: 1,
                pageList: [20, 30, 40],
                onSelectPage: function (pageNumber, pageSize) {
	                page.currentPage = pageNumber;
	                page.pageSize = pageSize;
	                doSearch();
                }
            });
		}
		
		
		function searchReset() {
		   $("#searchForm input").val("");
		   $("#searchRoleIdSelect").val("");
		}
		
		
		
		function doSearch() {
		   var params = [];
		   var key, symbol, value;
		   

		   value = $("#searchUserAccount").val();
		   if(value != "") {
		      key = "userAccount";
		      symbol = "like"
		      value = "%" + value + "%";
		      params.push(key);  params.push(symbol); params.push(value);
		   }
		   
		   
		   value = $("#searchUserName").val();
		   if(value != "") {
		      key = "userName";
		      symbol = "like"
		      value = "%" + value + "%";
		      params.push(key);  params.push(symbol); params.push(value);
		   }
		   
		   /*
		   value = $("#searchRoleIdSelect").val();
		   if(value != "") {
		      key = "role.roleId";
		      symbol = "="
		      params.push(key);  params.push(symbol); params.push(value);
		   }
		   */
	
		    $.ajax({
			    url: '<%=request.getContextPath()%>/system/user/searchUser.do',
			    data: {"params": params, "currentPage" : page.currentPage, "pageSize" : page.pageSize}, 
			    traditional: true,  
			    dataType : "json"
			})
		   .done(function( data ) {
			     if(data.success) {
			     
			        page.currentPage = data.obj.currentPage;
	                page.pageSize = data.obj.pageSize;
			        $('#MyDatagrid').datagrid('loadData', {"total":data.obj.totalRecord, "rows":data.obj.list});
			        $('#MyDatagrid').datagrid('clearSelections');
			     
			     } else {
			        $.messager.alert('提示', data.msg);
			     }
		    });
		   
		   
		   
		}
		
		
		
		
			
	</script>
</head>
<body class="easyui-layout">
	
	<div region="center" border="false" style="padding:5px;">
	  <div id="MyDatagrid"></div>
	  
	  <div id="tb"> <!-- datagrid 的工具栏  start -->
	
	    <form id="searchForm" style="padding:5px;">
	    
	     	<span>账号:</span>
			<input id="searchUserAccount" name="userAccount" type="text" value="">
			<span>昵称:</span>
			<input id="searchUserName" name="userName" type="text" value="">
			<!--  
				<span>角色:</span>
	            <select id="searchRoleIdSelect" name="role.roleId">
	              <option value=""></option>
	            </select>
             -->
			<a href="javascript:void(0)" class="easyui-linkbutton" plain="true" iconCls="icon-search" onclick="doSearch()">查询</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" plain="true" iconCls="icon-reload" onclick="searchReset()">重置</a>
	    </form>
	   
	 	
		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addUserInit()">添加</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editUserInit()">修改</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="delUser()">删除</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-undo" plain="true" onclick="editPasswordInit()">重置密码</a>
	 </div>     <!-- datagrid 的工具栏  end -->
	  

	  <div id="win" class="easyui-window" title="添加用户" style="width:400px;height:350px;" closed="true">
		<form id="applyform" style="padding:10px 20px 10px 40px;">
		  <table>
		   <tr>
		      <input type="hidden" name="userId" value="">
		      <th>账号:</th><td><input type="text" name="userAccount" value=""></td>
		   </tr>
		   <tr id="userPasswordTrId">
		      <th>密码:</th><td><input id="userPasswordId" type="password" name="userPassword" value=""></td>
		   </tr>
		   <tr id="userPasswordTrId2">
		      <th>确认密码:</th><td><input type="password" name="userPassword2" value=""></td>
		   </tr>
		   <tr>
		      <th>昵称:</th><td><input type="text" name="userName" value=""></td>
		   </tr>
		   <tr>
		      <th>角色:</th><td><select id="winRoleSelect" name="role.roleId"></select></td>
		   </tr>
		   <tr>
		      <th>电话:</th><td><input type="text" name="cellphone" value=""></td>
		   </tr>
		   <tr>
		      <th>邮箱:</th><td><input type="text" name="email" value=""></td>
		   </tr>
		  </table>
		  <div style="padding:5px;text-align:center;">
				<a id="saveBtn" href="javascript:void(0)" class="easyui-linkbutton" icon="icon-ok" onclick="">保存</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" icon="icon-cancel" onclick="javascript: $('#win').window('close');">取消</a>
		   </div>
	    </form>
	  </div> <!-- win -->
	  
	  
	  
	  
	  
	  <div id="editPasswordWin" class="easyui-window" title="重置密码" style="width:400px;height:350px;" closed="true">
		<form id="applyform1" style="padding:10px 20px 10px 40px;">
		  <table>
		   <tr>
		      <input type="hidden" name="userId" value="">
		   </tr>
		   <tr>
		      <th>密码:</th><td><input id="editUserPasswordId" type="password" name="userPassword" value=""></td>
		   </tr>
		   <tr>
		      <th>确认密码:</th><td><input type="password" name="userPassword2" value=""></td>
		   </tr>
		  </table>
		  <div style="padding:5px;text-align:center;">
				<a href="javascript:void(0)" class="easyui-linkbutton" icon="icon-ok" onclick="editPassword()">确定</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" icon="icon-cancel" onclick="javascript: $('#editPasswordWin').window('close');">取消</a>
		   </div>
	    </form>
	  </div> <!-- editPasswordWin -->
	  
	  
	  
	</div> <!-- center -->
</body>
</html>