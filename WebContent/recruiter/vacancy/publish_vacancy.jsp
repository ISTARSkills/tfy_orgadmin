
<%@page import="com.istarindia.apps.dao.Vacancy"%>
<%@page import="com.istarindia.apps.dao.VacancyDAO"%>
<%
VacancyDAO vaccancyDAO = new VacancyDAO();
Vacancy vacancy = new Vacancy();
if(request.getParameter("vacancy_id") !=null ) {
	vacancy = vaccancyDAO.findById(Integer.parseInt(request.getParameter("vacancy_id")));
}

%>

<div class="panel-body" style="width: 100%;">
	<fieldset>
		<h2>Publish</h2>
		<p>You're almost done. This is the last step before your position
			is published on job portal, social media and job boards.</p>
		<div class="row">
			<div class="col-lg-6">
				<%
														if(request.getParameter("vacancy_id") !=null ) 
														{
														%>
				<button type="button" class="btn btn-w-m btn-primary"
					id="publish_position">Publish</button>
				<%
														}
														%>
			</div>
		</div>
	</fieldset>
</div>