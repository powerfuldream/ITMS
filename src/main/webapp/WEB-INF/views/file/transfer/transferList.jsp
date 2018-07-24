<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <%@ include  file="/assets/header.jsp"%>
   <link href="<%=request.getContextPath()%>/assets/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
   <title>传输文件</title>
   <script type="text/javascript">
		$(function(){
		  init();
		});
		
		var fileIds;
		var terminalIds;
		
	    function init() {
	       fileIds = [];
		   terminalIds = [];
		   
	    }
	    
	    
	    function openFileModal() {
		  $("#fileIframe")[0].contentWindow.doSearch();
		  $('#fileModal').modal('show');
		}
		
	
		function selectFile() {
		   var j;
		   var rows = $("#fileIframe")[0].contentWindow.getSelectItmes();
		   for(var i = 0; i < rows.length; i++) {
		   
		     for(j = 0; j < fileIds.length; j++) {   //检查select的Id是否存在
		         if(rows[i].mid == fileIds[j]) break;
		     }
		     
		     if(j >= fileIds.length) {               //如果是新加入的话
		          fileIds.push(rows[i].mid);
		          $("#fileTableId").append('<tr id = "fileId-' +  rows[i].mid + '">' + 
		                                       '<td>' + rows[i].fileName + '</td>' + 
		                                       '<td>' + formatFileType(rows[i].fileType) + '</td>' + 
		                                       '<td>' + easyuiDateFormat(rows[i].uploadTime) + '</td>' + 
		                                       '<td><button type="button" class="btn btn-danger" onclick="delSelectFile(' + rows[i].mid + ')">取消</button></td>' + 
		                                    '</tr>');
		     }
		     
		   }
		   
		   //关闭模态框
		   $('#fileModal').modal('hide');
		
		}
		
	    function formatFileType(value) {
		   if(value == 'vedio') return '视频';
		   else if(value == 'picture') return '图片';
		   else if(value == 'other') return '其他';
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
		
		
		function openTerminalModal() {
		  $("#terminalIframe")[0].contentWindow.doSearch();
		  $('#terminalModal').modal('show');
		}
		
	    function selectTerminal() {
		   var j;
		   var rows = $("#terminalIframe")[0].contentWindow.getSelectItmes();
		   console.log(rows);
		   for(var i = 0; i < rows.length; i++) {
		   
		     for(j = 0; j < terminalIds.length; j++) {   //检查select的Id是否存在
		         if(rows[i].terminalId == terminalIds[j]) break;
		     }
		     
		     if(j >= terminalIds.length) {               //如果是新加入的话
		          terminalIds.push(rows[i].terminalId);
		          $("#terminalTableId").append('<tr id = "terminalId-' +  rows[i].terminalId + '">' + 
		                                       '<td>' + rows[i].serialNumber + '</td>' + 
		                                       '<td>' + rows[i].terminalName + '</td>' + 
		                                       '<td>' + rows[i].detailAddress + '</td>' + 
		                                       '<td><button type="button" class="btn btn-danger" onclick="delSelectTerminal(' + rows[i].terminalId + ')">取消</button></td>' + 
		                                    '</tr>');
		     }
		     
		   }
		   
		   //关闭模态框
		   $('#terminalModal').modal('hide');
		   
		}
		
		function delSelectTerminal(terminalId) {
		   for(var i = 0; i < terminalIds.length; i++) {
		     if(terminalIds[i] == terminalId) {
		        terminalIds.splice(i,1);
		        $("#terminalId-" + terminalId).remove();     
		        return;
		     }
		   }
		}
		
		function resetTerminals() {
		    terminalIds = [];
		    $("#terminalTableId").html("");
		}
		
		
		function startTransfer() {
		     //显示进度条
     		 $.messager.progress({ 
		       title: '提示', 
		       msg: '传输进行中，请稍候.....'
		     });
		  
			  $.ajax({
			    url: '<%=request.getContextPath()%>/file/transferFile.do',
			    data:{"fileIds": fileIds, "terminalIds": terminalIds, "isOffset": "false"}, 
			    type: "post",
			    traditional: true,  
			    dataType : "json"
			  })
			  .done(function( data ) {
			     if(data.success) {
			        //成功传输的话
			        if(data.obj.fIdNoList.length == 0 && data.obj.tIdOffList.length == 0) {
			          $('#resultShow').html("全部传输成功!");
			        } else {
			          var str = "";
			          if(data.obj.fIdNoList.length != 0) {
			              str += "以下文件名传输失败: <br/>"
			              for(var i = 0; i < data.obj.fIdNoList.length; i++) {
			                  var fileName = $("#fileId-" + data.obj.fIdNoList[i]).children('td').eq(0).html();
			                  str += fileName + "<br/>"
			              }
			          
			          }
			          
			          if(data.obj.tIdOffList.length != 0) {
			              str += "<br/>以下播放端名称(因为离线)无法完成传输: <br/>"
			              for(var i = 0; i < data.obj.tIdOffList.length; i++) {
			                  var terminalName = $("#terminalId-" + data.obj.tIdOffList[i]).children('td').eq(1).html();
			                  str += terminalName + "<br/>"
			              }
			          
			          }
			          
			          $('#resultShow').html(str);
			
			        }
			        
			        $('#ResultModal').modal('show');
			     
			     } else {
			         $.messager.alert('消息', data.msg);
			     }
			  })
			  .fail(function( xhr, status, errorThrown ) {
			    alert( "Sorry, there was a problem!" );
			    console.log( "Error: " + errorThrown );
			    console.log( "Status: " + status );
			    console.dir( xhr );
			  })
			  .always(function( xhr, status ) {
			      $.messager.progress('close'); //关闭进度条
			  });
			  
		}
		
		
   </script>
 </head>
<body class="easyui-layout">
	
	<div region="center" border="false" style="padding:15px;">
         
       <div class="panel panel-default">
		  <div class="panel-heading">
		     <h5 class="sub-header"><i class="fa fa-file-text-o"></i><span style="margin-left:2px;">需要传输的文件列表</span></h5>
		  </div>
		  <div class="panel-body">
		     <table class="table table-striped">
		        <thead>
		          <tr>
		            <th>文件名称</th>
		            <th>文件类型</th>
		            <th>上传时间</th>
		            <th>操作</th>
		          </tr>
		        </thead>
		        <tbody id="fileTableId">
		       
		        </tbody>
		        <tr><td colspan="4" style="text-align:center;"><button type="button" class="btn btn-link" onclick="openFileModal();">添加传输文件</button></td></tr>
			 </table>
		  </div>
	    </div>
         
		
	   <h4 style="text-align:center;"><i class="fa fa-cloud-download fa-2x"></i></h4>
       
       <div class="panel panel-default">
		  <div class="panel-heading">
		     <h5 class="sub-header"><i class="fa fa-film"></i><span style="margin-left:2px;">传输到的播放端列表</span></h5>
		  </div>
		  <div class="panel-body">
		     <table class="table table-striped">
		        <thead>
		          <tr>
		              <th>序列号码</th>
		              <th>播放端名称</th>
		              <th>安装地址</th>
		              <th>操作</th>
		          </tr>
		        </thead>
		        <tbody id="terminalTableId">
		       
		        </tbody>
		        <tr><td colspan="4" style="text-align:center;"><button type="button" class="btn btn-link" onclick="openTerminalModal();">添加传输到的播放端</button></td></tr>
			 </table>
		  </div>
	    </div>
        
		   
	    <div style="padding:5px;text-align:center;">
		    <button type="button" class="btn btn-warning" style="margin:5px;" onclick="resetFiles();">重选文件</button>
			<button type="button" class="btn btn-primary" onclick="startTransfer();">开始传输</button>
		    <button type="button" class="btn btn-info"  style="margin:5px;" onclick="resetTerminals();">重选终端</button>
	    </div>
		   

	</div> <!-- center -->
	
    
    <div id="fileModal" class="modal fade" tabindex="-1" role="dialog">
	  <div class="modal-dialog modal-lg" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title">选择传输的文件</h4>
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
    
    <div id="terminalModal" class="modal fade" tabindex="-1" role="dialog">
	  <div class="modal-dialog modal-lg" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title">选择传输到的播放端</h4>
	      </div>
	      <div class="modal-body" style="height:400px;">
	        <iframe id="terminalIframe" src="<%=request.getContextPath()%>/common/selectTerminal.do" width="100%" height="100%"></iframe>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	        <button type="button" class="btn btn-primary" onclick="selectTerminal();">确定</button>
	      </div>
	    </div><!-- /.modal-content -->
	  </div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
	
	
	<div id="ResultModal" class="modal fade" tabindex="-1" role="dialog">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title">传输结果</h4>
	      </div>
	      <div class="modal-body">
	            <div id="resultShow"></div>
	      </div>
	      <div class="modal-footer" style="text-align:center;">
	        <button type="button" class="btn btn-primary" data-dismiss="modal">确定</button>
	      </div>
	    </div><!-- /.modal-content -->
	  </div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
	
	
	<script src="<%=request.getContextPath()%>/assets/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</body>
</html>