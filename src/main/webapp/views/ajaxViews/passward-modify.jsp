<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta content="text/html;charset=UTF-8"/>
    <%@ include file="/layui/header.jsp"%>
    <script type="text/javascript" src="<%=request.getContextPath()%>/assets/jquery-validation-1.14.0/dist/jquery.validate.min.js"></script>
    <title>编辑用户</title>
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
      <input id="userIdInput" type="hidden" name="userId" value="" />
      
	 
	  
	  <div class="layui-form-item">
	    <label class="layui-form-label">新密码:</label>
	    <div class="layui-input-inline">
	      <input id="userPasswordId" type="password" name="userPassword" lay-verify="required" class="layui-input input-text" />
	    </div>
	  </div>
	  
	  <div class="layui-form-item">
	    <label class="layui-form-label">确认新密码:</label>
	    <div class="layui-input-inline">
	      <input type="password" name="userPassword2" lay-verify="required" class="layui-input input-text" />
	    </div>
	  </div>	  
  </form>
  
  <br><br>
  <hr class="layui-bg-green"/>
  <div class="layui-form-item">
    <div class="layui-input-block">
      <button class="layui-btn" onclick="editUserPassward()">修改</button>
      <button type="button" class="layui-btn layui-btn-primary" onclick="closeWind()">关闭</button>
    </div>
  </div>
<script type="text/javascript">
   
  
		
   
   function validateForm() {
      // 在键盘按下并释放及提交后验证提交表单
      return $("#applyform").validate({
	    rules: {
	      
	      userPassword: "required",
	      userPassword2: {
	        required: true,
	        equalTo: "#userPasswordId"
	      },
	   
	    },
	    messages: {
	      userPassword: "<span style='color:red;'>不能为空</span>",
	      userPassword2: {
	        required: "<span style='color:red;'>不能为空</span>",
	        equalTo: "<span style='color:red;'>两次密码不一样</span>"
	      }      
	    }}).form();
	}
   
   

   function closeWind(){
	   var index = parent.layer.getFrameIndex(window.name);
	   parent.layer.closeAll();
   }
 
	function editUserPassward() { 
		    if(!validateForm()) {
			   return ;
			}
		
             $.ajax({
			    url: '<%=request.getContextPath()%>/system/user/editUserPassword.do',
			    data:$("#applyform").serialize(), 
			    type: "post",
			    dataType : "json",
			  })
			  .done(function( data ) {
			     if(data.success) {
			        parent.layer.closeAll();
			        parent.layer.msg('修改成功,下次请用新密码登录',{icon:6,time:2000});
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
