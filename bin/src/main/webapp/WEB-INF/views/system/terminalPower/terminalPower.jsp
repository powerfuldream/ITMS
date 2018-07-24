<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <%@ include  file="/assets/header.jsp"%>
   <title>终端权限配置</title>
   <script type="text/javascript">
		$(function() {
		  
		   initTerminalAreaTree();
           initRoleSelct();
		});
		
	
		 
		 function initTerminalAreaTree() { 

	         $.ajax({
			    url: '<%=request.getContextPath()%>/area/findAll.do',
			    type: "get",
			    dataType : "json",
				beforeSend: function () {
				    $.messager.progress({ 
				       title: '提示', 
				       msg: '较大量数据加载中，请稍候.....', 
				       text: '50%' 
				    });
			    },
			    complete: function () {
			        $.messager.progress('close');
			    }
			  })
			  .done(function( data ) {
			     if(data.success) {
			            console.log(new Date());
			            //组装地区的json数据, 使其可以显示在easyui的树中
				        var treeData = [];
				        for(var i = 0; i < data.obj.length; i++) {
				           
					           var area = {
					             "searchTerminal": "searchTerminal",
					             "addTerminal": "addTerminal",
					             "editTerminal": "editTerminal",
					             "delTerminal": "delTerminal",
					             "updateTerminalState": "updateTerminalState",
					             "state": "closed",
					             
					             "id": data.obj[i].code,
					             "_parentId": data.obj[i].parentCode,
					             "name": data.obj[i].name
					           }
					          if(area._parentId == "86") area._parentId = null;
		                      treeData.push(area);
				        }
				         console.log(new Date());
				        //把地区的数据显示到树中
				        $('#setPlayTerminalTable').treegrid('loadData', {"total":treeData.length, "rows": treeData});
				         console.log(new Date());
			     
		         } else {
				    $.messager.alert('消息', data.msg);
				 }
			   })
		 }
		 
		 
		 
		function initRoleSelct() {
		 
		    $.ajax({
			    url: '<%=request.getContextPath()%>/system/role/findAll.do',
			    type: "get",
			    dataType : "json",
			  })
			  .done(function( data ) {
			      $("#winRoleSelect").append('<option value="none">' + '未选择'  +  '</option>');
			      for(var i = 0; i < data.rows.length; i++) {
			         var role = data.rows[i];
			         $("#winRoleSelect").append('<option value="' + role.roleId + '">' + role.roleName +  '</option>');
			      }
			  })
			  .fail(function( xhr, status, errorThrown ) {
			    alert( "Sorry, there was a problem!" );
			    console.log( "Error: " + errorThrown );
			    console.log( "Status: " + status );
			    console.dir( xhr );
			  })
		
		}
		

		 
		 var terminalPower = {
		    "roleId": "",
		    "urls": []
		 }
		 
		 function setTerminalPowerInit() {
		     var roleId = $("#winRoleSelect").val();
		     if(roleId == "none") {
			   $("input:checkbox").prop('checked', false);  //清除原先的勾选状态
		       return;
		     }

			  $.ajax({
			    url: '<%=request.getContextPath()%>/system/setPlayTerminalInit.do',
			    data:{"roleId": roleId}, 
			    type: "get",
			    dataType : "json"
			  })
			  .done(function( data ) {
			     if(data.success) {
			       
			        //记录该角色拥有的播放端权限
			        terminalPower = {
					    "roleId": "",
					    "urls": []
					}
			        terminalPower.roleId = roleId;
			        
			        //清除原先的勾选状态
			        $("input:checkbox").prop('checked', false);
			        
			        
			        //让角色原先拥有的权限勾选出来
			        console.log(data.obj);
			        for(var i = 0; i < data.obj.length; i++) { 
			         // var arr = data.obj[i].resourceUrl.split("/");
			          //$("#" + arr[0] + "//" + arr[1]).prop('checked', true); 
			          $(document.getElementById(data.obj[i].resourceUrl)).prop('checked', true); 
			          terminalPower.urls.push(data.obj[i].resourceUrl);
			        }
			        
			        
			      
			     } else {
			        $.messager.alert('消息', data.msg);
			     }
			  })
			
		 }
		 
		 
		 
		  function setTerminalPower() {
		     var roleId = $("#winRoleSelect").val();
		     if(roleId == "none") {
			   $.messager.alert('消息', "请选择要配置的角色!");
		       return;
		     }

			  $.ajax({
			    url: '<%=request.getContextPath()%>/system/setPlayTerminal.do',
			    data: terminalPower, 
			    type: "post",
			    traditional: true,  
			    dataType : "json"
			  })
			  .done(function( data ) {
			     if(data.success) {
			       //提示配置成功
			        $.messager.alert('消息', "成功配置该角色的播放端权限!");
			     } else {
			        $.messager.alert('消息', data.msg);
			     }
			  })

		 }
		 
		 function resetTerminalPower() {  //清空原先的check
		   
             //清除原先的勾选状态
	         $("input:checkbox").prop('checked', false);
	         terminalPower.urls = [];
	         
		 }
		 
		 
		 
		 
		 
		 
		 
		 
		 function set_terminal_formatter(value, node) { 
		     var url = value + "/" + node.id;
			 var content = '<input id="' + url + '" onclick="checkTerminal(\'' + url +  '\')" type="checkbox"/>';
			 return content;
		}
		
	   /*	
	    function set_terminal_formatter2(value, node) { 
	        var sum = "";
	        for(var i = 0; i < value.length; i++) {
	            var url = value[i] + "/" + node.id;
			    var content = '<input id="' + url + '" onclick="checkTerminal(\'' + url +  '\')" type="checkbox" />';
			    sum += content;
	        }
		    
			return sum;
		}
		*/
		
		function checkTerminal(url) {
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
	
	<div region="center" border="false" style="padding:8px;overflow-y:auto;">
        <br/>
        <label for="roleSelect">配置的角色:</label><select id="winRoleSelect" name="roleSelect" onchange="setTerminalPowerInit()"></select>
        <br/><br/>
	    
		<table id="setPlayTerminalTable" title="播放端权限配置" class="easyui-treegrid" style="width:800px;height:500px" 
		       fitColumns="true" fit="true"
		       idField="id" treeField="name">
			<thead frozen="true">
				<tr>
					<th field="name" width="150">播放端所在地区</th>
				</tr>
			</thead>
			<thead>
				<tr>
					<th colspan="5">对应地区的权限授予情况</th>
				</tr>
				<tr>

					<th field="searchTerminal" width="120" align="center" data-options="formatter:set_terminal_formatter">允许查看播放端</th>
					<th field="addTerminal" width="120" align="center" data-options="formatter:set_terminal_formatter">允许添加播放端</th>
					<th field="editTerminal" width="120" align="center" data-options="formatter:set_terminal_formatter">允许修改播放端</th>
					<th field="delTerminal" width="120" align="center" data-options="formatter:set_terminal_formatter">允许删除播放端</th>
					<th field="updateTerminalState" width="120" align="center" data-options="formatter:set_terminal_formatter">允许更改播放端状态</th>
				  
				</tr>
			</thead>
		 </table>
	     <div style="padding:5px;text-align:center;">
				<a href="javascript:void(0)" class="easyui-linkbutton" icon="icon-ok" onclick="setTerminalPower();">保存</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" icon="icon-cancel" onclick="resetTerminalPower();">重置</a>
		 </div>
	  
	</div> <!-- center -->
	
	  
</body>
</html>