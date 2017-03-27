/**
 * 
 */
package in.orgadmin.utils.bulkupload;

import org.apache.poi.ss.usermodel.Cell;

/**
 * @author ayrus
 *
 */
public abstract class CellValidator {
	
	public CellValidator() {
		super();
	}

	public abstract String getValidatedCellContent(Cell cell, int rowId, String columnName) ;

}
