/**
 * 
 */
package tfy.admin.services;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.viksitpro.core.dao.entities.Batch;
import com.viksitpro.core.dao.entities.BatchGroup;
import com.viksitpro.core.dao.entities.BatchGroupDAO;
import com.viksitpro.core.dao.entities.Course;
import com.viksitpro.core.dao.entities.CourseDAO;
import com.viksitpro.core.dao.entities.Organization;
import com.viksitpro.core.dao.entities.OrganizationDAO;
import com.viksitpro.core.utilities.DBUTILS;

/**
 * @author mayank
 *
 */
public class AdminServices {

	public ArrayList<Course> getCoursesInCollege(int college_id)
	{
		CourseDAO dao = new CourseDAO();
		if(college_id==-3)
		{
			//super admin
			return (ArrayList<Course>)dao.findAll();
		}
		else
		{
			ArrayList<Course> courses = new ArrayList<>();
			ArrayList<Integer>alreadyAddedCourses = new ArrayList<>();
			Organization org = new OrganizationDAO().findById(college_id);
			for(BatchGroup bg : org.getBatchGroups())
			{
				for(Batch batch: bg.getBatchs())
				{
					if(!alreadyAddedCourses.contains(batch.getCourse().getId()))
					{
						alreadyAddedCourses.add(batch.getCourse().getId());
						courses.add(batch.getCourse());
					}
				}
			}
			
			return courses;
		}	
	}
	
	@SuppressWarnings("unchecked")
	public ArrayList<BatchGroup> getBatchGroupInCollege(int college_id)
	{
		
		BatchGroupDAO dao = new BatchGroupDAO();
		ArrayList<BatchGroup> batchGroup = new ArrayList<>();
		if(college_id==-3)
		{
			//super admin
			return (ArrayList<BatchGroup>)dao.findAll();
		}
		else
		{
			
			Organization org = new OrganizationDAO().findById(college_id);
			
			batchGroup.addAll(org.getBatchGroups());
	
		}
		return batchGroup;
		
	}
	
}
