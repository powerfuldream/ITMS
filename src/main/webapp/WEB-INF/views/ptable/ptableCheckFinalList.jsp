<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <%@ include file="/layui/header.jsp"%>
   <title>播表列表</title>
   <meta name="renderer" content="webkit">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
   <script type="text/javascript" defer="defer">
   $(function(){
	   init();
   });
   
      function init(){
    	  layui.use('layer', function(){
    		  var layer = layui.layer;
    		});
		   		   
		   //状态
		   var statusId = "2";
    	  
    	  layui.use('table', function(){
    		  var table = layui.table;
    		  table.render({
    		    elem: '#table1'
    		    ,id: 'flagOne'
    		    ,url:'<%=request.getContextPath()%>/ptable/searchUnckeckFirstPtable.do'
    		    ,height: 550
    		    //,cellMinWidth: 120
    		    ,limits:[10,25,50,75,100]
    		    ,cols: [[
    		      //{field:'id', width:'1%'}
    		      {field:'ptableName',width:250, event: 'set1', title: '播表名', fixed: true, sort: true}
      		      ,{field:'playDate',width:120, event: 'set2', title: '播放日期', sort: true
      		    	,templet: function(d){
    		    		  var date = new Date(d.playDate);
    		    		  var Y = date.getFullYear() + '-';
    		    		  var M = (date.getMonth()+1 < 10 ? '0'+(date.getMonth()+1) : date.getMonth()+1) + '-';
    		    		  var D = (date.getDate() < 10 ? '0' + (date.getDate()) : date.getDate()) + ' ';    		   		 
    		    		  return Y+M+D;
    		    	  } 
      		      }
      		    ,{field:'periodTime',width:260, event: 'set3', title: '时段范围', sort: true
      		    	,templet: function(d){
      		    		var periodName = d.periodName;
      		    		var periodTime = d.periodTime;
      		    		return periodName + " " + periodTime;
      		    	}
      		      }
      		  ,{field:'insertFlag',width:100, event: 'set4', title: '播表类型', sort: true
  		    	,templet: function(d){
  		    		var flag = d.insertFlag;
  		    		if(flag == '0'){
  		    			return '<span style="color: #90EE90;">周期轮播</span>';
  		    		}else if(flag == '1'){
  		    			return '<span style="color: #FF6347;">插播</span>';
  		    		}
  		    	}
  		      }
      		      ,{field:'statusId',width:110, event: 'set5', title: '审核状态', sort: true
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
      		      ,{field:'playTotalTime',width:120, event: 'set6', title: '播表时长', sort: true}
      		      ,{field:'allTime',width:120, event: 'set7', title: '可播时长'}
      		      ,{field:'screenRate',width:100, event: 'set8', title: '占屏比', sort: true}
      		    ,{field:'terminalName',width:120, event: 'set9', title: '终端名', sort: true}
      		      ,{field:'createName',width:120, event: 'set10', title: '创建人', sort: true}
      		      ,{field:'createTime',width:180, event: 'set11', title: '创建时间', sort: true
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
      		      ,{fixed: 'right', width:100, event: 'set12', title: '操作', align:'center', toolbar: '#barDemo'}
      		    ]]
    		    ,page: true
    		    ,where: {"statusId":statusId}
    		    ,done: function(res, curr, count){
    		    	  //document.getElementById("table1").remove();
    		    	  if(res.fail == 1){
    		    	      layer.msg(res.msg,{icon:5,time:2000});
    		    	  }
    		    	  //console.log(res.msg);
    		      }
    		  });
    		  
    		  table.on('tool(tableEvent)', function(obj){
    			  var tmpdata = obj.data;
    			  var pid = tmpdata.pid;
    			  if(obj.event === 'mediaInfo'){
    				  document.location = '<%=request.getContextPath()%>/ptable/goCheckPtableFinal/' + pid + '.do';
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
								<div class="layui-inline">
									<button class="layui-btn" type="button" onclick="init()">
										<i class="layui-icon">&#x1002;</i>刷新
									</button>
								</div>
							</div>
						</div>
					</form>
				</div>
			</div>
			
		 <div class="layui-col-md12">
            <table class="layui-table" id="table1" lay-filter="tableEvent"></table>
			<script type="text/html" id="barDemo">
 				<a class="layui-btn layui-btn-sm" lay-event="mediaInfo">
                <i class="layui-icon">&#xe6ed;</i>审核</a>
			</script>
			<script type="text/html" id="barDemo1">
 				<a class="layui-btn layui-btn-sm layui-btn-danger" lay-event="md5" >MD5</a>
			</script>
	      </div>
			
		</div>
	</div>
</body>
</html>