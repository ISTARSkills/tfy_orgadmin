/**
 * 
 */
package tfy.admin.trainer;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;

import com.istarindia.android.pojo.AssessmentResponsePOJO;
import com.istarindia.android.pojo.QuestionResponsePOJO;
import com.viksitpro.core.dao.entities.AssessmentOption;
import com.viksitpro.core.dao.entities.BaseHibernateDAO;
import com.viksitpro.core.dao.entities.StudentAssessment;

/**
 * @author mayank
 *
 */
public class TrainerReportService {

	public List<StudentAssessment> getStudentAssessmentForUser(int istarUserId, int assessmentId) {
System.out.println("dddddddd"+assessmentId+" yyy"+istarUserId);
		List<StudentAssessment> allStudentAssessment = new ArrayList<StudentAssessment>();

		String hql = "from StudentAssessment studentAssessment where assessment.id= :assessment and istarUser.id= :istarUser";

		BaseHibernateDAO baseHibernateDAO = new BaseHibernateDAO();
		Session session = baseHibernateDAO.getSession();

		Query query = session.createQuery(hql);
		query.setParameter("assessment", assessmentId);
		query.setParameter("istarUser", istarUserId);
		
		allStudentAssessment = query.list();

		return allStudentAssessment;
	}
	
	public AssessmentResponsePOJO getAssessmentResponseOfUser(int assessmentId, int istarUserId) {

		AssessmentResponsePOJO assessmentResponsePOJO = null;
		
		List<StudentAssessment> allStudentAssessments = getStudentAssessmentForUser(istarUserId, assessmentId);
		List<QuestionResponsePOJO> allQuestionsResponse = new ArrayList<QuestionResponsePOJO>();

		System.out.println("allStudentAssessments>>>>>>."+allStudentAssessments);
		if (allStudentAssessments.size() > 0) {
			assessmentResponsePOJO = new AssessmentResponsePOJO();
			for (StudentAssessment studentAssessment : allStudentAssessments) {
				QuestionResponsePOJO questionResponsePOJO = new QuestionResponsePOJO();
				List<Integer> markedOptions = new ArrayList<Integer>();
				questionResponsePOJO.setQuestionId(studentAssessment.getQuestion().getId());

				List<AssessmentOption> allOptionsOfQuestion = new ArrayList<AssessmentOption>(
						studentAssessment.getQuestion().getAssessmentOptions());

				for (int i = 0; i < allOptionsOfQuestion.size(); i++) {
					if (i == 0 && studentAssessment.getOption1()) {
						markedOptions.add(allOptionsOfQuestion.get(i).getId());
					}

					if (i == 1 && studentAssessment.getOption2()) {
						markedOptions.add(allOptionsOfQuestion.get(i).getId());
					}

					if (i == 2 && studentAssessment.getOption3()) {
						markedOptions.add(allOptionsOfQuestion.get(i).getId());
					}

					if (i == 3 && studentAssessment.getOption4()) {
						markedOptions.add(allOptionsOfQuestion.get(i).getId());
					}

					if (i == 4 && studentAssessment.getOption5()) {
						markedOptions.add(allOptionsOfQuestion.get(i).getId());
					}
				}
				questionResponsePOJO.setOptions(markedOptions);
				questionResponsePOJO.setDuration(studentAssessment.getTimeTaken());
				allQuestionsResponse.add(questionResponsePOJO);
			}
			assessmentResponsePOJO = new AssessmentResponsePOJO();
			assessmentResponsePOJO.setId(assessmentId);
			assessmentResponsePOJO.setResponse(allQuestionsResponse);
		}
		return assessmentResponsePOJO;
	}
}
