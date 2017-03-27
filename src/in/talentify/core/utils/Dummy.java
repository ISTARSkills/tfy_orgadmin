package in.talentify.core.utils;

import java.util.ArrayList;

public class Dummy {
/*	String draw;
*/	String recordsTotal;
	String recordsFiltered;
	ArrayList<ArrayList<String>> data;
	public Dummy() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	
	
	public Dummy(String recordsTotal, String recordsFiltered, ArrayList<ArrayList<String>> data) {
		super();
		this.recordsTotal = recordsTotal;
		this.recordsFiltered = recordsFiltered;
		this.data = data;
	}



	/*public Dummy(String draw, String recordsTotal, String recordsFiltered, ArrayList<ArrayList<String>> data) {
		super();
		this.draw = draw;
		this.recordsTotal = recordsTotal;
		this.recordsFiltered = recordsFiltered;
		this.data = data;
	}
	public String getDraw() {
		return draw;
	}
	public void setDraw(String draw) {
		this.draw = draw;
	}*/
	public String getRecordsTotal() {
		return recordsTotal;
	}
	public void setRecordsTotal(String recordsTotal) {
		this.recordsTotal = recordsTotal;
	}
	public String getRecordsFiltered() {
		return recordsFiltered;
	}
	public void setRecordsFiltered(String recordsFiltered) {
		this.recordsFiltered = recordsFiltered;
	}
	public ArrayList<ArrayList<String>> getData() {
		return data;
	}
	public void setData(ArrayList<ArrayList<String>>  data) {
		this.data = data;
	}

	
}
