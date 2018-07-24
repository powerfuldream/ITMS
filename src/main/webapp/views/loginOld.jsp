<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <%@ include  file="/assets/header.jsp"%>
   <title>登录</title>
   <style>
     body{
	  background:#fff url("<%=request.getContextPath()%>/assets/image/login_background.jpg") no-repeat left top;
	  background-size:100%;
	}
	
   
   </style>
</head>
<body>
	<div id="loginWin" class="easyui-window" title="欢迎登录" style="width:400px;height:250px;padding:5px;line-height: 20px;color: #fff; font-family: Verdana, 微软雅黑,黑体"
	   minimizable="false" maximizable="false" resizable="false" collapsible="false">
	    <div class="easyui-layout" fit="true">
	       <div region="center" border="false" style="padding:5px;background:#fff;border:1px solid #ccc;">
		        <form id="loginForm" method="post">
		            <div style="padding:5px 0;text-align: center;margin-top:50px;">
		                <i class="fa fa-user"></i> <label for="userAccount">帐号:</label>
		                <input type="text" name="userAccount" style="width:260px;"></input>
		            </div>
		            <div style="padding:5px 0;text-align: center;">
		                <i class="fa fa-lock"></i> <label for="userPassword">密码:</label>
		                <input type="password" name="userPassword" style="width:260px;"></input>
		            </div>
		             <div style="padding:5px 0;text-align: center;color: red;" id="showMsg"></div>
		        </form>
	        </div>
	        <div region="south" border="false" style="text-align:center;padding:5px 0;">
	            <a class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="login()">登录</a>
	            <a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cleardata()">重置</a>
	        </div>
	    </div>
	</div>
</body>
<script type="text/javascript">
	document.onkeydown = function(e){
	    var event = e || window.event;  
	    var code = event.keyCode || event.which || event.charCode;
	    if (code == 13) {
	        login();
	    }
	}
	
	$(function(){
	    $("input[name='userAccount']").focus();
	});
	
	function cleardata(){
	    $('#loginForm').form('clear');
	}
	
	function login(){
	     if($("input[name='userAccount']").val()=="" || $("input[name='userPassword']").val()==""){
	         $("#showMsg").html("用户名或密码为空，请输入");
	         $("input[name='userAccount']").focus();
	    } else {
	            //ajax异步提交  
	          $.ajax({
			    url: '<%=request.getContextPath()%>/login/reqLogin.do',
			    data:$("#loginForm").serialize(), 
			    type: "post",
			    dataType : "json",
			  })
			  .done(function( data ) {
			     if(data.success) {
			        document.location = "<%=request.getContextPath()%>/front/index.do";
			     } else {
			        $("#showMsg").html(data.msg);  //登录错误提示信息
			     }
			  })

	   } 
	}
</script>
</html>