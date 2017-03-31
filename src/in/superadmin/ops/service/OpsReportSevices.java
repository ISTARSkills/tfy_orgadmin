package in.superadmin.ops.service;

import java.util.HashMap;
import java.util.List;

import com.viksitpro.core.utilities.DBUTILS;

public class OpsReportSevices {

	DBUTILS dbutils = new DBUTILS();

	public StringBuffer getStudentReportDetailsForTable(int assessmentId, int batchId) {
		String sql = "SELECT 	TFINAL.user_id AS student_id, 	TFINAL.first_name AS student_name, 	TFINAL.score AS score, 	TFINAL.percentage AS percentage, 	( 		CASE 		WHEN TFINAL.percentage LIKE 'Absent' THEN 			'Absent' 		WHEN ( 			CAST (TFINAL.percentage AS INTEGER) >= 75 			AND CAST (TFINAL.percentage AS INTEGER) <= 100 		) THEN 			'A+' 		WHEN ( 			CAST (TFINAL.percentage AS INTEGER) >= 60 			AND CAST (TFINAL.percentage AS INTEGER) < 75 		) THEN 			'A' 		WHEN ( 			CAST (TFINAL.percentage AS INTEGER) >= 40 			AND CAST (TFINAL.percentage AS INTEGER) < 60 		) THEN 			'B+' 		WHEN ( 			CAST (TFINAL.percentage AS INTEGER) < 40 		) THEN 			'B' 		END 	) AS grade FROM 	( 		SELECT DISTINCT 			user_profile.user_id, 			user_profile.first_name, 			( 				CASE 				WHEN report.score IS NOT NULL THEN 					CAST (report.score AS VARCHAR) 				ELSE 					'Absent' 				END 			) AS score, 			CAST ( 				( 					CASE 					WHEN report.score IS NULL THEN 						'Absent' 					ELSE 						CAST ( 							(report.score * 100) / ( 								SELECT 									COUNT (DISTINCT questionid) 								FROM 									assessment_question 								WHERE 									assessmentid = "
				+ assessmentId
				+ " 							) AS VARCHAR 						) 					END 				) AS VARCHAR 			) AS percentage 		FROM 			user_profile 		LEFT JOIN report ON ( 			user_profile.user_id = report.user_id 			AND report.assessment_id = "
				+ assessmentId
				+ " 		) 		WHERE 			user_profile.user_id IN ( 				SELECT DISTINCT 					batch_students.student_id 				FROM 					batch_students, 					batch 				WHERE 					batch_students.batch_group_id = batch.batch_group_id 				AND batch. ID = "
				+ batchId + " 			) 	) TFINAL ORDER BY 	user_id, 	first_name";
		List<HashMap<String, Object>> data = dbutils.executeQuery(sql);
		StringBuffer out = new StringBuffer();

		out.append("<table class='table table-bordered'> " + "<thead><tr><th>ID</th>" + "<th>Student Name</th>"
				+ "<th>Score</th>" + "<th>Percentage</th>" + "<th>Grade's</th></tr></thead>" + "<tbody>");

		for (HashMap<String, Object> item : data) {
			out.append("<td>" + item.get("student_id") + "</td>" + "<td>" + item.get("student_name") + "</td>" + "<td>"
					+ item.get("score") + "</td>" + "<td>" + item.get("percentage") + "</td>" + "<td>"
					+ item.get("grade") + "</td></tr>");

		}
		out.append("</tbody></table>");

		out.append("");
		return out;
	}

	public StringBuffer getStudentScoreDetailsForTable(int assessmentId, int batchId) {
		String sql = "SELECT 	COUNT (*) FILTER (WHERE gt.grade = 'A+') AS aplus, 	COUNT (*) FILTER (WHERE gt.grade = 'A') AS A, 	COUNT (*) FILTER (WHERE gt.grade = 'B+') AS bplus, 	COUNT (*) FILTER (WHERE gt.grade = 'B') AS b, 	COUNT (*) FILTER (WHERE gt.grade = 'C') AS C, 	COUNT (*) FILTER (WHERE gt.grade = 'Absent') AS ABSENT FROM 	( 		SELECT 			TFINAL. user_id AS student_id, 			TFINAL. first_name AS student_name, 			TFINAL.score AS score, 			( 				CASE 				WHEN TFINAL.score LIKE 'Absent' THEN 					'Absent' 				WHEN ( 					CAST (TFINAL.score AS INTEGER) >= 25 					AND CAST (TFINAL.score AS INTEGER) <= 30 				) THEN 					'A+' 				WHEN ( 					CAST (TFINAL.score AS INTEGER) >= 20 					AND CAST (TFINAL.score AS INTEGER) < 25 				) THEN 					'A' 				WHEN ( 					CAST (TFINAL.score AS INTEGER) >= 10 					AND CAST (TFINAL.score AS INTEGER) < 15 				) THEN 					'B+' 				WHEN ( 					CAST (TFINAL.score AS INTEGER) >= 5 					AND CAST (TFINAL.score AS INTEGER) < 10 				) THEN 					'B' 				WHEN ( 					CAST (TFINAL.score AS INTEGER) < 5 				) THEN 					'C' 				END 			) AS grade 		FROM 			( 				SELECT DISTINCT 					user_profile.user_id, 					user_profile.first_name, 					( 						CASE 						WHEN report.score IS NOT NULL THEN 							CAST (report.score AS VARCHAR) 						ELSE 							'Absent' 						END 					) AS score 				FROM 					user_profile 				LEFT JOIN report ON ( 					user_profile.user_id = report.user_id 					AND report.assessment_id = "
				+ assessmentId
				+ " 				) 				WHERE 					user_profile. user_id IN ( 						SELECT DISTINCT 							batch_students.student_id 						FROM 							batch_students, 							batch 						WHERE 							batch_students.batch_group_id = batch.batch_group_id 						AND batch. ID = "
				+ batchId
				+ " 					) 			) TFINAL 		ORDER BY 			user_id, 			first_name 	) gt";
		List<HashMap<String, Object>> data = dbutils.executeQuery(sql);
		StringBuffer out = new StringBuffer();

		out.append("<table id='datatable1' class='table table-bordered'>" + "<thead> <tr><th>Marks Scored</th>"
				+ " <th>Category</th>" + "<th>No of Student</th></tr></thead><tbody> ");

		for (HashMap<String, Object> item : data) {

			out.append("<tr> " + "<td>N/A</td> " + "<td></td> <td>" + item.get("absent") + "</td> </tr>"

					+ "<tr>" + "<td>5 to 9 Marks</td>" + "<td></td>" + "<td>" + item.get("c") + "</td></tr> "

					+ "<tr>" + "<td>10 to 14 Marks</td>" + "<td></td>" + "<td>" + item.get("b") + "</td></tr> "

					+ "<tr>" + "<td>15 to 19 Marks</td>" + "<td></td>" + "<td>" + item.get("bplus") + "</td></tr> "

					+ "<tr>" + "<td>20 to 24 Marks</td>" + "<td></td>" + "<td>" + item.get("a") + "</td></tr> "

					+ "<tr>" + "<td>25 to 30 Marks</td>" + "<td></td>" + "<td>" + item.get("aplus") + "</td></tr> ");

		}
		out.append("</tbody></table>");

		out.append("");
		return out;
	}

	public StringBuffer getStudentPercentageDetailsForTable(int assessmentId, int batchId) {
		String sql = "SELECT 	COUNT (*) FILTER (WHERE gt.grade = 'A+') AS aplus, 	COUNT (*) FILTER (WHERE gt.grade = 'A') AS A, 	COUNT (*) FILTER (WHERE gt.grade = 'B+') AS bplus, 	COUNT (*) FILTER (WHERE gt.grade = 'B') AS b, 	COUNT (*) FILTER (WHERE gt.grade = 'Absent') AS ABSENT FROM 	( 		SELECT 			TFINAL.user_id AS student_id, 			TFINAL. first_name AS student_name, 			TFINAL.score AS score, 			TFINAL.percentage AS percentage, 			( 				CASE 				WHEN TFINAL.percentage LIKE 'Absent' THEN 					'Absent' 				WHEN ( 					CAST (TFINAL.percentage AS INTEGER) >= 75 					AND CAST (TFINAL.percentage AS INTEGER) <= 100 				) THEN 					'A+' 				WHEN ( 					CAST (TFINAL.percentage AS INTEGER) >= 60 					AND CAST (TFINAL.percentage AS INTEGER) < 75 				) THEN 					'A' 				WHEN ( 					CAST (TFINAL.percentage AS INTEGER) >= 40 					AND CAST (TFINAL.percentage AS INTEGER) < 60 				) THEN 					'B+' 				WHEN ( 					CAST (TFINAL.percentage AS INTEGER) < 40 				) THEN 					'B' 				END 			) AS grade 		FROM 			( 				SELECT DISTINCT 					user_profile.user_id, 					user_profile.first_name, 					( 						CASE 						WHEN report.score IS NOT NULL THEN 							CAST (report.score AS VARCHAR) 						ELSE 							'Absent' 						END 					) AS score, 					CAST ( 						( 							CASE 							WHEN report.score IS NULL THEN 								'Absent' 							ELSE 								CAST ( 									(report.score * 100) / ( 										SELECT 											COUNT (DISTINCT questionid) 										FROM 											assessment_question 										WHERE 											 assessmentid = "
				+ assessmentId
				+ " 									) AS VARCHAR 								) 							END 						) AS VARCHAR 					) AS percentage 				FROM 					user_profile 				LEFT JOIN report ON ( 					user_profile.user_id = report.user_id 					AND report.assessment_id = "
				+ assessmentId
				+ " 				) 				WHERE 					user_profile.user_id IN ( 						SELECT DISTINCT 							batch_students.student_id 						FROM 							batch_students, 							batch 						WHERE 							batch_students.batch_group_id = batch.batch_group_id 						AND batch. ID = "
				+ batchId
				+ " 					) 			) TFINAL 		ORDER BY 			user_id, 			first_name 	) gt";
		List<HashMap<String, Object>> data = dbutils.executeQuery(sql);
		StringBuffer out = new StringBuffer();

		out.append("<table  id='datatable2' class='table table-bordered'>" + "<thead> <tr><th>Marks Scored</th>"
				+ " <th>Category</th>" + "<th>No of Student</th></tr></thead><tbody> ");

		for (HashMap<String, Object> item : data) {

			out.append("<tr>" + "<td>75-100</td>" + "<td></td>" + "<td>" + item.get("aplus") + "</td></tr> " + "<tr>"
					+ "<td>60-75</td>" + "<td></td>" + "<td>" + item.get("a") + "</td></tr> " + "<tr>"
					+ "<td>40-60</td>" + "<td></td>" + "<td>" + item.get("bplus") + "</td></tr> " + "<tr>"
					+ "<td>40</td>" + "<td></td>" + "<td>" + item.get("b") + "</td></tr> " + "<tr> " + "<td>N/A</td> "
					+ "<td></td><td>" + item.get("absent") + "</td> </tr>");

		}
		out.append("</tbody></table>");

		out.append("");
		return out;
	}

	public StringBuffer getOrganization() {
		// System.err.println(orgId);
		String sql = "SELECT id,name FROM organization";
		List<HashMap<String, Object>> data = dbutils.executeQuery(sql);
		StringBuffer out = new StringBuffer();
		for (HashMap<String, Object> item : data) {
			out.append("<option value='" + item.get("id") + "'>" + item.get("name") + "</option>");
		}
		out.append("");
		return out;
	}

	public List<HashMap<String, Object>> getAllQuestions(int assessmentId) {

		String sql = "select DISTINCT q.id as question_id,q.question_text,q.comprehensive_passage_text from question q,assessment_question asq where asq.assessmentid="
				+ assessmentId + " and asq.questionid=q.id";

		// System.err.println(sql);
		List<HashMap<String, Object>> items = dbutils.executeQuery(sql);
		return items;
	}

	public StringBuffer getAllOptions(int question_id) {
		String sql = "select * from assessment_option where question_id=" + question_id;

		// System.err.println(sql);
		List<HashMap<String, Object>> questionItem = dbutils.executeQuery(sql);
		StringBuffer out = new StringBuffer();
		for (HashMap<String, Object> item : questionItem) {
			if (item.get("marking_scheme").toString().equalsIgnoreCase("1")) {
				out.append("<div class='alert alert-success' style='color: #000 !important'><b>" + item.get("text")
						+ "</b></div>");
			} else {
				out.append(
						"<div class='alert alert-success' style='background-color: #eef2f4 !important;border-color: #eef2f4 !important; '>"
								+ item.get("text") + "</div>");
			}
		}
		return out;
	}

	public List<HashMap<String, Object>> getopsreport2(int assessmentId, int batchId, int questionId) {

		String sql = "SELECT 	COUNT (*) FILTER (  		WHERE 			student_assessment.correct = 't' 	) AS correct, 	COUNT (*) FILTER (  		WHERE 			student_assessment.correct = 'f' 	) AS incorrect, 	( 		( 			SELECT 				COUNT ( 					DISTINCT batch_students.student_id 				) 			FROM 				batch_students, 				batch 			WHERE 				batch_students.batch_group_id = batch.batch_group_id 			AND batch. ID = "
				+ batchId
				+ " 		) - ( 			COUNT (*) FILTER (  				WHERE 					student_assessment.correct = 't' 				OR student_assessment.correct = 'f' 			) 		) 	) AS skipped FROM 	student_assessment WHERE 	assessment_id = "
				+ assessmentId + " AND question_id = " + questionId
				+ " AND student_assessment.student_id IN ( 	SELECT DISTINCT 		batch_students.student_id 	FROM 		batch_students, 		batch 	WHERE 		batch_students.batch_group_id = batch.batch_group_id 	AND batch. ID = "
				+ batchId + " )";

		// System.err.println(sql);
		List<HashMap<String, Object>> items = dbutils.executeQuery(sql);
		return items;
	}

}
