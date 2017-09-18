<%@page import="com.viksitpro.core.elt.interactive.CMSSlide"%>
<%@page import="com.viksitpro.core.elt.*"%>
<%@page import="com.viksitpro.core.elt.interactive.CMSLesson"%>
<%@page
	import="com.viksitpro.core.elt.interactive.InteractiveLessonServices"%>
<%@page import="com.istarindia.android.pojo.ComplexObject"%>
<%@page import="com.istarindia.android.pojo.RestClient"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>

<%
	boolean flag = false;
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	IstarUser user = (IstarUser) request.getSession().getAttribute("user");
	RestClient rc = new RestClient();
	ComplexObject cp = rc.getComplexObject(user.getId());
	if (cp == null) {
		flag = true;
		request.setAttribute("msg", "User Does Not Have Permission To Access");
		request.getRequestDispatcher("/login.jsp").forward(request, response);
	}
	request.setAttribute("cp", cp);

	InteractiveLessonServices services = new InteractiveLessonServices();
	int lessonId=-1;
	CMSLesson cmsLesson = null;
	if (request.getParameter("lesson_id") != null) {
		lessonId = Integer.parseInt(request.getParameter("lesson_id"));
		cmsLesson = services.getCmsInteractiveLesson(lessonId);
	}
%>


<style>
.badge {
	display: inline-block;
	padding: .25em .4em;
	font-size: 75%;
	font-weight: 700;
	line-height: 1;
	color: #fff;
	text-align: center;
	white-space: nowrap;
	vertical-align: baseline;
	border-radius: .25rem;
}

.badge.badge-drag {
	background-color: #eb384f;
}

.add-slide {
	background-color: #eb384f;
	padding: 10px !important;
}

.badge.badge-match {
	background-color: #5bc0de;
}

.badge.badge-ordering {
	background-color: #5cb85c;
}

#interactive-slides-lists {
	border: solid 1px #eee;
	width: 100%;
	min-height: 600px;
}

#interactive-slides-lists>div::-webkit-scrollbar-track {
	-webkit-box-shadow: inset 0 0 6px rgba(0, 0, 0, 0.3);
	background-color: #ebeaea;
}

#interactive-slides-lists>div::-webkit-scrollbar {
	border-radius: 100px;
	width: 6px;
	background-color: #ebeaea;
}

#interactive-slides-lists>div::-webkit-scrollbar-thumb {
	border-radius: 100px;
	background-color: #eb384f;
}
</style>
<jsp:include page="/inc/head.jsp"></jsp:include>


<body id="interactive_lesson">

	<jsp:include page="/inc/navbar.jsp"></jsp:include>

	<div class="jumbotron gray-bg">
		<div class="container mx-0">
			<div class="row">
				<h1>Interactive Lesson</h1>
			</div>
		</div>


		<div class="container mx-0 w-100"
			style='max-width: 100% !important; overflow-x: auto;'>
			<div class='row my-1'>
				<div class='col-8'>
					<span class="badge add-slide"><i class="fa fa-plus-circle"
						aria-hidden="true"></i> Add Slide</span>
				</div>
				<div class='col-4 text-right'>
					<span class="badge badge-drag">Tap/Drag Based</span> <span
						class="badge badge-match">Match the Following</span> <span
						class="badge badge-ordering">Ordering</span>
				</div>
			</div>

			<div id="interactive-slides-lists"></div>

		</div>


	</div>
	<jsp:include page="/inc/foot.jsp"></jsp:include>
	<script src="<%=baseURL%>assets/js/plugins/gojs/go.js"></script>
	<script src="<%=baseURL%>assets/js/plugins/gojs/go-debug.js"></script>
	<script>
		$(document).ready(function() {
			init();
			$('.add-slide').unbind().on("click",function(){
				window.location='./lesson_interactive.jsp?lesson_id=<%=lessonId%>';
			});
			
		});

		function init() {
			if (window.goSamples)
				goSamples();

			var $ = go.GraphObject.make;

			myDiagram = $(go.Diagram, "interactive-slides-lists", {
				initialContentAlignment : go.Spot.Center,
				"undoManager.isEnabled" : true,
				layout : $(go.TreeLayout)
			});
			myDiagram.isReadOnly = false;

			var detailtemplate = $(go.Node, "Spot", $(go.Panel, "Auto", $(
					go.Shape, "RoundedRectangle", {
						stroke : '#eb384f'
					}, {
						fill : "#fff",

					}), $(go.Panel, "Table", {
				padding : 5,
				defaultAlignment : go.Spot.Left,
				minSize : new go.Size(80, 130)
			}, $(go.TextBlock, {
				row : 0,
				column : 0,
				columnSpan : 2,
				font : "bold 12pt sans-serif"
			}, new go.Binding("text", "key")), $(go.TextBlock, {
				row : 1,
				column : 0
			}, "Slide : "), $(go.TextBlock, {
				row : 1,
				column : 1
			}, new go.Binding("text", "data")))), $(go.Panel, "Spot",
					new go.Binding("opacity", "ribbon", function(t) {
						return t ? 1 : 0;
					}), {
						opacity : 0,
						alignment : new go.Spot(1, 0, 1, -1),
						alignmentFocus : go.Spot.TopRight
					}, $(go.Shape, {
						geometryString : "F1 M0 0 L30 0 70 40 70 70z",
						
						stroke : null,
						strokeWidth : 0
					},new go.Binding("fill", "ribbonColor")), $(go.TextBlock, new go.Binding("text", "ribbon"), {
						alignment : new go.Spot(1, 0, -29, 29),
						angle : 45,
						maxSize : new go.Size(100, NaN),
						stroke : "white",
						font : "bold 13px avenir-light",
						textAlign : "center"
					})));

			myDiagram.nodeTemplate = detailtemplate;
			

			myDiagram.addDiagramListener("ObjectDoubleClicked", function(ev) {

				var data;

				try {
					data = ev.subject.part.data.slideId;
				} catch (err) {

				}
				if (data) {
					var lessonString='<%=lessonId!=-1?"lesson_id="+lessonId+"&":""%>';
					window.location='./lesson_interactive.jsp?'+lessonString+'slide_id=' + data;
				}

			});

			myDiagram.linkTemplate = $(go.Link, {
				curve : go.Link.Bezier,
				toEndSegmentLength : 30,
				fromEndSegmentLength : 30
			}, $(go.Shape, {
				strokeWidth : 2,
				stroke : "#cb626f"
			}), $(go.TextBlock, {
				stroke : '#000'
			}, new go.Binding("text", "text")));

			var dataList = [];

			
			
			<%if (cmsLesson != null) {
				for (int i = 0; null != cmsLesson.getSlides() && i <cmsLesson.getSlides().size(); i++) {
					CMSSlide cmsslide = cmsLesson.getSlides().get(i);%>
				
			var obj = {};
			obj.key = <%=cmsslide.getOrder_id()%>;
			
			obj.slideId = <%=cmsslide.getId()%>;
			
			<%String type = "";
					String color = "";
					switch (cmsslide.getTemplate()) {
						case "D-T" :
							type = "TAP/Drag";
							color = "#eb384f";
							break;
						case "MATCH" :
							type = "MATCH";
							color = "#5bc0de";
							break;
						case "ORDERING" :
							type = "ORDER";
							color = "#5cb85c";
							break;
					}%>
				obj.data = "slide is about <%=type%>...";
			obj.ribbon = "<%=type%>";
			obj.ribbonColor="<%=color%>";

			dataList.push(obj);
	<%}
			}%>

			var linkList = [ {
				from : 1,
				to : 2,
				text : "Opts 1"
			}, {
				from : 1,
				to : 1,
				text : "Opts 3"
			}, {
				from : 1,
				to : 3,
				text : "Opts 2"
			}, {
				from : 3,
				to : 4,
				text : "Opts 1"
			}, {
				from : 4,
				to : 5,
				text : "opts 1"
			}, {
				from : 5,
				to : 6,
				text : "opts 1"
			}, {
				from : 6,
				to : 8,
				text : "opts 1"
			}, {
				from : 6,
				to : 9,
				text : "opts 1"
			}, {
				from : 8,
				to : 9,
				text : "opts 1"
			} ];
			myDiagram.model = new go.GraphLinksModel(dataList, linkList);
		}
	</script>
</body>
</html>