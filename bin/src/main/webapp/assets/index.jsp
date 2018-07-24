<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <%@ include  file="/assets/header.jsp"%>
   <title>智能终端管理系统</title>
   <script type="text/javascript">
		$(function(){
		
		 
		});
		
		function addTab(title, url){
			if ($('#TabsId').tabs('exists', title)){
				$('#TabsId').tabs('select', title);
			} else {
				var content = '<iframe scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';
				$('#TabsId').tabs('add',{
					title:title,
					content:content,
					closable:true
				});
			}
		}
		
		
			
	</script>
</head>
<body class="easyui-layout">
	<div region="north" border="false" class="rtitle">
		智能终端管理系统
	</div>
	<div region="west" title="系统功能" split="true" border="true" style="width:200px;background:#EAFDFF;">
	
		   <div class="easyui-accordion" style="width:200px;height:auto;">
				<div title="权限管理">
                    <ul>
                        <li><div><a href="javascript:void(0)" onclick="addTab('用户管理', '<%=request.getContextPath()%>/system/user/userList.do');">用户管理</a></div></li>
                        <li><div><a href="javascript:void(0)" onclick="addTab('角色管理', '<%=request.getContextPath()%>/system/role/roleList.do');">角色管理</a></div></li>
                        <li><div><a href="javascript:void(0)" onclick="addTab('资源管理', '<%=request.getContextPath()%>/system/resource/resourceList.do');">资源管理</a></div></li>
                    </ul>
                </div>
                <div title="播放管理">
                    <ul>
                        <li><div><a href="javascript:void(0)" onclick="addTab('播放端管理', '<%=request.getContextPath()%>/terminal/center.do');">播放端管理</a></div></li>
                    </ul>
                </div>
			</div>
	
	</div>
	<div region="center" border="false">
		  <div id="TabsId" class="easyui-tabs" style="width:auto;height:100%;">
			  <div title="Home"></div>  
          </div>
	</div>
</body>
</html>