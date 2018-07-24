<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<title>播表生成模块 - layui</title>
   <link href="<%=request.getContextPath()%>/layui/css/layui.css" rel="stylesheet">
   <script type="text/javascript" src="<%=request.getContextPath()%>/layui/layui.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/highCharts/highcharts.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/highCharts/highcharts-3d.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/highCharts/exporting.js"></script>
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/datepicker/WdatePicker.js"></script>
<!-- <style>
body{padding: 50px 50px;}
.layui-upload-img{width: 92px; height: 92px; margin: 0 10px 10px 0;}
hr{margin: 30px 0;}
</style> -->

</head>
<body onload="getTree()">
<input type="hidden" id="videoViewPlay" value=""/>
<input type="hidden" id="treeId" value=""/>
	<div region="center" border="false" style="padding: 5px;">
		<div style="width: 20%;height: 100%; float: left">
			<br>
			<br>
			<ul id="demo2"></ul>
		</div>
		<div style="width: 80%; float: left">
			<div style="height: 35%;">
			<fieldset class="layui-elem-field layui-field-title"
				style="margin-top: 5px;">
				<legend>当前终端对应时段列表</legend>
			</fieldset>

			<div class="layui-upload">
				<input type="button" class="layui-btn" style="margin: 2px;"
					value="当前终端" /> &nbsp;&nbsp;&nbsp;<input id="terminalName"
					type="button" class="layui-btn" style="margin: 2px;" value="无" />
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input id="terminalName" type="button" class="layui-btn" onclick="allTable()" style="margin: 5px;display:none;"  value="一键生成所有播表" />	
				<input id="add" type="hidden" value=""/>
				<div id="changePeriod" class="layui-upload-list" >
					<table id="test" class="layui-table" lay-skin="line">
						<thead>
							<tr>
								<th>时段名</th>
								<th>开始时间</th>
								<th>结束时间</th>
								<th>生效日期</th>
								<th>状态</th>
								<th>操作</th>
							</tr>
						</thead>
						<tbody id="tableList"></tbody>
			       </table>
				</div>
				<button type="button" class="layui-btn" style="margin: 2px;"
					onclick="goBack()">返回</button>
			</div>

			<hr>
		</div>
		<div style="height: 65%;">
		   <div style="width: 70%; float: left" align="left">
		     <div id="container"></div>
		   </div>
		   <div style="width: 30%; float: left">
		      <div id="sliders" align="right">
    <table>
        <tr>
            <td>α 角（内旋转角）</td>
            <td><input id="alpha" type="range" min="0" max="45" value="15"/> <span id="alpha-value" class="value"></span></td>
        </tr>
        <tr>
            <td>β 角（外旋转角）</td>
            <td><input id="beta" type="range" min="-45" max="45" value="15"/> <span id="beta-value" class="value"></span></td>
        </tr>
        <tr>
            <td>深度</td>
            <td><input id="depth" type="range" min="20" max="100" value="50"/> <span id="depth-value" class="value"></span></td>
        </tr>
    </table>
</div>
		   </div>
		</div>
		</div>
	</div>

<script type="text/javascript">

layui.use('layer', function(){
	  var layer = layui.layer;
	});

var d = [100,200,500,300,230,250,600];
var c = [];
var pids = [];

function dateGet(){
	for(var i = 0; i < 7; i++){
		c.push(GetDateStr(i));
	}
}

 function GetDateStr(AddDayCount) { 
	     var dd = new Date(); 
	     dd.setDate(dd.getDate()+AddDayCount);//获取AddDayCount天后的日期 
	     var y = dd.getFullYear(); 
	     var m = dd.getMonth()+1;//获取当前月份的日期 
	     var d = dd.getDate(); 
	     return y+"-"+m+"-"+d; 
	}
 

$(function () {
	
	periodTable();
	
	$.ajax({
		type : "POST",
		url : "/ITMS/period/getMapData.do",
		data : {
			"terminalId" : 't9'
		},
		dataType : "json",
		success : function(dmsg) {
			d = [];
			for(var i = 0; i < dmsg.length; i++){
				d.push(dmsg[i]);
			}
			dateGet();
			highChart();
		}
	});
});

function periodTable(){
	
	layui.use('laydate', function(){
		  var laydate = layui.laydate;
		  for(var i = 0; i < 30; i++){
			  
		  }
		  //执行一个laydate实例
		  laydate.render({
		    elem: '#dateTime0' //指定元素
		    ,range: true
		  });

		pids = [];
		var peid = document.getElementById("treeId").value;
		$.ajax({
			type: "POST",
			url: "<%=request.getContextPath()%>/period/periodChangeTable.do",
			data:{"terminalId":peid},
			dataType: "json",
			success: function(msg){
				$("#test tbody").html("");
				for(var i = 0; i < msg.length; i++){
					pids.push(msg[i].periodId);
					var trObj = document.createElement("tr");
					var tdStr = "<td>" + msg[i].periodName + "</td>"
	                   + "<td>" + msg[i].startInterval + "kb</td>"
	                   + "<td>" + msg[i].endInterval + "</td>"
	                   //+ "<td>" + "<input id='dataTime" + i + "'  style='width:180px;'/></td>"
	                   + "<td>"
	                   + "<div class='layui-inline'><input type='text' class='layui-input' name='myDate' id='timeRange" + i + "' placeholder=' - '/></div>"
	                   //+ "<input class='Wdate' type='text' id='startDate" + i + "' onclick='WdatePicker({firstDayOfWeek:0})' style='width:100px;'/>"
	                  // + "<div class='layui-inline'><div class='layui-input-inline'><input type='text' id='startDate" + i + "' name='myDate' class='layui-input'  placeholder='yyyy-MM-dd'  style='width:100px;' />"
	                  // + " - "
	                  // + "<input class='Wdate' type='text' id='endDate" + i + "' onclick='WdatePicker({firstDayOfWeek:0})' style='width:100px;'/>"
	                  // + "<input type='text' id='endDate" + i + "' name='myDate' class='layui-input'  placeholder='yyyy-MM-dd'  style='width:100px;' /></div></div>"
	                   + "</td>"
	                   + "<td>" + "<label id='stat"+i+"'>等待生成播表</label>" + "</td>"
	                   + "<td><input type='button' id='generateBtn"+i+"' class='layui-btn layui-btn-mini layui-btn' onclick='generateTb(" + i + ")' style='width:100px;' value='生成播表'></td>";
	                trObj.innerHTML = tdStr;
	                document.getElementById("tableList").appendChild(trObj);
	                
	                //generatePtable 7-9 187 修改laydate生成，解决生成播表日期不显示bug 张一鸣
	           		 laydate.render({
					    elem: '#timeRange'+i
					    ,range: true
					 });
				}
				
			
				 
				 
			}
		});
	
  });	
}

function generateTb(id){
	
	var periodId = pids[id];
	
	var time = $("#timeRange"  + id).val().split(" ");
	var startDate = time[0];
	var endDate = time[2];
	console.log("startDate " +startDate + " endDate " + endDate);
	if(startDate == "" || endDate == ""){ 
		layer.msg('生效日期不能为空!',{icon:5,time:2000});
		return ;
	}
	var formData = new FormData();
	formData.append("periodId", periodId);
	formData.append("startDate", startDate);
	formData.append("endDate", endDate);
	  //layer.msg('Hello World');
	  layer.confirm('确定生成播表!?', function(index){
		  layer.load(); //播表生成loading
		  layer.close(index);
		  $.ajax({
			  type : "POST",
			  url : "<%=request.getContextPath()%>/ptable/generateTable.do",
			  data : formData,
			  processData : false,
			  contentType : false,
			  dataType : "json",
			  success : function(msg) {
				  var value = msg.toString();
				  layer.closeAll('loading'); //关闭loading
				  if(value=="true"){
					  layer.msg('播表生成成功!', {
							icon : 6,
							time : 2000
						});
					  //var pid = document.getElementById("p"+id).innerText;
					  //document.getElementById("startDate"+id).value = "";
					  //document.getElementById("endDate"+id).value = "";
					  document.getElementById("stat"+id).innerText = "已生成播表";
					  document.getElementById("generateBtn"+id).value="重新生成";
					  //document.getElementById("b"+id).disabled=true;
				  }else if(value=="false"){
					  document.getElementById("stat"+id).innerText = "播表生成失败";
					  layer.msg('播表生成失败! 请确定排播有包括今天以后的节目', {
							icon : 5,
							time : 2000
						});
				  }else if(value=="1"){
					  layer.msg('登陆超时,重新登陆操作!', {
							icon : 5,
							time : 2000
						});
				  }else if(value=="2"){
					  layer.msg('生效日期不能为空!', {
							icon : 5,
							time : 2000
						});
				  }else if(value=="3"){
					  layer.msg('生效日期前后有误!', {
							icon : 5,
							time : 2000
						});
				  }
			  }
		  });
	  });
}

function highChart(){
    // Set up the chart
    var chart = new Highcharts.Chart({
        chart: {
            renderTo: 'container',
            type: 'column',
            options3d: {
                enabled: true,
                alpha: 15,
                beta: 15,
                depth: 50,
                viewDistance: 25
            }
        },
        title: {
            text: '终端未来7天预测图'
        },
        xAxis: {
            categories: c
        },
        yAxis: {
            allowDecimals: false,
            min: 0,
            title: {
                text: '播放总时长(/分钟)'
            }
        },
        subtitle: {
            text: ''
        },
        plotOptions: {
            column: {
                depth: 25
            }
        },
        series: [{
            name:'播放总时长',
            data: d
        }]
    });
    function showValues() {
        $('#alpha-value').html(chart.options.chart.options3d.alpha);
        $('#beta-value').html(chart.options.chart.options3d.beta);
        $('#depth-value').html(chart.options.chart.options3d.depth);
    }
    // Activate the sliders
    $('#sliders input').on('input change', function () {
        chart.options.chart.options3d[this.id] = this.value;
        showValues();
        chart.redraw(false);
    });
    showValues();
}

</script>


	<script type="text/javascript">
var node = [];
/* $(function(){
	  
	}); */
	function getTree(){
		treeSearch();

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
							id:'' + msg[i].children[j].id
						});
					}
				}
				node[i].children = child;
			}
			
			layui.use(['tree', 'layer'], function(){
				  var layer = layui.layer
				  ,$ = layui.jquery; 
				  
				  layui.tree({
				    elem: '#demo2' //指定元素
				    ,target: '_blank' //是否新选项卡打开（比如节点返回href才有效）
				    ,click: function(item){ //点击节点回调
				      //layer.msg('当前节名称：'+ item.name + '<br>全部参数：'+ JSON.stringify(item));
				      //console.log(item);
				      var id = item.id;
				      var name = item.name
				      document.getElementById("treeId").value = id;
				      if(id.charAt(0) == 't'){
				    	  document.getElementById("terminalName").value = name;
				    	  //$("#forcast").remove();
				    	  //var domtree = '<input id="forcast" type="button" class="layui-btn" onclick="periodForcast()" style="margin: 5px;" value="播表预测"/>'
				    	  //$("#add").after(domtree);
				    	  getMapData();
				      }else{
				    	  //$("#forcast").remove();
				    	  document.getElementById("terminalName").value = "无";
				      }
				      //queryPeriod();
				      periodTable();
				    }
				    ,nodes: node
				  });
			});
		}
	});
}

function generateTable(id){
	layui.use('layer', function(){
		  var layer = layui.layer;		  
		}); 
	
	var ptableName = document.getElementById("b"+id).value;
	var formData = new FormData();
	formData.append("ptableName", ptableName);
	formData.append("periodId", id);
	  var layer = layui.layer;
	  //layer.msg('Hello World');
	  layer.confirm('确定生成播表!?', function(index){
		  //do something
			//var tid = document.getElementById("treeId").value;
			//if(tid == null || tid == ''){
			//	tid = "t9";
			//}
		  layer.load(); //播表生成loading
		  layer.close(index);
		  $.ajax({
			  type : "POST",
			  url : "<%=request.getContextPath()%>/ptable/generateTable.do",
			  data : formData,
			  processData : false,
			  contentType : false,
			  dataType : "json",
			  success : function(msg) {
				  var value = msg.toString();
				  layer.closeAll('loading'); //关闭loading
				  if(value=="true"){
					  var pid = document.getElementById("p"+id).innerText;
					  document.getElementById("p"+id).innerText = "已生成播表";
					  document.getElementById("b"+id).value="重新生成";
					  //document.getElementById("b"+id).disabled=true;
				  }else{
					  document.getElementById("p"+id).innerText = "播表生成失败";
				  }
			  }
		  });
		}); 
}

function getMapData(){
	var td = document.getElementById("treeId").value;
	$.ajax({
		type : "POST",
		url : "/ITMS/period/getMapData.do",
		data : {
			"terminalId" : td
		},
		dataType : "json",
		success : function(dmsg) {
			d = [];
			for(var i = 0; i < dmsg.length; i++){
				d.push(dmsg[i]);
			}
			dateGet();
			highChart();
		}
	});
}

function queryPeriod(){
	layui.use('layer', function(){
		  var layer = layui.layer;
		});
	//layer.msg('Hello jan');
	var peid = document.getElementById("treeId").value;
	//layer.msg(peid);
	$.ajax({
		type : "POST",
		url : "/ITMS/period/periodChangeTable.do",
		data : {
			"terminalId" : peid
		},
		dataType : "html",
		success : function(dmsg) {
			layer.msg('查询成功!', {
				icon : 6,
				time : 2000
			});
			$("#changePeriod").html(dmsg);
		}
	});
}

function periodForcast(periodId){
	
}

function allTable(){
	  var layer = layui.layer;
	  layer.msg('Hello World');
	  layer.confirm('is not?', function(index){
		  //do something
		  
		  layer.close(index);
		}); 
}



function goBack(){
	document.location = "<%=request.getContextPath()%>/material/broadcastList.do";
}

function preView(){
	var newWindow = window.open('video.html',"_blank","toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes,left=300,top=100, width=800, height=500");
	/* newWindow.document.getElementById("val").value = 'your code here'; */
}
</script>
</body>
</html>
