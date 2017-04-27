import java.util.ArrayList;
import java.util.HashMap;

import javax.mail.MessagingException;
import javax.mail.internet.AddressException;

import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.viksitpro.core.dao.entities.BaseHibernateDAO;
import com.viksitpro.core.dao.entities.BatchGroup;
import com.viksitpro.core.dao.entities.BatchGroupDAO;
import com.viksitpro.core.dao.entities.Organization;
import com.viksitpro.core.dao.entities.OrganizationDAO;
import com.viksitpro.core.utilities.EmailUtils;

import in.orgadmin.admin.services.EmailService;
import in.orgadmin.utils.report.ReportUtils;
import in.talentify.core.utils.CMSRegistry;
import in.talentify.core.utils.EmailSendingUtility;


public class MAIN {
	
	
	public static void main(String[] args) {

		
		
		/**/
		
		checkingReportUtils();
		//nosense();

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
		
		System.err.println(utils.getHTML(3048, conditions));;
		
		/*int totalStudent=50;
		int nintyPercent = (int)(.9* totalStudent);		
		System.out.println(nintyPercent);
		
		
		double r = Math.random()*0.8;
		System.out.println(r);*/
	}
}
