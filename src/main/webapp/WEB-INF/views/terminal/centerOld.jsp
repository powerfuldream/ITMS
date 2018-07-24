<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <%@ include  file="/assets/header.jsp"%>
   <title>智能终端管理系统</title>
   
   <script type="text/javascript">
		$(function() {
			initAreaTree();
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
		


		
		function initAreaTree() {
		   //获取行政区数据  
		    $.ajax({  
		        url: '<%=request.getContextPath()%>/area/buildTree.do',  
		        dataType: 'json'  
		    }).done(function(data){  
		        if(!data) {  
		            return;  
		        }  

		        //添加/修改播放端的地区树
		        var xzqtree = $.fn.zTree.init($('#areaWinTree'), {
		           callback: {
                       onClick: function(event, treeId, treeNode) {
						    $("#winAreaCodeId").val(treeNode.id);
						    $("#winAreaNameId").val(treeNode.name);
						    $('#areaWin').window('close');
					   }
                   }
                }, data);  
                
              
                 //展开广东省的节点, 并选中广东省的节点
			    var guangDongNode = xzqtree.getNodeByParam('id', '440000');		//根据id值获得节点对象，我这里获得是id值为1的对象。
	            xzqtree.expandNode(guangDongNode, true, false);     //调用方法展开节点，第二个参数是：是否展开(要的就是这个)第三个参数是：是否影响全部子节点，我这里不需要。  
		        xzqtree.selectNode(guangDongNode);
                

		    });  
		}
		
		function validateForm() {
	      // 在键盘按下并释放及提交后验证提交表单
	      return $("#applyform").validate({
		    rules: {
		      serialNumber: "required",
		      terminalName: "required",
		      detailAddress: "required",
		      terminalDescribe: "required",
		      ip: "required",
		      macAddr: "required",
		      resolutionLength: {
		          required: true,
		          digits:true
		      },
		      resolutionWidth: {
		          required: true,
		          digits:true
		      },
		      ledLength: {
		          required: true,
		          digits:true
		      },
		      ledWidth: {
		          required: true,
		          digits:true
		      },
		      startSpotTop:{
		          required: true,
		          digits:true
		      },
		      startSpotLeft:{
		          required: true,
		          digits:true
		      },
		      runStartTime1: "required",
		      runEndTime1: "required"
		    },
		    messages: {
		      serialNumber: "不能为空",
		      terminalName: "不能为空",
		      detailAddress: "不能为空",
		      terminalDescribe: "不能为空",
		      ip: "不能为空",
		      macAddr: "不能为空",
		      resolutionLength: {
		          required: "不能为空",
		          digits:"必须输入整数"
		      },
		      resolutionWidth: {
		          required: "不能为空",
		          digits:"必须输入整数"
		      },
		      ledLength: {
		          required: "不能为空",
		          digits:"必须输入整数"
		      },
		      ledWidth: {
		          required: "不能为空",
		          digits:"必须输入整数"
		      },
		      startSpotTop:{
		          required:"不能为空",
		          digits:"必须输入整数"
		      },
		      startSpotLeft:{
		          required:"不能为空",
		          digits:"必须输入整数"
		      },
		      runStartTime1: "不能为空",
		      runEndTime1: "不能为空"
		    }}).form();
		
		
		}
		
		function addTerminalInit() {
		    $('.window-header .panel-title').eq(0).html("添加播放端");
		    $('.window-header .panel-title').eq(1).html("选择添加到的区域");
		    
		    //保存原先的地区信息，在clear后还原
		    var tempAreaCode = $("#winAreaCodeId").val();
		    var tempAreaName = $("#winAreaNameId").val();
		    $("#applyform").form('clear');
		    $("#winAreaCodeId").val(tempAreaCode);
		    $("#winAreaNameId").val(tempAreaName);
		    
		    $("#saveBtn").attr("onclick", "addTerminal()");
		    $('#win').window('open');
		}
		
		
		function addTerminal() { 
		    if(!validateForm()) {
			   return ;
			}
		
            $("#runStartTime").val("Sat Jul 29 2017 " + $("#runStartTime1").val() + " GMT+0800 (中国标准时间)");
            $("#runEndTime").val("Sat Jul 29 2017 " + $("#runEndTime1").val() + " GMT+0800 (中国标准时间)");
             $.ajax({
			    url: '<%=request.getContextPath()%>/terminal/addTerminal/' +  $("#winAreaCodeId").val() + '.do',
			    data:$("#applyform").serialize(), 
			    type: "post",
			    dataType : "json",
			  })
			  .done(function( data ) {
			     if(data.success) {
			       //刷新页面
			       doSearch();
			       // close a window
			       $('#win').window('close'); 
			       //提示添加成功
			       $.messager.alert('提示', "添加成功!");
			       
			       checkSearchAreaTreeNeedUpdate($("#winAreaCodeId").val());  //如果不存在该结点，就从数据库中重新加载searchAreaTree
			     
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
		
		
		function editTerminalInit() {
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
				$('.window-header .panel-title').eq(0).html("修改播放端");
				$('.window-header .panel-title').eq(1).html("重新选择区域");
			    $("#applyform").form('load', row);
			    $("#saveBtn").attr("onclick", "editTerminal()");
                $("#runStartTime1").val($("#runStartTime").val());
                $("#runEndTime1").val($("#runEndTime").val());
			    $('#win').window('open');
			}
		}
		
	
	
		function editTerminal() { 
		    if(!validateForm()) {
			   return ;
			}
		
            $("#runStartTime").val("Sat Jul 29 2017 " + $("#runStartTime1").val() + " GMT+0800 (中国标准时间)");
            $("#runEndTime").val("Sat Jul 29 2017 " + $("#runEndTime1").val() + " GMT+0800 (中国标准时间)");
             $.ajax({
			    url: '<%=request.getContextPath()%>/terminal/editTerminal/' +  $("#winAreaCodeId").val() + '.do',
			    data:$("#applyform").serialize(), 
			    type: "post",
			    dataType : "json",
			  })
			  .done(function( data ) {
			     if(data.success) {
			       //刷新表单
                   doSearch();
			  
			       //关闭原先的弹窗
			       $('#win').window('close'); 
			  
			       //提示修改成功
			       $.messager.alert('消息', "修改成功");
			       
			       checkSearchAreaTreeNeedUpdate($("#winAreaCodeId").val());  //如果不存在该结点，就从数据库中重新加载searchAreaTree
			     
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
		
	
		
		
		function delTerminal() {
		    var rows = $('#MyDatagrid').datagrid('getSelections');
		    if(rows.length < 1) {
		       $.messager.alert('提示', "请选择一行数据");
		       return;
		    } 
		    
		    
		    $.messager.confirm('提示框', '你确定要删除选中的数据?',function(r) {
		        if(!r) return;
			    var terminalIds = [];
			    var areaCodes = [];
			    for(var i = 0; i < rows.length; i++) {
			      terminalIds.push(rows[i].terminalId);
			      if($.inArray(rows[i].areaCode, areaCodes)==-1) {
				　　　　areaCodes.push(rows[i].areaCode);
				　　}
			    }
			    
		
			    
			     $.ajax({
				    url: '<%=request.getContextPath()%>/terminal/delTerminal/' +  currentAreaCode + '.do',
				    data:{"terminalIds": terminalIds, "areaCodes": areaCodes}, 
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
		
		
		function updateTerminalState(state) {
		    var rows = $('#MyDatagrid').datagrid('getSelections');
		    if(rows.length < 1) {
		       $.messager.alert('提示', "请选择一行数据");
		       return;
		    } 
		
		    var terminalIds = [];
		    var areaCodes = [];
		    for(var i = 0; i < rows.length; i++) {
		      terminalIds.push(rows[i].terminalId);
		      if($.inArray(rows[i].areaCode, areaCodes)==-1) {
			　　　　areaCodes.push(rows[i].areaCode);
			　　}
		    }
		    
		    
		    
		    
		     $.ajax({
			    url: '<%=request.getContextPath()%>/terminal/updateTerminalState/' +  currentAreaCode + '.do',
			    data:{"terminalIds": terminalIds, "state":state, "areaCodes":areaCodes}, 
			    type: "post",
			    traditional: true,  
			    dataType : "json"
			  })
			  .done(function( data ) {
			     if(data.success) {
			       			       //提示修改成功
			       if(state == '1') {
			          $.messager.alert('消息', "激活成功");
			       } else {
			          $.messager.alert('消息', "禁用成功");
			       }
			     
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
		}
		
		
		var searchAreaTree;
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
		        searchAreaTree = $.fn.zTree.init($('#searchAreaTree'), setting, data); 
		
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
			    url: '<%=request.getContextPath()%>/terminal/searchTerminal/' + searchAreaCode + '.do',
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
		
		
		
		function checkSearchAreaTreeNeedUpdate(areaCode) {  //判断searchAreaTree需不需要重新加载
		    if(searchAreaTree.getNodeByParam('id', areaCode) == null) {  //如果不存在该结点，就从数据库中重新加载searchAreaTree
		       searchAreaTreeLoad();
		    }
		}
		
		
		
		
		//传输文件
		function transferInit() {
		    var rows = $('#MyDatagrid').datagrid('getSelections');
		    if(rows.length < 1) {
		       $.messager.alert('提示', "请选择一行数据");
		       return;
		    } 
		    
		    $('#transferWin').window('open');
		}
		
		function transferStart() {
		    var rows = $("#transferIframe").contents().find("#MyDatagrid").datagrid('getSelections');
		    if(rows.length < 1) {
		       $.messager.alert('提示', "请选择一行数据");
		       return;
		    } else {
		        $.messager.alert('提示', "请选择一行数据");
		    }
		}
		
		
		function transferReset() {
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
						<!--  <th field="terminalId" width="80">播放端编号</th> -->
						<th field="serialNumber" width="80">序列号码</th>
						<th field="terminalName" width="80">名称</th>
						<th field="terminalDescribe" width="80">描述</th>
					    <th field="ip" width="80">IP地址</th>
						<th field="macAddr" width="80">网卡地址</th>
						<th field="resolutionLength" width="80">分辨率-长</th>
						<th field="resolutionWidth" width="80">分辨率-宽</th>
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
					<span>网卡地址:</span>
					<input id="searchMacAddr" name="macAddr" type="text" value="">
					<br/>
					
			        <span>所在区域:</span>
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
			   
		  	
			
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addTerminalInit()">添加</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editTerminalInit()">修改</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-tip" plain="true" onclick="updateTerminalState(1)">激活</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-undo" plain="true" onclick="updateTerminalState(0)">禁用</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="delTerminal()">删除</a>
				<!--  
				<a href="javascript:void(0)" class="easyui-linkbutton" plain="true" onclick="transferInit()"><i class="fa fa-paper-plane-o"></i><span style="margin-left:2px;">传输文件</span></a>
			    -->
			</div>
			
		</div>
		
		
		<div id="win" class="easyui-window" title="添加播放端" style="width:600px;height:350px;" closed="true">
			<form id="applyform" style="padding:10px 20px 10px 40px;">
			  <table>
			   <tr>
			     <input id="winAreaCodeId" type="hidden" name="areaCode" value="440000">
			     <th id="winAreaNameThId">所在地区:</th><td><input id="winAreaNameId" type="text" name="areaName" value="广东省" onfocus="javascript:$('#areaWin').window('open');"></td>
			   </tr>
			   <tr>
			     <th>序列号:</th><td><input type="text" name="serialNumber" value=""></td>
			     <th>播发端名称:</th><td><input type="text" name="terminalName" value=""></td>
			   </tr>
			   <tr>
			     <th>安装地址:</th><td><input type="text"  name="detailAddress" value=""></td>
			     <th>播发端描述:</th><td><input type="text" name="terminalDescribe" value=""></td>
			   </tr>
			   <tr>
			     <th>IP地址:</th><td><input type="text" name="ip" value=""></td>
			     <th>Mac地址:</th><td><input type="text" name="macAddr" value=""></td>
			   </tr>
			   <tr>
			     <th>分辨率-长:</th><td><input type="text" name="resolutionLength" value=""></td>
			     <th>分辨率-宽:</th><td><input type="text" name="resolutionWidth" value=""></td>
			   </tr>
			   <tr>
			     <th>LED-长:</th><td><input type="text" name="ledLength" value=""></td>
			     <th>LED-宽:</th><td><input type="text" name="ledWidth" value=""></td>
			   </tr>
			   <tr>
			     <th>LED起点-Top:</th><td><input type="text" name="startSpotTop" value=""></td>
			     <th>LED起点-Left:</th><td><input type="text" name="startSpotLeft" value=""></td>
			   </tr>
			   <tr>
			     <th>运行开始时间:</th><td><input type="text" id="runStartTime1" name="runStartTime1" class="Wdate moninput"  value=""
                     onclick="WdatePicker({dateFmt:'HH:mm:ss',lang:'zh-cn',maxDate:'#F{$dp.$D(\'runEndTime1\')}'})"/></td>
			     <th>运行结束时间:</th><td><input type="text" id="runEndTime1" name="runEndTime1" class="Wdate moninput"      value=""
                     onclick="WdatePicker({dateFmt:'HH:mm:ss',lang:'zh-cn',minDate:'#F{$dp.$D(\'runStartTime1\')}'})"/></td>
			  
			       <input type="hidden" name="terminalId" value="">
			       <input type="hidden" id="runStartTime" name="runStartTime" value="">
			       <input type="hidden" id="runEndTime" name="runEndTime" value="">
			     
			   </tr>
			  </table>
				
				
				<div style="padding:5px;text-align:center;">
					<a id="saveBtn" href="javascript:void(0)" class="easyui-linkbutton" icon="icon-ok" onclick="">保存</a>
					<a href="javascript:void(0)" class="easyui-linkbutton" icon="icon-cancel" onclick="javascript: $('#win').window('close');">取消</a>
				</div>
			</form>
	    </div> <!-- win -->

        <div id="areaWin" class="easyui-window" title="重新选择区域" style="width:400px;height:430px;" closed="true">
              <ul class="ztree" id="areaWinTree" style="width:200px;margin:5px;overflow:auto;"></ul>  
        </div>
        
        
        <div id="searchAreaWin" class="easyui-window" title="选择查询区域" style="width:400px;height:430px;" closed="true">
              <ul class="ztree" id="searchAreaTree" style="width:200px;margin:5px;overflow:auto;"></ul>  
        </div>
        
        
        <div id="transferWin" class="easyui-window" title="选择传输的文件" style="width:800px;height:400px;" closed="true">
            <iframe id="transferIframe" src="<%=request.getContextPath()%>/file/transferFileList.do" width="100%" height="90%"></iframe> 
            <div style="padding:5px;text-align:center;">
				<a href="javascript:void(0)" class="easyui-linkbutton" icon="icon-ok" onclick="transferStart();">传输开始</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" icon="icon-reload" onclick="">重新选择</a>
		    </div>
        </div>

	</div>
</body>
</html>