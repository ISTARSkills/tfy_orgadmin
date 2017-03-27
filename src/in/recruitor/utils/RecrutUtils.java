/**
 * 
 */
package in.recruitor.utils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import org.hibernate.Query;

import com.istarindia.apps.dao.IstarNotification;
import com.istarindia.apps.dao.IstarNotificationDAO;
import com.istarindia.apps.dao.IstarTaskType;
import com.istarindia.apps.dao.IstarTaskWorkflow;
import com.istarindia.apps.dao.IstarTaskWorkflowConcrete;
import com.istarindia.apps.dao.IstarTaskWorkflowDAO;
import com.istarindia.apps.dao.IstarUserDAO;
import com.istarindia.apps.dao.JobsEvent;
import com.istarindia.apps.dao.JobsEventDAO;
import com.istarindia.apps.dao.Recruiter;
import com.istarindia.apps.dao.RecruiterDAO;
import com.istarindia.apps.dao.Student;
import com.istarindia.apps.dao.StudentDAO;
import com.istarindia.apps.dao.Vacancy;
import com.istarindia.apps.dao.VacancyDAO;
import com.istarindia.apps.service.TaskWorkflowService;

/**
 * @author Vaibhav
 *
 */
public class RecrutUtils {

	public StringBuffer getVacanciesTabList(int collegeID, int recruiter_id) {
		Recruiter r = new RecruiterDAO().findById(recruiter_id);
		Set<Vacancy> vacanceis = r.getVacancies();
		StringBuffer tabList = new StringBuffer();
		int index = 0;
		String tabClass = " class='active' ";
		for (Vacancy vacancy : vacanceis) {
			if (index < 5) {
				tabList.append("<li " + tabClass + ">");
				tabList.append( "<a data-toggle='tab' href='#tab-vacancy-" + vacancy.getId() + "' aria-expanded='true'>");
				tabList.append(vacancy.getProfileTitle());
				tabList.append("	</a></li>");

				tabClass = "";
			}
			index++;
		}

		return tabList;

	}

	public StringBuffer getVacanciesTabDetailsList(int collegeID, int recruiter_id) {
		Recruiter r = new RecruiterDAO().findById(recruiter_id);
		Set<Vacancy> vacanceis = r.getVacancies();
		StringBuffer tabList = new StringBuffer();
		int index = 0;
		String tabClass = "active";
		for (Vacancy vacancy : vacanceis) {
			if (index < 5) {
				tabList.append("<div id='tab-vacancy-" + vacancy.getId() + "' class='tab-pane " + tabClass + "'>");
				tabList.append("<div class='panel-body'>");
				tabList.append(getWokFlowSteps(vacancy));
				tabList.append("</div>");
				tabList.append("</div>");

				tabClass = "";
			}
			index++;
		}

		return tabList;

	}

	private StringBuffer getWokFlowSteps(Vacancy vacancy) {
		StringBuffer out = new StringBuffer();
		
		out.append("<div class='tabs-container'> <div class='tabs-left'> "
				+ "<ul class='nav nav-tabs'> "
				+ getWorkFlowTablist(vacancy)
				+ "</ul> "
				
				+ "<div class='tab-content '> " + getWorkFlowTabDetailslist(vacancy) + " </div></div></div>");
		
		return out;
	}

	private StringBuffer getWorkFlowTablist(Vacancy vacancy) {
		List<String> temps = new ArrayList<>();
		temps.add("ONE");
		temps.add("TWO");
		temps.add("THREE");
		temps.add("FOUR");
		
		
		StringBuffer out = new StringBuffer();
		int index = 0;
		String tabClass = " class='active' ";
		for (String temp : temps) {
			if (index < 5) {
				out.append("<li " + tabClass + ">");
				out.append( "<a data-toggle='tab' href='#tab-vacancy-" + vacancy.getId() + "workflow-" + index + "' aria-expanded='true'>");
				out.append(temp);
				out.append("	</a></li>");

				tabClass = "";
			}
			index++;
		}

		return out;

	}

	private StringBuffer getWorkFlowTabDetailslist(Vacancy vacancy) {
		List<String> temps = new ArrayList<>();
		temps.add("ONE");
		temps.add("TWO");
		temps.add("THREE");
		temps.add("FOUR");
		
		StringBuffer out = new StringBuffer();
		int index = 0;
		String tabClass = "active ";
		for (String temp : temps) {
			if (index < 5) {
				out.append("<div id='tab-vacancy-" + vacancy.getId() + "workflow-"+index+"' class='tab-pane " + tabClass + "'> <div class='panel-body'> ");
				out.append(temp + "  " + temp);
				out.append("	 </div> </div> ");

				tabClass = "";
			}
			index++;
		}

		return out;

	}

	//Students for Recruiter Jobs Page
	public HashMap<Integer, Student> getUsersForVacancy(int vacancyID, String stageID){
		HashMap<Integer, Student> users = new HashMap<>();
		
		IstarTaskWorkflow stage = new IstarTaskWorkflowDAO().findById(UUID.fromString(stageID));
		String hql = "from JobsEvent as model where model.vacancy=:vac_id and model.status=:status and model.isactive='t' order by model.actor";
		Query q = (new IstarUserDAO()).getSession().createQuery(hql);
		q.setInteger("vac_id", vacancyID);
		q.setString("status", stage.getStage());
		List<JobsEvent> events = q.list();
		for(JobsEvent ev : events)
		{
			users.put(ev.getActor().getId(), ev.getActor());
		}	
		return users;	
	}
	
	//Students for Recruiter Jobs Page - Paginated
	public ArrayList<Student> getUsersForVacancyPaginated(int vacancyID, String stageID){
		ArrayList<Student> users = new ArrayList<Student>();
		
		IstarTaskWorkflow stage = new IstarTaskWorkflowDAO().findById(UUID.fromString(stageID));

		String hql = "from JobsEvent as model where model.vacancy=:vac_id and model.status=:status  and model.isactive='t' order by model.actor";
		Query q = (new IstarUserDAO()).getSession().createQuery(hql);
		q.setInteger("vac_id", vacancyID);
		q.setString("status", stage.getStage());
		List<JobsEvent> events = q.list();
		for(JobsEvent ev : events)
		{
			users.add(ev.getActor());
		}	
		return users;	
	}
	
	//Students for Recruiter Campaigns Page
	public HashMap<Integer, Student> getUsersForVacancy(int vacancyID, String stageID, int collegeID){
		HashMap<Integer, Student> users = new HashMap<>();
		
		IstarTaskWorkflow stage = new IstarTaskWorkflowDAO().findById(UUID.fromString(stageID));
		
		String hql = "select je.actor from JobsEvent je inner join je.actor aa where aa.college=:college_id and "
				+ "je.vacancy=:vacancy_id and je.status=:status and je.isactive='t' order by je.actor";
		
		Query q = (new IstarUserDAO()).getSession().createQuery(hql);
		q.setInteger("college_id", collegeID);
		q.setInteger("vacancy_id", vacancyID);
		q.setString("status", stage.getStage());
		List<Student> allStudentsOfCollege = (List<Student>) q.list();
		
		for(Student student : allStudentsOfCollege)
		{
			users.put(student.getId(), student);
		}	
		return users;
	}
	
	//Students for Recruiter Campaigns Page - Paginated
	public ArrayList<Student> getUsersForVacancyPaginated(int vacancyID, String stageID, int collegeID){
		HashMap<Integer, Student> users = new HashMap<>();
		
		IstarTaskWorkflow stage = new IstarTaskWorkflowDAO().findById(UUID.fromString(stageID));
		
		String hql = "select je.actor from JobsEvent je inner join je.actor aa where aa.college=:college_id and "
				+ "je.vacancy=:vacancy_id and je.status=:status and je.isactive='t'  order by je.actor";
		
		Query q = (new IstarUserDAO()).getSession().createQuery(hql);
		q.setInteger("college_id", collegeID);
		q.setInteger("vacancy_id", vacancyID);
		q.setString("status", stage.getStage());
		ArrayList<Student> allStudentsOfCollege = (ArrayList<Student>) q.list();
		
		return allStudentsOfCollege;
	}
	
	//Students for PlacementOfficer Campaigns Page
	public HashMap<Integer, Student> getUsersForVacancy(int vacancyID, String stageID, int collegeID ,int companyID){
		HashMap<Integer, Student> users = new HashMap<>();
		
		IstarTaskWorkflow stage = new IstarTaskWorkflowDAO().findById(UUID.fromString(stageID));
		
		String hql = "SELECT je.actor FROM	JobsEvent je INNER JOIN je.actor aa INNER JOIN je.vacancy vac WHERE	aa.college=:college_id "
				+ "AND je.vacancy=:vacancy_id AND je.status=:status  and je.isactive='t' AND vac.company=:company_id order by je.actor";
		
		Query q = (new IstarUserDAO()).getSession().createQuery(hql);
		q.setInteger("college_id", collegeID);
		q.setInteger("vacancy_id", vacancyID);
		q.setString("status", stage.getStage());
		q.setInteger("company_id", companyID);
		List<Student> allStudentsOfCollege = (List<Student>) q.list();
		
		for(Student student : allStudentsOfCollege)
		{
			users.put(student.getId(), student);
		}	
		return users;
	}
	
	//Students for PlacementOfficer Campaigns Page - Paginated
	public ArrayList<Student> getUsersForVacancyPaginated(int vacancyID, String stageID, int collegeID ,int companyID){
		HashMap<Integer, Student> users = new HashMap<>();
		
		IstarTaskWorkflow stage = new IstarTaskWorkflowDAO().findById(UUID.fromString(stageID));
		
		String hql = "SELECT je.actor FROM	JobsEvent je INNER JOIN je.actor aa INNER JOIN je.vacancy vac WHERE	aa.college=:college_id "
				+ "AND je.vacancy=:vacancy_id AND je.status=:status  and je.isactive='t' AND vac.company=:company_id order by je.actor";
		
		Query q = (new IstarUserDAO()).getSession().createQuery(hql);
		q.setInteger("college_id", collegeID);
		q.setInteger("vacancy_id", vacancyID);
		q.setString("status", stage.getStage());
		q.setInteger("company_id", companyID);
		ArrayList<Student> allStudentsOfCollege = (ArrayList<Student>) q.list();
		
		return allStudentsOfCollege;
	}
	
	public String getOfferLetter(int vacancyID, int studentID){
		
		String offerLetter = "";
		String hql = "select action from JobsEvent where vacancy=:vacancy_id and actor=:student_id and status='Offered'";
		
		System.out.println(hql);
		Query q = (new IstarUserDAO()).getSession().createQuery(hql);
		q.setInteger("vacancy_id", vacancyID);
		q.setInteger("student_id", studentID);
		
		List<String> action = (List<String>) q.list();
		System.out.println("Offer Letter size:-->" + action.size());
		if(action.size() > 0){
			System.out.println("Offer letter found");
			return action.get(0);
		}
		else{
			System.out.println("No Offer Letter");
			return "No Offer Letter";
		}
	}
	
	public ArrayList<IstarNotification> getMessagesByRecruiterStudent(int studentID, int recID) {
		IstarNotificationDAO dao = new IstarNotificationDAO();
		IstarNotification n = new IstarNotification();
		n.setSenderId(recID);
		n.setReceiverId(studentID);
		List<IstarNotification>  details = dao.findByExample(n);
		
		return (ArrayList<IstarNotification>) details;
		
	}
}
