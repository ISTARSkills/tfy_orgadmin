package in.orgadmin.utils.bulkupload;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedList;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;

public class BulkUploadUtils {

	
	public String getStudents(File file, LinkedList<String> columnOrder) throws IOException {
		StringBuffer table = new StringBuffer();
		
		//table div starts
		table.append("<div class='table-responsive'>  <table id='datatable_report_777' data-graph_title='Confirm details' data-graph_containter='report_container_777' data-graph_type='table' class=' datatable_report table table-striped table-bordered table-hover dataTables-example' > ");

		
		
		//thead div starts
		table.append("<thead> <tr style='font-size: 11px;'>");
		
		//thead columns starts
		for(String column : columnOrder) {
			table.append("<th>  " + column + "  </th>");
		}
		//thead columns end
		
		//thead div ends
		table.append("</tr> </thead>");
		
		
		

		//tfoot div starts
		table.append("<tfoot> <tr style='font-size: 11px;'>");

		//tfoot columns starts
		for(String column : columnOrder) {
			table.append("<th>  " + column + "  </th>");
		}
		//tfoot columns end
		
		//tfoot div ends
		table.append("</tr> </tfoot>");
		
		
		

		//tbody div starts
		table.append("<tbody>");

		//tbody columns starts
		int rowId = 0;
		for(LinkedList<Cell> row : getContent(file)) {
			table.append("<tr id='row_" + rowId + "' class='DTrow' style='font-size: 11px;'>");
			int ite = 0;
			for(String column : columnOrder) {
				//table.append("<td id='row_" + rowId +"_"+ column + "' class='row_" + rowId + " ," + column + "'>");
		
				
				table.append(CellValidatorFactory.getInstance().getValidator(column.toUpperCase()).getValidatedCellContent(row.get(ite++), rowId, column));
				
				//table.append("</td>");
			}
			table.append("</tr>");
			rowId++;
		}
		//tbody columns end
		
		//tbody div ends
		table.append("</tbody>");
		
		
		
		
		
		//table div ends
		table.append("</table> </div> <div id='report_container_777'></div>");
		return table.toString();
	}
	
	public LinkedList<LinkedList<Cell>> getContent(File file) throws IOException {
		FileInputStream fileInputStream = new FileInputStream(file);
        @SuppressWarnings("resource")
		HSSFWorkbook workbook = new HSSFWorkbook(fileInputStream);
        HSSFSheet worksheet = workbook.getSheetAt(0);
        Iterator<Row> rowIterator = worksheet.iterator();
        rowIterator.next();
        LinkedList <LinkedList <Cell>> cellMatrix = new LinkedList <>();
        
        boolean IS_HEADER_ROW = true;
        for (Row row : worksheet) {
        	if(!IS_HEADER_ROW) {
	        	LinkedList<Cell> cellsInRow = new LinkedList <>();
	            for (Cell cell : row) {
	            	
	            	Iterator<Cell> cellIterator = row.cellIterator();
	            	ArrayList<String> temp = new ArrayList<>();
	            	
					while (cellIterator.hasNext()) {
						HSSFCell cell1 = (HSSFCell) cellIterator.next();
						switch (cell1.getCellType()) {
						case HSSFCell.CELL_TYPE_NUMERIC:
							temp.add(cell1.getNumericCellValue() + "");
							break;
						case HSSFCell.CELL_TYPE_STRING:
							temp.add(cell1.getStringCellValue());
							break;
							
						case HSSFCell.CELL_TYPE_BLANK:
							temp.add("CELL_TYPE_BLANK");
							break;

						}
					}
					
	            	cellsInRow.add(cell);
	            }
	            cellMatrix.add(cellsInRow);
        	}
        	IS_HEADER_ROW = false ;
        }
        
		return cellMatrix;
	}
	
	//Creating a static class with possible columns would be great. But later maybe! 
	public ArrayList<String> getStudentColumns() {
		ArrayList<String> columns = new ArrayList<>();
		
		columns.add("Name");
		columns.add("Email");
		columns.add("Mobile");
		columns.add("Gender");
		
		return columns;
	}
	
}
