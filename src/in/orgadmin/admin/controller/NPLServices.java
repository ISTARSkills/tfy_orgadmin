/**
 * 
 */
package in.orgadmin.admin.controller;

import java.io.IOException;

import com.google.cloud.language.v1.AnalyzeSentimentResponse;
import com.google.cloud.language.v1.Document;
import com.google.cloud.language.v1.Document.Type;
import com.google.cloud.language.v1.LanguageServiceClient;
import com.google.cloud.language.v1.Sentiment;
/**
 * @author mayank
 *
 */
public class NPLServices {

	private final LanguageServiceClient languageApi;

	public NPLServices(LanguageServiceClient languageApi) {
		
		this.languageApi = languageApi;
	}
	
	 public Sentiment analyzeSentimentText(String text) throws IOException {
	        Document doc = Document.newBuilder()
	            .setContent(text).setType(Type.PLAIN_TEXT).build();
	        AnalyzeSentimentResponse response = languageApi.analyzeSentiment(doc);
	        return response.getDocumentSentiment();
	      }
	
	
}
