package in.orgadmin.recruiter.controllers;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.lang.StringEscapeUtils;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Example;

import com.istarindia.apps.dao.DBUTILS;
import com.istarindia.apps.dao.IstarTaskWorkflow;
import com.istarindia.apps.dao.IstarTaskWorkflowDAO;
import com.istarindia.apps.dao.JobsEvent;
import com.istarindia.apps.dao.JobsEventDAO;
import com.istarindia.apps.dao.Student;
import com.istarindia.apps.dao.StudentDAO;
import com.istarindia.apps.dao.Vacancy;
import com.istarindia.apps.dao.VacancyDAO;
import com.istarindia.apps.services.controllers.IStarBaseServelet;

import in.recruiter.services.RecruiterServices;

public class SendOfferLetter extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
	
	public static File uploadFolder;
	String fileUploadPath;
	
	@Override
    public void init(ServletConfig config) {
    	fileUploadPath =config.getInitParameter("upload_path");
    	System.out.println("Creating folder for File Upload: " +  fileUploadPath);
    	uploadFolder = new File(fileUploadPath);
    	System.out.println("Folder Created for image upload");
	}
	
	public SendOfferLetter(){
		super();
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printParams(request);
		
		int vacancyID = 0;
		int studentID = 0;
		String stageID = "";
		String offerLetterFileName = "";
		
		if (!ServletFileUpload.isMultipartContent(request)) {
			throw new IllegalArgumentException(
					"Request is not multipart, please 'multipart/form-data' enctype for your form.");
		}
		
		ServletFileUpload uploadHandler = new ServletFileUpload(new DiskFileItemFactory());

		List<FileItem> items = null;
		File offerLetterFile = null;
		try {
			items = uploadHandler.parseRequest(request);
		} catch (FileUploadException e) {
			e.printStackTrace();
		}
		
		for (FileItem item: items) {
			
			System.out.println(item.toString());
			if (!item.isFormField()) {
				String fileExtension = "";
				
				if(item.getName().toString().toLowerCase().endsWith(".pdf")){
					fileExtension = ".pdf";
					System.out.println("The file is a PDF File");
				}
				
				if (!fileExtension.trim().isEmpty()) {
					System.out.println("The file is not Empty");

					UUID uuidName = UUID.randomUUID();
					offerLetterFile = new File(uploadFolder, uuidName.toString() + fileExtension);

					try {
						System.out.println("Saving image to Disk");
						item.write(offerLetterFile);
						System.out.println("Absolute Path id: "+offerLetterFile.getAbsoluteFile());
						offerLetterFileName = "/video/offer_letters/" + uuidName + fileExtension;
						System.out.println("FILE CREATED");
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
			
			if(item.getFieldName().equalsIgnoreCase("vacancy_id")){
				vacancyID = Integer.parseInt(item.getString());
			}
			else if (item.getFieldName().equalsIgnoreCase("stage_id")){
				stageID = item.getString();
				System.out.println("STAGE ID IS-> +stageID");
			}
			else if (item.getFieldName().equalsIgnoreCase("student_id")){
				studentID = Integer.parseInt(item.getString());
			}
		}
		
		String sql = "update jobs_event set action='"+offerLetterFileName+"' where actor_id="+studentID+" and vacancy_id="+vacancyID+" and status='Offered'";
		
		System.out.println(sql);
		DBUTILS utils = new DBUTILS();
		utils.executeUpdate(sql);
		
		System.out.println("OFFER LETTER UPLOADED");
			
		response.sendRedirect("/recruiter/jobs.jsp");
		
		}
}
