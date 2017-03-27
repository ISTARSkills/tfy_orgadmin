package in.orgadmin.orgadmin.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.apps.dao.Pincode;
import com.istarindia.apps.dao.PincodeDAO;
import com.istarindia.apps.dao.Student;
import com.istarindia.apps.dao.StudentDAO;
import com.istarindia.apps.services.controllers.IStarBaseServelet;

@WebServlet("/add_student")
public class CreateOrUpdateStudent extends IStarBaseServelet{
	private static final long serialVersionUID = 1L;

	public CreateOrUpdateStudent() {
		super();
	}

protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	printParams(request);
	printAttrs(request);
	
		String name = request.getParameter("name");
		String email = request.getParameter("email");
		String mobile = request.getParameter("mobile");
		String gender = request.getParameter("gender");
		String fatherName = request.getParameter("father_name");
		String motherName = request.getParameter("mother_name");
		String collegeName = request.getParameter("college_name");
		String addressLineOne = request.getParameter("address_line_one");
		String addressLineTwo = request.getParameter("address_line_two");
		int pinCode = Integer.parseInt(request.getParameter("pincode"));
		
		String studentId = request.getParameter("student_id");
		
		PincodeDAO pincodeDAO = new PincodeDAO();
		Pincode pincode = pincodeDAO.findByPin(pinCode).get(0);
			
		String city = pincode.getCity();
		String state = pincode.getState();
		String country = pincode.getCountry();
		String studentImage = "url of the student image";
		
		if(studentId==null){
			System.out.println("Creating Student");
			
			
		}
		else{
			StudentDAO studentDAO = new StudentDAO();
			Student student = studentDAO.findById(Integer.parseInt(studentId));
			System.out.println("Updating Student Object");
		}
		
		response.sendRedirect(""); //user dependent
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		doGet(request, response);
	}
	
}
