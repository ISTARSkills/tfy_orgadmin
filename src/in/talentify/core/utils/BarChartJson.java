package in.talentify.core.utils;

import java.util.ArrayList;

public class BarChartJson {
	String name;
	ArrayList<Float> data;
	public BarChartJson() {
		super();
		// TODO Auto-generated constructor stub
	}
	public BarChartJson(String name, ArrayList<Float> data) {
		super();
		this.name = name;
		this.data = data;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public ArrayList<Float> getData() {
		return data;
	}
	public void setData(ArrayList<Float> data) {
		this.data = data;
	}
	
	
}
