import java.io.File;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import javax.mail.MessagingException;
import javax.mail.internet.AddressException;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.viksitpro.core.dao.entities.BaseHibernateDAO;
import com.viksitpro.core.dao.entities.BatchGroup;
import com.viksitpro.core.dao.entities.BatchGroupDAO;
import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.Organization;
import com.viksitpro.core.dao.entities.OrganizationDAO;
import com.viksitpro.core.dao.entities.UserOrgMapping;
import com.viksitpro.core.dao.entities.UserRole;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.EmailUtils;

import in.orgadmin.admin.services.EmailService;
import in.orgadmin.utils.report.CustomReport;
import in.orgadmin.utils.report.CustomReportList;
import in.orgadmin.utils.report.ReportUtils;
import in.talentify.core.utils.CMSRegistry;
import in.talentify.core.utils.EmailSendingUtility;


public class MAIN {
	
	
	public static void main(String[] args) {

		/*ReportUtils util = new ReportUtils();
		HashMap<String, String> conditions = new HashMap();
		
		
		
		  String course_id="3";
		 conditions.put("course_id", course_id); 
		  String college_id="3";
		 conditions.put("college_id", college_id+"");
		  getAttendanceGraph(3052, conditions);
		//checkingReportUtils();
		//nosense();
*/
		
		dapoooo();
		asdas();
	}
	
	
	private static void asdas() {
		// TODO Auto-generated method stub
		Organization org = new OrganizationDAO().findById(2);
		for(BatchGroup bg : org.getBatchGroups())
		{
			if(bg.getBatchStudentses().size()>0){
			System.out.println(bg.getName()+ " "+bg.getId()+" "+bg.getType());
			
			}
		}
	}


	private static void dapoooo() {
		Organization college = new OrganizationDAO().findById(2);
		//String sql="SELECT id,email,gender,CAST (mobile AS INTEGER),name FROM org_admin where organization_id="+org_id;
		for(UserOrgMapping userOrg : college.getUserOrgMappings())
		{
			for(UserRole  userRole : userOrg.getIstarUser().getUserRoles())
			{
				if(userRole.getRole().getRoleName().equalsIgnoreCase("ORG_ADMIN"))
				{
					IstarUser orgadmin = userRole.getIstarUser(); 
					System.out.println(userRole.getIstarUser());
					System.out.println(orgadmin.getId());
					System.out.println(orgadmin.getEmail());
					System.out.println();
					System.out.println();
					System.out.println();
					System.out.println();
					System.out.println();
					System.out.println();
					System.out.println();
					
				/*	orgAdminId=orgadmin.getId()+"";
					orgAdminEmail=orgadmin.getEmail();
					orgAdminMobile=orgadmin.getMobile()+"";
					if(orgadmin.getUserProfile()!=null){
					orgAdminGender=orgadmin.getUserProfile().getGender();					
					orgAdminFirstName = orgadmin.getUserProfile().getFirstName();	
					orgAdminLastName = orgadmin.getUserProfile().getLastName();*/
					}
				}
			}
		
		System.out.println("done");
		}
		
	


	public static CustomReport getReport(int reportID) {
		CustomReportList reportCollection = new CustomReportList();
		CustomReport report = new CustomReport();
		try {
			URL url = (new CMSRegistry()).getClass().getClassLoader().getResource("custom_report_list.xml");
			File file = new File(url.toURI());
			JAXBContext jaxbContext = JAXBContext.newInstance(CustomReportList.class);
			Unmarshaller jaxbUnmarshaller = jaxbContext.createUnmarshaller();
			reportCollection = (CustomReportList) jaxbUnmarshaller.unmarshal(file);

		} catch (URISyntaxException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (JAXBException e) {
			e.printStackTrace();
		}
		
		for (CustomReport r : reportCollection.getCustomReports()) {
			if (r.getId() == reportID) {
				report = r;
			}
		}
		return report;
	}
	
public static StringBuffer getAttendanceGraph(int reportID,HashMap<String, String> conditions){
		
		DBUTILS dbutils = new DBUTILS();
		StringBuffer out = new StringBuffer();
		
		
		String id = UUID.randomUUID().toString();
		out.append("<div class='graph_holder' id='graph_container_"+id+"' ></div> ");
		out.append("<table style='display:none' class='data_holder datatable_report' data-graph_containter='graph_container_"+id+"' data-y_axis_title='' data-report_title='' "
				+ " data-graph_holder='container" + id + "' id='chart_datatable_"+id+"'");
		out.append(" data-graph_type='area'>");	
		CustomReport report = getReport(reportID) ;
		String sql9 = report.getSql();
		for(String key : conditions.keySet())
		{
			sql9 = sql9.replaceAll(":"+key, conditions.get(key));
		}	
		ArrayList<String> batchNames = new ArrayList<>();
		ArrayList<String> createdAt = new ArrayList<>();
		List<HashMap<String, Object>> attendance_view = dbutils.executeQuery(sql9);
		HashMap<String, Integer> created_attendance = new HashMap<>();
		out.append(" <thead><tr>");	
		for(HashMap<String, Object>  rows : attendance_view)
		{
			if(!batchNames.contains(rows.get("batchname")))
			{
				batchNames.add(rows.get("batchname").toString());
				
			}
		}
		
		for(HashMap<String, Object>  rows : attendance_view)
		{
			if(!createdAt.contains(rows.get("created_at")))
			{
				createdAt.add(rows.get("created_at").toString());
			}
		}
		
		for(int i=0;i<batchNames.size();i++){
			
			out.append("<th>"+batchNames.get(i).trim()+"</th>");
		}
		out.append("</tr> </thead>");	
		out.append(" <tbody>");
		
		
			
			
			
			for(HashMap<String, Object>  rows1 : attendance_view)
			{
				out.append(" <tr>");
				for(int j = 0; j<createdAt.size();j++){
				
				System.out.println(createdAt.get(j)+"--"+rows1.get("created_at").toString());
				if(createdAt.get(j) == rows1.get("created_at").toString()){
					
					out.append( "<td>"+rows1.get("attendance")+"</td>");
					
				}else{
					out.append(" <tr><td>"+rows1.get("created_at")+"</td> ");
					  out.append( "<td>"+rows1.get("attendance")+"</td>");
				}
				
			}
			out.append( "</tr>");
		}
		
		out.append("</tbody></table>");
		
		//System.out.println(out);
		return out;
		
		
	}
	

	private static void nosense() {
		String sql1="	SELECT 	batch_group. NAME, 	CAST ( 		(SUM(master) * 100) / COUNT (*) AS INTEGER 	) AS master, 	CAST ( 		(SUM(rookie) * 100) / COUNT (*) AS INTEGER 	) AS rookie, 	CAST ( 		(SUM(apprentice) * 100) / COUNT (*) AS INTEGER 	) AS apprentice, 	CAST ( 		(SUM(wizard) * 100) / COUNT (*) AS INTEGER 	) AS wizard FROM 	mastery_level_per_course, 	batch_group WHERE 	mastery_level_per_course.college_id =:college_id AND course_id =:course_id AND batch_group. ID = mastery_level_per_course.batch_group_id GROUP BY 	batch_group. NAME";
		Transaction tx = null;
		Session session = new BaseHibernateDAO().getSession();
		try {
			tx = session.beginTransaction();
			SQLQuery query = session.createSQLQuery(sql1);
			HashMap<String, String> conditions = new HashMap<>();
			conditions.put("course_id", "3");
			conditions.put("college_id", "3");
			for (String key : conditions.keySet()) {
				try {
					if (sql1.contains(key)) {
						System.out.println("key->" + key + "   value-> " + conditions.get(key));						
						//query.setParameter("course_id", Integer.parseInt(conditions.get(key)));
						query.setParameter("course_id", "3");
						query.setParameter("college_id", "3");
					}
				} catch (Exception e) {
					e.printStackTrace();
					query.setParameter(key, conditions.get(key));
				}
			}
			sql1= query.getQueryString();
			System.out.println("finalSql >>"+sql1);
		} catch (HibernateException e) {
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}				
		
	}

	private static void checkingReportUtils() {
		// TODO Auto-generated method stub
		
		//System.out.println("1>>>"+(new CMSRegistry()).getClass().getClassLoader());
		//System.out.println("2>>>"+(new CMSRegistry()).getClass().getClassLoader().getResource("report_list.xml"));
		ReportUtils utils = new ReportUtils();
		HashMap<String, String> conditions = new HashMap<>();
		
		System.err.println(utils.getHTML(3052, conditions));;
		
		/*int totalStudent=50;
		int nintyPercent = (int)(.9* totalStudent);		
		System.out.println(nintyPercent);
		
		
		double r = Math.random()*0.8;
		System.out.println(r);*/
	}
}
