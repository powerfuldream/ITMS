<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta content="text/html;charset=UTF-8"/>
	<%@ include file="/layui/header.jsp"%>
    <title>素材修改列表</title>
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

	<input type="hidden" id="mid" name="mid"/>
	<div class="layui-fluid">
    <form class="layui-form">

  <div class="layui-form-item">
    <label class="layui-form-label my_width">素材原名：</label>
    <div class="layui-input-inline">
      <input type="text" id="materialName" name="materialName" required="" style="width:250px;" lay-verify="required"  autocomplete="off" class="layui-input" readonly="readonly"/>
    </div>
  </div>
  

  
  <div class="layui-form-item">
    <label class="layui-form-label my_width">素材的新名：</label>
    <div class="layui-input-inline">
      <input type="text" id="materialNewName" name="materialNewName" style="width:250px;"  placeholder="请输入素材新名称" autocomplete="off" class="layui-input input-text"/>
    </div>
  </div>
  

  <div class="layui-form-item" id="div2" hidden>
    <label class="layui-form-label my_width">绑定的终端：</label>
    <div class="layui-input-inline" style="width:250px;">
      <select id="terminalSelect">
      </select>
    </div>
  </div>
  
  
  
  
  <br><br>
  <hr class="layui-bg-green"/>
  <div class="layui-form-item">
    <div class="layui-input-block">
      <button class="layui-btn" onclick="editMaterial()"><i class="layui-icon">&#xe642;</i>保存</button>
      <button type="button" class="layui-btn layui-btn-primary" onclick="closeWind()">关闭</button>
    </div>
  </div>
<script type="text/javascript">

   function closeWind(){
	   var index = parent.layer.getFrameIndex(window.name);
	   parent.layer.closeAll();
   }
   
   function editMaterial(){
	   var mid = $("#mid").val();
	   var materialNewName = $("#materialNewName").val();
	   var index = parent.layer.getFrameIndex(window.name);
	  
	   
	   var newTerminalId = "";
	   if($("#div2").is(':visible')){ 
	      newTerminalId =  $("#terminalSelect").val();
	   } else {  //单独修改素材名字就不能为空
	   
	      if(materialNewName == ""){
	        parent.layer.msg('修改失败, 新素材名不能为空',{icon:5,time:1000});
		    return ;
	      }
	   }
	   
	   $.ajax({
			type: "POST",
			url: "<%=request.getContextPath()%>/material/editMaterial.do",
			data:{"materialName":materialNewName, "mid":mid, "newTerminalId":newTerminalId},
			async: false,
			dataType: "json",
			success: function(msg){
				var value = msg.toString();
				if(value=="true"){
					//opener.location.reload();
					parent.layer.closeAll();
					parent.layer.msg('保存成功!',{icon:6,time:2000});
					parent.refresh();
					//window.parent.location.reload(); //刷新父页面
			  }else if(value=="false"){
				  parent.layer.msg('存在同名文件，请重新输入!!!',{icon:5,time:2000});
			  }else if(value=="1"){
				  parent.layer.msg('操作有误!!!',{icon:5,time:2000});
			  }else if(value=="2"){
				  parent.layer.msg('素材已审核，该角色无权修改!!!',{icon:5,time:2000});
			  }else{
				  parent.layer.msg('修改失败!!!',{icon:5,time:2000});
			  }
			}
		});
   }
   
  
   function setUpdateTerminal(terminalVal, terminal) {
      var content = "";
      for(var i = 0; i < terminalVal.length; i++) {
        	content = content + ' <option value="' + terminalVal[i].terminalId + '">' + terminalVal[i].terminalName + '</option> ';
      }
      $("#terminalSelect").html(content);
      
      $("#terminalSelect").val(terminal.terminalId);
      $("#div2").show();
      
      layui.use('form', function(){
		  var form = layui.form;
	  });
   
   }
   
 
   
</script>
 </form>
 </div>
</body>
</html>
