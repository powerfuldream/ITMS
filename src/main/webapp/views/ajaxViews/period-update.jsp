<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta content="text/html;charset=UTF-8"/>
    <%@ include file="/layui/header.jsp"%>
   <title>修改时段</title>
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
<input type="hidden" id="peirodId" name="peirodId" value="">
	<div class="layui-fluid">

  <div class="layui-form-item">
    <label class="layui-form-label">时段名：</label>
    <div class="layui-input-inline">
      <input type="text" id="periodName" name="periodName" required="" placeholder="请输入时段名"  lay-verify="required"  autocomplete="off" class="layui-input input-text" />
    </div>
  </div>
  <div class="layui-form-item">
    <label class="layui-form-label">时段范围：</label>
    <div class="layui-input-inline">
      <input type="text" id="testTime" name="testTime" placeholder="请选择时间" class="layui-input input-text" />
    </div>
  </div>
  <div class="layui-form-item">
    <label class="layui-form-label">备注：</label>
    <div class="layui-input-inline">
      <input type="text" id="mark" name="mark" placeholder="备注" autocomplete="off" class="layui-input input-text"/>
    </div>
  </div>
  <br><br>
  <hr class="layui-bg-green"/>
  <div class="layui-form-item">
    <div class="layui-input-block">
      <button class="layui-btn" onclick="editPeriod()"><i class="layui-icon">&#xe642;</i>保存</button>
      <button type="button" class="layui-btn layui-btn-primary" onclick="closeWind()">关闭</button>
    </div>
  </div>
<script type="text/javascript">
layui.use(['layer','form','laydate'], function(){
	var layer = layui.layer
	,form = layui.form
    ,laydate = layui.laydate;
    //执行一个laydate实例
    laydate.render({
    	elem: '#testTime'
		    ,type: 'time'
		    ,range: true
    });
});

   function closeWind(){
	   var index = parent.layer.getFrameIndex(window.name);
	   parent.layer.closeAll();
   }
   
   function editPeriod(){
	   var periodId = $("#peirodId").val();
	   var periodName = $("#periodName").val();
	   var interval = $("#testTime").val();
	   var mark = $("#mark").val();
	   console.log(periodId);
	   console.log(periodName);
	   console.log(interval);
	   console.log(mark);
	   if(periodName == "" && interval == "" && mark == ""){
		   layer.msg('未输入任何字段!!!',{icon:6,time:2000});
		   return ;
	   }else{
		   var formData = new FormData();
			formData.append("periodId", periodId);
			formData.append("periodName", periodName);
			formData.append("timeStr", interval);
			formData.append("mark", mark);
		   $.ajax({
				type: "POST",
				url: "<%=request.getContextPath()%>/period/editPeriod.do",
				data:formData,
				async: false,
				processData : false,
				contentType : false,
				dataType: "json",
				success: function(msg){
					var value = msg.toString();
					if(value=="true"){
						//opener.location.reload();
						parent.layer.closeAll();
						parent.layer.msg('修改成功!',{icon:6,time:2000});
						parent.refresh();
						//window.parent.location.reload(); //刷新父页面
				  }else if(value=="false"){
					  layer.msg('存在同名文件，请重新输入!!!',{icon:5,time:2000});
				  }else if(value=="1"){
					  layer.msg('前后时段有误!!!',{icon:5,time:2000});
				     } else {
				    	 layer.msg('修改失败!!!',{icon:5,time:2000});
				     }
				}
			});
	   }
	 }
   
</script>
	</div>
</body>
</html>
