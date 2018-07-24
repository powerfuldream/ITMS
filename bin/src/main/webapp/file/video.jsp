<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript">
	
	function get(){
//		alert(1111);
//		window.opener.document.getElementById('adName').value='123123123';
		var va = window.opener.document.getElementById('adName').value;
//		alert(va);
		
		var fileObj=window.opener.document.getElementById("file");  
		// fileObj.files[0]代表文件选择框选择的第一个文件  
		var src = window.URL.createObjectURL(fileObj.files[0]);  
		var vdo = document.createElement('video');  
		vdo.src = src;  
		vdo.controls = "controls";
		vdo.autoplay = "autoplay";
//		vdo.loop = "loop";
		document.body.appendChild(vdo);
		
/* 		var app = "<video width='320' height='240' controls='controls' autoplay='autoplay'>" + 
		  "<source src='"+ src + "  type='video/mp4'>" + 
		"</video>";
		$("#vdo").after(app); */
	}
</script>
</head>
<body onLoad="get()">
<!--      <input type="button" value="aaaa" onclick = "get()">
     <input type="text" id="val" value=''>
    <video width="320" height="240" controls="controls" autoplay="autoplay">
  <source src="file:///C:/Users/MrLiao/Desktop/code/media/movie.ogg" type="video/ogg">
  <source src="file:///C:/Users/MrLiao/Desktop/code/media/movie.ogg" type="video/ogg">
</video>  -->
<input type="hidden" id="vdo">
</body>
</html>