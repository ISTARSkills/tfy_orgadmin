package in.superadmin.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.google.api.client.json.Json;
import com.google.gson.Gson;
import com.viksitpro.core.utilities.DBUTILS;

import in.superadmin.bean.DataTableBean;


/**
 * Servlet implementation class UserManagementData
 */
@WebServlet("/UserManagementData")
public class UserManagementData extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UserManagementData() {
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
		 //System.out.println(paramName);
		 //System.out.println(request.getParameter(paramName));

		}
		DBUTILS db = new DBUTILS();
		String sql ="select name,email,gender,mobile,user_type,image_url from org_admin LIMIT 10 OFFSET "+request.getParameter("start").toString();
		String count = "select count(*) from org_admin";
		List<HashMap<String, Object>> countdata = db.executeQuery(count);
		 int counts=  Integer.parseInt(countdata.get(0).get("count").toString());
		 //System.out.println("ssc "+sql);
		List<HashMap<String, Object>> datas = db.executeQuery(sql);
		DataTableBean result = new DataTableBean();
        try {
			result.setDraw(Integer.parseInt(request.getParameter("draw").toString()));;
			result.setRecordsTotal(counts);;
			result.setRecordsFiltered(counts);
			ArrayList<ArrayList<String>> data = new ArrayList<>();
		for (HashMap<String, Object> item : datas) {
			ArrayList<String> a = new ArrayList<>();
			a.add(item.get("name").toString());
			a.add(item.get("email").toString());
			a.add(item.get("gender").toString());
			a.add(item.get("mobile").toString());
			a.add(item.get("user_type").toString());
			a.add(item.get("image_url").toString());
			data.add(a);
		}
		result.setData(data);
        } catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        Gson gson = new Gson();
		response.getWriter().println(gson.toJson(result));
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
