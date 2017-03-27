/**
 * 
 */
package in.orgadmin.utils.bulkupload;

import org.apache.poi.ss.usermodel.Cell;

/**
 * @author ayrus
 *
 */
public class TextValidator extends CellValidator {

	/* (non-Javadoc)
	 * @see in.orgadmin.utils.bulkupload.CellValidator#getValidatedCellContent(org.apache.poi.ss.usermodel.Cell)
	 */
	@Override
	public String getValidatedCellContent(Cell cell, int rowId, String columnName)  {
		String out1 = "-";
             StringBuffer out = new StringBuffer();
		
		 out.append("<td id='row_" + rowId +"_"+ columnName + "' class='no-error, row_" + rowId + " ," + columnName + "'>");

		try {//out1 = cell.getStringCellValue().replaceAll("\\s","");
			out.append(cell.getStringCellValue().replaceAll("\\s",""));
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		out.append("</td>");
		return out.toString();
	}

}
