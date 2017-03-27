package in.talentify.core.javabean;

public class SuperAdminEvent {

	int total_event;
	int completed_event;
	int event_cancelled;
	int event_inprogress;
	int event_pending;

	public SuperAdminEvent() {
		super();
		// TODO Auto-generated constructor stub
	}

	public SuperAdminEvent(int total_event, int completed_event, int event_cancelled, int event_inprogress, int event_pending) {
		super();
		this.total_event = total_event;
		this.completed_event = completed_event;
		this.event_cancelled = event_cancelled;
		this.event_inprogress = event_inprogress;
		this.event_pending = event_pending;
	}

	public int getTotal_event() {
		return total_event;
	}

	public void setTotal_event(int total_event) {
		this.total_event = total_event;
	}

	public int getCompleted_event() {
		return completed_event;
	}

	public void setCompleted_event(int completed_event) {
		this.completed_event = completed_event;
	}

	public int getEvent_cancelled() {
		return event_cancelled;
	}

	public void setEvent_cancelled(int event_cancelled) {
		this.event_cancelled = event_cancelled;
	}

	public int getEvent_inprogress() {
		return event_inprogress;
	}

	public void setEvent_inprogress(int event_inprogress) {
		this.event_inprogress = event_inprogress;
	}

	public int getEvent_pending() {
		return event_pending;
	}

	public void setEvent_pending(int event_pending) {
		this.event_pending = event_pending;
	}

}
