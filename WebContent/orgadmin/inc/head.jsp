<!DOCTYPE html>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%><html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="shortcut icon" href="<%=basePath%>img/user_images/new_talentify_logo.png" />
<title>Talentify | Admin-Portal</title>
<link href="<%=basePath %>css/bootstrap.min.css" rel="stylesheet">
<link href="<%=basePath %>css/plugins/dataTables/datatables.min.css" rel="stylesheet">

    <link href="<%=basePath %>css/plugins/select2/select2.min.css" rel="stylesheet">

<link href="<%=basePath %>css/plugins/fullcalendar/fullcalendar.min.css" rel="stylesheet">
<link href="<%=basePath %>css/plugins/fullcalendar/fullcalendar.print.css" rel='stylesheet' media='print'>

<link href="<%=basePath %>css/plugins/datapicker/datepicker3.css" rel="stylesheet">
<link href="<%=basePath %>css/plugins/clockpicker/clockpicker.css" rel="stylesheet">
    <link href="https://swisnl.github.io/jQuery-contextMenu/dist/jquery.contextMenu.css" rel="stylesheet" type="text/css" />

<link href="<%=basePath %>font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="<%=basePath %>css/animate.css" rel="stylesheet">
<link href="<%=basePath %>css/style.css" rel="stylesheet">
 <link href="<%=basePath %>css/plugins/toastr/toastr.min.css" rel="stylesheet">

<link href="<%=basePath%>css/plugins/chosen/bootstrap-chosen.css" rel="stylesheet">
<link href="<%=basePath%>css/plugins/bootstrap-tagsinput/bootstrap-tagsinput.css" rel="stylesheet">
<link rel="stylesheet" href="<%=basePath%>css/jquery.rateyo.min.css">
<link href="<%=basePath%>css/plugins/sweetalert/sweetalert.css" rel="stylesheet">
<link href="<%=basePath%>css/wickedpicker.css" rel="stylesheet">
<link href="<%=basePath%>css/wickedpicker.min.css" rel="stylesheet">
<link href="<%=basePath%>css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">
<link href="<%=basePath%>css/plugins/steps/jquery.steps.css" rel="stylesheet">
</head>