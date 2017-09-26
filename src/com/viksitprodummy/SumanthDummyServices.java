package com.viksitprodummy;

import java.util.Random;

public class SumanthDummyServices {

	public StringBuffer getAttendanceDetailPerRole() {

		StringBuffer out = new StringBuffer();
		Random rand = new Random();
		out.append("<ul id='tree1'>");

		for (int i = 0; i < 4; i++) {
			int  n = rand.nextInt(25) + 10;
			int  m = rand.nextInt(25) + 10;
			int  v = rand.nextInt(25) + 10;
			int  c = rand.nextInt(25) + 10;
			out.append("<li>");
			out.append("<div style='display: initial;'>");
			out.append(
					"<div class='progress' style='display: inline; width: 30%; font-size: 17px; background-color: #fff; margin-right: 20px;'>Banks And Financial System</div>");
			out.append(
					"<div class='progress' style='display: inline-flex; width: 70%; position: absolute; top: 16px; background-color: #fff; right: 10px;'>");
			out.append(
					"<div class='progress-bar p-3' role='progressbar' style='width: "+n+"%; font-size: 14px; height: 3rem !important; background-color: #33b5e5;' aria-valuenow='"+n+"' aria-valuemin='0' aria-valuemax='100'>"+n+"%</div>");
			out.append(
					"<div class='progress-bar   p-3' role='progressbar' style='width: "+m+"%; font-size: 14px; height: 3rem !important; background-color: #fd6c81;' aria-valuenow='"+m+"' aria-valuemin='0' aria-valuemax='100'>"+m+"%</div>");
			out.append(
					"<div class='progress-bar   p-3' role='progressbar' style='width: "+v+"%; font-size: 14px; height: 3rem !important; background-color: #7692ff;' aria-valuenow='"+v+"' aria-valuemin='0' aria-valuemax='100'>"+v+"%</div>");
			out.append(
					"<div class='progress-bar   p-3' role='progressbar' style='width: "+c+"%; font-size: 14px; height: 3rem !important; background-color: #b8e986;' aria-valuenow='"+c+"' aria-valuemin='0' aria-valuemax='100'>"+c+"%</div>");
			out.append("</div>");
			out.append("</div>");
			if (i % 2 == 0) {
			out.append("<ul>");
			
				for (int j = 0; j < 4; j++) {
					n = rand.nextInt(100) + 10;
					out.append("<li>");
					out.append("<div style='display: initial;'>");
					out.append(
							"<div class='progress' style='display: inline; width: 30%; font-size: 17px; background-color: #fff; margin-right: 20px;'>Banks And Financial System sub "+j+"</div>");
					out.append(
							"<div class='progress' style='display: inline-flex; width: 70%; position: absolute; top: 16px; background-color: #fff; right: 10px;'>");
					out.append(
							"<div class='progress-bar p-3' role='progressbar' style='width: "+n+"%; font-size: 14px; height: 3rem !important; background-color: #33b5e5;' aria-valuenow='"+n+"' aria-valuemin='0' aria-valuemax='100'>"+n+"%</div>");
					out.append(
							"<div class='progress-bar   p-3' role='progressbar' style='width: "+m+"%; font-size: 14px; height: 3rem !important; background-color: #fd6c81;' aria-valuenow='"+m+"' aria-valuemin='0' aria-valuemax='100'>"+m+"%</div>");
					out.append(
							"<div class='progress-bar   p-3' role='progressbar' style='width: "+v+"%; font-size: 14px; height: 3rem !important; background-color: #7692ff;' aria-valuenow='"+v+"' aria-valuemin='0' aria-valuemax='100'>"+v+"%</div>");
					out.append(
							"<div class='progress-bar   p-3' role='progressbar' style='width: "+c+"%; font-size: 14px; height: 3rem !important; background-color: #b8e986;' aria-valuenow='"+c+"' aria-valuemin='0' aria-valuemax='100'>"+c+"%</div>");
					out.append("</div>");
					out.append("</div>");

					out.append("</li>");
				}
				out.append("</ul>");
			}
			
			out.append("</li>");

		}

		out.append("</ul>");

		return out;

	}

}
