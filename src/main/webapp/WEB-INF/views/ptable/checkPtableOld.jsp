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
   <%@ include  file="/assets/header.jsp"%>
   <link href="<%=request.getContextPath()%>/assets/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
   <link href="<%=request.getContextPath()%>/st/app.css" rel="stylesheet" type="text/css" />
   <link href="<%=request.getContextPath()%>/layui/css/layui.css" rel="stylesheet">
   <script type="text/javascript" src="<%=request.getContextPath()%>/layui/layui.js"></script>
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
		      $("#tipH5Id").html("播表一级审核页");
		      $("#savePtableBtn").attr("onclick","saveListFile();");
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
				         "fileId":     files[i].mid,
				         "fileName":   files[i].fileName,
				         "materialName": files[i].materialName,
				         "startTime":files[i].startTime,
				         "endTime":files[i].endTime,
				         "fileType":   files[i].fileType,
				         "uploadTime": files[i].uploadTime,
				         "filePath": files[i].filePath
				       };
				       
		               fileIds.push(row.mid);
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
	    
		function editNum(){
			$('.window-header .panel-title').html("修改播表素材顺序");
		    $("#editFileApplyform").form('clear');
		    $("#editFileBtn").attr("onclick", "saveListFile()");
		    $('#editPeriodWin').window('open');
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
		         if(rows[i].mid == fileIds[j]) break;
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
			var date = new Date(row.startTime);
            var y = date.getFullYear();
            var m = date.getMonth() + 1;
            var d = date.getDate();
            var date = new Date(row.endTime);
            var y1 = date.getFullYear();
            var m1 = date.getMonth() + 1;
            var d1 = date.getDate();
            var start = y + '-' +m + '-' + d;
            var end = y1 + '-' +m1 + '-' + d1;
             var content = '<tr id = "fileId-' +  row.mid + '">' + 
		                     '<td>' + row.materialName + '</td>' + 
		                     '<td>' + start + '</td>' + 
		                     '<td>' + end + '</td>' + 
 		                     '<td><button type="button" class="btn btn-danger" style="margin:5px;" onclick="mediaViewTable(' + '\'' + row.filePath + '\'' + ')">预览</button></td>' +  
		                  '</tr>';
		     //alert(content);
		     var path = row.filePath;
		     //alert(path);
		     var content1 = "<tr id = 'fileId-" +  row.mid + "'>" + 
		                      "<td>" + row.fileName + "</td>" + 
		                      "<td>" + row.materialName + "</td>" + 
		                      "<td><button type='button' class='btn btn-danger' style='margin:5px;' onclick='mediaViewTable(" + row.fileId + ")'>预览</button></td>" + 
		                      "</tr>";
		     //alert(content1);
		     return content;
		}
		
		function mediaViewTable(value){
			//alert(value);
 			var ffname = value.split("/");
			var fffname = ffname[ffname.length - 1];
			document.getElementById("videoView").value = fffname;
			window.open('<%=request.getContextPath()%>/file/videoViewTable.jsp',"_blank","toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes,left=300,top=100, width=800, height=550");
		}
		
		
		function formatFileType(value) {
		   if(value == 'vedio') return '视频';
		   else if(value == 'picture') return '图片';
		   else if(value == 'other') return '其他';
		}
		
		
		function goBack() {
		   document.location = "<%=request.getContextPath()%>/ptable/ptableCheckList.do";
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
	<input type="hidden" id="modifyPid" value='<%=session.getAttribute("modifyPid")%>'/>
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
		            <th>素材名称</th>
		            <th>开始日期</th>
		            <th>结束日期</th>
		            <th>视频预览</th>
		          </tr>
		        </thead>
		        <tbody id="fileTableId">
		       
		        </tbody>
<!-- 		        <tr><td colspan="4" style="text-align:center;"><button type="button" class="btn btn-link" onclick="openFileModal();">添加视频文件</button></td></tr> -->
			 </table>
		  </div>
	    </div>
	    
	    
	    	  <div id="editPeriodWin" class="easyui-window" title="修改时段" style="width:500px;height:550px;" closed="true">
		<form id="editFileApplyform" style="padding:30px 20px 10px 40px;" >
		     <h5><i class="fa fa-video-camera"></i><span style="margin-left:2px;">顺序播放视频调整列表(拖拽):</span></h5>
		  <div>
				<ul id="foo" class="block__list block__list_words">
<!-- 					<li drag-id="1">1</li>
					<li drag-id="2">2</li>
					<li drag-id="3">3</li>
					<li drag-id="4">4</li>
					<li drag-id="5">5</li>
					<li drag-id="6">6</li>
					<li drag-id="7">7</li>
					<li drag-id="8">8</li> -->
					<c:forEach items="${sessionScope.tableFirst}" var="table" varStatus="status">
						<li drag-id="${table.mid}">${table.materialName}</li>
					</c:forEach>
				</ul>
		</div>
           <br><br>
		  <div style="padding:5px;text-align:center;">
				<a id="editFileBtn" href="javascript:void(0)" class="easyui-linkbutton" icon="icon-ok" onclick="">保存</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" icon="icon-cancel" onclick="javascript: $('#editPeriodWin').window('close');">取消</a>
		   </div>
	    </form>
	  </div>	                 

      <div style="width:33%;float:left;text-align:right;">
         <br><br>
         <!-- <label><font size="4" color="green">审核不通过理由</font></label>&nbsp;&nbsp;&nbsp; -->
      </div>
      <div style="width:2%;float:left;text-align:right;"></div>
      <div style="width:65%;float:left">
         &nbsp;&nbsp;&nbsp;<label><font size="4" color="green">审核不通过理由:</font></label>
            <div class="checkbox">              
              &nbsp;&nbsp;&nbsp;<label><input id="checkUn1" name="r" type="checkbox" value="1">
              <font size="4" color="red">排播有误</font>
              </label>
            </div>
            <div class="checkbox">
              &nbsp;&nbsp;&nbsp;<label><input id="checkUn2" name="r" type="checkbox" value="2">
              <font size="4" color="red">素材敏感信息</font>
              </label>
            </div>
      </div>
      
      <div style="width:33%;float:left;text-align:right;">
         <br><br>
      </div>
      <div style="width:2%;float:left;text-align:right;"></div>
      <div style="width:65%;float:left">
         &nbsp;&nbsp;&nbsp;
         <button type="button" class="btn btn-success"  style="margin:5px;" onclick="editNum()">修改顺序</button>
		 <button id="savePtableBtn" type="button" class="btn btn-primary" onclick="">审核通过</button>
		 <button id="" type="button" class="btn btn-primary" onclick="ptableUnaccess()">审核不通过</button>
		 <button type="button" class="btn btn-success"  style="margin:5px;" onclick="goBack()">返回</button>
      </div>

	    <!-- <div style="padding:5px;text-align:center;">	    
        <button type="button" class="btn btn-info" style="margin:5px;" onclick="resetFiles();">重置</button>			
	    </div> -->
		   

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
	   <script type="text/javascript" src="<%=request.getContextPath()%>/st/Sortable.js"></script>
   <script>
        
        var listFile='';
   
		Sortable.create(document.getElementById('foo'), {
			animation : 150, //动画参数
			onAdd : function(evt) { //拖拽时候添加有新的节点的时候发生该事件
				console.log('onAdd.foo:', [ evt.item, evt.from ]);
			},
			onUpdate : function(evt) { //拖拽更新节点位置发生该事件
				console.log('onUpdate.foo:', [ evt.item, evt.from ]);
			},
			onRemove : function(evt) { //删除拖拽节点的时候促发该事件
				console.log('onRemove.foo:', [ evt.item, evt.from ]);
			},
			onStart : function(evt) { //开始拖拽出发该函数
				console.log('onStart.foo:', [ evt.item, evt.from ]);
			},
			onSort : function(evt) { //发生排序发生该事件
				console.log('onSort.foo:', [ evt.item, evt.from ]);
			},
			onEnd : function(evt) { //拖拽完毕之后发生该事件
				console.log('onEnd.foo:', [ evt.item, evt.from ]);
				var id_arr = '';
				for (var i = 0, len = evt.from.children.length; i < len; i++) {
					id_arr += ','
							+ evt.from.children[i].getAttribute('drag-id');
				}
				//alert(id_arr);
				id_arr = id_arr.substr(1);
				listFile = id_arr;
				//然后请求后台ajax 这样就完成了拖拽排序
				//alert(id_arr);
				//console.log(id_arr);
			}
		});
		
		function ptableUnaccess(){
			var ppid = document.getElementById("modifyPid").value;
		    var r=document.getElementsByName("r");
		    var checkArray = [];
		    for(var i=0;i<r.length;i++){
		         if(r[i].checked){
		        	 checkArray.push(r[i].value);
		       }
		    }
		    if(checkArray.length == 0){
		    	$.messager.alert('提示', '请选择不通过理由');
		    	return ;
		    }
		    $.ajax({
		    	type: "POST",
				url: "<%=request.getContextPath()%>/ptable/playTableUnAccess.do",
				data: {"ppid" : ppid,"checkArray":checkArray},
				traditional: true,
				dataType : "json",
				success : function(msg){
					var value = msg.toString();
					if(value=="true"){
						$.messager.alert('提示', '保存成功!!!');
						document.location = "<%=request.getContextPath()%>/ptable/ptableCheckList.do";
					}else{
						$.messager.alert('提示', '审核保存失败!!!');
					}
				}
		    });
		}
		
		function editList(){
			
			layui.use('layer', function(){
				  var layer = layui.layer;
				  
				  layer.open({
					    title:'时段列表',
						type:2,
						area:['60%','80%'],
						content:'/ITMS/file/materialList.jsp'
						//content:'/ITMS/period/periodList.do'
					}); 
				});
		}
		

		
		function saveListFile(){
			var ppid = document.getElementById("modifyPid").value;
			if(listFile == '') {
				//$.messager.alert('提示', '顺序未改动');
				$.ajax({
					type: "POST",
					url: "<%=request.getContextPath()%>/ptable/modifyPlayTableNum.do",
					data: {"ppid" : ppid,"sortNum":listFile},
					traditional: true,
					dataType : "json",
					success : function(msg){
						var value = msg.toString();
						if(value=="true"){
							$.messager.alert('提示', '审核成功!!!');
							document.location = "<%=request.getContextPath()%>/ptable/ptableCheckList.do";
							$('#editPeriodWin').window('open');
						}else{
							$.messager.alert('提示', '审核保存失败!!!');
						}
					}
				});
			}else{
					//alert(listFile);//modifyPlayTableNum
					$.ajax({
						type: "POST",
						url: "<%=request.getContextPath()%>/ptable/modifyPlayTableNum.do",
						data: {"ppid" : ppid,"sortNum":listFile},
						traditional: true,
						dataType : "json",
						success : function(msg){
							var value = msg.toString();
							if(value=="true"){
								//initGrid();
								//doCheckSearch();
								$.messager.alert('提示', '保存成功!!!');
								document.location = "<%=request.getContextPath()%>/ptable/ptableCheckList.do";
								$('#editPeriodWin').window('open');
							}else{
								$.messager.alert('提示', '保存失败!!!');
							}
						}
					});
				}
			}			
	</script>
</body>
</html>