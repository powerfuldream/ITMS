<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <%@ include file="/layui/header.jsp"%>
    <script src="../../layui/DataTableExtend.js"></script>
   <title>播表详情</title>
   <meta name="renderer" content="webkit">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
   <script type="text/javascript" defer="defer">
        var pid = '${pid}';//播表ID
        var periodName='${periodName}';//时段名
        var tid='${tid}';//终端ID
        var ptdate;//播表的播放日期
        var periodID;//时段ID
        var itemnum;//该播表素材的总数
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
	    		     {type:'numbers',title: '序号'}
	    		    ,{field:'materialName',width:270, event: 'set1', title: '素材名称'}
	      		    ,{field:'frequency',width:140, event: 'set2', title: '频次'}
	      		    ,{field:'duration',width:140, event: 'set3', title: '时长'}
	      		    ,{fixed: 'right', width:110, event: 'set4', title: '操作', align:'center', toolbar: '#barDemo',width : '200'}
	      		    ]]
	    		    ,page: false
	    		    ,where: {"pid": pid}
	    		    ,done: function(res, curr, count){
	    		    	
	    		    	 /* LayUIDataTable.SetJqueryObj($);// 第一步：设置jQuery对象

	                        //LayUIDataTable.HideField('num');// 隐藏列-单列模式
	                        //LayUIDataTable.HideField(['num','match_guest']);// 隐藏列-多列模式

	                        var currentRowDataList = LayUIDataTable.ParseDataTable(function (index, currentData, rowData) {
	                            console.log("当前页数据条数:" + currentRowDataList.length)
	                            console.log("当前行索引：" + index);
	                            console.log("触发的当前行单元格：" + currentData);
	                            console.log("当前行数据：" + JSON.stringify(rowData));

	                            var msg = '<div style="text-align: left"> 【当前页数据条数】' + currentRowDataList.length + '<br/>【当前行索引】' + index + '<br/>【触发的当前行单元格】' + currentData + '<br/>【当前行数据】' + JSON.stringify(rowData) + '</div>';
	                            layer.msg(msg)
	                        }) */
	                        
	                        
	    		    	  //document.getElementById("table1").remove();
	    		    	  if(res.fail == 1){
	    		    	      layer.msg(res.msg,{icon:5,time:2000});
	    		    	  }else if(res.fail == 0){
	    		    		  document.getElementById("ptableNameOnce").innerHTML = '<font  size="4"  color="red"> 当前播表名：' + res.msg + '</font>';
	    		    		 var tempstr=res.msg;
	    		    		 var date = /(.+)?(?:\(|（)(.+)(?=\)|）)/.exec(tempstr);
	    		    		 ptdate=date[2];
	    		    		  
	    		    	  }
	    		    	  
	    		    	  var arr = [];
	    		    	  
	    		    	  var myDate = new Date();
	    		    	  var year = myDate.getFullYear();
	    		    	  debugger;
	  	                  var vList = []; // 初始化播放列表 var
	  	                  var ms = [];
	  	                  var tdata = res.data;
	  	                  
	  	                itemnum=tdata.length;
	  	                periodID=tdata[0].periodId;
	  	                
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
	  	    			  //  var path = "<%=request.getContextPath()%>/media/" + year + "/" + realname;
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
	    			  var objnumber = obj.tr[0].rowIndex;
	    			  var filePath = tmpdata.material.filePath;
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
	    					 
	    			  }if(obj.event==='copy'){
	    				  $.ajax({
	    						type: "POST",
	    						url: "<%=request.getContextPath()%>/ptable/copyOneToPlayFile.do",
	    						data: {"ppid" : pid,"mmid" :mid,"num" :itemnum},
	    						traditional: true,
	    						dataType : "json",
	    						success : function(msg){
	    							var value = msg.toString();
	    							if(value=="true"){
	    			    				  layer.msg('复制成功',{icon:6,time:1500});
	    			    				  initTable();
	    							}else{
	    								layer.msg(msg.toString(),{icon:5,time:1500});
	    							}
	    						}
	    					});
	    				 
	    				  
	    			  }else if(obj.event==='del'){
	    				   layer.confirm('真的删除么', function(index){
	    				     
	    					  layer.close(index);
	    				      //向服务端发送删除指令
	    				       $.ajax({
	    						type: "POST",
	    						url: "<%=request.getContextPath()%>/ptable/delOneFromPlayFile.do",
	    						data: {"ppid" : pid,"mmid" :mid,"num" :objnumber},
	    						traditional: true,
	    						dataType : "json",
	    						success : function(msg){
	    							var value = msg.toString();
	    							if(value=="true"){
	    								  layer.msg('删除成功',{icon:6,time:1500});
	    			    				  initTable();
	    							}else{
	    								layer.msg(msg.toString(),{icon:5,time:1500});
	    							}
	    						}
	    					});
	    				 }); 
	    				  
	    			  }
	    			  
	    		  });
	    		});
		}
		
		function goBack() {
			   document.location = "<%=request.getContextPath()%>/ptable/ptableList.do";
			}
		
		function updateSort(){
			$.ajax({
				type: "POST",
				url: "<%=request.getContextPath()%>/ptable/getTableSortNum.do",
				data: {"ppid" : pid},
				traditional: true,
				dataType : "json",
				success : function(msg){
					var value = msg.toString();
					if(value=="true"){
						layer.open({
			    			title:'播表顺序列表',
			    			type:2,
			    			area:['48%','100%'],
			    			content:'<%=request.getContextPath()%>/views/ajaxViews/material-onlysort.jsp',
			    			success: function(layero, index){
			    				var body = layer.getChildFrame('body',index);//建立父子联系
			    	            var iframeWin = window[layero.find('iframe')[0]['name']];
			    	            // console.log(arr); //得到iframe页的body内容
			    	            // console.log(body.find('input'));
			    	            var inputList = body.find('input');
			    	            $(inputList[0]).val(pid);
			    			}
			    		});
					}else{
						layer.msg('播表顺序获取失败!',{icon:5,time:1500});
					}
				}
			});
		}
		
		function broadlistmaterialadd(){
			layer.open({
    			title:'添加素材',
    			type:2,
    			area:['60%','85%'],
    			content:'<%=request.getContextPath()%>/views/ajaxViews/broadlist-material-add.jsp',
    			success: function(layero, index){
    				var body = layer.getChildFrame('body',index);//建立父子联系
    	            var iframeWin = window[layero.find('iframe')[0]['name']];
    	            // console.log(arr); //得到iframe页的body内容
    	            // console.log(body.find('input'));
    	            var inputList = body.find('input');
    	            var date=ptdate+" "+'-'+" "+ptdate;
    	            $(inputList[1]).val(tid);
    	            $(inputList[2]).val(pid);
    	            $(inputList[3]).val(itemnum);
    	            $(inputList[5]).val(date);
    	            $(inputList[6]).val(periodID);
    	            $(inputList[7]).val(periodName);
    	            
    			}
		  });
		}
		
		function testbuttonmsg(){
			layer.msg(pid+','+periodName+','+periodID+','+ptdate+','+tid,{icon:5,time:1500});
		} 
		
    </script>
<body>
<input type="hidden" id="videoView" value="">
    <div class="layui-fluid">
  <div class="layui-row layui-col-space10">
   <div  align="center">
       <blockquote class="layui-elem-quote">
播表详情页
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
			       <label class="layui-form-mid" id="ptableNameOnce">
			       
			       </label>
		        </div>
			    <div class="layui-col-md12 layui-col-space1">
					<table class="layui-table" id="table1" lay-filter="tableEvent"></table>
					<br>
					<div>
					   <button class="layui-btn" type="button"  onclick="goBack()">
						  <i class="layui-icon">&#xe65c;</i>返回
					</button>
					
					<button class="layui-btn layui-btn-norma" type="button" onclick="updateSort()">
						  <i class="layui-icon">&#xe642;</i>修改顺序
				   </button>
				   
				   <button class="layui-btn layui-btn-norma" type="button" onclick="broadlistmaterialadd()">
						  <i class="layui-icon">&#xe642;</i>添加素材
				   </button>
				   
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<label id="totalMaterial"></label>
					</div>
					<br>
					<script type="text/html" id="barDemo">
  						 <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="mediaView">预览</a>
                         <a class="layui-btn layui-btn-xs"  lay-event="copy">复制</a>
	                     <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
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