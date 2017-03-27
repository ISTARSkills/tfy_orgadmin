/**
 * 
 */
package in.orgadmin.utils.bulkupload;

import org.apache.poi.ss.usermodel.Cell;

/**
 * @author ayrus
 *
 */
public class NumberValidator extends CellValidator {

	/* (non-Javadoc)
	 * @see in.orgadmin.utils.bulkupload.CellValidator#getValidatedCellContent(org.apache.poi.ss.usermodel.Cell)
	 */
	@Override
	public String getValidatedCellContent(Cell cell, int rowId, String columnName)  {
		StringBuffer out = new StringBuffer();
		 out.append("<td id='row_" + rowId +"_"+ columnName + "' class='no-error, row_" + rowId + " ," + columnName + "'>");
		
		 String out1 = "-";
		 
		try {
			
			 out.append((long)(cell.getNumericCellValue()) + "");
		} catch (Exception e) {
			
			out.append(cell.getStringCellValue());
			e.printStackTrace();
		}
		out.append("</td>");
		return out.toString();
	}

}
