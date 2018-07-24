<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <%@ include  file="/assets/header.jsp"%>
   <title>智能终端列表</title>
   <link href="<%=request.getContextPath()%>/assets/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
   <link href="<%=request.getContextPath()%>/layui/css/layui.css" rel="stylesheet">
   <script type="text/javascript" src="<%=request.getContextPath()%>/layui/layui.js"></script>
   <script type="text/javascript">
		$(function() {
			searchAreaTreeLoad();  //添加了新的地区的话, areaTree要跟着变
            pageSearchInit();
            doSearch();
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
		
		function operation(value, node){
			return "<input type='button' class='btn btn-success' id='resetstop" + value +"'  style='margin:2px;' onclick='stopTerminal(" +value+ ")' value='终止运行'/>";
		}
		
		//重启终端
		function restartTerminal(tid){
			var terminalId1 = tid;
			//alert(terminalId);
			
			$.messager.confirm('提示', '确定要重启终端!!', function(r){
				if(!r) return ;
			
			$.ajax({
				type: "POST",
				url: "<%=request.getContextPath()%>/playerController/restartTerminal.do",
				data:{"terminalId":terminalId1},
				dataType: "json",
				success: function(msg){
					var value = msg.toString();
					if(value == "true"){
						$.messager.alert('提示', "10秒内将重启终端运行");
						document.getElementById("resetstop").value="终止运行";
					}else if(value == "false"){
						$.messager.alert('提示', "终端未连接运行");
					}
				}
			});
		  });
		}
		
		//终止终端运行与重启
		function stopTerminal(tid){
			var terminalId = tid;
			//alert(terminalId);
			var btnValue = document.getElementById('resetstop'+tid).value;
			
			if(btnValue == '终止运行'){
				$.messager.confirm('提示', '确定要关闭终端!!', function(r){
					if(!r) return ;
				
				$.ajax({
					type: "POST",
					url: "<%=request.getContextPath()%>/playerController/stopTerminal.do",
					data:{"terminalId":terminalId},
					dataType: "json",
					success: function(msg){
						var value = msg.toString();
						if(value == "true"){
							$.messager.alert('提示', "10秒内将停止终端运行");
							document.getElementById('resetstop'+tid).value="重启终端";
						}else if(value == "false"){
							$.messager.alert('提示', "终端未连接运行");
						}
					}
				});
			  });
			}else if(btnValue == '重启终端'){
				$.messager.confirm('提示', '确定要重启终端!!', function(r){
					if(!r) return ;
				
				$.ajax({
					type: "POST",
					url: "<%=request.getContextPath()%>/playerController/restartTerminal.do",
					data:{"terminalId":terminalId},
					dataType: "json",
					success: function(msg){
						var value = msg.toString();
						if(value == "true"){
							$.messager.alert('提示', "10秒内将重启终端运行");
							document.getElementById('resetstop'+tid).value="终止运行";
						}else if(value == "false"){
							$.messager.alert('提示', "终端未连接运行");
						}
					}
				});
			  });
			}
			
<%-- 			$.messager.confirm('提示', '确定要关闭终端!!', function(r){
				if(!r) return ;
			
			$.ajax({
				type: "POST",
				url: "<%=request.getContextPath()%>/playerController/stopTerminal.do",
				data:{"terminalId":terminalId},
				dataType: "json",
				success: function(msg){
					var value = msg.toString();
					if(value == "true"){
						$.messager.alert('提示', "10秒内将停止终端运行");
						alert(document.getElementById("resetstop").value);
						document.getElementById("resetstop").value="重启终端";
					}else if(value == "false"){
						$.messager.alert('提示', "终端未连接运行");
					}
				}
			});
		  }); --%>
		}
		
	    function getSelectItmes() {
		     var rows = $('#MyDatagrid').datagrid('getSelections');
		     if(rows.length < 1)   $.messager.alert('提示', '请至少选择一个播放端');
		     return rows;
		}
	
	

	
	
	    function setPlayForTerminalInit() {
	        var rows = $('#MyDatagrid').datagrid('getSelections');
		    if(rows.length < 1) {
		       $.messager.alert('提示', "请选择一行数据");
		       return;
		    } 
		    
		    
		     $.ajax({
			    url: '<%=request.getContextPath()%>/playerController/findAllPlayTable.do',
			    type: "get",
			    dataType : "json",
			  })
			  .done(function( data ) {
			      if(data.success) {
			         $("#setPtableWinSelect").html('<option value="-1"></option>');
			          for(var i = 0; i < data.obj.length; i++) {
				         var ptable = data.obj[i];
				         $("#setPtableWinSelect").append('<option value="' + ptable.pid + '">' + ptable.pname +  '</option>');
				      }
				      $('#setPtableWin').window('open');
			      }  else {
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
	    
	    
	    function setPlayForTerminal() {
	        var rows = $('#MyDatagrid').datagrid('getSelections');
	        var terminalIds = [];
		    for(var i = 0; i < rows.length; i++) {
		      terminalIds.push(rows[i].terminalId);
		    }
		    
		     $.ajax({
			    url: '<%=request.getContextPath()%>/playerController/setPlayForTerminal.do',
			    data:{"terminalIds": terminalIds, "pid": $("#setPtableWinSelect").val()}, 
			    type: "post",
			    traditional: true,  
			    dataType : "json"
			  })
			  .done(function( data ) {
			     if(data.success) {
			       //提示修改成功
			       $.messager.alert('消息', "设置播表成功");
			     
			       //刷新表单
	               doSearch();
			     
			       //
			       $('#setPtableWin').window('close');
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
		
		function validateEditPasswordForm() {
		  
			 return $("#editConnectPasswordform").validate({
			    rules: {
			      connectPassword: "required",
			      connectPassword2: {
			        required: true,
			        equalTo: "#editConnectPasswordId"
			      }
			    },
			    messages: {
			      connectPassword: "不能为空",
			      connectPassword2: {
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
			    $("#editConnectPasswordform").form('clear');
			    $("#editConnectPasswordform input[name='terminalId']").val(row.terminalId);
			    $('#editConnectPasswordWin').window('open');
			}
		}
		
		
		function editConnectPassword() {
		
		     if(!validateEditPasswordForm()) {
			   return ;
			 }
			
             $.ajax({
			    url: '<%=request.getContextPath()%>/playerController/editConnectPassword.do',
			    data:$("#editConnectPasswordform").serialize(), 
			    type: "post",
			    dataType : "json",
			  })
			  .done(function( data ) {
			     if(data.success) {
			       $('#editConnectPasswordWin').window('close'); // close a window
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
		
		
		
	
		
	</script>
</head>
<body class="easyui-layout">
	<div region="center" border="false">
		<div class="easyui-layout" fit="true" style="padding:5px;">
		    <table id="MyDatagrid" class="easyui-datagrid" style="width:auto;height:auto;"
					title="播放端列表" iconCls="icon-filter"
					idField="terminalId" pagination="true"
					striped="true"
					fit="true"  autoRowHeight="true"
					toolbar="#tb">
				 <thead>
					<tr>
					    <th field="ck" checkbox="true"></th>
					    <th field="deleted" width="80" data-options="formatter:network_formatter">联网情况</th>
						<th field="serialNumber" width="80">序列号码</th>
						<th field="terminalName" width="110">播放端名称</th>
					<!--	<th field="pname" width="80">播表</th>   -->
						<th field="terminalDescribe" width="80">描述</th>
					    <th field="ip" width="80">IP地址</th>
						<th field="macAddr" width="80">网卡地址</th>
						<th field="resolutionLength" width="60">分辨率-长</th>
						<th field="resolutionWidth" width="60">分辨率-宽</th>
						<th field="ledLength" width="50">LED-长</th>
						<th field="ledWidth" width="50">LED-宽</th>
						<th field="startSpotTop" width="80">LED起点-Top</th>
						<th field="startSpotLeft" width="80">LED起点-Left</th>
						<th field="runStartTime" width="80">运行开始时间</th>
						<th field="runEndTime" width="80">运行结束时间</th>
						<th field="areaCode" width="80">地区编号</th>
						<th field="areaName" width="100">地区全称</th>
						<th field="detailAddress" width="100">安装地址</th>
						<th field="state" width="80">状态</th>
						<th field="terminalId" width="80" data-options="formatter:operation">操作</th>
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
			 
			  <!--  <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-save" plain="true" onclick="setPlayForTerminalInit()">设置播表</a>  -->
			   <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editPasswordInit()">重置连接密码</a>
			</div> 
			
			<div id="searchAreaWin" class="easyui-window" title="选择查询区域" style="width:400px;height:180px;top:5%;left:20%;" closed="true">
              <ul class="ztree" id="searchAreaTree" style="width:200px;margin:5px;overflow:auto;"></ul>  
            </div>
			
		</div> <!-- easyui-layout  -->
		
		
		
		<div id="setPtableWin" class="easyui-window" title="设置播表" style="width:250px;height:200px;" closed="true">
		  <form id="setPtableWinform" style="padding:15px 20px 10px 40px;">
           <table>
			   <tr>
			      <th>请选择播表:</th><td><select id="setPtableWinSelect"></select></td>
			   </tr>
		   </table>
		   <br/>
		   <div style="padding:5px;text-align:center;">
			   <a href="javascript:void(0)" class="easyui-linkbutton" icon="icon-ok" onclick="setPlayForTerminal();">保存</a>
			   <a href="javascript:void(0)" class="easyui-linkbutton" icon="icon-cancel" onclick="javascript: $('#setPtableWin').window('close');">取消</a>
		   </div>
		  </form>
        </div> <!-- setPtableWin  -->     
                  
        <div id="editConnectPasswordWin" class="easyui-window" title="重置连接密码" style="width:400px;height:350px;" closed="true">
			<form id="editConnectPasswordform" style="padding:10px 20px 10px 40px;">
			  <table>
			   <tr>
			      <input type="hidden" name="terminalId" value="">
			   </tr>
			   <tr>
			      <th>连接密码:</th><td><input id="editConnectPasswordId" type="password" name="connectPassword" value=""></td>
			   </tr>
			   <tr>
			      <th>确认密码:</th><td><input type="password" name="connectPassword2" value=""></td>
			   </tr>
			  </table>
			  <div style="padding:5px;text-align:center;">
					<a href="javascript:void(0)" class="easyui-linkbutton" icon="icon-ok" onclick="editConnectPassword()">确定</a>
					<a href="javascript:void(0)" class="easyui-linkbutton" icon="icon-cancel" onclick="javascript: $('#editConnectPasswordWin').window('close');">取消</a>
			   </div>
		    </form>
	   </div> <!-- editPasswordWin -->
	   
	   

	</div>     <!-- center -->
</body>
</html>