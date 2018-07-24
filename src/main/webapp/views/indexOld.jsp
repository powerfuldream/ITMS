<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="org.south.itms.entity.User"%>
<% 
   User user = (User)session.getAttribute("user");  
   if(user != null) {
     request.setAttribute("userName", user.getUserName());
     request.setAttribute("roleName", user.getRole().getRoleName());
   }
   
   String path = request.getContextPath();
   String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<head id="Head1">
<meta charset="UTF-8">
<title>智能终端管理系统</title>
<style type="text/css">
*{border:0;margin:0;padding:0;}
body{font-family:'Microsoft Yahei','微软雅黑',Arial,'Hiragino Sans GB','宋体';font-size:14px;	}
ul{list-style:none;}
/* slides */
.slides{position:fixed;right:0;top:45%;}
.slides .slideul>li{position:relative;display:block;width:56px;height:56px;margin-bottom:10px;overflow:visible;}
}
</style>
<%@ include file="/assets/header.jsp"%>
<link rel="stylesheet" type="text/css"
	href="<%=request.getContextPath()%>/assets/index/css/default.css">
<link href="css/hover.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="css/jquery.toast.css">
<!-- <script src="js/modernizr.custom.js"></script> -->
<style type="text/css">
.rtitle {
	font-size: 18px;
	font-weight: bold;
	padding: 5px 10px;
	background: #336699;
	color: #fff;
}

.easyui-accordion ul li a {
	line-height: 24px;
	margin: 2px 0px;
	padding-left: 10px;
	padding-top: 2px;
}
</style>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/assets/js/jquery.cookie.js"></script>
<script type="text/javascript" src="js/jquery.toast.js"></script>
<script type="text/javascript">
    
        $(function() {
            initLogin();	
			initTab();   //从cookie中获取值, 打开上次的tab
        });
        
        
        function initLogin() {
           var userName = '<%=request.getAttribute("userName")%>';
           <%-- var roleName = '<%=session.getAttribute("roleName")%>'; --%>
           var roleName = '<%=request.getAttribute("roleName")%>';
           if(userName == "null") {
              //没有登录的话
              $("#showUserSpan").html("");
              $("#loginBtn").html("登录");
              $("#loginBtn").attr("href", "<%=request.getContextPath()%>/login.do");
           } else { 
        	   
        	   if(roleName == '素材初审管理员' || roleName ==  '素材终审管理员'){
        		   //alert(roleName);
        		   $("#badgePlay").remove();
        		   $("#broad").remove();
        		   //$("#materialExcep").hide();
                   //显示欢迎信息和退出按钮
                   $("#showUserSpan").html(roleName + ":" + userName);
                   /* <span class='badge badge-danger'>1</span><i class='Hui-iconfont' style='font-size:18px'>&#xe68a;</i> */
     /*               $("#msg").html("<li id='Hui-msg'><a href='#' title='消息'><span class='badge badge-danger'>1</span><i class='Hui-iconfont' style='font-size:18px'>&#xe68a;</i></a></li>");
      */              
                   $("#loginBtn").html("退出");
                   $("#loginBtn").attr("href", "<%=request.getContextPath()%>/login/reqLogout.do");
                                      
        		   if(roleName == '素材初审管理员'){
        			   var excepNum = '<%=session.getAttribute("excepNum")%>';
        			   if(excepNum == 0){
            			   $("#materialExcep").hide();
            		   }
        			   timeFirstCheck();
        		   }else{
        			   var checkNumSec = '<%=session.getAttribute("checkNumSec")%>';
        			   $("#checkNumber").text(checkNumSec);
        			   timeFinalCheck();
        		   }
        	   }else if(roleName == '播表初审管理员' || roleName ==  '播表终审管理员') {
        		   //alert(roleName);
        		   $("#badge").remove();
        		   $("#broad").remove();
        		   $("#materialExcep").remove();
                   //显示欢迎信息和退出按钮
                   $("#showUserSpan").html(roleName + ":" + userName);      
                   $("#loginBtn").html("退出");
                   $("#loginBtn").attr("href", "<%=request.getContextPath()%>/login/reqLogout.do");
                                      
        		   if(roleName == '播表初审管理员'){
        			   //timeFirstPlay();
        		   }else{
        			   var playNumSec = '<%=session.getAttribute("playNumSec")%>';
        			   $("#playNumber").text(checkNumSec);
        			   //timeFinalPlay();
        		   }
        	   }else if(roleName == '排播管理员'){
        		   $("#badge").remove();
        		   $("#badgePlay").remove();
        		   $("#materialExcep").remove();
        		   var broadNum = '<%=session.getAttribute("broadNum")%>';
        		   if(broadNum == 0){
        			   $("#broad").hide();
        		   }else{
        			   $("#broadNumber").text(broadNum);
        		   }
        		 //显示欢迎信息和退出按钮
                   $("#showUserSpan").html(roleName + ":" + userName);      
                   $("#loginBtn").html("退出");
                   $("#loginBtn").attr("href", "<%=request.getContextPath()%>/login/reqLogout.do");
                   
                   timeBroadCheck();
        	   }else {
        		   $("#badge").remove();
        		   $("#badgePlay").remove();
        		   $("#broad").remove();
        		   $("#materialExcep").remove();
                   //显示欢迎信息和退出按钮
                   $("#showUserSpan").html(roleName + ":" + userName);
                   /* <span class='badge badge-danger'>1</span><i class='Hui-iconfont' style='font-size:18px'>&#xe68a;</i> */
     /*               $("#msg").html("<li id='Hui-msg'><a href='#' title='消息'><span class='badge badge-danger'>1</span><i class='Hui-iconfont' style='font-size:18px'>&#xe68a;</i></a></li>");
      */              
                   $("#loginBtn").html("退出");
                   $("#loginBtn").attr("href", "<%=request.getContextPath()%>/login/reqLogout.do");
        	   }
           }
        }
        
        function timeBroadCheck(){
        	$.ajax({
        		type: "POST",
        		url: "<%=request.getContextPath()%>/material/notifyBroad.do",
        		dataType: "json",
        		success: function(date){
        			var value = date.toString();
        			var num = '<%=session.getAttribute("broadNum")%>';
        			//alert(value);
        			var oldnum = parseInt(num);
        			var margin = parseInt(value);
        			var nownum = margin + oldnum;
        			if(margin != 0) {
        				messageBroad()
        				showBroad(margin);
        			}
        		}
        	});
        	
        	setTimeout("timeBroadCheck()",20000);
        }
        
        function showBroad(valueBroad){
        	$("#broadNumber").text(valueBroad);
        	$("#broad").show();
        }
        
        function timeFirstCheck() {
        	materialCheck();
        	materialExcep();
        	setTimeout("timeFirstCheck()",25000);
        }
        
        function materialCheck(){
        	$.ajax({
        		type: "POST",
        		url: "<%=request.getContextPath()%>/material/notifyFile.do",
        		dataType: "json",
        		success: function(date){
        			var value = date.toString();
        			var num = '<%=session.getAttribute("checkNum")%>';
        			//alert(value);
        			var oldnum = parseInt(num);
        			var margin = parseInt(value);
        			var nownum = margin + oldnum;
        			if(margin != 0) {
        				messageFirst();
        				showDom(margin);
        			}
        		}
        	});
        }
        function materialExcep(){
        	$.ajax({
        		type: "POST",
        		url: "<%=request.getContextPath()%>/material/notifyExcep.do",
        		dataType: "json",
        		success: function(date){
        			var value = date.toString();
        			var num = '<%=session.getAttribute("checkNum")%>';
        			//alert(value);
        			var oldnum = parseInt(num);
        			var margin = parseInt(value);
        			var nownum = margin + oldnum;
        			if(margin != 0) {
        				messageExcep();
        				showExcep(margin);
        			}
        		}
        	});
        }
        
        function showDom(value) {
        	$("#checkNumber").text(value);
        	$("#badge").show();
        }
        function showExcep(excep){
        	$("#excepNumber").text(excep);
        	$("#materialExcep").show();
        }
        
        function messageFirst() {
            var code = $("#codeIdFirst").val();
//            alert(code);
            eval(code);
        }
        
        function messageExcep() {
            var code = $("#materialExcep").val();
//            alert(code);
            eval(code);
        }
        
        function messageBroad(){
        	var code = $("#broadCheck").val();
//          alert(code);
            eval(code);
        }
        
        function messageSecond() {
            var code = $("#codeIdSecond").val();
//            alert(code);
            eval(code);
        }
        
        function timeFinalCheck() {
        	$.ajax({
        		type: "POST",
        		url: "<%=request.getContextPath()%>/file/notifyFileSec.do",
        		dataType: "json",
        		success: function(date){
        			var value = date.toString();
        			var num = '<%=session.getAttribute("checkNumSec")%>';
        			//alert(value);
        			var oldnum = parseInt(num);
        			var margin = parseInt(value);
        			var nownum = margin + oldnum;
        			if(margin != 0) {
        				messageSecond();
        				showDom(margin);
        			}
        		}
        	});
        	
        	setTimeout("timeFinalCheck()",10000);
        }
        
        
       function addTab(title, url) {
			if ($('#tabs').tabs('exists', title)){
				$('#tabs').tabs('select', title);
				refreshTab({tabTitle:title,url:url});  
			} else {
				var content = '<iframe scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';
				$('#tabs').tabs('add',{
					title:title,
					content:content,
					closable:true
				});
			}
			
		}
		
		
	   function refreshTab(cfg){  
          var refresh_tab = cfg.tabTitle ? $('#tabs').tabs('getTab',cfg.tabTitle) : $('#tabs').tabs('getSelected');  
          if(refresh_tab && refresh_tab.find('iframe').length > 0) {  
	          var _refresh_ifram = refresh_tab.find('iframe')[0];  
	          var refresh_url = cfg.url?cfg.url:_refresh_ifram.src;  
	          _refresh_ifram.contentWindow.location.href=refresh_url;  
          }  
       } 
		
	
	   window.onunload = function() { //浏览器刷新，让tab可以不关闭
	      var tabUrl = null;
	      var tabTitle = null;
	      //尝试获取已选中的tab
	      var tab = $('#tabs').tabs('getSelected');
	      if(tab && tab.find('iframe').length > 0) {  
	         tabUrl = tab.find('iframe')[0].src;
	         tabTitle = tab.panel('options').tab.text();
	      } 
	      //保存到cookie
	      $.cookie('tabUrl', tabUrl); 
	      $.cookie('tabTitle', tabTitle); 
	   } 
	   
	   
	   function initTab() { //从cookie中获取值, 打开上次的tab
	      var tabUrl = $.cookie('tabUrl'); 
	      var tabTitle = $.cookie('tabTitle'); 
	      if(tabUrl == undefined) return;
	       
	      //console.log(tabUrl + " " + tabTitle);
	      
	      if(tabUrl != "null" && tabTitle != "null") {
	        addTab(tabTitle, tabUrl);
	      }
	   }
	   
	   function check(){
//		   $("#badge").remove();
		   $("#badge").hide();
//		   alert(666);
		   addTab('素材审核', '<%=request.getContextPath()%>/material/checkList.do');
	   }
	   
	   function checkExcep(){
//		   $("#badge").remove();
		   $("#materialExcep").hide();
//		   alert(666);
		   addTab('素材敏感', '<%=request.getContextPath()%>/ptable/checkExcepList.do');
	   }
	   
	   function checkPlay(){
//		   $("#badge").remove();
		   $("#badgePlay").hide();
//		   alert(666);
		   addTab('播表审核', '<%=request.getContextPath()%>/ptable/ptableCheckList.do');
	   }
	   
	   function checkBroad(){
		   $("#broad").hide();
		   addTab('排播有误', '<%=request.getContextPath()%>/ptable/broadCheckList.do');
	   }
	

    </script>

</head>
<body class="easyui-layout" style="overflow-y: hidden" scroll="no">

	<noscript>
		<div>
			style="position: absolute; z-index: 100000; height: 2046px; top: 0px; left: 0px; width: 100%; background: white; text-align: center;">
			<img
				src="<%=request.getContextPath()%>/assets/index/images/noscript.gif"
				alt='抱歉，请开启脚本支持！' />
		</div>
	</noscript>
	<div region="north" split="true" border="false"
		style="overflow: hidden; height: 40px; padding: 5px;
        background: url(<%=request.getContextPath()%>/assets/index/images/layout-browser-hd-bg.gif) #7f99be repeat-x center 50%;
        line-height: 20px;color: #fff; font-family: Verdana, 微软雅黑,黑体">
		<span style="float: right; padding-right: 20px;" class="head"><span
			id="showUserSpan">欢迎系统管理员: admin</span>&nbsp;<a
			href="javascript:void(0)" id="loginBtn" style="margin-left: 5px;">退出登录</a></span>

		<span style="padding-left: 10px; font-size: 16px;"><img
			src="<%=request.getContextPath()%>/assets/index/images/blocks.gif"
			width="20" height="20" align="absmiddle" /> 智能终端管理系统</span>
	</div>
	<!--     <div>
        <li id="Hui-msg"> <a href="#" title="消息" id="msg"><span class="badge badge-danger">1</span><i class="Hui-iconfont" style="font-size:18px">&#xe68a;</i></a> </li>
    </div> -->
	<div region="south" split="true"
		style="height: 30px; background: #D2E0F2; line-height: 20px; color: #FFFFFF; font-family: Verdana, 微软雅黑, 黑体">
		<div class="footer">Copyright © 2017 广东南方新视界传媒科技有限公司 All Rights
			Reserved</div>
	</div>
	<div region="west" split="true" title="导航菜单" style="width: 180px;"
		id="west">
		<div class="easyui-accordion" fit="true" border="false">
			<!--  导航内容 -->
			<div title="系统管理">
				<ul>
					<li><div>
							<a href="javascript:void(0)"
								onclick="addTab('用户管理', '<%=request.getContextPath()%>/system/user/userList.do');">用户管理</a>
						</div></li>
					<li><div>
							<a href="javascript:void(0)"
								onclick="addTab('角色管理', '<%=request.getContextPath()%>/system/role/roleList.do');">角色管理</a>
						</div></li>
					<li><div>
							<a href="javascript:void(0)"
								onclick="addTab('资源管理', '<%=request.getContextPath()%>/system/resource/resourceList.do');">资源管理</a>
						</div></li>
					<li><div>
							<a href="javascript:void(0)"
								onclick="addTab('播放端权限配置', '<%=request.getContextPath()%>/system/goTerminalPowerJsp.do');">播放端权限配置</a>
						</div></li>
				</ul>
			</div>
			<div title="播放管理">
				<ul>
					<li><div>
							<a href="javascript:void(0)"
								onclick="addTab('播放端管理', '<%=request.getContextPath()%>/terminal/center.do');">播放端管理</a>
						</div></li>
					<li><div>
							<a href="javascript:void(0)"
								onclick="addTab('播表管理', '<%=request.getContextPath()%>/ptable/ptableList.do');">播表管理</a>
						</div></li>
					<li><div>
							<a href="javascript:void(0)"
								onclick="addTab('终端连接', '<%=request.getContextPath()%>/playerController/playCenter.do');">终端连接</a>
						</div></li>
					<li><div>
							<a href="javascript:void(0)"
								onclick="addTab('时段管理', '<%=request.getContextPath()%>/period/periodList.do');">时段管理</a>
						</div></li>	
					<li><div>
							<a href="javascript:void(0)"
								onclick="addTab('排播管理', '<%=request.getContextPath()%>/material/broadcastList.do');">排播管理</a>
						</div></li>						
				</ul>
			</div>
			<div title="素材管理">
				<ul>
					<li><div>
							<a href="javascript:void(0)" id="fileManage"
								onclick="addTab('素材管理', '<%=request.getContextPath()%>/material/materialList.do');">素材管理</a>
						</div></li>
					<li><div>
							<a href="javascript:void(0)" id="fileTranslate" onclick="addTab('传输文件', '<%=request.getContextPath()%>/file/transferFileList.do');">传输文件</a>
						</div></li>
				</ul>
			</div>
			<div title="日志管理">
                    <ul>
                        <li><div><a href="javascript:void(0)" onclick="addTab('系统日志', '<%=request.getContextPath()%>/logController/sysLogList.do');">系统日志</a></div></li>
                        <li><div><a href="javascript:void(0)" onclick="addTab('传输日志', '<%=request.getContextPath()%>/logController/transferLogList.do');">传输日志</a></div></li>
                        <li><div><a href="javascript:void(0)" onclick="addTab('心跳日志', '<%=request.getContextPath()%>/logController/heartbeatLogList.do');">心跳日志</a></div></li>
                        <li><div><a href="javascript:void(0)" onclick="addTab('播放日志', '<%=request.getContextPath()%>/logController/playLogList.do');">播放日志</a></div></li>
                        <li><div><a href="javascript:void(0)" onclick="addTab('错误日志', '<%=request.getContextPath()%>/logController/errorLogList.do');">错误日志</a></div></li>
                    </ul>
             </div>

		</div>
	</div>
	<div id="mainPanle" region="center"
		style="background: #eee; overflow-y: hidden">
		<div id="tabs" class="easyui-tabs" fit="true" border="false">
			<div title="欢迎使用" style="padding: 20px; overflow: hidden;" id="home">

				<h1>欢迎使用智能终端管理系统</h1>

			</div>
		</div>
		<div id='adf'></div>
		<!-- ui-icon-mail-closed  ui-icon-comment -->
		<div id="badge" class="cndns-right">
			<div class="cndns-right-meau meau-contact">
				<a href="javascript:void(0)" onclick="check()"
					class="cndns-right-btn"> <span class="demo-icon">&#xe68a;</span>
		            <sup id="checkNumber"><%=session.getAttribute("checkNum")%></sup>
					<p>
						素材<br/> 审核
					</p>
				</a>
			</div>
		</div>
		
        <div id="materialExcep" class="slides">
			<div class="cndns-right-meau meau-contact">
				<a href="javascript:void(0)" onclick="checkExcep()"
					class="cndns-right-btn"> <span class="demo-icon">&#xe68a;</span>
		            <sup id="excepNumber"><%=session.getAttribute("excepNum")%></sup>
					<p>
						敏感<br/>素材
					</p>
				</a>
			</div>
        </div>
    
		
		<div id="badgePlay" class="cndns-right">
			<div class="cndns-right-meau meau-contact">
				<a href="javascript:void(0)" onclick="checkPlay()"
					class="cndns-right-btn"> <span class="demo-icon">&#xe68a;</span>
		            <sup id="playNumber"><%=session.getAttribute("playNum")%></sup>
					<p>
						播表<br/> 审核
					</p>
				</a>
			</div>
		</div>
		<div id="broad" class="cndns-right">
			<div class="cndns-right-meau meau-contact">
				<a href="javascript:void(0)" onclick="checkBroad()"
					class="cndns-right-btn"> <span class="demo-icon">&#xe68a;</span>
		            <sup id="broadNumber"><%=session.getAttribute("broadNum")%></sup>
					<p>
						排播<br/> 有误
					</p>
				</a>
			</div>
		</div>
	</div>
	<input type="hidden" id="codeIdFirst"
		value="$.toast({
                heading: '审核提醒',
                textAlign : 'left',
                hideAfter : 8000,
                showHideTransition : 'slide',
                text: '有新素材上传成功了，请按时审核',
                position : 'top-right'
            })">
            
     <input type="hidden" id="codeIdSecond"
		value="$.toast({
                heading: '审核提醒',
                textAlign : 'left',
                hideAfter : 8000,
                showHideTransition : 'slide',
                text: '有素材初审通过了，请按时审核',
                position : 'top-right'
            })">
            
	<input type="hidden" id="playIdFirst"
		value="$.toast({
                heading: '审核提醒',
                textAlign : 'left',
                hideAfter : 8000,
                showHideTransition : 'slide',
                text: '有新新播表生成了，请按时审核',
                position : 'top-right'
            })">
            
     <input type="hidden" id="playIdSecond"
		value="$.toast({
                heading: '审核提醒',
                textAlign : 'left',
                hideAfter : 8000,
                showHideTransition : 'slide',
                text: '有播表初审通过，请及时审核',
                position : 'top-right'
            })">
            
     <input type="hidden" id="broadCheck"
		value="$.toast({
                heading: '排播异常提醒',
                textAlign : 'left',
                hideAfter : 8000,
                showHideTransition : 'slide',
                text: '有播表初审异常，请及时检查排播信息',
                position : 'top-right'
            })">
            
      <input type="hidden" id="materialExcep"
		value="$.toast({
                heading: '素材敏感提醒',
                textAlign : 'left',
                hideAfter : 8000,
                showHideTransition : 'slide',
                text: '有播表素材含敏感信息，请及时检查素材信息',
                position : 'top-right'
            })">

</body>
</html>