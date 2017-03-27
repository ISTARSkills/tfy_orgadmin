package in.orgadmin.orgadmin.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.apps.dao.AddressDAO;
import com.istarindia.apps.dao.DBUTILS;
import com.istarindia.apps.dao.IstarUser;
import com.istarindia.apps.dao.IstarUserDAO;
import com.istarindia.apps.dao.Student;
import com.istarindia.apps.dao.StudentDAO;
import com.istarindia.apps.services.controllers.IStarBaseServelet;

import in.orgadmin.admin.services.OrgAdminUserService;
import in.recruiter.services.RecruiterServices;

/**
 * Servlet implementation class UpdateTrainerDetails
 */
@WebServlet("/update_trainer_details")
public class UpdateTrainerDetails extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    
    public UpdateTrainerDetails() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printParams(request);
		
		RecruiterServices rs = new RecruiterServices();
		OrgAdminUserService orgAdminUserService = new OrgAdminUserService();
		
		String trainerID = request.getParameter("trainer_id");
		String mobile = request.getParameter("mobile");
		String trainer_name = request.getParameter("trainer_name");
		String gender = request.getParameter("gender");
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		String Utype = request.getParameter("Utype");
		String org_id = request.getParameter("org_id");
		
		Student student = null;
		Student presentor = null;
		
		
		if(request.getParameterMap().containsKey("trainer_id")){
			student = orgAdminUserService.updateStudent(Integer.parseInt(trainerID), trainer_name, email, password, mobile, 
					gender, Utype, new AddressDAO().findById(2));
			
			response.sendRedirect("orgadmin/trainer/trainer_list.jsp");
		}else{
			System.out.println("Creating New Student/Trainer");
			student = orgAdminUserService.createStudent(trainer_name, email, password, mobile, 
					gender, Utype, new AddressDAO().findById(2));
			
			if(Utype.equalsIgnoreCase("TRAINER")){
			presentor = orgAdminUserService.createStudent(trainer_name, email.replace("@", "_presentor@"), password, mobile, 
					gender, "PRESENTOR", new AddressDAO().findById(2));
			System.out.println("Trainer and Presentor Objects Created, Now Creating Trainer Presentor");
			orgAdminUserService.createTrainerPresentor(student.getId(), presentor.getId());
			System.out.println("Created Entry in Trainer Presentor");
			}
			
			response.sendRedirect("orgadmin/organization/dashboard.jsp?org_id="+org_id);
		}
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
