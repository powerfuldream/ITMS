<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <%@ include  file="/assets/header.jsp"%>
   <title>素材列表</title>
   <script type="text/javascript">
		$(function(){
		  initGrid();
		  //doSearch();
		});
		
		
		//实现对DataGird控件的绑定操作  
		function initGrid() {  
		    $('#MyDatagrid').datagrid({   //定位到Table标签，Table标签的ID是grid   
		        title: '素材列表',  
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
		        idField: 'mid',   
		        columns: [[  
		             { field: 'ck', checkbox: true },   //选择  
		             { title: '素材名称', field: 'materialName', width: 200},  
		             { title: '时长', field: 'duration', width: 100 },  
		             { title: '文件类型', field: 'fileType', width: 100, 
		                formatter: function(value,row,index) {
		                      if(value == 'vedio') return '视频';
		                      else if(value == 'picture') return '图片';
		                      else if(value == 'other') return '其他';
						       
						}
					 },
		             { title: '上传时间', field: 'uploadTime', width: 100,
                         formatter:function(value,row,index) {   
	                         return easyuiDateFormat(value);  
                         }
                     }
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
		   

		   value = $("#searchFileName").val();
		   if(value != "") {
		      key = "materialName";
		      symbol = "like"
		      value = "%" + value + "%";
		      params.push(key);  params.push(symbol); params.push(value);
		   }
		   
		   
		   value = $("#searchFileTypeSelect").val();
		   if(value != "") {
		      key = "fileType";
		      symbol = "="
		      params.push(key);  params.push(symbol); params.push(value);
		   }
		   
	
		    $.ajax({
			    url: '<%=request.getContextPath()%>/material/searchFile.do',
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
		
		
		function getSelectItmes() {
		     var rows = $('#MyDatagrid').datagrid('getSelections');
		     if(rows.length < 1)   $.messager.alert('提示', '请至少选择一个文件');
		     return rows;
		}
		
		
		
		
		
	</script>
</head>
<body class="easyui-layout">
	
	<div region="center" border="false" style="padding:5px;">
	  <div id="MyDatagrid"></div>
	  
	  <div id="tb"> <!-- datagrid 的工具栏  start -->
	
	    <form id="searchForm" style="padding:5px;">
	    
	     	<span>素材名称:</span>
			<input id="searchFileName" name="fileName" type="text" value="">
<!-- 			<span>文件类型:</span>
		    <select id="searchFileTypeSelect" name="fileType">
					   <option value=""></option>
					   <option value="vedio">视频</option>
					   <option value="picture">图片</option>
					   <option value="other">其他</option>
			</select> -->
			

			<a href="javascript:void(0)" class="easyui-linkbutton" plain="true" iconCls="icon-search" onclick="doSearch()">查询</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" plain="true" iconCls="icon-reload" onclick="searchReset()">重置</a>
	    </form>

	 </div>        <!-- datagrid 的工具栏  end -->

	  
	</div> <!-- center -->
</body>
</html>