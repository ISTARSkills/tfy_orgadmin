<%@page import="com.viksitpro.core.utilities.TicketStates"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUserDAO"%>
<%@page import="in.talentify.core.services.NotificationAndTicketServices"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="org.ocpsoft.prettytime.PrettyTime"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%
IstarUser user = (IstarUser) request.getSession().getAttribute("user");
String ticketId = request.getParameter("ticket_id");
NotificationAndTicketServices serv = new NotificationAndTicketServices();
List<HashMap<String, Object>> summaryData = serv.getTicketSummary(ticketId);
List<HashMap<String, Object>> ticketData = serv.getTicket(ticketId);
IstarUserDAO dao = new IstarUserDAO();
PrettyTime pt = new PrettyTime();

Timestamp updetdat = (Timestamp)ticketData.get(0).get("updated_at"); 
%>	
<div class="panel panel-primary custom-theme-panel-primary" style="margin-bottom: 0px;">
                                        <div class="panel-heading custom-theme-panal-color">
	<button type="button" class="close" data-dismiss="modal">
		<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
	</button>
	<h2 class="modal-title text-center">Ticket Summary</h2>

</div>


 <div class="modal-body">
                                        
                                        
                                        
                                       


	<h2><%=ticketData.get(0).get("title")%></h2>
	<h3><%=ticketData.get(0).get("description")%></h3>
	<div style="margin-bottom: 23px;">
	<span class="label label-primary">Created By: </span> &nbsp;<%=dao.findById(Integer.parseInt(ticketData.get(0).get("creator_id").toString())).getUserProfile().getFirstName()%>
	<span class="label label-primary" >Status : </span>&nbsp;<span id="ticket_modal_status"><%=ticketData.get(0).get("status")%></span> (last updated <%=pt.format(updetdat)%>)
	<%if(ticketData.get(0).get("status").toString().equalsIgnoreCase(TicketStates.CLOSED)) 
	{
	%>
	<button  class="btn btn-w-m btn-primary ticket_status_change" style="float:right" data-status="<%=TicketStates.REOPENED%>" data-ticket_id="<%=ticketId%>">Re Open Ticket</button>
	<%
	}
	else
	{	
	%>
	<button class="btn btn-w-m btn-primary ticket_status_change" style="float:right" data-status="<%=TicketStates.CLOSED%>" data-ticket_id="<%=ticketId%>">Close Ticket</button>
	<%
	}%>
	</div>
	
                                <div class="chat-discussion" style="height:579px !important;">
                                <div id="ticket_messages">
                                    <%
                                  
                                    for(int i =0; i<summaryData.size(); i++)
                                    {
                                    	HashMap<String, Object> row = summaryData.get(i);
                                    	int commentBy = (int)row.get("comment_by");
                                    	
                                    	IstarUser commentor = dao.findById(commentBy);
                                    	String align="right";
                                    	if(user.getId()==commentBy)
                                    	{
                                    		align="left";
                                    	}
                                    	else
                                    	{
                                    		align="right";
                                    	}
                                    	Timestamp commentedAt = (Timestamp)row.get("comment_created_at");
                                    	%>
                                    	<div class="chat-message <%=align%>">
                                        <img class="message-avatar" src="http://cdn.talentify.in/video/android_images/<%=commentor.getUserProfile().getFirstName().toUpperCase().substring(0, 1)%>.png" alt="">
                                        <div class="message">
                                            <a class="message-author" href="#"> <%=commentor.getUserProfile().getFirstName()%> </a>
                                            <span class="message-date"><%= pt.format(commentedAt)%></span>
                                            <span class="message-content">
											<%=row.get("comment")%>
                                            </span>
                                        </div>
                                    </div>
                                    	
                                    	<% 
                                    }
                                    %>
                                    </div>
                                <div class="col-sm-10"><input type="text" class="form-control" placeholder="Enter Message" data-ticket_id="<%=ticketId%>" data-commented_by="<%=user.getId() %>" id="add_comment_to_ticket"></div>
                                
                                </div>
                                

                            </div>
</div> 