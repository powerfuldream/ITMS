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
<%@ include  file="/assets/header.jsp"%>
<title>播表生成模块 - layui</title>
   <link href="<%=request.getContextPath()%>/layui/css/layui.css" rel="stylesheet">
   <script type="text/javascript" src="<%=request.getContextPath()%>/layui/layui.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/highCharts/highcharts.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/highCharts/highcharts-3d.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/highCharts/exporting.js"></script>
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
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
				<input id="terminalName" type="button" class="layui-btn" onclick="allTable()" style="margin: 5px;" value="一键生成所有播表" />	
				<input id="add" type="hidden" value=""/>
				<div id="changePeriod" class="layui-upload-list" >
					<table class="layui-table" lay-skin="line">
						<thead>
							<tr>
								<th>时段名</th>
								<th>开始时间</th>
								<th>结束时间</th>
								<th>状态</th>
								<!-- <th>
								播表名
								</th> -->
								<th>操作</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${periodTwice}" var="period" varStatus="status">
								<tr>
									<td>${period.periodName}</td>
									<td>${period.startInterval}</td>
									<td>${period.endInterval}</td>
									<td>
									<span style="color: #5FB878;">
									<label id='p${period.periodId}'>
									<c:choose>
									<c:when test="${period.status == 0}">等待生成播表
                             </c:when>
                             <c:otherwise> 已生成播表
                             </c:otherwise>
                          </c:choose>
									</label>
									</span>
									</td>
									<%-- <td>
									<input id='n${period.periodId}' class="layui-input" value="" width="80" placeholder="请输入播表名"/>
									</td> --%>
									<td>
									<c:choose>
									<c:when test="${period.status == 0}">
									<input id='b${period.periodId}' type="button" class="layui-btn" onclick="generateTable('${period.periodId}')" style="margin: 2px;" value="生成播表" />	
                             </c:when>
                             <c:otherwise>
									<input id='b${period.periodId}' type="button" class="layui-btn" onclick="generateTable('${period.periodId}')" style="margin: 2px;" value="重新生成"/>	 <!-- disabled -->
                             </c:otherwise>
                          </c:choose>
                          <%-- <input id='bp${period.periodId}' type="button" class="layui-btn" onclick="periodForcast('${period.periodId}')" style="margin: 5px;" value="播表预测" disabled/>	 --%>
									</td>
								</tr>
							</c:forEach>
						</tbody>
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


var d = [100,200,500,300,230,250,600];
var c = [];

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
		            id: '' + msg[i].id
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
				      queryPeriod();
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
		  //layer.msg('hello');
		  layer.load(); //播表生成loading
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
	document.location = "<%=request.getContextPath()%>/ptable/broadCheckList.do";
}

function preView(){
	var newWindow = window.open('video.html',"_blank","toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes,left=300,top=100, width=800, height=500");
	/* newWindow.document.getElementById("val").value = 'your code here'; */
}
</script>
</body>
</html>
