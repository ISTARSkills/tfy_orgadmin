package com.viksitpro.user.service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import com.istarindia.android.pojo.ComplexObject;
import com.istarindia.android.pojo.DailyTaskPOJO;
import com.istarindia.android.pojo.RestClient;

public class UserCalendarService {

	public StringBuffer getCalendarDetails(int monthIndex, int user_id) throws ParseException {

		StringBuffer out = new StringBuffer();
		RestClient rc = new RestClient();
		ComplexObject cp = rc.getComplexObject(user_id);
		StudentTrainerDashboardService studentsrainerdashboardservice = new StudentTrainerDashboardService();
		out.append("<div class='row m-0 p-0 w-100' style='display: -webkit-inline-box; align-items: center; background: rgba(250, 250, 250, 0.99);'>");
		Calendar cal = Calendar.getInstance();
		cal.set(Calendar.MONTH, monthIndex);

		cal.set(Calendar.DAY_OF_MONTH, 1);
		int maxDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);

		HashMap<Date, ArrayList<DailyTaskPOJO>> map_events = new HashMap<>();
		ArrayList<Date> currentMonthDates = new ArrayList();
		SimpleDateFormat ll = new SimpleDateFormat("dd-MM-yyyy");
		SimpleDateFormat df = new SimpleDateFormat("dd MMM");
		List<DailyTaskPOJO> listofevent = cp.getEvents();

		for (int i = 1; i < maxDay; i++) {
			cal.set(Calendar.DAY_OF_MONTH, i);
			Date currentDate = cal.getTime();

			for (DailyTaskPOJO dd : listofevent) {
				Date date = new Date(dd.getStartDate().getTime());

				if (ll.parse(ll.format(currentDate)).compareTo(ll.parse(ll.format(date))) == 0) {

					if (map_events.containsKey(currentDate)) {
						map_events.get(currentDate).add(dd);
					} else {
						ArrayList<DailyTaskPOJO> dailyTaskPOJOs = new ArrayList();
						dailyTaskPOJOs.add(dd);
						map_events.put(currentDate, dailyTaskPOJOs);
						currentMonthDates.add(currentDate);
					}
				}
			}
		}

		for (Date day : currentMonthDates) {

			out.append("<div class='' style='width: 180px;display: grid; line-height: 3.5;border-right: 1px solid #eee;background: rgba(250, 250, 250, 0.99);'>");

			out.append("<div class='w-100 h-100 text-center m-auto'>");
			out.append("<p  class='p-0 m-0 find_currentDate_parent' data-currentDate='"+df.format(day)+"'>" + df.format(day) + "</p>");
			out.append("</div>");
			out.append("</div>");

		}
		out.append("</div>");

		out.append("<div class='row m-0 p-0 custom-scroll-holder' style='display: -webkit-inline-box; align-items: center;'>");

		for (Date day : currentMonthDates) {

			out.append("<div class='custom-calendar-item-colums find_currentDate_child' data-currentDate='"+df.format(day)+"' style='width: 180px; border-left: 1px solid #eee;'>");

			if (map_events.get(day) != null && map_events.get(day).size() != 0) {
				for (int j = 0; j < map_events.get(day).size(); j++) {
					for (HashMap<String, Object> eveDetails : studentsrainerdashboardservice.EventDetailsForCalendar(map_events.get(day).get(j).getItemId())) {
						if (eveDetails != null && eveDetails.size() != 0) {

							out.append(
									"<div class='' style='    border-top: 5px solid #39b26a;justify-self: start; width: 160px; margin: 8px; min-height: 110px; max-height: 110px; border-radius: 4px; background-color: #ffffff; box-shadow: 0 4px 7px 0 rgba(0, 0, 0, 0.1), 0 2px 2px 0 rgba(0, 0, 0, 0.12), inset 0 4px 0 0 #39b26a;'>");

							SimpleDateFormat _24HourSDF = new SimpleDateFormat("yyyy-mm-dd HH:mm:ss");
							SimpleDateFormat _12HourSDF = new SimpleDateFormat("hh:mm a");
							Date _24StartHourDt = _24HourSDF
									.parse(map_events.get(day).get(j).getStartDate().toString());
							Date _24EndHourDt = _24HourSDF.parse(map_events.get(day).get(j).getEndDate().toString());

							out.append(
									"<div class='row calendar-event-header m-0 p-2' data-eventID='"+map_events.get(day).get(j).getItemId()+"' >");
							out.append(
									"<i class='fa fa-clock-o aligncenter' style='color: #2196f2;' aria-hidden='true'></i> <h2 class=' calendar-time-size  mb-0 ml-2 aligncenter'>"+_12HourSDF.format(_24StartHourDt) +"-"+_12HourSDF.format(_24EndHourDt)+"</h2>");
							out.append("</div>");

							out.append(
									"<h1 class='w-100 cal-event-name p-2' style='font-weight: bolder;'>"+eveDetails.get("course_name")+"</h1>");
							out.append(
									" <h2 class='w-100 cal-event-batch p-2'>"+eveDetails.get("section_name")+"</h2> ");

							out.append("</div>");

						}
					}
				}
			}

			out.append("</div>");

		}
		out.append("</div>");
		return out;

	}

}
