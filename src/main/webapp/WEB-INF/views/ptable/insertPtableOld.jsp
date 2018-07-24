<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <%@ include  file="/assets/header.jsp"%>
   <link href="<%=request.getContextPath()%>/assets/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
   <title>插播信息</title>
   <script type="text/javascript" src="<%=request.getContextPath()%>/file/laydate/laydate.js"></script>
   <script src="<%=request.getContextPath()%>/assets/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
   <script type="text/javascript">
   laydate.render({
		  elem: '#testDate'
		  ,type: 'time'
		  ,range: true
		  ,done: function(value, date, endDate){
		    	var durTime1 = document.getElementById("intervalTime").value;
		    	var tim1 = document.getElementById("testDate").value;
		    	if(durTime1 == '' || tim1 == ''){
		    		document.getElementById("frequ").innerText = "";
		    	}else{
		    		if(isNaN(durTime1)){
		 				$.messager.alert('提示', '请输入整数');
		 				document.getElementById("frequ").innerText = "";
		 				return ;
		 			}else{
		 				var dat1 = tim1.split("-");
						var start1 = '2017/12/14 ' + dat1[0];
						var end1 = '2017/12/14 ' + dat1[1];
						var d3 = new Date(start1);
						var d4 = new Date(end1);
						var fre2 = parseInt(d4 - d3)/1000;
						var fre3 = parseInt(fre2/durTime1);
						document.getElementById('frequ').style.color= "red";
						document.getElementById("frequ").innerText = "约" + fre3 + "次";
		 			}
		    	}
		  }
		});
   laydate.render({
	    elem: '#test1'
	  });
   
        var pid = '${pid}';
        
		$(function(){

		  if(pid == '') {
		    addInitShow();  //是添加的请求
		    
		  } else {   //如果是修改请求的话
            modifyInitShow();
		  }
		  
		});
		
		
		function modifyInitShow() {
		      $("#tipH5Id").html("修改播表操作页");
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
		            for(var i = 0; i < files.length; i++) {
		               var row = {
				         "fileId":     files[i].mid,
				         "materialName":   files[i].materialName,
				         "duration":     files[i].duration,
				         "uploadTime": files[i].uploadTime
				       };
				       
		               fileIds.push(row.fileId);
			           $("#fileTableId").append(growItemContent(row));
		            }
		         
			        
			     } else {
			        $.messager.alert('消息', data.msg);
			     }
			  })
	
		}
		
		var fileIds;
		
	    function addInitShow() {
	       $("#tipH5Id").html("请按照提示完成插播操作");
	       $("#savePtableBtn").attr("onclick","insertPtable();");
	       fileIds = [];
	       
	       var size = '<%=session.getAttribute("tableNum")%>';
	       var content;
	       if(size == 0){
	    	   content = '<tr id="noMessage">' +
	    	       '<td colspan="6" style="text-align: center;">无相关插播信息</td>' +
	    	       '</tr>';
	    	   $("#insertTableId").append(content);
	       }else{
	    	   
	    	   <c:forEach items="${insertTables}" var="table" varStatus="status">
 	    	   var b = '${table.insertDate}';
 	    	  var date = new Date(b);
              var y = date.getFullYear();
              var m = date.getMonth() + 1;
              var d = date.getDate();
              var f = y + '-' +m + '-' + d;
              var c = '${table.status}';
              var sta;
              if(c == 1){
            	  sta = "瞬时插播";
              }else if(c == 2){
            	  sta = "延时插播";
              }
	    	   var content1 = '<tr>'+
	    	               '<td>'+ '${table.materialName}' +'</td>'+
	    	               '<td>'+ f +'</td>'+
	    	               '<td>'+ '${table.startTime}' +'</td>'+
	    	               '<td>'+ '${table.endTime}' +'</td>'+
	    	               '<td>'+ '${table.min}' +'</td>'+
	    	               '<td>'+ sta +'</td>'+
	    	               '</tr>'; 
	    	    $("#insertTableId").append(content1);
	    	   </c:forEach>
	       }       
	    }
	    
		function gradeChange(){
			var tId = $("#terminal").val();
			$("#inser tbody").html("");
			
			$.ajax({
				type: "POST",
				url: "<%=request.getContextPath()%>/ptable/fildIPtable.do",
				data: {"terminalId":tId},
				traditional: true,
				dataType : "json",
				success : function(data){
					var len = data.length;
					if(len == 0){
					   var content = '<tr id="noMessage">' +
			    	       '<td colspan="6" style="text-align: center;">无相关插播信息</td>' +
			    	       '</tr>';
			    	   $("#insertTableId").append(content);
					}else{
						for(var i=0; i < len; i++){
							var b = data[i].insertDate;
				 	    	  var date = new Date(b);
				              var y = date.getFullYear();
				              var m = date.getMonth() + 1;
				              var d = date.getDate();
				              var f = y + '-' +m + '-' + d;
				              var c = data[i].status;
				              var sta;
				              if(c == 1){
				            	  sta = "瞬时插播";
				              }else if(c == 2){
				            	  sta = "延时插播";
				              }
							var content1 = '<tr>'+
		    	               '<td>'+ data[i].materialName +'</td>'+
		    	               '<td>'+ f +'</td>'+
		    	               '<td>'+ data[i].startTime +'</td>'+
		    	               '<td>'+ data[i].endTime +'</td>'+
		    	               '<td>'+ data[i].min +'</td>'+
		    	               '<td>'+ sta +'</td>'+
		    	               '</tr>'; 
		    	    $("#insertTableId").append(content1);
						}
					}
					//alert(len);
				}
			});
		}
	    
	    
	    function openFileModal() {
	      $("#fileIframe").contents().find("#searchFileTypeSelect").val("vedio");
		  $("#fileIframe")[0].contentWindow.doSearch();
		  $('#fileModal').modal('show');
		}
		
	
	
		function selectFile() {
			document.getElementById("buttonFile").style.display = "none";
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
			$("#fileTableId").html("");
			document.getElementById("buttonFile").style.display = "none";
		    document.getElementById("buttonFile").style.display = "";
/* 		  for(var i = 0; i < fileIds.length; i++) {
		     if(fileIds[i] == fileId) {
		        fileIds.splice(i,1);
		        $("#fileId-" + fileId).remove();     
			    document.getElementById("buttonFile").style.display = "none";
			    document.getElementById("buttonFile").style.display = "";
		        return;
		     }
		   } */
		}
		
		
		function resetFiles() {
			document.getElementById("test1").value = '';
			document.getElementById("testDate").value = '';
			document.getElementById("intervalTime").value = '';
			document.getElementById("buttonFile").style.display = "";
		    fileIds = [];
		    $("#fileTableId").html("");
		}
		
		
		var jumpInsertNode = null;
		
		function jumpInsert(fileId) {
		    jumpInsertNode = $("#fileId-" + mid);
		    openFileModal();
		}
		
		
		function growItemContent(row) {
             var content = '<tr id = "fileId-' +  row.mid + '-' + row.materialName +'" >' + 
		                     '<td>' + row.materialName + '</td>' + 
		                     '<td>' + row.duration + '</td>' + 
		                     '<td>' + easyuiDateFormat(row.uploadTime) + '</td>' + 
		                     '<td><button type="button" class="btn btn-danger" style="margin:5px;" onclick="delSelectFile(' + row.mid + ')">取消</button></td>' + 
		                  '</tr>';
		     return content;
		}
		
		
		function formatFileType(value) {
		   if(value == 'vedio') return '视频';
		   else if(value == 'picture') return '图片';
		   else if(value == 'other') return '其他';
		}
		
		
		function goBack() {
		   document.location = "<%=request.getContextPath()%>/ptable/ptableList.do";
		}
		

		
		
		function insertPtable() {
		   var insertDate = $("#test1").val();
		   var intervalTime = $("#testDate").val();
		   var interval = $("#intervalTime").val();
		   var terminalId = $("#terminal").val();
		   var status = $("#stat").val();
		   if(insertDate == ""){
			   $.messager.alert('提示', '插播日期不能为空');
		       return;
		   }
		   if(intervalTime == ""){
			   $.messager.alert('提示', '插播时段不能为空');
		       return;
		   }
		   if(interval == ''){
			   $.messager.alert('提示', '插播播放间隔不能为空');
		       return;
		   }
		   if(terminalId == ''){
			   $.messager.alert('提示', '插播终端未选择');
		       return;
		   }
		   if(isNaN(interval)){					
				$.messager.alert('提示', '输入的频次数不符');
				return ;
			}
		  var fids = [];
		  var materialName;
		  $("#fileTableId tr").each(function(){
		     var id = $(this).attr('id').split('-')[1];
		     materialName = $(this).attr('id').split('-')[2];
		     fids.push(id);
		  });
		  //alert(materialName);
		   
		  if(fids.length < 1) {
		       $.messager.alert('提示', '请至少选择一个要播放的视频文件');
		       return;
		  } 
		  
		   //开始保存
		      $.ajax({
			    url: '<%=request.getContextPath()%>/ptable/insertPtable.do',
			    data: {"insertDate":insertDate,"intervalTime":intervalTime,
			    	"interval":interval,"terminalId":terminalId, 
			    	"fids": fids, "materialName":materialName, "status":status}, 
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
	    
	    function myFunction(){
	    	var durTime = document.getElementById("intervalTime").value;
	    	if(isNaN(durTime)){
 				$.messager.alert('提示', '请输入整数');
 				document.getElementById("frequ").innerText = "";
 				return ;
 			}else{
 				var tim = document.getElementById("testDate").value;
 				if(tim == ""){
 					document.getElementById("frequ").innerText = "";
 				}else{
 					var dat = tim.split("-");
 					var start = '2017/12/14 ' + dat[0];
 					var end = '2017/12/14 ' + dat[1];
 					var d1 = new Date(start);
 					var d2 = new Date(end);
 					var fre = parseInt(d2 - d1)/1000;
 					var fre1 = parseInt(fre/durTime);
 					document.getElementById('frequ').style.color= "red";
 					document.getElementById("frequ").innerText = "约" + fre1 + "次";
 				}
 			}
	    }
	    
	    function change(){
	    	//alert(222);
	    	var durTime1 = document.getElementById("intervalTime").value;
	    	var tim1 = document.getElementById("testDate").value;
	    	if(durTime1 == '' || tim1 == ''){
	    		document.getElementById("frequ").innerText = "";
	    	}else{
	    		if(isNaN(durTime1)){
	 				$.messager.alert('提示', '请输入整数');
	 				document.getElementById("frequ").innerText = "";
	 				return ;
	 			}else{
	 				var dat1 = tim1.split("-");
					var start1 = '2017/12/14 ' + dat1[0];
					var end1 = '2017/12/14 ' + dat1[1];
					var d3 = new Date(start1);
					var d4 = new Date(end1);
					var fre2 = parseInt(d4 - d3)/1000;
					var fre3 = parseInt(fre2/durTime1);
					document.getElementById('frequ').style.color= "red";
					document.getElementById("frequ").innerText = "约" + fre3 + "次";
	 			}
	    	}
	    }
		
   </script>
 </head>
<body class="easyui-layout">

	<div region="center" border="false" style="padding: 15px;">
		<div class="alert alert-info" role="alert"
			style="text-align: center; vertical-align: center;">
			<h5 id="tipH5Id">请按照提示完成添加播表操作</h5>
		</div>

		<div class="panel panel-default">
			<div class="panel-heading">
				<h5 class="sub-header">
					<i class="fa fa-video-camera"></i>
					<span style="margin-left: 2px;">终端已有插播信息:&nbsp;&nbsp;&nbsp;&nbsp;终端名:
					<select name="terminal" id="terminal" onchange="gradeChange()">
                      <c:forEach items="${terminals}" var = "terminal" varStatus = "status">
                          <c:if test="${status.count == 1}">                            
                            <option selected="selected" value="${terminal.terminalId}">${terminal.terminalName}</option>
                          </c:if>
                          <c:if test="${status.count != 1}">
                            <option value="${terminal.terminalId}">${terminal.terminalName}</option>
                          </c:if>
                      </c:forEach>
                   </select>
					</span>
									<!-- <span class="input-group-addon"> </span> -->

				</h5>
			</div>
			<div class="panel-body">
				<table class="table table-striped" id="inser">
					<thead>
						<tr>
							<th>素材名称</th>
							<th>插播日期</th>
							<th>开始时间</th>
							<th>结束时间</th>
							<th>间隔</th>
							<th>插播时态</th>
						</tr>
					</thead>
					<tbody id="insertTableId">
<%--  					   	<c:forEach items="${insertTables}" var="table" varStatus="status">
					   	  <tr>
					   	     <td>${table.materialName}</td>
					   	     <td>${table.insertDate}</td>
					   	     <td>${table.startTime}</td>
					   	     <td>${table.endTime}</td>
					   	     <td>${table.min}</td>
					   	  </tr>
	                    </c:forEach> --%>
					</tbody>
				</table>
			</div>
		</div>

		<form>
			<div class="input-group">
				<span class="input-group-addon">插播日期: </span>
				<!-- 		    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;">
  <legend>同时绑定多个</legend>
</fieldset> -->

				<div class="layui-form">
					<div class="layui-form-item">
						<div class="layui-inline">
							<input type="text" class="layui-input test-item" id="test1"
								placeholder="yyyy-MM-dd">
						</div>
					</div>
				</div>

				<span class="input-group-addon">插播时段: </span> <input type="text"
					id="testDate"> 
				<span class="input-group-addon">插播时态:
				</span>
				<select name="stat" id="stat">
				   <option selected="selected" value="1">瞬时插播</option>
				   <option value="2">延时插播</option>
				</select>
				<span class="input-group-addon">时段间隔:
				</span> <input type="text" id="intervalTime" oninput='myFunction()'>&nbsp;&nbsp;秒
				&nbsp;&nbsp;<label id="frequ" style="width:60px;"></label>
			</div>
		</form>
		<br />

		<div class="panel panel-default">
			<div class="panel-heading">
				<h5 class="sub-header">
					<i class="fa fa-video-camera"></i><span style="margin-left: 2px;">插播素材信息:</span>
				</h5>
			</div>
			<div class="panel-body">
				<table class="table table-striped">
					<thead>
						<tr>
							<th>素材名称</th>
							<th>素材时长</th>
							<th>上传时间</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody id="fileTableId">

					</tbody>
					<tr>
						<td colspan="4" style="text-align: center;"><button id="buttonFile"
								type="button" class="btn btn-link" onclick="openFileModal();">添加素材视频</button></td>
					</tr>
				</table>
			</div>
		</div>


		<div style="padding: 5px; text-align: center;">
			<button type="button" class="btn btn-info" style="margin: 5px;"
				onclick="resetFiles();">重置</button>
			<button id="savePtableBtn" type="button" class="btn btn-primary"
				onclick="">保存</button>
			<button type="button" class="btn btn-success" style="margin: 5px;"
				onclick="goBack()">返回</button>
		</div>


	</div>
	<!-- center -->


	<div id="fileModal" class="modal fade" tabindex="-1" role="dialog">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title">选择视频文件</h4>
				</div>
				<div class="modal-body" style="height: 400px;">
					<iframe id="fileIframe"
						src="<%=request.getContextPath()%>/common/selectFile.do"
						width="100%" height="100%"></iframe>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" onclick="selectFile();">确定</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	<!-- /.modal -->
</body>
</html>