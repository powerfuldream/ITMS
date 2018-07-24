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
   <link href="<%=request.getContextPath()%>/assets/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
   <title>播表审核</title>
   <script type="text/javascript">
		$(function(){
		  initGrid();
		  doSearch();
		});
		
		
		//实现对DataGird控件的绑定操作  
		function initGrid() {  
		    $('#MyDatagrid').datagrid({   //定位到Table标签，Table标签的ID是grid   
		        title: '播表展示',  
		        iconCls: 'icon-save',  
		        nowrap: true,  
		        singleSelect : false,// 如果为true，则只允许选择一行。
		        autoRowHeight: true,  
		        striped: true,  
		        collapsible: true,  
		        fit : true,// datagrid自适应宽高
                fitColumns : true,// 使列自动展开/收缩到合适的数据表格宽度。
		        pagination: true,  
		        rownumbers: false,  
		        idField: 'pid',   
		        columns: [[  
		             { field: 'ck', checkbox: true },   //选择  
		             { title: '播表ID', field: 'pid', width: 40},
		             { title: '终端ID', field: 'terminalId', width: 40},
		             { title: '时段范围', field: 'periodId', width: 150 ,
	                        formatter: function(value) {
	                        	if(value == null) return "插播素材";
	                            var tm = $("#time"+value).val();
	                            return tm;
						   }
		             },
		             { title: '审核状态', field: 'statusId', width: 100,
						 formatter: function(value,row,index) {
		                      if(value == '1') return '未审核';
		                      else if(value == '2') return '已初审';
		                      else if(value == '3') return '已通过';
		                      else if(value == '4') return '未通过'
						}
		             },
		             { title: '播放日期', field: 'playDate', width: 70,
		            	 formatter : function(value){
                             var date = new Date(value);
                             var y = date.getFullYear();
                             var m = date.getMonth() + 1;
                             var d = date.getDate();
                             return y + '-' +m + '-' + d;
                         } },
                     { title: '播放总时长', field: 'playTotalTime', width: 70},
                     { title: '占屏比', field: 'screenRate', width: 70},
		             { title: '创建人', field: 'userId', width: 100 ,
	                        formatter: function(value) {
	                            var tm = $("#user"+value).val();
	                            return tm;
						   }
		             },
		             { title: '创建时间', field: 'createTime', width: 100,
                         formatter:function(value,row,index) {   
	                         return easyuiDateFormat(value);  
                         }
                     },
		             { title: '操作', field: 'deleted', width: 100,
                         formatter:function(value,row,index) {
                        	 return "<button type='button' class='btn btn-success'  style='margin:5px;' onclick='editPtableInit()'>审核</button>";
	                         /* return "<a href='#' onclick='editPtableInit()'>审核</a>"; */
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
		}
		
		
		
		function doSearch() {
		   var params = [];
		   var key, symbol, value;
		   

/* 		   value = $("#searchPname").val();
		   if(value != "") {
		      key = "pname";
		      symbol = "like"
		      value = "%" + value + "%";
		      params.push(key);  params.push(symbol); params.push(value);
		   } */
		   
		   value = $("#searchPlayStatusSelect").val();
		   if(value != "") {
		      key = "statusId";
		      symbol = "="
		      params.push(key);  params.push(symbol); params.push(value);
		   }
		   
	
		    $.ajax({
			    url: '<%=request.getContextPath()%>/ptable/searchUnckeckFirstPtable.do',
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
		
		function addPtableInit() {
		  document.location = "<%=request.getContextPath()%>/ptable/goAddPtable.do";
		}
		
	    function editPtableInit() {
	      	var rows = $('#MyDatagrid').datagrid('getSelections');
		    if(rows.length < 1) {
		       $.messager.alert('提示', "请选择要查看的播表");
		       return;
		    } else if(rows.length > 1) {
		       $.messager.alert('提示', "不能选择多行数据同时查看, 请只选择一行数据");
		       return;
		    }
	    
		    document.location = '<%=request.getContextPath()%>/ptable/goCheckPtable/' + rows[0].pid + '.do';
		}
		
		
		
	     function delPtable() {
	    	document.location = "<%=request.getContextPath()%>/ptable/ptableCheckList.do";  
		}
		
		
		function seePlayContent() {
		
		}
		
		
		function reloadCheck(){
			alert(2222);
		}
		
		
	</script>
</head>
<body class="easyui-layout">
	
	<c:forEach items="${periodL}" var="period" varStatus="status">
		<input type='hidden' id='i${period.periodId}'
			value="${period.periodName}">
		<input type="hidden" id='time${period.periodId}'
			value="${period.periodName}  ${period.startInterval}-${period.endInterval}">
	</c:forEach>
	
	<c:forEach items="${userL}" var="user" varStatus="status">
		<input type='hidden' id='user${user.userId}'
			value="${user.userName}">
	</c:forEach>
	
	<div region="center" border="false" style="padding:5px;">
	  <div id="MyDatagrid"></div>
	  
	  <div id="tb"> <!-- datagrid 的工具栏  start -->
	
<!--  	    <form id="searchForm" style="padding:5px;">
	    
	     	<span>播表名称:</span>
			<input id="searchPname" name="pname" type="text" value="">
			<span>审核状态:</span>
			<select id="searchPlayStatusSelect" name="fileStatus">
			           <option value=""></option>
					   <option value="1">未审核</option>
					   <option value="4">未通过</option>
					   <option value="2">已初审</option>
					   <option value="3">通过</option>
			</select>
		

			<a href="javascript:void(0)" class="easyui-linkbutton" plain="true" iconCls="icon-search" onclick="doSearch()">查询</a> 
	    </form> -->
			<a href="javascript:void(0)" class="easyui-linkbutton" plain="true" iconCls="icon-reload" onclick="delPtable()">刷新</a>
	    
<!-- 		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" plain="true" onclick="editPtableInit()">播表详情</a>  
 	    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addPtable()">插播</a> -->
<!-- 		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="delPtable()">删除播表</a> -->
		<!--  <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-sum" plain="true" onclick="seePlayContent()">播放内容</a>-->
	 </div>        <!-- datagrid 的工具栏  end -->

	  
	</div> <!-- center -->
</body>
</html>