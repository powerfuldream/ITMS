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
   <script type="text/javascript" defer="defer">
   layui.use(['layer','form', 'element','laydate'], function(){
		var layer = layui.layer
		,form = layui.form
		,element = layui.element;
		
		form.on('select(test)', function(data){
			  //console.log(data);
			doYesSearch();
		});
	});
   
   $(function(){
	   init();
   });
   
   function init(){
	   doYesSearch();
   }
   
   function doYesSearch(){
	   var pid = $("#broadId").val();
	   
        //方法级渲染
	   layui.use('table', function(){
    		  var table = layui.table;
    		  table.render({
    		    elem: '#table1'
    		    ,id: 'flagTwo'
    		    ,url:'<%=request.getContextPath()%>/material/searchItemByPid2.do'
    		    //,height: 500
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
    		    ,where: {"pid": pid}
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
   
   function artificialGenerated(){
  	 //手动生成播表
  	   document.location = "<%=request.getContextPath()%>/ptable/generatePtable.do"; 
  	   <%--   document.location = "<%=request.getContextPath()%>/ptable/generatePtableExcep.do"; --%>
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
								<label class="layui-form-mid">排播错误的播表名：</label>
								<div class="layui-input-inline"
									style="width: 250px; height: 35px;">
									<select name="broadId" id="broadId"  lay-filter="test">
                                    <c:forEach items="${ptableNameOne}" var="pt" varStatus="status">
		                               <c:if test="${status.count == 1}">
                                         <option selected="selected" value="${pt.pid}">${pt.ptableName}</option>
                                       </c:if>
                                       <c:if test="${status.count != 1}">
                                         <option value="${pt.pid}">${pt.ptableName}</option>
                                       </c:if>
	                                </c:forEach>
                                    </select>
								</div>
							</div>
							
							<div class="layui-inline">
								<div class="layui-inline">
									<button class="layui-btn layui-btn-danger operatorTable" type="button" function="getDeleteData">
										<i class="layui-icon">&#xe640;</i>删除
									</button>
								</div>
							</div>
							
							<div class="layui-inline">
								<div class="layui-inline">
									<button class="layui-btn" type="button" onclick="addNewPeriod()">
				                      <i class="layui-icon">&#xe654;</i>新增时段
				                    </button>
								</div>
							</div>
							
							
							<div class="layui-inline">
								<div class="layui-inline">
									<button class="layui-btn" type="button" onclick="artificialGenerated()" >
			                          <i class="layui-icon">&#xe63c;</i>生成播表
			                        </button>
								</div>
							</div>
							 
						</div>
					</form>
				</div>
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
</body>
</html>