import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.istarindia.apps.dao.DBUTILS;

import in.orgadmin.utils.report.IStarColumn;
import in.orgadmin.utils.report.Report;
import in.talentify.core.utils.JsonUIUtils;
import in.talentify.core.utils.ReportUtils;
import in.talentify.core.utils.UIUtils;

public class MAIN {

	public static void main(String[] args) {
		/*ReportUtils ru = new ReportUtils();
		Report  report = ru.getReport(4001);
		
		for (IStarColumn iterable_element : report.getColumns()) {
			System.err.println("<th>"+iterable_element.getDisplayName()+"</th>");
		}
		
		DBUTILS db = new DBUTILS();
		
		List<HashMap<String, Object>> data = db.executeQuery(report.getSql());
		ArrayList<ArrayList<String>> data2 = new ArrayList<>();*/
		
		JsonUIUtils json = new JsonUIUtils();
		//System.out.println(json.getCourseChartData(22, 3));
		
	}

}
