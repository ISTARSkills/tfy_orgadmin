<%@page import="com.viksitpro.core.dao.entities.IstarUserDAO"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="org.eclipse.jetty.websocket.api.Session"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.viksitpro.chat.services.Chat" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
for(Session sesson : Chat.sessionUserIdMap.keySet())
{
	//sending message from user beloging to students group
	if(sesson!=null && sesson.isOpen())
	{
		int user_id = Chat.sessionUserIdMap.get(sesson);
		IstarUser user = new IstarUserDAO().findById(user_id);
		%>
			<p><%=user_id %>  &nbsp;<%=user.getEmail()%></p>
		<% 
	}
}	
%>
</body>
</html>