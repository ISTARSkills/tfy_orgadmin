<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="org.ocpsoft.prettytime.PrettyTime"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="in.orgadmin.utils.report.CustomReport"%>
<%@page import="in.orgadmin.utils.report.CustomReportUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="chat_notification" id="chat_notification_id" style="margin-top: 10px;
    width: 500px;">    
<%
IstarUser user = (IstarUser) request.getSession().getAttribute("user");
%>    
<%
CustomReportUtils reportUtils = new CustomReportUtils();
CustomReport report = reportUtils.getReport(25);
String sql = report.getSql().replaceAll(":user_id", user.getId()+"");
DBUTILS util = new DBUTILS();
List<HashMap<String, Object>> notificationData = util.executeQuery(sql);
PrettyTime p = new PrettyTime();
for(HashMap<String, Object> row: notificationData)
{
	int id = (int)row.get("id");
	String title = row.get("title").toString();
	String type = row.get("type").toString();
	String firstName = row.get("first_name").toString();
	Timestamp createdAt = (Timestamp)row.get("created_at"); 
	String time = p.format(createdAt);
	
	String groupCode = "";
	if(row.get("group_code")!=null)
	{
		groupCode = row.get("group_code").toString();
	}
	%>    	                                        
     <div class="alert alert-info alert-dismissable notification_item animated tada">
                                <button aria-hidden="true" data-dismiss="alert" class="close notification_close" data-notice_id="<%=id%>" data-group_code="<%=groupCode%>" data-notice_type="SINGLE_NOTICE" type="button">×</button>
                                 <a class="alert-link" > <%=firstName %> </a>
											<span class="message-date" >&nbsp;posted <%=time %> </span>
                                            <span class="message-content">
											<%=title%>	
											</span>
                            </div>                                   	
		
	<%
}

%>
</div>	