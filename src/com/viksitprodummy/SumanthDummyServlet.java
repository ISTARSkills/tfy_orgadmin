package com.viksitprodummy;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.google.gson.Gson;

/**
 * Servlet implementation class SumanthDummyServlet
 */
@WebServlet("/SumanthDummyServlet")
public class SumanthDummyServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public SumanthDummyServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		/*['Year', 'Sales', 'Expenses', 'Profit'],
        ['2014', 1000, 400, 200],
        ['2015', 1170, 460, 250],
        ['2016', 660, 1120, 300],
        ['2017', 1030, 540, 350]*/

		Random rand = new Random();
		ArrayList<ArrayList<String>> arrayList = new ArrayList<>();
		try {
			ArrayList<String> list=new  ArrayList<>();	
			
			list.add("Session");
			list.add("Date");
			
			for(int j=0;j<4;j++) {
				list.add(j==0?"EAST":j==1?"WEST":j==2?"NORTH":j==3?"SOUTH":"");	
			
			}	
			
			arrayList.add(list);
			
			for(int j=0;j<4;j++) {
				ArrayList<String> list1= new  ArrayList<>();	
				int  n = rand.nextInt(50) + 1;	
				list1.add(j==0?"1":j==1?"2":j==2?"3":j==3?"4":"");
				list1.add(j==0?"12 July 2107":j==1?"12 Sep 2107":j==2?"12 Oct 2107":j==3?"12 Nov 2107":"");

				
				for(int i=0;i<4;i++) {
					
					list1.add(j==0?"5"+n+".1":j==1?"4"+n+".1":j==2?"3"+n+".1":j==3?"2"+n+".1":"");
	
				}
				
				
				
				arrayList.add(list1);
		    }
			
			/*for(int j=0;j<4;j++) {
				AttendenceData attendenceData = new AttendenceData();
				ArrayList<ArrayList<String>> arrayList = new ArrayList<>();
			attendenceData.setName(j==0?"EAST":j==1?"WEST":j==2?"NORTH":j==3?"SOUTH":"");
			
			for (int i = 0; i < 4; i++) {
				ArrayList<String> list=new  ArrayList<>();	
				int  n = rand.nextInt(50) + 1;
				list.add(i==0?"12 July 2107":i==1?"12 Sep 2107":i==2?"12 Oct 2107":i==3?"12 Nov 2107":"");
				list.add(i==0?"5"+n+".1":i==1?"4"+n+".6":i==2?"3"+n+".5":i==3?"4"+n+".5":"");
				arrayList.add(list);
			}
			attendenceData.setColor(j==0?"#30beef":j==1?"#bae88a":j==2?"#fd6d81":j==3?"#7295fd":"");
			attendenceData.setArrayList(arrayList);
			jsonarray.add(attendenceData);
			}*/
	
			
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		String json = new Gson().toJson(arrayList);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		 response.getWriter().write(json);

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		doGet(request, response);
	}

	public class AttendenceData {
		
		ArrayList<ArrayList<String>> data = new ArrayList<>();
		String color;
		public AttendenceData() {
			super();
		}

		public ArrayList<ArrayList<String>> getArrayList() {
			return data;
		}

		public void setArrayList(ArrayList<ArrayList<String>> data) {
			this.data = data;
		}

	}

}
