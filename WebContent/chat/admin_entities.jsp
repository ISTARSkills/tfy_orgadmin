<%@page import="java.util.UUID"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="in.orgadmin.utils.report.CustomReport"%>
<%@page import="in.orgadmin.utils.report.CustomReportUtils"%>
<%@page import="java.util.HashMap"%>
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
	report = repUtils.getReport(27);
	defaultReportID="27";
	searchReportID ="30";
}
else if (userRole.equalsIgnoreCase("ORG_ADMIN"))
{
	report = repUtils.getReport(33);
	defaultReportID = "33";
	searchReportID="36";
	}
String sql = report.getSql().replaceAll(":user_id", user.getId()+"");
DBUTILS util = new DBUTILS();
List<HashMap<String, Object>> orgList = util.executeQuery(sql);
%>   
<div class="panel-body">
<input type="text" placeholder="Search Admin" class="form-control search_chat_entity" id="<%=UUID.randomUUID()%>" data-default_report_id="<%=defaultReportID%>" data-report_id="<%=searchReportID	 %>" data-user_id="<%=user.getId()%>" style="width: 289px;
    margin-left: -18px;
    margin-top: -17px;
    margin-bottom: 6px;border-radius: 6px;"> 
                                <div class="chat-users" style="height: 441px; margin-left: -24px; width: 296px;">
								<div class="users-list">
								<%								 
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
                                            <img class="chat-avatar" src="http://cdn.talentify.in<%=image%>" alt="" style="width:36px ; height:36px">
                                            <div class="chat-user-name">
                                                <a href="#"><%=org.get("name")%></a>
                                                <%if(org.get("chat_count")!=null && (int)org.get("chat_count")!=0){ %>
                                                <span class="label label-primary" style="float:right" id='entity_user_<%=org.get("id") %>_chat_count'><%=org.get("chat_count")%></span>
                                                <%} %>                                            
                                            </div>
                                        </div>
									<%
									} %>                                      
                                    </div>
                                </div>                                    
                                </div>