package in.orgadmin.orgadmin.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.lang.StringEscapeUtils;

import com.istarindia.apps.dao.College;
import com.istarindia.apps.dao.CollegeDAO;
import com.istarindia.apps.dao.Company;
import com.istarindia.apps.dao.CompanyDAO;
import com.istarindia.apps.dao.DBUTILS;
import com.istarindia.apps.dao.Organization;
import com.istarindia.apps.dao.OrganizationDAO;
import com.istarindia.apps.dao.Pincode;
import com.istarindia.apps.dao.PincodeDAO;
import com.istarindia.apps.services.controllers.IStarBaseServelet;

import in.recruiter.services.RecruiterServices;

import java.io.File;

public class UpdateOrganizationDetails extends IStarBaseServelet {
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
       
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printParams(request);
		
		
		String collegeName = "";
		String industryType = "EDUCATION";
		String collegeProfile = null;
		String addressLineOne = "";
		String addressLineTwo = "";
		String pinCode = "";
		String collegeImage = null ;
		String collegeID = null;
		String numberOfStudents = null;
				
		if (!ServletFileUpload.isMultipartContent(request)) {
			throw new IllegalArgumentException(
					"Request is not multipart, please 'multipart/form-data' enctype for your form.");
		}
		
		ServletFileUpload uploadHandler = new ServletFileUpload(new DiskFileItemFactory());

		List<FileItem> items = null;
		File imageFile = null;
		try {
			items = uploadHandler.parseRequest(request);
		} catch (FileUploadException e) {
			e.printStackTrace();
		}

		for (FileItem item : items) {
			
			if (!item.isFormField()) {
				String fileExtension = "";
				
				if(item.getName().toString().toLowerCase().endsWith(".png")){
					fileExtension = ".png";
				}else if (item.getName().toString().toLowerCase().endsWith(".jpg")){
					fileExtension = ".jpg";
				}else if(item.getName().toString().toLowerCase().endsWith(".jpeg")){
					fileExtension = ".jpeg";
				}
				
				
				if (!fileExtension.trim().isEmpty()) {
					System.out.println("The file is an Image");

					UUID uuidName = UUID.randomUUID();
					imageFile = new File(uploadFolder, uuidName.toString() + fileExtension);

					try {
						System.out.println("Saving image to Disk");
						
						item.write(imageFile);
						System.out.println("Absolute Path id: "+imageFile.getAbsoluteFile());
						collegeImage = "/video/company_image/" + uuidName + fileExtension;
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}else{
				
				if(item.getFieldName().equalsIgnoreCase("name")){
					collegeName = StringEscapeUtils.escapeHtml(item.getString());
				}
				else if (item.getFieldName().equalsIgnoreCase("addressline1")){
					addressLineOne = item.getString();
				}else if (item.getFieldName().equalsIgnoreCase("addressline2")){
					addressLineTwo = item.getString();
				}else if (item.getFieldName().equalsIgnoreCase("pincode")){
					pinCode = item.getString();
				}else if (item.getFieldName().equalsIgnoreCase("companyprofile")){
					collegeProfile = item.getString();
				}else if (item.getFieldName().equalsIgnoreCase("numberOfStudents")){
					numberOfStudents = item.getString();
				}else if (item.getFieldName().equalsIgnoreCase("college_id")){
					collegeID = item.getString();
				}else if (item.getFieldName().equalsIgnoreCase("profile")){
					collegeProfile = item.getString();
				}
			}
		}
		
		PincodeDAO pincodeDAO = new PincodeDAO();
		List<Pincode> pinCodes = pincodeDAO.findByPin(Integer.parseInt(pinCode));
		
		Pincode pinCodeOfCollege = pinCodes.get(0);
		
		String city = pinCodeOfCollege.getCity();
		String state = pinCodeOfCollege.getState();
		String country = pinCodeOfCollege.getCountry();
		
		
		System.out.println("Creating RecruiterService");
		RecruiterServices recruiterServices = new RecruiterServices();

		College college;

		if(collegeID==null){
			System.out.println("Creating college object");
			college = recruiterServices.createCollege(addressLineOne, addressLineTwo, state, city, country, Integer.parseInt(pinCode), collegeName, industryType, collegeProfile, collegeImage, numberOfStudents);
		
			response.sendRedirect("/orgadmin/dashboard.jsp");
		
		}
		else{
			CollegeDAO collegeDAO = new CollegeDAO();
			college = collegeDAO.findById(Integer.parseInt(collegeID));
			collegeImage = collegeImage==null?college.getImage():collegeImage;
			collegeProfile = collegeProfile==null?college.getCompany_profile():collegeProfile;
			
			System.out.println("Updating company details");
			college = recruiterServices.updateCollege(college.getId(),addressLineOne, addressLineTwo, state, city, country, Integer.parseInt(pinCode), collegeName, industryType, collegeProfile, collegeImage, numberOfStudents);
			
			response.sendRedirect("/orgadmin/organization/edit_organization.jsp?org_id="+college.getId());
		
		}
		
		
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
