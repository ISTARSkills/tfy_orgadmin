<%@page import="com.viksitpro.core.utilities.AppProperies"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%><!DOCTYPE html>
<%
	String path = request.getContextPath();
	String basePath = "http://cdn.talentify.in/";

	try {
		basePath = AppProperies.getProperty("cdn_path");
	} catch (Exception e) {
		e.printStackTrace();
	}

	String loggedInRole = (String) request.getSession().getAttribute("logged_in_role");
	String roleDir = loggedInRole.toLowerCase();
	if (loggedInRole.toLowerCase().equalsIgnoreCase("trainer")) {
		roleDir = "student";
	}
	if (loggedInRole.toLowerCase().equalsIgnoreCase("org_admin")) {
		roleDir = "orgadmin";
	}
%><html>
<head>
<base href="/">
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="shortcut icon"
	href="<%=basePath%>assets/img/user_images/new_talentify_logo.png" />
<title>Talentify | Admin-Portal</title>
<link href="<%=basePath%>assets/css/bootstrap.css" rel="stylesheet">
<link href="<%=basePath%>assets/css/bootstrap-glyphicons.css"
	rel="stylesheet">
<link
	href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"
	rel="stylesheet">
<link href="<%=basePath%>assets/css/plugins/jsTree/style.css"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css"
	href="<%=basePath%>assets/css/daterangepicker.css" />
<link
	href="<%=basePath%>assets/css/plugins/fullcalendar/fullcalendar.min.css"
	rel="stylesheet">
<link href="<%=basePath%>assets/css/<%=roleDir%>.css" rel="stylesheet"
	type="text/css" />
<link rel="stylesheet"
	href="<%=basePath%>assets/css/jquery.dropdown.css">
<link href="<%=basePath%>assets/css/plugins/sweetalert/sweetalert.css"
	rel="stylesheet">

</head>