<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 
 <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/assets/easyui/themes/default/easyui.css">
 <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/assets/easyui/themes/icon.css">
 <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/assets/zTree/css/zTreeStyle/zTreeStyle.css">
 <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/assets/font-awesome-4.7.0/css/font-awesome.min.css">
 <script type="text/javascript" src="<%=request.getContextPath()%>/assets/js/jquery-3.2.1.min.js"></script>
 <script type="text/javascript" src="<%=request.getContextPath()%>/assets/easyui/jquery.easyui.min.js"></script>
 <script type="text/javascript" src="<%=request.getContextPath()%>/assets/easyui/locale/easyui-lang-zh_CN.js"></script>
 <script type="text/javascript" src="<%=request.getContextPath()%>/assets/zTree/js/jquery.ztree.all.min.js"></script> 
 <script type="text/javascript" src="<%=request.getContextPath()%>/assets/My97DatePicker/WdatePicker.js"></script> 
 <script type="text/javascript" src="<%=request.getContextPath()%>/assets/jquery-validation-1.14.0/dist/jquery.validate.min.js"></script>
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
 