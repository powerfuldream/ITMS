<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%@  page   import= "org.south.itms.util.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<%@ include file="/layui/header.jsp"%>
<title>素材上传模块 - layui</title>

<style>
 #file {
    display:none;
    position: absolute;
    top: 0;
    left: 0;
    width: 110px; /* 宽高和外围元素保持一致 */
    height: 37px;
    opacity: 0;
    -moz-opacity: 0;  /* 兼容老式浏览器 */
    filter: alpha(opacity=0); /* 兼容IE */
}
#btn-jan {
	background:#1E9FFF;
    height: 38px;
    line-height:25px;
    cursor:pointer;
    width:110px;
    border:none;
    display: inline-block;
    color: #F0F8FF;
    font-family: 微软雅黑;
    font-size: 15px;
    font-weight:bold;
}
</style>

</head>
<body onload="getTree()">
<input type="hidden" id="videoViewPlay" value=""/>
<input type="hidden" id="treeId" value=""/>
<div region="center" border="false" style="padding:5px;">

	 <div style="width: 20%; float: left">
	    <br><font  size="4"  color="red">双击打开关闭</font><br>
	    <ul id="demo2"></ul>
	 </div>
	 
		<div style="width: 80%; height: 100%; float: left">
			<fieldset class="layui-elem-field layui-field-title"
				style="margin-top: 30px;">
				<legend>上传素材列表</legend>
			</fieldset>
						
			<div>
			  <div class="layui-inline">
			     <div>
                   <!-- <input id="file-jan" type="file" onchange="stateChange()" multiple/> -->
                   <input type="button" onclick="file.click()" id="btn-jan" value="多素材选择">
                   <input type="file" id="file" onchange="stateChange()" multiple/>
                 </div>
			  </div>
			  
			   <div class="layui-inline">
				<label class="layui-form-mid"><font size="4">&nbsp;&nbsp;&nbsp;当前已选终端：</font></label>
				<div class="layui-input-inline" style="width: 90px; height: 35px;">
					<input id="terminalName" type="button" class="layui-btn layui-btn-jan" style="margin: 2px;" value="无" />
				</div>
			  </div>
			  
			  <div class="layui-inline">
			     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			     <font  size="4"  color="red">选择大文件上传时请等待提示</font>
			  </div>
			</div>
			<br>
			
			<div>
			  <div>
				   <table class="layui-table" lay-skin="line">
						<thead>
							<tr>
								<th>文件名</th>
								<th>大小</th>
								<th>所选终端</th>
								<th>上传进度</th>
								<th>状态</th>
								<th>操作</th>
							</tr>
						</thead>
						<tbody id="tableList"></tbody>
			       </table>
			</div>
			<div>
				<button type="button" class="layui-btn" id="testListAction" onclick="uploadFile()">开始上传</button>
			</div>

			<hr>
		</div>
	</div>
</div>
<!-- <div>
   <input type="file" id="uploadf" />
   <button onclick="uploadFileD()">shangchuan</button>
</div> -->

<script type="text/javascript">

function uploadFileD(){
	var obj1 = document.getElementById("uploadf");
	var formDat = new FormData();
	formDat.append("file", obj1.files[0]);
	var FileController = "<%=request.getContextPath()%>/material/uploadF.do";
	var xhr = new XMLHttpRequest();
    xhr.open("post", FileController, true);
    xhr.send(formDat);
    xhr.onload = function () {
    	var b = xhr.responseText;
    	console.log(b);
        if(b == "true"){      
            alert("登录成功！");      
        }else{
            alert("登录失败！");
        }
    }; 
<%-- 	alert(666);
	$.ajax({
		type: "POST",
		url: "<%=request.getContextPath()%>/material/uploadF.do",
		data: formDat,
		processData: false,
		contentType: false,
		cache : false,//防止缓存
		dataType: "json",
		success: function(date){
			var value = date.toString();
			if(vlaue == 'true'){
				alert(2222);
			}
		}
	}); --%>
}

var node = [];
var objFile = [];
var offset = 0;
var start = 0;
var currProgress = 0; 
var done = false; 
var total = 100;
var tidVal = [];

function stateChange(){
	var volumn1 = $("#file")[0].files[0].size/1024;
	var obj = document.getElementById("file");
	//objFile.push(obj);
	var length = obj.files.length;
	var ttid = document.getElementById("treeId").value;
	for(var i = 0; i < length; i++){
		objFile.push(obj.files[i]);
		tidVal.push(ttid);
		var trObj = document.createElement("tr");
        trObj.id = "upload" + offset;
        var size = obj.files[i].size/1024;
        //var fileSize = Math.round(size);
        var terminalName = $("#terminalName").val();
        var tname = document.getElementById("terminalName").value;
        //console.log(terminalName);
        //console.log(tname);
        var tdStr = "<td>" + obj.files[i].name + "</td>"
                     + "<td>" + size.toFixed(1) + "kb</td>"
                     + "<td>" + tname + "</td>"
                     + "<td>" + "<progress id='prog" + offset + "' value='0' max='100' style='width:100px;'></progress>" 
                     + "<label id='numValue"+offset+"'>0%</label>" + "</td>"
                     + "<td>" + "<label id='stat"+offset+"'>等待上传</label>" + "</td>"
                     + "<button id='delbtn"+offset+"' class='layui-btn layui-btn-mini layui-btn-danger' onclick='delFile(" + offset + ")'>删除</button>"
                     + "<button id='prevbtn"+offset+"' class='layui-btn layui-btn-mini layui-btn' onclick='preView(" + offset + ")'>预览</button></td>";
        trObj.innerHTML = tdStr;
        offset = offset + 1;
        document.getElementById("tableList").appendChild(trObj);
        //trObj.innerHTML = "<td><input name='firstName'/></td><td><input name='lastName'/></td><td><input type='button' value='Add' onclick='add()'> <input type='button' value='Del' onclick='del(this)'></td>";  
        //document.getElementById("tableList").appendChild(trObj);
	}
}

//预览 
function preView(offset){
	//console.log(offset);
	console.log(objFile[offset].name);
	console.log(objFile[offset]);
	var url = URL.createObjectURL(objFile[offset]);
	document.getElementById("videoViewPlay").value = url;
	console.log(url);
	window.open('<%=request.getContextPath()%>/file/video.html',"_blank","toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes,left=300,top=100, width=800, height=550");
}

//删除指定行
function delFile(offset){
	var deltrObj = document.getElementById("upload" + offset);
    document.getElementById("tableList").removeChild(deltrObj);
    //delete objFile[offset];
    objFile[offset] = 0;
}

//上传文件
function uploadFile(){
	var len = objFile.length;
	if(start < len){
		if(objFile[start] == 0){
			start = start + 1;
			uploadFile();
		}else{
//		if(typeof(objFile[start]) === 'undefined'){
//			start = start + 1;
//			uploadFile();
//		}else{
			var fileData = new FormData();
			fileData.append("file", objFile[start]);
			//var tid = document.getElementById("treeId").value;
			var tttid = tidVal[start];
			fileData.append("tid",tttid);
			//console.log(objFile[start].name);
			//隐藏button按钮
			var labelVal1 = document.getElementById("stat"+start);
			labelVal1.innerHTML = '<span style="color: #5FB878;">正在上传..</span>';
			
			var FileController = "<%=request.getContextPath()%>/material/upload.do";
		    var xhr = new XMLHttpRequest();
			xhr.open("post", FileController, true);
			xhr.send(fileData);
			console.log(fileData);
			xhr.onload = function () {
				var b = xhr.responseText;
				if(b == 'true'){
					document.getElementById("delbtn" + start).style.display = "none";
					document.getElementById("prevbtn" + start).style.display = "none";
					var labelVal = document.getElementById("stat"+start);
					labelVal.innerHTML = '<span style="color: #5FB878;">上传成功</span>';
					var prBar = document.getElementById("prog"+start);
					var val = document.getElementById("numValue"+start);
					prBar.value = 100;
					val.innerHTML = "100%";
					objFile[start] = 0;
					//layer.msg('ok!',{icon:6,time:500});
					if((start + 1) < len){
						start = start + 1;
						uploadFile();
						//layer.msg('文件保存成功!',{icon:6,time:3000});
					}else if((start + 1) >= len){
/* 						for(var i = 0; i <= start; i++){
							if(document.getElementById("stat"+i) != null){
								var labelValTmp = document.getElementById("stat"+i);
								labelValTmp.innerHTML = '<span style="color: #5FB878;">上传成功</span>';
							}
							if(document.getElementById("prog"+i) != null){
								var prBarTmp = document.getElementById("prog"+i);
								prBarTmp.value = 100;
							}
							if(document.getElementById("numValue"+i) != null){
								var valTmp = document.getElementById("numValue"+i);
								valTmp.innerHTML = "100%";
							}
						} */
						start = start + 1;
						layer.msg('当前所选文件上传完成!',{icon:6,time:2000});
					}
				}else if(b == '1'){
					var labelVal = document.getElementById("stat"+start);
					labelVal.innerHTML = '<span style="color: #FF5722;">上传失败(同名素材)</span>';
					$("#prog"+start).remove();
					$("#numValue" + start).remove();
					objFile[start] = 0;
					if((start + 1) < len){
						start = start + 1;
						uploadFile();
					}else if((start + 1) >= len){
/* 						for(var i = 0; i <= start; i++){
							if(document.getElementById("stat"+i) != null){
								var labelValTmp = document.getElementById("stat"+i);
								labelValTmp.innerHTML = '<span style="color: #5FB878;">上传成功</span>';
							}
							if(document.getElementById("prog"+i) != null){
								var prBarTmp = document.getElementById("prog"+i);
								prBarTmp.value = 100;
							}
							if(document.getElementById("numValue"+i) != null){
								var valTmp = document.getElementById("numValue"+i);
								valTmp.innerHTML = "100%";
							}
						} */
						start = start + 1;
						layer.msg('当前所选文件上传完成!',{icon:6,time:2000});
					}
				}else if(b == 'false'){
					var labelVal = document.getElementById("stat"+start);
					labelVal.innerHTML = '<span style="color: #FF5722;">上传失败</span>';
					layer.msg('(登陆超时,重新登陆上传)!',{icon:5,time:2000});
					$("#prog"+start).remove();
					$("#numValue" + start).remove();
					objFile[start] = 0;
					if((start + 1) < len){
						start = start + 1;
						uploadFile();
					}else if((start + 1) >= len){
/* 						for(var i = 0; i <= start; i++){
							if(document.getElementById("stat"+i) != null){
								var labelValTmp = document.getElementById("stat"+i);
								labelValTmp.innerHTML = '<span style="color: #5FB878;">上传成功</span>';
							}
							if(document.getElementById("prog"+i) != null){
								var prBarTmp = document.getElementById("prog"+i);
								prBarTmp.value = 100;
							}
							if(document.getElementById("numValue"+i) != null){
								var valTmp = document.getElementById("numValue"+i);
								valTmp.innerHTML = "100%";
							}
						} */
						start = start + 1;
						layer.msg('当前所选文件上传完成!',{icon:6,time:2000});
					}
				}
			}; 
			startProgress(start);
<%-- 			$.ajax({
				type: "POST",
				url: "<%=request.getContextPath()%>/material/upload.do",
				data: fileData,
				processData: false,
				contentType: false,
				cache : false,//防止缓存
				dataType: "json",
				success: function(date){
					var value = date.toString();
					console.log(start);
					if(value == 'true'){
						document.getElementById("delbtn" + start).style.display = "none";
						document.getElementById("prevbtn" + start).style.display = "none";
						var labelVal = document.getElementById("stat"+start);
						labelVal.innerHTML = '<span style="color: #5FB878;">上传成功</span>';
						var prBar = document.getElementById("prog"+start);
						var val = document.getElementById("numValue"+start);
						prBar.value = 100;
						val.innerHTML = "100%";
						objFile[start] = 0;
						//layer.msg('ok!',{icon:6,time:500});
						if((start + 1) < len){
							start = start + 1;
							uploadFile();
							//layer.msg('文件保存成功!',{icon:6,time:3000});
						}else if((start + 1) >= len){
							start = start + 1;
							layer.msg('当前所选文件上传完成!',{icon:6,time:2000});
						}
					}else if(value == '1'){
						var labelVal = document.getElementById("stat"+start);
						labelVal.innerHTML = '<span style="color: #FF5722;">上传失败(同名素材)</span>';
						$("#prog"+start).remove();
						$("#numValue" + start).remove();
						objFile[start] = 0;
						if((start + 1) < len){
							start = start + 1;
							uploadFile();
						}else if((start + 1) >= len){
							start = start + 1;
							layer.msg('当前所选文件上传完成!',{icon:6,time:2000});
						}
					}else if(value == 'false'){
						var labelVal = document.getElementById("stat"+start);
						labelVal.innerHTML = '<span style="color: #FF5722;">上传失败</span>';
						$("#prog"+start).remove();
						$("#numValue" + start).remove();
						objFile[start] = 0;
						if((start + 1) < len){
							start = start + 1;
							uploadFile();
						}else if((start + 1) >= len){
							start = start + 1;
							layer.msg('当前所选文件上传完成!',{icon:6,time:2000});
						}
					}
				}
			}); --%>
			
		}
	}
}

//显示进度条
function startProgress(num){
	//if(currProgress!=100){
		$.ajax({
					type : "POST",
					url : "<%=request.getContextPath()%>/progress/getProgress.do",
					dataType : "json",
					success : function(msg) {
						//var value = msg.toString();
						if(msg == null){
							
						}else{
						
						   if(document.getElementById("stat"+num).innerHTML == '<span style="color: #5FB878;">上传成功</span>') {  //如果上传在监听进度前就已经完成的话
                               return;
                           }

							var value = msg.toString();
							currProgress = msg;
							var prBar = document.getElementById("prog"+num);
							var val = document.getElementById("numValue"+num);
							prBar.value = currProgress;
							val.innerHTML = msg+"%";
//							alert(currProgress);                 
							if(currProgress==100)  done=true;

							if(!done){
								setTimeout("startProgress("+num+")",600);
								
							}else{
							    clearInterval()
							    done = false;
							    currProgress = 0;
							    var labelVal2 = document.getElementById("stat"+num);
								labelVal2.innerHTML = '<span style="color: #5FB878;">正在保存中..</span>';
							}
						}
					}
				});

			//}
}

/* $(function(){
	  
	}); */
	function getTree(){
		treeSearch();
	}

function extra_data(input,data){
	var item=[];
	$.each(data,function(k,v){
		item.push('<input type="hidden" name="'+k+'" value="'+v+'">');
	})
	$(input).after(item.join(''));
}

function treeSearch(){
	$.ajax({
		type: "POST",
		url: "<%=request.getContextPath()%>/material/treeDate.do",
		dataType: "json",
		success: function(msg){
			for(var i = 0; i < msg.length; i++){
				node.push({
		            name:'' + msg[i].name,
		            id: '' + msg[i].id,
		            spread:'' + true
		        });
				if(msg[i].children.length > 0){
					var child = [];
					for(var j = 0; j < msg[i].children.length; j++){
						child.push({
							name:'' + msg[i].children[j].name,
							id:'' + msg[i].children[j].id
						});
					}
				}
				node[i].children = child;
			}
			
			layui.use(['tree', 'layer'], function(){
				  var layer = layui.layer
				  ,$ = layui.jquery; 
				  
				  layui.tree({
				    elem: '#demo2' //指定元素
				    ,target: '_blank' //是否新选项卡打开（比如节点返回href才有效）
				    ,click: function(item){ //点击节点回调
				      //layer.msg('当前节名称：'+ item.name + '<br>全部参数：'+ JSON.stringify(item));
				      //console.log(item);
				      var id = item.id;
				      var name = item.name
				      document.getElementById("treeId").value = id;
				      if(id.charAt(0) == 't'){
				    	  //document.getElementById("terminalName").innerText = name;
				    	  document.getElementById("terminalName").value = name;
				      }
				    }
				    ,nodes: node
				  });
			});
		}
	});
}

function goBack(){
	document.location = "<%=request.getContextPath()%>/material/materialList.do";
}

//function preView(){
	//var newWindow = window.open('video.html',"_blank","toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes,left=300,top=100, width=800, height=500");
	/* newWindow.document.getElementById("val").value = 'your code here'; */
//}
</script>
</body>
</html>
