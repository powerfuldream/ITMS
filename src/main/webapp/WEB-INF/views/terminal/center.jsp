<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <%@ include file="/layui/header.jsp"%>
   <title>播放端管理</title>
   <meta name="renderer" content="webkit">
   <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
   <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
   <script type="text/javascript" defer="defer">
   
     $(function(){
       initSearchAreaTree();
       init();
	   initAreaTree();
     });
  
      var terminalIframeWin;
      function initAreaTree() {
            //获取行政区数据  
		    $.ajax({  
		        url: '<%=request.getContextPath()%>/area/buildTree.do',  
		        dataType: 'json'  
		    }).done(function(data){  
		        if(!data) {  
		            return;  
		        }  
	
		        layui.use(['tree', 'layer'], function(){
	 				var layer = layui.layer
	 				,$ = layui.jquery; 
	 					  
	 				layui.tree({
	 					    elem: '#demo1' //指定元素
	 					    ,target: '_blank' //是否新选项卡打开（比如节点返回href才有效）
	 					    ,click: function(item) { //点击节点回调
	 					      
				                terminalIframeWin.clickArea(item);
				                layer.closeAll('page'); 
	 					    }
	 					    ,nodes: data.children
	 				     }); 
    		     });
		        
		        
            });
      
      }
      

	  function openAreaTree() {
	     layui.use(['layer'], function(){
	    		 var layer = layui.layer;
			      layer.open({
			        type: 1,
			        title:"请选择播放端放置的地区",
			        content: $('#TreeDivId') //这里content是一个DOM，注意：最好该元素要存放在body最外层，否则可能被其它的相对元素所影响
			     });
		});
	  }
   
   
     function initSearchAreaTree() {
           $.ajax({  
		        url: '<%=request.getContextPath()%>/area/buildTreeByTerminalTable.do',  
		        dataType: 'json'  
		    }).done(function(data){  
		        if(!data){  
		            return;  
		        }  
		        		       
		        		       
		        data.spread = true;
		        for(var i = 0; i < data.children.length; i++)
		          data.children[i].spread = true;
	            var node = [];
	            node.push(data);
		        
		        layui.use(['tree', 'layer'], function(){
	 				var layer = layui.layer
	 				,$ = layui.jquery; 
	 					  
	 				layui.tree({
	 					    elem: '#demo2' //指定元素
	 					    ,target: '_blank' //是否新选项卡打开（比如节点返回href才有效）
	 					    ,click: function(item) { //点击节点回调
	 					        if(item.id == "86") $("#searchAreaName").val("中国");
	 					        else  $("#searchAreaName").val(item.nodeData.fullName);
				                refresh();
	 					    }
	 					    ,nodes: node
	 				     }); 
    		     });
		        
		    });
       
     }
  
   
      function init(){
    	  
    	  var params = "";
    	  
    	  var value;
    	  
    	   value = $("#searchSerialNumber").val();
		   if(value != "") {
			   params = params + "serialNumber" + ",like,%" + value + "%,";
		   }
		   
		   value = $("#searchTerminalName").val();
		   if(value != "") {
			   params = params + "terminalName" + ",like,%" + value + "%,";
		   }
		   
		   
		   value = $("#searchAreaName").val();
		   if(value != "中国") {
			   params = params + "areaName" + ",like,%" + value + "%,";
		   }
    
    	  /*
    	    value = $("#searchStateSelect").val();
		   if(value != "") {
			   params = params + "state" + ",like,%" + value + "%,";
		   }
    	  	  */
    	  
    	  layui.use('table', function(){
    		  var table = layui.table;
    		  table.render({
    		    elem: '#table1'
    		    ,id: 'flagOne'
    		    ,url:'<%=request.getContextPath()%>/terminal/searchTerminal2.do'
    		    ,height: 365
    		    //,cellMinWidth: 120
    		    ,limits:[10,25,50,75,100]
    		    ,cols: [[
    		      //{field:'id', width:'1%'}
    		      {checkbox: true, event: 'set1', fixed: true}    		      
                 ,{field:'terminalName',width:180, event: 'set2', title: '播放端名称', fixed: true, sort: true}
                 ,{field:'serialNumber',width:150, event: 'set3', title: '序列号码', sort: true}

                 
      		     ,{field:'ip',width:180, event: 'set5', title: 'IP地址', sort: true}
      		     ,{field:'macAddr',width:180, event: 'set6', title: '网卡地址', sort: true}
      		     ,{field:'resolutionLength',width:180, event: 'set7', title: '电脑分辨率-长', sort: true}
      		     ,{field:'resolutionWidth',width:180, event: 'set8', title: '电脑分辨率-宽', sort: true}
      		     
      		     
      		     
      		     ,{field:'ledLength',width:100, event: 'set9', title: 'LED-长', sort: true}
      		     ,{field:'ledWidth',width:100, event: 'set10', title: 'LED-宽', sort: true}
      		     
      		     
      		     ,{field:'startSpotTop',width:150, event: 'set11', title: 'LED起点-Top', sort: true}
      		     ,{field:'startSpotLeft',width:150, event: 'set12', title: 'LED起点-Left', sort: true}
      		     
      		     
      		     ,{field:'runStartTime',width:150, event: 'set13', title: '运行开始时间', sort: true}
      		     ,{field:'runEndTime',width:150, event: 'set14', title: '运行结束时间', sort: true}
      		     
      		     ,{field:'areaCode',width:100, event: 'set15', title: '地区编号', sort: true}
      		     ,{field:'areaName',width:180, event: 'set16', title: '地区全称', sort: true}
      		     
      		     
      		     ,{field:'detailAddress',width:180, event: 'set17', title: '安装地址', sort: true}
      		     ,{field:'terminalDescribe',width:180, event: 'set4', title: '描述', sort: true}
      		     ,{field:'state',width:100, event: 'set18', title: '状态', sort: true}
      		     
      		    ]]
    		    ,page: true
    		    ,where: {"param": params}
    		    ,done: function(res, curr, count){
    		    	  //document.getElementById("table1").remove();
    		      }
    		  });
    		  
    		  var active = {
    				  getDeleteData: function(){ //获取选中数据
    				      var checkStatus = table.checkStatus('flagOne')
    				      ,data = checkStatus.data;
    				      var pids = [];
    				      for(var i = 0; i < data.length; i++){
    					      pids.push(data[i].terminalId);
    				      }
    				      if(pids.length == 0){
    				    	  layer.msg('请选择要删除的数据!',{icon:6,time:1500});
    				    	  return ;
    				      }
    				      //批量删除
    				      layer.confirm('确定删除所选播放端吗', function(index){
    					         //obj.del();
    					         layer.close(index);
    					         //console.log(pids.length);
    					         $.ajax({
    									type: "POST",
    									url: '<%=request.getContextPath()%>/terminal/delTerminal2.do',
			                            data:{"terminalIds": pids}, 
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
    				   ,getUpdateData: function(){ //获取选中数据
    				      var checkStatus = table.checkStatus('flagOne')
    				      ,data = checkStatus.data;
    				      if(data.length == 1){

    				    	  layer.open({
    				    			title:'修改播放端',
    				    			type:2,
    				    			area:['98%','98%'],
    				    			content:'<%=request.getContextPath()%>/views/ajaxViews/terminal-update.jsp',
    				    			success: function(layero, index){
    				    			 //   var iframeWin = window[layero.find('iframe')[0]['name']];//得到iframe页的窗口对象，执行iframe页的方法：
                                     //   iframeWin.initAreaTree(getAreaTreeDate());//调用子页面的方法，得到子页面返回的ids
    				    			    terminalIframeWin = window[layero.find('iframe')[0]['name']];//得到iframe页的窗口对象，执行iframe页的方法：
   
    				    			
    				    				var body = layer.getChildFrame('body',index);//建立父子联系
    				    	            var inputList = body.find('#applyform input');
    				    	            
    				    	          
    				    	            $(inputList[0]).val(data[0].serialNumber);
    				    	            $(inputList[1]).val(data[0].terminalName);
    				    	            $(inputList[2]).val(data[0].areaCode);
    				    	            $(inputList[3]).val(data[0].areaName);
    				    	            $(inputList[4]).val(data[0].detailAddress);
    				    	           // $(inputList[5]).val(data[0].roleId);
    				    	            //body.find("#winRoleSelect option[text='jQuery']").attr("selected", true);  
    				    	           
    				    	            
    				    	            $(inputList[5]).val(data[0].ip);
    				    	            $(inputList[6]).val(data[0].macAddr);
    				    	            $(inputList[7]).val(data[0].resolutionLength);
    				    	            $(inputList[8]).val(data[0].resolutionWidth);
    				    	            $(inputList[9]).val(data[0].ledLength);
    				    	            $(inputList[10]).val(data[0].ledWidth);
    				    	            
    				    	            $(inputList[11]).val(data[0].startSpotTop);
    				    	            $(inputList[12]).val(data[0].startSpotLeft);
    				    	            $(inputList[13]).val(data[0].runStartTime);
    				    	            $(inputList[14]).val(data[0].runEndTime);
    				    	            $(inputList[15]).val(data[0].terminalId);
    				    	            $(inputList[18]).val(data[0].terminalDescribe);
    				    	            body.find('#state').val(data[0].state);
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
				    			title:'添加播放端',
				    			type:2,
				    			area:['98%','98%'],
				    			content:'<%=request.getContextPath()%>/views/ajaxViews/terminal-add.jsp',
				    			success: function(layero, index){
				    			      terminalIframeWin = window[layero.find('iframe')[0]['name']];//得到iframe页的窗口对象，执行iframe页的方法：
                                  
				    			}
				    		});
    				   }
    				   ,updateTerminalState: function(state) {
    				   
    				   
    				      var checkStatus = table.checkStatus('flagOne')
    				      ,data = checkStatus.data;
    				      var pids = [];
    				      for(var i = 0; i < data.length; i++){
    					      pids.push(data[i].terminalId);
    				      }
    				      if(pids.length == 0){
    				    	  layer.msg('请选择要操作的数据!',{icon:6,time:1500});
    				    	  return ;
    				      }
    				      //批量删除
    				      layer.confirm('确定变更状态吗', function(index){
    					         //obj.del();
    					         layer.close(index);
    					         //console.log(pids.length);
    					         $.ajax({
								    url: '<%=request.getContextPath()%>/terminal/updateTerminalState2.do',
								    data:{"terminalIds": terminalIds, "state":state}, 
								    type: "post",
								    traditional: true,  
								    dataType : "json"
								  })
								  .done(function( data ) {
								    
								      if(data.success) {
    									  refresh();
										  if(state == '1') {
								          
								            layer.msg("激活成功",{icon:6,time:2000});
								          } else {
								        
								            layer.msg("禁用成功",{icon:6,time:2000});
								          }  
										       
										       
										       
									  } else {
										       layer.msg(data.msg, {icon:5,time:2000});
									  }
								     
								     
								     
								  })
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
    					  } else if(dothing == "activation"){
    						  active.updateTerminalState(1);
    					  } else if(dothing == "unactivation"){
    						  active.updateTerminalState(0);
    					  } 
    			});
    		  
    		  
    		  
		  

    		});
      }
      
      
      function refresh() {
        init();
      }
      
   </script>
   
</head>
<body>
	<input type="hidden" id="videoView" value="">
	
  <div style="width: 14%; height:100%; float: left">
	    <br>
	    <ul id="demo2"></ul>
  </div>
  <div style="width: 86%; height:100%; float: left">
	
	
	
	<div class="layui-fluid">
		<div class="layui-row layui-col-space1">
			<div class="layui-col-md12">
				<div class="layui-form-query">
					<form class="layui-form" id="query_form">
						<div class="layui-form-item">
							
							<div class="layui-inline">
								<label class="layui-form-mid">序列号码：</label>
								<div class="layui-input-inline"
									style="width: 100px; height: 35px;">
									<input type="tel" id="searchSerialNumber" name="serialNumber" autocomplete="off"
										style="width: 100px; height: 35px;" placeholder="序列号码"
										class="layui-input input-text" />
								</div>
							</div>
							
							<div class="layui-inline">
								<label class="layui-form-mid">播放端名称：</label>
								<div class="layui-input-inline"
									style="width: 110px; height: 35px;">
									<input type="tel" id="searchTerminalName" name="terminalName" autocomplete="off"
										style="width: 110px; height: 35px;" placeholder="播放端名称"
										class="layui-input input-text" />
								</div>
							</div>
							
							<div class="layui-inline">
								<label class="layui-form-mid">所在位置：</label>
								<div class="layui-input-inline"
									style="width: 130px; height: 35px;">
									<input type="tel" id="searchAreaName" name="areaName" autocomplete="off"
										style="width: 130px; height: 35px;"  disabled="disabled" value="中国"
										class="layui-input input-text" />
								</div>
							</div>
							
							
							
							
							<div class="layui-inline">
								<div class="layui-inline">
									<button class="layui-btn" type="button" onclick="init()">
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
			    <button class="layui-btn layui-btn-sm operatorTable" function="getAddData">
				  <i class="layui-icon">&#xe654;</i>添加
				</button>
	        	<button class="layui-btn layui-btn-sm operatorTable"  function="getUpdateData">
			      <i class="layui-icon">&#xe642;</i>修改
			    </button>
				<button class="layui-btn layui-btn-sm layui-btn-danger operatorTable" function="getDeleteData">
				  <i class="layui-icon">&#xe640;</i>删除
				</button>
				<!--  
				<button class="layui-btn layui-btn-sm operatorTable"  function="activation">
			      <i class="layui-icon">&#xe642;</i>激活
			    </button>
				<button class="layui-btn layui-btn-sm layui-btn-danger operatorTable" function="unactivation">
				  <i class="layui-icon">&#xe640;</i>禁用
				</button>
				-->
				<button class="layui-btn layui-btn-sm" onclick="refresh()">
				  <i class="layui-icon">&#x1002;</i>刷新
				</button>
		      </div>
			
		 <div class="layui-col-md12">
            <table class="layui-table" id="table1" lay-filter="tableEvent"></table>
	      </div>
			
		</div>
	</div>
	</div>
	</div>

	<script type="text/javascript">
	layui.use('form', function(){
		  var form = layui.form;
		});
	</script>
	</div>
</body>


  <div id="TreeDivId" style="display:none;">
	    <br>
	    <ul id="demo1"></ul>
  </div>
 
  
</html>