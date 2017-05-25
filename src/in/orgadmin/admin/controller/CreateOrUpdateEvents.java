package in.orgadmin.admin.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.IstarUserDAO;
import com.viksitpro.core.utilities.IStarBaseServelet;

import in.orgadmin.admin.services.AssessmentSchedulerService;
import in.orgadmin.admin.services.EventSchedulerService;

@WebServlet("/createorupdate_events")
public class CreateOrUpdateEvents extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;

	public CreateOrUpdateEvents() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		printParams(request);

		int batchID = 0;
		int hours = 0;
		int minute = 0;
		int assessmentID =0;
		String eventType = null;
		String eventDate = null;
		String startTime = null;
		int trainerID=0;
		int AdminUserID = 0;
		int classroomID = 0;
		String startEventDate = null;
		String endEventDate = null;
		int sessionID = 0;
		String eventID = null;
		int orgID = 0;
		String associateTrainerID = null;
		

		if (request.getParameterMap().containsKey("orgID")) {
			orgID = request.getParameter("orgID") != "" ? Integer.parseInt(request.getParameter("orgID")) : 0;
		}
		if (request.getParameterMap().containsKey("hours")) {
			hours = request.getParameter("hours") != "" ? Integer.parseInt(request.getParameter("hours")) : 0;
		}
		if (request.getParameterMap().containsKey("minute")) {
			minute = request.getParameter("minute") != "" ? Integer.parseInt(request.getParameter("minute")) : 0;
		}
		if (request.getParameterMap().containsKey("batchID")) {
			batchID = request.getParameter("batchID") != "" ? Integer.parseInt(request.getParameter("batchID")) : 0;
		}
		if (request.getParameterMap().containsKey("eventType")) {
			eventType = request.getParameter("eventType") != "" ? request.getParameter("eventType") : "";
		}
		if (request.getParameterMap().containsKey("eventDate")) {
			eventDate = request.getParameter("eventDate") != "" ? request.getParameter("eventDate") : "";
		}
		if (request.getParameterMap().containsKey("startTime")) {
			startTime = request.getParameter("startTime") != "" ? request.getParameter("startTime") : "";
		}

		if (request.getParameterMap().containsKey("AdminUserID")) {
			AdminUserID = request.getParameter("AdminUserID") != ""
					? Integer.parseInt(request.getParameter("AdminUserID")) : 0;
		}
		/*if (request.getParameterMap().containsKey("superAdminUserID")) {
			AdminUserID = request.getParameter("superAdminUserID") != ""
					? Integer.parseInt(request.getParameter("superAdminUserID")) : 0;
		}*/
		if (request.getParameterMap().containsKey("classroomID")) {
			classroomID = request.getParameter("classroomID") != ""
					? Integer.parseInt(request.getParameter("classroomID")) : 0;
		}
		if (request.getParameterMap().containsKey("startEventDate")) {
			startEventDate = request.getParameter("startEventDate") != ""
					? request.getParameter("startEventDate") : "";
		}
		if (request.getParameterMap().containsKey("endEventDate")) {
			endEventDate = request.getParameter("endEventDate") != ""
					? request.getParameter("endEventDate") : "";
		}
		if (request.getParameterMap().containsKey("trainerID")) {
			trainerID = request.getParameter("trainerID") != ""
					? Integer.parseInt(request.getParameter("trainerID")) : 0;
		}
		if (request.getParameterMap().containsKey("assessmentID")) {
			assessmentID = request.getParameter("assessmentID") != ""
					? Integer.parseInt(request.getParameter("assessmentID")) : 0;
		}
		if (request.getParameterMap().containsKey("sessionID")) {
			sessionID = request.getParameter("sessionID") != ""
					? Integer.parseInt(request.getParameter("sessionID")) : 0;
		}
		
		if (request.getParameterMap().containsKey("associateTrainerID")) {
			associateTrainerID = request.getParameter("associateTrainerID") != ""
					? request.getParameter("associateTrainerID") : "0";
		}

		
		
		if (request.getParameterMap().containsKey("eventID")) {
			EventSchedulerService ess = new EventSchedulerService();
			eventID = request.getParameter("eventID") != "" ? request.getParameter("eventID") : "";
			ess.insertUpdateData(trainerID, hours, minute, batchID, eventType, eventDate, startTime,
					classroomID, AdminUserID, sessionID, eventID,associateTrainerID);
		} 

			// singleEvent
			if (request.getParameterMap().containsKey("tabType")
					&& request.getParameter("tabType").equalsIgnoreCase("singleEvent")) {

				IstarUserDAO dao = new IstarUserDAO();
				IstarUser user = new IstarUser();
				EventSchedulerService ess = new EventSchedulerService();
				if(request.getParameterMap().containsKey("eventType") && request.getParameter("eventType").equalsIgnoreCase("session")){
					
					if (request.getParameterMap().containsKey("eventValue")) {
						JSONParser parser = new JSONParser();
					      String eventDataDetails = request.getParameter("eventDataDetails");
					     
					      Object obj = null;
							try {
								obj = parser.parse(eventDataDetails);
								JSONArray array = (JSONArray)obj;
								
								for (int i = 0; i < array.size(); i++) {
								
									JSONObject jsonObject = (JSONObject) array.get(i);																		
									        trainerID = Integer.parseInt((String) jsonObject.get("trainerID"));
											hours = Integer.parseInt((String) jsonObject.get("hours"));
											minute = Integer.parseInt((String) jsonObject.get("minute"));
											batchID = Integer.parseInt((String) jsonObject.get("batchID"));
											eventType = (String) jsonObject.get("eventType");
											eventDate = (String) jsonObject.get("eventDate");
											startTime = (String) jsonObject.get("startTime");
									        classroomID = Integer.parseInt((String) jsonObject.get("classroomID"));
									        AdminUserID = Integer.parseInt((String) jsonObject.get("AdminUserID"));
									      if(jsonObject.containsKey("sessionID")){
									        sessionID = Integer.parseInt((String) jsonObject.get("sessionID"));
									        }  
									        eventID = (String) jsonObject.get("eventID");
									        associateTrainerID =  (String) jsonObject.get("associateTrainerID");
									        
									        ess.insertUpdateData(trainerID, hours, minute, batchID, eventType, eventDate, startTime,
													 classroomID, AdminUserID, sessionID, eventID,associateTrainerID);									
								}
								
									
							} catch (org.json.simple.parser.ParseException e) {
								e.printStackTrace();
							}
						
						
							user = dao.findById(AdminUserID);
						if(user.getUserRoles().iterator().next().getRole().getRoleName().equalsIgnoreCase("SUPER_ADMIN")){
							response.sendRedirect("super_admin/scheduler.jsp");
						}else{
							response.sendRedirect("orgadmin/scheduler.jsp");							
						}
					} else {
						response.getWriter().print(ess.singleEvent(trainerID, hours, minute, batchID, eventType, eventDate,
								startTime,  classroomID, AdminUserID,orgID,associateTrainerID));
					}
					
				}
				else if (request.getParameterMap().containsKey("eventType") && request.getParameter("eventType").equalsIgnoreCase("assessment")){
				
					AssessmentSchedulerService asservice = new AssessmentSchedulerService();
					if (request.getParameterMap().containsKey("eventValue")) {
						
						 JSONParser parser = new JSONParser();
					      String eventDataDetails = request.getParameter("eventDataDetails");
					     
					      Object obj = null;
							try {
								obj = parser.parse(eventDataDetails);
								JSONArray array = (JSONArray)obj;
								
								for (int i = 0; i < array.size(); i++) {
								
									JSONObject jsonObject = (JSONObject) array.get(i);
									
									
									        trainerID = Integer.parseInt((String) jsonObject.get("trainerID"));
											
											batchID = Integer.parseInt((String) jsonObject.get("batchID"));
											
											eventDate = (String) jsonObject.get("eventDate");
											startTime = (String) jsonObject.get("startTime");
									        classroomID = Integer.parseInt((String) jsonObject.get("classroomID"));
									        AdminUserID = Integer.parseInt((String) jsonObject.get("AdminUserID"));
									        assessmentID = Integer.parseInt((String) jsonObject.get("assessmentID"));
									        associateTrainerID =  (String) jsonObject.get("associateTrainerID");
									        
									        asservice.insertDeleteData(trainerID,assessmentID, batchID, AdminUserID, eventDate, startTime,classroomID, associateTrainerID);
									        
									
									
								}
								
									
							} catch (org.json.simple.parser.ParseException e) {
								e.printStackTrace();
							}
						
							user = dao.findById(AdminUserID);
						if(user.getUserRoles().iterator().next().getRole().getRoleName().equalsIgnoreCase("SUPER_ADMIN")){
							response.sendRedirect("super_admin/scheduler.jsp");
						}else{
							response.sendRedirect("orgadmin/scheduler.jsp");
							
						}
					}
					
					else{
						response.getWriter().print(asservice.singleAssessmentEvent(trainerID,eventType,batchID, assessmentID, eventDate,startTime,AdminUserID,classroomID, associateTrainerID));
					}
					
					
					
					
				}

				

			}

			// dailyEvent else if
			else if (request.getParameterMap().containsKey("tabType") && request.getParameter("tabType").equalsIgnoreCase("dailyEvent")) {

				IstarUserDAO dao = new IstarUserDAO();
				IstarUser user = new IstarUser();
				//user = dao.findById(AdminUserID);
				EventSchedulerService ess = new EventSchedulerService();
				
				if(request.getParameterMap().containsKey("eventType") && request.getParameter("eventType").equalsIgnoreCase("session")){
					
					if (request.getParameterMap().containsKey("eventValue")) {
						
						
						 JSONParser parser = new JSONParser();
					      String eventDataDetails = request.getParameter("eventDataDetails");
					     
					      Object obj = null;
							try {
								obj = parser.parse(eventDataDetails);
								JSONArray array = (JSONArray)obj;
								
								for (int i = 0; i < array.size(); i++) {
								
									JSONObject jsonObject = (JSONObject) array.get(i);
									
									
									        trainerID = Integer.parseInt((String) jsonObject.get("trainerID"));
											hours = Integer.parseInt((String) jsonObject.get("hours"));
											minute = Integer.parseInt((String) jsonObject.get("minute"));
											batchID = Integer.parseInt((String) jsonObject.get("batchID"));
											eventType = (String) jsonObject.get("eventType");
											eventDate = (String) jsonObject.get("eventDate");
											startTime = (String) jsonObject.get("startTime");
									        classroomID = Integer.parseInt((String) jsonObject.get("classroomID"));
									        AdminUserID = Integer.parseInt((String) jsonObject.get("AdminUserID"));
									      if(jsonObject.containsKey("sessionID")){
									        sessionID = Integer.parseInt((String) jsonObject.get("sessionID"));
									        }  
									        eventID = (String) jsonObject.get("eventID");
									        associateTrainerID =  (String) jsonObject.get("associateTrainerID");
									        
									        ess.insertUpdateData(trainerID, hours, minute, batchID, eventType, eventDate, startTime,
													 classroomID, AdminUserID, sessionID, eventID,associateTrainerID);
									        
									
									
								}
								
									
							} catch (org.json.simple.parser.ParseException e) {
								e.printStackTrace();
							}
						
						
							user = dao.findById(AdminUserID);
						if(user.getUserRoles().iterator().next().getRole().getRoleName().equalsIgnoreCase("SUPER_ADMIN")){
							response.sendRedirect("super_admin/scheduler.jsp");
						}else{
							response.sendRedirect("orgadmin/scheduler.jsp");
							
						}

					}else {
						
						response.getWriter().print(ess.dailyEvent(trainerID, hours, minute, batchID, eventType, startEventDate,
								endEventDate, startTime,  classroomID, AdminUserID,orgID,associateTrainerID));
					}
					
				}
				else if (request.getParameterMap().containsKey("eventType") && request.getParameter("eventType").equalsIgnoreCase("assessment")){
					
				}
				
			

				

			} //
			
			// weeklyEvent else if
						else if (request.getParameterMap().containsKey("tabType") && request.getParameter("tabType").equalsIgnoreCase("weeklyEvent")) {
							
							IstarUserDAO dao = new IstarUserDAO();
							IstarUser user = new IstarUser();
							user = dao.findById(AdminUserID);
							String days = "";
							
							if (request.getParameterMap().containsKey("day")) {
								days = request.getParameter("day") != ""
										? request.getParameter("day") : "";
							}
					


							EventSchedulerService ess = new EventSchedulerService();
							
							if(request.getParameterMap().containsKey("eventType") && request.getParameter("eventType").equalsIgnoreCase("session")){
								
								

								if (request.getParameterMap().containsKey("eventValue")) {
									
									
									
									 JSONParser parser = new JSONParser();
								      String eventDataDetails = request.getParameter("eventDataDetails");
								     
								      Object obj = null;
										try {
											obj = parser.parse(eventDataDetails);
											JSONArray array = (JSONArray)obj;
											
											for (int i = 0; i < array.size(); i++) {
											
												JSONObject jsonObject = (JSONObject) array.get(i);
												
												
												        trainerID = Integer.parseInt((String) jsonObject.get("trainerID"));
														hours = Integer.parseInt((String) jsonObject.get("hours"));
														minute = Integer.parseInt((String) jsonObject.get("minute"));
														batchID = Integer.parseInt((String) jsonObject.get("batchID"));
														eventType = (String) jsonObject.get("eventType");
														eventDate = (String) jsonObject.get("eventDate");
														startTime = (String) jsonObject.get("startTime");
												        classroomID = Integer.parseInt((String) jsonObject.get("classroomID"));
												        AdminUserID = Integer.parseInt((String) jsonObject.get("AdminUserID"));
												      if(jsonObject.containsKey("sessionID")){
												        sessionID = Integer.parseInt((String) jsonObject.get("sessionID"));
												        }  
												        eventID = (String) jsonObject.get("eventID");
												        associateTrainerID =  (String) jsonObject.get("associateTrainerID");
												        
												        ess.insertUpdateData(trainerID, hours, minute, batchID, eventType, eventDate, startTime,
																 classroomID, AdminUserID, sessionID, eventID,associateTrainerID);
												        
												
												
											}
											
												
										} catch (org.json.simple.parser.ParseException e) {
											e.printStackTrace();
										}
									
									
										user = dao.findById(AdminUserID);

					
									
									

									if(user.getUserRoles().iterator().next().getRole().getRoleName().equalsIgnoreCase("SUPER_ADMIN")){
										response.sendRedirect("super_admin/scheduler.jsp");
									}else{
										response.sendRedirect("orgadmin/scheduler.jsp");
										
									}

								}else {
									
									response.getWriter().print(ess.weeklyEvent(trainerID, hours, minute, batchID, eventType, startEventDate,
											endEventDate, startTime,  classroomID, AdminUserID,days,orgID,associateTrainerID));
								}
								
							}
							
							
							else if (request.getParameterMap().containsKey("eventType") && request.getParameter("eventType").equalsIgnoreCase("assessment")){
								
								
							}
							

							

						} //

		
		// response.sendRedirect("orgadmin/scheduler.jsp");  
			
		else if(request.getParameterMap().containsKey("eventDataDetails")){
				
				EventSchedulerService ess = new EventSchedulerService();
				 JSONParser parser = new JSONParser();
			      String eventDataDetails = request.getParameter("eventDataDetails");
			      StringBuffer out = new StringBuffer();
			      Object obj = null;
					try {
						obj = parser.parse(eventDataDetails);
						JSONArray array = (JSONArray)obj;
						out.append(ess.editNewEvent(array));
						out.append("");	
						response.getWriter().print(out);
							
					} catch (org.json.simple.parser.ParseException e) {
						e.printStackTrace();
					}
	
			}

	}



	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}
