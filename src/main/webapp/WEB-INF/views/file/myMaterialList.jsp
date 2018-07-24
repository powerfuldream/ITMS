<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <%@ include file="/layui/header.jsp"%>
   <style type="text/css">
.layui-table-fixed .layui-table-body {overflow: visible}
.layui-table-view .layui-table{overflow: visible;}
.layui-table tr{overflow: visible;}
.layui-table-cell{overflow: visible;}
.layui-input{width:110px;height:30px;}
</style>
   <title>我的素材列表</title>
   <meta name="renderer" content="webkit">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
   <%-- <script src="<%=request.getContextPath()%>/layui/jquery-1.8.2.min.js"></script> --%>
   <script type="text/javascript" defer="defer">
   var node = [];
   var terminalVal = [];
   $(function(){
	   getAllTerminal();
	   init();
   });
   
   function getAllTerminal(){
	   $.ajax({
		    url: '<%=request.getContextPath()%>/material/findAllTerminal.do',
		    type: "get",
		    dataType : "json",
		  })
		  .done(function( msg ) {
			  var data = msg.data;
		      for(var i = 0; i < data.length; i++) {
		    	  terminalVal.push(data[i]);
		      }
		      console.log(terminalVal.length);
		  })
		  .fail(function( xhr, status, errorThrown ) {
		    alert( "Sorry, there was a problem!" );
		    console.log( "Error: " + errorThrown );
		    console.log( "Status: " + status );
		    console.dir( xhr );
		  })
   }
   
      function init(){
    	  layui.use('layer', function(){
    		  var layer = layui.layer;
    		  //layer.zIndex();
    		});
    	  
    	  layui.use('laydate', function(){
    		  var laydate = layui.laydate;
    		  //执行一个laydate实例
    		  laydate.render({
    		    elem: '#dateTime' //指定元素
    		    ,range: true
    		  });
    		});
    	  
		  
    	  var param = "";
		  var whereSuffix = "";
    	  
		   //名称
		   var materialName = $("#materialName").val();
		   if(materialName != ""){
			   param = param + "materialName" + ",like,%" + materialName + "%,";
		   }
		   
		   var tis = $("#tis").val();
		   if(tis != ""){
			   param = param + "tis" + ",=," + tis + ",";
		   }
		   
/* 		   //类型
		   var fileType = $("#fileType").val();
		   if(fileType != ""){
			   param = param + "fileType" + ",=," + fileType + ",";
		   } */
		   
		   //状态
		   var statusId = $("#statusId").val();
		   if(statusId != ""){
			   param = param + "statusId" + ",=," + statusId + ",";
		   }
		   
		   //时间
		   var dateTime = $("#dateTime").val();
		   if(dateTime != ""){
			   var datime = dateTime.split(" ");
			   console.log(datime[0]);
			   console.log(datime[2]);
			   var start = datime[0].trim();
			   var end = datime[2].trim();
			   whereSuffix += " AND DATE_FORMAT(uploadTime, '%Y-%m-%d') = '" + start + "'";
			   whereSuffix += " AND DATE_FORMAT(uploadTime, '%Y-%m-%d') <= '" + end + "'";
		   }
		   
		   console.log(param);
    	  
    	  layui.use('table', function(){
    		  var table = layui.table;
    		  table.render({
    		    elem: '#table1'
    		    ,id: 'flagTwo'
    		    ,url:'<%=request.getContextPath()%>/material/searchMyFile.do'
    		    //,height: 550
    		    //,cellMinWidth: 120
    		    ,limits:[10,25,50,75,100]
    		    ,cols: [[
    		      //{field:'id', width:'1%'}
    		      {checkbox: true, event: 'set1', fixed: true}
    		      ,{field:'materialName',width:280, event: 'set2', title: '素材名',  sort: true}
    		      ,{field:'terminalName',width:200, event: 'set3', title: '终端名(已智能选择待绑定)',  sort: true
    		    	  ,templet: function(d){
    		    		  var tis1 = d.tis;
      		    		  var tname = d.terminal;
      		    		  var name = d.terminalName;
      		    		  var mid = d.mid;
      		    		  console.log(name);
      		    		  if(tis1 == "0"){
      		    			 var content = '<select lay-ignore name="terminal' + mid + '" id="terminal' + mid + '" style="width: 150px; height: 30px;" lay-filter="test"> ';
      		    			 for(var i = 0; i < terminalVal.length; i++){
      		    				 if(name == terminalVal[i].terminalName){
      		    					content = content + ' <option value="' + terminalVal[i].terminalId + '" selected>' + terminalVal[i].terminalName + '</option> ';
      		    				 }else{
      		    					content = content + ' <option value="' + terminalVal[i].terminalId + '">' + terminalVal[i].terminalName + '</option> ';
      		    				 }
      		    			 }
      		    			 content = content + ' </select>';
      		    			  return content;
      		    			         
      		    			  //return '<span style="color: #FF6347;">' + '未选择' + '</span>';
      		    		  }else{
      		    			  return '<span style="color: #1E9FFF;">' + tname.terminalName + '(已选择)</span>';
      		    		  }
      		    	  }  
    		      }
    		      ,{field:'statusId',width:100, event: 'set4', title: '审核状态', sort: true
    		    	  ,templet: function(d){
    		    		  var state = d.statusId;
    		    		  if(state == 1){
    		    			  return '<span style="color: #FF6347;">' + '未审核' + '</span>';
    		    		  }else if(state == 2){
    		    			  return '<span style="color: #90EE90;">' + '已初审' + '</span>';
    		    		  }else if(state == 3){
    		    			  return '<span style="color: #90EE90;">' + '已通过' + '</span>';
    		    		  }else if(state == 4){
    		    			  return '<span style="color: #FF6347;">' + '未通过' + '</span>';
    		    		  }
    		    	  }
    		      }
    		      ,{field:'resolution',width:100, event: 'set5', title: '分辨率'}
    		      ,{field:'size',width:130, event: 'set6', title: '大小'}
    		      ,{field:'duration',width:100, event: 'set7', title: '时长(秒)', sort: true}
    		      ,{field:'info',width:100, event: 'set8', title: '排播状态', sort: true
    		    	  ,templet: function(d){
    		    		  var state = d.info;
    		    		  if(state == 0){
    		    			  return '<span style="color: #FF6347;">' + '未排播' + '</span>';
    		    		  }else if(state == 1){
    		    			  return '<span style="color: #90EE90;">' + '已排播' + '</span>';
    		    		  }
    		    	  }
    		      }
    		      ,{field:'usedNum',width:130, event: 'set9', title: '使用次数'}
    		      ,{field:'uploadTime',width:160, event: 'set10', title: '上传时间', sort: true
    		    	  ,templet: function(d){
    		    		  var date = new Date(d.uploadTime);
    		    		  var Y = date.getFullYear() + '-';
    		    		  var M = (date.getMonth()+1 < 10 ? '0'+(date.getMonth()+1) : date.getMonth()+1) + '-';
    		    		  var D = (date.getDate() < 10 ? '0' + (date.getDate()) : date.getDate()) + ' ';
    		    		  var h = (date.getHours() < 10 ? '0' + date.getHours() : date.getHours()) + ':';
    		    		  var m = (date.getMinutes() <10 ? '0' + date.getMinutes() : date.getMinutes()) + ':';
    		    		  var s = (date.getSeconds() <10 ? '0' + date.getSeconds() : date.getSeconds());
    		    		  return Y+M+D+h+m+s;
    		    	  }
    		      }
    		      ,{field:'uploadName',width:90, event: 'set11', title: '上传人', sort: true}
    		      ,{fixed: 'right', width:80, event: 'set12', title: '操作', align:'center', toolbar: '#barDemo'}
    		    ]]
    		    ,page: true
    		    ,where: {"param": param,"dateTime":dateTime}
    		    ,done: function(res, curr, count){
    		    	  //changeBg();
    		      }
    		  });
    		  
    		  var active = {
    				  getDeleteData: function(){ //获取选中数据
    				      var checkStatus = table.checkStatus('flagTwo')
    				      ,data = checkStatus.data;
    				      var mids = [];
    				      for(var i = 0; i < data.length; i++){
    					      mids.push(data[i].mid);
    				      }
    				      if(mids.length == 0){
    				    	  layer.msg('请选择要删除的数据!',{icon:6,time:1500});
    				    	  return ;
    				      }
    				      //批量删除
    				      layer.confirm('真的删除这些素材么', function(index){
    					         //obj.del();
    					         layer.close(index);
    					         console.log(mids.length);
    					         $.ajax({
    									type: "POST",
    									url: "<%=request.getContextPath()%>/material/delMaterial.do",
    									data: {"mid":mids},
    									traditional: true,
    									dataType : "json",
    									success : function(msg){
    										var value = msg.toString();
    										if(value=="true"){
    											terminalVal = [];
    									    	getAllTerminal();
    											init();
    											layer.msg('删除成功!',{icon:6,time:4000});
    										}
    									}
    								});
    			    	  });
    				    }
    		  ,getTisData: function(){ //获取选中数据，2018.7.11 增加判断素材分辨率与终端分辨率是否相同功能 张一鸣
			      var checkStatus = table.checkStatus('flagTwo')
			      ,data = checkStatus.data;
			      var tids = [];
			      var flaglen = 0;
			      var flagresolution=0;
			      for(var i = 0; i < data.length; i++){
			    	  var mid = data[i].mid;
			    	  var mresolution=data[i].resolution;
			    	  var obj = document.getElementById("terminal" + mid);
			    	  if(obj != null){
			    		  var tid = obj.value;//获取到终端id
			    		  for(var j=0;j< terminalVal.length; j++)
			    			  {
			    			  	if(tid==terminalVal[j].terminalId)
			    			  		{
			    			  			var tledresolution=terminalVal[j].ledLength+'X'+terminalVal[j].ledWidth;
			    			  			if(tledresolution!=mresolution)
			    			  				{flagresolution=flagresolution+1;}
			    			  				
			    			  		}
			    			  }
			    		  
			    		  tids.push(mid + "-" + tid);
			    	  }else{
			    		  flaglen = flaglen + 1;
			    	  }
			      }
			      if(flaglen == data.length){
			    	  layer.msg('所选素材终端已确定!',{icon:6,time:1500});
			    	  return ;
			      }
			      if(tids.length == 0){
			    	  layer.msg('请选择要保存的素材!',{icon:6,time:1500});
			    	  return ;
			      }
			      
			      if(flagresolution!=0){
			    	  //批量保存
				      layer.confirm('素材分辨率与所选终端LED分辨率不一致，确定绑定吗', function(index){
					         //obj.del();
					         layer.close(index);
					         console.log(tids.length);
					         $.ajax({
									type: "POST",
									url: "<%=request.getContextPath()%>/material/tidMaterial.do",
									data: {"tid":tids},
									traditional: true,
									dataType : "json",
									success : function(msg){
										var value = msg.toString();
										if(value=="true"){
											terminalVal = [];
									    	getAllTerminal();
											init();
											layer.msg('保存成功!',{icon:6,time:4000});
										}
									}
								});
			    	  });
			    	  return;
			      }
			      
			      //批量保存
			      layer.confirm('真的要保存所选素材确定的终端么', function(index){
				         //obj.del();
				         layer.close(index);
				         console.log(tids.length);
				         $.ajax({
								type: "POST",
								url: "<%=request.getContextPath()%>/material/tidMaterial.do",
								data: {"tid":tids},
								traditional: true,
								dataType : "json",
								success : function(msg){
									var value = msg.toString();
									if(value=="true"){
										terminalVal = [];
								    	getAllTerminal();
										init();
										layer.msg('保存成功!',{icon:6,time:4000});
									}
								}
							});
		    	  });
			    }
    				   ,getUpdateData: function(){ //获取选中数据
    				      var checkStatus = table.checkStatus('flagTwo')
    				      ,data = checkStatus.data;
    				      if(data.length == 1){
    				    	  var mmid = data[0].mid;
    				    	  var mname = data[0].materialName;
    				    	  layer.open({
    				    			title:'素材修改列表',
    				    			type:2,
    				    			area:['50%','95%'],
    				    			content:'<%=request.getContextPath()%>/views/ajaxViews/material-update.jsp',
    				    			success: function(layero, index){
    				    				var body = layer.getChildFrame('body',index);//建立父子联系
    				    	            var iframeWin = window[layero.find('iframe')[0]['name']];
    				    	            // console.log(arr); //得到iframe页的body内容
    				    	            // console.log(body.find('input'));
    				    	            var inputList = body.find('input');
    				    	            $(inputList[0]).val(mmid);
    				    	            $(inputList[1]).val(mname);
    				    	            
    				    	            if(data[0].tis == "1") {  //邦定了终端就要初始化可修改的播放端
    				    	             iframeWin.setUpdateTerminal(terminalVal, data[0].terminal);
    				    	            }
    				    			}
    				    			//end: function(){
    				    				//window.location.reload();
    				    			//}
    				    		});
    				      }else if(data.length == 0){
    					      layer.msg('请选择要修改的数据!',{icon:6,time:1500});
    				      }else{
    				    	  layer.msg('只能选中一条数据修改!',{icon:6,time:1500});
    				      }
    				      //console.log(checkStatus.data.length) //获取选中行数量，可作为是否有选中行的条件
    				      //console.log(checkStatus.isAll ) //表格是否全选
    				      //layer.msg('选中了：'+ data.length + ' 个');
    				    }
    				  };
    				  
    				  $('.operatorTable').on('click', function(){
    					  var othis = $(this);
    					  var dothing = othis.attr("function");
    					  if(dothing == "getDeleteData"){
    						  //console.log(dothing);
    						  active.getDeleteData();
    					  }else if(dothing == "getUpdateData"){
    						  //console.log(dothing);
    						  active.getUpdateData();
    					  }else if(dothing == "getTisData"){
    						  active.getTisData();
    					  }
    				  });
    		  
    		  table.on('tool(tableEvent)', function(obj){
    			  var tmpdata = obj.data;
    			  var mid = tmpdata.mid;
    			  var md5 = tmpdata.md5;
    			  var filePath = tmpdata.filePath;
    			  var name = filePath.split("/");
    			  var realname = name[name.length - 1];
    			  document.getElementById("videoView").value = realname;
    			  if(obj.event === 'mediaView'){
    				  $.ajax({
    						type:"POST",
    					    url: '<%=request.getContextPath()%>/material/deposeMaterial.do',
    					    data: {"mid": mid},
    					    dataType : "json",
    					    success: function(msg){
    					    	var value = msg.toString();
    							if(value=="true"){
    								window.open('<%=request.getContextPath()%>/file/videoViewDepose.jsp',"_blank","toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes,left=300,top=20, width=800, height=620");
    							}else if(value == "false"){
    								window.open('<%=request.getContextPath()%>/file/videoView.jsp',"_blank","toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes,left=300,top=20, width=800, height=620");
    							}
    					    }
    					});
    			  }else if(obj.event == "md5"){
    				  layer.open({
    					  title: 'MD5'
    					  ,content: md5
    					});
    			  }
    		  });
    		});
      }
      
      function refresh(){
    	  terminalVal = [];
    	  getAllTerminal();
   	      init();
      }
      
   </script>
   
</head>
<body>
  <input type="hidden" id="videoView" value="">
  <div style="width: 100%; height:100%; float: left">
	<div class="layui-fluid">
		<div class="layui-row layui-col-space1">
			<div class="layui-col-md12">
				<div class="layui-form-query">
					<form class="layui-form" id="query_form">
						<div class="layui-form-item">
							<div class="layui-inline">
								<label class="layui-form-mid">素材名：</label>
								<div class="layui-input-inline"
									style="width: 100px; height: 35px;">
									<input type="tel" id="materialName" name="materialName" autocomplete="off"
										style="width: 120px; height: 35px;" placeholder="素材名"
										class="layui-input input-text" />
								</div>
							</div>
							
<!-- 							<div class="layui-inline">
								<label class="layui-form-mid">类型：</label>
								<div class="layui-input-inline"
									style="width: 90px; height: 35px;">
									<select id="fileType" name="fileType" style="width: 150px; height: 35px;">
										<option value="">请选择</option>
										<option value="vedio">视频</option>
										<option value="picture">图片</option>
										<option value="other">其他</option>
									</select>
								</div>
							</div> -->
							
							<div class="layui-inline">
								<label class="layui-form-mid">终端确定与否：</label>
								<div class="layui-input-inline"
									style="width: 90px; height: 35px;">
									<select id="tis" name="tis" style="width: 90px; height: 35px;">
										<option value="">--请选择--</option>
										<option value="0">否</option>
										<option value="1">是</option>
									</select>
								</div>
							</div>
							
							<div class="layui-inline">
								<label class="layui-form-mid">状态：</label>
								<div class="layui-input-inline"
									style="width: 90px; height: 35px;">
									<select id="statusId" name="statusId" style="width: 150px; height: 35px;">
										<option value="">--请选择--</option>
										<option value="1">未审核</option>
										<option value="3">通过</option>
										<option value="4">未通过</option>
									</select>
								</div>
							</div>
							
							<div class="layui-inline">
			                    <label class="layui-form-mid">上传日期范围：</label>
			                    <div class="layui-inline" style="">
				                    <input type="text" id="dateTime" name="dateTime" autocomplete="off" style="width: 170px; height: 36px;" class="layui-input fsDate" dateRange="1" placeholder=" - "/>
			                    </div>
		                    </div>
							
							<div class="layui-inline">
								<div class="layui-inline">
									<button class="layui-btn" type="button" function="query" onclick="init()">
										<i class="layui-icon">&#xe615;</i>查询
									</button>
								</div>
							</div>
						</div>
					</form>
				</div>
			</div>
			
		<div class="layui-btn-container">
	        	<button class="layui-btn operatorTable" function="getTisData" data-type="getTisData">
			      <i class="layui-icon">&#xe618;</i>绑定终端
			    </button>
	        	<button class="layui-btn operatorTable" function="getUpdateData" data-type="getUpdateData">
			      <i class="layui-icon">&#xe642;</i>修改
			    </button>
				<button class="layui-btn layui-btn-danger operatorTable" function="getDeleteData" data-type="getDeleteData">
				  <i class="layui-icon">&#xe640;</i>批量删除
				</button>
				<button class="layui-btn" onclick="refresh()">
				  <i class="layui-icon">&#x1002;</i>刷新
				</button>
		      </div>
			
		 <div class="layui-col-md12">
            <table class="layui-table" id="table1" lay-filter="tableEvent"></table>
			<!-- <a class="layui-btn layui-btn-primary layui-btn-xs" lay-event="top" topUrl="views/datagrid2/one.html" topMode="readonly" topWidth="800px" topHeight="600px" topTitle="查看demo" inputs="id:">查看</a> -->
			<script type="text/html" id="barDemo">
 				<a class="layui-btn layui-btn-sm" lay-event="mediaView" >预览</a>
			</script>
			<script type="text/html" id="barDemo1">
 				<a class="layui-btn layui-btn-sm layui-btn-danger" lay-event="md5" >MD5</a>
			</script>
	      </div>
			
		</div>
	</div>
  </div>
	<script type="text/javascript">
	layui.use('form', function(){
		  var form = layui.form;
   		  form.on('select(test)', function(data){
			 $("#" + data.elem.id).val(data.value);
		   });
	});
	</script>
</body>
</html>