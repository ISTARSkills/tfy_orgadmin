<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%
		String url = request.getRequestURL().toString();
		String baseURL = url.substring(0, url.length() - request.getRequestURI().length()) + request.getContextPath() + "/";
		
		String user_id  = "";
		if(request.getParameterMap().containsKey("user_id")){
			
			 user_id = request.getParameter("user_id");
		}
%>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

</head>
<body>
<iframe src="http://api.talentify.in:8080/cpreports/report.jsp?user_id=<%=user_id%>" style="width:100%;  height:100%; min-height: 1000px;   border-width: inherit; border-style: hidden;">
                      </iframe>
</body>
</html>