<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <%@ include  file="/assets/header.jsp"%>
   <title>智能终端列表</title>
   
   <script type="text/javascript">
		$(function() {
			searchAreaTreeLoad();  //添加了新的地区的话, areaTree要跟着变
            pageSearchInit();
           // doSearch();
		});
		


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
		

		
		
		var searchAreaCode = "86";
		var currentAreaCode = "86";
		var page = {
		   "currentPage" : "1", // 当前页码
	       "pageSize" : "20" // 每页多少条数据
		};
		
		
		function searchAreaTreeLoad() {  
		
		     $.ajax({  
		        url: '<%=request.getContextPath()%>/area/buildTreeByTerminalTable.do',  
		        dataType: 'json'  
		    }).done(function(data){  
		        if(!data){  
		            return;  
		        }  
		        
		        //树的配置
		        var setting = {  
		          callback: {
                     onClick: function(event, treeId, treeNode) {  //重载点击事件
                        $('#searchAreaWin').window('close')
                        $("#searchAreaName").val(treeNode.name);
                        searchAreaCode = treeNode.id;
                     }
                  }
		        };
		       
		        //初始化首页的地区 
		        var searchAreaTree = $.fn.zTree.init($('#searchAreaTree'), setting, data); 
		
		    });  
		
		}
		
		
		
		function searchReset() {
		   $("#searchForm input").val("");
		   $("#searchStateSelect").val("");
		   searchAreaCode = "86";
		}
		
		
		function doSearch() {
		   var params = [];
		   var key, symbol, value;
		   
		   //序列号码
		   value = $("#searchSerialNumber").val();
		   if(value != "") {
		      key = "serialNumber";
		      symbol = "like"
		      value = "%" + value + "%";
		      params.push(key);  params.push(symbol); params.push(value);
		   }
		   
		   //名称
		   value = $("#searchTerminalName").val();
		   if(value != "") {
		      key = "terminalName";
		      symbol = "like"
		      value = "%" + value + "%";
		      params.push(key);  params.push(symbol); params.push(value);
		   }
		   
		   
		   //IP地址
		   value = $("#searchIp").val();
		   if(value != "") {
		      key = "ip";
		      symbol = "like"
		      value = "%" + value + "%";
		      params.push(key);  params.push(symbol); params.push(value);
		   }
		   
		   
		   //mac地址
		   value = $("#searchMacAddr").val();
		   if(value != "") {
		      key = "macAddr";
		      symbol = "like"
		      value = "%" + value + "%";
		      params.push(key);  params.push(symbol); params.push(value);
		   }
		   
		   
		   //状态
		   value = $("#searchStateSelect").val();
		   if(value != "") {
		      key = "state";
		      symbol = "="
		      params.push(key);  params.push(symbol); params.push(value);
		   }
		   
	
		    $.ajax({
			    url: '<%=request.getContextPath()%>/terminal/comon/searchTerminal/' + searchAreaCode + '.do',
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
			        currentAreaCode = searchAreaCode;
			     } else {
			        
			        if(data.failType == "noAuthority") {
			            $.messager.alert('提示', "你没有权限查询 " + $("#searchAreaName").val() + " 目录下的播放端信息");
			        } else {
			             $.messager.alert('提示', data.msg);
			        }
			        
			     }
		    });
		   
		   
		   
		}
		
		
		function network_formatter(value, node) {  //修改deleted的意思，让deleted = 1 为在线的意思
		   if(value == 1) return '<span style="color:green;">在线</span>';
		   else return '<span style="color:gray;">离线</span>';
		}
		
		
		
	    function getSelectItmes() {
		     var rows = $('#MyDatagrid').datagrid('getSelections');
		     if(rows.length < 1)   $.messager.alert('提示', '请至少选择一个播放端');
		     return rows;
		}
	
		
	
		
	</script>
</head>
<body class="easyui-layout">
	<div region="center" border="false">
		<div class="easyui-layout" fit="true" style="padding:5px;">
		    <table id="MyDatagrid" class="easyui-datagrid" style="width:auto;height:auto;"
					title="播放端列表" iconCls="icon-filter"
					idField="terminalId" pagination="true"
					striped="true"
					fit="true"  autoRowHeight="false"
					toolbar="#tb">
				 <thead>
					<tr>
					    <th field="ck" checkbox="true"></th>
					    <th field="deleted" width="80" data-options="formatter:network_formatter">联网情况</th>
						<th field="serialNumber" width="80">序列号码</th>
						<th field="terminalName" width="80">名称</th>
						<th field="terminalDescribe" width="80">描述</th>
					    <th field="ip" width="80">IP地址</th>
						<th field="macAddr" width="80">网卡地址</th>
						<th field="resolutionLength" width="80">电脑分辨率-长</th>
						<th field="resolutionWidth" width="80">电脑分辨率-宽</th>
						<th field="ledLength" width="80">LED-长</th>
						<th field="ledWidth" width="80">LED-宽</th>
						<th field="startSpotTop" width="80">LED起点-Top</th>
						<th field="startSpotLeft" width="80">LED起点-Left</th>
						<th field="runStartTime" width="80">运行开始时间</th>
						<th field="runEndTime" width="80">运行结束时间</th>
						<th field="areaCode" width="80">地区编号</th>
						<th field="areaName" width="100">地区全称</th>
						<th field="detailAddress" width="100">安装地址</th>
						<th field="state" width="80">状态</th>
					</tr>
				</thead>
			</table>
			
			<div id="tb">

			    <form id="searchForm" style="padding:5px;">
			    
		      		<span>序列号码:</span>
					<input id="searchSerialNumber" name="serialNumber" type="text" value="">
					<span>名称:</span>
					<input id="searchTerminalName" name="terminalName" type="text" value="">
					<span>IP地址:</span>
					<input id="searchIp" name="ip" type="text" value="">
					<br/>
					<span>网卡地址:</span>
					<input id="searchMacAddr" name="macAddr" type="text" value="">
			        <span>区域:</span>
		            <input id="searchAreaName" name="areaName" value="" onfocus="javascript:$('#searchAreaWin').window('open');"/>
		            <span>状态:</span>
					<select id="searchStateSelect" name="state">
					   <option value=""></option>
					   <option value="激活">激活</option>
					   <option value="禁用">禁用</option>
					</select>
		            
					<a href="javascript:void(0)" class="easyui-linkbutton" plain="true" iconCls="icon-search" onclick="doSearch()">查询</a>
					<a href="javascript:void(0)" class="easyui-linkbutton" plain="true" iconCls="icon-reload" onclick="searchReset()">重置</a>
	           </form>
			 
			</div> 
			
			<div id="searchAreaWin" class="easyui-window" title="选择查询区域" style="width:400px;height:180px;top:5%;left:20%;" closed="true">
              <ul class="ztree" id="searchAreaTree" style="width:200px;margin:5px;overflow:auto;"></ul>  
            </div>
			
		</div> <!-- easyui-layout  -->

	</div>     <!-- center -->
</body>
</html>