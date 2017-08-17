<%@page import="com.viksitpro.core.dao.entities.Context"%>
<%@page import="com.viksitpro.core.dao.entities.ContextDAO"%>
<%@page import="com.viksitpro.core.dao.entities.QuestionDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Question"%>
<%@page import="com.viksitpro.core.dao.entities.CourseDAO"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.dao.entities.Course"%>
<%@page import="java.util.ArrayList"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<jsp:include page="../inc/head.jsp"></jsp:include>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	List<Question> questions = new QuestionDAO().findAll();
			
%>

<body class="top-navigation" id="question_list"
	data-helper='This page is used to list questions.'>
	<div id="wrapper">
	<div id="page-wrapper" class="gray-bg">
		<jsp:include page="../inc/navbar.jsp"></jsp:include>
		
			<%
				String[] brd = { "Dashboard", "Questions" };
			%>
			<%=UIUtils.getPageHeader("Questions Table", brd)%>

			<div class="row card-box scheduler_margin-box">
				<div class="col-lg-2">
					<!-- <button class="btn btn-outline btn-primary dim question-edit-popup"
						data-question_id="-3" type="button">
						<i class="fa fa-plus-circle"></i>
					</button> -->
					<button type="button"  data-question_id='-3' class="btn btn-w-m btn-danger question-edit-popup">
						<i class="fa fa-plus"></i> Create Question
					</button>
				</div>
			</div>
			
			<div class="row card-box scheduler_margin-box">

				<div class="ui-group">
					<h3 class="ui-group__title">Filter</h3>
					<div class="filters button-group js-radio-button-group btn-group">
						<button class="button btn btn-danger button_spaced btn-xs"
							data-filter="*">show all</button>
						<%
						   
							ArrayList<String> arrayList = new ArrayList<>();
							ArrayList<String> displayList = new ArrayList<>();
							boolean check=false;
							for (Question question : questions) {
								int context = question.getContext_id();
								Context contexts = (Context)new ContextDAO().findById(context);
								String context_name = "";
								
								if (contexts != null && contexts.getTitle() != null && !contexts.getTitle().contentEquals("")) {
									context_name = contexts.getTitle().trim().replace(" ", "_").replace("/", "_").toLowerCase();
									if (!arrayList.contains(context_name)) {
										arrayList.add(context_name);
										displayList.add(contexts.getTitle());
									}
								}else{
									check=true;
								}
							}
							
							
								if(check){
									arrayList.add("n_a");
									displayList.add("N/A");
								}
							
							

							int i = 0;
							for (String c_category : arrayList) {
						%>

						<button class="button btn btn-white button_spaced btn-xs" data-filter=".<%=c_category%>"><%=displayList.get(i)%></button>
						<%
							i++;
							}
						%>
					</div>
				</div>

			</div>
			
			<div class="wrapper wrapper-content animated fadeInRight card-box scheduler_margin-box no_padding_box">
				<div class="row">
					<div class="col-lg-12">
                    <div class="ibox float-e-margins" style="margin: 0px;">
                        <div class="ibox-content">
                            <div class="row">
                               
                                <div class="col-sm-8 m-b-xs">
                                    <div data-toggle="buttons" class="btn-group">
                                    
                                        <label class="btn btn-sm btn-white difficult_level" data-difficult_level="1"> <input type="radio" id="option1" name="options"> Difficulty Level 1 </label>
                                        <label class="btn btn-sm btn-white difficult_level"  data-difficult_level="2"> <input type="radio" id="option2" name="options"> Difficulty Level 2 </label>
                                        <label class="btn btn-sm btn-white difficult_level"  data-difficult_level="3"> <input type="radio" id="option3" name="options"> Difficulty Level 3 </label>
                                        <label class="btn btn-sm btn-white difficult_level"  data-difficult_level="4"> <input type="radio" id="option4" name="options"> Difficulty Level 4 </label>
                                        <label class="btn btn-sm btn-white difficult_level"  data-difficult_level="5"> <input type="radio" id="option5" name="options"> Difficulty Level 5 </label>
                                        
                                    </div>
                                </div>
                                <div class="col-sm-4">
                                    <div class="input-group"><input type="text" placeholder="Search" class="input-sm form-control"> <span class="input-group-btn">
                                        <button type="button" class="btn btn-sm btn-primary"> Go!</button> </span></div>
                                </div>
                            </div>
                            <div class="table-responsive">
                           
                                <table class="table  table-bordered" id='question_list_table' data-url='../question_list' data-count="0">
                                    <thead>
                                    <tr>
                                             <th data-visisble='true'>#</th>
											<th data-visisble='true'>Question Text</th>
											<th data-visisble='true'>Question Skill</th>
											<th data-visisble='true'>Question Type</th>
											<th data-visisble='true'>Difficulty Level</th>
											<th data-visisble='true'>action</th>
                                    </tr>
                                    </thead>
                                    <tbody id="question_data">
                                    
                                    </tbody>
                                </table>
                                    <div id="page-selection" style="text-align: center"></div>
                                
                            </div>

                        </div>
                    </div>
                </div>
				</div>
			</div>
		</div>
	</div>
</body>
<!-- Mainly scripts -->
<jsp:include page="../inc/foot.jsp"></jsp:include>
<script>
        // init bootpag
       
    </script>