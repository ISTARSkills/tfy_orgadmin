package in.orgadmin.orgadmin.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.istarindia.apps.services.controllers.IStarBaseServelet;

@WebServlet("/add_orgadmin")
public class CreateOrUpdateOrgAdmin extends IStarBaseServelet{
	private static final long serialVersionUID = 1L;
	
	//No args constructor
	CreateOrUpdateOrgAdmin(){
		super();
	}
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		printParams(request);
		printAttrs(request);
		
		
		
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		doGet(request, response);
	}
	
}
