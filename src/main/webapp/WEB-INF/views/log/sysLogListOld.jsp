<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <%@ include  file="/assets/header.jsp"%>
   <title>系统日志列表</title>
   <script type="text/javascript">
		$(function(){
		  initGrid();
		  doSearch();
		});
		
		
		//实现对DataGird控件的绑定操作  
		function initGrid() {  
		    $('#MyDatagrid').datagrid({   //定位到Table标签，Table标签的ID是grid   
		        title: '系统日志列表',  
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
		        idField: 'sysLogId',   
		        columns: [[  
		             { field: 'ck', checkbox: true },   //选择  
		             { title: '播放端名称', field: 'terminalName', width: 100},  
		             { title: '日志内容', field: 'logContent', width: 200 },  
		             { title: '记录时间', field: 'recordDate', width: 100,
                         formatter:function(value,row,index) {   
	                         return easyuiDateFormat(value);  
                         }
                     },
                     { title: '公网IP', field: 'locateIp', width: 100 }
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
		}
		
		
		
		function doSearch() {
		   var params = [];
		   var whereSuffix = "";
		   var key, symbol, value;
		   

		   value = $("#searchTerminalName").val();
		   if(value != "") {
		      key = "terminalName";
		      symbol = "like"
		      value = "%" + value + "%";
		      params.push(key);  params.push(symbol); params.push(value);
		   }
		   
		   
		   value = $("#searchLocateIp").val();
		   if(value != "") {
		      key = "locateIp";
		      symbol = "like"
		      value = "%" + value + "%";
		      params.push(key);  params.push(symbol); params.push(value);
		   }
		  
		   
		   
		   value = $("#searchLogContent").val();
		   if(value != "") {
		      key = "logContent";
		      symbol = "like"
		      value = "%" + value + "%";
		      params.push(key);  params.push(symbol); params.push(value);
		   }
		   
		   
		   value = $("#searchRecordDate").val();
		   if(value != "") {
		     whereSuffix += " AND DATE_FORMAT(recordDate, '%Y-%m-%d') = '" + value + "'";
		   }
		
		   
	
		    $.ajax({
			    url: '<%=request.getContextPath()%>/logController/searchSysLog.do',
			    data: {"params": params, "currentPage" : page.currentPage, "pageSize" : page.pageSize, "whereSuffix": whereSuffix}, 
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
		
		
		function delSysLog(){
			var rows = $('#MyDatagrid').datagrid('getSelections');
		    if(rows.length < 1) {
		       $.messager.alert('提示', "请选择一行数据");
		       return;
		    } 
		    
		    
		    $.messager.confirm('提示框', '你确定要删除选中的日志?', function(r) {
		        if(!r) return;
			    var ids = [];
			    for(var i = 0; i < rows.length; i++) {
			      ids.push(rows[i].sysLogId);
			    }
			    
			    
			     $.ajax({
				    url: '<%=request.getContextPath()%>/logController/delSysLog.do',
				    data:{"ids": ids}, 
				    type: "post",
				    traditional: true,  
				    dataType : "json"
				  })
				  .done(function( data ) {
				     if(data.success) {
				       //提示修改成功
				       $.messager.alert('消息', "删除成功");
				     
				       //刷新表单
	                   doSearch();
				     
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
	
		    
		    });
		}
	</script>
</head>
<body class="easyui-layout">

	 <div region="center" border="false" style="padding:5px;">
	  <div id="MyDatagrid"></div>
	  <div id="tb"> <!-- datagrid 的工具栏  start -->
	
	    <form id="searchForm" style="padding:5px;">
	    
	     	
			<span>日志内容:</span>
			<input id="searchLogContent" name="logContent" type="text" value="">
			<span>播放端名称:</span>
			<input id="searchTerminalName" name="terminalName" type="text" value="">
			<span>公网IP:</span>
            <input id="searchLocateIp" name="locateIp" type="text" value="">
			<br/>
			<span>记录日期:</span>
            <input id="searchRecordDate" name="recordDate" type="text" value="" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',lang:'zh-cn'})">
           
			
         
			<a href="javascript:void(0)" class="easyui-linkbutton" plain="true" iconCls="icon-search" onclick="doSearch()">查询</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" plain="true" iconCls="icon-reload" onclick="searchReset()">重置</a>
	    </form>
	 
		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="delSysLog()">删除记录</a>
	  </div>     <!-- datagrid 的工具栏  end -->
	  
	  
</body>
</html>