/**
 * 
 *//*
package com.viksitpro.chat.services;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.viksitpro.core.dao.entities.BatchGroup;
import com.viksitpro.core.dao.entities.BatchStudents;
import com.viksitpro.core.dao.entities.ChatGroup;
import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.IstarUserDAO;
import com.viksitpro.core.dao.entities.UserProfile;



*//**
 * @author ComplexObject
 *
 *//*
public class ChatUserService {

	*//**
	 * 
	 * @param email email Email of Loggedd in User 
	 * @return returns the List of ChatGroup  user belongs to 
	 *//*
	
	public List<ChatGroup> getChatGroupUserBelongsTo(String email)
	{
		IstarUser currentUser = getIstarUser(email);
		Set<ChatGroupMember> chatGroupMembers= (Set<ChatGroupMember>) currentUser.getChatGroupMembers();
		List<ChatGroup> groupsUserBelongsTo = new ArrayList<>();
		
		for(ChatGroupMember groupMember : chatGroupMembers)
		{
			groupsUserBelongsTo.add(groupMember.getChatGroup());
		}
		return groupsUserBelongsTo;
	}
	
	*//**
	 * 
	 * @param email Email of Loggedd in User 
	 * @return returns the List of Chat User belongs to his group 
	 *//*
	public List<IstarUser> getUserToDisplay(String email) {
		List<IstarUser> usersInGroup = new ArrayList<>();
		
		IstarUser currentUser = getIstarUser(email);
		Set<ChatGroupMember> chatGroupMembers= (Set<ChatGroupMember>) currentUser.getChatGroupMembers();
		List<ChatGroup> groupsUserBelongsTo = new ArrayList<>(); 
		for(ChatGroupMember groupMember : chatGroupMembers)
		{
			groupsUserBelongsTo.add(groupMember.getChatGroup());
		}
		
		for(ChatGroup group : groupsUserBelongsTo)
		{
			for(ChatGroupMember member : group.getChatGroupMembers())
			{
				if(member.getIstarUser().getId()!=currentUser.getId())
				{
					usersInGroup.add(member.getIstarUser());
				}
			}
		}
		//ViksitLogger.logMSG(this.getClass().getName(),);
		return usersInGroup;
	}
	
	
	public ArrayList<IstarUser> onlineUsersInBGroup(int id)
	{
		ArrayList<IstarUser> onlineUsers = new ArrayList<>();
		IstarUser user = new IstarUserDAO().findById(id);
		ArrayList<Integer> bg = new ArrayList<>();
		ArrayList<Integer> usersAdded = new ArrayList<>();
		ArrayList<BatchGroup> bgroups = new ArrayList<>(); 
		for(BatchStudents bs : user.getBatchStudentses())
		{
			if(!bg.contains(bs.getBatchGroup().getId()))
			{	
				bg.add(bs.getBatchGroup().getId());
				bgroups.add(bs.getBatchGroup());
			}
		}
		
		for(BatchGroup bgg : bgroups)
		{
			for(BatchStudents bs2: bgg.getBatchStudentses())
			{
				if(bs2.getIstarUser().getId() != id && !usersAdded.contains(bs2.getIstarUser().getId()))
				{					
						usersAdded.add(bs2.getIstarUser().getId());
						if(Chat.userIdBGGroupIdMap.containsKey(bs2.getIstarUser().getId()))
						{
						onlineUsers.add(bs2.getIstarUser());
						}
				}
			}
		}
		
		return onlineUsers;
	}

	public ArrayList<IstarUser> onlineUsersInCustomGroup(int id)
	{
		
		ArrayList<IstarUser> onlineUsers = new ArrayList<>();
		IstarUser user = new IstarUserDAO().findById(id);
		ArrayList<Integer> chatgrps = new ArrayList<>();
		ArrayList<Integer> usersAdded = new ArrayList<>();
		ArrayList<ChatGroup> chatgroups = new ArrayList<>(); 
		for(ChatGroup bs : user.getChatGroups())
		{
			for(IstarUser member  : bs.getIstarUsers())
			{
				if(member.getId() != id && !usersAdded.contains(member.getId()))
				{					
						usersAdded.add(member.getId());
						if(Chat.userIdCustomGroupIdMap.containsKey(member.getId()))
						{
						onlineUsers.add(member);
						}
				}
			}
		}		
		
		
		return onlineUsers;
	}
	
	
	*//**
	 * 
	 * @param email Email of IstarUser by which a user is logged in
	 * @return Chat User instance corresponding to IstarUser
	 *//*
	public IstarUser getIstarUser(String email)
	{
		IstarUser IstarUser = new IstarUser();
		List<IstarUser> IstarUsers = new IstarUserDAO().findByEmail(email);
		if(IstarUsers.size()>0)
		{
			return IstarUsers.get(0);
		}
		else
		{
			//create a chat User
			List<IstarUser> istarUsers  = new  IstarUserDAO().findByEmail(email);
			if(istarUsers.size()>0)
			{
				IstarUser istarUser = istarUsers.get(0);
				UserProfile istarProfile = istarUser.getUserProfile();
				IstarUser = createIstarUser(istarUser.getId(), istarUser.getEmail(), istarUser.getPassword(), istarUser.getMobile());
				
				IstarUserProfile profile = createUserProfile(IstarUser.getId(), istarProfile.getAddress().getId(), istarProfile.getFirstName(), istarProfile.getLastName(), istarProfile.getDob(),
						istarProfile.getGender(), istarProfile.getProfileImage(), istarProfile.getAadharNo());
				IstarUser.setIstarUserProfile(profile);
				IstarUser = updateIstarUserToDAO(IstarUser);
			}
		}	
		
		return IstarUser;
	}
	
	
	public IstarUser createIstarUser(Integer id, String email, String password, Long mobile){
		
		IstarUser IstarUser = new IstarUser();
		
		java.util.Date date = new java.util.Date();
		Timestamp current = new Timestamp(date.getTime());
		
		IstarUser.setEmail(email);
		IstarUser.setPassword(password);
		IstarUser.setMobile(mobile);
		IstarUser.setCreatedAt(current);
		IstarUser.setId(id);
		IstarUser = saveIstarUserToDAO(IstarUser);
		if(IstarUser!=null)
		{
			createUserProfile(IstarUser.getId(), null, null, null, null, null, null, null);
		}
		return IstarUser;
	}
	
	public IstarUser updateIstarUser(Integer IstarUserId, String email, String password, Long mobile){
		
		IstarUser IstarUser = new IstarUserDAO().findById(IstarUserId);
		
		java.util.Date date = new java.util.Date();
		Timestamp current = new Timestamp(date.getTime());
		
		IstarUser.setEmail(email);
		IstarUser.setPassword(password);
		IstarUser.setMobile(mobile);
		IstarUser.setCreatedAt(current);
	
		IstarUser = updateIstarUserToDAO(IstarUser);
		if(IstarUser.getIstarUserProfile()==null)
		{
			createUserProfile(IstarUser.getId(), null, null, null, null, null, null, null);
		}
		return IstarUser;
	}
	
	public IstarUser saveIstarUserToDAO(IstarUser IstarUser) {

		IstarUserDAO IstarUserDAO = new IstarUserDAO();

		Session IstarUserSession = IstarUserDAO.getSession();
		Transaction IstarUserTransaction = null;
		try {
			IstarUserTransaction = IstarUserSession.beginTransaction();
			IstarUserSession.save(IstarUser);
			IstarUserTransaction.commit();
		} catch (HibernateException e) {
			e.printStackTrace();
			if (IstarUserTransaction != null)
				IstarUserTransaction.rollback();
			e.printStackTrace();
		} finally {
			IstarUserSession.close();
		}
		return IstarUser;
	}
	
	
	public IstarUser updateIstarUserToDAO(IstarUser IstarUser) {

		IstarUserDAO IstarUserDAO = new IstarUserDAO();

		Session IstarUserSession = IstarUserDAO.getSession();
		Transaction IstarUserTransaction = null;
		try {
			IstarUserTransaction = IstarUserSession.beginTransaction();
			IstarUserSession.update(IstarUser);
			IstarUserTransaction.commit();
		} catch (HibernateException e) {
			e.printStackTrace();
			if (IstarUserTransaction != null)
				IstarUserTransaction.rollback();
			e.printStackTrace();
		} finally {
			IstarUserSession.close();
		}
		return IstarUser;
	}
	
	*//**
	 * 
	 * @param IstarUserId Integer value of IstarUser Id
	 * @param addressId	Integer value of Address Id
	 * @param firstName String value of First Name
	 * @param lastName String value of Last Name
	 * @param date Date value of Date of Birth
	 * @param gender String value of gender
	 * @param profileImage String value of profileImage
	 * @param aadhar Long value of Aadhar Card
	 * @return saved User Profile Object of IstarUser
	 *//*
	public IstarUserProfile createUserProfile(Integer IstarUserId, Integer addressId, String firstName, String lastName, java.util.Date date, String gender, String profileImage, Long aadhar)
	{
		IstarUser user = new IstarUserDAO().findById(IstarUserId);
		
		IstarUserProfile userProfile = user.getIstarUserProfile();
		if(userProfile!=null)
		{
			return userProfile; 
		}
		else
		{
			//create a new user profile
			userProfile = new IstarUserProfile();
			userProfile.setAadharNo(aadhar);
			
			userProfile.setAddressId(addressId);
			userProfile.setDob(date);
			userProfile.setFirstName(firstName);
			userProfile.setGender(gender);			
			userProfile.setIstarUser(user);
			userProfile.setLastName(lastName);
			userProfile.setProfileImage(profileImage);		
			userProfile = saveUserProfileToDAO(userProfile);
		}	
		
		
		return userProfile;
	}

	public IstarUserProfile updateIstarUserProfile(Integer IstarUserId, Integer addressId, String firstName, String lastName, java.util.Date date, String gender, String profileImage, Long aadhar)
	{
		IstarUser user = new IstarUserDAO().findById(IstarUserId);
		
		IstarUserProfile userProfile = user.getIstarUserProfile();
		if(userProfile!=null)
		{
			userProfile.setAadharNo(aadhar);
			
			userProfile.setAddressId(addressId);
			userProfile.setDob(date);
			userProfile.setFirstName(firstName);
			userProfile.setGender(gender);			
			userProfile.setIstarUser(user);
			userProfile.setLastName(lastName);
			userProfile.setProfileImage(profileImage);
			userProfile = updateUserProfileToDAO(userProfile);
		}
		else
		{
			//create a new user profile
			userProfile = new IstarUserProfile();
			userProfile.setAadharNo(aadhar);
			
			userProfile.setAddressId(addressId);
			userProfile.setDob(date);
			userProfile.setFirstName(firstName);
			userProfile.setGender(gender);			
			userProfile.setIstarUser(user);
			userProfile.setLastName(lastName);
			userProfile.setProfileImage(profileImage);		
			userProfile = saveUserProfileToDAO(userProfile);
		}	
		
		
		return userProfile;
	}
	
	
	*//**
	 * @param userProfile IstarUserProfile Object to be saved in database
	 * @return returns Saved IstarUserProfile Object in case of success. In case of failure method throws exception.
	 *//*
	private IstarUserProfile saveUserProfileToDAO(IstarUserProfile userProfile) {
		IstarUserProfileDAO userProfileDAO = new IstarUserProfileDAO();
		Session userProfileSession = userProfileDAO.getSession();
		Transaction userProfileTransaction = null;
		try {
			userProfileTransaction = userProfileSession.beginTransaction();
			userProfileSession.save(userProfile);
			userProfileTransaction.commit();
		} catch (HibernateException e) {
			e.printStackTrace();
			if (userProfileTransaction != null)
				userProfileTransaction.rollback();
			e.printStackTrace();			
		} finally {
			userProfileSession.close();
		}
		return userProfile;
	}
	
	private IstarUserProfile updateUserProfileToDAO(IstarUserProfile userProfile) {
		IstarUserProfileDAO userProfileDAO = new IstarUserProfileDAO();
		Session userProfileSession = userProfileDAO.getSession();
		Transaction userProfileTransaction = null;
		try {
			userProfileTransaction = userProfileSession.beginTransaction();
			userProfileSession.update(userProfile);
			userProfileTransaction.commit();
		} catch (HibernateException e) {
			e.printStackTrace();
			if (userProfileTransaction != null)
				userProfileTransaction.rollback();
			e.printStackTrace();			
		} finally {
			userProfileSession.close();
		}
		return userProfile;
	}
}
*/