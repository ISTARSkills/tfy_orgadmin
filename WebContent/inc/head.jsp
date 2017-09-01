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
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="shortcut icon" href="<%=basePath%>assets/img/user_images/new_talentify_logo.png" />
<title>Talentify | Admin-Portal</title>
<link href="<%=basePath%>assets/css/bootstrap.css" rel="stylesheet">
<link href="<%=basePath%>assets/css/bootstrap-glyphicons.css" rel="stylesheet">
<link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
 <link href="<%=basePath%>assets/css/plugins/jsTree/style.css" rel="stylesheet" type="text/css" />

  <link href="<%=basePath%>assets/css/<%=roleDir%>.css" rel="stylesheet" type="text/css" />
   <link href="<%=basePath%>assets/css/bootstrap-datepicker3.min.css" rel="stylesheet" type="text/css" />
 
</head>