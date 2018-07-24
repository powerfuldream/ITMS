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
   <title>素材管理</title>
   <link href="<%=request.getContextPath()%>/assets/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
   <link href="<%=request.getContextPath()%>/layui/css/layui.css" rel="stylesheet">
   <script type="text/javascript" src="<%=request.getContextPath()%>/layui/layui.js"></script>

<script type="text/javascript">
layui.use('upload', function(){
	  var $ = layui.jquery
	  ,upload = layui.upload;

	  
	  //演示多文件列表
	  var demoListView = $('#demoList');
	  var uploadListIns = upload.render({
	    elem: '#testList'
	    ,url: ''
	    ,accept: 'file'
	    ,multiple: true
	    ,number: 3
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
	          ,'</td>'
	        ,'</tr>'].join(''));
	        
	        //单个重传
	        tr.find('.demo-reload').on('click', function(){
	          obj.upload(index, file);
	        });
	        
	        //删除
	        tr.find('.demo-delete').on('click', function(){
	          delete files[index]; //删除对应的文件
	          tr.remove();
	          uploadListIns.config.elem.next()[0].value = ''; //清空 input file 值，以免删除后出现同名文件不可选
	        });
	        
	        demoListView.append(tr);
	      });
	    }
	    ,done: function(res, index, upload){
	      if(res.code == 0){ //上传成功
	        var tr = demoListView.find('tr#upload-'+ index)
	        ,tds = tr.children();
	        tds.eq(2).html('<span style="color: #5FB878;">上传成功</span>');
	        tds.eq(3).html(''); //清空操作
	        delete this.files[index]; //删除文件队列已经上传成功的文件
	        return;
	      }
	      this.error(index, upload);
	    }
	    ,allDone: function(obj){
	      console.log(obj)
	    }
	    ,error: function(index, upload){
	      var tr = demoListView.find('tr#upload-'+ index)
	      ,tds = tr.children();
	      tds.eq(2).html('<span style="color: #FF5722;">上传失败</span>');
	      tds.eq(3).find('.demo-reload').removeClass('layui-hide'); //显示重传
	    }
	  });
	  
	});
</script>
<script type="text/javascript">
		$(function(){
		  initGrid();
		  doSearch();
		});
		
/* 		laydate.render({
			  elem: '#testDate'
			  ,type: 'time'
			  ,range: true
			}); */
		
		//实现对DataGird控件的绑定操作  
		function initGrid() {  
		    $('#MyDatagrid').datagrid({   //定位到Table标签，Table标签的ID是grid   
		        title: '素材列表',  
		        iconCls: 'icon-save',  
		        nowrap: true,  
		        singleSelect : false,// 如果为true，则只允许选择一行。
		        autoRowHeight: true,  
		        striped: true,
		        collapsible: true,  
		        fit : true,// datagrid自适应宽高
                fitColumns : true,// 使列自动展开/收缩到合适的数据表格宽度。
		        pagination: true,  
		        rownumbers: false,  
		        idField: 'fileId',   
		        columns: [[  
		             { field: 'ck', checkbox: true },   //选择  
		             { title: '素材名', field: 'materialName', width: 160},
		             { title: '文件名', field: 'fileName', width: 160},
		             /* { title: '终端ID', field: 'terminalId', width: 40 },
		             { title: '开始时间', field: 'startTime', width: 70,
		            	 formatter : function(value){
                             var date = new Date(value);
                             var y = date.getFullYear();
                             var m = date.getMonth() + 1;
                             var d = date.getDate();
                             return y + '-' +m + '-' + d;
                         } },
		             { title: '结束时间', field: 'endTime', width: 70 ,
                             formatter : function(value){
                                 var date = new Date(value);
                                 var y = date.getFullYear();
                                 var m = date.getMonth() + 1;
                                 var d = date.getDate();
                                 return y + '-' +m + '-' + d;
                             }  },
		             { title: '时段范围', field: 'periodId', width: 160 ,
                        formatter: function(value) {
                        	if(value == null) return "插播素材";
                            var tm = $("#time"+value).val();
                            return tm;
					   }
                     },
		             { title: '频次', field: 'frequency', width: 40 }, */
		             { title: '校验码', field: 'md5', width: 40,
		            	 formatter: function(value,row,index) {
		                      return "<a href='#' onclick='md5View(" +index+ ")'>MD5</a>";
						       
						}},
		             { title: '文件类型', field: 'fileType', width: 50, 
		                formatter: function(value,row,index) {
		                      if(value == 'vedio') return '视频';
		                      else if(value == 'picture') return '图片';
		                      else if(value == 'other') return '其他';
						       
						}
					 },
					 { title: '时长', field: 'duration', width: 40,
						 formatter: function(value,row,index) {
	                      return value + '秒';
					       
						}},
					 { title: '审核状态', field: 'statusId', width: 50,
						 formatter: function(value,row,index) {
		                      if(value == '1') return '未审核';
		                      else if(value == '2') return '已初审';
		                      else if(value == '3') return '已通过';
		                      else if(value == '4') return '未通过'
						}
					 },
		             { title: '上传时间', field: 'uploadTime', width: 100,
                         formatter:function(value,row,index) {   
	                         return easyuiDateFormat(value);  
                         }
                     },
					 { title: '操作', field: 'filePath', width: 60,
                    	 formatter:function(value,row,index) {   
              			var rows = $("#MyDatagrid").datagrid('getRows');
            			var name = rows[index]['filePath'];
            			var ffname = name.split("/");
            			var fffname = ffname[ffname.length - 1];
            			return "<button type='button' class='btn btn-success'  style='margin:5px;' onclick='mediaView(" +index+ ")'>预览</button>";
            			}
					 }
		        ]],  
                toolbar: '#tb'
		    });
		    
		    pageSearchInit();
		};  
		
		function mediaView(value){
			var rows = $("#MyDatagrid").datagrid('getRows');
			var name = rows[value]['filePath'];
			var realname = name.split("/");
			document.getElementById("videoView").value = realname[realname.length - 1];
			window.open('videoView.html');
		}
		
		function md5View(value){
//			alert(value);
			var rows = $("#MyDatagrid").datagrid('getRows');
			document.getElementById("mdValue").value = rows[value]['md5'];
//			alert(rows[value]['md5']); //获取指定列
/* 					for (var i = 0; i < rows.length; i++) { 
					alert(rows[i]['md5']); //获取指定列 
					} */
			var newWindow = window.open('md.html');
			/* newWindow.document.getElementById("val").value = 'your code here'; */
		}
		
		
	
		
		var page = {
		   "currentPage" : "1", // 当前页码
	       "pageSize" : "20" // 每页多少条数据
		};
		
		
		function pageSearchInit() {  
		    var p = $("#MyDatagrid").datagrid('getPager');
            //设置分页组件参数
            $(p).pagination({
                pageSize: 20,
                pageNumber: 1,
                pageList: [20, 30, 40],
                onSelectPage: function (pageNumber, pageSize) {
	                page.currentPage = pageNumber;
	                page.pageSize = pageSize;
	                doSearch();
                }
            });
		}
		
		
		function searchReset() {
		   $("#searchForm input").val("");
		   $("#searchFileTypeSelect").val("");
		}
		
		
		
		function doSearch() {
		   var params = [];
		   var key, symbol, value;
		   

		   value = $("#searchFileName").val();
		   if(value != "") {
		      key = "materialName";
		      symbol = "like"
		      value = "%" + value + "%";
		      params.push(key);  params.push(symbol); params.push(value);
		   }
		   
		   
		   value = $("#searchFileTypeSelect").val();
		   if(value != "") {
		      key = "fileType";
		      symbol = "="
		      params.push(key);  params.push(symbol); params.push(value);
		   }
		   
		   value = $("#searchFileStatusSelect").val();
		   if(value != "") {
		      key = "statusId";
		      symbol = "="
		      params.push(key);  params.push(symbol); params.push(value);
		   }
		   
	
		    $.ajax({
			    url: '<%=request.getContextPath()%>/file/searchFile.do',
			    data: {"params": params, "currentPage" : page.currentPage, "pageSize" : page.pageSize}, 
			    traditional: true,
			    dataType : "json"
			})
		   .done(function( data ) {
			     if(data.success) {
			     
			        page.currentPage = data.obj.currentPage;
	                page.pageSize = data.obj.pageSize;
			        $('#MyDatagrid').datagrid('loadData', {"total":data.obj.totalRecord, "rows":data.obj.list});
			        $('#MyDatagrid').datagrid('clearSelections');
			     
			     } else {
			        $.messager.alert('提示', data.msg);
			     }
		    });
		   
		   
		   
		}
		
		function uploadMaterial(){
			document.location = "<%=request.getContextPath()%>/material/goUpload.do";
		}
		
		
		function upload() {
//			list();
/* 			<c:forEach items="${periods}" var="item" varStatus="status" >  
               var value = ${item.periodId};
               alert(value);
            </c:forEach> */
/*      	   var v = $("#time2").val();
            alert(v); */
     	   
			var value = '<%=session.getAttribute("periodList")%>';
			//alert(value);
		    $('.window-header .panel-title').html("上传视频");
		    $("#fileApplyform").form('clear');
		    $("#saveFileBtn").attr("onclick", "uploadFile()");
		    $('#fileWin').window('open');
 		}
		
		function uploadFile(){
			var str = $("#file").val();
 			var frequency = $("#frequency").val();
 		    if(isNaN(frequency)){					
 				$.messager.alert('提示', '输入的频次数不符');
 				return ;
 			}
			var terminalId = $("#terminal").val();
			var periodId = $("#period").val();
			var tid = $("#tid").val();
			var periodid = $("#pid").val();
			if(terminalId == null) terminalId = tid;
			if(periodId == null)  periodId = periodid;
//			alert(periodId);
			var startTime = $("#startTime").val();
			var endTime = $("#endTime").val();
			var materialName = $("#adName").val();
			
//			alert(tid);
/* 			var file1 = document.getElementById('file').files[0]; 
			var url = URL.createObjectURL(file1);
			$("#myvideo").prop("src", url);
            $("#myvideo")[0].addEventListener("loadedmetadata", function() {
                time = this.duration;
            	var tol = this.duration; //获取总时长
                alert("时长：" + tol);
            }); */
            
			if(str==""){
				$.messager.alert('提示', '请选择一个视频素材');
			}else{
				var formData = new FormData();
				formData.append("uploadFile", $("#file")[0].files[0]);
				formData.append("frequency", $("#frequency").val());
				formData.append("terminalId", terminalId);
				formData.append("startTime", startTime);
				formData.append("endTime", endTime);
				formData.append("materialName", materialName);
				formData.append("periodId", periodId);
						$.ajax({
							type : "POST",
							url : "<%=request.getContextPath()%>/file/uploadFile.do",
							data : formData,
							processData : false,
							contentType : false,
							dataType : "json",
							beforeSend: function () {
							    $.messager.progress({ 
							       title: '提示', 
							       msg: '视屏数据上传中，请稍候.....', 
//							       text: '100%' 
							    });
						    },
							success : function(date) {
								var value = date.toString();
							     if(value=="true") {
									   initGrid();
									   doSearch();
								       $.messager.progress('close');
								       $('#fileWin').window('close'); // close a window
								       $.messager.alert('提示', '上传成功');
								     }else if(value=="false"){
								    	 $.messager.progress('close');
								    	 $.messager.alert('提示', '存在同名文件，请重新命名!!');
								     } else if(value == "1"){
								    	 $.messager.progress('close');
								    	 $.messager.alert('提示', '日期范围有误或为空');
								     }else {
								    	 $.messager.progress('close');
								    	 $.messager.alert('提示', '上传失败');
								     }
							}
						}); 
					}
				}
		
		function editFile(){
			var rows = $('#MyDatagrid').datagrid('getSelections');
			if(rows.length!=1){
				$.messager.alert('提示', '请选择具体要修改的素材');
				return ;
			}else{
		    	var rows = $('#MyDatagrid').datagrid('getSelections');
				var fId = rows[0].fileId;
				var fileName = rows[0].fileName;
				var label=document.getElementById("fName1");
				label.innerText = fileName;
			    $('.window-header .panel-title').html("修改素材");
			    $("#editFileApplyform").form('clear');
			    $("#editFileBtn").attr("onclick", "editF()");
			    $('#editFileWin').window('open');
			}
		}
		
	    function editF(){
	    	var rows = $('#MyDatagrid').datagrid('getSelections');
			var fId = rows[0].fileId;
			var adName1 = $("#mName1").val();
			var startTime1 = $("#startTime1").val();
			var endTime1 = $("#endTime1").val();
			var frequency1 = $("#frequency1").val();
			var terminalId1 = $("#terminal1").val();
			var period1 = $("#period1").val();
			var tid = $("#tid").val();
			if(terminalId1 == null) terminalId1 = tid;
			if(period1 == null) period1 = "isNull";
			if(startTime1=="" && endTime1=="" && adName1=="" 
					&& terminalId1=="isNull" && period1=="isNull" && frequency1==""){
				$('#editFileWin').window('close');
				return ;
			}
			if(startTime1=="" || endTime1==""){
				$.messager.alert('提示', '日期范围有误或为空');
				return ;
			}
			$.ajax({
				type: "POST",
				url: "<%=request.getContextPath()%>/file/editFile.do",
				data:{"materialName":adName1, "startTime":startTime1,
					"endTime":endTime1, "periodId":period1, 
					"frequency":frequency1, "fileId":fId
					, "terminalId":terminalId1},
				dataType: "json",
				success: function(msg){
					var value = msg.toString();
					if(value=="true"){
						initGrid();
						doSearch();
						$('#editFileWin').window('close'); // close a window
						$.messager.alert('提示', '修改成功');
				  }else if(value=="false"){
					  $.messager.alert('提示', '存在同名文件，请重新输入!!');
				  }else if(value=="1"){
					  $.messager.alert('提示', '日期范围有误或为空!!');
				  }else if(value=="2"){
					  $.messager.alert('提示', '素材审核中，不可修改!!');
				  }else{
					  $.messager.alert('提示', '修改失败!!');
				  }
				}
			});
	    }
		
		
		function delFile(){
			var rows = $('#MyDatagrid').datagrid('getSelections');
			if(rows.length<1){
				$.messager.alert('提示', '请选择要删除的文件');
				return ;
			}
			
			$.messager.confirm('提示', '确定要删除!!', function(r){
				if(!r) return ;
				
				var fileId = [];
				
				for(var i=0;i<rows.length;i++){
					fileId.push(rows[i].fileId);
				}
				
				$.ajax({
					type: "POST",
					url: "<%=request.getContextPath()%>/file/delFile.do",
					data: {"fileId":fileId},
					traditional: true,
					dataType : "json",
					success : function(msg){
						var value = msg.toString();
						if(value=="true"){
							initGrid();
							doSearch();
							$.messager.alert('提示', '删除成功');
						}
					}
				});
			})
		}
		
		var flag = 1;
		
		function stateChange(){
			
		    var picFile = document.getElementById("file");    
		    var files = picFile.files;
		    for(var i=0; i<files.length; i++){
		        var file = files[i];
		        alert(file.name);
		        alert(file.type);
		        alert(file.size);
		        /* var div = document.createElement("div")
		        div.innerHTML = "第("+ (i+1) +") 个文件的名字："+ file.name +
		        " , 文件类型："+ file.type +" , 文件大小:"+ file.size 
		        document.body.appendChild( div) */
		    }
		    
		  /* 将上传的多个文件放入formData中 */
		    var picFileList = $("#file").get(0).files;
		    var formData = new FormData();
		    for(var i=0; i< picFileList.length; i++){
		        formData.append("file" , picFileList[i] );
		    }
			
			var file1 = document.getElementById('file').files[0]; 
			var f = document.getElementById("file");
//			alert(f.value);
			var arr = f.value.split("\\");  //注split可以用字符或字符串分割
//			var my = arr[arr.length-1];  //这就是要取得的图片名称
			var my1 = arr[arr.length-1].split(".");
			var my2 = my1[0];
//			alert(my2);
			var url = URL.createObjectURL(file1);
			$("#myvideo").prop("src", url);
            $("#myvideo")[0].addEventListener("loadedmetadata", function() {
                    time = this.duration;
                	var tol = this.duration; //获取总时长
                	var t = parseInt(tol);
//                    alert("时长：" + t);
                    document.getElementById("adName").value = my2 + " " + t + "秒";
//                    alert(111);
            }); 
            if(flag == 1){
                var app = "<input  type='button' style='background-color:#C2C2FF' onclick='preView()' value='&nbsp;&nbsp;预览&nbsp;&nbsp;'>";
                $("#view").after(app);
                flag = 0;
            }
		}
		
		function preView(){
			var newWindow = window.open('video.html');
			/* newWindow.document.getElementById("val").value = 'your code here'; */
		}
		
		
	</script>
</head>
<body class="easyui-layout">
<%-- 	<input type="hidden" id="tid" value="${ sessionScope.terminalsOne}"> --%>
	<input type="hidden" id="tid" value="isNull">
	<input type="hidden" id="pid" value="isNull">
	<input type="hidden" id="mdValue" value="">
	<input type="hidden" id="videoView" value="">
	<input type="hidden" id="timenull" value="插播素材"/>
	<c:forEach items="${periods}" var="period" varStatus="status">
		<input type='hidden' id='i${period.periodId}'
			value="${period.periodName}">
		<input type="hidden" id='time${period.periodId}'
			value="${period.periodName}  ${period.startInterval}-${period.endInterval}">
	</c:forEach>
	<div id="add"></div>

	<%-- 	<c:forEach items="${periods}" var = "period" varStatus = "status">
	   <input type="hidden" id="'i'+${period.periodId}" value="${period.periodName}">
	   <input type="hidden" id='"time"+${period.periodId}+""' value="${period.startInterval}-${period.endInterval}">
    </c:forEach> --%>
	
	<div region="center" border="false" style="padding:5px;">
	  <div id="MyDatagrid"></div>
	  
	  <div id="tb"> <!-- datagrid 的工具栏  start -->
	  
	  <div id="fileWin" class="easyui-window" title="素材上传" style="width:770px;height:500px;" closed="true">
		<form id="fileApplyform" style="padding:30px 20px 10px 40px;" enctype="multipart/form-data">

<fieldset class="layui-elem-field layui-field-title" style="margin-top: 10px;">
  <legend>多素材文件列表</legend>
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
  <button type="button" class="layui-btn" id="cancel" onclick="javascript: $('#fileWin').window('close');">取消</button>
</div> <br><br>

<!-- 		  <table border="0" style="width:100%;text-align:center;">
             <tr align=center>
                 <th align="right" width="80px">素材上传:</th>
                 <th><input type="file" name="file" id="file" width="30px" onchange="stateChange()" multiple="multiple"></th>
                 <th><input type="hidden" id = "view"></th>
              </tr>
              <tr align=center>
                 <td align="right" width="80px">&nbsp;</td>
                 <td>&nbsp;</td>
              </tr>              
           </table>
           <br>
           
		  <div style="padding:5px;text-align:center;">
				<a id="saveFileBtn" href="javascript:void(0)" class="easyui-linkbutton" icon="icon-ok" onclick="">上传</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" icon="icon-cancel" onclick="javascript: $('#fileWin').window('close');">取消</a>
		   </div> -->
		   <div>
		       <video id="myvideo" width="1px"></video>
		   </div>
	    </form>
	  </div> <!-- fileWin -->
	  
	  
	  <div id="editFileWin" class="easyui-window" title="修改素材" style="width:550px;height:450px;" closed="true">
		<form id="editFileApplyform" style="padding:30px 20px 10px 40px;" >
		  <table width="100%" border="0">
              <tr>
                 <td align="right" width="100px">文件名:</td>
                 <td><label id="fName1"></label></td>
                 <td>&nbsp;</td>
              </tr>
              <tr>
                 <td align="right" width="100px">&nbsp;</td>
                 <td>&nbsp;</td>
                 <td>&nbsp;</td>
              </tr> 
              <tr>
                 <td align="right" width="100px">素材名:</td>
                 <td><input type="text" name="mName1" id="mName1" value="" width="80px" ></td>
                 <td>&nbsp;</td>
              </tr>
              <tr>
                 <td align="right" width="100px">&nbsp;</td>
                 <td>&nbsp;</td>
                 <td>&nbsp;</td>
              </tr>
           </table>
           <br><br>
		  <div style="padding:5px;text-align:center;">
				<a id="editFileBtn" href="javascript:void(0)" class="easyui-linkbutton" icon="icon-ok" onclick="">保存</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" icon="icon-cancel" onclick="javascript: $('#editFileWin').window('close');">取消</a>
		   </div>
	    </form>
	  </div> <!-- fileWin -->
	
	    <form id="searchForm" style="padding:5px;">
	    
	     	<span>素材名:</span>
			<input id="searchFileName" name="fileName" type="text" value="">
			<span>素材类型:</span>
		    <select id="searchFileTypeSelect" name="fileType">
					   <option value=""></option>
					   <option value="vedio">视频</option>
					   <option value="picture">图片</option>
					   <option value="other">其他</option>
			</select>
			<span>审核状态:</span>
			<select id="searchFileStatusSelect" name="fileStatus">
			           <option value=""></option>
					   <option value="1">未审核</option>
					   <option value="4">未通过</option>
					   <!-- <option value="2">已初审</option> -->
					   <option value="3">通过</option>
			</select>

			<a href="javascript:void(0)" class="easyui-linkbutton" plain="true" iconCls="icon-search" onclick="doSearch()">查询</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" plain="true" iconCls="icon-reload" onclick="searchReset()">重置</a>
	    </form>
	    
	    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="uploadMaterial()">上传素材</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editFile()">修改素材</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="delFile()">删除</a>
	 </div>        <!-- datagrid 的工具栏  end -->

	  
	</div> <!-- center -->
</body>
</html>