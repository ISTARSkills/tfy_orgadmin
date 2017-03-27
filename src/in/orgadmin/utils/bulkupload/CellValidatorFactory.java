/**
 * 
 */
package in.orgadmin.utils.bulkupload;


/**
 * @author ayrus
 *
 */
public class CellValidatorFactory {

	private static CellValidatorFactory instance = null;
	
	protected CellValidatorFactory() {
	      // Exists only to defeat instantiation.
	}
	
	public static CellValidatorFactory getInstance() {
		if(instance == null) {
			instance = new CellValidatorFactory();
		}
		return instance;
	}
	
	public CellValidator getValidator(String columnName) {
		switch (columnName) {
		case "TEXT":
			return (new TextValidator());
		case "GENDER":
			return (new GenderValidator());
		case "NUMBER":
			return (new NumberValidator());
		case "MOBILE":
			return (new MobileNumberValidator());
		case "EMAIL":
			return (new EmailValidator());
		case "PINCODE":
			return (new PincodeValidator());
		default:
			return (new TextValidator());
		}
	}
}
