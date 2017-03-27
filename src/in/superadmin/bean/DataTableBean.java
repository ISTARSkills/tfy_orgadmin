package in.superadmin.bean;

import java.util.ArrayList;

public class DataTableBean {

	private int draw;
	private int recordsTotal;
	private int recordsFiltered;
	private  ArrayList<ArrayList<String>> data;
	public DataTableBean() {
		super();
		// TODO Auto-generated constructor stub
	}
	public DataTableBean(int draw, int recordsTotal, int recordsFiltered, ArrayList<ArrayList<String>> data) {
		super();
		this.draw = draw;
		this.recordsTotal = recordsTotal;
		this.recordsFiltered = recordsFiltered;
		this.data = data;
	}
	public int getDraw() {
		return draw;
	}
	public void setDraw(int draw) {
		this.draw = draw;
	}
	public int getRecordsTotal() {
		return recordsTotal;
	}
	public void setRecordsTotal(int recordsTotal) {
		this.recordsTotal = recordsTotal;
	}
	public int getRecordsFiltered() {
		return recordsFiltered;
	}
	public void setRecordsFiltered(int recordsFiltered) {
		this.recordsFiltered = recordsFiltered;
	}
	public ArrayList<ArrayList<String>> getData() {
		return data;
	}
	public void setData(ArrayList<ArrayList<String>> data) {
		this.data = data;
	}
	
}
