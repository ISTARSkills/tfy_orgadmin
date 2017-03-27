package in.orgadmin.services;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.collections.CollectionUtils;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.istarindia.apps.UserTypes;
import com.istarindia.apps.dao.Campaigns;
import com.istarindia.apps.dao.College;
import com.istarindia.apps.dao.CollegeDAO;
import com.istarindia.apps.dao.CollegeRecruiter;
import com.istarindia.apps.dao.CollegeRecruiterDAO;
import com.istarindia.apps.dao.Company;
import com.istarindia.apps.dao.CompanyDAO;
import com.istarindia.apps.dao.IstarUser;
import com.istarindia.apps.dao.IstarUserDAO;
import com.istarindia.apps.dao.Recruiter;
import com.istarindia.apps.dao.RecruiterDAO;

import in.orgadmin.utils.EmailUtils;

public class InviteUser {

	/**
	 * This method is used by the Placement Officer to invite a Recruiter. If
	 * the recruiter does not exists a new Recruiter is created and email is
	 * sent along with auto generated password. An entry to CollegeRecruiter is
	 * made for invitation and an email is sent to the recruiter.
	 * 
	 * @param recruiterName
	 *            The name of the recruiter to be invited
	 * @param recruiterEmail
	 *            The email of the recruiter to be invited
	 * @param companyID
	 *            The company Id if the recruiter is a new user, else the
	 *            company of the recruiter will be selected
	 * @param palcementOfficerCollegeID
	 *            The college Id of the Placement Officer who is sending an
	 *            invite.
	 * 
	 * @return This method returns nothing
	 */
	public String inviteCollegeRecruiter(String recruiterName, String recruiterEmail, int companyID,
			int palcementOfficerCollegeID) {

		String result = "";
		
		Recruiter recruiter;
		Company recruiterCompany;

		RecruiterDAO recruiterDAO = new RecruiterDAO();
		
		IstarUserDAO istarUserDAO = new IstarUserDAO();
		
		List<IstarUser> userList = istarUserDAO.findByEmail(recruiterEmail);

		CollegeRecruiterDAO collegeRecruiterDAO = new CollegeRecruiterDAO();
		CollegeRecruiter collegeRecruiter = new CollegeRecruiter();

		CollegeDAO collegeDAO = new CollegeDAO();
		College college = collegeDAO.findById(palcementOfficerCollegeID);

		if (!userList.isEmpty()) {
			
			String userType = userList.get(0).getUserType();
			
			if(userType.equalsIgnoreCase(UserTypes.RECRUITER)){
				recruiter = (Recruiter) userList.get(0);
				
				List<CollegeRecruiter> existingCollegeRecruiterForCollege = (List<CollegeRecruiter>) collegeRecruiterDAO.findByProperty("college", college);
				List<CollegeRecruiter> existingCollegeRecruiterForRecruiter = (List<CollegeRecruiter>) collegeRecruiterDAO.findByProperty("recruiter", recruiter);
				
				List<CollegeRecruiter> commonCollegeRecruiter = new ArrayList<CollegeRecruiter>();
				
				commonCollegeRecruiter = (List<CollegeRecruiter>) CollectionUtils.intersection(existingCollegeRecruiterForCollege, existingCollegeRecruiterForRecruiter);
				
				if(commonCollegeRecruiter.size() > 0){
					result = "An invitation has already been sent to this recruiter from your college";
					System.out.println(result);
					return result;
				}
				
				recruiterCompany = recruiter.getCompany();
			}else{
			System.out.println("User already exists");
			result = "Oops! The specified email address belongs to somebody else. Please provide a valid email address.";
			System.out.println(result);
			return result;
			}
		} 
		else {
			recruiter = new Recruiter();

			CompanyDAO companyDAO = new CompanyDAO();
			recruiterCompany = companyDAO.findById(companyID);

			recruiter.setName(recruiterName);
			recruiter.setEmail(recruiterEmail);
			recruiter.setCompany(recruiterCompany);
			recruiter.setPassword("test1234");
			recruiter.setUserType("RECRUITER");
			recruiter.setRecruiterType("NORMAL");

			Session recruiterSession = recruiterDAO.getSession();

			System.out.println("Adding New Recruiter");
			Transaction recruiterTransaction = null;
			try {
				recruiterTransaction = recruiterSession.beginTransaction();
				recruiterDAO.save(recruiter);
				recruiterTransaction.commit();

				String subjectNewRecruiter = "Thanks you registering";
				String messageNewRecruiter = "Hi " + recruiterName + ", Your user id is: " + recruiterEmail
						+ " and password is test123.";
				EmailUtils.sendEmail(recruiterEmail, subjectNewRecruiter, messageNewRecruiter);

			} catch (HibernateException e) {
				if (recruiterTransaction != null)
					recruiterTransaction.rollback();
				e.printStackTrace();
			} finally {
				recruiterSession.flush();
				recruiterSession.close();
			}

		}

		System.out.println("Adding CollegeRecruiter");

		collegeRecruiter.setCollege(college);
		collegeRecruiter.setRecruiter(recruiter);

		Session collegeRecruiterSession = collegeRecruiterDAO.getSession();

		Transaction collegeRecruiterTransaction = null;
		try {
			collegeRecruiterTransaction = collegeRecruiterSession.beginTransaction();
			collegeRecruiterDAO.save(collegeRecruiter);
			collegeRecruiterTransaction.commit();

			String subjectInviteRecruiter = "Invitation";
			String messageInviteRecruiter = "Hi " + recruiterName + ", You've been invited for recruitment at "
					+ college.getName() + " for placements.";
			EmailUtils.sendEmail(recruiterEmail, subjectInviteRecruiter, messageInviteRecruiter);

		} catch (HibernateException e) {
			if (collegeRecruiterTransaction != null)
				collegeRecruiterTransaction.rollback();
			e.printStackTrace();
		} finally {
			collegeRecruiterSession.flush();
			collegeRecruiterSession.close();
		}

		result = "Thanks! A notification has been sent to the recruiter.";
		System.out.println(result);
		return result;
	}

	public void AddRecruiterBySuperAdmin(String recruiterName, String recruiterEmail, int companyID) {
		
		Recruiter recruiter;
		Company recruiterCompany;

		RecruiterDAO recruiterDAO = new RecruiterDAO();
		List<Recruiter> recruiterList = recruiterDAO.findByEmail(recruiterEmail);

		if (!recruiterList.isEmpty()) {
			System.out.println("Recruiter already exists");

			recruiter = recruiterList.get(0);
			recruiterCompany = recruiter.getCompany();

		} else {
			recruiter = new Recruiter();

			CompanyDAO companyDAO = new CompanyDAO();
			recruiterCompany = companyDAO.findById(companyID);

			recruiter.setName(recruiterName);
			recruiter.setEmail(recruiterEmail);
			recruiter.setCompany(recruiterCompany);
			recruiter.setPassword("test1234");
			recruiter.setUserType("RECRUITER");
			recruiter.setRecruiterType("NORMAL");

			Session recruiterSession = recruiterDAO.getSession();

			System.out.println("Adding New Recruiter");
			Transaction recruiterTransaction = null;
			try {
				recruiterTransaction = recruiterSession.beginTransaction();
				recruiterDAO.save(recruiter);
				recruiterTransaction.commit();

				String subjectNewRecruiter = "Thanks you registering";
				String messageNewRecruiter = "Hi " + recruiterName + ", Your user id is: " + recruiterEmail
						+ " and password is test123.";
				EmailUtils.sendEmail(recruiterEmail, subjectNewRecruiter, messageNewRecruiter);

			} catch (HibernateException e) {
				if (recruiterTransaction != null)
					recruiterTransaction.rollback();
				e.printStackTrace();
			} finally {
				recruiterSession.flush();
				recruiterSession.close();
			}

		}
	}
}
