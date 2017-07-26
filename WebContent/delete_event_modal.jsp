<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	IstarUser user = (IstarUser)request.getSession().getAttribute("user");
	int orgAdminUserID =user.getId();
	String eventId = request.getParameter("event_id");
	
%>

                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-body">
                                            <div class="row">
                                                <div class="col-sm-12 b-r"><h3 class="m-t-none m-b">Provide Reason For Deletion</h3>

                                                  <form role="form" id="delete_event_form">
                                                  <input type="hidden" name="eventID" value="<%=eventId%>"/>

<input type="hidden" name="AdminUserID" value="<%=orgAdminUserID%>"/>
                                                        <div class="form-group">	 <input type="text" name="reason_for_edit_delete" class="form-control" required id="reason_for_edit_delete" >
										<label id="reason_needed" class="error" style="display:none">Reason is required.</label></div>
                                                       
                                                        <div>
                                                            <button class="btn btn-sm btn-primary pull-right m-t-n-xs" type="submit" id="delete_event_button"><strong>Delete</strong></button>
                                                            
                                                        </div>
                                                    </form>
                                                    

                                                    
                                                </div>
                                               
                                        </div>
                                    </div>
                                    </div>
                                </div>
								
