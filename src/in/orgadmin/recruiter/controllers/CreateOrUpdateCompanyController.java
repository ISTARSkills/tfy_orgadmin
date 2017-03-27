package in.orgadmin.recruiter.controllers;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebInitParam;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.lang.StringEscapeUtils;

import com.istarindia.apps.dao.Company;
import com.istarindia.apps.dao.CompanyDAO;
import com.istarindia.apps.dao.Pincode;
import com.istarindia.apps.dao.PincodeDAO;
import com.istarindia.apps.services.controllers.IStarBaseServelet;

import in.recruiter.services.RecruiterServices;

public class CreateOrUpdateCompanyController extends IStarBaseServelet {
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


	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		printParams(request);
		
		
		String companyName = "";
		String industryType = "";
		String companyProfile = null;
		String addressLineOne = "";
		String addressLineTwo = "";
		String pinCode = "";
		String companyImage = null ;
		String companyID = null;

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
			
			System.out.println(item.toString());
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
						companyImage = "/video/company_image/" + uuidName + fileExtension;
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
			else{
				
				if(item.getFieldName().equalsIgnoreCase("name")){
					companyName = StringEscapeUtils.escapeHtml(item.getString());
				}
				else if (item.getFieldName().equalsIgnoreCase("industry_type")){
					industryType = item.getString();
				}
				else if (item.getFieldName().equalsIgnoreCase("profile")){
					companyProfile = item.getString();
				}
				else if (item.getFieldName().equalsIgnoreCase("addressline1")){
					addressLineOne = StringEscapeUtils.escapeHtml(item.getString());
				}
				else if (item.getFieldName().equalsIgnoreCase("addressline2")){
					addressLineTwo = StringEscapeUtils.escapeHtml(item.getString());
				}
				else if (item.getFieldName().equalsIgnoreCase("pincode")){
					pinCode = item.getString();
				}
				else if(item.getFieldName().equalsIgnoreCase("company_id")){
					companyID = item.getString();
				}
			}
		}
		
		
		PincodeDAO pincodeDAO = new PincodeDAO();
		List<Pincode> pinCodes = pincodeDAO.findByPin(Integer.parseInt(pinCode));
		
		Pincode pinCodeOfCompany = pinCodes.get(0);
		
		String city = pinCodeOfCompany.getCity();
		String state = pinCodeOfCompany.getState();
		String country = pinCodeOfCompany.getCountry();
		
		
		System.out.println("Creating RecruiterService");
		RecruiterServices recruiterServices = new RecruiterServices();

		Company company;

		if(companyID==null){
			System.out.println("Creating company object");
			company = recruiterServices.createCompany(addressLineOne, addressLineTwo, state, city, country, Integer.parseInt(pinCode), companyName, industryType, companyProfile, companyImage);
		}
		else{
			CompanyDAO companyDAO = new CompanyDAO();
			company = companyDAO.findById(Integer.parseInt(companyID));
			companyImage = companyImage==null?company.getImage():companyImage;
			companyProfile = companyProfile==null?company.getCompany_profile():companyProfile;
			
			System.out.println("Updating company details");
			company = recruiterServices.updateCompany(company.getId(),addressLineOne, addressLineTwo, state, city, country, Integer.parseInt(pinCode), companyName, industryType, companyProfile, companyImage);
		}
		
		response.sendRedirect("/orgadmin/company/company_list.jsp");
	}

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
	}

}
