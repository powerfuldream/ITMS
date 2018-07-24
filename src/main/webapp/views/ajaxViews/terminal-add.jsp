<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta content="text/html;charset=UTF-8"/>
    <%@ include file="/layui/header.jsp"%>
    <script type="text/javascript" src="<%=request.getContextPath()%>/assets/jquery-validation-1.14.0/dist/jquery.validate.min.js"></script>
    <title>添加播放端</title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
	<meta http-equiv ="Pragma" content = "no-cache"/>
	<meta http-equiv="Cache-Control" content="no cache" />
	<meta http-equiv="Expires" content="0" />
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1"/>
	<meta name="apple-mobile-web-app-status-bar-style" content="black"/>
	<meta name="apple-mobile-web-app-capable" content="yes"/>
	<meta name="format-detection" content="telephone=no"/>
	
	<style>
	  .my_width {
	    width: 180px;
	  }
	</style>
	
	
</head>
<body>

  <div class="layui-fluid">
 
  <form id="applyform">

		  <div class="layui-form-item">
		    <label class="layui-form-label my_width">序列号码:</label>
		    <div class="layui-input-inline">
		      <input type="text" name="serialNumber" lay-verify="required" class="layui-input input-text my_width" />
		    </div>
		    
		    <label class="layui-form-label my_width">播放端名称:</label>
		    <div class="layui-input-inline">
		      <input type="text" name="terminalName" lay-verify="required" class="layui-input input-text my_width" />
		    </div>
		    
		  </div>
		  
		  

		  <div class="layui-form-item">
		    <label class="layui-form-label my_width">所在地区:</label>
		    <div class="layui-input-inline">
		      <input id="winAreaCodeId" type="hidden" name="areaCode" value="440000">
		      <input id="winAreaNameId" type="text" name="areaName" value="广东省" onfocus="openAreaTree()" class="layui-input input-text my_width" />
		    </div>
		    
		    
		    <label class="layui-form-label my_width">安装地址:</label>
		    <div class="layui-input-inline">
		      <input type="text" name="detailAddress" lay-verify="required" class="layui-input input-text my_width" />
		    </div>
		    
		    
		  </div>


          <div class="layui-form-item">
		    <label class="layui-form-label my_width">连接密码:</label>
		    <div class="layui-input-inline">
		      <input type="password" id="connectPassword" name="connectPassword" lay-verify="required" class="layui-input input-text my_width" />
		    </div>
		    
		    <label class="layui-form-label my_width">确认密码:</label>
		    <div class="layui-input-inline">
		      <input type="password" name="connectPassword2"  lay-verify="required" class="layui-input input-text my_width" />
		    </div>
		    
		  </div>  

	
	 
		  <div class="layui-form-item">
		    <label class="layui-form-label my_width">IP地址:</label>
		    <div class="layui-input-inline">
		      <input type="text" name="ip" lay-verify="required" class="layui-input input-text my_width" />
		    </div>
		    
		    <label class="layui-form-label my_width">Mac地址:</label>
		    <div class="layui-input-inline">
		      <input type="text" name="macAddr" lay-verify="required" class="layui-input input-text my_width" />
		    </div>
		    
		  </div>  
		
		  




		  <div class="layui-form-item">
		    <label class="layui-form-label my_width">电脑分辨率-长:</label>
		    <div class="layui-input-inline">
		      <input type="text" name="resolutionLength" lay-verify="required" class="layui-input input-text my_width" />
		    </div>
		    
		    
		    <label class="layui-form-label my_width">电脑分辨率-宽:</label>
		    <div class="layui-input-inline">
		      <input type="text" name="resolutionWidth" lay-verify="required" class="layui-input input-text my_width" />
		    </div>
		  </div>  
		  





		  <div class="layui-form-item">
		    <label class="layui-form-label my_width">LED-长:</label>
		    <div class="layui-input-inline">
		      <input type="text" name="ledLength" lay-verify="required" class="layui-input input-text my_width" />
		    </div>
		    
		    
		    <label class="layui-form-label my_width">LED-宽:</label>
		    <div class="layui-input-inline">
		      <input type="text" name="ledWidth" lay-verify="required" class="layui-input input-text my_width" />
		    </div>
		    
		  </div>  
		  

	  
	  
	  
	  
		  <div class="layui-form-item">
		    <label class="layui-form-label my_width">LED起点-Top:</label>
		    <div class="layui-input-inline">
		      <input type="text" name="startSpotTop" lay-verify="required" class="layui-input input-text my_width" />
		    </div>
		    
		    
		    <label class="layui-form-label my_width">LED起点-Left:</label>
		    <div class="layui-input-inline">
		      <input type="text" name="startSpotLeft" lay-verify="required" class="layui-input input-text my_width" />
		    </div>
		    
		  </div>  
		  

	 
	 
	 
	 
	 
		  <div class="layui-form-item">
		    <label class="layui-form-label my_width">运行开始时间:</label>
		    <div class="layui-input-inline">
		      <input type="text" id="runStartTime1" lay-verify="required" class="layui-input input-text my_width" />
		    </div>
		    
		    
		    <label class="layui-form-label my_width">运行结束时间:</label>
		    <div class="layui-input-inline">
		      <input type="text" id="runEndTime1"  lay-verify="required" class="layui-input input-text my_width" />
		    </div>
		    
		     <input type="hidden" name="terminalId" value="">
		     <input type="hidden" id="runStartTime" name="runStartTime" value="">
			 <input type="hidden" id="runEndTime" name="runEndTime" value="">
		    
		  </div>  

	  
	  
	  
		  <div class="layui-form-item">
		    <label class="layui-form-label my_width">播放端描述:</label>
		    <div class="layui-input-inline">
		      <input type="text" name="terminalDescribe" lay-verify="required" class="layui-input input-text my_width" />
		    </div>
		  </div>  
	


  </form>
  
  <br><br>
  <hr class="layui-bg-green"/>
  <div class="layui-form-item">
    <div class="layui-input-block">
      <button class="layui-btn" onclick="addTerminal()"><i class="layui-icon">&#xe654;</i>保存</button>
      <button type="button" class="layui-btn layui-btn-primary" onclick="closeWind()">关闭</button>
    </div>
  </div>
<script type="text/javascript">

       $(function() {
 		   
 		   layui.use('laydate', function(){
    		  var laydate = layui.laydate;
    		  
    		  laydate.render({
      		    elem: '#runStartTime1' //指定元素
      		    ,type: 'time'
      		  });
    		  //执行一个laydate实例
    		  laydate.render({
    		    elem: '#runEndTime1' //指定元素
    		    ,type: 'time'
    		  });
    		});
 		   
 		   
		});
		

   
     function openAreaTree() {
       parent.openAreaTree();
     }
 
     function clickArea(item) {

        $("#winAreaCodeId").val(item.id);
		$("#winAreaNameId").val(item.name);
   
     }


	 
   

   function closeWind(){
	   var index = parent.layer.getFrameIndex(window.name);
	   parent.layer.closeAll();
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
	 
	 
	 
    function validateForm() {
	      // 在键盘按下并释放及提交后验证提交表单
	      return $("#applyform").validate({
		    rules: {
		      serialNumber: "required",
		      terminalName: "required",
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
		      connectPassword: "required",
		      connectPassword2: {
		        required: true,
		        equalTo: "#connectPassword"
		      },
		      detailAddress: "required"
		    },
		    messages: {
		      serialNumber: "<span style='color:red;'>不能为空</span>",
		      terminalName: "<span style='color:red;'>不能为空</span>",
		      resolutionLength: {
		          required: "<span style='color:red;'>不能为空</span>",
		          digits:"<span style='color:red;'>必须输入整数</span>"
		      },
		      resolutionWidth: {
		          required: "<span style='color:red;'>不能为空</span>",
		          digits:"<span style='color:red;'>必须输入整数</span>"
		      },
		      ledLength: {
		          required: "<span style='color:red;'>不能为空</span>",
		          digits:"<span style='color:red;'>必须输入整数</span>"
		      },
		      ledWidth: {
		          required: "<span style='color:red;'>不能为空</span>",
		          digits:"<span style='color:red;'>必须输入整数</span>"
		      },
		      startSpotTop:{
		          required:"<span style='color:red;'>不能为空</span>",
		          digits:"<span style='color:red;'>必须输入整数</span>"
		      },
		      startSpotLeft:{
		          required:"<span style='color:red;'>不能为空</span>",
		          digits:"<span style='color:red;'>必须输入整数</span>"
		      },
		      connectPassword: "<span style='color:red;'>不能为空</span>",
	          connectPassword2: {
	              required: "<span style='color:red;'>不能为空</span>",
	              equalTo: "<span style='color:red;'>两次密码不一样</span>"
	          },
		      detailAddress: "<span style='color:red;'>不能为空</span>"
		    }}).form();
		
		
		}	 
	
	 
   
</script>
</div>
</body>

</html>
