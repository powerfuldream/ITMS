<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript">
	
	function getMedia(){
		var myDate = new Date();
		var year = myDate.getFullYear();
		var filename=window.opener.document.getElementById("videoView").value; 
		var video = document.getElementById("video1");
        video.addEventListener('ended', play);
        play();
        function play() {
            var video = document.getElementById("video1");
            //video.src = "/ITMS/media/" + year + "/" + filename;
            video.src = '<%=request.getContextPath()%>/downloadController/showVedio.do?filename=' + filename;
            video.load(); //如果短的话，可以加载完成之后再播放，监听 canplaythrough 事件即可
            video.play();
        }
	}
/*             curr++;
            if (curr >= vLen)
                curr = 0; // 播放完了，重新播放 */
//		window.opener.document.getElementById('adName').value='123123123';
		
 		//var filename=window.opener.document.getElementById("videoView").value; 
		// fileObj.files[0]代表文件选择框选择的第一个文件  
/* 		var src = '/ITMS/media/' + filename;  
		var vdo = document.createElement('video');  
		vdo.src = src;  
		vdo.controls = "controls";
		vdo.autoplay = "autoplay";
		vdo.loop = "loop";
		document.getElementById('media').appendChild(vdo);
 		var app = "<video width='320' height='240' controls='controls' autoplay='autoplay'>" + 
		  "<source src='"+ src + "  type='video/mp4'>" + 
		"</video>";
		$("#vdo").after(app);  */ 
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
		      <div align="center">
		        <video width="650" height="450" id="video1" class="indexBanner" controls="controls" autoplay>
		           <source src="" type="video/mp4" />
		        </video>
		      </div>
</div>
</body>
</html>