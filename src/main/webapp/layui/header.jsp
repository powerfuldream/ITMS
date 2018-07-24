<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<link href="<%=request.getContextPath()%>/layui/css/layui.css" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/layui/css/hp-layui.css" />
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/layui/css/modules/laydate/default/laydate.css" />
	<script type="text/javascript" src="<%=request.getContextPath()%>/layui/layui.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/layui/lay/modules/laydate.js"></script>
    <!-- <link href="https://cdn.bootcss.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <script src="https://cdn.bootcss.com/pace/1.0.2/pace.min.js"></script>
	<link href="https://cdn.bootcss.com/pace/1.0.2/themes/pink/pace-theme-flash.css" rel="stylesheet"> -->
    <script type="text/javascript" src="<%=request.getContextPath()%>/layui/pace/pace.min.js"></script>
	<link href="<%=request.getContextPath()%>/layui/pace/pace-theme-flash.css" rel="stylesheet">
	<link href="<%=request.getContextPath()%>/layui/pace/font-awesome.min.css" rel="stylesheet">
	<script type="text/javascript" src="<%=request.getContextPath()%>/layui/jquery-1.8.2.min.js"></script>
	<link href="<%=request.getContextPath()%>/layui/plugins/contextMenu/jquery.contextMenu.min.css" rel="stylesheet">
	<script src="<%=request.getContextPath()%>/layui/plugins/contextMenu/jquery.contextMenu.min.js"></script>
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/layui/css/fs.css?v=1.6.3" media="all"/>
	<script type="text/javascript" src="<%=request.getContextPath()%>/layui/plugins/frame/js/fsDict.js?v=1.6.3"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/layui/plugins/frame/js/fs.js?v=1.6.3"></script>
	<%-- <script type="text/javascript" src="<%=request.getContextPath()%>/layui/plugins/frame/js/main.js?v=1.6.3"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/layui/frame/js/fsMenu.js?v=1.6.3"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/layui/frame/js/fsConfig.js?v=1.6.3"></script> --%>
 <script type="text/javascript">
    function easyuiDateFormat(value) {
            var date = new Date(value);
            var year = date.getFullYear().toString();
            var month = (date.getMonth() + 1);
            var day = date.getDate().toString();
            var hour = date.getHours().toString();
            var minutes = date.getMinutes().toString();
            var seconds = date.getSeconds().toString();
            if (month < 10) {
                month = "0" + month;
            }
            if (day < 10) {
                day = "0" + day;
            }
            if (hour < 10) {
                hour = "0" + hour;
            }
            if (minutes < 10) {
                minutes = "0" + minutes;
            }
            if (seconds < 10) {
                seconds = "0" + seconds;
            }
            return year + "-" + month + "-" + day + " " + hour + ":" + minutes + ":" + seconds;
     }
 </script>
 
 	<style>
	  .my_width {
	    width: 180px;
	  }
	</style>
 
 