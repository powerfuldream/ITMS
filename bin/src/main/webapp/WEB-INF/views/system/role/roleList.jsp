<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <%@ include  file="/assets/header.jsp"%>
   <title>角色管理</title>
   <script type="text/javascript">
		$(function(){
		   initRoleGrid();
		   initResourceGrid();
		   //initTerminalAreaTree();

		});
		
		
		//实现对DataGird控件的绑定操作  
		function initRoleGrid() {  
		    $('#MyRoleDatagrid').datagrid({   //定位到Table标签，Table标签的ID是grid  
		        url: '<%=request.getContextPath()%>/system/role/findAll.do',   //指向后台的Action来获取当前菜单的信息的Json格式的数据  
		        title: '角色列表',  
		        iconCls: 'icon-save',  
		        nowrap: true,  
		        singleSelect : false,// 如果为true，则只允许选择一行。
		        autoRowHeight: false,  
		        striped: true,  
		        collapsible: true,  
		        fit : true,// datagrid自适应宽高
                fitColumns : true,// 使列自动展开/收缩到合适的数据表格宽度。
		        pagination: true,  
		        pageSize: 20,  
		        pageList: [20,50,100],  
		        rownumbers: false,  
		        sortName: 'createDate',    //根据某个字段给easyUI排序  
		        sortOrder: 'DESC',  
		        remoteSort: false,  
		        idField: 'roleId',  
		     //   queryParams: queryData,  //异步查询的参数  
		        columns: [[  
		             { field: 'ck', checkbox: true },   //选择  
		             { title: '角色名称', field: 'roleName', width: 100},  
		             { title: '角色描述', field: 'roleDescribe', width: 200 },  
		             { title: '创建时间', field: 'createDate', width: 80,
                         formatter:function(value,row,index) {   
	                         return easyuiDateFormat(value);  
                         }   
                      }
		        ]],  
		        toolbar: [{  
		            id: 'btnAdd',  
		            text: '添加',  
		            iconCls: 'icon-add',  
		            handler: function () {  
		               addRoleInit(); 
		            }  
		        }, '-', {  
		            id: 'btnEdit',  
		            text: '修改',  
		            iconCls: 'icon-edit',  
		            handler: function () {  
		                editRoleInit();//实现修改记录的方法  
		            }  
		        }, '-', {  
		            id: 'btnDelete',  
		            text: '删除',  
		            iconCls: 'icon-remove',  
		            handler: function () {  
		               delRole(); 
		            }  
		        }, '-', {  
		            id: 'setResourceId',  
		            text: '配置资源',  
		            iconCls: 'icon-sum',  
		            handler: function () {  
		               setResourceInit(); 
		            }  
		        }
		        
		    /*    , '-', {  
		            id: 'setTerminalPowerId',  
		            text: '播放端权限配置',  
		            iconCls: 'icon-tip',  
		            handler: function () {  
		               setTerminalPowerInit(); 
		            }  
		        }
		        */
		        
		        ],  
		        onDblClickRow: function (rowIndex, rowData) {  
		         
		        }  
		    })  
		}
		

	
		function validateRoleForm() {
	      // 在键盘按下并释放及提交后验证提交表单
	      return $("#roleApplyform").validate({
		    rules: {
		      roleName: "required",
		      roleDescribe: "required"
		    },
		    messages: {
		      roleName: "不能为空",
		      roleDescribe: "不能为空"
		    }}).form();
		}
	
	
	
	
	
		function addRoleInit() {
		    $('.window-header .panel-title').html("添加角色");
		    $("#roleApplyform").form('clear');
		    $("#saveRoleBtn").attr("onclick", "addRole()");
		    $('#roleWin').window('open');
		}
		
		
		function addRole() { 
		    if(!validateRoleForm()) {
			   return ;
			}
		
             $.ajax({
			    url: '<%=request.getContextPath()%>/system/role/addRole.do',
			    data:$("#roleApplyform").serialize(), 
			    type: "post",
			    dataType : "json",
			  })
			  .done(function( data ) {
			     if(data.success) {
			       $("#MyRoleDatagrid").datagrid("reload", {}); //刷新当前页
			       $('#roleWin').window('close'); // close a window
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
		
		
		
		function editRoleInit() {
		    var rows = $('#MyRoleDatagrid').datagrid('getSelections');
		    if(rows.length < 1) {
		       $.messager.alert('提示', "请选择一行数据");
		       return;
		    } else if(rows.length > 1) {
		       $.messager.alert('提示', "不能选择多行数据同时编辑, 请只选择一行数据");
		       return;
		    }
		
			var row = rows[0];
			if (row){
				$('.window-header .panel-title').html("修改角色");
			    $("#roleApplyform").form('load', row);
			    $("#saveRoleBtn").attr("onclick", "editRole()");
			    $('#roleWin').window('open');
			}
		}
		
	
	
		function editRole() { 
		    if(!validateRoleForm()) {
			   return ;
			}
		
             $.ajax({
			    url: '<%=request.getContextPath()%>/system/role/editRole.do',
			    data:$("#roleApplyform").serialize(), 
			    type: "post",
			    dataType : "json",
			  })
			  .done(function( data ) {
			     if(data.success) {
			       //刷新表单
			       $("#MyRoleDatagrid").datagrid("reload", {}); //刷新当前页
			       //关闭原先的弹窗
			       $('#roleWin').window('close'); // close a window
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
		
		function delRole() {
		    var rows = $('#MyRoleDatagrid').datagrid('getSelections');
		    if(rows.length < 1) {
		       $.messager.alert('提示', "请选择一行数据");
		       return;
		    } 
		    
		    
		    $.messager.confirm('提示框', '你确定要删除选中的角色?',function(r) {
		        if(!r) return;
		        
		        var roleIds = [];
			    for(var i = 0; i < rows.length; i++) {
			      roleIds.push(rows[i].roleId);
			    }
			    
		
			    
			     $.ajax({
				    url: '<%=request.getContextPath()%>/system/role/delRole.do',
				    data:{"roleIds": roleIds}, 
				    type: "post",
				    traditional: true,  
				    dataType : "json"
				  })
				  .done(function( data ) {
				     if(data.success) {
				       //提示修改成功
				       $.messager.alert('消息', "删除成功");
				     
				       //刷新表单
				       $("#MyRoleDatagrid").datagrid("reload", {}); //刷新当前页
				     
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
					$('#MyRoleDatagrid').datagrid('clearSelections');
				  });

		    });

		}
		
		var roleResourceObj = {
		   "roleId": "",
		   "resources":[],
		   "init": "true"   //标记为初始化防止频繁触发select事件
		}
		
			 
		function initResourceGrid() {  
		    $('#setResourceDatagrid').datagrid({   //定位到Table标签，Table标签的ID是grid  
		        title: '资源列表',  
		        height: 300,
		        iconCls: 'icon-save',  
		        nowrap: true,  
		        singleSelect : false,// 如果为true，则只允许选择一行。
		        autoRowHeight: false,  
		        striped: true,  
		        collapsible: true,  
                fitColumns : true,// 使列自动展开/收缩到合适的数据表格宽度。
		        pagination: true,  
		        pageSize: 2,  
		        pageList: [2,50,100],  
		        rownumbers: false,  
		        //sortName: 'ID',    //根据某个字段给easyUI排序  
		        //sortOrder: 'asc',  
		        //remoteSort: false,  
		        idField: 'resourceId',  
		     //   queryParams: queryData,  //异步查询的参数  
		        columns: [[  
		             { field: 'ck', checkbox: true },   //选择 
		             { title: '资源名称', field: 'resourceName', width: 150 },  
		             { title: '资源路径', field: 'resourceUrl', width: 200 },  
		             { title: '资源类型', field: 'resourceType', width: 100,
						formatter: function(value,row,index){
							if (value == "public"){
								return "公共资源";
							} else if(value == "private") {
							    return "需要授权";
							} else {
								return value;
							}
						}
		             }
		        ]],
	            onSelect: function (rowIndex, rowData) {
	                if(roleResourceObj.init == "false") setResourceClick(rowIndex, rowData, "onSelect");
			    },                    
			    onUnselect: function (rowIndex, rowData) {
			        if(roleResourceObj.init == "false") setResourceClick(rowIndex, rowData, "onUnselect");
			    }
		    });  
		}
		
		
		
		
		
		function setResourceClick(index, row, evenType) { //配置资源的点击事件
		   if(evenType == "onUnselect") {
		       //如果点击的资源在该角色已有资源列表里就移除,否则添加，
			   for(var i = 0; i < roleResourceObj.resources.length; i++) {
			     if(roleResourceObj.resources[i].resourceId == row.resourceId) {
			         roleResourceObj.resources.splice(i,1);
			         break;
			     }
			   }
		   } else {
		   	   //不在已有资源列表就添加
		       roleResourceObj.resources.push(row);
		   }
		   
		   //更新资源数
		   $("#setResourceNum").html("已配置资源: " + roleResourceObj.resources.length);
		}
		
		
		function setResourceInit() {
		
		    var rows = $('#MyRoleDatagrid').datagrid('getSelections');
		    if(rows.length < 1) {
		       $.messager.alert('提示', "请选择一行数据");
		       return;
		    } else if(rows.length > 1) {
		       $.messager.alert('提示', "不能选择多行数据同时编辑, 请只选择一行数据");
		       return;
		    }
		
			var row = rows[0];
			if (row){
			
			   $.ajax({
			    url: '<%=request.getContextPath()%>/system/role/setResourceInit.do',
			    data:{"roleId": row.roleId, "resourceType":"private"}, 
			    type: "get",
			    traditional: true,  
			    dataType : "json"
			  })
			  .done(function( data ) {
			     if(data.success) {
			   
			        //记录该角色原来的资源
			        roleResourceObj = {};
			        roleResourceObj.roleId = row.roleId;
			        roleResourceObj.resources = data.obj[1];
                    roleResourceObj.init = "true";
                    
                    //取消选中状态
			       // $('#MyRoleDatagrid').datagrid('clearSelections');
			        $('#setResourceDatagrid').datagrid('clearSelections');
                    
                    
			        //加载全部的资源
			        $('#setResourceDatagrid').datagrid('loadData', {"total":data.obj[0].length, "rows":data.obj[0]});
			        //显示该角色已有的资源
			        for(var j = 0; j < roleResourceObj.resources.length; j++) {
			            var rowIndex = $('#setResourceDatagrid').datagrid('getRowIndex', roleResourceObj.resources[j].resourceId);//id是关键字值
			            $('#setResourceDatagrid').datagrid('selectRow', rowIndex);
			        }
			        
			        //可以触发select事件
			        roleResourceObj.init = "false";
			        
			        //显示该角色拥有的资源数
			        $("#setResourceNum").html("已配置资源: " + roleResourceObj.resources.length);
			        
			        $('.window-header .panel-title').html("配置资源");
			        $('#setResourceWin').window('open');
			     } else {
			         $.messager.alert('消息', data.msg);
			     }
			  })
			
			}
		}
		
		
		function setResource() {
		     
		     var resourceIds = [];
		     for(var i = 0; i < roleResourceObj.resources.length; i++) {
		       resourceIds.push(roleResourceObj.resources[i].resourceId);
		     }
		     
		     
		     
		     $.ajax({
			    url: '<%=request.getContextPath()%>/system/role/setResource.do',
			    data:{"roleId": roleResourceObj.roleId, "resourceType":"private", "resourceIds": resourceIds}, 
			    type: "get",
			    traditional: true,  
			    dataType : "json"
			  })
			  .done(function( data ) {
			     if(data.success) {
			         $('#setResourceWin').window('close');
			         $.messager.alert('消息', "成功保存角色的配置资源");
			         
				  } else {
					  $.messager.alert('消息', data.msg);
			      }
				})
					
		 }
		 
		 
		 
		 
		 
		 function initTerminalAreaTree() { 
	         $.ajax({
			    url: '<%=request.getContextPath()%>/area/findAll.do',
			    type: "get",
			    dataType : "json"
			  })
			  .done(function( data ) {
			     if(data.success) {
			            //组装地区的json数据, 使其可以显示在easyui的树中
				        var treeData = [];
				        for(var i = 0; i <= data.obj.length; i++) {
				           var area = {
				             "showTerminal": "showTerminal",
				             "addTerminal": "addTerminal",
				             "editTerminal": "editTerminal",
				             "delTerminal": "delTerminal",
				             "updateTerminalState": "updateTerminalState",
				             "state": "closed"
				           }
				           
				           if(i == data.obj.length) {  //最后添加中国的地区
				              area.id = "86";
				              area.name = "中国";
				              treeData.push(area);
				              break;
				           }
				           
				           
				           area.id = data.obj[i].code;
				           area._parentId = data.obj[i].parentCode;
				           area.name = data.obj[i].name;
	                       treeData.push(area);
				        }
				     
				        //把地区的数据显示到树中
				        $('#setPlayTerminalTable').treegrid('loadData', {"total":treeData.length, "rows": treeData});
			     
		         } else {
				    $.messager.alert('消息', data.msg);
				 }
			   })
		 }
		 
		 
		 var terminalPower = {
		    "roleId": "",
		    "urls": []
		 }
		 
		 function setTerminalPowerInit() {
		     
		    var rows = $('#MyRoleDatagrid').datagrid('getSelections');
		    if(rows.length < 1) {
		       $.messager.alert('提示', "请选择一行数据");
		       return;
		    } else if(rows.length > 1) {
		       $.messager.alert('提示', "不能选择多行数据同时编辑, 请只选择一行数据");
		       return;
		    }
		
			var row = rows[0];
			if (row) {
				  $.ajax({
				    url: '<%=request.getContextPath()%>/system/role/setPlayTerminalInit.do',
				    data:{"roleId": row.roleId}, 
				    type: "get",
				    dataType : "json"
				  })
				  .done(function( data ) {
				     if(data.success) {
				        console.log(data);
				        //记录该角色拥有的播放端权限
				        terminalPower = {
						    "roleId": "",
						    "urls": []
						}
				        terminalPower.roleId = row.roleId;
				        
				        //清除原先的勾选状态
				       // $("#setPlayTerminalTable input:checkbox").attr('checked', false);
				     
				     
				        //让角色原先拥有的权限勾选出来
				        for(var i = 0; i < data.obj.length; i++) { 
				          $("#" + data.obj[i].resourceUrl).attr('checked', true); 
				          terminalPower.urls.push(data.obj[i].resourceUrl);
				        }
				        
				        
				        $('#setPlayTerminalWin').window('open'); 
				     } else {
				        $.messager.alert('消息', data.msg);
				     }
				  })
			
			}
		     
		
		 }
		 
		 function set_terminal_formatter(value, node) { 
		     var url = value + "/" + node.id;
			 var content = '<input id="' + url + '" onclick="checkTerminal(\'' + url +  '\')" type="checkbox" />';
			 return content;
		}
		
		function checkTerminal(url) {
		   console.log(url);
		   //如果该角色原先有该权限就移除
		   for(var i = 0; i < terminalPower.urls.length; i++) {
		     if(terminalPower.urls[i] == url) {
		        terminalPower.urls.splice(i,1);
		        return;
		     }
		   }
		   
		   //没有该url就添加
		   terminalPower.urls.push(url);
		}
		
		
			
	</script>
</head>
<body class="easyui-layout">
	
	<div region="center" border="false" style="padding:5px;">
	  <div id="MyRoleDatagrid"></div>
	  
	  
	  <div id="roleWin" class="easyui-window" title="添加角色" style="width:400px;height:350px;" closed="true">
		<form id="roleApplyform" style="padding:10px 20px 10px 40px;">
		  <table>
		   <tr>
		      <input type="hidden" name="roleId" value="">
		      <th>角色名称:</th><td><input type="text" name="roleName" value="" style="width:200px;"></td>
		   </tr>
		   <tr>
		      <th>角色描述:</th><td><input type="text" name="roleDescribe" value="" style="width:200px;"></td>
		   </tr>
		  </table>
		  <div style="padding:5px;text-align:center;">
				<a id="saveRoleBtn" href="javascript:void(0)" class="easyui-linkbutton" icon="icon-ok" onclick="">保存</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" icon="icon-cancel" onclick="javascript: $('#roleWin').window('close');">取消</a>
		   </div>
	    </form>
	  </div> <!-- roleWin -->
	  
	  
	  
	  
	  <div id="setResourceWin" class="easyui-window" title="资源列表" style="width:900px;height:450px;padding:5px;" closed="true">
	       <p id="setResourceNum">已配置资源: 10</p>
	       <div id="setResourceDatagrid"></div>
	       <div style="padding:5px;text-align:center;">
				<a href="javascript:void(0)" class="easyui-linkbutton" icon="icon-ok" onclick="setResource();">保存</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" icon="icon-cancel" onclick="javascript: $('#setResourceWin').window('close');">取消</a>
		   </div>
	  </div> 
	  
	  
	  

	  
	</div> <!-- center -->
</body>
</html>