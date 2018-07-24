<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
   <meta charset="UTF-8">
   <%@ include file="/layui/header.jsp"%>
   <title>排播列表</title>
   <meta name="renderer" content="webkit">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
   <%-- <script src="<%=request.getContextPath()%>/layui/jquery-1.8.2.min.js"></script> --%>
   <script type="text/javascript" defer="defer">
   layui.use(['layer','form', 'element','laydate'], function(){
		var layer = layui.layer
		,form = layui.form
		,element = layui.element
	    ,laydate = layui.laydate;
		
		laydate.render({
		    elem: '#broadTime' //指定元素
		    ,range: true
		  });
	    //执行一个laydate实例
	    laydate.render({
		    elem: '#dateTime' //指定元素
		    ,range: true
		  });
			
			//form.render('select', 'infoValue');
			form.on('radio(infoValue)', function(data){
				if(data.value == 0){
					//document.getElementById("tName").style.display="none";//隐藏
					document.getElementById("broadDate").style.display="none";//隐藏
					document.getElementById("uploadDate").style.display="";//显示
					$("#delBtn").hide();
					doNoSearch();
				}else if(data.value == 1){
					document.getElementById("broadDate").style.display="";//显示
					document.getElementById("uploadDate").style.display="none";//隐藏
					//document.getElementById("tName").style.display="";
					$("#delBtn").show();
					doYesSearch();
				}
			});
	});
   
   var node = [];
   var searchTerminal = "";
   $(function(){	   
	   treeSearch();
	   init();
   });   
   
   function init(){
	  
	   var radioId = document.getElementsByName("info");
		var infoId;
		for(var i=0;i<radioId.length;i++){
			if(radioId[i].checked==true){
				infoId=radioId[i].value;
			}
		}
		if(infoId == 0){
			doNoSearch();
		}else if(infoId == 1){
		    
			doYesSearch();
			document.getElementById("uploadDate").style.display="none";//隐藏
		}
   }
   
   function doNoSearch(){
	   //var materialName = $("#materialName").val();  //名称
	   //var terminalId = $("#terminal").val();  //终端
	   //var info = 0;   //是否排播
	   //var dateTime = $("#dateTime").val();   //时间
	   
	   var param = "";
		  
	       //名称
	   var materialName = $("#materialName").val();
	   if(materialName != ""){
		   param = param + "materialName" + ",like,%" + materialName + "%,";
	   }
	   
	   
	   //类型
	   //var fileType = $("#fileType").val();
	   //if(fileType != ""){
		  // param = param + "fileType" + ",=," + fileType + ",";
	   //}
	   param = param + "fileType" + ",=,vedio,";
	   
	   param = param + "info" + ",=," + 0 + ",";
	   
	   //状态
	   var statusId = $("#statusId").val();
	   if(statusId != ""){
		   param = param + "statusId" + ",=," + 3 + ",";
	   }
	   
	   //时间
	   var dateTime = $("#dateTime").val();
	   
	   //方法级渲染
	   layui.use('table', function(){
    		  var table = layui.table;
    		  table.render({
    		    elem: '#table1'
    		    ,id: 'flagTwo'
    		    ,url:'<%=request.getContextPath()%>/material/wrapSearchFile.do'
    		    ,height: 500
    		    //,cellMinWidth: 120
    		    ,limits:[10,25,50,75,100]
    		    ,cols: [[
    		      //{field:'id', width:'1%'}
    		      {checkbox: true, fixed: true}
    		      ,{field:'materialName',width:280, event: 'set2', title: '素材名', fixed: true, sort: true}
    		      ,{field:'terminalName',width:120, event: 'set3', title: '终端名', sort: true
    		    	  ,templet: function(d){
    		    		  var terminal = d.terminal;
    		    		  return '<span style="color: #1E9FFF;">' + terminal.terminalName + '</span>';
    		    	  }
    		      }
    		      ,{field:'resolution',width:100, event: 'set6', title: '分辨率'}
    		      ,{field:'size',width:130, event: 'set6', title: '素材大小'}
    		      ,{field:'duration',width:100, event: 'set7', title: '时长(秒)', sort: true}
    		      ,{field:'usedNum',width:100, event: 'set8', title: '使用次数', sort: true}
    		      ,{field:'statusId',width:100, event: 'set8', title: '审核状态', sort: true
    		    	  ,templet: function(d){
    		    		  var state = d.statusId;
    		    		  if(state == 1){
    		    			  return "未审核";
    		    		  }else if(state == 2){
    		    			  return "已初审";
    		    		  }else if(state == 3){
    		    			  return "已通过";
    		    		  }else if(state == 4){
    		    			  return "未通过";
    		    		  }
    		    	  }
    		      }
    		      ,{field:'uploadTime',width:160, event: 'set9', title: '上传时间', sort: true
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
    		      ,{field:'uploadName',width:90, event: 'set10', title: '上传人', sort: true}
    		      ,{fixed: 'right', width:180, event: 'set13', title: '操作', align:'center', toolbar: '#barDemoNo'}
    		    ]]
    		    ,page: true
    		    ,where: {"terminalIdStr": searchTerminal, "param": param, "dateTime":dateTime}
    		    ,done: function(res, curr, count){
    		    	  //changeBg();
    		      }
    		  });
    		  table.on('tool(tableEvent)', function(obj){
    			  var tmpdata = obj.data;
    			  var mmid = tmpdata.mid;
    			  var md5 = tmpdata.md5;
    			  var materialName = tmpdata.materialName;
    			  var filePath = tmpdata.filePath;
    			  var name = filePath.split("/");
    			  var realname = name[name.length - 1];
    			  document.getElementById("videoView").value = realname;
    			  
    			   if(obj.event === 'mediaView'){
    				  $.ajax({
  						type:"POST",
  					    url: '<%=request.getContextPath()%>/material/deposeMaterial.do',
  					    data: {"mid": mmid},
  					    dataType : "json",
  					    success: function(msg){
  				
  							window.open('<%=request.getContextPath()%>/file/videoView.jsp',"_blank","toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes,left=300,top=20, width=800, height=620");
  							
  					    }
  					});
    				  <%-- window.open('<%=request.getContextPath()%>/file/videoView.jsp',"_blank","toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes,left=300,top=20, width=800, height=620"); --%>
    			  } else if(obj.event === 'md5'){
    				  layer.open({
    					  title: 'MD5'
    					  ,content: md5
    					});
    			  }else if(obj.event === 'broadMedia'){
    				  layer.open({
			    			title:'排播素材',
			    			type:2,
			    			area:['60%','85%'],
			    			content:'<%=request.getContextPath()%>/views/ajaxViews/material-add.jsp',
			    			success: function(layero, index){
			    				var body = layer.getChildFrame('body',index);//建立父子联系
			    	            var iframeWin = window[layero.find('iframe')[0]['name']];
			    	            // console.log(arr); //得到iframe页的body内容
			    	            // console.log(body.find('input'));
			    	            var inputList = body.find('input');
			    	            //var labelList = body.find('label');
			    	            $(inputList[0]).val(mmid);
			    	            $(inputList[1]).val(materialName);
			    	            $(inputList[6]).val(tmpdata.terminal.terminalId);
			    			}
    				  });
    			  }
    		  });
	   });
   }
   
   
   function doYesSearch(){
     
	   var param = "";
		  
	   //名称
	   var materialName = $("#materialName").val();
	   if(materialName != ""){
		   param = param + "materialName" + ",like,%" + materialName + "%,";
	   }

	   
	   
	   var dateTime = $("#broadTime").val();   //时间

	   //方法级渲染
	   layui.use('table', function(){
    		  var table = layui.table;
    		  table.render({
    		    elem: '#table1'
    		    ,id: 'flagTwo'
    		    ,url:'<%=request.getContextPath()%>/material/wrapSearchBroadItem.do'
    		    ,height: 500
    		    //,cellMinWidth: 120
    		    ,limits:[10,25,50,75,100]
    		    ,cols: [[
    		      //{field:'id', width:'1%'}
    		      {checkbox: true, event: 'set1', fixed: true}
    		      ,{field:'itemName',width:280, event: 'set2', title: '节目名称', fixed: true, sort: true}
    		      ,{field:'terminalName',width:120, event: 'set3', title: '终端名', sort: true
    		    	  ,templet: function(d){
    		    		  var material = d.material;
    		    		  var name = material.terminal;
    		    		  return '<span style="color: #1E9FFF;">' + name.terminalName + '</span>';
    		      }
    		      }
    		      ,{field:'playDate',width:200, event: 'set4', title: '播放日期', sort: true}
    		      ,{field:'periodName',width:200, event: 'set5', title: '播放时段', sort: true}
    		      ,{field:'frequency',width:80, event: 'set6', title: '频次', sort: true}
    		      ,{field:'resolution',width:100, event: 'set7', title: '分辨率'
    		    	  ,templet: function(d){
    		    		  var material = d.material;
    		    		  return material.resolution;
    		      }
    		      }
    		      ,{field:'size',width:130, event: 'set8', title: '素材大小'
    		    	  ,templet: function(d){
    		    		  var material = d.material;
    		    		  return material.size;
    		      }  
    		      }
    		      ,{field:'duration',width:100, event: 'set9', title: '时长(秒)', sort: true
    		    	  ,templet: function(d){
    		    		  var material = d.material;
    		    		  return material.duration;
    		      }  
    		      }
    		      ,{field:'statusId',width:100, event: 'set10', title: '审核状态', sort: true
    		    	  ,templet: function(d){
    		    		  var states = d.material;
    		    		  var state = states.statusId;
    		    		  if(state == 1){
    		    			  return "未审核";
    		    		  }else if(state == 2){
    		    			  return "已初审";
    		    		  }else if(state == 3){
    		    			  return "已通过";
    		    		  }else if(state == 4){
    		    			  return "未通过";
    		    		  }
    		    	  }
    		      }
    		      ,{field:'info',width:100, event: 'set11', title: '排播状态', sort: true
    		    	  ,templet: function(d){
    		    		  var states = d.material;
    		    		  var state = states.info;
    		    		  if(state == 0){
    		    			  return '<span style="color: #FF6347;">' + '未排播' + '</span>';
    		    		  }else if(state == 1){
    		    			  return '<span style="color: #90EE90;">' + '已排播' + '</span>';
    		    		  }
    		    	  }
    		      }
    		      ,{field:'createTime',width:160, event: 'set12', title: '创建时间', sort: true
    		    	  ,templet: function(d){
    		    		  var date = new Date(d.createTime);
    		    		  var Y = date.getFullYear() + '-';
    		    		  var M = (date.getMonth()+1 < 10 ? '0'+(date.getMonth()+1) : date.getMonth()+1) + '-';
    		    		  var D = (date.getDate() < 10 ? '0' + (date.getDate()) : date.getDate()) + ' ';
    		    		  var h = (date.getHours() < 10 ? '0' + date.getHours() : date.getHours()) + ':';
    		    		  var m = (date.getMinutes() <10 ? '0' + date.getMinutes() : date.getMinutes()) + ':';
    		    		  var s = (date.getSeconds() <10 ? '0' + date.getSeconds() : date.getSeconds());
    		    		  return Y+M+D+h+m+s;
    		    	  }
    		      }
    		      ,{field:'createName',width:90, event: 'set13', title: '创建人', sort: true}
    		      ,{fixed: 'right', width:180, event: 'set14', title: '操作', align:'center', toolbar: '#barDemoYes'}
    		    ]]
    		    ,page: true
    		    ,where: {"terminalIdStr": searchTerminal, "params": param, "dateTime": dateTime}
    		    ,done: function(res, curr, count){
    		    	  //changeBg();
    		      }
    		  });
    		  
    		  table.on('checkbox(tableEvent)', function(obj){
  			      //console.log(obj);
  		       });
    		  
    		  var  active = {
    				  getDeleteData: function(){ //获取选中数据
    				      var checkStatus = table.checkStatus('flagTwo')
    				      ,data = checkStatus.data;
    				      var mids = [];
    				      for(var i = 0; i < data.length; i++){
    					      mids.push(data[i].itemId);
    				      }
    				      if(mids.length == 0){
    				    	  layer.msg('请选择要删除的数据!',{icon:6,time:1500});
    				    	  return ;
    				      }
    				      //批量删除
    				      layer.confirm('确定删除选中的节目吗', function(index){
    					         //obj.del();
    					         layer.close(index);
    					       
    					         $.ajax({
    									type: "POST",
    									url: "<%=request.getContextPath()%>/material/delItem.do",
    									data: {"itemIds":mids},
    									traditional: true,
    									dataType : "json",
    									success : function(data){
    										if(data.success) {
    										   refresh();
										       layer.msg('删除成功!',{icon:6,time:2000});
										     } else {
										       layer.msg(data.msg, {icon:5,time:2000});
										     }
    									}
    								});
    			    	  });
    				    }
    		  };
    		  
    		  $('.operatorTable').on('click', function(){
				  var othis = $(this);
				  var dothing = othis.attr("function");
				  if(dothing == "getDeleteData"){
					  //console.log(dothing);
					  active.getDeleteData();
				  }
			  });
    		  
    		  
    		  table.on('tool(tableEvent)', function(obj){
    			  var tmpdata = obj.data;
    			  var itemId = tmpdata.itemId;
    			  var material = tmpdata.material;
    			  var mmid = material.mid;
    			  var md5 = material.md5;
    			  var materialName = material.materialName;
    			  var date = tmpdata.playDate;
    			  var periodId = tmpdata.periodId;
    			  var pNameOld = tmpdata.periodName;
    			  var pNameNew = pNameOld.split(" ");
    			  var pName = pNameNew[0];
    			  var frequency = tmpdata.frequency;
    			  var filePath = material.filePath;
    			  var name = filePath.split("/");
    			  var realname = name[name.length - 1];
    			  //console.log(date);console.log(pName);console.log(frequency);console.log(realname);
    			  document.getElementById("videoView").value = realname;
    			  if(obj.event === 'mediaView'){
    				  $.ajax({
  						type:"POST",
  					    url: '<%=request.getContextPath()%>/material/deposeMaterial.do',
  					    data: {"mid": mmid},
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
    				  <%-- window.open('<%=request.getContextPath()%>/file/videoView.jsp',"_blank","toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes,left=300,top=20, width=800, height=620"); --%>
    			  }else if(obj.event === 'md5'){
    				  layer.open({
    					  title: 'MD5'
    					  ,content: md5
    					});
    			  }else if(obj.event === 'mediaUpdate'){
    				  layer.open({
			    			title:'重新排播素材',
			    			type:2,
			    			area:['60%','85%'],
			    			content:'<%=request.getContextPath()%>/views/ajaxViews/broad-update.jsp',
			    			success: function(layero, index){
			    				var body = layer.getChildFrame('body',index);//建立父子联系
			    	            var iframeWin = window[layero.find('iframe')[0]['name']];
			    	            // console.log(arr); //得到iframe页的body内容
			    	            // console.log(body.find('input'));
			    	            var inputList = body.find('input');
			    	            //var labelList = body.find('label');
			    	            $(inputList[0]).val(itemId);
			    	            $(inputList[1]).val(materialName);
			    	            $(inputList[2]).val(date);
			    	            $(inputList[3]).val(periodId);
			    	            $(inputList[4]).val(pName);
			    	            $(inputList[5]).val(frequency);
			    	            $(inputList[6]).val(tmpdata.terminalId);
			    			}
    				  });
    			  }
    		  });
	   });
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
								id:'' + msg[i].children[j].id,
							});
						}
					}
					node[i].children = child;
				}
				
				layui.use(['tree', 'layer'], function(){
					  var layer = layui.layer
					  ,$ = layui.jquery; 
					  
					  layui.tree({
					    elem: '#demo1' //指定元素
					    ,target: '_blank' //是否新选项卡打开（比如节点返回href才有效）
					    ,click: function(item){ //点击节点回调
					            searchTerminal = "";
							    if(item.id.charAt(0) == 'p') {
							       for(var i = 0; i < item.children.length; i++) {
							          searchTerminal += item.children[i].id.slice(1) + ",";
							       }
							    } else {
							          searchTerminal += item.id.slice(1) + ",";
							    }
								    
					     
					     
					         //分两种情况查询
					      	    var radioId = document.getElementsByName("info");
								var infoId;
								for(var i=0;i<radioId.length;i++){
									if(radioId[i].checked==true){
										infoId=radioId[i].value;
									}
								}
								if(infoId == 0){
									doNoSearch();
								}else if(infoId == 1){
								    doYesSearch();
								}
					            searchTerminal = "";
					      
					      
					    }
					    ,nodes: node
					  });
				});
			}
		});
	}
   
   
   function refresh(){
	   init();
   }
   
   function addNewPeriod(){
	   layer.open({
			title:'添加时段',
			type:2,
			area:['60%','85%'],
			content:'<%=request.getContextPath()%>/views/ajaxViews/period-add.jsp',
			success: function(){
				
			}
		});
   }
   
   function materialBroad(){
	   layer.open({
			title:'排播素材',
			type:2,
			area:['70%','95%'],
			content:'<%=request.getContextPath()%>/views/ajaxViews/material-broad.jsp',
			success: function(layero, index){
				var body = layer.getChildFrame('body',index);//建立父子联系
	            var iframeWin = window[layero.find('iframe')[0]['name']];
	            // console.log(arr); //得到iframe页的body内容
	            // console.log(body.find('input'));
	            var inputList = body.find('input');
	            //var labelList = body.find('label');
	            //$(inputList[0]).val(mmid);
	            //$(inputList[1]).val(materialName);
			}
	  });
   }
   
   function artificialGenerated(){
  	 //手动生成播表
  	 document.location = "<%=request.getContextPath()%>/ptable/generatePtable.do";
      }
   
   </script>
   </head>
<body>
  <input type="hidden" id="videoView" value="">
  <div style="width: 14%; height:100%; float: left">
	    <br><font  size="4"  color="red">双击打开关闭</font><br>
	    <ul id="demo1"></ul>
  </div> 
 
  <div style="width: 86%; height:100%; float: left">
  	<div class="layui-fluid">
		<div class="layui-row layui-col-space1">
			<div class="layui-col-md12">
				<div class="layui-form-query">
					<form class="layui-form" id="query_form">
						<div class="layui-form-item">
							<div class="layui-inline">
								<label class="layui-form-mid">素材名：</label>
								<div class="layui-input-inline"
									style="width: 110px; height: 35px;">
									<input type="tel" id="materialName" name="materialName" autocomplete="off"
										style="width: 110px; height: 35px;" placeholder="素材名"
										class="layui-input input-text" />
								</div>
							</div>
							
							 <!--  
							<div class="layui-inline" id="tName">
								<label class="layui-form-mid">终端：</label>
								<div class="layui-input-inline"
									style="width: 140px; height: 35px;">
									<select name="terminal" id="terminal" lay-verify="required" lay-search="" style="width: 140px; height: 35px;">
										<option value="">直接选择或搜索</option>
										<c:forEach items="${terminals}" var = "terminal" varStatus = "status">
                                        <option value="${terminal.terminalId}">${terminal.terminalName}</option>
                                        </c:forEach>
									</select>
								</div>
							</div>
							-->
							
							<div class="layui-inline" id="uploadDate">
			                    <label class="layui-form-mid">上传日期范围：</label>
			                    <div class="layui-inline" style="">
				                    <input type="text" id="dateTime" name="dateTime" autocomplete="off" style="width: 170px; height: 36px;" class="layui-input fsDate" dateRange="1" placeholder=" - "/>
			                    </div>
		                    </div>
		                     
		                    <div class="layui-inline" id="broadDate">
			                    <label class="layui-form-mid">排播日期范围：</label>
			                    <div class="layui-inline" style="">
				                    <input type="text" id="broadTime" name="broadTime" autocomplete="off" style="width: 170px; height: 36px;" class="layui-input fsDate" dateRange="1" placeholder=" - "/>
			                    </div>
		                    </div>
							
							<div class="layui-inline">
								<label class="layui-form-label">是否排播：</label>
								    <div class="layui-input-block">
                                       <input type="radio" name="info" value="1" title="是" lay-filter="infoValue" checked>
                                       <input type="radio" name="info" value="0" title="否" lay-filter="infoValue">
                                    </div>
							</div>

							<div class="layui-inline">
								<div class="layui-inline">
									<button class="layui-btn layui-btn-jan" type="button"  onclick="init()">
										<i class="layui-icon">&#xe615;</i>查询
									</button>
								</div>
							</div>
						</div>
					</form>
				</div>
			</div>
			
			<div class="layui-col-md12">
  	 	<div class="layui-row grid-demo">
	      <div class="layui-btn-container">
	        	<button class="layui-btn layui-btn-sm" onclick="materialBroad()" >
			      <i class="layui-icon">&#xe654;</i>排播
			    </button>
	        	<button class="layui-btn layui-btn-sm" onclick="artificialGenerated()" >
			      <i class="layui-icon">&#xe63c;</i>生成播表
			    </button>
			    <button class="layui-btn layui-btn-sm" onclick="addNewPeriod()">
				  <i class="layui-icon">&#xe654;</i>新增时段
				</button>
				<button id="delBtn" class="layui-btn layui-btn-sm layui-btn-danger operatorTable" function="getDeleteData" data-type="getDeleteData">
				  <i class="layui-icon">&#xe640;</i>批量删除
				</button>
				<button class="layui-btn layui-btn-sm" onclick="refresh()">
				  <i class="layui-icon">&#x1002;</i>刷新
				</button>
		      </div>
			
		 <div class="layui-col-md12">
            <table class="layui-table" id="table1" lay-filter="tableEvent"></table>
			<script type="text/html" id="barDemoNo">
                <a class="layui-btn layui-btn-sm" lay-event="broadMedia" >排播</a>
 				<a class="layui-btn layui-btn-sm" lay-event="mediaView" >预览</a>
            </script>
			<script type="text/html" id="barDemoYes">

                <a class="layui-btn layui-btn-sm" lay-event="mediaUpdate" >修改</a>
 				<a class="layui-btn layui-btn-sm" lay-event="mediaView" >预览</a>
			
            </script>
			<script type="text/html" id="barDemo1">
              <a class="layui-btn layui-btn-sm layui-btn-danger" lay-event="md5" >MD5</a>
            </script>
	      </div>
			
		</div>
	</div>
	</div>
	</div>
	</div>
</body>
</html>