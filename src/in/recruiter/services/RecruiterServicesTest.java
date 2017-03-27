/**
 * 
 */
package in.recruiter.services;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.UUID;

import javax.mail.MessagingException;
import javax.mail.internet.AddressException;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.istarindia.app.metadata.services.MetadataServices;
import com.istarindia.apps.dao.BatchGroup;
import com.istarindia.apps.dao.BatchGroupDAO;
import com.istarindia.apps.dao.BatchStudents;
import com.istarindia.apps.dao.College;
import com.istarindia.apps.dao.CollegeDAO;
import com.istarindia.apps.dao.CollegeRecruiter;
import com.istarindia.apps.dao.CollegeRecruiterDAO;
import com.istarindia.apps.dao.Company;
import com.istarindia.apps.dao.CompanyDAO;
import com.istarindia.apps.dao.IstarTaskType;
import com.istarindia.apps.dao.IstarTaskTypeDAO;
import com.istarindia.apps.dao.IstarTaskWorkflow;
import com.istarindia.apps.dao.Recruiter;
import com.istarindia.apps.dao.RecruiterDAO;
import com.istarindia.apps.dao.Student;
import com.istarindia.apps.dao.StudentDAO;
import com.istarindia.apps.dao.Vacancy;
import com.istarindia.apps.dao.VacancyDAO;

import in.orgadmin.utils.EmailUtils;

/**
 * @author ComplexObject
 *
 */
public class RecruiterServicesTest {
	public static void main(String[] args) {
		int batch_group_id = 98;
		int vacancy_id=2;
		String stage= "TARGETED";
		generateJobsData( batch_group_id, vacancy_id,  stage);
	}
	
	private static void generateJobsData(int batch_group_id, int vacancy_id, String stage) {		
		BatchGroup bg = new BatchGroupDAO().findById(batch_group_id);
		Vacancy vacancy = new VacancyDAO().findById(vacancy_id);
		ArrayList<Integer> already_added_student =  new ArrayList<>();
		RecruiterServices serv = new RecruiterServices();
		Date d = new Date();
		for(BatchStudents bs : bg.getBatchStudentses())
		{
			if(!already_added_student.contains(bs.getStudent().getId()))
			{
				already_added_student.add(bs.getStudent().getId());
				Student student = bs.getStudent();
				serv.createJobsEventForEachStudent(d, 2, 40, vacancy.getRecruiter().getId(), vacancy_id, vacancy.getIstarTaskType().getId().toString(),stage, student);

			}
		}
		System.out.println("Jobs has been created");
	}

	/*private static void testStudentProfile() {
		SimpleDateFormat date = new SimpleDateFormat("dd-MM-yyyy");
		Student student = new StudentDAO().findById(449);
		String firstname = "Vinay";
		String lastname= "sharma";
		Date dob = new Date();
		MetadataServices serv = new MetadataServices();
		try {
			dob = date.parse("17-02-2016");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Long mobileno= 1234567891l;
		String gender= "Male";
		Integer pincode= 560055;
		Long aadharno= 123456789120l;
		String email= "vinay@istarindia.com";
		Float marks_10= 77f;
		Float marks_12= 77f;
		Integer yop_10 = 2010;
		Integer yop_12 = 2012;
		Boolean has_under_graduation = true;
		String under_graduation_specialization_name = "B.E.";
		Float under_gradution_marks = 86f;
		Boolean has_post_graduation = true;
		String post_graduation_specialization_name = "MBA";
		Float post_gradution_marks = 70f;
		Boolean is_studying_further_after_degree = true;
		String job_sector = "IT";
		String preferred_location = "Bhopal,Bangalore";
		String company_name = "ABCD";
		String position= "Known";
		String duration = "XYZ";
		String description = "qwerty";
		String interested_in_type_of_course = "PG";
		String image_url_10 = "fffffff"; 
		String image_url_12 = "ggggggggggg";
		String area_of_interest = "Software";
		String profile_image = "ssssssssss";
		String dob1 = dob.toString();
		serv.saveStudentProfile(student, firstname, lastname, dob1, mobileno, gender, pincode, aadharno, email, yop_10, marks_10,
				yop_12, marks_12, has_under_graduation, under_graduation_specialization_name, under_gradution_marks, has_post_graduation,
				post_graduation_specialization_name, post_gradution_marks, is_studying_further_after_degree, job_sector, preferred_location,
				company_name, position, duration, description, interested_in_type_of_course, area_of_interest, image_url_10, image_url_12,
				profile_image, "BCA", "MCA");
		System.out.println("done");
		
	}
	
	*/

}
