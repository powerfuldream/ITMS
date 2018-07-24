<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <%@ include file="/layui/header.jsp"%>
   <title>素材列表</title>
   <meta name="renderer" content="webkit">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
   <%-- <script src="<%=request.getContextPath()%>/layui/jquery-1.8.2.min.js"></script> --%>
   <script type="text/javascript" defer="defer">
   var terminalId = '${terminalId}';
   $(function(){
	   init();
   });
   
      function init(){
    	  
    	  var params = "";
    	  
    	  var value;
    	  
    	   value = $("#materialName").val();
		   if(value != "") {
			   params = params + "materialName" + ",like,%" + value + "%,";
		   }
		   
		   if(terminalId != "") {
			   params = params + "terminal_id" + ",=," + terminalId + ",";
		   }
		   
		   
		   params = params + "statusId" + ",=," + "3" + ",";
    	  
    	  layui.use('table', function(){
    		  var table = layui.table;
    		  table.render({
    		    elem: '#table1'
    		    ,id: 'flagOne'
    		    ,url:'<%=request.getContextPath()%>/material/getAllMaterialInfo.do'
    		    ,height: 300
    		    //,cellMinWidth: 120
    		    ,limits:[10,25,50,75,100]
    		    ,cols: [[
    		      //{field:'id', width:'1%'}
    		      {checkbox: true, event: 'set1', fixed: true}
    		      ,{field:'materialName',width:200, event: 'set2', title: '素材名', fixed: true, sort: true}
    		      ,{field: 'terminalName',width:125, event: 'set3', title: '终端名', sort: true
    		    	  ,templet: function(d){
    		    		  var name = d.terminal;
    		    		  return '<span style="color: #1E9FFF;">' + name.terminalName + '</span>';
    		    	  }
    		      }
    		      ,{field: 'resolution',width:100, event: 'set4', title: '分辨率', sort: true}
      		      ,{field: 'duration',width:90, event: 'set5', title: '时长(秒)', sort: true}
      		      ,{field: 'size',width:100, event: 'set6', title: '大小', sort: true}
      		      ,{field: 'usedNum',width:95, event: 'set7', title: '使用次数', sort: true}
      		      ,{fixed: 'right', width:90, event: 'set8', title: '操作', align:'center', toolbar: '#barDemo'}
      		    ]]
    		    ,page: true
    		    ,where: {"param": params}
    		    ,done: function(res, curr, count){
    		    	  //document.getElementById("table1").remove();
    		      }
    		  });
    		  
    		  table.on('checkbox(tableEvent)', function(obj){
  			      //console.log(obj);
  		       });
    		  
    		  var active = {
    		      getAddData: function(){//获取选中数据
    		    	  var checkStatus = table.checkStatus('flagOne')
				      ,data = checkStatus.data;
    		          var tmpdata = '';
    		          var mids = [];
    		          for(var i = 0; i < data.length; i++){
    		        	  mids.push(data[i].mid);
    		        	  tmpdata = tmpdata + data[i].materialName + '='
    		        	  + data[i].duration + '='
    		        	  + data[i].size + '='
    		        	  + data[i].resolution + '=';
    		          }
    		      
    		    	  parent.$('#checkData').val(tmpdata);
    		    	  parent.$('#checkTwice').val(tmpdata);
    		    	  parent.$('#midData').val(mids);
    		    	  parent.layer.closeAll();
    		          /* for(var i = 0; i < data.length; i++){
    		        	  var tdStr = "<td>" + data[i].materialName + "</td>"
                                + "<td>" + size.toFixed(1) + "kb</td>"
                                + "<td>" + tname + "</td>"
                                + "<td>" + "<progress id='prog" + offset + "' value='0' max='100' style='width:100px;'></progress>" 
                                + "<label id='numValue"+offset+"'>0%</label>" + "</td>"
                                + "<td>" + "<label id='stat"+offset+"'>等待上传</label>" + "</td>"
                                + "<button id='delbtn"+offset+"' class='layui-btn layui-btn-mini layui-btn-danger' onclick='delFile(" + offset + ")'>删除</button>"
                                + "<button id='prevbtn"+offset+"' class='layui-btn layui-btn-mini layui-btn' onclick='preView(" + offset + ")'>预览</button></td>";
                          trObj.innerHTML = tdStr; 
    		          }   	*/	      
    		      }
    		  };
    		  
    		  $('.operatorTable').on('click', function(){
				  var othis = $(this);
				  var dothing = othis.attr("function");
				  if(dothing == "getAddData"){
					  //console.log(dothing);
					  active.getAddData();
				  }
			  });
    		  
    		  table.on('tool(tableEvent)', function(obj){
    			  var tmpdata = obj.data;
    			  var mid = tmpdata.mid;
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
    					    data: {"mid": mid},
    					    dataType : "json",
    					    success: function(msg){

    						   window.open('<%=request.getContextPath()%>/file/videoView.jsp',"_blank","toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes,left=300,top=20, width=800, height=620");
    							
    					    }
    					});
    			  }else if(obj.event === 'checkMaterial'){
    				  var index = parent.layer.getFrameIndex(window.name);
    				  //console.log(mid);
    				  //console.log(materialName);
    				  parent.$("#mid").val(mid);
    				  parent.$('#materialName').val(materialName);
    				  parent.layer.closeAll();
    			  }
    		  });
    		});
      }
      
      function myTrim(x) {
    	    return x.replace(/^\s+|\s+$/gm,'');
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
								<label class="layui-form-mid">素材名：</label>
								<div class="layui-input-inline"
									style="width: 100px; height: 35px;">
									<input type="tel" id="materialName" name="materialName" autocomplete="off"
										style="width: 100px; height: 35px;" placeholder="素材名"
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
	</div>
  <hr class="layui-bg-green"/>
  <div class="layui-form-item">
    <div class="layui-input-block">
      <button class="layui-btn operatorTable" function="getAddData" data-type="getAddData" ><i class="layui-icon">&#xe654;</i>添加</button>
      <button type="button" class="layui-btn layui-btn-primary" onclick="closeWind()">关闭</button>
    </div>
  </div>

	<script type="text/javascript">
	layui.use('form', function(){
		  var form = layui.form;
		});
	
	function closeWind(){
		   var index = parent.layer.getFrameIndex(window.name);
		   parent.layer.closeAll();
	   }
	
	</script>
</body>
</html>