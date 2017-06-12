<%@page import="java.io.IOException"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.util.Properties"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%
	String path = request.getContextPath();
	String basePath = "http://cdn.talentify.in/";
	

	try {
		Properties properties = new Properties();
		String propertyFileName = "app.properties";
		InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
		if (inputStream != null) {
			properties.load(inputStream);
			basePath = properties.getProperty("cdn_path");
		}
	} catch (IOException e) {
		e.printStackTrace();
	}
	
	
%><html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="shortcut icon" href="<%=basePath%>img/user_images/new_talentify_logo.png" />
<title>Talentify | Admin-Portal</title>
<link href="<%=basePath %>assets/css/bootstrap.min.css" rel="stylesheet">
<link href="<%=basePath%>assets/css/timepicki.css" rel="stylesheet">
<link href="<%=basePath %>assets/css/plugins/dataTables/datatables.min.css" rel="stylesheet">

    <link href="<%=basePath %>assets/css/plugins/select2/select2.min.css" rel="stylesheet">

<link href="<%=basePath %>assets/css/plugins/fullcalendar/fullcalendar.min.css" rel="stylesheet">
<link href="<%=basePath %>assets/css/plugins/fullcalendar/fullcalendar.print.css" rel='stylesheet' media='print'>

<link href="<%=basePath %>assets/css/plugins/datapicker/datepicker3.css" rel="stylesheet">
<link href="<%=basePath %>assets/css/plugins/clockpicker/clockpicker.css" rel="stylesheet">
    <link href="https://swisnl.github.io/jQuery-contextMenu/dist/jquery.contextMenu.css" rel="stylesheet" type="text/css" />

<link href="<%=basePath %>assets/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="<%=basePath %>assets/css/animate.css" rel="stylesheet">
<link href="<%=basePath %>assets/css/style.css" rel="stylesheet">
 <link href="<%=basePath %>assets/css/plugins/toastr/toastr.min.css" rel="stylesheet">

<link href="<%=basePath%>assets/css/plugins/chosen/bootstrap-chosen.css" rel="stylesheet">
<link href="<%=basePath%>assets/css/plugins/bootstrap-tagsinput/bootstrap-tagsinput.css" rel="stylesheet">
<link rel="stylesheet" href="<%=basePath%>assets/css/jquery.rateyo.min.css">
<link href="<%=basePath%>assets/css/plugins/sweetalert/sweetalert.css" rel="stylesheet">

<link href="<%=basePath%>assets/css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">
<link href="<%=basePath%>assets/css/plugins/steps/jquery.steps.css" rel="stylesheet">
 <link href="<%=basePath%>assets/css/plugins/bootstrap-tagsinput/bootstrap-tagsinput.css" rel="stylesheet">


</head>