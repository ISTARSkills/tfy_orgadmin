package com.istarindia.android.pojo;

import java.util.Date;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;

@XmlRootElement(name = "lesson")
public class LessonPOJO implements Comparable<LessonPOJO> {

	private Integer id;
	private Integer playlistId;
	private String type;
	private String title;
	private String description;
	private String subject;
	private Integer orderId;
	private Integer duration;
	private String status;
	private String lessonUrl;
	private String imageUrl;

	public LessonPOJO() {

	}

	@XmlAttribute(name = "id", required = false)
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	@XmlAttribute(name = "playlistId", required = false)
	public Integer getPlaylistId() {
		return playlistId;
	}

	public void setPlaylistId(Integer playlistId) {
		this.playlistId = playlistId;
	}

	@XmlAttribute(name = "type", required = false)
	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	@XmlAttribute(name = "title", required = false)
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	@XmlAttribute(name = "description", required = false)
	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	@XmlAttribute(name = "subject", required = false)
	public String getSubject() {
		return subject;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

	@XmlAttribute(name = "orderId", required = false)
	public Integer getOrderId() {
		return orderId;
	}

	public void setOrderId(Integer orderId) {
		this.orderId = orderId;
	}

	@XmlAttribute(name = "duration", required = false)
	public Integer getDuration() {
		return duration;
	}

	public void setDuration(Integer duration) {
		this.duration = duration;
	}

	@XmlAttribute(name = "status", required = false)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	@Override
	public int compareTo(LessonPOJO o) {
		return this.orderId - o.orderId;
	}

	@XmlAttribute(name = "lessonUrl", required = false)
	public String getLessonUrl() {
		return lessonUrl;
	}

	public void setLessonUrl(String lessonUrl) {
		this.lessonUrl = lessonUrl;
	}

	@XmlAttribute(name = "imageUrl", required = false)
	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	@XmlTransient
	public boolean isFuture(ComplexObject cp) {
		for (CoursePOJO course : cp.getCourses()) {
			for (ModulePOJO module : course.getModules()) {
				for (ConcreteItemPOJO lesson : module.getLessons()) {
					if (lesson.getLesson().getId() == id) {
						for (TaskSummaryPOJO task : cp.getTasks()) {
							////ViksitLogger.logMSG(this.getClass().getName(),("task.getId()-->"+task.getId() + "   -           "+ lesson.getTaskId());
							if(lesson.getTaskId().intValue() == task.getId().intValue()){
								//ViksitLogger.logMSG(this.getClass().getName(),("I found my Task ->>"+lesson.getTaskId() );
								if((task.getDate().getTime()) - (new Date()).getTime() > 0){
									return true;
								}
							}
						}
					}
				}
			}

		}

		return false;

	}
}
