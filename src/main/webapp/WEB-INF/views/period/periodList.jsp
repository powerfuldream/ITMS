<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <%@ include file="/layui/header.jsp"%>
   <title>时段列表</title>
   <meta name="renderer" content="webkit">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
   <%-- <script src="<%=request.getContextPath()%>/layui/jquery-1.8.2.min.js"></script> --%>
   <script type="text/javascript" defer="defer">
   
	
   
   $(function(){
	   init();
   });
   
      function init(){
    	  layui.use('laydate', function(){
    		  var laydate = layui.laydate;
    		  
    		  //执行一个laydate实例
    		  laydate.render({
    		    elem: '#month' //指定元素
    		  });
    		});
    	  
    	  layui.use('table', function(){
    		  var table = layui.table;
    		  table.render({
    		    elem: '#table1'
    		    ,id: 'flagThree'
    		    ,url:'<%=request.getContextPath()%>/period/searchPeriod.do'
    		    ,height: 410
    		    //,cellMinWidth: 120
    		    ,limits:[10,25,50,75,100]
    		    ,cols: [[
    		      {checkbox: true, event: 'set1', fixed: true}
    		      ,{field:'periodId', width:100, event: 'set2', title: '时段ID', fixed: true}
    		      ,{field:'periodName',width:275, event: 'set3', title: '时段名', fixed: true, sort: true}
      		      ,{field:'startInterval',width:200, event: 'set4', title: '开始时间', sort: true}
      		      ,{field:'endInterval',width:200, event: 'set5', title: '结束时间', sort: true}
      		      ,{field:'terminalName',width:200, event: 'set6', title: '所属终端', sort: true}
      		      ,{field:'mark',width:272, event: 'set7', title: '备注'}
      		     
      		    ]]
    		    ,page: true
    		    ,done: function(res, curr, count){
    		    	  //document.getElementById("table1").remove();
    		      }
    		  });
    		  
    		  table.on('checkbox(tableEvent)', function(obj){
  			      //console.log(obj);
  		       });
    		  
    		  var  active = {
    				  getDeleteData: function(){ //获取选中数据
    				      var checkStatus = table.checkStatus('flagThree')
    				      ,data = checkStatus.data;
    				      var pids = [];
    				      for(var i = 0; i < data.length; i++){
    					      pids.push(data[i].periodId);
    				      }
    				      if(pids.length == 0){
    				    	  layer.msg('请选择要删除的数据!',{icon:6,time:1500});
    				    	  return ;
    				      }
    				      //批量删除
    				      layer.confirm('真的删除所选时段么', function(index){
    					         //obj.del();
    					         layer.close(index);
    					         //console.log(pids.length);
    					         $.ajax({
    									type: "POST",
    									url: "<%=request.getContextPath()%>/period/delPeriod.do",
    									data: {"periodId":pids},
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
    				   ,getUpdateData: function(){ //获取选中数据
    				      var checkStatus = table.checkStatus('flagThree')
    				      ,data = checkStatus.data;
    				      if(data.length == 1){
    				    	  var pid = data[0].periodId;
    				    	  var pname = data[0].periodName;
    				    	  var stime = data[0].startInterval;
    				    	  var etime = data[0].endInterval;
    				    	  var mark = data[0].mark;
    				    	  var ptime = stime + ' - ' + etime;
    				    	  layer.open({
    				    			title:'修改时段',
    				    			type:2,
    				    			area:['60%','85%'],
    				    			content:'<%=request.getContextPath()%>/views/ajaxViews/period-update.jsp',
    				    			success: function(layero, index){
    				    				var body = layer.getChildFrame('body',index);//建立父子联系
    				    	            var iframeWin = window[layero.find('iframe')[0]['name']];
    				    	            // console.log(arr); //得到iframe页的body内容
    				    	            // console.log(body.find('input'));
    				    	            var inputList = body.find('input');
    				    	            $(inputList[0]).val(pid);
    				    	            $(inputList[1]).val(pname);
    				    	            $(inputList[2]).val(ptime);
    				    	            $(inputList[3]).val(mark);
    				    	            
    				    	         
    				    			},
    				    		});
    				      }else if(data.length == 0){
    					      layer.msg('请选择要修改的数据!',{icon:6,time:1500});
    				      }else{
    				    	  layer.msg('只能选中一条数据修改!',{icon:6,time:1500});
    				      }
    				    }
    				   ,getAddData: function(){
    					   layer.open({
				    			title:'添加时段',
				    			type:2,
				    			area:['60%','85%'],
				    			content:'<%=request.getContextPath()%>/views/ajaxViews/period-add.jsp',
				    			success: function(){
				    				
				    			}
				    		});
    				   }
    				  };
    				  
    				  $('.operatorTable').on('click', function(){
    					  var othis = $(this);
    					  var dothing = othis.attr("function");
    					  if(dothing == "getDeleteData"){
    						  active.getDeleteData();
    					  }else if(dothing == "getUpdateData"){
    						  active.getUpdateData();
    					  }else if(dothing == "getAddData"){
    						  active.getAddData();
    					  }
    				  });
    		});
      }
      
      function refresh(){
    	  init();
      }
   </script>
   
</head>
<body>
	<input type="hidden" id="videoView" value="">
	<div class="layui-fluid">
		<div class="layui-row layui-col-space1">
			<div class="layui-col-md12">
				<fieldset id="menu_func_div" class="layui-elem-field">
					<legend>时段列表</legend>
					<div class="layui-field-box">
						<div class="layui-col-md12 layui-col-space1">
							<div id="table_buttion_div">
<!-- 								<form id="query_form" style="display: none;">
									<input type="text" id="menuId" name="menuId" value="0" />
								</form> -->
								<button class="layui-btn operatorTable" function="getAddData">
									<i class="layui-icon">&#xe654;</i>新增
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
						</div>
						<div class="layui-col-md12 layui-col-space1">
							<table class="layui-table" id="table1" lay-filter="tableEvent"></table>
						</div>
					</div>
				</fieldset>
			</div>

		</div>
	</div>

	<script type="text/javascript">
		layui.use('form', function() {
			var form = layui.form;
		});
	</script>
</body>
</html>