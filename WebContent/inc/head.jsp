<%@page import="java.io.IOException"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.util.Properties"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%><!DOCTYPE html>
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
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="/logo.png" type="image/png"  rel="shortcut icon">
<title>Talentify | Admin-Portal</title>
<link href="<%=basePath%>assets/css/bootstrap.min.css" rel="stylesheet">
<link href="<%=basePath%>assets/css/plugins/dataTables/datatables.min.css"
	rel="stylesheet">

<link href="<%=basePath%>assets/css/plugins/select2/select2.min.css"
	rel="stylesheet">

<link href="<%=basePath%>assets/css/plugins/fullcalendar/fullcalendar.min.css"
	rel="stylesheet">
<link
	href="<%=basePath%>assets/css/plugins/fullcalendar/fullcalendar.print.css"
	rel='stylesheet' media='print'>

<link href="<%=basePath%>assets/css/plugins/datapicker/datepicker3.css"
	rel="stylesheet">
<link href="<%=basePath%>assets/css/plugins/clockpicker/clockpicker.css"
	rel="stylesheet">
 <link href="<%=basePath%>assets/css/jquery.contextMenu.css" rel="stylesheet" type="text/css" />
<link href="http://netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap-glyphicons.css" rel="stylesheet">
<link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">

<link href="<%=basePath%>assets/css/animate.css" rel="stylesheet">
<link href="<%=basePath%>assets/css/style.css" rel="stylesheet">
<link href="<%=basePath%>assets/css/plugins/toastr/toastr.min.css"
	rel="stylesheet">

<link href="<%=basePath%>assets/css/plugins/chosen/bootstrap-chosen.css"
	rel="stylesheet">
<link
	href="<%=basePath%>assets/css/plugins/bootstrap-tagsinput/bootstrap-tagsinput.css"
	rel="stylesheet">
<link rel="stylesheet" href="<%=basePath%>assets/css/jquery.rateyo.min.css">
<link href="<%=basePath%>assets/css/plugins/sweetalert/sweetalert.css" rel="stylesheet">
<link href="<%=basePath%>assets/css/wickedpicker.css" rel="stylesheet">
<link href="<%=basePath%>assets/css/wickedpicker.min.css" rel="stylesheet">
<link href="<%=basePath%>assets/css/timepicki.css" rel="stylesheet">
 <link href="<%=basePath%>assets/css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">
<link href="<%=basePath%>assets/css/plugins/steps/jquery.steps.css" rel="stylesheet">
<link href="<%=basePath%>assets/css/plugins/bootstrap-tagsinput/bootstrap-tagsinput.css" rel="stylesheet">
<link href="<%=basePath%>assets/css/plugins/ionRangeSlider/ion.rangeSlider.css" rel="stylesheet">
<link href="<%=basePath%>assets/css/plugins/iCheck/custom.css" rel="stylesheet">
<link href="<%=basePath%>assets/css/switchery.min.css" rel="stylesheet">
<link rel="stylesheet"
		href="//static.jstree.com/3.3.4/assets/dist/themes/default/style.min.css" />
    <link href="<%=basePath%>assets/css/plugins/ionRangeSlider/ion.rangeSlider.skinFlat.css" rel="stylesheet">
</head>