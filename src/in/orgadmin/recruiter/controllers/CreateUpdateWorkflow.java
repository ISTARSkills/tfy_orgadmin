package in.orgadmin.recruiter.controllers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.istarindia.apps.WorkflowChangeLevel;
import com.istarindia.apps.dao.IstarTaskType;
import com.istarindia.apps.dao.Vacancy;
import com.istarindia.apps.dao.VacancyDAO;
import com.istarindia.apps.services.controllers.IStarBaseServelet;

import in.recruiter.services.RecruiterServices;

/**
 * Servlet implementation class CreateUpdateWorkflow
 */
@WebServlet("/create_update_workflow")
public class CreateUpdateWorkflow extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CreateUpdateWorkflow() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printParams(request);
		/*
		 * param_name -> stage_names[] : param_value ->stage 1
param_name -> stage_types[] : param_value ->assessment
param_name -> assessment_ids[] : param_value ->10311
param_name -> panelists[] : param_value ->none
param_name -> other_infos[] : param_value ->none
param_name -> vacancy_iddd : param_value ->30013*/
		
		String stage_names[] = request.getParameterValues("stage_names[]");
		String stage_types[] = request.getParameterValues("stage_types[]");
		String assessment_ids[] = request.getParameterValues("assessment_ids[]");
		String panelists[] = request.getParameterValues("panelists[]");
		String testURLs[] = request.getParameterValues("test_urls[]");
		String other_infos[] = request.getParameterValues("other_infos[]");
		String vacancy_iddd = request.getParameter("vacancy_iddd");
		if(!vacancy_iddd.equalsIgnoreCase("none"))
		{
			String workflow_name = "WorkFlow"+vacancy_iddd;
			RecruiterServices service = new RecruiterServices();
			List<HashMap<String, String>> stages = new ArrayList<>();
			List<HashMap<String, String>> stage_actions = new ArrayList<>();
			int stage_count=0;
			int i=1;
			System.out.println("total stages---"+stage_names.length+" value "+StringUtils.join(stage_names));
			for(String str : stage_names)
			{
				if(!str.equalsIgnoreCase("none"))
				{
					
					HashMap<String, String> stage = new HashMap<>();
					stage.put("stage_name", str);
					stage.put("order", ""+i);
					
					stages.add(stage);
					
					
					HashMap<String, String> stage_action = new HashMap<>();					
					String stage_type= stage_types[stage_count];
					//System.out.println("stage_type"+stage_type);
					stage_action.put("stage_type", stage_type);
					if(stage_type.equalsIgnoreCase("assessment"))
					{
						String assessment_id = assessment_ids[stage_count];
						//System.out.println("action"+assessment_id);
						stage_action.put("action", assessment_id);
					}
					else if(stage_type.equalsIgnoreCase("interview")) 
					{
						String interviewee = panelists[stage_count];
						//System.out.println("action"+interviewee);
						stage_action.put("action", interviewee);
					}
					else if(stage_type.equalsIgnoreCase("external_assessment")) 
					{
						System.out.println("Hi from external_assessment");
						String testURL = testURLs[stage_count];
						System.out.println("action"+testURL);
						stage_action.put("action", testURL);
					}
					else if(stage_type.equalsIgnoreCase("other"))
					{
						String other_info = other_infos[stage_count];
					//	System.out.println("action"+other_info);
						stage_action.put("action", other_info);
					}
					
					//System.out.println("stage_name"+str);
					//System.out.println("order"+i);
					
					
					stage_actions.add(stage_action);
					i++;
				}
				stage_count++;
			}
			
			Vacancy vacancy = new VacancyDAO().findById(Integer.parseInt(vacancy_iddd));
			if(vacancy.getIstarTaskType().getType().equalsIgnoreCase("DEFAULT_VACANCY_WORKFLOW"))
			{
				IstarTaskType workflow = service.createNewWorkflow("JOB", workflow_name, vacancy.getCompany().getId(), WorkflowChangeLevel.CANNOT_CHANGED, stages,stage_actions, false, vacancy);
				vacancy.setIstarTaskType(workflow);
				VacancyDAO vdao = new VacancyDAO();
				Session session = vdao.getSession();
				Transaction tx = null;
				try {
					tx = session.beginTransaction();
					session.update(vacancy);					
					tx.commit();
				} catch (HibernateException e) {
					e.printStackTrace();
					if (tx != null)
						tx.rollback();
					e.printStackTrace();
				} finally {
					session.close();
				}
			}
			else
			{				
				//IstarTaskType workflow = service.updateWorkflow(vacancy.getIstarTaskType(), "JOB", workflow_name, stages, stage_actions)	;
			}			
			
			System.out.println("workflow created");
			/*update vacancy*/
		}
		
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
