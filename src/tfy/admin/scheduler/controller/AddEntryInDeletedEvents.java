package tfy.admin.scheduler.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.core.utilities.DBUTILS;

import in.talentify.core.controllers.IStarBaseServelet;

/**
 * Servlet implementation class AddEntryInDeletedEvents
 */
@WebServlet("/add_entry_in_deleted_events")
public class AddEntryInDeletedEvents extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddEntryInDeletedEvents() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printparams(request);
		
		String AdminUserID = request.getParameter("AdminUserID");
		String eventId = request.getParameter("eventID");
		String reason_for_edit_delete = request.getParameter("reason_for_edit_delete");
		String actionType = request.getParameter("action_type");
		DBUTILS util = new DBUTILS();		
		
		String deleteOldEntry ="delete from batch_schedule_event_deleted where id in (select id from batch_schedule_event where batch_group_code in (select batch_group_code from batch_schedule_event where id = "+eventId+"))";
		util.executeUpdate(deleteOldEntry);
		
		String insertIntoDeletedEvents ="insert into batch_schedule_event_deleted (select * from batch_schedule_event where batch_group_code in (select batch_group_code from batch_schedule_event where id = "+eventId+"))";
		util.executeUpdate(insertIntoDeletedEvents);
		
		String insertIntoReasonTable ="DO 	$$ DECLARE lobjs CURSOR FOR  select id from batch_schedule_event where batch_group_code in (select batch_group_code from batch_schedule_event where id = "+eventId+") ;  BEGIN 	FOR xyz IN lobjs LOOP 	EXECUTE 'delete from deleted_events_details where event_id ='||xyz.id||'';	EXECUTE 'INSERT INTO deleted_events_details (id, event_id, deleted_on, deleted_by, reason_for_deletion, action_type) VALUES ((select COALESCE(max(id),0)+1 from deleted_events_details), '||xyz.id||', now(), "+AdminUserID+", ''"+reason_for_edit_delete+"'', ''"+actionType+"'');'; 	END LOOP ; END $$;";
		util.executeUpdate(insertIntoReasonTable);
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
