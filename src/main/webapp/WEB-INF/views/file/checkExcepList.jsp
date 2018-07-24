<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <%@ include file="/layui/header.jsp"%>
   <title>素材敏感列表</title>
   <meta name="renderer" content="webkit">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
      	<script type="text/javascript">
	layui.use('form', function(){
		  var form = layui.form;
		  form.on('select(test)', function(data){
			  
			  init();
			});
		});
	</script>
   <script type="text/javascript" defer="defer">
   $(function(){
	   init();
	   
	   if('${showDeleteBtn}' == 'false') $("#showDeleteBtn").hide();
   });
   
      function init(){
    	  layui.use('layer', function(){
    		  var layer = layui.layer;
    		});
    	  
    	  layui.use('laydate', function(){
    		  var laydate = layui.laydate;
    		  
    		  //执行一个laydate实例
    		  laydate.render({
    		    elem: '#month' //指定元素
    		  });
    		});
		  
    	  var pid = $("#broadId").val();
    	  
    	  layui.use('table', function(){
    		  var table = layui.table;
    		  table.render({
    		    elem: '#table1'
    		    ,id: 'flagOne'
    		    ,url:'<%=request.getContextPath()%>/material/searchMaterialByPid2.do'
    		    ,height: 410
    		    //,cellMinWidth: 120
    		    ,limits:[10,25,50,75,100]
    		    ,cols: [[
    		      //{field:'id', width:'1%'}
    		       {checkbox: true, event: 'set1', fixed: true}
    		      ,{field:'materialName',width:320, event: 'set2', title: '素材名', fixed: true, sort: true}
      		     // ,{width:110, event: 'set3', title: '校验码', align:'center', toolbar: '#barDemo1'}
      		      ,{field:'fileType',width:120, event: 'set4', title: '文件类型', sort: true}
      		      ,{field:'resolution',width:110, event: 'set5', title: '分辨率'}
      		      ,{field:'duration',width:90, event: 'set6', title: '时长', sort: true}
      		      ,{field:'statusId',width:110, event: 'set7', title: '审核状态', sort: true
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
      		      ,{field:'uploadName',width:120, event: 'set8', title: '上传人', sort: true}
      		      ,{fixed: 'right', width:100, event: 'set9', title: '操作', align:'center', toolbar: '#barDemo'}
      		    ]]
    		    ,page: true
    		    ,where: {"pid": pid}
    		    ,done: function(res, curr, count){
    		    	  if(res.fail == 1){
    		    		  layer.msg(res.msg, {icon:6,time:2000});
    		    	  }else if(res.fail == 2){
    		    		  layer.msg(res.msg, {icon:5,time:2000});
    		    	  }
    		      }
    		  });
    		  
    		  table.on('checkbox(tableEvent)', function(obj){
  			    //console.log(obj);
  			    //var checkStatus = table.checkStatus('flagOne');
  			    //var da = checkStatus.data;
  		      });
    		  
    		  var active = {
    				  getDeleteData: function(){ //获取选中数据
    				      var checkStatus = table.checkStatus('flagOne')
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
    											init();
    											layer.msg('删除成功!',{icon:6,time:4000});
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
    			  var mid = tmpdata.mid;
    			  var md5 = tmpdata.md5;
    			  var filePath = tmpdata.filePath;
    			  var name = filePath.split("/");
    			  var realname = name[name.length - 1];
    			  document.getElementById("videoView").value = realname;
    			  if(obj.event === 'mediaView'){
    				  $.ajax({
    						type:"POST",
    					    url: '<%=request.getContextPath()%>/material/deposeMaterial.do.do',
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
      
      
   </script>
   
</head>
<body>
	<input type="hidden" id="videoView" value="">
	<div class="layui-fluid">
		<div class="layui-row layui-col-space1">
			<div class="layui-col-md12">
				<div class="layui-form-query">
					<form class="layui-form" id="query_form">
						<div class="layui-form-item">
							
							<div class="layui-inline">
								<label class="layui-form-mid">含敏感素材的播表名：</label>
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
								<div id="showDeleteBtn" class="layui-inline">
									<button class="layui-btn layui-btn-danger operatorTable" type="button" function="getDeleteData">
										<i class="layui-icon">&#xe640;</i>删除
									</button>
								</div>
							</div>
						</div>
					</form>
				</div>
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

	<script type="text/javascript">
	layui.use('form', function(){
		  var form = layui.form;
		});
	</script>
</body>
</html>