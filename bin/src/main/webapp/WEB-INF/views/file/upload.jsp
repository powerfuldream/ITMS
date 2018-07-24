<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<title>文件上传模块 - layui</title>

   <link href="<%=request.getContextPath()%>/layui/css/layui.css" rel="stylesheet">
   <script type="text/javascript" src="<%=request.getContextPath()%>/layui/layui.js"></script>

<style>
body{padding: 50px 50px;}
.layui-upload-img{width: 92px; height: 92px; margin: 0 10px 10px 0;}
hr{margin: 30px 0;}
</style>

</head>
<body>
<input type="hidden" id="videoViewPlay" value=""/>

<fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;">
  <legend>上传素材列表</legend>
</fieldset> 
 
<div class="layui-upload">
  <button type="button" class="layui-btn layui-btn-normal" id="testList">多素材选择</button> 
  <div class="layui-upload-list">
    <table class="layui-table">
      <thead>
        <tr><th>文件名</th>
        <th>大小</th>
        <th>状态</th>
        <th>操作</th>
      </tr></thead>
      <tbody id="demoList"></tbody>
    </table>
  </div>
  <button type="button" class="layui-btn" id="testListAction">开始上传</button>
  <button type="button" class="layui-btn" style="margin: 5px;"
				onclick="goBack()">返回</button>
</div>

<hr>


<script>
layui.use('upload', function(){
  var $ = layui.jquery
  ,upload = layui.upload;

  
  //演示多文件列表
  var demoListView = $('#demoList');
  var fileUrl = '<%=request.getContextPath()%>/material/upload.do';
  var uploadListIns = upload.render({
    elem: '#testList'
    ,url: '<%=request.getContextPath()%>/material/upload.do'
    ,accept: 'file'
    ,multiple: true
    ,number: 0
    ,auto: false
    ,bindAction: '#testListAction'
    ,choose: function(obj){   
      var files = this.files = obj.pushFile(); //将每次选择的文件追加到文件队列

      //读取本地文件
      obj.preview(function(index, file, result){
        var tr = $(['<tr id="upload-'+ index +'">'
          ,'<td>'+ file.name +'</td>'
          ,'<td>'+ (file.size/1014).toFixed(1) +'kb</td>'
          ,'<td>等待上传</td>'
          ,'<td>'
            ,'<button class="layui-btn layui-btn-mini demo-reload layui-hide">重传</button>'
            ,'<button class="layui-btn layui-btn-mini layui-btn-danger demo-delete">删除</button>'
            ,'<button class="layui-btn layui-btn-mini layui-btn preView">预览</button>'
          ,'</td>'
        ,'</tr>'].join(''));
        
        //单个重传
        tr.find('.demo-reload').on('click', function(){
          obj.upload(index, file);
        });
        
      //预览
        tr.find('.preView').on('click', function(){
        	//alert(index);
        	//alert(files[index]);
        	//alert(files[index].name);
        	var url = URL.createObjectURL(files[index]);
        	//alert(url);
        	document.getElementById("videoViewPlay").value = url;
        	window.open('<%=request.getContextPath()%>/file/video.html',"_blank","toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes,left=300,top=100, width=800, height=550");
        });
        
        //删除
        tr.find('.demo-delete').on('click', function(){
        	alert(index);
        	alert(files[index]);
            delete files[index]; //删除对应的文件
            tr.remove();
            uploadListIns.config.elem.next()[0].value = ''; //清空 input file 值，以免删除后出现同名文件不可选
        });
        
        demoListView.append(tr);
      });
    }
/*   ,before: function(obj){ //obj参数包含的信息，跟 choose回调完全一致，可参见上文。
	    layer.load(); //上传loading
	  } */
    ,done: function(res, index, upload){
      if(res.code == 0 && res.fail == 0){ //上传成功
    	  layer.closeAll('loading'); //关闭loading
    	  //alert(index);
          var tr = demoListView.find('tr#upload-'+ index)
          ,tds = tr.children();
          tds.eq(2).html('<span style="color: #5FB878;">上传成功</span>');
          tds.eq(3).html(''); //清空操作
          delete this.files[index]; //删除文件队列已经上传成功的文件
          return;
      }else if(res.code == 0 && res.fail == 1){//上传失败
    	  layer.closeAll('loading'); //关闭loading
    	  var tr = demoListView.find('tr#upload-'+ index)
          ,tds = tr.children();
          tds.eq(2).html('<span style="color: #FF5722;">上传失败(已有同素材名文件)</span>');
          tds.eq(3).find('.demo-reload').removeClass('layui-hide'); //显示重传
          return;
      }
      this.error(index, upload);
    }
    ,allDone: function(obj){
    	layer.closeAll('loading'); //关闭loading
      console.log(obj);
    }
    ,error: function(index, upload){
      layer.closeAll('loading'); //关闭loading
      var tr = demoListView.find('tr#upload-'+ index)
      ,tds = tr.children();
      tds.eq(2).html('<span style="color: #FF5722;">上传失败</span>');
      tds.eq(3).find('.demo-reload').removeClass('layui-hide'); //显示重传
    }
  });
  
});

function goBack(){
	document.location = "<%=request.getContextPath()%>/material/materialList.do";
}

function preView(){
	var newWindow = window.open('video.html',"_blank","toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes,left=300,top=100, width=800, height=500");
	/* newWindow.document.getElementById("val").value = 'your code here'; */
}
</script>
</body>
</html>
