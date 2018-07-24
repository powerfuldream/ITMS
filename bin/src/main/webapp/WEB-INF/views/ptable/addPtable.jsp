<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <%@ include  file="/assets/header.jsp"%>
   <link href="<%=request.getContextPath()%>/assets/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
   <title>添加播放表</title>
   <script type="text/javascript">
        var pid = '${pid}';
        
		$(function(){

		  if(pid == '') {
		    addInitShow();  //是添加的请求
		    
		  } else {   //如果是修改请求的话
            modifyInitShow();
		  }
		  
		});
		
		
		function modifyInitShow() {
		      $("#tipH5Id").html("播表详情页");
		      $("#savePtableBtn").attr("onclick","modifyPtable();");
		      $.ajax({
			    url: '<%=request.getContextPath()%>/ptable/getPtableById.do',
			    data: {"pid": pid}, 
			    type: "post",  
			    dataType : "json"
			  })
			  .done(function( data ) {
			     if(data.success) {
			        var playTable = data.obj.playTable;
			        var files = data.obj.files;
			        
			        $("#pnameId").val(playTable.pname);
		            fileIds = [];
		            
	                debugger;
	                var vList = []; // 初始化播放列表 var	           
		            
		            for(var i = 0; i < files.length; i++) {
		               var row = {
				         "fileId":     files[i].fileId,
				         "fileName":   files[i].fileName,
				         "materialName": files[i].materialName,
				         "fileType":   files[i].fileType,
				         "uploadTime": files[i].uploadTime,
				         "filePath": files[i].filePath
				       };
				       
		               fileIds.push(row.fileId);
		               var value = row.filePath;
		               var arr = value.split("/");
		               var path = "<%=request.getContextPath()%>/media/"+ arr[arr.length-1];
//		               alert(path);
		               vList.push(path);
			           $("#fileTableId").append(growItemContent(row));
		            }
		            

	                var curr = 0; // 当前播放的视频 
	                var video = document.getElementById("video1");
	                video.addEventListener('ended', play);
		            vLen = vList.length; // 播放列表的长度
		            play();
	                function play() {
	                    var video = document.getElementById("video1");
	                    video.src = vList[curr];
	                    video.load(); //如果短的话，可以加载完成之后再播放，监听 canplaythrough 事件即可
	                    video.play();
	                    curr++;
	                    if (curr >= vLen)
	                        curr = 0; // 播放完了，重新播放
	                }
		         
			        
			     } else {
			        $.messager.alert('消息', data.msg);
			     }
			  })
		}
		
		var fileIds;
		
	    function addInitShow() {
	       $("#tipH5Id").html("请按照提示完成添加播表操作");
	       $("#savePtableBtn").attr("onclick","addPtable();");
	       fileIds = [];
	    }
	    
	    
	    function openFileModal() {
	      $("#fileIframe").contents().find("#searchFileTypeSelect").val("vedio");
		  $("#fileIframe")[0].contentWindow.doSearch();
		  $('#fileModal').modal('show');
		}
		
	
	
		function selectFile() {
		   var rows = $("#fileIframe")[0].contentWindow.getSelectItmes();
		   if(rows.length == 0) return;
		   if(rows.length != 1 || rows[0].fileType != "vedio") {
		       $.messager.alert('提示', '一次只能选择一个视频文件');
		       return;
		   }
		   
		   var j, i = 0;
		   for(j = 0; j < fileIds.length; j++) {   //检查select的Id是否存在
		         if(rows[i].fileId == fileIds[j]) break;
		   }
		     
		   if(j >= fileIds.length) {               //如果是新加入的话
		        fileIds.push(rows[i].fileId);
		        if(jumpInsertNode == null) {
		            $("#fileTableId").append(growItemContent(rows[i]));
		        } else {
		            $(growItemContent(rows[i])).insertBefore(jumpInsertNode);
		        }
		     
		    }

		   //关闭模态框
		   $('#fileModal').modal('hide');
		   jumpInsertNode = null;
		}
		
		function delSelectFile(fileId) {  //删除选中的项
		  for(var i = 0; i < fileIds.length; i++) {
		     if(fileIds[i] == fileId) {
		        fileIds.splice(i,1);
		        $("#fileId-" + fileId).remove();     
		        return;
		     }
		   }
		}
		
		
		function resetFiles() {
		    fileIds = [];
		    $("#fileTableId").html("");
		}
		
		
		var jumpInsertNode = null;
		
		function jumpInsert(fileId) {
		    jumpInsertNode = $("#fileId-" + fileId);
		    openFileModal();
		}
		
		
		function growItemContent(row) {
             var content = '<tr id = "fileId-' +  row.fileId + '">' + 
		                     '<td>' + row.fileName + '</td>' + 
		                     '<td>' + row.materialName + '</td>' + 
		                     '<td>' + formatFileType(row.fileType) + '</td>' + 
		                     '<td>' + easyuiDateFormat(row.uploadTime) + '</td>' + 
/* 		                     '<td><button type="button" class="btn btn-warning" onclick="jumpInsert('  + row.fileId  + ')">插入</button><button type="button" class="btn btn-danger" style="margin:5px;" onclick="delSelectFile(' + row.fileId + ')">取消</button></td>' +  */
                             '<td><button type="button" class="btn btn-danger" style="margin:5px;" onclick="mediaViewTable(' + '\'' + row.filePath + '\'' + ')">预览</button></td>' +  
		                  '</tr>';	 
		     return content;
		}
		
		function mediaViewTable(value){
			//alert(value);
 			var ffname = value.split("/");
			var fffname = ffname[ffname.length - 1];
			document.getElementById("videoView").value = fffname;
			window.open('<%=request.getContextPath()%>/file/videoViewTable.html');
		}
		
		
		function formatFileType(value) {
		   if(value == 'vedio') return '视频';
		   else if(value == 'picture') return '图片';
		   else if(value == 'other') return '其他';
		}
		
		
		function goBack() {
		   document.location = "<%=request.getContextPath()%>/ptable/ptableList.do";
		}
		
		
		function addPtable() {
		   //先校验
		   var pname = $("#pnameId").val();
		   if(pname == "") {
		       $.messager.alert('提示', '请填写播表名称');
		       return;
		   } 
		   
		  var fids = [];
		  $("#fileTableId tr").each(function(){
		     var id = $(this).attr('id').split('-')[1];
		     fids.push(id);
		  });
		   
		  if(fids.length < 1) {
		       $.messager.alert('提示', '请至少选择一个要播放的视频文件');
		       return;
		  } 
		  
		   //开始保存
		      $.ajax({
			    url: '<%=request.getContextPath()%>/ptable/addPtable.do',
			    data: {"pname": pname, "fids": fids}, 
			    type: "post",
			    traditional: true,  
			    dataType : "json"
			  })
			  .done(function( data ) {
			     if(data.success) {
			       //提示成功
			        $.messager.alert("消息", "成功保存播表!", "info", function () {  
			            goBack();
			        });  
			        
			     } else {
			        $.messager.alert('消息', data.msg);
			     }
			  })
		   
		}
		
		
	    function modifyPtable() {
		   //先校验
		   var pname = $("#pnameId").val();
		   if(pname == "") {
		       $.messager.alert('提示', '请填写播表名称');
		       return;
		   } 
		   
		  var fids = [];
		  $("#fileTableId tr").each(function(){
		     var id = $(this).attr('id').split('-')[1];
		     fids.push(id);
		  });
		   
		  if(fids.length < 1) {
		       $.messager.alert('提示', '请至少选择一个要播放的视频文件');
		       return;
		  } 
		  
		   //开始保存
		      $.ajax({
			    url: '<%=request.getContextPath()%>/ptable/modifyPtable.do',
			    data: {"pid": pid, "pname": pname, "fids": fids}, 
			    type: "post",
			    traditional: true,  
			    dataType : "json"
			  })
			  .done(function( data ) {
			     if(data.success) {
			       //提示成功
			        $.messager.alert("消息", "修改播表成功!", "info", function () {  
			            goBack();
			        });  
			        
			     } else {
			        $.messager.alert('消息', data.msg);
			     }
			  })
		   
		}
		
   </script>
 </head>
<body class="easyui-layout">
	<input type="hidden" id="videoView" value=""/>
	<div region="center" border="false" style="padding:15px;">
     
		
	   <div class="alert alert-info" role="alert" style="text-align:center;vertical-align:center;"><h5 id="tipH5Id">请按照提示完成添加播表操作</h5></div>

	   <form>
<!-- 		  <div class="input-group">
 		    <span class="input-group-addon">播表名称: </span>
		    <input id="pnameId" type="text" class="form-control" placeholder="必须填写项" name="pname" value="">
		  </div> -->
		  <div class="panel panel-default" style="width:33%;float:left">
		     <div class="panel-heading">
		       <h5 class="sub-header"><i class="fa fa-video-camera"></i><span style="margin-left:2px;">播放预览:</span></h5>
		     </div>
		      <br>
		      <div align="center">
		        <video width="300" height="250" id="video1" class="indexBanner" controls="controls" autoplay>
		           <source src="" type="video/mp4" />
		        </video>
		      </div>
		  </div>
       </form>   
       <div class="panel panel-default" style="width:1%;float:left"></div>
       <div class="panel panel-default" style="width:65%;float:left">
		  <div class="panel-heading">
		     <h5 class="sub-header"><i class="fa fa-video-camera"></i><span style="margin-left:2px;">顺序播放的视频列表:</span></h5>
		  </div>
		  <div class="panel-body">
		     <table class="table table-striped">
		        <thead>
		          <tr>
		            <th>文件名称</th>
		            <th>素材名称</th>
		            <th>文件类型</th>
		            <th>上传时间</th>
		            <th>操作</th>
		          </tr>
		        </thead>
		        <tbody id="fileTableId">
		       
		        </tbody>
<!-- 		        <tr><td colspan="4" style="text-align:center;"><button type="button" class="btn btn-link" onclick="openFileModal();">添加视频文件</button></td></tr> -->
			 </table>
		  </div>
	    </div>
        
		   
	    <div style="padding:5px;text-align:center;">
<!-- 	        <button type="button" class="btn btn-info" style="margin:5px;" onclick="resetFiles();">重置</button>
			<button id="savePtableBtn" type="button" class="btn btn-primary" onclick="">保存</button> -->
		    <button type="button" class="btn btn-success"  style="margin:5px;" onclick="goBack()">返回</button>
	    </div>
		   

	</div> <!-- center -->
	
    
    <div id="fileModal" class="modal fade" tabindex="-1" role="dialog">
	  <div class="modal-dialog modal-lg" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title">选择视频文件</h4>
	      </div>
	      <div class="modal-body" style="height:400px;">
	        <iframe id="fileIframe" src="<%=request.getContextPath()%>/common/selectFile.do" width="100%" height="100%"></iframe>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	        <button type="button" class="btn btn-primary" onclick="selectFile();">确定</button>
	      </div>
	    </div><!-- /.modal-content -->
	  </div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
    
	
	<script src="<%=request.getContextPath()%>/assets/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</body>
</html>