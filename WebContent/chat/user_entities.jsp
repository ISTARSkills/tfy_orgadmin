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
String userRole = user.getUserRoles().iterator().next().getRole().getRoleName();
CustomReport report = new CustomReport();
String searchReportID = "";
String defaultReportID = "";
if(userRole.equalsIgnoreCase("SUPER_ADMIN"))
{
	report = repUtils.getReport(29);
	defaultReportID="29";
	searchReportID ="32";
}
else if (userRole.equalsIgnoreCase("ORG_ADMIN"))
{
	report = repUtils.getReport(35);
	defaultReportID="35";
	searchReportID ="38";
	}
String sql = report.getSql().replaceAll(":user_id", user.getId()+"");
DBUTILS util = new DBUTILS();
List<HashMap<String, Object>> userList = util.executeQuery(sql);
%>     
<div class="panel-body">
<input type="text" placeholder="Search User" class="form-control search_chat_entity" id="<%=UUID.randomUUID()%>" data-default_report_id="<%=defaultReportID%>" data-report_id="<%=searchReportID	 %>" data-user_id="<%=user.getId()%>" style="width: 289px;
    margin-left: -18px;
    margin-top: -17px;
    margin-bottom: 6px;border-radius: 6px;"> 
                                <div class="chat-users" style="height: 441px; margin-left: -24px; width: 296px;">
								<div class="users-list">
								<%								 
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
                                            <img class="chat-avatar" src="http://cdn.talentify.in<%=image%>" alt="" style="width:36px ; height:36px">
                                            <div class="chat-user-name">
                                                <a href="#"><%=name%>
                                                <%if(users.get("chat_count")!=null && (int)users.get("chat_count")!=0){ %>
                                                <span class="label label-primary" style="float:right"><%=users.get("chat_count")%></span>
                                                <%} %>  
                                               </a> 
                                            </div>
                                        </div>
									<%
									} %>                                      
                                    </div>
                                </div>                                 
								</div>