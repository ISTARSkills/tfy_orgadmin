<%@page import="java.util.UUID"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="in.orgadmin.utils.report.CustomReport"%>
<%@page import="in.orgadmin.utils.report.CustomReportUtils"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
IstarUser user = (IstarUser) request.getSession().getAttribute("user");
CustomReportUtils repUtils = new CustomReportUtils();
CustomReport report = new CustomReport();
String userRole = user.getUserRoles().iterator().next().getRole().getRoleName();
String searchReportID = "";
String defaultReportID = "";
if(userRole.equalsIgnoreCase("SUPER_ADMIN"))
{
	report = repUtils.getReport(28);
	defaultReportID="28";
	searchReportID ="31";
}
else if (userRole.equalsIgnoreCase("ORG_ADMIN"))
{
	report = repUtils.getReport(34);
	defaultReportID="34";
	searchReportID ="37";	
}
String sql = report.getSql().replaceAll(":user_id", user.getId()+"");
DBUTILS util = new DBUTILS();
List<HashMap<String, Object>> groupList = util.executeQuery(sql);
%>     
<div class="panel-body">
<input type="text" placeholder="Search Group" class="form-control search_chat_entity" id="<%=UUID.randomUUID()%>" data-default_report_id="<%=defaultReportID%>" data-report_id="<%=searchReportID	 %>" data-user_id="<%=user.getId()%>" style="width: 289px;
    margin-left: -18px;
    margin-top: -17px;
    margin-bottom: 6px;border-radius: 6px;">                                
                                <div class="chat-users" style="height: 441px; margin-left: -24px; width: 296px;">
								<div class="users-list">
								<%								 
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
                                            <img class="chat-avatar" src="http://cdn.talentify.in<%=image%>" alt="" style="width:36px ; height:36px">
                                            <div class="chat-user-name">
                                                <a href="#"><%=group.get("name")%>
                                                <%if(group.get("chat_count")!=null && (int)group.get("chat_count")!=0){ %>
                                                 <span class="label label-primary" style="float:right" id="entity_bg_group_<%=group.get("id")%>_chat_count"><%=group.get("chat_count")%></span>
                                                <%} %> 
                                                 </a>
                                            </div>
                                        </div>
									<%
									} %>                                      
                                    </div>
                                </div>                                 
								</div>