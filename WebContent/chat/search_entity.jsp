<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="in.orgadmin.utils.report.CustomReport"%>
<%@page import="in.orgadmin.utils.report.CustomReportUtils"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
int reportID = Integer.parseInt(request.getParameter("report_id"));
int userId = Integer.parseInt(request.getParameter("user_id"));
CustomReportUtils repUtils = new CustomReportUtils();
if(reportID==30 || reportID==36)
{ //search admin
	String searchTerm = request.getParameter("search_term");	
	CustomReport report = repUtils.getReport(reportID);
	String sql = report.getSql().replaceAll(":user_id", userId+"").replace(":search_term", searchTerm.toLowerCase());
	DBUTILS util = new DBUTILS();
	List<HashMap<String, Object>> orgList = util.executeQuery(sql);
								 
	for(HashMap<String, Object> org  : orgList){
		String image="N.png";
		if(org.get("role_name")!=null)
		{										
			image = "/video/android_images/"+org.get("role_name").toString().substring(0, 1)+".png";
		}
		else
		{
			image = "/video/android_images/"+org.get("role_name").toString().substring(0, 1)+".png";
		}
		
		%>
		<div class="chat-user" id="entity_user_<%=org.get("id")%>" data-user_id="<%=org.get("id") %>" 
		data-user_type="ORG" data-user_name="<%=org.get("name")%>" data-user_image="<%=image%>">
                <img class="chat-avatar" src="http://api.talentify.in<%=image%>" alt="" style="width:36px ; height:36px">
                <div class="chat-user-name">
                    <a href="#"><%=org.get("name")%></a>
                    <span class="label label-primary" style="float:right" id='entity_user_<%=org.get("id") %>_chat_count'></span>                                                              
                </div>
            </div>
		<%
		} 
}
else if(reportID==31 || reportID==37)
{ //search groups
	String searchTerm = request.getParameter("search_term");
	CustomReport report = repUtils.getReport(reportID);
	String sql = report.getSql().replaceAll(":user_id", userId+"").replace(":search_term", searchTerm.toLowerCase());
	DBUTILS util = new DBUTILS();
	List<HashMap<String, Object>> groupList = util.executeQuery(sql);
	for(HashMap<String, Object> group  : groupList){
		String image="N.png";
		if(group.get("image")!=null)
		{
			image = "/"+group.get("image").toString();
		}
		else
		{
			image = "/video/android_images/"+group.get("name").toString().substring(0, 1)+".png";
		}	
		
		%>
		<div class="chat-user" id="entity_bg_group_<%=group.get("id") %>" data-user_id="<%=group.get("id") %>" data-user_type="BG_GROUP" data-user_name="<%=group.get("name")%>" data-user_image="<%=image%>">
                <img class="chat-avatar" src="http://api.talentify.in<%=image%>" alt="" style="width:36px ; height:36px">
                <div class="chat-user-name">
                    <a href="#"><%=group.get("name")%></a>
                    <%
                    if(group.get("chat_count")!=null && (int)group.get("chat_count")!=0)
                    {
                    %>
                    <span class="label label-primary" style="float:right" id='entity_bg_group_<%=group.get("id") %>_chat_count'><%=group.get("chat_count") %></span> 
                    <%
                    }
                    %>
                </div>
            </div>
		<%
		}
}
else if(reportID==32 || reportID==38)
{ //search user
	String searchTerm = request.getParameter("search_term");
	CustomReport report = repUtils.getReport(reportID);
	String sql = report.getSql().replaceAll(":user_id", userId+"").replace(":search_term", searchTerm.toLowerCase());
	DBUTILS util = new DBUTILS();
	List<HashMap<String, Object>> userList = util.executeQuery(sql);
	for(HashMap<String, Object> users  : userList){
		String image="N.png";
		String name=users.get("email").toString();
		if(users.get("profile_image")!=null)
		{
			image = "/"+users.get("profile_image").toString();
		}
		else
		{
			if(users.get("first_name")!=null)
			{
				image = "/video/android_images/"+users.get("first_name").toString().substring(0, 1)+".png";
				name = users.get("first_name").toString();
			}
			else
			{
				image = "/video/android_images/"+users.get("email").toString().substring(0, 1)+".png";
			}											
		}										
		%>
		<div class="chat-user" id="entity_user_<%=users.get("id")%>" data-user_id="<%=users.get("id") %>" data-user_type="USER" data-user_name="<%=name%>" data-user_image="<%=image%>" >
                <img class="chat-avatar" src="http://api.talentify.in<%=image%>" alt="" style="width:36px ; height:36px">
                <div class="chat-user-name">
                    <a href="#"><%=name%></a>
                     <span class="label label-primary" style="float:right" id='entity_user_<%=users.get("id") %>_chat_count'></span> 
                </div>
            </div>
		<%
		}
}
else if(reportID==27 || reportID==33)
{
	
	CustomReport report = repUtils.getReport(reportID);
	String sql = report.getSql().replaceAll(":user_id", userId+"");
	DBUTILS util = new DBUTILS();
	List<HashMap<String, Object>> orgList = util.executeQuery(sql);
								 
	for(HashMap<String, Object> org  : orgList){
		String image="N.png";
		if(org.get("role_name")!=null)
		{										
			image = "/video/android_images/"+org.get("role_name").toString().substring(0, 1)+".png";
		}
		else
		{
			image = "/video/android_images/"+org.get("role_name").toString().substring(0, 1)+".png";
		}
		
		%>
		<div class="chat-user" id="entity_user_<%=org.get("id")%>" data-user_id="<%=org.get("id") %>" 
		data-user_type="ORG" data-user_name="<%=org.get("name")%>" data-user_image="<%=image%>">
                <img class="chat-avatar" src="http://api.talentify.in<%=image%>" alt="" style="width:36px ; height:36px">
                <div class="chat-user-name">
                    <a href="#"><%=org.get("name")%></a>
                    <span class="label label-primary" style="float:right" id='entity_user_<%=org.get("id") %>_chat_count'><%=org.get("chat_count")%></span>                                            
                </div>
            </div>
		<%
		} 
}
else if(reportID==28 || reportID==34)
{
	CustomReport report = repUtils.getReport(reportID);
	String sql = report.getSql().replaceAll(":user_id", userId+"");
	DBUTILS util = new DBUTILS();
	List<HashMap<String, Object>> groupList = util.executeQuery(sql);
	for(HashMap<String, Object> group  : groupList){
		String image="N.png";
		if(group.get("image")!=null)
		{
			image = "/"+group.get("image").toString();
		}
		else
		{
			image = "/video/android_images/"+group.get("name").toString().substring(0, 1)+".png";
		}	
		
		%>
		<div class="chat-user" id="entity_bg_group_<%=group.get("id") %>" data-user_id="<%=group.get("id") %>" data-user_type="BG_GROUP" data-user_name="<%=group.get("name")%>" data-user_image="<%=image%>">
                <img class="chat-avatar" src="http://api.talentify.in<%=image%>" alt="" style="width:36px ; height:36px">
                <div class="chat-user-name">
                    <a href="#"><%=group.get("name")%>
                    <%if(group.get("chat_count")!=null && (int)group.get("chat_count")!=0){ %>
                     <span class="label label-primary" style="float:right"><%=group.get("chat_count")%></span>
                     <%} %>
                     </a>
                </div>
            </div>
		<%
		}
}
else if(reportID==29 || reportID==35)
{
	CustomReport report = repUtils.getReport(reportID);
	String sql = report.getSql().replaceAll(":user_id", userId+"");
	DBUTILS util = new DBUTILS();
	List<HashMap<String, Object>> userList = util.executeQuery(sql);
	for(HashMap<String, Object> users  : userList){
		String image="N.png";
		String name=users.get("email").toString();
		if(users.get("profile_image")!=null)
		{
			image = "/"+users.get("profile_image").toString();
		}
		else
		{
			if(users.get("first_name")!=null)
			{
				image = "/video/android_images/"+users.get("first_name").toString().substring(0, 1)+".png";
				name = users.get("first_name").toString();
			}
			else
			{
				image = "/video/android_images/"+users.get("email").toString().substring(0, 1)+".png";
			}											
		}										
		%>
		<div class="chat-user" id="entity_user_<%=users.get("id")%>" data-user_id="<%=users.get("id") %>" data-user_type="USER" data-user_name="<%=name%>" data-user_image="<%=image%>" >
                <img class="chat-avatar" src="http://api.talentify.in<%=image%>" alt="" style="width:36px ; height:36px">
                <div class="chat-user-name">
                    <a href="#"><%=name%>
                    <span class="label label-primary" style="float:right" id='entity_user_<%=users.get("id") %>_chat_count'><%=users.get("chat_count")%></span></a>
                </div>
            </div>
		<%
		}
}
%>