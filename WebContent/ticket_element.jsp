<%@page import="java.util.ArrayList"%>
<%@page import="com.viksitpro.core.dao.entities.UserRole"%>
<%@page import="com.viksitpro.core.dao.entities.RoleDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Role"%>
<%@page import="com.viksitpro.core.utilities.TicketTypes"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUserDAO"%>
<%@page
	import="in.talentify.core.services.NotificationAndTicketServices"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%@page import="org.ocpsoft.prettytime.PrettyTime"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="org.json.JSONArray"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page
	import="in.orgadmin.dashboard.services.OrgAdminDashboardServices"%>
<%@page import="java.util.Date"%>

<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	
	 IstarUser user = (IstarUser)request.getSession().getAttribute("user"); 
	 NotificationAndTicketServices serv = new NotificationAndTicketServices();
	 List<HashMap<String, Object>> tickets = serv.getTickets(user.getId()); 
	 IstarUserDAO dao = new IstarUserDAO();
	 
	 ArrayList<String> departments = serv.getDepartments();
	 //  user.getUserRoles().iterator().next().getRole().getUserRoles();
	 
%>
<div class="row">
	<div class="ibox ticket_margin-box card-box">
		<div class="ibox-title">
			<h5>Ticket List</h5>
			<div class="ibox-tools">
				<a class="btn btn-primary btn-xs" id='open_ticket'>Add New Issue</a>
			</div>
		</div>
		<div class="ibox-content">
			<div class="table-responsive">
				<table class="table table-hover issue-tracker">
					<thead>
						<tr>
							<th>Status</th>
							<th>Ticket Details</th>
							<th>Raised By</th>
							<th>Created At</th>
							<th>Updated At</th>
							<!-- <th>Tags</th> -->
							<th>Details</th>
						</tr>
					</thead>
					<tbody>

						<%
                                PrettyTime pt = new PrettyTime();
                                for(HashMap<String , Object> row: tickets)
                                {
                                	String senderName = dao.findById(Integer.parseInt(row.get("creator_id").toString())).getUserProfile().getFirstName();
                                	Timestamp created_at = (Timestamp)row.get("created_at");
                                	Timestamp updated_at = (Timestamp)row.get("updated_at");
                                %>
						<tr>
							<td><span class="label label-primary"
								id="ticket_table_status"><%=row.get("status") %></span></td>
							<td class="issue-info"><a href="#"> <%=row.get("title") %>
							</a> <small> <%=row.get("description") %>
							</small></td>
							<td><%=senderName%></td>
							<td><%=pt.format(created_at)%></td>
							<td><%=pt.format(updated_at)%></td>

							<%-- <td class="text-left">
                                    <%
                                    if(row.get("tags")!=null){
                                    for(String str: row.get("tags").toString().split(","))
                                    { 
                                    %>
                                    <button class="btn btn-white btn-xs"><%=str%></button>
                                    <% 
                                    }
                                }
                                    %>
                                      
                                    </td> --%>
							<td><a data-toggle="modal"
								class="btn btn-primary ticket_summary_button"
								data-ticket_id="<%=row.get("id")%>">Details</a></td>
						</tr>
						<%
                                }
                                %>



					</tbody>
				</table>
			</div>
		</div>

	</div>
</div>

<!-- ticket summary modal starts here -->
<div id="ticket_summary_modal" class="modal fade" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content ticket_summary_body">
			<!-- <div class="modal-body" id ="ticket_summary_body">
                                        
                                        
                                        
                                        </div> -->
		</div>
	</div>
</div>
<!-- ticket summary modal ends here -->

<!-- new ticket window starts here -->
<div id="create_new_ticket_modal" class="modal fade" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">

				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">�</span><span class="sr-only">Close</span>
				</button>
				<h3 class="m-t-none m-b">New Ticket</h3>
			</div>
			<div class="modal-body">
				<div class="row">
					<div class="col-sm-12 b-r">

						<form role="form" class="form"
							action="<%=baseURL%>create_new_ticket" id="new_ticket_form">
							<input type="hidden" name="created_by" value="<%=user.getId()%>">
							<div class="form-group">
								<label>Title *</label> <input type="text"
									placeholder="Enter Title" class="form-control ticket_filed"
									required name="title">
							</div>
							<div class="form-group">
								<label>Description *</label> <input type="text"
									placeholder="Enter Description"
									class="form-control ticket_filed" required name="description">
							</div>
							<div class="form-group">
								<select data-placeholder="Select Administration" multiple
									tabindex="8" name="receivers" id="receivers" required
									class="ticket_filed">
									<%
						if(user.getUserRoles().iterator().next().getRole().getRoleName().equalsIgnoreCase("SUPER_ADMIN"))
						{
							Role r= new RoleDAO().findByRoleName("ORG_ADMIN").get(0);
							
							for(UserRole ur : r.getUserRoles())
							{
								if(ur.getIstarUser().getUserProfile()!=null){
								%>
									<option value="<%=ur.getIstarUser().getId()%>"><%=ur.getIstarUser().getUserProfile().getFirstName()%></option>
									<%
								}		
							}
							Role sr= new RoleDAO().findByRoleName("SUPER_ADMIN").get(0);
							for(UserRole ur : sr.getUserRoles())
							{
								if(ur.getIstarUser().getUserProfile()!=null){
								%>
									<option value="<%=ur.getIstarUser().getId()%>"><%=ur.getIstarUser().getUserProfile().getFirstName()%></option>
									<%
								}	
							}
						}
						else if (user.getUserRoles().iterator().next().getRole().getRoleName().equalsIgnoreCase("ORG_ADMIN"))
						{
							Role sr= new RoleDAO().findByRoleName("SUPER_ADMIN").get(0);
							for(UserRole ur : sr.getUserRoles())
							{
								if(ur.getIstarUser().getUserProfile()!=null){
								%>
									<option value="<%=ur.getIstarUser().getId()%>"><%=ur.getIstarUser().getUserProfile().getFirstName()%></option>
									<%
								}
							}
						}	
						%>
								</select>
							</div>
							<div class="form-group">
								<select data-placeholder="Select Department" multiple
									tabindex="8" name="department" id="department" required
									class="ticket_filed">
									<%
										for(String department: departments)
										{
											%>
									<option value="<%=department%>"><%=department%></option>
									<% 
										}
										%>
								</select>
							</div>
							<div class="form-group">
								<select data-placeholder="Select Ticket Type" tabindex="8"
									name="ticket_type" id="ticket_type" required multiple
									class="ticket_filed">
									<option value="<%=TicketTypes.EARLY_FINISH_CLASS%>"><%=TicketTypes.EARLY_FINISH_CLASS%></option>
									<option value="<%=TicketTypes.INTERNET_ISSUE%>"><%=TicketTypes.INTERNET_ISSUE%></option>
									<option value="<%=TicketTypes.LATE_START_CLASS%>"><%=TicketTypes.LATE_START_CLASS%></option>
									<option value="<%=TicketTypes.POOR_ASSESSMENT_REPORT%>"><%=TicketTypes.POOR_ASSESSMENT_REPORT%></option>
									<option value="<%=TicketTypes.POOR_ATTENDENACE%>"><%=TicketTypes.POOR_ATTENDENACE%></option>
									<option value="<%=TicketTypes.PROJECTOR_ISSUE%>"><%=TicketTypes.PROJECTOR_ISSUE%></option>
								</select>
							</div>

							<div class="form-group">
								<label>Other Receiver Emails</label> <input
									placeholder="Enter Email" class="tagsinput form-control"
									type="text" value="" name="other_members" />
							</div>
							<div>
								<br>
								<div class="form-group">
									<button class="btn btn-sm btn-primary pull-right m-t-n-xs"
										type="submit">
										<strong>Create Ticket</strong>
									</button>
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<!-- new ticket window end here -->

</div>
