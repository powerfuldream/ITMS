<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
   <link href="<%=request.getContextPath()%>/assets/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
      <link href="<%=request.getContextPath()%>/layui/css/layui.css" rel="stylesheet">
   <script type="text/javascript" src="<%=request.getContextPath()%>/layui/layui.js"></script>
 <script type="text/javascript" src="<%=request.getContextPath()%>/st/Sortable.js"></script>
</head>
<body>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
  <legend>时段列表</legend>
</fieldset>
	<div align="center">

		<div class="panel panel-default" >
		  <div class="panel-heading">
		     <h5 class="sub-header"><i class="fa fa-video-camera"></i><span style="margin-left:2px;">顺序播放视频调整列表(拖拽):</span></h5>
		  </div>
		  <div class="panel-body">
				<ul id="foo" class="block__list block__list_words">
<!-- 					<li drag-id="1">1</li>
					<li drag-id="2">2</li>
					<li drag-id="3">3</li>
					<li drag-id="4">4</li>
					<li drag-id="5">5</li>
					<li drag-id="6">6</li>
					<li drag-id="7">7</li>
					<li drag-id="8">8</li> -->
					<c:forEach items="${sessionScope.tableFirst}" var="table" varStatus="status">
						<li drag-id="${table.mid}">${table.materialName}</li>
					</c:forEach>
				</ul>
		  </div>
		</div>
		
		<button type="button" class="layui-btn" id="selectPeriod"
			onclick="saveFileList()">确定</button>
		<button type="button" class="layui-btn" style="margin: 5px;"
			onclick="goBack()">关闭</button>
	</div>
   <script>
        
        var listFile='';     
   
		Sortable.create(document.getElementById('foo'), {
			animation : 150, //动画参数
			onAdd : function(evt) { //拖拽时候添加有新的节点的时候发生该事件
				console.log('onAdd.foo:', [ evt.item, evt.from ]);
			},
			onUpdate : function(evt) { //拖拽更新节点位置发生该事件
				console.log('onUpdate.foo:', [ evt.item, evt.from ]);
			},
			onRemove : function(evt) { //删除拖拽节点的时候促发该事件
				console.log('onRemove.foo:', [ evt.item, evt.from ]);
			},
			onStart : function(evt) { //开始拖拽出发该函数
				console.log('onStart.foo:', [ evt.item, evt.from ]);
			},
			onSort : function(evt) { //发生排序发生该事件
				console.log('onSort.foo:', [ evt.item, evt.from ]);
			},
			onEnd : function(evt) { //拖拽完毕之后发生该事件
				console.log('onEnd.foo:', [ evt.item, evt.from ]);
				var id_arr = '';
				for (var i = 0, len = evt.from.children.length; i < len; i++) {
					id_arr += ','
							+ evt.from.children[i].getAttribute('drag-id');
				}
				//alert(id_arr);
				id_arr = id_arr.substr(1);
				listFile = id_arr;
				//然后请求后台ajax 这样就完成了拖拽排序
				//alert(id_arr);
				//console.log(id_arr);
			}
		});
		
		function saveListFile(){
			if(listFile == '') {
				$.messager.alert('提示', '顺序未改动');
			}else{
					alert(listFile);//modifyPlayTableNum
					$.ajax({
						type: "POST",
						url: "<%=request.getContextPath()%>/ptable/modifyPlayTableNum.do",
						data: {"sortNum":listFile},
						traditional: true,
						dataType : "json",
						success : function(msg){
							var value = msg.toString();
							if(value=="true"){
								//initGrid();
								//doCheckSearch();
								$.messager.alert('提示', '保存成功!!!');
								document.location = "<%=request.getContextPath()%>/ptable/ptableCheckList.do";
							}else{
								$.messager.alert('提示', '保存失败!!!');
							}
						}
					});
			}			
		}

		function goBack() {
			parent.layer.closeAll();
		}
	</script>

</body>
</html>