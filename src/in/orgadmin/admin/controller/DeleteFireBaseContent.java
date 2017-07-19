package in.orgadmin.admin.controller;


import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.viksitpro.core.utilities.DBUTILS;

/**
 * Servlet implementation class DeleteFireBaseContent
 * Mon Jan  2 13:47:34 IST 2017
 */
@WebServlet("/DeleteFireBaseContent")
public class DeleteFireBaseContent extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	private SimpleDateFormat sdf_FIREBASE = new SimpleDateFormat("EEE MMM dd HH:mm:ss z yyyy", Locale.ENGLISH);
	private DatabaseReference currentRef;
	private FirebaseDatabase ref;
	
	int selectionDay=1;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DeleteFireBaseContent() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		try {
			// Move calendar to yesterday
			PrintWriter out = response.getWriter();
			
			if(request.getParameter("select_day")!=null){
				selectionDay=Integer.parseInt(request.getParameter("select_day"));
			}
			
			Date todayDate = getCalendarDay(selectionDay);
			out.println("selected Date-->" + todayDate);

			ref = FirebaseDatabase.getInstance();
			DBUTILS util = new DBUTILS();
			String sql = "select id from student";
			List<HashMap<String, Object>> data = util.executeQuery(sql);
			int studentId = 0;
			if (data.size() > 0) {
				for (HashMap<String, Object> row : data) {
					if (row.get("id") != null) {
						studentId = (int) row.get("id");
						currentRef = ref.getReference("" + studentId);
						if (currentRef != null) {
							currentRef.addListenerForSingleValueEvent(new ValueEventListener() {
								@Override
								public void onDataChange(DataSnapshot dataSnapshot) {
									if (dataSnapshot.getValue() != null) {
										HashMap<String, Object> key_Value = (HashMap<String, Object>) dataSnapshot
												.getValue();

										for (String key : key_Value.keySet()) {

											HashMap<String, Object> values = (HashMap<String, Object>) key_Value
													.get(key);
											for (String secondKey : values.keySet()) {

												if (values.get("evdate") != null) {

													String firebaseDateString = (String) values.get("evdate");

													Calendar old_cal = Calendar.getInstance();
													try {
														old_cal.setTime(sdf_FIREBASE.parse(firebaseDateString));
														if (old_cal.getTime().before(todayDate)) {
															
															//System.out.println("firebase date-----"
																	//+ old_cal.getTime() + "----selcted_date-----"
																	//+ todayDate + "key is--->" + key);

															ref.getReference(dataSnapshot.getKey()).child(key)
																	.removeValue();
														}
													} catch (ParseException e) {
														try {
															old_cal.setTime(sdf.parse(firebaseDateString));
															if (old_cal.getTime().before(todayDate)) {
																
																//System.out.println("----firebase date-----"
																		//+ old_cal.getTime() + "----selcted_date-----"
																		//+ todayDate + "key is--->" + key);
																
																ref.getReference(dataSnapshot.getKey()).child(key)
																		.removeValue();
															}
														} catch (ParseException e1) {
															e1.printStackTrace();
														}
													}
												}
											}
										}
									}

								}

								@Override
								public void onCancelled(DatabaseError arg0) {
									// TODO Auto-generated method stub

								}
							});

						}

					}
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private Date getCalendarDay(int days) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(new Date());
		cal.add(Calendar.DAY_OF_MONTH, -days);
		return cal.getTime();
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
