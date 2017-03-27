<%@page import="com.istarindia.apps.dao.RecruiterPanelistMapping"%>
<%@page import="com.istarindia.apps.dao.RecruiterDAO"%>
<%@page import="com.istarindia.apps.dao.Recruiter"%>
<%

int recruiter_id = Integer.parseInt(request.getParameter("recruiter_id"));
Recruiter rec = new RecruiterDAO().findById(recruiter_id);
String panelist="";
for(RecruiterPanelistMapping map : rec.getRecruiterPanelistMappings())
{
	panelist+= map.getPanelist().getEmail()+",";	
}
%>
<div class="panel-body" style="width: 100%;">
		<h2>Hiring Team</h2>
		<p>
			Choose the team who'll be involved in the hiring effort for this
			position. Add existing company members by name or invite new
			ones by email.
		</p>
		
		<div class="panel-body">
						<h3>Select Members</h3>
						
				<div class="form_control">
					<div class="form-group row">
					<div class="col-md-6">
						<label class="col-xs-2 control-label">Email</label> 
						<div class="col-xs-10">
						<input class="tagsinput form-control" type="text" name="hiring_team" id="id_hiring_team_email" value="<%=panelist%>" />
						</div>
					</div>
					<div class="col-md-4">
					<button type="button" class="btn btn-w-m btn-primary" data-loading-text="Inviting"
					id="invite_hiring_team">Invite</button>
					</div>
					</div>	
									
				</div>
		</div>
		</div>