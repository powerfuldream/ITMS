<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta content="text/html;charset=UTF-8"/>
    <%@ include file="/layui/header.jsp"%>
    <script type="text/javascript" src="<%=request.getContextPath()%>/assets/jquery-validation-1.14.0/dist/jquery.validate.min.js"></script>
    <title>编辑角色</title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
	<meta http-equiv ="Pragma" content = "no-cache"/>
	<meta http-equiv="Cache-Control" content="no cache" />
	<meta http-equiv="Expires" content="0" />
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1"/>
	<meta name="apple-mobile-web-app-status-bar-style" content="black"/>
	<meta name="apple-mobile-web-app-capable" content="yes"/>
	<meta name="format-detection" content="telephone=no"/>
</head>
<body>
  <div class="layui-fluid">
 
  <form id="applyform">
      <input id="roleIdInput" type="hidden" name="roleId" value="" />
      
	  <div class="layui-form-item">
	    <label class="layui-form-label">角色名称:</label>
	    <div class="layui-input-inline">
	      <input type="text" name="roleName" lay-verify="required" class="layui-input input-text" />
	    </div>
	  </div>
	  
	  <div class="layui-form-item">
	    <label class="layui-form-label">角色描述:</label>
	    <div class="layui-input-inline">
	      <input type="text" name="roleDescribe" lay-verify="required" class="layui-input input-text" />
	    </div>
	  </div>
	
	  
  </form>
  
  <br><br>
  <hr class="layui-bg-green"/>
  <div class="layui-form-item">
    <div class="layui-input-block">
      <button class="layui-btn" onclick="sure()"><i class="layui-icon">&#xe654;</i>保存</button>
      <button type="button" class="layui-btn layui-btn-primary" onclick="closeWind()">关闭</button>
    </div>
  </div>
<script type="text/javascript">

	
   function validateForm() {
      // 在键盘按下并释放及提交后验证提交表单
      return $("#applyform").validate({
	    rules: {
	      roleName: "required",
	      roleDescribe: "required"
	    },
	    messages: {
	      roleName: "<span style='color:red;'>不能为空</span>",
	      roleDescribe: "<span style='color:red;'>不能为空</span>"
	    }}).form();
	}	
		
   

   
   

   function closeWind(){
	   var index = parent.layer.getFrameIndex(window.name);
	   parent.layer.closeAll();
   }
   
   function sure() {
     var id = $("#roleIdInput").val();
     if(id == '' || id == null) {
        addRole();
     } else {
        editRole();
     }
   }
   
   
   function addRole() { 
	    if(!validateForm()) {
		   return ;
		}

         $.ajax({
		    url: '<%=request.getContextPath()%>/system/role/addRole.do',
		    data:$("#applyform").serialize(), 
		    type: "post",
		    dataType : "json",
		  })
		  .done(function( data ) {
		     if(data.success) {

		       parent.layer.closeAll();
			   parent.layer.msg('添加成功!',{icon:6,time:2000});
			   parent.refresh();

		     } else {
		         parent.layer.msg(data.msg, {icon:5,time:2000});
		     }
		  })
		  .fail(function( xhr, status, errorThrown ) {
		    alert( "Sorry, there was a problem!" );
		    console.log( "Error: " + errorThrown );
		    console.log( "Status: " + status );
		    console.dir( xhr );
		  })
		
	}
	 
	 
	 
	function editRole() { 
		    if(!validateForm()) {
			   return ;
			}
		
             $.ajax({
			    url: '<%=request.getContextPath()%>/system/role/editRole.do',
			    data:$("#applyform").serialize(), 
			    type: "post",
			    dataType : "json",
			  })
			  .done(function( data ) {
			     if(data.success) {
			        parent.layer.closeAll();
			        parent.layer.msg('修改成功!',{icon:6,time:2000});
			        parent.refresh();
			     
			     } else {
			          parent.layer.msg(data.msg, {icon:5,time:2000});
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
</div>
</body>
</html>
