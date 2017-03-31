package in.orgadmin.controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.utilities.IStarBaseServelet;

import in.orgadmin.utils.DatatableUtils;
import in.orgadmin.utils.OrgAdminRegistry;
import in.orgadmin.utils.report.IStarColumn;
import in.orgadmin.utils.report.Report;
import in.orgadmin.utils.report.ReportCollection;

/**
 * Servlet implementation class NotificationBatchFilter
 */
@WebServlet("/GetStudentsInBatch")
public class GetStudentsInBatch extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetStudentsInBatch() {
        super();
        
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printParams(request);


		response.setContentType("application/json");
		JSONObject parentJon = new JSONObject();
		JSONObject json = null;
		JSONArray arr = new JSONArray();

		int report_id = 209;
		String ite = new String();
		String key = new String();
		String value = new String();

		ReportCollection reportCollection = new ReportCollection();
		Report report = new Report();
		try {
			URL url = (new OrgAdminRegistry()).getClass().getClassLoader().getResource("/report_list.xml");
			File file = new File(url.toURI());
			JAXBContext jaxbContext = JAXBContext.newInstance(ReportCollection.class);
			Unmarshaller jaxbUnmarshaller = jaxbContext.createUnmarshaller();
			reportCollection = (ReportCollection) jaxbUnmarshaller.unmarshal(file);
		} catch (URISyntaxException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (JAXBException e) {
			e.printStackTrace();
		}

		for (Report r : reportCollection.getReports()) {
			if (r.getId() == report_id) {
				report = r;
			}
		}

		ArrayList<ArrayList<String>> data = new ArrayList<>();

		try {
			HashMap<String, String> conditions = new HashMap<>();
			for (String param : request.getParameterMap().keySet()) {
				if (param.startsWith("key")) {
					ite = param.split("_")[1];
					key = request.getParameter(param); // example: key_1 =
														// org_id
					value = request.getParameter("value_" + ite); // example:
																	// value_1 =
																	// 2
					conditions.put(key, value);
				}
			}
			data = (new DatatableUtils()).getReportData(report.getSql(), report.getColumns(), conditions);
			data.subList(0, 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		String ROWID = "";

		for (ArrayList<String> str : data) {
			json = new JSONObject();
			int j = 0;
			for (IStarColumn column : report.getColumns()) {
				try {
					if (column.getName().equalsIgnoreCase("task_id") || column.getName().equalsIgnoreCase("id")
							|| column.getName().equalsIgnoreCase("handout_id")) {
						ROWID = str.get(j);
					}
					String status = str.get(j);
					String taskType = "NONE";
					IstarUser user  = new IstarUser();
					int taskID = Integer.parseInt(ROWID);
					int reportID = report_id;
					String itemType = "NONE";
					StringBuffer str11;
					try {
						str11 = in.orgadmin.utils.report.ReportColumnHandlerFactory.getInstance().getHandler(column.getColumnHandler())
								.getHTML(status, user, taskType, taskID, reportID, itemType);
						json.put(column.getName(), str11);
					} catch (Exception e) {
						json.put(column.getName(), str.get(j));
					}
					
					
					j++;
				} catch (Exception e) {
					e.printStackTrace();
				}

			}
			arr.put(json);
		}
		try {
			parentJon.put("data", arr);
		} catch (JSONException e) {
			e.printStackTrace();
		}

		PrintWriter out1 = response.getWriter();
		out1.print(parentJon);
	
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		doGet(request, response);
	}

}
