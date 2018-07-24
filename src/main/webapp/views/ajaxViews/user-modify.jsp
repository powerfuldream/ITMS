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
  <input id="roleNameInput" type="hidden" value="" />
  <form id="applyform">
      <input id="userIdInput" type="hidden" name="userId" value="" />
      
	  <div class="layui-form-item">
	    <label class="layui-form-label">账号：</label>
	    <div class="layui-input-inline">
	      <input type="text" name="userAccount" lay-verify="required" class="layui-input input-text" />
	    </div>
	  </div>
	  
	  <div class="layui-form-item">
	    <label class="layui-form-label">密码：</label>
	    <div class="layui-input-inline">
	      <input id="userPasswordId" type="password" name="userPassword" lay-verify="required" class="layui-input input-text" />
	    </div>
	  </div>
	  
	  <div class="layui-form-item">
	    <label class="layui-form-label">确认密码：</label>
	    <div class="layui-input-inline">
	      <input type="password" name="userPassword2" lay-verify="required" class="layui-input input-text" />
	    </div>
	  </div>
	    
	  
	  <div class="layui-form-item">
			<label class="layui-form-label">角色：</label>
			<div class="layui-input-inline"
				style="width: 140px; height: 35px;">
				<select id="winRoleSelect" name="role.roleId" style="width: 140px; height: 35px;">
				</select>
			</div>
	  </div>
	  
	  
	  
	  <div class="layui-form-item">
	    <label class="layui-form-label">昵称：</label>
	    <div class="layui-input-inline">
	      <input type="text" name="userName" lay-verify="required" class="layui-input input-text" />
	    </div>
	  </div>
	  
	  <div class="layui-form-item">
	    <label class="layui-form-label">电话：</label>
	    <div class="layui-input-inline">
	      <input type="text" name="cellphone" lay-verify="phone" class="layui-input input-text" />
	    </div>
	  </div>
	  
	  <div class="layui-form-item">
	    <label class="layui-form-label">邮箱：</label>
	    <div class="layui-input-inline">
	      <input type="text" name="email" lay-verify="email" class="layui-input input-text" />
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
   
   $(function(){
	  initRoleSelct();
	  // 手机号码验证
	jQuery.validator.addMethod("isMobile", function(value, element) {
	    var length = value.length;
	    var mobile = /^(13[0-9]{9})|(18[0-9]{9})|(14[0-9]{9})|(17[0-9]{9})|(15[0-9]{9})$/;
	    return this.optional(element) || (length == 11 && mobile.test(value));
	 }, "请正确填写您的手机号码");
   });
		
   
   function validateForm() {
      // 在键盘按下并释放及提交后验证提交表单
      return $("#applyform").validate({
	    rules: {
	      userAccount: "required",
	      userPassword: "required",
	      userPassword2: {
	        required: true,
	        equalTo: "#userPasswordId"
	      },
	      'role.roleId': "required",
	      userName: "required",
	      cellphone: {
	         //required: true,
	         isMobile : true
	      },
	      email: {
                 //required: true,
                 email: true
              }
	    },
	    messages: {
	      userAccount: "<span style='color:red;'>不能为空</span>",
	      userPassword: "<span style='color:red;'>不能为空</span>",
	      userPassword2: {
	        required: "<span style='color:red;'>不能为空</span>",
	        equalTo: "<span style='color:red;'>两次密码不一样</span>"
	      },
	      'role.roleId': "<span style='color:red;'>不能为空</span>",
	      userName: "<span style='color:red;'>不能为空</span>",
	      cellphone: {
	         required: "<span style='color:red;'>不能为空</span>",
	         isMobile: "<span style='color:red;'>电话格式错误</span>"
	      },
	      email: {
                 required: "<span style='color:red;'>不能为空</span>",
                 email: "<span style='color:red;'>邮箱格式错误</span>"
              }
	    }}).form();
	}
   
   

   function closeWind(){
	   var index = parent.layer.getFrameIndex(window.name);
	   parent.layer.closeAll();
   }
   
   function sure() {
     var userId = $("#userIdInput").val();
     if(userId == '' || userId == null) {
        addUser();
     } else {
        editUser();
     }
   }
   
   
   function addUser() { 
	    if(!validateForm()) {
		   return ;
		}

         $.ajax({
		    url: '<%=request.getContextPath()%>/system/user/addUser.do',
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
	 
	 
	 
	function editUser() { 
		    if(!validateForm()) {
			   return ;
			}
		
             $.ajax({
			    url: '<%=request.getContextPath()%>/system/user/editUser.do',
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
	 
	 
 	function initRoleSelct() {
	 
	    $.ajax({
		    url: '<%=request.getContextPath()%>/system/role/findAll.do',
		    type: "get",
		    dataType : "json",
		  })
		  .done(function( data ) {
		      for(var i = 0; i < data.rows.length; i++) {
		         var role = data.rows[i];
		         //添加或者修改用户时让其选择角色框
		         $("#winRoleSelect").append('<option value="' + role.roleId + '">' + role.roleName +  '</option>');
                
		      }
		      
              //显示原先用户的角色， 如果有的话
              var roleName = $("#roleNameInput").val();
              if(roleName != '') {
                 
                   $("#winRoleSelect option").each(function (){
			    	   
					    if($(this).text()==roleName){
					        $(this).attr('selected',true);
					    }
					});
                 
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
