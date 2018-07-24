<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
<title>Insert title here</title>
   <link href="<%=request.getContextPath()%>/layui/css/layui.css" rel="stylesheet">
   <script type="text/javascript" src="<%=request.getContextPath()%>/layui/layui.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/layui/jquery-1.8.2.min.js"></script>
<script type="text/javascript">

   function access(){
	   var materialId = document.getElementById("mid").value;
	   //alert(materialId);
	   $.ajax({
			type:"POST",
		    url: '<%=request.getContextPath()%>/material/checkAccess.do',
		    data: {"mid": materialId}, 
		    dataType : "json",
		    success: function(msg){
		    	var value = msg.toString();
		    	if(value == 'true'){
		    		opener.location.reload();
		    		window.close();
		    	}
		    }
		 });
   }
   
   function unaccess(){
	   var materialId = document.getElementById("mid").value;
	   $.ajax({
			type:"POST",
		    url: '<%=request.getContextPath()%>/material/checkUnAccess.do',
		    data: {"mid": materialId}, 
		    dataType : "json",
		    success: function(msg){
		    	var value = msg.toString();
                if(value == 'true'){
                	opener.location.reload();
                	window.close();
		    	}
		    }
		 });
   }
   
   function updateTime(){
	   var time = document.getElementById("lens").innerText;
	   if(time != 0){
		   setTimeout("updateTime()",1000);
		   var now = time - 1;
		   document.getElementById("lens").innerText = now;
	   }
   }
	
	
	function getMedia(){
	    var materialExist = '${sessionScope.materialExist}';
	    if(materialExist == "false") {  //视频不存在的话
	       $("#tipMsg").show();
	       $("#div2").hide();
	       return;
	    } 
	   
	
		var myDate = new Date();
		var year = myDate.getFullYear();
		updateTime();
//		window.opener.document.getElementById('adName').value='123123123';
		$("#accessMaterial").hide();
		var filename=window.opener.document.getElementById("videoView").value; 
		var video = document.getElementById("video1");
        video.addEventListener('ended', play);
        //video.src = "/ITMS/media/" + year + "/" + filename;
        video.src = '<%=request.getContextPath()%>/downloadController/showVedio.do?filename=' + filename;
        video.load(); //如果短的话，可以加载完成之后再播放，监听 canplaythrough 事件即可
        video.play();
        //play();
        function play() {
            var video = document.getElementById("video1");                     
            video.controls = "controls";
            $("#duration").remove();
            $("#accessMaterial").show();
/*             curr++;
            if (curr >= vLen)
                curr = 0; // 播放完了，重新播放 */
        }
/* 		// fileObj.files[0]代表文件选择框选择的第一个文件  
		var src = '/ITMS/media/' + filename;  
		var vdo = document.createElement('video');  
		//vdo.src = src;  
//		vdo.controls = "controls";
		vdo.autoplay = "autoplay";
		vdo.width="650";
		vdo.height="450";
//		vdo.loop = "loop";
		document.getElementById('media').appendChild(vdo); */
		
	}
</script>
</head>
<body onLoad="getMedia()">
	<!--      <input type="button" value="aaaa" onclick = "get()">
     <input type="text" id="val" value=''>
    <video width="320" height="240" controls="controls" autoplay="autoplay">
  <source src="file:///C:/Users/MrLiao/Desktop/code/media/movie.ogg" type="video/ogg">
  <source src="file:///C:/Users/MrLiao/Desktop/code/media/movie.ogg" type="video/ogg">
</video>  -->
	<input type="hidden" id="vdo">
	<input type="hidden" id="mid" value="<%=session.getAttribute("materialIdOnce")%>">
	
  <h2 id="tipMsg" hidden  align="center" style="color:red; margin-top:20px;">视频已被删除</h2>
  <div id="div2">
	
	<div align="center">
		<video width="650" height="350" id="video1" class="indexBanner">
			<source src="" type="video/mp4" />
		</video>
	</div>
	<div id="duration">
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label>总时长:</label>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label id="durat"><%=session.getAttribute("durationOnce")%></label>&nbsp;秒
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label>剩余时间:</label>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label id="lens"><%=session.getAttribute("durationOnce")%></label>&nbsp;秒
	</div>
	<fieldset class="layui-elem-field layui-field-title" style="margin-top: 5px;">
		<legend>素材信息</legend>
	</fieldset>
	<div class="panel panel-default" style="width: 75%; height: 100%; float: left">
	     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label>素材名:</label>
	     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label><%=session.getAttribute("materialNameOnce")%></label>	     
	     <br><br>
	     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label>素材分辨率:</label>
	     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label><%=session.getAttribute("resolutionOnce")%></label>	     
	     <br><br>
	     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label>大小:</label>
	     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label><%=session.getAttribute("sizeOnce")%></label>	     
	     <br><br>
	     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label>终端名称:</label>
	     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label><%=session.getAttribute("terminalNameOnce")%></label>	     
	     <br><br>
	     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label>终端尺寸:</label>
	     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label><%=session.getAttribute("terminalLWOnce")%></label>
	     <br><br>
	     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label>节目类型格式:</label>
	     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label><%=session.getAttribute("typeOnce")%></label>
	     
	</div>
	<div style="width: 25%; height: 100%; float: left">
       <div id="accessMaterial">
        <div>
		  <button type="button" class="layui-btn" onclick="access()">审核通过</button>
		</div>
		<br>
		<div>
		  <button type="button" class="layui-btn" onclick="unaccess()">审核不通过</button>
		</div>
       </div>
	</div>
  </div>
</body>
</html>