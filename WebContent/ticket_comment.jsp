<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
String ticketId = request.getParameter("ticket_id");
IstarUser user = (IstarUser)request.getSession().getAttribute("user");
String message = request.getParameter("message");
%>    
<div class="chat-message left">
                                        <img class="message-avatar" src="http://cdn.talentify.in/video/android_images/<%=user.getUserProfile().getFirstName().toUpperCase().substring(0, 1)%>.png" alt="">
                                        <div class="message">
                                            <a class="message-author" href="#"> <%=user.getUserProfile().getFirstName()%> </a>
                                            <span class="message-date">few seconds ago</span>
                                            <span class="message-content">
											<%=message%>
                                            </span>
                                        </div>
                                    </div>