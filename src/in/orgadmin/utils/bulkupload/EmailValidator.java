/**
 * 
 */
package in.orgadmin.utils.bulkupload;

import java.util.HashMap;
import java.util.List;

import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;

import org.apache.poi.ss.usermodel.Cell;

import com.istarindia.apps.dao.DBUTILS;

/**
 * @author ayrus
 *
 */
public class EmailValidator extends CellValidator {

	/* (non-Javadoc)
	 * @see in.orgadmin.utils.bulkupload.CellValidator#getValidatedCellContent(org.apache.poi.ss.usermodel.Cell)
	 */
	@Override
	public String getValidatedCellContent(Cell cell, int rowId, String columnName)  {
		StringBuffer out = new StringBuffer();
		
		
		DBUTILS util = new DBUTILS();
		String out1 = "-";
		String chkdata = "select email from student where email='"+cell+"'";
		List<HashMap<String, Object>> data = util.executeQuery(chkdata);
		if(data.size() == 0){
				try {
					
				
				InternetAddress emailAddr = new InternetAddress(cell.getStringCellValue());
				
				
				System.out.println("-------------emailAddr----------------"+emailAddr);
			      emailAddr.validate();
			      
			      out.append("<td id='row_" + rowId +"_"+ columnName + "' class='no-error, row_" + rowId + " ," + columnName + "'>"+cell.getStringCellValue().replaceAll("\\s",""));

			      
			} catch (AddressException ex) {
			//	ex.printStackTrace();
				
				out.append("<td id='row_" + rowId +"_"+ columnName + "' class='email-valid-error, row_" + rowId + " ," + columnName + "'style='color:blue;'>"+ cell.getStringCellValue().replaceAll("\\s",""));
				
		
		       } 
				
				catch (Exception e) {
				e.printStackTrace();
			}
				
		}else{
			
			out.append("<td id='row_" + rowId +"_"+ columnName + "' class='already-exist-error, row_" + rowId + " ," + columnName + " 'style='color:red;'>Email Id Already Exist");

		
			
		}
		   
		out.append("</td>");
		return out.toString();
	}

}
