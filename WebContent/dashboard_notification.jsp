<%@page import="java.util.ArrayList"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="in.talentify.core.services.NotificationAndTicketServices"%>
<%@page import="com.viksitpro.core.utilities.NotificationType"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="java.util.List"%>
<%@page import="in.orgadmin.utils.report.CustomReport"%>
<%@page import="in.orgadmin.utils.report.CustomReportUtils"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.ocpsoft.prettytime.PrettyTime"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
IstarUser user = (IstarUser) request.getSession().getAttribute("user");
String limit = "8";
if(request.getParameter("limit")!=null)
{
	limit = request.getParameter("limit");
}
String offset = "0";
if(request.getParameter("offset")!=null)
{
	offset = request.getParameter("offset");
}
NotificationAndTicketServices serv = new NotificationAndTicketServices();
List<HashMap<String, Object>> data = new ArrayList();
PrettyTime p = new PrettyTime();
int total_notice_unread = 0;
if(data.size()>0)
{
	total_notice_unread = (int)data.get(0).get("total_rows");		
}

for(HashMap<String, Object> row: data)
{
										String title =row.get("title").toString();
										String id = row.get("id").toString();
										String time =p.format((Timestamp)row.get("created_at"));
										String type = row.get("type").toString();
										String firstName = row.get("first_name").toString();
										String groupCode = "";
										if(row.get("group_code")!=null){
											groupCode = row.get("group_code").toString();
										}
										String noticeType =  row.get("notice_type").toString();
										String color ="info";
										String tags ="";
										if(type.equalsIgnoreCase(NotificationType.TICKET_NOTIFICATION))
										{
											color = "danger";
											if(row.get("action")!=null)
											{
												String action = row.get("action").toString();
												for(String str : action.split(","))
												{
													tags+="<span style='margin-left: 4px;' class='label label-danger'>"+str+"</span>";
												}
											}
										}											
										%>
<div class="alert alert-<%=color%> alert-dismissable" style="padding-bottom: 26px;">
		<button aria-hidden="true" data-dismiss="alert" class="close notification_close" data-notice_id="<%=id%>" data-group_code="<%=groupCode%>" data-notice_type="<%=noticeType%>" type="button">×</button>
		<a class="alert-link" >Posted By: <%=firstName%>
		</a> <span class="message-date" >&nbsp;posted <%=time %>
		</span> <span class="message-content"> <%=title%>		
		</span>
		<div class="notice_tags" style="float: right;"><%=tags %></div>
</div>
	<%}%>
<input id="total_unread_notice" type="hidden" value="<%=total_notice_unread%>">