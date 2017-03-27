/**
 * 
 */
package in.orgadmin.utils.bulkupload;

import org.apache.poi.ss.usermodel.Cell;

/**
 * @author ayrus
 *
 */
public class PincodeValidator extends CellValidator {

	/* (non-Javadoc)
	 * @see in.orgadmin.utils.bulkupload.CellValidator#getValidatedCellContent(org.apache.poi.ss.usermodel.Cell)
	 */
	@Override
	public String getValidatedCellContent(Cell cell, int rowId, String columnName)  {
		StringBuffer out = new StringBuffer();
		String out1 = "-";
		 out.append("<td id='row_" + rowId +"_"+ columnName + "' class='no-error, row_" + rowId + " ," + columnName + "'>");

		try {
			
			out.append(cell.getNumericCellValue() + "".replaceAll("\\s",""));
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		out.append("</td>");
		return out.toString();
	}

}
