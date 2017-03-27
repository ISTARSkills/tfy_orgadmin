/**
 * 
 */
package in.orgadmin.utils.bulkupload;

import org.apache.poi.ss.usermodel.Cell;

/**
 * @author ayrus
 *
 */
public class GenderValidator extends CellValidator {

	/* (non-Javadoc)
	 * @see in.orgadmin.utils.bulkupload.CellValidator#getValidatedCellContent(org.apache.poi.ss.usermodel.Cell)
	 */
	@Override
	public String getValidatedCellContent(Cell cell, int rowId, String columnName)  {
		StringBuffer out = new StringBuffer();
		 
		String out1 = "-";
		if(!(cell.getStringCellValue().equals("")) && cell.getStringCellValue().equalsIgnoreCase("male") || cell.getStringCellValue().equalsIgnoreCase("female")){
			out.append("<td id='row_" + rowId +"_"+ columnName + "' class='no-error, row_" + rowId + " ," + columnName + "'>");

			try {
				
				 out.append(cell.getStringCellValue().replaceAll("\\s","").toUpperCase());
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			
			
		}else if(cell.getStringCellValue().equalsIgnoreCase("m") ){
			
			
			out.append("<td id='row_" + rowId +"_"+ columnName + "' class='no-error, row_" + rowId + " ," + columnName + "'>MALE");

			
		}else if(cell.getStringCellValue().equalsIgnoreCase("f") ){
			
			
			out.append("<td id='row_" + rowId +"_"+ columnName + "' class='no-error, row_" + rowId + " ," + columnName + "'>FEMALE");

		}
	
		else{
			
			out.append("<td id='row_" + rowId +"_"+ columnName + "' class='gender-error, row_" + rowId + " ," + columnName + "'>Please Set Proper Gender");

			
			
			}
		
		out.append("</td>");
		return out.toString();
	}

}
