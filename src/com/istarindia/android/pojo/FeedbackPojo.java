/**
 * 
 */
package com.istarindia.android.pojo;

/**
 * @author mayank
 *
 */
public class FeedbackPojo {

	String name;
    String rating;

    public FeedbackPojo() {
    }

    public FeedbackPojo(String name, String rating) {
        this.name = name;
        this.rating = rating;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getRating() {
        return rating;
    }

    public void setRating(String rating) {
        this.rating = rating;
    }

}
