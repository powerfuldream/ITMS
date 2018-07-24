<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <%@ include  file="/assets/header.jsp"%>
   <title>资源管理</title>
   <script type="text/javascript">
		$(function() {
		   initGrid();
		   doSearch();
		});
		
		
		//实现对DataGird控件的绑定操作  
		function initGrid() {  
		    $('#MyDatagrid').datagrid({   //定位到Table标签，Table标签的ID是grid  
		        title: '资源列表',  
		        iconCls: 'icon-save',  
		        nowrap: true,  
		        singleSelect : false,// 如果为true，则只允许选择一行。
		        autoRowHeight: false,  
		        striped: true,  //行背景交换
		        collapsible: true,  
		        fit : true,// datagrid自适应宽高
                fitColumns : true,// 使列自动展开/收缩到合适的数据表格宽度。
		        pagination: true,    
		        rownumbers: false,  
		        idField: 'resourceId',   
		        columns: [[  
		             { field: 'ck', checkbox: true },   //选择  
		             { title: '资源名称', field: 'resourceName', width: 150 },  
		             { title: '资源路径', field: 'resourceUrl', width: 200 },  
		             { title: '资源类型', field: 'resourceType', width: 80,
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
		        toolbar: '#tb'
		    });
		    pageSearchInit();
		};  
		
		
	
	
		function validateForm() {
	      // 在键盘按下并释放及提交后验证提交表单
	      return $("#applyform").validate({
		    rules: {
		      resourceName: "required",
		      resourceUrl: "required",
		      resourceType: "required"
		    },
		    messages: {
		      resourceName: "不能为空",
		      resourceUrl: "不能为空",
		      resourceType: "不能为空"
		    }}).form();
		}
	
	
	
	
	
		function addResourceInit() {
		    $('.window .panel-title').html("添加资源");
		    $("#applyform").form('clear');
		    $("#saveBtn").attr("onclick", "addResource()");
		    $('#win').window('open');
		}
		
		
		function addResource() { 
		    if(!validateForm()) {
			   return ;
			}
		
             $.ajax({
			    url: '<%=request.getContextPath()%>/system/resource/addResource.do',
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
		
		
		
		function editResourceInit() {
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
				$('.window .panel-title').html("修改资源");
			    $("#applyform").form('load', row);
			    $("#saveBtn").attr("onclick", "editResource()");
			    $('#win').window('open');
			}
		}
		
	
	
		function editResource() { 
		    if(!validateForm()) {
			   return ;
			}
		
             $.ajax({
			    url: '<%=request.getContextPath()%>/system/resource/editResource.do',
			    data:$("#applyform").serialize(), 
			    type: "post",
			    dataType : "json",
			  })
			  .done(function( data ) {
			     if(data.success) {
			       //刷新表单
			       doSearch(); //刷新当前页
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
		
		function delResource() {
		    var rows = $('#MyDatagrid').datagrid('getSelections');
		    if(rows.length < 1) {
		       $.messager.alert('提示', "请选择一行数据");
		       return;
		    } 
		
		    $.messager.confirm('提示框', '你确定要删除选中的资源?',function(r) {
		        if(!r) return;
		        
			    var resourceIds = [];
			    for(var i = 0; i < rows.length; i++) {
			      resourceIds.push(rows[i].resourceId);
			    }
		    
	
		    
		       $.ajax({
			    url: '<%=request.getContextPath()%>/system/resource/delResource.do',
			    data:{"resourceIds": resourceIds}, 
			    type: "post",
			    traditional: true,  
			    dataType : "json"
			  })
			  .done(function( data ) {
			     if(data.success) {
			       //提示修改成功
			       $.messager.alert('消息', "删除成功");
			     
			       //刷新表单
			       doSearch(); //刷新当前页
			     
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
		        
		    });
		 
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
		   $("#searchResourceTypeSelect").val("");
		}
		
		
		
		function doSearch() {
		   var params = [];
		   var key, symbol, value;

		   value = $("#searchResourceName").val();
		   if(value != "") {
		      key = "resourceName";
		      symbol = "like"
		      value = "%" + value + "%";
		      params.push(key);  params.push(symbol); params.push(value);
		   }
		   
		   
		   value = $("#searchResourceUrl").val();
		   if(value != "") {
		      key = "resourceUrl";
		      symbol = "like"
		      value = "%" + value + "%";
		      params.push(key);  params.push(symbol); params.push(value);
		   }
		   
		   
		   value = $("#searchResourceTypeSelect").val();
		   if(value != "") {
		      key = "resourceType";
		      symbol = "="
		      params.push(key);  params.push(symbol); params.push(value);
		   }
		   
	
		    $.ajax({
			    url: '<%=request.getContextPath()%>/system/resource/searchResource.do',
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
	    
	     	<span>资源名称:</span>
			<input id="searchResourceName" name="resourceName" type="text" value="">
			<span>资源路径:</span>
			<input id="searchResourceUrl" name="resourceUrl" type="text" value="">
			<span>资源类型:</span>
            <select id="searchResourceTypeSelect" name="resourceType">
              <option value=""></option>
              <option value ="public">公共资源</option>
			  <option value ="private">需要授权</option>
            </select>
         
			<a href="javascript:void(0)" class="easyui-linkbutton" plain="true" iconCls="icon-search" onclick="doSearch()">查询</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" plain="true" iconCls="icon-reload" onclick="searchReset()">重置</a>
	    </form>
	 
		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addResourceInit()">添加</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editResourceInit()">修改</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="delResource()">删除</a>
	  </div>     <!-- datagrid 的工具栏  end -->
	  
	  
	  
	  
	  <div id="win" class="easyui-window" title="添加资源" style="width:400px;height:350px;" closed="true">
		<form id="applyform" style="padding:10px 20px 10px 40px;">
		  <table>
		   <tr>
		      <input type="hidden" name="resourceId" value="">
		      <th>资源名称:</th><td><input type="text" name="resourceName" value="" style="width:200px;"></td>
		   </tr>
		   <tr>
		      <th>资源路径:</th><td><input type="text" name="resourceUrl" value="" style="width:200px;"></td>
		   </tr>
		   <tr>
		     <th>资源类型:</th>
		     <td>
		        <select name="resourceType" style="width:205px;">
				  <option value ="public">公共资源</option>
				  <option value ="private">需要授权</option>
				</select>
		     </td>
		   </tr>
		  </table>
		  <div style="padding:5px;text-align:center;">
				<a id="saveBtn" href="javascript:void(0)" class="easyui-linkbutton" icon="icon-ok" onclick="">保存</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" icon="icon-cancel" onclick="javascript: $('#win').window('close');">取消</a>
		   </div>
	    </form>
	  </div> <!-- win -->
	  
	  
	</div> <!-- center -->
</body>
</html>