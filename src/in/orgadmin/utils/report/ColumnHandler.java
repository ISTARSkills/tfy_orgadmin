package in.orgadmin.utils.report;

public abstract class ColumnHandler {

	public ColumnHandler() {
		super();
	}

	public abstract StringBuffer getHTML( String value, int reportID);

	public abstract StringBuffer getOrder(String string, int reportID) ;

	

}