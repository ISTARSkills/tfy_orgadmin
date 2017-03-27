package in.orgadmin.orgadmin.controller;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.File;
import java.util.ArrayList;
import java.util.Iterator;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import com.istarindia.apps.services.controllers.IStarBaseServelet;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;

/**
 * Servlet implementation class UserBulkUpload
 */
@MultipartConfig(location = "C:/Users/Sumanth/Videos", fileSizeThreshold = 512 * 512, maxFileSize = 512 * 512 * 5, maxRequestSize = 512 * 512 * 5 * 5)

@WebServlet("/UserBulkUpload")
public class UserBulkUpload extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
	private boolean isMultipart;
   
	

    /**
     * @see HttpServlet#HttpServlet()
     */
    public UserBulkUpload() {
        super();
       
    }

	
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
    	printParams(request);
    	
    	
    	
}
		
	

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		

	 	
	     if (!ServletFileUpload.isMultipartContent(request)) {
	         throw new IllegalArgumentException("Request is not multipart, please 'multipart/form-data' enctype for your form.");
	     }

	     ServletFileUpload uploadHandler = new ServletFileUpload(new DiskFileItemFactory());
	     PrintWriter writer = response.getWriter();
	     StringBuffer out = new StringBuffer();
	   
	     System.out.println(new File(request.getServletContext().getRealPath("/")+"img/"));
	     
	     try {
				// Parse the request
				List items = uploadHandler.parseRequest(request);
				Iterator iterator = items.iterator();
				while (iterator.hasNext()) {
					FileItem item = (FileItem) iterator.next();
					if (!item.isFormField()) {
						String fileName = item.getName();
						String root = getServletContext().getRealPath("/");
						File path = new File(root + "/uploads");
						if (!path.exists()) {
							boolean status = path.mkdirs();
						}

						File uploadedFile = new File(path + "/" + fileName);
						System.out.println(uploadedFile.getAbsolutePath());
						item.write(uploadedFile);

						ArrayList<ArrayList<String>> excelData = readExcelData(uploadedFile.getAbsolutePath());
						
						ArrayList<String> headers  = excelData.get(0);

						
						ArrayList<String > cols_from_table = new ArrayList<>();
						cols_from_table.add("EMAIL");
						cols_from_table.add("NAME");
						cols_from_table.add("GENDER");
						cols_from_table.add("MOBILE");
						
						for(int i =0;  i <cols_from_table.size();i++){
						
						out.append("<div class='form-group'>"
								+ "<label class='col-sm-2 control-label'>"+ cols_from_table.get(i)+"</label>"
								+ "<div class='col-sm-10'>"
								+ "<select class='form-control m-b' id='xldata"+i+"' name='xldata'>");
								
								for(String str : headers)
								{
									out.append("<option value="+str+">"+str.toUpperCase()+"</option>");
									
									
								}
								
								
							out.append("</select></div></div><div class='hr-line-dashed'></div>"
								);
							
							
							
						}
						
						
				
					 }
				}
			} catch (FileUploadException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
	     
	           response.getWriter().print(out);
		}
	         
	      





	public static ArrayList<ArrayList<String>> readExcelData(String fileName) {
		
	    ArrayList<ArrayList<String>> celllisting = new ArrayList<>();
		
	  
	    
		try {
			FileInputStream file = new FileInputStream(new File(fileName));
			
			
			HSSFWorkbook workbook = new HSSFWorkbook(file);
			HSSFSheet sheet = workbook.getSheetAt(0);
			
			Row header = sheet.getRow(0);
		        int n = header.getLastCellNum();
		        for(int i=0; i<n; i++){
		        	System.out.println(header.getCell(i).getStringCellValue());}
		       
		 
		        Iterator<Row> rowIterator = sheet.iterator();
			while (rowIterator.hasNext()) {
				Row row = rowIterator.next();
				
				
				Iterator<Cell> cellIterator = row.cellIterator();
			
				
				//if (row.getRowNum() != 0) {
					ArrayList<String> temp = new ArrayList<>();

					while (cellIterator.hasNext()) {
						
						Cell cell = cellIterator.next();
					
						
						switch (cell.getCellType()) {
						case HSSFCell.CELL_TYPE_NUMERIC:
							cell.setCellType(Cell.CELL_TYPE_STRING);
							temp.add(cell.getStringCellValue() + "");
							break;
						case HSSFCell.CELL_TYPE_STRING:
							temp.add(cell.getStringCellValue());
							break;
							
						case HSSFCell.CELL_TYPE_BLANK:
							temp.add("");

							break;

						}
					}
					celllisting.add(temp);			
				//}
			}
			file.close();
		} catch (Exception e) {
			e.printStackTrace();
		}		 
		return celllisting;				
	}

 public    StringBuffer getColumnForStudentUpload()
 {
	 StringBuffer sb = new StringBuffer();
	 
	 ArrayList<String> columns = new ArrayList<>();
	 columns.add("");
	 columns.add("");
	 columns.add("");
	 columns.add("");
	 
	
	 for(String str : columns)
	 {
		 sb.append("<option value='"+str+"'>"+str.toUpperCase()+"</option>"); 
	 }

	 return sb;
 }
}