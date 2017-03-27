package in.talentify.core.utils;

public class CourseReportEvent {

	private String title;
	private String start;
	private String color;
	public CourseReportEvent() {
		super();
		// TODO Auto-generated constructor stub
	}
	public CourseReportEvent(String title, String start, String color) {
		super();
		this.title = title;
		this.start = start;
		this.color = color;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getStart() {
		return start;
	}
	public void setStart(String start) {
		this.start = start;
	}
	public String getColor() {
		return color;
	}
	public void setColor(String color) {
		this.color = color;
	}
	
	
}
