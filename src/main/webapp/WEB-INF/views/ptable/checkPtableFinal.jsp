<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <%@ include file="/layui/header.jsp"%>
   <title>播表终审</title>
   <meta name="renderer" content="webkit">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  <%-- <script type="text/javascript" src="<%=request.getContextPath()%>/st/Sortable.js"></script> --%>
   <script type="text/javascript" defer="defer">
        var pid = '${pid}';
        
		$(function(){
			initTable();
		});
		
		function initTable(){
			layui.use('layer', function(){
	    		  var layer = layui.layer;
	    		});
			
			layui.use('table', function(){
	    		  var table = layui.table;
	    		  table.render({
	    		    elem: '#table1'
	    		    ,id: 'flagOne'
	    		    ,url:'<%=request.getContextPath()%>/ptable/getPtableById.do'
	    		    //,height: 320
	    		    ,skin: 'row'
	    		    //,cellMinWidth: 120
	    		    ,limits:[10,25,50,75,100]
	    		    ,cols: [[
	    		      //{field:'id', width:'1%'}
	    		     {type:'numbers'}
	    		    ,{field:'materialName',width:270, event: 'set1', title: '素材名称'}
	      		    ,{field:'frequency',width:140, event: 'set2', title: '频次'}
	      		    ,{field:'duration',width:140, event: 'set3', title: '时长'}
	      		    ,{fixed: 'right', width:110, event: 'set4', title: '操作', align:'center', toolbar: '#barDemo'}
	      		    ]]
	    		    ,page: false
	    		    ,where: {"pid": pid}
	    		    ,done: function(res, curr, count){
	    		    	  //document.getElementById("table1").remove();
	    		    	  if(res.fail == 1){
	    		    	      layer.msg(res.msg,{icon:5,time:2000});
	    		    	  }else if(res.fail == 0){
	    		    		  document.getElementById("ptableNameThree").innerHTML = '<font  size="4"  color="red"> 当前播表名：' + res.msg + '</font>';
	    		    	  }
	    		    	  
	    		    	  var arr = [];
	    		    	  
	    		    	  var myDate = new Date();
	    		    	  var year = myDate.getFullYear();
	    		    	  debugger;
	  	                  var vList = []; // 初始化播放列表 var
	  	                  var ms = [];
	  	                  var tdata = res.data;
	  	                for(var i = 0, l = tdata.length; i < l; i++) { 
	  	                	for(var j = i + 1; j < l; j++) 
	  	                		if (tdata[i].material.mid === tdata[j].material.mid) j = ++i; 
	  	                	arr.push(tdata[i].material.mid); 
	  	                }
	  	                if(arr.length != 0){
	  	                	document.getElementById("totalMaterial").innerHTML = '<span style="color: #1E9FFF;">总共有' + arr.length + '条不同素材</span>';
	  	                	//document.getElementById("totalMaterial").innerText = "" +  + "";
	  	                }
	  	                  
	  	                  for(var i = 0; i < tdata.length; i++){
	  	                	var filePath = tdata[i].material.filePath;
	  	    			    var name = filePath.split("/");
	  	    			    var realname = name[name.length - 1];
	  	    			    //var path = "<%=request.getContextPath()%>/media/" + year + "/" + realname;
	  	    			    var path = '<%=request.getContextPath()%>/downloadController/showVedio.do?filename=' + realname;
	  	    			    vList.push(path);
	  	    			    ms.push(tdata[i].material);
	  	                  }
	  	                  
	  	                var curr = 0; // 当前播放的视频 
		                var video = document.getElementById("video1");
		                video.addEventListener('ended', play);
			            vLen = vList.length; // 播放列表的长度
			            play();
		                function play() {
			            	document.getElementById("mName").innerText = "当前播放素材名:  " + ms[curr].materialName;
			            	document.getElementById("mResolution").innerText = "分辨率:  " + ms[curr].resolution;
			            	document.getElementById("mSize").innerText = "大小:  " + ms[curr].size;
			            	document.getElementById("mDuration").innerText = "时长:  " + ms[curr].duration;
			            	document.getElementById("mTerminalName").innerText = "所属终端:  " + ms[curr].terminal.terminalName;
			            	
		                    var video = document.getElementById("video1");
		                    video.src = vList[curr];
		                    video.load(); //如果短的话，可以加载完成之后再播放，监听 canplaythrough 事件即可
		                    video.play();
		                    curr++;
		                    if (curr >= vLen)
		                        curr = 0; // 播放完了，重新播放
		                }
	    		    	  //console.log(res.msg);
	    		      }
	    		  });
	    		  
	    		  table.on('tool(tableEvent)', function(obj){
	    			  var tmpdata = obj.data;
	    			  var mid = tmpdata.material.mid;
	    			  var filePath = tmpdata.material.filePath;
	    			  var name = filePath.split("/");
	    			  var realname = name[name.length - 1];
	    			  console.log(realname);
	    			  document.getElementById("videoView").value = realname;
	    			  if(obj.event === 'mediaView'){
	    				  $.ajax({
	    						type:"POST",
	    					    url: '<%=request.getContextPath()%>/material/viMaterial.do',
	    					    data: {"mid": mid},
	    					    dataType : "json",
	    					    success: function(msg){
	    					    	var value = msg.toString();
	    							if(value=="true"){
	    								console.log(6666);
	    				                window.open('<%=request.getContextPath()%>/file/videoView.jsp',"_blank","toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes,left=300,top=20, width=800, height=620");
	    							}
	    					    }
	    				   });
	    			  }
	    		  });
	    		});
		}
		
		function goBack() {
			   document.location = "<%=request.getContextPath()%>/ptable/ptableCheckSecondList.do";
			}
		
		
		function ptableUnaccess(){
			var mark = $("#mark").val();
			//alert(mark);
			$.ajax({
				type: "POST",
				url: "<%=request.getContextPath()%>/ptable/modifyPlayTableFinalNumUn.do",
				traditional: true,
				data:{"ppid" : pid,"mark":mark},
				dataType : "json",
				success : function(msg){
					var value = msg.toString();
					if(value=="true"){
						//initGrid();
						//doCheckSearch();
						layer.msg('审核保存成功!',{icon:6,time:1500});
						document.location = "<%=request.getContextPath()%>/ptable/ptableCheckSecondList.do";
					}else{
						layer.msg('审核保存失败!',{icon:5,time:1500});
					}
				}
			});
		}
		
		function ptableAccess(){
			var noValue = "";
			$.ajax({
				type: "POST",
				url: "<%=request.getContextPath()%>/ptable/modifyPlayTableFinalNum.do",
				data: {"ppid" : pid,"sortNum":noValue},
				traditional: true,
				dataType : "json",
				success : function(msg){
					var value = msg.toString();
					if(value=="true"){
						layer.msg('审核保存成功!',{icon:6,time:1500});
						document.location = "<%=request.getContextPath()%>/ptable/ptableCheckSecondList.do";
					}else{
						layer.msg('审核保存失败!',{icon:5,time:1500});
					}
				}
			});
		}
		
    </script>
<body>
<input type="hidden" id="videoView" value="">
    <div class="layui-fluid">
  <div class="layui-row layui-col-space10">
   <div  align="center">
       <blockquote class="layui-elem-quote">
                         播表终审页
    </blockquote>
   </div>

    <div class="layui-col-md4">
		<fieldset class="layui-elem-field">
         <legend><i class="layui-icon">&#xe6ed;</i>播放预览</legend>
         <div class="layui-field-box">
         	<div class="layui-row layui-col-space10">
         		<div class="layui-col-md12">
         			<div align="center">
		        <video width="300" height="250" id="video1" class="indexBanner" controls="controls" autoplay>
		           <source src="" type="video/mp4" />
		        </video>
		      </div>
         		</div>
         		<div>
         		  <label id="mName"></label>
         		  <br><br>
         		  <label id="mResolution"></label>
         		  &nbsp;&nbsp;&nbsp;&nbsp;<label id="mSize"></label>
         		  &nbsp;&nbsp;&nbsp;&nbsp;<label id="mDuration"></label>
         		  <br><br>
         		  <label id="mTerminalName"></label>
         		</div>
         	</div>
		  	
		  </div>
		  </fieldset>
    </div>
    
    <div class="layui-col-md8">
		<fieldset id="menu_func_div" class="layui-elem-field">
	         <legend><i class="layui-icon">&#xe6ed;</i>播表素材顺序列表</legend>
	         <div class="layui-field-box">
			    <div class="layui-inline">
			       <label class="layui-form-mid" id="ptableNameThree">
			       
			       </label>
		        </div>
			    <div class="layui-col-md12 layui-col-space1">
					<table class="layui-table" id="table1" lay-filter="tableEvent"></table>
					<br>
					<form class="layui-form" id="query_form">
						<div class="layui-form-item">
					        <div class="layui-inline">
								<label class="layui-form-mid layui-bg-green">备注：</label>
								<div class="layui-input-inline"
									style="width: 400px; height: 35px;">
									<input id="mark" placeholder="审核理由" style="width: 350px; height: 35px;" class="layui-input input-text"/>
								</div>
					        </div>
					     </div>
					</form>
					<div class="layui-inline">
								<div class="layui-inline">
									<button class="layui-btn" type="button" onclick="ptableAccess()">
										<i class="layui-icon">&#xe618;</i>审核通过
									</button>
								</div>
								<div class="layui-inline">
									<button class="layui-btn layui-btn-danger" type="button" onclick="ptableUnaccess()">
										<i class="layui-icon">&#x1006;</i>审核不通过
									</button>
								</div>
								<div class="layui-inline">
									<button class="layui-btn" type="button"  onclick="goBack()">
						                <i class="layui-icon">&#xe65c;</i>返回
					                </button>
					                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					                <label id="totalMaterial"></label>
								</div>
					</div>
					<br>
					<script type="text/html" id="barDemo">
  						 <a id="del" class="layui-btn layui-btn-danger layui-btn-sm" lay-event="mediaView">预览</a>
					</script>
			    </div>
			  </div>
			  <br>
		</fieldset>
    </div>
  </div>
</div>
</body>
</html>