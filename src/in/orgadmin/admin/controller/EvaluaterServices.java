/**
 * 
 */
package in.orgadmin.admin.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.brunocvcunha.dense4j.DenseCalculator;

import com.google.cloud.language.v1.LanguageServiceClient;
import com.google.cloud.language.v1.Sentiment;

/**
 * @author ISTAR-SKILL
 *
 */
public class EvaluaterServices {

	public HashMap<String, Object> evaluateVoiceText(String speechText, String keyWords, String sampleText) {
		HashMap<String, Object> data = new HashMap<>();
		data.putAll(getSentimentAnalysisReport(sampleText));
		ArrayList<String> keyWordsList = new ArrayList<>();
		for(String key : keyWords.split("!#"))
		{
			keyWordsList.add(key);
		}
		data.putAll(getDensityMap(speechText, keyWordsList, sampleText));
		return data;
	}

	public HashMap<String, Object> getSentimentAnalysisReport(String text)
	{
		HashMap<String, Object> data = new HashMap<>();
		try {
			System.out.println("starting");
			NPLServices app = new NPLServices(LanguageServiceClient.create());
			Sentiment sentiment = app.analyzeSentimentText(text);
			if(sentiment!=null)
			{
				data.put("magnitude", sentiment.getMagnitude());
				data.put("score", sentiment.getScore());
				System.out.println(sentiment.getMagnitude());
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return data;
	}
	
	
	public HashMap<String, Integer> getDensityMap(String text, ArrayList<String> keywords, String sampleText)
	{
		HashMap<String, Integer> data = new HashMap<>();
		Map<String, Integer> expectedDensity = DenseCalculator.getKeywordsMap(sampleText);
		Map<String, Integer> systemDensity = DenseCalculator.getKeywordsMap(text);
		
		for(String keyWord: keywords)
		{
			System.out.println("keyWord "+keyWord);
			if(systemDensity.get(keyWord)!=null && expectedDensity.get(keyWord)!=null && expectedDensity.get(keyWord)!=0)
			{
				data.put(keyWord, (expectedDensity.get(keyWord)*100)/systemDensity.get(keyWord));
			}
		}
		return data;
	}


	
}
