<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<%@ include file="/layui/header.jsp"%>
   <title>权限管理列表</title>
   <meta name="renderer" content="webkit">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">  
</head>
<body onload="getTree()">
  <div style="width: 30%; float: left">
     <br><font  size="4">&nbsp;&nbsp;角色菜单树:</font><br><br>
     <ul id="demo2"></ul>
  </div>
  <div style="width: 70%; height: 100%; float: left">
     <fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;">
		<legend>资源列表</legend>
	 </fieldset>
	 <div>
	   <span style="margin-left: 2px;">&nbsp;&nbsp;&nbsp;&nbsp;<font  size="3">角色名:</font>
	     <select name="role" id="role" onchange="gradeChange()">
           <c:forEach items="${RoleOnce}" var = "role" varStatus = "status">
              <option value="${role.roleId}">${role.roleName}</option>
           </c:forEach>
         </select>
        </span>
	 </div>
	 <br>
	 <div>
	    <div class="layui-form-item"  id="listResource">
	       <c:forEach items="${listRs}" var = "r" varStatus = "status">
	          <label>
	            <input type="checkbox" name="rsFlag" value="${r.resourceId}" checked>
	            <font size='4'>${r.resourceName}</font>
	          </label>
	          <br>
	       </c:forEach>
	    </div>
	 </div>
	 <br>
	 <div>
	    <input class="layui-btn" type="button" onclick="saveRs()" id="btn-jan" value="保存">
	 </div>
  </div>
  
  <script type="text/javascript">
  layui.use(['layer', 'form'], function(){
	  var layer = layui.layer
	  form = layui.form;
	});
  
  var node = [];
  
  function getTree(){
		treeSearch();
	}
  
  function saveRs(){
	var roleId = document.getElementById("role").value;
	obj = document.getElementsByName("rsFlag");
  	var authorityData = [];
  	for(k in obj){
  		if(obj[k].checked){
  			authorityData.push(obj[k].value);
  		}
  	}
  	if(authorityData.length == 0){
  		layer.msg('请至少选择一项进行修改保存!!',{icon:7,time:2000});
  	}else{
		layer.confirm('确定修改?', {icon: 3, title:'提示'}, function(index){
			layer.close(index);
			$.ajax({
				type:"POST",
				url: "<%=request.getContextPath()%>/system/updateAuthority.do",
				data:{"roleId":roleId,"authorityList":authorityData},
				traditional: true,
				dataType: "json",
				success:function(data){
					var value = data.toString();
					if(value == "true"){
						layer.msg("保存成功",{icon:6,time:1500});
						treeSearch();
					}else if(value == "false"){
						layer.msg("保存失败",{icon:5,time:1500});
					}
				}
			});
		});
  	}
  }
  
  function gradeChange(){
	  var rid = document.getElementById("role").value;
	  $.ajax({
			type: "POST",
			url: "<%=request.getContextPath()%>/system/changeRole.do",
			data:{"rid":rid},
			dataType: "json",
			success: function(result){
				if(result.msg=="true"){
					console.log(666);
					var list1 = document.getElementById('listResource');
					list1.innerHTML = "";
					var flag = result.flag;
					var data = result.data;
					var flag = result.flag;
					for(var i = 0; i < data.length; i++){
						if(flag[i] == '1'){
							var newNode = document.createElement("div");
							var objDom = "<label><input type='checkbox' name='rsFlag' title='' value='" + data[i].resourceId + "' checked><font size='4'>" + data[i].resourceName + "</font></label>";
							newNode.innerHTML = objDom;
							list1.appendChild(newNode);
						}else if(flag[i] == '0'){
							var newNode = document.createElement("div");
							var objDom = "<label><input type='checkbox' name='rsFlag' title='' value='" + data[i].resourceId + "'><font size='4'>" + data[i].resourceName + "</font></label>";
							newNode.innerHTML = objDom;
							list1.appendChild(newNode);
						}
					}
				}
			}
	  });
  }
  
  function treeSearch(){
		$.ajax({
			type: "POST",
			url: "<%=request.getContextPath()%>/system/treeRole.do",
			dataType: "json",
			success: function(msg){
				for(var i = 0; i < msg.length; i++){
					node.push({
			            name:'' + msg[i].name,
			            id: '' + msg[i].id,
			            spread:'' + true
			        });
					if(msg[i].children.length > 0){
						var child = [];
						var ch = msg[i].children;
						for(var j = 0; j < ch.length; j++){
							child.push({
								name:'' + msg[i].children[j].name,
								id:'' + msg[i].children[j].id
							});
							if(ch[j].children.length > 0){
								var chi = [];
								var chil = ch[j].children;
								for(var k = 0; k < chil.length; k++){
									chi.push({
										name:'' + chil[k].name,
										id:'' + chil[k].id
									});
								}
							}
							child[j].children = chi;
						}
					}
					node[i].children = child;
				}
				
				layui.use(['tree', 'layer'], function(){
					  var layer = layui.layer
					  ,$ = layui.jquery; 
					  
					  layui.tree({
					    elem: '#demo2' //指定元素
					    ,target: '_blank' //是否新选项卡打开（比如节点返回href才有效）
					    ,click: function(item){ //点击节点回调
					      //layer.msg('当前节名称：'+ item.name + '<br>全部参数：'+ JSON.stringify(item));
					      //console.log(item);
					      var id = item.id;
					      var name = item.name
					      //document.getElementById("treeId").value = id;
					      //if(id.charAt(0) == 't'){
					    	  //document.getElementById("terminalName").innerText = name;
					    	//  document.getElementById("terminalName").value = name;
					      //}
					    }
					    ,nodes: node
					  });
				});
			}
		});
	}
  
  </script>
  
</body>
</html>