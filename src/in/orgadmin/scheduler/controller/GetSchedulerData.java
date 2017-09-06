package in.orgadmin.scheduler.controller;

import java.io.IOException;
import java.util.Enumeration;
import java.util.*;
import java.text.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class GetSchedulerData
 */
@WebServlet("/GetSchedulerData")
public class GetSchedulerData extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private static final SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy");
    private static final SimpleDateFormat ddf = new SimpleDateFormat("dd");

    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetSchedulerData() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		Enumeration params = request.getParameterNames(); 
		while(params.hasMoreElements()){
		 String paramName = (String)params.nextElement();
		 System.out.println("Parameter Name - "+paramName+", Value - "+request.getParameter(paramName));
		}
		
		StringBuffer sb = new StringBuffer();

		try {
			List<Date> range_dates = getDaysBetweenDates(sdf.parse(request.getParameter("startdate")),
					sdf.parse(request.getParameter("enddate")));
			
			// i is used for creating row 
			int i = 0;
			// j is counter for the entire loop
			int j = 0;
			for (Date d : range_dates) {
				int temp = -1;
				//System.out.println("-----> " + sdf.format(d));
				Calendar cal = Calendar.getInstance();
				cal.setTime(d);
				if (i % 7 == 0) {
					//each row will consist seven grids
					sb.append("<div class='row m-0 bg-white'>");
				}
				if (i == 0) {
					//calculation used for checking grid to be added before start date of the month
					
					switch (cal.get(Calendar.DAY_OF_WEEK)) {
					case 1:
						//System.out.print("Sunday");
						temp = 7;
						break;
					case 2:
						//System.out.print("Monday");
						temp = 1;
						break;
					case 3:
						//System.out.print("Tuesday");
						temp = 2;
						break;
					case 4:
						//System.out.print("Wednesday");
						temp = 3;
						break;
					case 5:
						//System.out.print("Thursday");
						temp = 4;
						break;
					case 6:
						//System.out.print("Friday");
						temp = 5;
						break;
					case 7:
						temp = 6;
						//System.out.print("Saturday");
					}
				}

				if (temp != -1) {
					i = temp - 1;
					
					for(int l =0; l<temp-1;l++) {
						//to fill the first/empty  row of calendar  before current month start date

						sb.append("<div class='custom-col-md-7 m-0 md-height-180  text-center' data-date='"+sdf.format(d)+"'> ");
						Calendar cal1 = Calendar.getInstance();
						cal1.setTime(d);
					    cal1.add(Calendar.DATE, (l-(temp-1)));
					    sb.append("<div class='date-display-scheduler'>"+ddf.format(cal1.getTime())+"</div>");
					   // sb.append("<div class='show-more-popup'><div class='row m-0'><div class='row m-0'><h1 class='popup-date-head m-0'>24</h1> <h2 class='popup-date-tail m-0'>Aug  2017</h2></div></div>");
						sb.append("</div>");
					}
				}
					
				//normat date data fill as usual
				sb.append("<div class='custom-col-md-7 m-0 md-height-180 bg-white text-center' data-date='"+sdf.format(d)+"'>");
			    sb.append("<div class='date-display-scheduler'>"+ddf.format(d)+"</div>");
				sb.append("<div class='red-div'>"
						+ "<h1 class='m-0'>This is event</h1>"
						+"<p1 class ='float-left'>8 AM - 10 AM</p1>"
						+ "</div>");
				sb.append("<div class='green-div'>"
						+ "<h1 class='m-0'>This is event</h1>"
						+"<p1 class ='float-left'>8 AM - 10 AM</p1>"
						+ "</div>");
				sb.append("<div class='blue-div'>"
						+ "<h1 class='m-0'>This is event</h1>"
						+"<p1 class ='float-left'>8 AM - 10 AM</p1>"
						+ "</div>");
				sb.append("<div class='div-button-more'><h1 class='div-button-text'>+3 More</h1></div>");
				sb.append("</div>");
				
				
				if (i % 7 == 6) {
					//end of the row
					sb.append("</div >");
				}
				if (j == range_dates.size() - 1) {
					if (i % 7 != 6) {
						//to fill the last row of calendar  after current month end date
						//System.out.println("i --- "+(7-((i+1) % 7)) +"i   "+i);
						int formaula = (7-((i+1) % 7));
						for(int k=1;k <=formaula;k++ ) {
						sb.append("<div class='custom-col-md-7 m-0 md-height-180  text-center'> ");
						Calendar cal1 = Calendar.getInstance();
						cal1.setTime(d);
					    cal1.add(Calendar.DATE, k);
					    sb.append(sdf.format(cal1.getTime()));
						sb.append("</div>");
						}
						sb.append("</div >");
					}
				}
				i++;
				j++;
				
			}

		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		response.getWriter().println(sb.toString());
		
		
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

	
	 public static List<Date> getDaysBetweenDates(Date startDate, Date endDate){
	        ArrayList<Date> dates = new ArrayList<Date>();
	        Calendar cal1 = Calendar.getInstance();
	        cal1.setTime(startDate);

	        Calendar cal2 = Calendar.getInstance();
	        cal2.setTime(endDate);

	        while(cal1.before(cal2) || cal1.equals(cal2))
	        {
	            dates.add(cal1.getTime());
	            cal1.add(Calendar.DATE, 1);
	        }
	        return dates;
	    }
}
