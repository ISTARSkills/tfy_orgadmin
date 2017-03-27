package in.orgadmin.recruiter.controllers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.istarindia.apps.services.controllers.IStarBaseServelet;

import in.recruiter.services.RecruiterServices;

@WebServlet("/getDegreesSpecializations")
public class GetDegreesSpecializations extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;

	public GetDegreesSpecializations() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		printParams(request);

		Set<String> specilizations = new LinkedHashSet<String>();

		String degreeNames = request.getParameter("degrees");
		RecruiterServices recruiterServices = new RecruiterServices();

		String[] asd = degreeNames.split(",");

		List<String> allDegrees = (List<String>) Arrays.asList(asd);

		if (!allDegrees.isEmpty()) {
			for (String degreeName : allDegrees) {
				if (!degreeName.trim().isEmpty()) {
					if (degreeName.equalsIgnoreCase("BTECH")) {
						specilizations.add("<optgroup label=\"UG Engineering Majors\">");
						for (String branch : recruiterServices.getUGEngineeringSpecializations()) {
							String option = "<option value='" + branch + "'> " + branch + "</option>";
							System.out.println(option);
							specilizations.add(option);
						}
						specilizations.add("</optgroup>");
					} else if (degreeName.equalsIgnoreCase("BSC")) {
						specilizations.add("<optgroup label=\"UG Science Majors\">");
						for (String branch : recruiterServices.getUGScienceSpecializations()) {
							String option = "<option value='" + branch + "'> " + branch + "</option>";
							specilizations.add(option);
						}
						specilizations.add("</optgroup>");
					} else if (degreeName.equalsIgnoreCase("BCOM")) {
						specilizations.add("<optgroup label=\"UG Commerce Majors\">");
						for (String branch : recruiterServices.getUGCommerceSpecializations()) {
							String option = "<option value='" + branch + "'> " + branch + "</option>";
							specilizations.add(option);
						}
						specilizations.add("</optgroup>");
					}else if (degreeName.equalsIgnoreCase("BBM")) {
						specilizations.add("<optgroup label=\"UG BBM Majors\">");
						for (String branch : recruiterServices.getUGBBMSpecializations()) {
							String option = "<option value='" + branch + "'> " + branch + "</option>";
							specilizations.add(option);
						}
						specilizations.add("</optgroup>");
					}else if (degreeName.equalsIgnoreCase("BA")) {
						specilizations.add("<optgroup label=\"UG Arts Majors\">");
						for (String branch : recruiterServices.getUGArtSpecializations()) {
							String option = "<option value='" + branch + "'> " + branch + "</option>";
							specilizations.add(option);
						}
						specilizations.add("</optgroup>");
					}else if (degreeName.equalsIgnoreCase("MBA")) {
						specilizations.add("<optgroup label=\"PG Management Majors\">");
						for (String branch : recruiterServices.getPGMBASpecializations()) {
							String option = "<option value='" + branch + "'> " + branch + "</option>";
							specilizations.add(option);
						}
						specilizations.add("</optgroup>");
					}else if (degreeName.equalsIgnoreCase("MTECH")) {
						specilizations.add("<optgroup label=\"PG Engineering Majors\">");
						for (String branch : recruiterServices.getPGEngineeringSpecializations()) {
							String option = "<option value='" + branch + "'> " + branch + "</option>";
							specilizations.add(option);
						}
						specilizations.add("</optgroup>");
					}else if (degreeName.equalsIgnoreCase("MSC")) {
						specilizations.add("<optgroup label=\"PG Science Majors\">");
						for (String branch : recruiterServices.getPGScienceSpecializations()) {
							String option = "<option value='" + branch + "'> " + branch + "</option>";
							specilizations.add(option);
						}
						specilizations.add("</optgroup>");
					}else if (degreeName.equalsIgnoreCase("MCOM")) {
						specilizations.add("<optgroup label=\"PG Commerce Majors\">");
						for (String branch : recruiterServices.getPGCommerceSpecializations()) {
							String option = "<option value='" + branch + "'> " + branch + "</option>";
							specilizations.add(option);
						}
						specilizations.add("</optgroup>");
					}else if (degreeName.equalsIgnoreCase("MA")) {
						specilizations.add("<optgroup label=\"PG Arts Majors\">");
						for (String branch : recruiterServices.getPGArtSpecializations()) {
							String option = "<option value='" + branch + "'> " + branch + "</option>";
							specilizations.add(option);
						}
						specilizations.add("</optgroup>");
					}
					else {
						System.out.println("No Specialization for this Degree");
					}
				}
			}
		}
		
		StringBuffer allSpecilizations = new StringBuffer();
		for(String option : specilizations){
			allSpecilizations.append(option);
		}
		
		response.getWriter().print(allSpecilizations);
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
