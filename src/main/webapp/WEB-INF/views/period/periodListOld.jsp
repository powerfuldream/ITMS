<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <%@ include  file="/assets/header.jsp"%>
   <title>时段管理</title>
   <script type="text/javascript" src="<%=request.getContextPath()%>/file/laydate/laydate.js"></script>
   <script type="text/javascript">
 laydate.render({
	  elem: '#testDate'
	  ,type: 'time'
	  ,range: true
	});
 
 laydate.render({
	  elem: '#testDate1'
	  ,type: 'time'
	  ,range: true
	});
</script>
   
   <script type="text/javascript">
		$(function(){
		  initGrid();
		  doSearch();
		});
		
		
		//实现对DataGird控件的绑定操作  
		function initGrid() {  
		    $('#MyDatagrid').datagrid({   //定位到Table标签，Table标签的ID是grid   
		        title: '时段列表',  
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
		        idField: 'periodId',   
		        columns: [[  
		             { field: 'ck', checkbox: true },   //选择  
		             { title: '时段名', field: 'periodName', width: 200},  
		             { title: '开始时间', field: 'startInterval', width: 200 },  
					 { title: '结束时间', field: 'endInterval', width: 200 },
					 { title: '备注', field: 'mark', width: 200 },
		        ]],  
                toolbar: '#tb'
		    });		    
		    pageSearchInit();
		};  
		
		
	
		
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
		   $("#searchFileTypeSelect").val("");
		}
		
		
		
		function doSearch() {
		   var params = [];
		   var key, symbol, value;
		   

/* 		   value = $("#searchFileName").val();
		   if(value != "") {
		      key = "fileName";
		      symbol = "like"
		      value = "%" + value + "%";
		      params.push(key);  params.push(symbol); params.push(value);
		   }
		   
		   
		   value = $("#searchFileTypeSelect").val();
		   if(value != "") {
		      key = "fileType";
		      symbol = "="
		      params.push(key);  params.push(symbol); params.push(value);
		   } */
		   
	
		    $.ajax({
			    url: '<%=request.getContextPath()%>/period/searchPeriod.do',
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
		
		
		function addPeriod() {
		    $('.window-header .panel-title').html("添加时段");
		    $("#fileApplyform").form('clear');
		    $("#saveFileBtn").attr("onclick", "addP()");
		    $('#periodWin').window('open');
 		}
		
		function addP(){
//			alert(111);
			var str = $("#periodName").val();
 			var timeStr = $("#testDate").val();
			var mark = $("#mark").val();
			if(str=="" || timeStr==""){
				$.messager.alert('提示', '时段名和时段不能为空');
			}else{
				var formData = new FormData();
				formData.append("periodName", str);
				formData.append("timeStr", timeStr);
				formData.append("mark", mark);
						$.ajax({
							type : "POST",
							url : "<%=request.getContextPath()%>/period/addPeriod.do",
							data : formData,
							processData : false,
							contentType : false,
							dataType : "json",
							success : function(date) {
								var value = date.toString();
							     if(value=="true") {
									   initGrid();
									   doSearch();
								       $('#periodWin').window('close'); // close a window
								       $.messager.alert('提示', '添加成功');
								     }else if(value=="false"){
								    	 $.messager.alert('提示', '存在同名时段，请重新命名!!');
								     }else if(value=="1"){
								    	 $.messager.alert('提示', '前后时段有误!!');
								     } else {
								         $.messager.alert('提示', '添加失败');
								     }
							}
						}); 
					}
				}
		
		function editPeriod(){
			var rows = $('#MyDatagrid').datagrid('getSelections');
			if(rows.length!=1){
				$.messager.alert('提示', '请选择具体要修改的时段');
				return ;
			}else{
			    $('.window-header .panel-title').html("修改时段");
			    $("#editFileApplyform").form('clear');
			    $("#editFileBtn").attr("onclick", "editP()");
			    $('#editPeriodWin').window('open');
			}
		}
			
	    function editP(){
	    	var rows = $('#MyDatagrid').datagrid('getSelections');
			var periodId1 = rows[0].periodId;
	    	var str1 = $("#periodName1").val();
 			var timeStr1 = $("#testDate1").val();
			var mark1 = $("#mark1").val();
			var formData1 = new FormData();
			formData1.append("periodId", periodId1);
			formData1.append("periodName", str1);
			formData1.append("timeStr", timeStr1);
			formData1.append("mark", mark1);
			if(str1 == "" && timeStr1 == "" && mark1 == ""){
				$('#editPeriodWin').window('close');
				return;
			}
			$.ajax({
				type : "POST",
				url : "<%=request.getContextPath()%>/period/editPeriod.do",
				data : formData1,
				processData : false,
				contentType : false,
				dataType : "json",
				success : function(date) {
					var value = date.toString();
				     if(value=="true") {
						   initGrid();
						   doSearch();
					       $('#editPeriodWin').window('close'); // close a window
					       $.messager.alert('提示', '修改成功');
					     }else if(value=="false"){
					    	 $.messager.alert('提示', '存在同名时段，请重新命名!!');
					     }else if(value=="1"){
					    	 $.messager.alert('提示', '前后时段有误!!');
					     } else {
					         $.messager.alert('提示', '修改失败');
					     }
				}
			});
	    }
		
		
		function delPeriod(){
			var rows = $('#MyDatagrid').datagrid('getSelections');
			if(rows.length<1){
				$.messager.alert('提示', '请选择要删除的时段');
				return ;
			}
			
			$.messager.confirm('提示', '确定要删除!!', function(r){
				if(!r) return ;
				
				var periodId = [];
				
				for(var i=0;i<rows.length;i++){
					periodId.push(rows[i].periodId);
				}
				
				$.ajax({
					type: "POST",
					url: "<%=request.getContextPath()%>/period/delPeriod.do",
					data: {"periodId":periodId},
					traditional: true,
					dataType : "json",
					success : function(msg){
						var value = msg.toString();
						if(value=="true"){
							initGrid();
							doSearch();
							$.messager.alert('提示', '删除成功');
						}else{
							$.messager.alert('提示', '删除失败');
						}
					}
				});
			})
		}
			</script>
</head>
<body class="easyui-layout">
<%-- 	<input type="hidden" id="tid" value="${ sessionScope.terminalsOne}"> --%>
	<input type="hidden" id="tid" value="isNull">
	<div region="center" border="false" style="padding:5px;">
	  <div id="MyDatagrid"></div>
	  
	  <div id="tb"> <!-- datagrid 的工具栏  start -->
	  
	  <div id="periodWin" class="easyui-window" title="添加时段" style="width:400px;height:350px;" closed="true">
		<form id="fileApplyform" style="padding:30px 20px 10px 40px;" enctype="multipart/form-data">
		  <table width="100%" border="0">
             <tr>
                 <th align="right" width="100px">时段名:</th>
                 <th><input type="text" name="periodName" id="periodName" width="120px"></th>
              </tr>
              <tr>
                 <td align="right" width="100px">&nbsp;</td>
                 <td>&nbsp;</td>
              </tr>              
              <tr>
                 <td align="right" width="100px">时段范围:</td>
                 <td>				
                 <input type="text" id="testDate"></td>
                 <td>&nbsp;</td>
              </tr>
              <tr>
                 <td align="right" width="100px">&nbsp;</td>
                 <td>&nbsp;</td>
              </tr>
              <tr>
                 <td align="right" width="100px">备注:</td>
                 <td>
                 <input type="text" id="mark"></td>
              </tr>
              <tr>
                 <td align="right" width="100px">&nbsp;</td>
                 <td>&nbsp;</td>
              </tr>
           </table>
           <br><br>
           
		  <div style="padding:5px;text-align:center;">
				<a id="saveFileBtn" href="javascript:void(0)" class="easyui-linkbutton" icon="icon-ok" onclick="">添加</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" icon="icon-cancel" onclick="javascript: $('#periodWin').window('close');">取消</a>
		   </div>
		   <div>
		       <video id="myvideo" width="1px"></video>
		   </div>
	    </form>
	  </div> <!-- fileWin -->
	  
	  
	  <div id="editPeriodWin" class="easyui-window" title="修改时段" style="width:400px;height:350px;" closed="true">
		<form id="editFileApplyform" style="padding:30px 20px 10px 40px;" >
		  <table width="100%" border="0">
             <tr>
                 <th align="right" width="100px">时段名:</th>
                 <th><input type="text" name="periodName1" id="periodName1" width="120px" value=""></th>
              </tr>
              <tr>
                 <td align="right" width="100px">&nbsp;</td>
                 <td>&nbsp;</td>
              </tr>              
              <tr>
                 <td align="right" width="100px">时段范围:</td>
                 <td>				
                 <input type="text" id="testDate1"></td>
                 <td>&nbsp;</td>
              </tr>
              <tr>
                 <td align="right" width="100px">&nbsp;</td>
                 <td>&nbsp;</td>
              </tr>
              <tr>
                 <td align="right" width="100px">备注:</td>
                 <td>
                 <input type="text" id="mark1">
                 </td>
              </tr>
              <tr>
                 <td align="right" width="100px">&nbsp;</td>
                 <td>&nbsp;</td>
              </tr>
           </table>
           <br><br>
		  <div style="padding:5px;text-align:center;">
				<a id="editFileBtn" href="javascript:void(0)" class="easyui-linkbutton" icon="icon-ok" onclick="">保存</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" icon="icon-cancel" onclick="javascript: $('#editPeriodWin').window('close');">取消</a>
		   </div>
	    </form>
	  </div> <!-- fileWin -->
	    
	    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addPeriod()">添加</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editPeriod()">修改</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="delPeriod()">删除</a>
	 </div>        <!-- datagrid 的工具栏  end -->

	  
	</div> <!-- center -->
</body>
</html>