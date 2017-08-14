








<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="shortcut icon" href="http://localhost:8080/img/user_images/new_talentify_logo.png" />
<title>Talentify | Admin-Portal</title>
<link href="http://localhost:8080/assets/css/bootstrap.min.css" rel="stylesheet">
<link href="http://localhost:8080/assets/css/plugins/dataTables/datatables.min.css"
	rel="stylesheet">

<link href="http://localhost:8080/assets/css/plugins/select2/select2.min.css"
	rel="stylesheet">

<link href="http://localhost:8080/assets/css/plugins/fullcalendar/fullcalendar.min.css"
	rel="stylesheet">
<link
	href="http://localhost:8080/assets/css/plugins/fullcalendar/fullcalendar.print.css"
	rel='stylesheet' media='print'>

<link href="http://localhost:8080/assets/css/plugins/datapicker/datepicker3.css"
	rel="stylesheet">
<link href="http://localhost:8080/assets/css/plugins/clockpicker/clockpicker.css"
	rel="stylesheet">
 <link href="http://localhost:8080/assets/css/jquery.contextMenu.css" rel="stylesheet" type="text/css" />
<link href="http://netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap-glyphicons.css" rel="stylesheet">
<link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">

<link href="http://localhost:8080/assets/css/animate.css" rel="stylesheet">
<link href="http://localhost:8080/assets/css/style.css" rel="stylesheet">
<link href="http://localhost:8080/assets/css/plugins/toastr/toastr.min.css"
	rel="stylesheet">

<link href="http://localhost:8080/assets/css/plugins/chosen/bootstrap-chosen.css"
	rel="stylesheet">
<link
	href="http://localhost:8080/assets/css/plugins/bootstrap-tagsinput/bootstrap-tagsinput.css"
	rel="stylesheet">
<link rel="stylesheet" href="http://localhost:8080/assets/css/jquery.rateyo.min.css">
<link href="http://localhost:8080/assets/css/plugins/sweetalert/sweetalert.css" rel="stylesheet">
<link href="http://localhost:8080/assets/css/wickedpicker.css" rel="stylesheet">
<link href="http://localhost:8080/assets/css/wickedpicker.min.css" rel="stylesheet">
<link href="http://localhost:8080/assets/css/timepicki.css" rel="stylesheet">
 <link href="http://localhost:8080/assets/css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">
<link href="http://localhost:8080/assets/css/plugins/steps/jquery.steps.css" rel="stylesheet">
<link href="http://localhost:8080/assets/css/plugins/bootstrap-tagsinput/bootstrap-tagsinput.css" rel="stylesheet">
<link href="http://localhost:8080/assets/css/plugins/ionRangeSlider/ion.rangeSlider.css" rel="stylesheet">
<link href="http://localhost:8080/assets/css/plugins/iCheck/custom.css" rel="stylesheet">
    <link href="http://localhost:8080/assets/css/plugins/ionRangeSlider/ion.rangeSlider.skinFlat.css" rel="stylesheet">
</head>

<body class="top-navigation" id="super_admin_scheduler">
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			





<div class="row border-bottom white-bg">
	
	
	

	
	<style>
.dropdown-submenu {
	position: relative;
}

.dropdown-submenu .dropdown-menu {
	top: 0;
	left: 100%;
	margin-top: -1px;
}
</style>
	<nav class="navbar navbar-static-top" role="navigation">
		<div class="navbar-header">
			<button aria-controls="navbar" aria-expanded="false"
				data-target="#navbar" data-toggle="collapse"
				class="navbar-toggle collapsed" type="button">
				<i class="fa fa-reorder"></i>
			</button>
			<a href="/super_admin/dashboard.jsp"
				class="navbar-brand custom-theme-color">Talentify</a>
		</div>
		<div class="navbar-collapse collapse" id="navbar">


			<ul class="nav navbar-nav">

				
				<li><a id="Dashboard"
					class="top_navbar_holder" href="/super_admin/dashboard.jsp">Dashboard</a></li>
				
				<li><a id="AccountManagement"
					class="top_navbar_holder" href="/super_admin/account_management.jsp">Account Management</a></li>
				
				<li><a id="UserManagement"
					class="top_navbar_holder" href="/super_admin/user_management.jsp">User Management</a></li>
				
				<li><a id="Scheduler"
					class="top_navbar_holder" href="/super_admin/scheduler.jsp">Scheduler</a></li>
				
				<li><a id="Analytics"
					class="top_navbar_holder" href="/super_admin/analytics.jsp">Analytics</a></li>
				
'
				<li class="dropdown"><a aria-expanded="false" role="button"
					href="null" class="dropdown-toggle"
					data-toggle="dropdown">Utilities<span
						class="caret"></span> </a>
					<ul role="menu" class="dropdown-menu">
						
						<li><a id="Utilities" href="/super_admin/istar_notification.jsp">Notification</a></li>

						
						<li><a id="Utilities" href="/super_admin/classrroms.jsp">Classrooms</a></li>

						
						<li><a id="Utilities" href="/super_admin/report_partials/student_report.jsp">Students Reports</a></li>

						
						<li><a id="Utilities" href="/super_admin/super_admin_tickets.jsp">Tickets</a></li>

						
					</ul></li>
				
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown">Switch Organization<b class="caret"></b></a>

					
					<ul class="dropdown-menu mega-menu" style="background-color: #efedf9;">
						
						<li class="mega-menu-column">
							<ul>


								<li class="nav-header" style="font-size: 15px;">KERALA</li>
								
								<li
									style="font-size: 13px; display: block !important; cursor: help; border-bottom: 1px dotted #777;"><a
									href="/role_switch_controller?user_id=300&main_role=SUPER_ADMIN&org_id=271">Rajagiri College of Social Sciences </a></li>
								


							</ul>
						</li>
						
						<li class="mega-menu-column">
							<ul>


								<li class="nav-header" style="font-size: 15px;">TELANGANA</li>
								
								<li
									style="font-size: 13px; display: block !important; cursor: help; border-bottom: 1px dotted #777;"><a
									href="/role_switch_controller?user_id=300&main_role=SUPER_ADMIN&org_id=259">Warangal_DDUGKY</a></li>
								


							</ul>
						</li>
						
						<li class="mega-menu-column">
							<ul>


								<li class="nav-header" style="font-size: 15px;">KARNATAKA</li>
								
								<li
									style="font-size: 13px; display: block !important; cursor: help; border-bottom: 1px dotted #777;"><a
									href="/role_switch_controller?user_id=300&main_role=SUPER_ADMIN&org_id=2">ISTAR</a></li>
								
								<li
									style="font-size: 13px; display: block !important; cursor: help; border-bottom: 1px dotted #777;"><a
									href="/role_switch_controller?user_id=300&main_role=SUPER_ADMIN&org_id=3">East Point College</a></li>
								
								<li
									style="font-size: 13px; display: block !important; cursor: help; border-bottom: 1px dotted #777;"><a
									href="/role_switch_controller?user_id=300&main_role=SUPER_ADMIN&org_id=272">Istar IT Services Pvt Limited</a></li>
								


							</ul>
						</li>
						





					</ul></li>

				
				<li class="dropdown"><a aria-expanded="true" role="button"
					href="" class="dropdown-toggle" data-toggle="dropdown">Welcome
						&nbsp;&nbsp;&nbsp;Vaibhav<span
						class="caret"></span>
				</a>
					<ul role="menu" class="dropdown-menu">

						<li><a href="/edit_profile.jsp"> Profile </a></li>

						

						<li><a href="/auth/logout"> Logout </a></li>

					</ul></li>





			</ul>




		</div>
	</nav>
	
	

	<div style="display: none" id="admin_page_loader">
		<div style="width: 100%; z-index: 6; position: fixed;"
			class="spiner-example">
			<div style="width: 100%;" class="sk-spinner sk-spinner-three-bounce">
				<div style="width: 50px; height: 50px;" class="sk-bounce1"></div>
				<div style="width: 50px; height: 50px;" class="sk-bounce2"></div>
				<div style="width: 50px; height: 50px;" class="sk-bounce3"></div>
			</div>
		</div>
	</div>
</div>

			


			
			<div class="row">
				<div class="col-lg-12">
					<div class="tabs-container">
                        <ul class="nav nav-tabs">
                            <li class="active"><a data-toggle="tab" href="#tab-m" aria-expanded="true"> Manual Scheduler</a></li>
                            <li class=""><a data-toggle="tab" href="#tab-a" aria-expanded="false" id="dddddddd">Auto Scheduler</a></li>
                        </ul>
                        <div class="tab-content">
                            <div id="tab-m" class="tab-pane active">
                                <div class="panel-body">
                                   




    			


			
<div class="ibox float-e-margins no-margins bg-muted">
						<div class="ibox-content">
							<div class="row show-grid white-bg" style="    margin: 0px;">
								<div class="col-lg-3 white-bg no-borders whit-bg-schedular" style="    padding-left: 1px;
    padding-top: 0px;">
									<h1 class="text-danger font-bold">Create A New Event</h1>
									<div class="tabs-container">
										<ul class="nav nav-tabs gray-bg-schedular super_admin_scheduler">
											<li class="active"><a id="tab_1" data-toggle="tab" href="#tab-1">Single Event</a></li>
											<li class=""><a id="tab_2" data-toggle="tab" href="#tab-2">Daily</a></li>
											<li class=""><a id="tab_3" data-toggle="tab" href="#tab-3">Weekly</a></li>
										</ul>
										
										<div class="tab-content">
										
										<div id="tab-1" class="active tab-pane">
										








	<div class="panel-body border-event">

		<form id="idForm1" class="form">
			<input type="hidden" name="AdminUserID" value="300" /> <input
				type="hidden" name="tabType" value="singleEvent" />

			<div class="form-group">
				<label>Choose Organization</label> <select
					class="form-control m-b org_holder scheduler_select" name="orgID">	
					<option value="0">Select Organization...</option>
					<option value='4'>MES teachers College</option><option value='5'>BVP College</option><option value='6'>PSGR Krishnammal College for Women			</option><option value='7'>Dr NGP Arts &amp; Science College.</option><option value='8'>St. Joseph college of commerce.</option><option value='67'>Som-Lalit institute of Management Studies</option><option value='68'> Adarsha Institute of Technology</option><option value='69'>Guru Nanak Institute of Management</option><option value='70'>HR Institute of technology</option><option value='71'>Delhi Institute of Advanced Studies</option><option value='72'>Indira College of Commerce</option><option value='73'>BVP Engineering</option><option value='74'>Methodist Engineering College</option><option value='75'>TKR College of Engineering and Technology</option><option value='76'>Menarini Asia Pacific</option><option value='78'>Ajuba</option><option value='79'>Allianz</option><option value='80'>Amnet Systems</option><option value='81'>Aspire Systems</option><option value='82'>Bmc Software</option><option value='83'>Capgemini</option><option value='84'>Charter Global</option><option value='85'>Clover Infotech</option><option value='86'>CME Group</option><option value='123'>HP</option><option value='124'>Vizag_DDU-GKY </option><option value='2'>ISTAR</option><option value='3'>East Point College</option><option value='87'>Crayon</option><option value='88'>Cyber Infrastructure</option><option value='89'>Espire</option><option value='90'>Geometric</option><option value='92'>Harman Connected Sevices</option><option value='93'>Headstrong</option><option value='94'>Hinduja Global Solutions</option><option value='95'>iFocus Systec</option><option value='96'>Impetus</option><option value='97'>Infogain</option><option value='98'>Infosys</option><option value='99'>Invenio Business Solutions</option><option value='100'>Iron Mountain</option><option value='101'>Mindteck</option><option value='102'>Nasdaq</option><option value='103'>Ocwen Financial Services</option><option value='104'>Opteamix</option><option value='105'>People Tech Group</option><option value='106'>Polaris</option><option value='107'>PWC</option><option value='108'>Q3 Technologies</option><option value='109'>Sopra Steria</option><option value='110'>SourceHOV</option><option value='111'>Syntel</option><option value='112'>T-Systems</option><option value='113'>Tata Consultancy Services</option><option value='114'>Teradata</option><option value='115'>Valtech</option><option value='116'>Value Labs</option><option value='117'>Williams Lea</option><option value='118'>Wipro</option><option value='119'>WNS Global Services</option><option value='120'>Yash Technologies</option><option value='121'>Zen3 Infosolutions India Ltd</option><option value='122'>Zensar Technologies</option><option value='126'>3i Infotech</option><option value='127'>Morgan Stanley</option><option value='128'>Mutual Mobile</option><option value='129'>Infoshore</option><option value='130'>Mc Fadyen Solutions</option><option value='137'>BAE Systems</option><option value='131'>AGC Networks Ltd</option><option value='132'>Solution Hawk</option><option value='133'>Aztec Software</option><option value='134'>Metlife</option><option value='135'>Experian</option><option value='136'>Intel</option><option value='138'>Fiserv</option><option value='139'>Honeywell</option><option value='140'>Northrop Grumman</option><option value='141'>Raytheon Websense</option><option value='142'>Serco</option><option value='143'>Unisys</option><option value='158'>Code Brew Labs</option><option value='144'>Lauruss Infotech</option><option value='145'>Peerbits</option><option value='146'>Telecom Network Solutions</option><option value='147'>Ciber</option><option value='148'>Hyperlink Infosystems</option><option value='149'>Tata ELXSI Ltd</option><option value='150'>Acer </option><option value='151'>Experion</option><option value='152'>Syon Infomedia pvt ltd</option><option value='153'>Accel frontline ltd</option><option value='154'>Cadence Design Systems</option><option value='155'>Intellect Design Arena</option><option value='156'>Debut infotech</option><option value='157'>Savex Technologies</option><option value='159'>Variance Infotech</option><option value='160'>Trigyn Technologies </option><option value='161'>Great-West Financial Services</option><option value='162'>Zoondia Pvt Ltd</option><option value='163'>Evince Development Pvt. Ltd. </option><option value='164'>Terasol Technologies</option><option value='165'>Accenture </option><option value='166'>Aditi Consulting</option><option value='167'>Adobe</option><option value='168'>Amazon</option><option value='169'>Apple</option><option value='170'>Appster</option><option value='178'>Cognizant</option><option value='171'>Atos consulting  &amp; Technology Services</option><option value='172'>ADP India Pvt Ltd</option><option value='173'>Intex</option><option value='174'>Brillio</option><option value='175'>CA Technologies</option><option value='176'>Canon</option><option value='177'>Cisco</option><option value='179'>Convergys</option><option value='180'>Credit Suisse</option><option value='181'>CSC</option><option value='182'>Cyient</option><option value='183'>Dell</option><option value='190'>Technource</option><option value='184'>D-Link</option><option value='185'>Huawei Technologies</option><option value='186'>Fidelity Investments</option><option value='187'>First Data</option><option value='188'>Google</option><option value='189'>Torry Harris Business Solutions</option><option value='191'>Goldman Sachs</option><option value='192'>Deloitte</option><option value='193'>Hitachi Data Systems</option><option value='194'>Citi Group</option><option value='195'>Synapse</option><option value='196'>Vinsol</option><option value='197'>Contus</option><option value='198'>Andola Soft</option><option value='199'>Metaoption</option><option value='200'>Infinite computer solutions</option><option value='201'>Ingram micro</option><option value='202'>IBM</option><option value='203'>Intuit</option><option value='204'>ISHIR</option><option value='205'>ITC Infotech</option><option value='206'>Kellton Tech</option><option value='207'>KPIT</option><option value='208'>Lenovo</option><option value='209'>LG Soft India Pvt Ltd</option><option value='210'>Prismetric Technologies</option><option value='211'>kotak</option><option value='212'>Xerox</option><option value='213'>ADCC Infocad limited</option><option value='214'>Replicon</option><option value='215'>Fujitsu</option><option value='216'>Mastek</option><option value='217'>Mastercard</option><option value='218'>McKinsey and Company</option><option value='219'>SIFY Technologies Limited</option><option value='220'>Microsoft</option><option value='221'>Mobikasa</option><option value='222'>Mphasis</option><option value='223'>NCR</option><option value='224'>NET Solutions</option><option value='225'>Nokia</option><option value='226'>NTT Data</option><option value='227'>Nucleus Software</option><option value='228'>Oracle</option><option value='229'>RR Donnelley</option><option value='230'>Saksoft</option><option value='231'>Samsung Electronics</option><option value='232'>CSS CORP</option><option value='233'>Synchrony Financial</option><option value='234'>Sierra Cedar</option><option value='235'>Bajaj Capital Services</option><option value='236'>Sonata Software</option><option value='237'>Sourcebits</option><option value='238'>SQS</option><option value='239'>Subex</option><option value='240'>Sutherland Global Services</option><option value='241'>Symantec</option><option value='242'>Tata Technologies</option><option value='243'>Tech Mahindra</option><option value='244'>Texas Instruments</option><option value='245'>TIBCO Software Inc</option><option value='246'>TATA Interactive Systems</option><option value='247'>Celetronix Power India Pvt Ltd</option><option value='248'>TVS Electronics</option><option value='249'>Vmware</option><option value='250'>Xilinx</option><option value='251'>Yudiz Solutions Pvt Ltd</option><option value='252'>Zenith Software LTD</option><option value='253'>Zensar Technologies</option><option value='254'>Zetagile Infosolutions Pvt Ltd</option><option value='255'>OSS Cube</option><option value='256'>Velocity Software</option><option value='257'>HeadHonchos.com</option><option value='258'>Dhanwate National College</option><option value='261'>Reva Institute of Technology and Management</option><option value='262'>Rathinam College of Arts and Science</option><option value='263'>Alpha Arts &amp; Science College	</option><option value='264'>ABC Bank Ltd</option><option value='265'>abc</option><option value='266'>Meenakshi Academy of Higher Education and Research</option><option value='267'>St. Britto&#146;s Academy</option><option value='268'>Parul University</option><option value='269'>Janalakshmi Financial Services</option><option value='270'>mes institute of management</option><option value='259'>Warangal_DDUGKY</option><option value='260'>Marwadi University		</option><option value='271'>Rajagiri College of Social Sciences </option><option value='273'>Retail</option><option value='272'>Istar IT Services Pvt Limited</option>

				</select>
			</div>

			<div class="form-group">
				<label>Choose Trainer</label> <select
					class="form-control m-b scheduler_select" name="trainerID">
					<option value="">Select Trainer...</option>
					<option value='128'>subhra.naskar@gmail.com</option><option value='129'>hariharan.deepalakshmi@gmail.com</option><option value='130'>robinfrank88@gmail.com</option><option value='131'>bssuhas@gmail.com</option><option value='132'>anupama.ghoshal@gmail.com</option><option value='133'>vanishree.deepak@gmail.com</option><option value='135'>chetansinghp1991@gmail.com</option><option value='136'>jyothigadiya@gmail.com</option><option value='137'>vikassingh4219@gmail.com</option><option value='138'>suryashweta_c@yahoo.com</option><option value='139'>123sskd75@gmail.com</option><option value='140'>cadjadhav@gmail.com</option><option value='142'>shailaja.faithbuild@gmail.com</option><option value='143'>vineetabora@gmail.com</option><option value='144'>surbhi_koshta@yahoo.co.in</option><option value='145'>roy.fernandes7@gmail.com</option><option value='146'>lavneet.s.rathor@gmail.com</option><option value='147'>anjaliatre@yahoo.co.in</option><option value='148'>nititaj@gmail.com</option><option value='149'>findlubna@gmail.com</option><option value='150'>swatirath57@gmail.com</option><option value='151'>swatigothoskar@hotmail.com</option><option value='152'>narayananbadri09@gmail.com</option><option value='153'>priyanka55shelar@gmail.com</option><option value='155'>priyasrinivasan08@gmail.com</option><option value='156'>subin_ck@yahoo.co.in</option><option value='157'>sunitharunkumar@yahoo.co.in</option><option value='158'>sathyavenkatraj@gmail.com</option><option value='159'>thangaraj.academics@gmail.com</option><option value='160'>abip72@gmail.com</option><option value='161'>ragapriya.priya@gmail.com</option><option value='162'>paul_1@istarindia.com</option><option value='163'>shreeram_1@istarindia.com</option><option value='164'>shruthi_1@istarindia.com</option><option value='165'>deepti_1@istarindia.com</option><option value='166'>santosh_1@istarindia.com</option><option value='7504'>krisashokan@gmail.com</option><option value='170'>anusha_paul_1@istarindia.com</option><option value='172'>hemashree_1@istarindia.com</option><option value='134'>prernakapoor1@rediffmail.com</option><option value='141'>bikash_rathi@hotmail.com</option><option value='154'>nagadharanya@gmail.com</option><option value='171'>surga_1@istarindia.com</option><option value='7159'>divya.srinivasan05@gmail.com</option><option value='416'>sana19in@gmail.com</option><option value='385'>suraghsan@gmail.com</option><option value='387'>dummy@istarindia.com</option><option value='404'>sreekantha.mb@gmail.com</option><option value='406'>prvsomani@gmail.com</option><option value='410'>krishnankiru@gmail.com</option><option value='412'>mrigakshi.isms@gmail.com</option><option value='414'>pal.navinkumar@gmail.com</option><option value='418'>nirmalsonu17@gmail.com</option><option value='420'>amikakkad@rediffmail.com</option><option value='422'>selvilkannan@gmail.com</option><option value='424'>baral.namrata1@gmail.com</option><option value='426'>latishin@gmail.com</option><option value='1775'>84.ambika@gmail.com</option><option value='1777'>aditya.jain835@gmail.com</option><option value='1781'>uswarna@gmail.com</option><option value='1783'>cakaustubhbasu@gmail.com</option><option value='1785'>koteswaranaidu.j@gmail.com</option><option value='1787'>dinakar070@gmail.com</option><option value='1789'>subra.naskar@gmail.com</option><option value='1905'>anuja.jd@gmail.com</option><option value='2315'>venkatesh@istarindia.com</option><option value='2635'>uma_naresh@yahoo.com</option><option value='2636'>vidbha.m20@gmail.com</option><option value='2637'>swati1ximb@gmail.com</option><option value='2638'>sanjay@redwoodsyndicate.com</option><option value='2639'>saptarshim@ymail.com</option><option value='2640'>kirankvknet@gmail.com</option><option value='2641'>shubhada.vaidyanath@gmail.com</option><option value='2642'>nidhi.v.verma@gmail.com</option><option value='2643'>priyanka.sarawagi123@gmail.com</option><option value='2644'>prishikkesh@gmail.com</option><option value='2645'>twinkle.puc@gmail.com</option><option value='2646'>ratnashukla05@rediffmail.com</option><option value='2647'>viswanath_g_n@yahoo.com</option><option value='2648'>joydipg@gmail.com</option><option value='2649'>sayoojyasanil@gmail.com</option><option value='2650'>helinajay@gmail.com</option><option value='2651'>mohammadi_kousar@yahoo.co.in</option><option value='2652'>ymuralidharreddy@gmail.com</option><option value='2653'>poornima.jnv@gmail.com</option><option value='2654'>sreevenu74@gmail.com</option><option value='7722'>sureshkrish53535@gmail.com</option><option value='3318'>swatisinghnew@gmail.com</option><option value='3322'>apeksha.ashtekar@gmail.com</option><option value='3403'>rohitvkatira@gmail.com</option><option value='3501'>pooja@gmail.com</option><option value='3512'>ophir.impact@gmail.com</option><option value='3523'>ddddd@gmail.com</option><option value='3552'>payal_23pari@yahoo.co.in</option><option value='3595'>demo_developer@istarindia.com</option><option value='3640'>panank12@yahoo.com</option><option value='3665'>cuttambakamharikishan89@gmail.com</option><option value='3671'>sonisrikanth@yahoo.com</option><option value='3729'>shailendra.k.garg@gmail.com</option><option value='4478'>syedjaffer00@gmail.com</option><option value='4480'>anudesikan@hotmail.com</option><option value='4482'>poojau.sampat@gmail.com</option><option value='4484'>kumar.sanjeet2009@yahoo</option><option value='4486'>priya_angle@hotmail.com</option><option value='4488'>saurabhpkjain@gmail.com</option><option value='4490'>praveenshivs@gmail.com</option><option value='4498'>subhadraaithal@gmail.com</option><option value='4500'>darshana11daga@gmail.com</option><option value='4502'>caajaysbp@gmail.com</option><option value='4504'>parida2588@gmail.com</option><option value='4506'>urvashi.mirani7@gmail.com</option><option value='4508'>iyershankar2016@gmail.com</option><option value='4510'>Pankaj.singhal77@gmail.com</option><option value='4512'>baji143@rediffmail.com</option><option value='4514'>u.sheikshavali@gmail.com</option><option value='4545'>sandeepg@istarindia.com</option><option value='4696'>jaishankarcm@gmail.com</option><option value='4700'>dubeyhemlata36@gmail.com</option><option value='4702'>mona.shyamal@gmail.com</option><option value='4704'>pallavikarun@gmail.com</option><option value='4714'>salahuddin.shoupa@gmail.com</option><option value='4716'>bc_sanjay@rediffmail.com</option><option value='4718'>ms.srividyanaik@gmail.com</option><option value='4720'>shubhashree.krishnan@gmail.com</option><option value='4729'>pchavan2003.19@gmail.com</option><option value='4730'>abcd@istarindia.com</option><option value='4732'>saloni.j.jain@gmail.com</option><option value='4737'>im_abhishek@rediffmail.com</option><option value='7161'>pattammal@hotmail.com</option><option value='4743'>gayathri@istarindia.com</option><option value='4753'>sethi.parveen@gmail.com</option><option value='4906'>santhoshsam00@gmail.com</option><option value='4929'>rohini@istarindia.com</option><option value='5045'>milind.mohod@gmail.com</option><option value='5064'>solomon@gianthunt.com</option><option value='5068'>vrishali.singh@istarindia.com</option><option value='5098'>ronakrai02@gmail.com</option><option value='5100'>amin_vandana@yahoo.com</option><option value='5127'>cvjshastry@gmail.com</option><option value='5154'>venkateshwarreddy@istarindia.com</option><option value='5189'>ca.saiganesh@gmail.com</option><option value='5276'>bhagyaraj@istarindia.com</option><option value='5279'>nikhil@istarindia.com</option><option value='5282'>jaswinder.sunskills@gmail.com</option><option value='5348'>niru.mane@gmail.com</option><option value='5372'>satwinderkaur02@gmail.com</option><option value='5374'>alfy_972@yahoo.co.in</option><option value='5384'>hnagaraj11@gmail.com</option><option value='5412'>rajansathish@rediffmail.com</option><option value='5968'>dvlhimabindu@gmail.com</option><option value='5982'>faizairam.123@gmail.com</option><option value='5984'>misra.smita@rediffmail.com</option><option value='6022'>aditya_1@istarindia.com</option><option value='5265'>karthiik@istarindia.com</option><option value='5517'>vaibhav_9@istarindia.com</option><option value='6051'>gg@gmail.com</option><option value='5284'>saikumar@istarindia.com</option><option value='5454'>visu.chintu@gmail.com</option><option value='5286'>sandeep@istarindia.com</option><option value='4739'>nams.77@gmail.com</option><option value='173'>divya_1@istarindia.com</option><option value='7169'>sahuprabhat1992@gmail.com</option><option value='4496'>sarovishwa@gmail.com</option><option value='4522'>karthik_trainer@istarindia.com</option><option value='6972'>anusha_t@istarindia.com</option><option value='7179'>testing2@istarindia.com</option><option value='167'>neetu_1@istarindia.com</option><option value='127'>beena.aruna@gmail.com</option><option value='6978'>priyankas0907@gmail.com</option><option value='5092'>swarup@istarindia.com</option><option value='7193'>sastikmr@gmail.com</option><option value='7199'>vandana7rao@gmail.com</option><option value='6971'>teju@istarindia.com</option><option value='7662'>subha2492@gmail.com</option><option value='6992'>techintern1@istarindia.com</option><option value='7163'>demo_trainer@istarindia.com</option><option value='7177'>testing1@istarindia.com</option><option value='6989'>tetstr@gmail.com</option><option value='6994'>vinay123@gmail.com</option><option value='6996'>techintern3@istarindia.com</option><option value='6998'>ravi@istarindia.com</option><option value='7000'>swathi.jain96@gmail.com</option><option value='7005'>ajay@rajagffiri.edu</option><option value='7088'>vijay@istarindia.com</option><option value='7171'>demotrainer@istarindia.com</option><option value='7187'>s.maneesh1986@gmail.com</option><option value='7201'>ravichandra@istarindia.com</option><option value='7165'>carobertmjesu@gmail.com</option><option value='7206'>mahalakshmi333.ravi@gmail.com</option><option value='7105'>muksatt2505@gmail.com</option><option value='7210'>charmi_ca@yahoo.com</option><option value='7212'>asmithaiwala@gmail.com</option><option value='7214'>asms009@gmail.com</option><option value='7220'>remya.vjn@gmail.com</option><option value='7225'>shuklabhishek0792@gmail.com</option><option value='7231'>ASHOKKUMARK80@GMAIL.COM</option><option value='7233'>ashokkumark80@gmail.com</option><option value='7235'>veekshithhc@gmail.com</option><option value='7237'>mrsawant1@gmail.com</option><option value='168'>hema_1@istarindia.com</option><option value='7717'>vijing11@gmail.com</option><option value='7183'>anjalimsarda93@gmail.com</option><option value='7090'>durgi62@gmail.com</option><option value='7092'>farhanmtr1@gmail.com</option><option value='7094'>manasamaragoni@gmail.com</option><option value='7096'>manc.kamdar@gmail.com</option><option value='7098'>shweta_khanzode@yahoo.com</option><option value='175'>mark_1@istarindia.com</option><option value='7100'>krishnan.jayasri@gmail.com</option><option value='7117'>pdharmu@gmail.com</option><option value='7175'>ranjitk.mishra@gmail.com</option><option value='7103'>priyank@gmail.com</option><option value='7107'>aslam.driger@gmail.com</option><option value='7109'>vinayfortest@istarindia.com</option><option value='7111'>rahul.ramchandani792@gmail.com</option><option value='7113'>shreyagovind@gmail.com</option><option value='7115'>28june@istarindia.com</option><option value='7119'>lol@lol.com</option><option value='7121'>al@lol.com</option><option value='7123'>adal@lol.com</option><option value='7125'>ravi2@istarindia.com</option><option value='7127'>murali.s.seetharaman@gmail.com</option><option value='7129'>abhishek.cka@gmail.com</option><option value='7133'>praveen.hore@rediffmail.com</option><option value='7135'>mother@istarindia.com</option><option value='7136'>mother_presenter@istarindia.com</option><option value='7137'>keyboard@istarindia.com</option><option value='7195'>karthikdhilip@gmail.com</option><option value='7139'>VaibhavTemap@istarindia.com</option><option value='7203'>chiranjeevi.gatti@gmail.com</option><option value='7141'>nagadharanya@istarindia.com</option><option value='7167'>test1@istarindia.com</option><option value='6985'>deeptolive@gmail.com</option><option value='7181'>santosh.neups@gmail.com</option><option value='7143'>ab@istarindia.com</option><option value='7145'>dhanadakishor@gmail.com</option><option value='7185'>munirajuharsha@gmail.com</option><option value='8'>mark@istarindia.com</option><option value='7189'>reddyvinay100@gmail.com</option><option value='7197'>amolmotghare2913@gmail.com</option><option value='7154'>senthilkumarbabu@hotmail.com</option><option value='7147'>soumya.kash@gmail.com</option><option value='7149'>rbalu1960@gmail.com</option><option value='7243'>soundram63@gmail.com</option><option value='7151'>ms.ananthan@gmail.com</option><option value='6974'>iamvivekanands@gmail.com</option><option value='169'>teju_1@istarindia.com</option><option value='7208'>caanmolagrawal@gmail.com</option><option value='7227'>senthilkumar.rajappan@gmail.com</option><option value='408'>henna.khemani@gmail.com</option><option value='7156'>pranavmilan99@gmail.com</option><option value='7223'>sandeep_dbest@yahoo.co.in</option><option value='7229'>abby42.va@gmail.com</option><option value='7239'>alakshmanan75@gmail.com</option><option value='7241'>krajeev1976@gmail.com</option><option value='174'>archana_1@istarindia.com</option><option value='4741'>rameshk@istarindia.com</option><option value='7438'>tijovarghese3@gmail.com</option><option value='7728'>stutivadalia@gmail.com</option><option value='7513'>mpsrinivas28@gmail.com</option><option value='7585'>roshni23@gmail.com</option><option value='7574'>Vigneshwaranvishal@gmail.com</option><option value='7440'>munirajuharsha@hotmail.com</option><option value='7452'>hemika88@gmail.com</option><option value='7458'>jadhavpoonam1712@gmail.com</option><option value='7467'>Josh7win@gmail.com</option><option value='7469'>badimaladileepkumar@gmail.com</option><option value='7493'>sekarsdream@gmail.com</option><option value='7442'>vijayright05@gmail.com</option><option value='7444'>sha_ba2016@yahoo.com</option><option value='7446'>palashconsultancy@gmail.com</option><option value='7502'>ramadurairaghunathan@gmail.com</option><option value='7465'>anusha_vikram@yahoo.com</option><option value='7488'>savankeshriya@gmail.com</option><option value='7450'>mohanramu19@gmail.com</option><option value='7491'>sudhi4321@gmail.com</option><option value='7454'>reply2hemanth@gmail.com</option><option value='5236'>mamathajobmail2016@gmail.com</option><option value='7498'>suriyamba@live.com</option><option value='7567'>ravinder.gupta@federalmogul.com</option><option value='7462'>miriamphilip@gmail.com</option><option value='3814'>paul@istarindia.com</option><option value='7448'>geethage.rce@gmail.com</option><option value='7456'>sheelamxavier@gmail.com</option><option value='7460'>ashutoshkar11@gmail.com</option><option value='7495'>sridevi_17@yahoo.com</option><option value='7500'>cricvenky2298@gmail.com</option><option value='7572'>janu200292@gmail.com</option><option value='1779'>maureenjs55@gmail.com</option><option value='7478'>preeti.padmanaban@gmail.com</option><option value='7577'>mambu_patrick@yahoo.fr</option><option value='7579'>hariharans337@gmail.Com</option><option value='7664'>cacskrithika@gmail.com</option><option value='4881'>kotresh@istarindia.com</option><option value='7583'>hasini1981@rediffmail.com</option><option value='402'>shyam@istarindia.com</option><option value='7666'>av7ganesan@gmail.com</option><option value='7581'>raziyas221998@gmail.com</option><option value='7740'>new1@istar.com</option><option value='7738'>vinay_24july@istarindia.com</option><option value='449'>vinay_sales@istarindia.com</option><option value='17464'>it_trainer@istarindia.com</option><option value='17466'>it2@istarindia.com</option><option value='17468'>it3@istarindia.com</option>

				</select>
			</div>
			<div class="form-group">
				<label>Choose Associate Trainee</label>
				<input type="hidden" id="single_associateTrainerID_holder" name="associateTrainerID" value="0"/>
				<select data-placeholder="Select Associate Trainer"  multiple
						tabindex="4" name="" id="single_associateTrainerID" class="associateTrainer">
						<option value="">Select Associate Trainers...</option>
					       <option value='128'>subhra.naskar@gmail.com</option><option value='129'>hariharan.deepalakshmi@gmail.com</option><option value='130'>robinfrank88@gmail.com</option><option value='131'>bssuhas@gmail.com</option><option value='132'>anupama.ghoshal@gmail.com</option><option value='133'>vanishree.deepak@gmail.com</option><option value='135'>chetansinghp1991@gmail.com</option><option value='136'>jyothigadiya@gmail.com</option><option value='137'>vikassingh4219@gmail.com</option><option value='138'>suryashweta_c@yahoo.com</option><option value='139'>123sskd75@gmail.com</option><option value='140'>cadjadhav@gmail.com</option><option value='142'>shailaja.faithbuild@gmail.com</option><option value='143'>vineetabora@gmail.com</option><option value='144'>surbhi_koshta@yahoo.co.in</option><option value='145'>roy.fernandes7@gmail.com</option><option value='146'>lavneet.s.rathor@gmail.com</option><option value='147'>anjaliatre@yahoo.co.in</option><option value='148'>nititaj@gmail.com</option><option value='149'>findlubna@gmail.com</option><option value='150'>swatirath57@gmail.com</option><option value='151'>swatigothoskar@hotmail.com</option><option value='152'>narayananbadri09@gmail.com</option><option value='153'>priyanka55shelar@gmail.com</option><option value='155'>priyasrinivasan08@gmail.com</option><option value='156'>subin_ck@yahoo.co.in</option><option value='157'>sunitharunkumar@yahoo.co.in</option><option value='158'>sathyavenkatraj@gmail.com</option><option value='159'>thangaraj.academics@gmail.com</option><option value='160'>abip72@gmail.com</option><option value='161'>ragapriya.priya@gmail.com</option><option value='162'>paul_1@istarindia.com</option><option value='163'>shreeram_1@istarindia.com</option><option value='164'>shruthi_1@istarindia.com</option><option value='165'>deepti_1@istarindia.com</option><option value='166'>santosh_1@istarindia.com</option><option value='7504'>krisashokan@gmail.com</option><option value='170'>anusha_paul_1@istarindia.com</option><option value='172'>hemashree_1@istarindia.com</option><option value='134'>prernakapoor1@rediffmail.com</option><option value='141'>bikash_rathi@hotmail.com</option><option value='154'>nagadharanya@gmail.com</option><option value='171'>surga_1@istarindia.com</option><option value='7159'>divya.srinivasan05@gmail.com</option><option value='416'>sana19in@gmail.com</option><option value='385'>suraghsan@gmail.com</option><option value='387'>dummy@istarindia.com</option><option value='404'>sreekantha.mb@gmail.com</option><option value='406'>prvsomani@gmail.com</option><option value='410'>krishnankiru@gmail.com</option><option value='412'>mrigakshi.isms@gmail.com</option><option value='414'>pal.navinkumar@gmail.com</option><option value='418'>nirmalsonu17@gmail.com</option><option value='420'>amikakkad@rediffmail.com</option><option value='422'>selvilkannan@gmail.com</option><option value='424'>baral.namrata1@gmail.com</option><option value='426'>latishin@gmail.com</option><option value='1775'>84.ambika@gmail.com</option><option value='1777'>aditya.jain835@gmail.com</option><option value='1781'>uswarna@gmail.com</option><option value='1783'>cakaustubhbasu@gmail.com</option><option value='1785'>koteswaranaidu.j@gmail.com</option><option value='1787'>dinakar070@gmail.com</option><option value='1789'>subra.naskar@gmail.com</option><option value='1905'>anuja.jd@gmail.com</option><option value='2315'>venkatesh@istarindia.com</option><option value='2635'>uma_naresh@yahoo.com</option><option value='2636'>vidbha.m20@gmail.com</option><option value='2637'>swati1ximb@gmail.com</option><option value='2638'>sanjay@redwoodsyndicate.com</option><option value='2639'>saptarshim@ymail.com</option><option value='2640'>kirankvknet@gmail.com</option><option value='2641'>shubhada.vaidyanath@gmail.com</option><option value='2642'>nidhi.v.verma@gmail.com</option><option value='2643'>priyanka.sarawagi123@gmail.com</option><option value='2644'>prishikkesh@gmail.com</option><option value='2645'>twinkle.puc@gmail.com</option><option value='2646'>ratnashukla05@rediffmail.com</option><option value='2647'>viswanath_g_n@yahoo.com</option><option value='2648'>joydipg@gmail.com</option><option value='2649'>sayoojyasanil@gmail.com</option><option value='2650'>helinajay@gmail.com</option><option value='2651'>mohammadi_kousar@yahoo.co.in</option><option value='2652'>ymuralidharreddy@gmail.com</option><option value='2653'>poornima.jnv@gmail.com</option><option value='2654'>sreevenu74@gmail.com</option><option value='7722'>sureshkrish53535@gmail.com</option><option value='3318'>swatisinghnew@gmail.com</option><option value='3322'>apeksha.ashtekar@gmail.com</option><option value='3403'>rohitvkatira@gmail.com</option><option value='3501'>pooja@gmail.com</option><option value='3512'>ophir.impact@gmail.com</option><option value='3523'>ddddd@gmail.com</option><option value='3552'>payal_23pari@yahoo.co.in</option><option value='3595'>demo_developer@istarindia.com</option><option value='3640'>panank12@yahoo.com</option><option value='3665'>cuttambakamharikishan89@gmail.com</option><option value='3671'>sonisrikanth@yahoo.com</option><option value='3729'>shailendra.k.garg@gmail.com</option><option value='4478'>syedjaffer00@gmail.com</option><option value='4480'>anudesikan@hotmail.com</option><option value='4482'>poojau.sampat@gmail.com</option><option value='4484'>kumar.sanjeet2009@yahoo</option><option value='4486'>priya_angle@hotmail.com</option><option value='4488'>saurabhpkjain@gmail.com</option><option value='4490'>praveenshivs@gmail.com</option><option value='4498'>subhadraaithal@gmail.com</option><option value='4500'>darshana11daga@gmail.com</option><option value='4502'>caajaysbp@gmail.com</option><option value='4504'>parida2588@gmail.com</option><option value='4506'>urvashi.mirani7@gmail.com</option><option value='4508'>iyershankar2016@gmail.com</option><option value='4510'>Pankaj.singhal77@gmail.com</option><option value='4512'>baji143@rediffmail.com</option><option value='4514'>u.sheikshavali@gmail.com</option><option value='4545'>sandeepg@istarindia.com</option><option value='4696'>jaishankarcm@gmail.com</option><option value='4700'>dubeyhemlata36@gmail.com</option><option value='4702'>mona.shyamal@gmail.com</option><option value='4704'>pallavikarun@gmail.com</option><option value='4714'>salahuddin.shoupa@gmail.com</option><option value='4716'>bc_sanjay@rediffmail.com</option><option value='4718'>ms.srividyanaik@gmail.com</option><option value='4720'>shubhashree.krishnan@gmail.com</option><option value='4729'>pchavan2003.19@gmail.com</option><option value='4730'>abcd@istarindia.com</option><option value='4732'>saloni.j.jain@gmail.com</option><option value='4737'>im_abhishek@rediffmail.com</option><option value='7161'>pattammal@hotmail.com</option><option value='4743'>gayathri@istarindia.com</option><option value='4753'>sethi.parveen@gmail.com</option><option value='4906'>santhoshsam00@gmail.com</option><option value='4929'>rohini@istarindia.com</option><option value='5045'>milind.mohod@gmail.com</option><option value='5064'>solomon@gianthunt.com</option><option value='5068'>vrishali.singh@istarindia.com</option><option value='5098'>ronakrai02@gmail.com</option><option value='5100'>amin_vandana@yahoo.com</option><option value='5127'>cvjshastry@gmail.com</option><option value='5154'>venkateshwarreddy@istarindia.com</option><option value='5189'>ca.saiganesh@gmail.com</option><option value='5276'>bhagyaraj@istarindia.com</option><option value='5279'>nikhil@istarindia.com</option><option value='5282'>jaswinder.sunskills@gmail.com</option><option value='5348'>niru.mane@gmail.com</option><option value='5372'>satwinderkaur02@gmail.com</option><option value='5374'>alfy_972@yahoo.co.in</option><option value='5384'>hnagaraj11@gmail.com</option><option value='5412'>rajansathish@rediffmail.com</option><option value='5968'>dvlhimabindu@gmail.com</option><option value='5982'>faizairam.123@gmail.com</option><option value='5984'>misra.smita@rediffmail.com</option><option value='6022'>aditya_1@istarindia.com</option><option value='5265'>karthiik@istarindia.com</option><option value='5517'>vaibhav_9@istarindia.com</option><option value='6051'>gg@gmail.com</option><option value='5284'>saikumar@istarindia.com</option><option value='5454'>visu.chintu@gmail.com</option><option value='5286'>sandeep@istarindia.com</option><option value='4739'>nams.77@gmail.com</option><option value='173'>divya_1@istarindia.com</option><option value='7169'>sahuprabhat1992@gmail.com</option><option value='4496'>sarovishwa@gmail.com</option><option value='4522'>karthik_trainer@istarindia.com</option><option value='6972'>anusha_t@istarindia.com</option><option value='7179'>testing2@istarindia.com</option><option value='167'>neetu_1@istarindia.com</option><option value='127'>beena.aruna@gmail.com</option><option value='6978'>priyankas0907@gmail.com</option><option value='5092'>swarup@istarindia.com</option><option value='7193'>sastikmr@gmail.com</option><option value='7199'>vandana7rao@gmail.com</option><option value='6971'>teju@istarindia.com</option><option value='7662'>subha2492@gmail.com</option><option value='6992'>techintern1@istarindia.com</option><option value='7163'>demo_trainer@istarindia.com</option><option value='7177'>testing1@istarindia.com</option><option value='6989'>tetstr@gmail.com</option><option value='6994'>vinay123@gmail.com</option><option value='6996'>techintern3@istarindia.com</option><option value='6998'>ravi@istarindia.com</option><option value='7000'>swathi.jain96@gmail.com</option><option value='7005'>ajay@rajagffiri.edu</option><option value='7088'>vijay@istarindia.com</option><option value='7171'>demotrainer@istarindia.com</option><option value='7187'>s.maneesh1986@gmail.com</option><option value='7201'>ravichandra@istarindia.com</option><option value='7165'>carobertmjesu@gmail.com</option><option value='7206'>mahalakshmi333.ravi@gmail.com</option><option value='7105'>muksatt2505@gmail.com</option><option value='7210'>charmi_ca@yahoo.com</option><option value='7212'>asmithaiwala@gmail.com</option><option value='7214'>asms009@gmail.com</option><option value='7220'>remya.vjn@gmail.com</option><option value='7225'>shuklabhishek0792@gmail.com</option><option value='7231'>ASHOKKUMARK80@GMAIL.COM</option><option value='7233'>ashokkumark80@gmail.com</option><option value='7235'>veekshithhc@gmail.com</option><option value='7237'>mrsawant1@gmail.com</option><option value='168'>hema_1@istarindia.com</option><option value='7717'>vijing11@gmail.com</option><option value='7183'>anjalimsarda93@gmail.com</option><option value='7090'>durgi62@gmail.com</option><option value='7092'>farhanmtr1@gmail.com</option><option value='7094'>manasamaragoni@gmail.com</option><option value='7096'>manc.kamdar@gmail.com</option><option value='7098'>shweta_khanzode@yahoo.com</option><option value='175'>mark_1@istarindia.com</option><option value='7100'>krishnan.jayasri@gmail.com</option><option value='7117'>pdharmu@gmail.com</option><option value='7175'>ranjitk.mishra@gmail.com</option><option value='7103'>priyank@gmail.com</option><option value='7107'>aslam.driger@gmail.com</option><option value='7109'>vinayfortest@istarindia.com</option><option value='7111'>rahul.ramchandani792@gmail.com</option><option value='7113'>shreyagovind@gmail.com</option><option value='7115'>28june@istarindia.com</option><option value='7119'>lol@lol.com</option><option value='7121'>al@lol.com</option><option value='7123'>adal@lol.com</option><option value='7125'>ravi2@istarindia.com</option><option value='7127'>murali.s.seetharaman@gmail.com</option><option value='7129'>abhishek.cka@gmail.com</option><option value='7133'>praveen.hore@rediffmail.com</option><option value='7135'>mother@istarindia.com</option><option value='7136'>mother_presenter@istarindia.com</option><option value='7137'>keyboard@istarindia.com</option><option value='7195'>karthikdhilip@gmail.com</option><option value='7139'>VaibhavTemap@istarindia.com</option><option value='7203'>chiranjeevi.gatti@gmail.com</option><option value='7141'>nagadharanya@istarindia.com</option><option value='7167'>test1@istarindia.com</option><option value='6985'>deeptolive@gmail.com</option><option value='7181'>santosh.neups@gmail.com</option><option value='7143'>ab@istarindia.com</option><option value='7145'>dhanadakishor@gmail.com</option><option value='7185'>munirajuharsha@gmail.com</option><option value='8'>mark@istarindia.com</option><option value='7189'>reddyvinay100@gmail.com</option><option value='7197'>amolmotghare2913@gmail.com</option><option value='7154'>senthilkumarbabu@hotmail.com</option><option value='7147'>soumya.kash@gmail.com</option><option value='7149'>rbalu1960@gmail.com</option><option value='7243'>soundram63@gmail.com</option><option value='7151'>ms.ananthan@gmail.com</option><option value='6974'>iamvivekanands@gmail.com</option><option value='169'>teju_1@istarindia.com</option><option value='7208'>caanmolagrawal@gmail.com</option><option value='7227'>senthilkumar.rajappan@gmail.com</option><option value='408'>henna.khemani@gmail.com</option><option value='7156'>pranavmilan99@gmail.com</option><option value='7223'>sandeep_dbest@yahoo.co.in</option><option value='7229'>abby42.va@gmail.com</option><option value='7239'>alakshmanan75@gmail.com</option><option value='7241'>krajeev1976@gmail.com</option><option value='174'>archana_1@istarindia.com</option><option value='4741'>rameshk@istarindia.com</option><option value='7438'>tijovarghese3@gmail.com</option><option value='7728'>stutivadalia@gmail.com</option><option value='7513'>mpsrinivas28@gmail.com</option><option value='7585'>roshni23@gmail.com</option><option value='7574'>Vigneshwaranvishal@gmail.com</option><option value='7440'>munirajuharsha@hotmail.com</option><option value='7452'>hemika88@gmail.com</option><option value='7458'>jadhavpoonam1712@gmail.com</option><option value='7467'>Josh7win@gmail.com</option><option value='7469'>badimaladileepkumar@gmail.com</option><option value='7493'>sekarsdream@gmail.com</option><option value='7442'>vijayright05@gmail.com</option><option value='7444'>sha_ba2016@yahoo.com</option><option value='7446'>palashconsultancy@gmail.com</option><option value='7502'>ramadurairaghunathan@gmail.com</option><option value='7465'>anusha_vikram@yahoo.com</option><option value='7488'>savankeshriya@gmail.com</option><option value='7450'>mohanramu19@gmail.com</option><option value='7491'>sudhi4321@gmail.com</option><option value='7454'>reply2hemanth@gmail.com</option><option value='5236'>mamathajobmail2016@gmail.com</option><option value='7498'>suriyamba@live.com</option><option value='7567'>ravinder.gupta@federalmogul.com</option><option value='7462'>miriamphilip@gmail.com</option><option value='3814'>paul@istarindia.com</option><option value='7448'>geethage.rce@gmail.com</option><option value='7456'>sheelamxavier@gmail.com</option><option value='7460'>ashutoshkar11@gmail.com</option><option value='7495'>sridevi_17@yahoo.com</option><option value='7500'>cricvenky2298@gmail.com</option><option value='7572'>janu200292@gmail.com</option><option value='1779'>maureenjs55@gmail.com</option><option value='7478'>preeti.padmanaban@gmail.com</option><option value='7577'>mambu_patrick@yahoo.fr</option><option value='7579'>hariharans337@gmail.Com</option><option value='7664'>cacskrithika@gmail.com</option><option value='4881'>kotresh@istarindia.com</option><option value='7583'>hasini1981@rediffmail.com</option><option value='402'>shyam@istarindia.com</option><option value='7666'>av7ganesan@gmail.com</option><option value='7581'>raziyas221998@gmail.com</option><option value='7740'>new1@istar.com</option><option value='7738'>vinay_24july@istarindia.com</option><option value='449'>vinay_sales@istarindia.com</option><option value='17464'>it_trainer@istarindia.com</option><option value='17466'>it2@istarindia.com</option><option value='17468'>it3@istarindia.com</option>

					</select>
			</div>
			<div class="form-group">
				<label>Choose Section</label> <select
					class="form-control m-b batchGroupID scheduler_select" name="">
					<option value="">Select Section...</option>
				  

				</select>
			</div>
			<div class="form-group">
				<label>Select Course</label> <select
					class="form-control m-b courseID scheduler_select" name="batchID">
				    <option value="">Select Course...</option>
					<option value=''> Select Course...</option>

				</select>
			</div>
			<div class="form-group">
				<label>Select Event Type</label> <select
					class="form-control m-b eventType" name="eventType">
					<option value="session">Session</option>
					<option value="assessment">Assessment</option>
<option value="webinar">Webinar (TOT)</option>
					<option value="remote_class">Remote Class</option>
				</select>
			</div>
			<div class="form-group">
				<div class="assessment_list" id="assessment_list"
					style="display: none;">

					<label>Select Assessment</label> <select
						class="form-control m-b assessment scheduler_select "
						style="width: 100%" name="assessmentID">
                      <option value='0'> Select Assessment...</option>

					</select>
				</div>
			</div>

			<div class="form-group">
				<label>Select Class-Room</label> <select class="form-control m-b"
					name="classroomID">
					 <option value="">Select Classroom...</option> 
					

				</select>
			</div>
			
			<div class="form-group" id="data_2">
				<label class="font-bold">Event Date</label>
				<div class="input-group date">
					<span class="input-group-addon"><i class="fa fa-calendar"></i></span><input
						name="eventDate" type="text" class="form-control date_holder"
						value="">
				</div>
			</div>
			<div class="form-group">
				<label class="font-bold">Event Time</label>
				<div class="input-group" data-autoclose="true">
					 <span class="input-group-addon"> <span
						class="fa fa-clock-o"></span>
					</span><!-- <input type="text" style="width: 100%; height: 28px;" name="startTime" class="timepicker"/> -->
					<input type="text" style="width: 100%; height: 28px;" name="startTime" class="time_element"/>
				</div> 
				<!-- <div class="input-group clockpicker" data-autoclose="true">
					<input type="text" class="form-control time_holder" name="startTime"
						value="09:30"> <span class="input-group-addon"> <span
						class="fa fa-clock-o"></span>
					</span>
				</div> -->


			</div>
			<div class="form-group form-inline">
				<label class="font-bold">Duration</label> <label class="sr-only">Hours</label>
				<input type="number" value="1" name="hours" placeholder="Hours"
					class="form-control duration_holder"> <label
					class="sr-only">minute</label> <input type="number" value="0"
					name="minute" placeholder="Minute"
					class="form-control duration_holder">
			</div>
			<h4 class="text-danger display-error"></h4>
			<button class="btn btn-danger form-submit-btn custom-theme-btn-primary" data-form="idForm1"
				type="button">Save changes</button>
		</form>
	</div>


										</div>
										
										<div id="tab-2" class=" tab-pane">
										









	<div class="panel-body border-event">

		<form id="idForm2" class="form">
			<input type="hidden" name="AdminUserID" value="300" />
			<input type="hidden" name="tabType" value="dailyEvent" />

<div class="form-group">
				<label>Choose Organization</label> <select
					class="form-control m-b org_holder scheduler_select" name="orgID">
					
					<option value="0">Select Organization...</option>
					<option value='4'>MES teachers College</option><option value='5'>BVP College</option><option value='6'>PSGR Krishnammal College for Women			</option><option value='7'>Dr NGP Arts &amp; Science College.</option><option value='8'>St. Joseph college of commerce.</option><option value='67'>Som-Lalit institute of Management Studies</option><option value='68'> Adarsha Institute of Technology</option><option value='69'>Guru Nanak Institute of Management</option><option value='70'>HR Institute of technology</option><option value='71'>Delhi Institute of Advanced Studies</option><option value='72'>Indira College of Commerce</option><option value='73'>BVP Engineering</option><option value='74'>Methodist Engineering College</option><option value='75'>TKR College of Engineering and Technology</option><option value='76'>Menarini Asia Pacific</option><option value='78'>Ajuba</option><option value='79'>Allianz</option><option value='80'>Amnet Systems</option><option value='81'>Aspire Systems</option><option value='82'>Bmc Software</option><option value='83'>Capgemini</option><option value='84'>Charter Global</option><option value='85'>Clover Infotech</option><option value='86'>CME Group</option><option value='123'>HP</option><option value='124'>Vizag_DDU-GKY </option><option value='2'>ISTAR</option><option value='3'>East Point College</option><option value='87'>Crayon</option><option value='88'>Cyber Infrastructure</option><option value='89'>Espire</option><option value='90'>Geometric</option><option value='92'>Harman Connected Sevices</option><option value='93'>Headstrong</option><option value='94'>Hinduja Global Solutions</option><option value='95'>iFocus Systec</option><option value='96'>Impetus</option><option value='97'>Infogain</option><option value='98'>Infosys</option><option value='99'>Invenio Business Solutions</option><option value='100'>Iron Mountain</option><option value='101'>Mindteck</option><option value='102'>Nasdaq</option><option value='103'>Ocwen Financial Services</option><option value='104'>Opteamix</option><option value='105'>People Tech Group</option><option value='106'>Polaris</option><option value='107'>PWC</option><option value='108'>Q3 Technologies</option><option value='109'>Sopra Steria</option><option value='110'>SourceHOV</option><option value='111'>Syntel</option><option value='112'>T-Systems</option><option value='113'>Tata Consultancy Services</option><option value='114'>Teradata</option><option value='115'>Valtech</option><option value='116'>Value Labs</option><option value='117'>Williams Lea</option><option value='118'>Wipro</option><option value='119'>WNS Global Services</option><option value='120'>Yash Technologies</option><option value='121'>Zen3 Infosolutions India Ltd</option><option value='122'>Zensar Technologies</option><option value='126'>3i Infotech</option><option value='127'>Morgan Stanley</option><option value='128'>Mutual Mobile</option><option value='129'>Infoshore</option><option value='130'>Mc Fadyen Solutions</option><option value='137'>BAE Systems</option><option value='131'>AGC Networks Ltd</option><option value='132'>Solution Hawk</option><option value='133'>Aztec Software</option><option value='134'>Metlife</option><option value='135'>Experian</option><option value='136'>Intel</option><option value='138'>Fiserv</option><option value='139'>Honeywell</option><option value='140'>Northrop Grumman</option><option value='141'>Raytheon Websense</option><option value='142'>Serco</option><option value='143'>Unisys</option><option value='158'>Code Brew Labs</option><option value='144'>Lauruss Infotech</option><option value='145'>Peerbits</option><option value='146'>Telecom Network Solutions</option><option value='147'>Ciber</option><option value='148'>Hyperlink Infosystems</option><option value='149'>Tata ELXSI Ltd</option><option value='150'>Acer </option><option value='151'>Experion</option><option value='152'>Syon Infomedia pvt ltd</option><option value='153'>Accel frontline ltd</option><option value='154'>Cadence Design Systems</option><option value='155'>Intellect Design Arena</option><option value='156'>Debut infotech</option><option value='157'>Savex Technologies</option><option value='159'>Variance Infotech</option><option value='160'>Trigyn Technologies </option><option value='161'>Great-West Financial Services</option><option value='162'>Zoondia Pvt Ltd</option><option value='163'>Evince Development Pvt. Ltd. </option><option value='164'>Terasol Technologies</option><option value='165'>Accenture </option><option value='166'>Aditi Consulting</option><option value='167'>Adobe</option><option value='168'>Amazon</option><option value='169'>Apple</option><option value='170'>Appster</option><option value='178'>Cognizant</option><option value='171'>Atos consulting  &amp; Technology Services</option><option value='172'>ADP India Pvt Ltd</option><option value='173'>Intex</option><option value='174'>Brillio</option><option value='175'>CA Technologies</option><option value='176'>Canon</option><option value='177'>Cisco</option><option value='179'>Convergys</option><option value='180'>Credit Suisse</option><option value='181'>CSC</option><option value='182'>Cyient</option><option value='183'>Dell</option><option value='190'>Technource</option><option value='184'>D-Link</option><option value='185'>Huawei Technologies</option><option value='186'>Fidelity Investments</option><option value='187'>First Data</option><option value='188'>Google</option><option value='189'>Torry Harris Business Solutions</option><option value='191'>Goldman Sachs</option><option value='192'>Deloitte</option><option value='193'>Hitachi Data Systems</option><option value='194'>Citi Group</option><option value='195'>Synapse</option><option value='196'>Vinsol</option><option value='197'>Contus</option><option value='198'>Andola Soft</option><option value='199'>Metaoption</option><option value='200'>Infinite computer solutions</option><option value='201'>Ingram micro</option><option value='202'>IBM</option><option value='203'>Intuit</option><option value='204'>ISHIR</option><option value='205'>ITC Infotech</option><option value='206'>Kellton Tech</option><option value='207'>KPIT</option><option value='208'>Lenovo</option><option value='209'>LG Soft India Pvt Ltd</option><option value='210'>Prismetric Technologies</option><option value='211'>kotak</option><option value='212'>Xerox</option><option value='213'>ADCC Infocad limited</option><option value='214'>Replicon</option><option value='215'>Fujitsu</option><option value='216'>Mastek</option><option value='217'>Mastercard</option><option value='218'>McKinsey and Company</option><option value='219'>SIFY Technologies Limited</option><option value='220'>Microsoft</option><option value='221'>Mobikasa</option><option value='222'>Mphasis</option><option value='223'>NCR</option><option value='224'>NET Solutions</option><option value='225'>Nokia</option><option value='226'>NTT Data</option><option value='227'>Nucleus Software</option><option value='228'>Oracle</option><option value='229'>RR Donnelley</option><option value='230'>Saksoft</option><option value='231'>Samsung Electronics</option><option value='232'>CSS CORP</option><option value='233'>Synchrony Financial</option><option value='234'>Sierra Cedar</option><option value='235'>Bajaj Capital Services</option><option value='236'>Sonata Software</option><option value='237'>Sourcebits</option><option value='238'>SQS</option><option value='239'>Subex</option><option value='240'>Sutherland Global Services</option><option value='241'>Symantec</option><option value='242'>Tata Technologies</option><option value='243'>Tech Mahindra</option><option value='244'>Texas Instruments</option><option value='245'>TIBCO Software Inc</option><option value='246'>TATA Interactive Systems</option><option value='247'>Celetronix Power India Pvt Ltd</option><option value='248'>TVS Electronics</option><option value='249'>Vmware</option><option value='250'>Xilinx</option><option value='251'>Yudiz Solutions Pvt Ltd</option><option value='252'>Zenith Software LTD</option><option value='253'>Zensar Technologies</option><option value='254'>Zetagile Infosolutions Pvt Ltd</option><option value='255'>OSS Cube</option><option value='256'>Velocity Software</option><option value='257'>HeadHonchos.com</option><option value='258'>Dhanwate National College</option><option value='261'>Reva Institute of Technology and Management</option><option value='262'>Rathinam College of Arts and Science</option><option value='263'>Alpha Arts &amp; Science College	</option><option value='264'>ABC Bank Ltd</option><option value='265'>abc</option><option value='266'>Meenakshi Academy of Higher Education and Research</option><option value='267'>St. Britto&#146;s Academy</option><option value='268'>Parul University</option><option value='269'>Janalakshmi Financial Services</option><option value='270'>mes institute of management</option><option value='259'>Warangal_DDUGKY</option><option value='260'>Marwadi University		</option><option value='271'>Rajagiri College of Social Sciences </option><option value='273'>Retail</option><option value='272'>Istar IT Services Pvt Limited</option>

				</select>
			</div>
			<div class="form-group">
				<label>Choose Trainer</label> <select class="form-control m-b scheduler_select"
					name="trainerID">
					<option value="">Select Trainer...</option>
					<option value='128'>subhra.naskar@gmail.com</option><option value='129'>hariharan.deepalakshmi@gmail.com</option><option value='130'>robinfrank88@gmail.com</option><option value='131'>bssuhas@gmail.com</option><option value='132'>anupama.ghoshal@gmail.com</option><option value='133'>vanishree.deepak@gmail.com</option><option value='135'>chetansinghp1991@gmail.com</option><option value='136'>jyothigadiya@gmail.com</option><option value='137'>vikassingh4219@gmail.com</option><option value='138'>suryashweta_c@yahoo.com</option><option value='139'>123sskd75@gmail.com</option><option value='140'>cadjadhav@gmail.com</option><option value='142'>shailaja.faithbuild@gmail.com</option><option value='143'>vineetabora@gmail.com</option><option value='144'>surbhi_koshta@yahoo.co.in</option><option value='145'>roy.fernandes7@gmail.com</option><option value='146'>lavneet.s.rathor@gmail.com</option><option value='147'>anjaliatre@yahoo.co.in</option><option value='148'>nititaj@gmail.com</option><option value='149'>findlubna@gmail.com</option><option value='150'>swatirath57@gmail.com</option><option value='151'>swatigothoskar@hotmail.com</option><option value='152'>narayananbadri09@gmail.com</option><option value='153'>priyanka55shelar@gmail.com</option><option value='155'>priyasrinivasan08@gmail.com</option><option value='156'>subin_ck@yahoo.co.in</option><option value='157'>sunitharunkumar@yahoo.co.in</option><option value='158'>sathyavenkatraj@gmail.com</option><option value='159'>thangaraj.academics@gmail.com</option><option value='160'>abip72@gmail.com</option><option value='161'>ragapriya.priya@gmail.com</option><option value='162'>paul_1@istarindia.com</option><option value='163'>shreeram_1@istarindia.com</option><option value='164'>shruthi_1@istarindia.com</option><option value='165'>deepti_1@istarindia.com</option><option value='166'>santosh_1@istarindia.com</option><option value='7504'>krisashokan@gmail.com</option><option value='170'>anusha_paul_1@istarindia.com</option><option value='172'>hemashree_1@istarindia.com</option><option value='134'>prernakapoor1@rediffmail.com</option><option value='141'>bikash_rathi@hotmail.com</option><option value='154'>nagadharanya@gmail.com</option><option value='171'>surga_1@istarindia.com</option><option value='7159'>divya.srinivasan05@gmail.com</option><option value='416'>sana19in@gmail.com</option><option value='385'>suraghsan@gmail.com</option><option value='387'>dummy@istarindia.com</option><option value='404'>sreekantha.mb@gmail.com</option><option value='406'>prvsomani@gmail.com</option><option value='410'>krishnankiru@gmail.com</option><option value='412'>mrigakshi.isms@gmail.com</option><option value='414'>pal.navinkumar@gmail.com</option><option value='418'>nirmalsonu17@gmail.com</option><option value='420'>amikakkad@rediffmail.com</option><option value='422'>selvilkannan@gmail.com</option><option value='424'>baral.namrata1@gmail.com</option><option value='426'>latishin@gmail.com</option><option value='1775'>84.ambika@gmail.com</option><option value='1777'>aditya.jain835@gmail.com</option><option value='1781'>uswarna@gmail.com</option><option value='1783'>cakaustubhbasu@gmail.com</option><option value='1785'>koteswaranaidu.j@gmail.com</option><option value='1787'>dinakar070@gmail.com</option><option value='1789'>subra.naskar@gmail.com</option><option value='1905'>anuja.jd@gmail.com</option><option value='2315'>venkatesh@istarindia.com</option><option value='2635'>uma_naresh@yahoo.com</option><option value='2636'>vidbha.m20@gmail.com</option><option value='2637'>swati1ximb@gmail.com</option><option value='2638'>sanjay@redwoodsyndicate.com</option><option value='2639'>saptarshim@ymail.com</option><option value='2640'>kirankvknet@gmail.com</option><option value='2641'>shubhada.vaidyanath@gmail.com</option><option value='2642'>nidhi.v.verma@gmail.com</option><option value='2643'>priyanka.sarawagi123@gmail.com</option><option value='2644'>prishikkesh@gmail.com</option><option value='2645'>twinkle.puc@gmail.com</option><option value='2646'>ratnashukla05@rediffmail.com</option><option value='2647'>viswanath_g_n@yahoo.com</option><option value='2648'>joydipg@gmail.com</option><option value='2649'>sayoojyasanil@gmail.com</option><option value='2650'>helinajay@gmail.com</option><option value='2651'>mohammadi_kousar@yahoo.co.in</option><option value='2652'>ymuralidharreddy@gmail.com</option><option value='2653'>poornima.jnv@gmail.com</option><option value='2654'>sreevenu74@gmail.com</option><option value='7722'>sureshkrish53535@gmail.com</option><option value='3318'>swatisinghnew@gmail.com</option><option value='3322'>apeksha.ashtekar@gmail.com</option><option value='3403'>rohitvkatira@gmail.com</option><option value='3501'>pooja@gmail.com</option><option value='3512'>ophir.impact@gmail.com</option><option value='3523'>ddddd@gmail.com</option><option value='3552'>payal_23pari@yahoo.co.in</option><option value='3595'>demo_developer@istarindia.com</option><option value='3640'>panank12@yahoo.com</option><option value='3665'>cuttambakamharikishan89@gmail.com</option><option value='3671'>sonisrikanth@yahoo.com</option><option value='3729'>shailendra.k.garg@gmail.com</option><option value='4478'>syedjaffer00@gmail.com</option><option value='4480'>anudesikan@hotmail.com</option><option value='4482'>poojau.sampat@gmail.com</option><option value='4484'>kumar.sanjeet2009@yahoo</option><option value='4486'>priya_angle@hotmail.com</option><option value='4488'>saurabhpkjain@gmail.com</option><option value='4490'>praveenshivs@gmail.com</option><option value='4498'>subhadraaithal@gmail.com</option><option value='4500'>darshana11daga@gmail.com</option><option value='4502'>caajaysbp@gmail.com</option><option value='4504'>parida2588@gmail.com</option><option value='4506'>urvashi.mirani7@gmail.com</option><option value='4508'>iyershankar2016@gmail.com</option><option value='4510'>Pankaj.singhal77@gmail.com</option><option value='4512'>baji143@rediffmail.com</option><option value='4514'>u.sheikshavali@gmail.com</option><option value='4545'>sandeepg@istarindia.com</option><option value='4696'>jaishankarcm@gmail.com</option><option value='4700'>dubeyhemlata36@gmail.com</option><option value='4702'>mona.shyamal@gmail.com</option><option value='4704'>pallavikarun@gmail.com</option><option value='4714'>salahuddin.shoupa@gmail.com</option><option value='4716'>bc_sanjay@rediffmail.com</option><option value='4718'>ms.srividyanaik@gmail.com</option><option value='4720'>shubhashree.krishnan@gmail.com</option><option value='4729'>pchavan2003.19@gmail.com</option><option value='4730'>abcd@istarindia.com</option><option value='4732'>saloni.j.jain@gmail.com</option><option value='4737'>im_abhishek@rediffmail.com</option><option value='7161'>pattammal@hotmail.com</option><option value='4743'>gayathri@istarindia.com</option><option value='4753'>sethi.parveen@gmail.com</option><option value='4906'>santhoshsam00@gmail.com</option><option value='4929'>rohini@istarindia.com</option><option value='5045'>milind.mohod@gmail.com</option><option value='5064'>solomon@gianthunt.com</option><option value='5068'>vrishali.singh@istarindia.com</option><option value='5098'>ronakrai02@gmail.com</option><option value='5100'>amin_vandana@yahoo.com</option><option value='5127'>cvjshastry@gmail.com</option><option value='5154'>venkateshwarreddy@istarindia.com</option><option value='5189'>ca.saiganesh@gmail.com</option><option value='5276'>bhagyaraj@istarindia.com</option><option value='5279'>nikhil@istarindia.com</option><option value='5282'>jaswinder.sunskills@gmail.com</option><option value='5348'>niru.mane@gmail.com</option><option value='5372'>satwinderkaur02@gmail.com</option><option value='5374'>alfy_972@yahoo.co.in</option><option value='5384'>hnagaraj11@gmail.com</option><option value='5412'>rajansathish@rediffmail.com</option><option value='5968'>dvlhimabindu@gmail.com</option><option value='5982'>faizairam.123@gmail.com</option><option value='5984'>misra.smita@rediffmail.com</option><option value='6022'>aditya_1@istarindia.com</option><option value='5265'>karthiik@istarindia.com</option><option value='5517'>vaibhav_9@istarindia.com</option><option value='6051'>gg@gmail.com</option><option value='5284'>saikumar@istarindia.com</option><option value='5454'>visu.chintu@gmail.com</option><option value='5286'>sandeep@istarindia.com</option><option value='4739'>nams.77@gmail.com</option><option value='173'>divya_1@istarindia.com</option><option value='7169'>sahuprabhat1992@gmail.com</option><option value='4496'>sarovishwa@gmail.com</option><option value='4522'>karthik_trainer@istarindia.com</option><option value='6972'>anusha_t@istarindia.com</option><option value='7179'>testing2@istarindia.com</option><option value='167'>neetu_1@istarindia.com</option><option value='127'>beena.aruna@gmail.com</option><option value='6978'>priyankas0907@gmail.com</option><option value='5092'>swarup@istarindia.com</option><option value='7193'>sastikmr@gmail.com</option><option value='7199'>vandana7rao@gmail.com</option><option value='6971'>teju@istarindia.com</option><option value='7662'>subha2492@gmail.com</option><option value='6992'>techintern1@istarindia.com</option><option value='7163'>demo_trainer@istarindia.com</option><option value='7177'>testing1@istarindia.com</option><option value='6989'>tetstr@gmail.com</option><option value='6994'>vinay123@gmail.com</option><option value='6996'>techintern3@istarindia.com</option><option value='6998'>ravi@istarindia.com</option><option value='7000'>swathi.jain96@gmail.com</option><option value='7005'>ajay@rajagffiri.edu</option><option value='7088'>vijay@istarindia.com</option><option value='7171'>demotrainer@istarindia.com</option><option value='7187'>s.maneesh1986@gmail.com</option><option value='7201'>ravichandra@istarindia.com</option><option value='7165'>carobertmjesu@gmail.com</option><option value='7206'>mahalakshmi333.ravi@gmail.com</option><option value='7105'>muksatt2505@gmail.com</option><option value='7210'>charmi_ca@yahoo.com</option><option value='7212'>asmithaiwala@gmail.com</option><option value='7214'>asms009@gmail.com</option><option value='7220'>remya.vjn@gmail.com</option><option value='7225'>shuklabhishek0792@gmail.com</option><option value='7231'>ASHOKKUMARK80@GMAIL.COM</option><option value='7233'>ashokkumark80@gmail.com</option><option value='7235'>veekshithhc@gmail.com</option><option value='7237'>mrsawant1@gmail.com</option><option value='168'>hema_1@istarindia.com</option><option value='7717'>vijing11@gmail.com</option><option value='7183'>anjalimsarda93@gmail.com</option><option value='7090'>durgi62@gmail.com</option><option value='7092'>farhanmtr1@gmail.com</option><option value='7094'>manasamaragoni@gmail.com</option><option value='7096'>manc.kamdar@gmail.com</option><option value='7098'>shweta_khanzode@yahoo.com</option><option value='175'>mark_1@istarindia.com</option><option value='7100'>krishnan.jayasri@gmail.com</option><option value='7117'>pdharmu@gmail.com</option><option value='7175'>ranjitk.mishra@gmail.com</option><option value='7103'>priyank@gmail.com</option><option value='7107'>aslam.driger@gmail.com</option><option value='7109'>vinayfortest@istarindia.com</option><option value='7111'>rahul.ramchandani792@gmail.com</option><option value='7113'>shreyagovind@gmail.com</option><option value='7115'>28june@istarindia.com</option><option value='7119'>lol@lol.com</option><option value='7121'>al@lol.com</option><option value='7123'>adal@lol.com</option><option value='7125'>ravi2@istarindia.com</option><option value='7127'>murali.s.seetharaman@gmail.com</option><option value='7129'>abhishek.cka@gmail.com</option><option value='7133'>praveen.hore@rediffmail.com</option><option value='7135'>mother@istarindia.com</option><option value='7136'>mother_presenter@istarindia.com</option><option value='7137'>keyboard@istarindia.com</option><option value='7195'>karthikdhilip@gmail.com</option><option value='7139'>VaibhavTemap@istarindia.com</option><option value='7203'>chiranjeevi.gatti@gmail.com</option><option value='7141'>nagadharanya@istarindia.com</option><option value='7167'>test1@istarindia.com</option><option value='6985'>deeptolive@gmail.com</option><option value='7181'>santosh.neups@gmail.com</option><option value='7143'>ab@istarindia.com</option><option value='7145'>dhanadakishor@gmail.com</option><option value='7185'>munirajuharsha@gmail.com</option><option value='8'>mark@istarindia.com</option><option value='7189'>reddyvinay100@gmail.com</option><option value='7197'>amolmotghare2913@gmail.com</option><option value='7154'>senthilkumarbabu@hotmail.com</option><option value='7147'>soumya.kash@gmail.com</option><option value='7149'>rbalu1960@gmail.com</option><option value='7243'>soundram63@gmail.com</option><option value='7151'>ms.ananthan@gmail.com</option><option value='6974'>iamvivekanands@gmail.com</option><option value='169'>teju_1@istarindia.com</option><option value='7208'>caanmolagrawal@gmail.com</option><option value='7227'>senthilkumar.rajappan@gmail.com</option><option value='408'>henna.khemani@gmail.com</option><option value='7156'>pranavmilan99@gmail.com</option><option value='7223'>sandeep_dbest@yahoo.co.in</option><option value='7229'>abby42.va@gmail.com</option><option value='7239'>alakshmanan75@gmail.com</option><option value='7241'>krajeev1976@gmail.com</option><option value='174'>archana_1@istarindia.com</option><option value='4741'>rameshk@istarindia.com</option><option value='7438'>tijovarghese3@gmail.com</option><option value='7728'>stutivadalia@gmail.com</option><option value='7513'>mpsrinivas28@gmail.com</option><option value='7585'>roshni23@gmail.com</option><option value='7574'>Vigneshwaranvishal@gmail.com</option><option value='7440'>munirajuharsha@hotmail.com</option><option value='7452'>hemika88@gmail.com</option><option value='7458'>jadhavpoonam1712@gmail.com</option><option value='7467'>Josh7win@gmail.com</option><option value='7469'>badimaladileepkumar@gmail.com</option><option value='7493'>sekarsdream@gmail.com</option><option value='7442'>vijayright05@gmail.com</option><option value='7444'>sha_ba2016@yahoo.com</option><option value='7446'>palashconsultancy@gmail.com</option><option value='7502'>ramadurairaghunathan@gmail.com</option><option value='7465'>anusha_vikram@yahoo.com</option><option value='7488'>savankeshriya@gmail.com</option><option value='7450'>mohanramu19@gmail.com</option><option value='7491'>sudhi4321@gmail.com</option><option value='7454'>reply2hemanth@gmail.com</option><option value='5236'>mamathajobmail2016@gmail.com</option><option value='7498'>suriyamba@live.com</option><option value='7567'>ravinder.gupta@federalmogul.com</option><option value='7462'>miriamphilip@gmail.com</option><option value='3814'>paul@istarindia.com</option><option value='7448'>geethage.rce@gmail.com</option><option value='7456'>sheelamxavier@gmail.com</option><option value='7460'>ashutoshkar11@gmail.com</option><option value='7495'>sridevi_17@yahoo.com</option><option value='7500'>cricvenky2298@gmail.com</option><option value='7572'>janu200292@gmail.com</option><option value='1779'>maureenjs55@gmail.com</option><option value='7478'>preeti.padmanaban@gmail.com</option><option value='7577'>mambu_patrick@yahoo.fr</option><option value='7579'>hariharans337@gmail.Com</option><option value='7664'>cacskrithika@gmail.com</option><option value='4881'>kotresh@istarindia.com</option><option value='7583'>hasini1981@rediffmail.com</option><option value='402'>shyam@istarindia.com</option><option value='7666'>av7ganesan@gmail.com</option><option value='7581'>raziyas221998@gmail.com</option><option value='7740'>new1@istar.com</option><option value='7738'>vinay_24july@istarindia.com</option><option value='449'>vinay_sales@istarindia.com</option><option value='17464'>it_trainer@istarindia.com</option><option value='17466'>it2@istarindia.com</option><option value='17468'>it3@istarindia.com</option>

				</select>
			</div>
			<div class="form-group">
				<label>Choose Associate Trainee</label>
				<input type="hidden" id="daily_associateTrainerID_holder" name="associateTrainerID" value="0"/>
				<select data-placeholder="Select Associate Trainer"  multiple
						tabindex="4" name="" id="daily_associateTrainerID" class="associateTrainer">
						<option value="">Select Associate Trainers...</option>
					       <option value='128'>subhra.naskar@gmail.com</option><option value='129'>hariharan.deepalakshmi@gmail.com</option><option value='130'>robinfrank88@gmail.com</option><option value='131'>bssuhas@gmail.com</option><option value='132'>anupama.ghoshal@gmail.com</option><option value='133'>vanishree.deepak@gmail.com</option><option value='135'>chetansinghp1991@gmail.com</option><option value='136'>jyothigadiya@gmail.com</option><option value='137'>vikassingh4219@gmail.com</option><option value='138'>suryashweta_c@yahoo.com</option><option value='139'>123sskd75@gmail.com</option><option value='140'>cadjadhav@gmail.com</option><option value='142'>shailaja.faithbuild@gmail.com</option><option value='143'>vineetabora@gmail.com</option><option value='144'>surbhi_koshta@yahoo.co.in</option><option value='145'>roy.fernandes7@gmail.com</option><option value='146'>lavneet.s.rathor@gmail.com</option><option value='147'>anjaliatre@yahoo.co.in</option><option value='148'>nititaj@gmail.com</option><option value='149'>findlubna@gmail.com</option><option value='150'>swatirath57@gmail.com</option><option value='151'>swatigothoskar@hotmail.com</option><option value='152'>narayananbadri09@gmail.com</option><option value='153'>priyanka55shelar@gmail.com</option><option value='155'>priyasrinivasan08@gmail.com</option><option value='156'>subin_ck@yahoo.co.in</option><option value='157'>sunitharunkumar@yahoo.co.in</option><option value='158'>sathyavenkatraj@gmail.com</option><option value='159'>thangaraj.academics@gmail.com</option><option value='160'>abip72@gmail.com</option><option value='161'>ragapriya.priya@gmail.com</option><option value='162'>paul_1@istarindia.com</option><option value='163'>shreeram_1@istarindia.com</option><option value='164'>shruthi_1@istarindia.com</option><option value='165'>deepti_1@istarindia.com</option><option value='166'>santosh_1@istarindia.com</option><option value='7504'>krisashokan@gmail.com</option><option value='170'>anusha_paul_1@istarindia.com</option><option value='172'>hemashree_1@istarindia.com</option><option value='134'>prernakapoor1@rediffmail.com</option><option value='141'>bikash_rathi@hotmail.com</option><option value='154'>nagadharanya@gmail.com</option><option value='171'>surga_1@istarindia.com</option><option value='7159'>divya.srinivasan05@gmail.com</option><option value='416'>sana19in@gmail.com</option><option value='385'>suraghsan@gmail.com</option><option value='387'>dummy@istarindia.com</option><option value='404'>sreekantha.mb@gmail.com</option><option value='406'>prvsomani@gmail.com</option><option value='410'>krishnankiru@gmail.com</option><option value='412'>mrigakshi.isms@gmail.com</option><option value='414'>pal.navinkumar@gmail.com</option><option value='418'>nirmalsonu17@gmail.com</option><option value='420'>amikakkad@rediffmail.com</option><option value='422'>selvilkannan@gmail.com</option><option value='424'>baral.namrata1@gmail.com</option><option value='426'>latishin@gmail.com</option><option value='1775'>84.ambika@gmail.com</option><option value='1777'>aditya.jain835@gmail.com</option><option value='1781'>uswarna@gmail.com</option><option value='1783'>cakaustubhbasu@gmail.com</option><option value='1785'>koteswaranaidu.j@gmail.com</option><option value='1787'>dinakar070@gmail.com</option><option value='1789'>subra.naskar@gmail.com</option><option value='1905'>anuja.jd@gmail.com</option><option value='2315'>venkatesh@istarindia.com</option><option value='2635'>uma_naresh@yahoo.com</option><option value='2636'>vidbha.m20@gmail.com</option><option value='2637'>swati1ximb@gmail.com</option><option value='2638'>sanjay@redwoodsyndicate.com</option><option value='2639'>saptarshim@ymail.com</option><option value='2640'>kirankvknet@gmail.com</option><option value='2641'>shubhada.vaidyanath@gmail.com</option><option value='2642'>nidhi.v.verma@gmail.com</option><option value='2643'>priyanka.sarawagi123@gmail.com</option><option value='2644'>prishikkesh@gmail.com</option><option value='2645'>twinkle.puc@gmail.com</option><option value='2646'>ratnashukla05@rediffmail.com</option><option value='2647'>viswanath_g_n@yahoo.com</option><option value='2648'>joydipg@gmail.com</option><option value='2649'>sayoojyasanil@gmail.com</option><option value='2650'>helinajay@gmail.com</option><option value='2651'>mohammadi_kousar@yahoo.co.in</option><option value='2652'>ymuralidharreddy@gmail.com</option><option value='2653'>poornima.jnv@gmail.com</option><option value='2654'>sreevenu74@gmail.com</option><option value='7722'>sureshkrish53535@gmail.com</option><option value='3318'>swatisinghnew@gmail.com</option><option value='3322'>apeksha.ashtekar@gmail.com</option><option value='3403'>rohitvkatira@gmail.com</option><option value='3501'>pooja@gmail.com</option><option value='3512'>ophir.impact@gmail.com</option><option value='3523'>ddddd@gmail.com</option><option value='3552'>payal_23pari@yahoo.co.in</option><option value='3595'>demo_developer@istarindia.com</option><option value='3640'>panank12@yahoo.com</option><option value='3665'>cuttambakamharikishan89@gmail.com</option><option value='3671'>sonisrikanth@yahoo.com</option><option value='3729'>shailendra.k.garg@gmail.com</option><option value='4478'>syedjaffer00@gmail.com</option><option value='4480'>anudesikan@hotmail.com</option><option value='4482'>poojau.sampat@gmail.com</option><option value='4484'>kumar.sanjeet2009@yahoo</option><option value='4486'>priya_angle@hotmail.com</option><option value='4488'>saurabhpkjain@gmail.com</option><option value='4490'>praveenshivs@gmail.com</option><option value='4498'>subhadraaithal@gmail.com</option><option value='4500'>darshana11daga@gmail.com</option><option value='4502'>caajaysbp@gmail.com</option><option value='4504'>parida2588@gmail.com</option><option value='4506'>urvashi.mirani7@gmail.com</option><option value='4508'>iyershankar2016@gmail.com</option><option value='4510'>Pankaj.singhal77@gmail.com</option><option value='4512'>baji143@rediffmail.com</option><option value='4514'>u.sheikshavali@gmail.com</option><option value='4545'>sandeepg@istarindia.com</option><option value='4696'>jaishankarcm@gmail.com</option><option value='4700'>dubeyhemlata36@gmail.com</option><option value='4702'>mona.shyamal@gmail.com</option><option value='4704'>pallavikarun@gmail.com</option><option value='4714'>salahuddin.shoupa@gmail.com</option><option value='4716'>bc_sanjay@rediffmail.com</option><option value='4718'>ms.srividyanaik@gmail.com</option><option value='4720'>shubhashree.krishnan@gmail.com</option><option value='4729'>pchavan2003.19@gmail.com</option><option value='4730'>abcd@istarindia.com</option><option value='4732'>saloni.j.jain@gmail.com</option><option value='4737'>im_abhishek@rediffmail.com</option><option value='7161'>pattammal@hotmail.com</option><option value='4743'>gayathri@istarindia.com</option><option value='4753'>sethi.parveen@gmail.com</option><option value='4906'>santhoshsam00@gmail.com</option><option value='4929'>rohini@istarindia.com</option><option value='5045'>milind.mohod@gmail.com</option><option value='5064'>solomon@gianthunt.com</option><option value='5068'>vrishali.singh@istarindia.com</option><option value='5098'>ronakrai02@gmail.com</option><option value='5100'>amin_vandana@yahoo.com</option><option value='5127'>cvjshastry@gmail.com</option><option value='5154'>venkateshwarreddy@istarindia.com</option><option value='5189'>ca.saiganesh@gmail.com</option><option value='5276'>bhagyaraj@istarindia.com</option><option value='5279'>nikhil@istarindia.com</option><option value='5282'>jaswinder.sunskills@gmail.com</option><option value='5348'>niru.mane@gmail.com</option><option value='5372'>satwinderkaur02@gmail.com</option><option value='5374'>alfy_972@yahoo.co.in</option><option value='5384'>hnagaraj11@gmail.com</option><option value='5412'>rajansathish@rediffmail.com</option><option value='5968'>dvlhimabindu@gmail.com</option><option value='5982'>faizairam.123@gmail.com</option><option value='5984'>misra.smita@rediffmail.com</option><option value='6022'>aditya_1@istarindia.com</option><option value='5265'>karthiik@istarindia.com</option><option value='5517'>vaibhav_9@istarindia.com</option><option value='6051'>gg@gmail.com</option><option value='5284'>saikumar@istarindia.com</option><option value='5454'>visu.chintu@gmail.com</option><option value='5286'>sandeep@istarindia.com</option><option value='4739'>nams.77@gmail.com</option><option value='173'>divya_1@istarindia.com</option><option value='7169'>sahuprabhat1992@gmail.com</option><option value='4496'>sarovishwa@gmail.com</option><option value='4522'>karthik_trainer@istarindia.com</option><option value='6972'>anusha_t@istarindia.com</option><option value='7179'>testing2@istarindia.com</option><option value='167'>neetu_1@istarindia.com</option><option value='127'>beena.aruna@gmail.com</option><option value='6978'>priyankas0907@gmail.com</option><option value='5092'>swarup@istarindia.com</option><option value='7193'>sastikmr@gmail.com</option><option value='7199'>vandana7rao@gmail.com</option><option value='6971'>teju@istarindia.com</option><option value='7662'>subha2492@gmail.com</option><option value='6992'>techintern1@istarindia.com</option><option value='7163'>demo_trainer@istarindia.com</option><option value='7177'>testing1@istarindia.com</option><option value='6989'>tetstr@gmail.com</option><option value='6994'>vinay123@gmail.com</option><option value='6996'>techintern3@istarindia.com</option><option value='6998'>ravi@istarindia.com</option><option value='7000'>swathi.jain96@gmail.com</option><option value='7005'>ajay@rajagffiri.edu</option><option value='7088'>vijay@istarindia.com</option><option value='7171'>demotrainer@istarindia.com</option><option value='7187'>s.maneesh1986@gmail.com</option><option value='7201'>ravichandra@istarindia.com</option><option value='7165'>carobertmjesu@gmail.com</option><option value='7206'>mahalakshmi333.ravi@gmail.com</option><option value='7105'>muksatt2505@gmail.com</option><option value='7210'>charmi_ca@yahoo.com</option><option value='7212'>asmithaiwala@gmail.com</option><option value='7214'>asms009@gmail.com</option><option value='7220'>remya.vjn@gmail.com</option><option value='7225'>shuklabhishek0792@gmail.com</option><option value='7231'>ASHOKKUMARK80@GMAIL.COM</option><option value='7233'>ashokkumark80@gmail.com</option><option value='7235'>veekshithhc@gmail.com</option><option value='7237'>mrsawant1@gmail.com</option><option value='168'>hema_1@istarindia.com</option><option value='7717'>vijing11@gmail.com</option><option value='7183'>anjalimsarda93@gmail.com</option><option value='7090'>durgi62@gmail.com</option><option value='7092'>farhanmtr1@gmail.com</option><option value='7094'>manasamaragoni@gmail.com</option><option value='7096'>manc.kamdar@gmail.com</option><option value='7098'>shweta_khanzode@yahoo.com</option><option value='175'>mark_1@istarindia.com</option><option value='7100'>krishnan.jayasri@gmail.com</option><option value='7117'>pdharmu@gmail.com</option><option value='7175'>ranjitk.mishra@gmail.com</option><option value='7103'>priyank@gmail.com</option><option value='7107'>aslam.driger@gmail.com</option><option value='7109'>vinayfortest@istarindia.com</option><option value='7111'>rahul.ramchandani792@gmail.com</option><option value='7113'>shreyagovind@gmail.com</option><option value='7115'>28june@istarindia.com</option><option value='7119'>lol@lol.com</option><option value='7121'>al@lol.com</option><option value='7123'>adal@lol.com</option><option value='7125'>ravi2@istarindia.com</option><option value='7127'>murali.s.seetharaman@gmail.com</option><option value='7129'>abhishek.cka@gmail.com</option><option value='7133'>praveen.hore@rediffmail.com</option><option value='7135'>mother@istarindia.com</option><option value='7136'>mother_presenter@istarindia.com</option><option value='7137'>keyboard@istarindia.com</option><option value='7195'>karthikdhilip@gmail.com</option><option value='7139'>VaibhavTemap@istarindia.com</option><option value='7203'>chiranjeevi.gatti@gmail.com</option><option value='7141'>nagadharanya@istarindia.com</option><option value='7167'>test1@istarindia.com</option><option value='6985'>deeptolive@gmail.com</option><option value='7181'>santosh.neups@gmail.com</option><option value='7143'>ab@istarindia.com</option><option value='7145'>dhanadakishor@gmail.com</option><option value='7185'>munirajuharsha@gmail.com</option><option value='8'>mark@istarindia.com</option><option value='7189'>reddyvinay100@gmail.com</option><option value='7197'>amolmotghare2913@gmail.com</option><option value='7154'>senthilkumarbabu@hotmail.com</option><option value='7147'>soumya.kash@gmail.com</option><option value='7149'>rbalu1960@gmail.com</option><option value='7243'>soundram63@gmail.com</option><option value='7151'>ms.ananthan@gmail.com</option><option value='6974'>iamvivekanands@gmail.com</option><option value='169'>teju_1@istarindia.com</option><option value='7208'>caanmolagrawal@gmail.com</option><option value='7227'>senthilkumar.rajappan@gmail.com</option><option value='408'>henna.khemani@gmail.com</option><option value='7156'>pranavmilan99@gmail.com</option><option value='7223'>sandeep_dbest@yahoo.co.in</option><option value='7229'>abby42.va@gmail.com</option><option value='7239'>alakshmanan75@gmail.com</option><option value='7241'>krajeev1976@gmail.com</option><option value='174'>archana_1@istarindia.com</option><option value='4741'>rameshk@istarindia.com</option><option value='7438'>tijovarghese3@gmail.com</option><option value='7728'>stutivadalia@gmail.com</option><option value='7513'>mpsrinivas28@gmail.com</option><option value='7585'>roshni23@gmail.com</option><option value='7574'>Vigneshwaranvishal@gmail.com</option><option value='7440'>munirajuharsha@hotmail.com</option><option value='7452'>hemika88@gmail.com</option><option value='7458'>jadhavpoonam1712@gmail.com</option><option value='7467'>Josh7win@gmail.com</option><option value='7469'>badimaladileepkumar@gmail.com</option><option value='7493'>sekarsdream@gmail.com</option><option value='7442'>vijayright05@gmail.com</option><option value='7444'>sha_ba2016@yahoo.com</option><option value='7446'>palashconsultancy@gmail.com</option><option value='7502'>ramadurairaghunathan@gmail.com</option><option value='7465'>anusha_vikram@yahoo.com</option><option value='7488'>savankeshriya@gmail.com</option><option value='7450'>mohanramu19@gmail.com</option><option value='7491'>sudhi4321@gmail.com</option><option value='7454'>reply2hemanth@gmail.com</option><option value='5236'>mamathajobmail2016@gmail.com</option><option value='7498'>suriyamba@live.com</option><option value='7567'>ravinder.gupta@federalmogul.com</option><option value='7462'>miriamphilip@gmail.com</option><option value='3814'>paul@istarindia.com</option><option value='7448'>geethage.rce@gmail.com</option><option value='7456'>sheelamxavier@gmail.com</option><option value='7460'>ashutoshkar11@gmail.com</option><option value='7495'>sridevi_17@yahoo.com</option><option value='7500'>cricvenky2298@gmail.com</option><option value='7572'>janu200292@gmail.com</option><option value='1779'>maureenjs55@gmail.com</option><option value='7478'>preeti.padmanaban@gmail.com</option><option value='7577'>mambu_patrick@yahoo.fr</option><option value='7579'>hariharans337@gmail.Com</option><option value='7664'>cacskrithika@gmail.com</option><option value='4881'>kotresh@istarindia.com</option><option value='7583'>hasini1981@rediffmail.com</option><option value='402'>shyam@istarindia.com</option><option value='7666'>av7ganesan@gmail.com</option><option value='7581'>raziyas221998@gmail.com</option><option value='7740'>new1@istar.com</option><option value='7738'>vinay_24july@istarindia.com</option><option value='449'>vinay_sales@istarindia.com</option><option value='17464'>it_trainer@istarindia.com</option><option value='17466'>it2@istarindia.com</option><option value='17468'>it3@istarindia.com</option>

					</select>
			</div>
			<div class="form-group">
				<label>Choose Section</label> <select
					class="form-control m-b batchGroupID scheduler_select" name="">
					<option value="">Select Section...</option>
					  

				</select>
			</div>
			<div class="form-group">
				<label>Select Course</label> <select
					class="form-control m-b courseID scheduler_select" name="batchID">
					<option value="">Select Course...</option>
					 <option value=''> Select Course...</option> 

				</select>
			</div>
			<div class="form-group">
				<label>Select Event Type</label> <select
					class="form-control m-b eventType scheduler_select" name="eventType">
					<option value="session">Session</option>
					<option value="webinar">Webinar (TOT)</option>
					<option value="remote_class">Remote Class</option>
					<!-- <option value="assessment">Assessment</option> -->

				</select>
			</div>
			<!-- <div class="assessment_list" id="assessment_list"
				style="display: none;">
				<div class="form-group">
					<label>Select Assessment</label> <select
						class="form-control m-b assessment scheduler_select" name="assessmentID">
						<option value="null">Select Assessment</option>

					</select>
				</div>
			</div> -->

			<div class="form-group">
				<label>Select Class-Room</label> <select class="form-control m-b scheduler_select"
					name="classroomID">
					<option value="">Select Classroom...</option>
					

				</select>
			</div>
			<!-- <div class="form-group" id="data_2">
				<label class="font-bold">Start Event Date</label>
				<div class="input-group date">
					<span class="input-group-addon"><i class="fa fa-calendar"></i></span><input
						type="text" name="startEventDate" class="form-control date_holder"
						value="03/03/2017">
				</div>
				<label class="font-bold">End Event Date</label>
				<div class="input-group date">
					<span class="input-group-addon"><i class="fa fa-calendar"></i></span><input
						type="text" name="endEventDate" class="form-control date_holder"
						value="03/03/2017">
				</div>
			</div> -->
			 <div class="form-group" id="data_5">
                                <label class="font-bold">Event Date Range</label>
                                <div class="input-daterange input-group" id="datepicker">
                                    <input type="text" class="input-sm form-control date_holder"  name="startEventDate" value="31/03/2017"/>
                                    <span class="input-group-addon">to</span>
                                    <input type="text" class="input-sm form-control date_holder"name="endEventDate" value="01/04/2017" />
                                </div>
                            </div>

			<div class="form-group">
				<label class="font-bold">Event Time</label>
				<div class="input-group" data-autoclose="true">
					 <span class="input-group-addon"> <span
						class="fa fa-clock-o"></span>
					</span><!-- <input type="text" style="width: 100%; height: 28px;" name="startTime" class="timepicker"/> -->
					<input type="text" style="width: 100%; height: 28px;" name="startTime" class="time_element"/>
				</div> 
				<!-- <div class="input-group clockpicker" data-autoclose="true">
					<input type="text" class="form-control time_holder" name="startTime"
						value="09:30"> <span class="input-group-addon"> <span
						class="fa fa-clock-o"></span>
					</span>
				</div> -->

			</div>
			<div class="form-group form-inline">
				<label class="font-bold">Duration</label> <label class="sr-only">Hours</label>
				<input type="number" value="1" name="hours" placeholder="Hours"
					class="form-control duration_holder"> <label class="sr-only">minute</label>
				<input type="number" value="0" name="minute" placeholder="Minute"
					class="form-control duration_holder">
			</div>
			<button class="btn btn-danger form-submit-btn custom-theme-btn-primary" data-form="idForm2"
				type="button">Save changes</button>
		</form>

	</div>

										</div>
										
										<div id="tab-3" class=" tab-pane">
										








	<div class="panel-body border-event">

		<form id="idForm3" class="form">
			<input type="hidden" name="AdminUserID" value="300" />
			<input type="hidden" name="tabType" value="weeklyEvent" />
			
			<div class="form-group">
				<label>Choose Organization</label> <select
					class="form-control m-b org_holder scheduler_select" name="orgID">
					
					<option value="0">Select Organization...</option>
					<option value='4'>MES teachers College</option><option value='5'>BVP College</option><option value='6'>PSGR Krishnammal College for Women			</option><option value='7'>Dr NGP Arts &amp; Science College.</option><option value='8'>St. Joseph college of commerce.</option><option value='67'>Som-Lalit institute of Management Studies</option><option value='68'> Adarsha Institute of Technology</option><option value='69'>Guru Nanak Institute of Management</option><option value='70'>HR Institute of technology</option><option value='71'>Delhi Institute of Advanced Studies</option><option value='72'>Indira College of Commerce</option><option value='73'>BVP Engineering</option><option value='74'>Methodist Engineering College</option><option value='75'>TKR College of Engineering and Technology</option><option value='76'>Menarini Asia Pacific</option><option value='78'>Ajuba</option><option value='79'>Allianz</option><option value='80'>Amnet Systems</option><option value='81'>Aspire Systems</option><option value='82'>Bmc Software</option><option value='83'>Capgemini</option><option value='84'>Charter Global</option><option value='85'>Clover Infotech</option><option value='86'>CME Group</option><option value='123'>HP</option><option value='124'>Vizag_DDU-GKY </option><option value='2'>ISTAR</option><option value='3'>East Point College</option><option value='87'>Crayon</option><option value='88'>Cyber Infrastructure</option><option value='89'>Espire</option><option value='90'>Geometric</option><option value='92'>Harman Connected Sevices</option><option value='93'>Headstrong</option><option value='94'>Hinduja Global Solutions</option><option value='95'>iFocus Systec</option><option value='96'>Impetus</option><option value='97'>Infogain</option><option value='98'>Infosys</option><option value='99'>Invenio Business Solutions</option><option value='100'>Iron Mountain</option><option value='101'>Mindteck</option><option value='102'>Nasdaq</option><option value='103'>Ocwen Financial Services</option><option value='104'>Opteamix</option><option value='105'>People Tech Group</option><option value='106'>Polaris</option><option value='107'>PWC</option><option value='108'>Q3 Technologies</option><option value='109'>Sopra Steria</option><option value='110'>SourceHOV</option><option value='111'>Syntel</option><option value='112'>T-Systems</option><option value='113'>Tata Consultancy Services</option><option value='114'>Teradata</option><option value='115'>Valtech</option><option value='116'>Value Labs</option><option value='117'>Williams Lea</option><option value='118'>Wipro</option><option value='119'>WNS Global Services</option><option value='120'>Yash Technologies</option><option value='121'>Zen3 Infosolutions India Ltd</option><option value='122'>Zensar Technologies</option><option value='126'>3i Infotech</option><option value='127'>Morgan Stanley</option><option value='128'>Mutual Mobile</option><option value='129'>Infoshore</option><option value='130'>Mc Fadyen Solutions</option><option value='137'>BAE Systems</option><option value='131'>AGC Networks Ltd</option><option value='132'>Solution Hawk</option><option value='133'>Aztec Software</option><option value='134'>Metlife</option><option value='135'>Experian</option><option value='136'>Intel</option><option value='138'>Fiserv</option><option value='139'>Honeywell</option><option value='140'>Northrop Grumman</option><option value='141'>Raytheon Websense</option><option value='142'>Serco</option><option value='143'>Unisys</option><option value='158'>Code Brew Labs</option><option value='144'>Lauruss Infotech</option><option value='145'>Peerbits</option><option value='146'>Telecom Network Solutions</option><option value='147'>Ciber</option><option value='148'>Hyperlink Infosystems</option><option value='149'>Tata ELXSI Ltd</option><option value='150'>Acer </option><option value='151'>Experion</option><option value='152'>Syon Infomedia pvt ltd</option><option value='153'>Accel frontline ltd</option><option value='154'>Cadence Design Systems</option><option value='155'>Intellect Design Arena</option><option value='156'>Debut infotech</option><option value='157'>Savex Technologies</option><option value='159'>Variance Infotech</option><option value='160'>Trigyn Technologies </option><option value='161'>Great-West Financial Services</option><option value='162'>Zoondia Pvt Ltd</option><option value='163'>Evince Development Pvt. Ltd. </option><option value='164'>Terasol Technologies</option><option value='165'>Accenture </option><option value='166'>Aditi Consulting</option><option value='167'>Adobe</option><option value='168'>Amazon</option><option value='169'>Apple</option><option value='170'>Appster</option><option value='178'>Cognizant</option><option value='171'>Atos consulting  &amp; Technology Services</option><option value='172'>ADP India Pvt Ltd</option><option value='173'>Intex</option><option value='174'>Brillio</option><option value='175'>CA Technologies</option><option value='176'>Canon</option><option value='177'>Cisco</option><option value='179'>Convergys</option><option value='180'>Credit Suisse</option><option value='181'>CSC</option><option value='182'>Cyient</option><option value='183'>Dell</option><option value='190'>Technource</option><option value='184'>D-Link</option><option value='185'>Huawei Technologies</option><option value='186'>Fidelity Investments</option><option value='187'>First Data</option><option value='188'>Google</option><option value='189'>Torry Harris Business Solutions</option><option value='191'>Goldman Sachs</option><option value='192'>Deloitte</option><option value='193'>Hitachi Data Systems</option><option value='194'>Citi Group</option><option value='195'>Synapse</option><option value='196'>Vinsol</option><option value='197'>Contus</option><option value='198'>Andola Soft</option><option value='199'>Metaoption</option><option value='200'>Infinite computer solutions</option><option value='201'>Ingram micro</option><option value='202'>IBM</option><option value='203'>Intuit</option><option value='204'>ISHIR</option><option value='205'>ITC Infotech</option><option value='206'>Kellton Tech</option><option value='207'>KPIT</option><option value='208'>Lenovo</option><option value='209'>LG Soft India Pvt Ltd</option><option value='210'>Prismetric Technologies</option><option value='211'>kotak</option><option value='212'>Xerox</option><option value='213'>ADCC Infocad limited</option><option value='214'>Replicon</option><option value='215'>Fujitsu</option><option value='216'>Mastek</option><option value='217'>Mastercard</option><option value='218'>McKinsey and Company</option><option value='219'>SIFY Technologies Limited</option><option value='220'>Microsoft</option><option value='221'>Mobikasa</option><option value='222'>Mphasis</option><option value='223'>NCR</option><option value='224'>NET Solutions</option><option value='225'>Nokia</option><option value='226'>NTT Data</option><option value='227'>Nucleus Software</option><option value='228'>Oracle</option><option value='229'>RR Donnelley</option><option value='230'>Saksoft</option><option value='231'>Samsung Electronics</option><option value='232'>CSS CORP</option><option value='233'>Synchrony Financial</option><option value='234'>Sierra Cedar</option><option value='235'>Bajaj Capital Services</option><option value='236'>Sonata Software</option><option value='237'>Sourcebits</option><option value='238'>SQS</option><option value='239'>Subex</option><option value='240'>Sutherland Global Services</option><option value='241'>Symantec</option><option value='242'>Tata Technologies</option><option value='243'>Tech Mahindra</option><option value='244'>Texas Instruments</option><option value='245'>TIBCO Software Inc</option><option value='246'>TATA Interactive Systems</option><option value='247'>Celetronix Power India Pvt Ltd</option><option value='248'>TVS Electronics</option><option value='249'>Vmware</option><option value='250'>Xilinx</option><option value='251'>Yudiz Solutions Pvt Ltd</option><option value='252'>Zenith Software LTD</option><option value='253'>Zensar Technologies</option><option value='254'>Zetagile Infosolutions Pvt Ltd</option><option value='255'>OSS Cube</option><option value='256'>Velocity Software</option><option value='257'>HeadHonchos.com</option><option value='258'>Dhanwate National College</option><option value='261'>Reva Institute of Technology and Management</option><option value='262'>Rathinam College of Arts and Science</option><option value='263'>Alpha Arts &amp; Science College	</option><option value='264'>ABC Bank Ltd</option><option value='265'>abc</option><option value='266'>Meenakshi Academy of Higher Education and Research</option><option value='267'>St. Britto&#146;s Academy</option><option value='268'>Parul University</option><option value='269'>Janalakshmi Financial Services</option><option value='270'>mes institute of management</option><option value='259'>Warangal_DDUGKY</option><option value='260'>Marwadi University		</option><option value='271'>Rajagiri College of Social Sciences </option><option value='273'>Retail</option><option value='272'>Istar IT Services Pvt Limited</option>

				</select>
			</div>
			
			<div class="form-group">
				<label>Choose Trainer</label> <select class="form-control m-b"
					name="trainerID">
					<option value="">Select Trainer...</option>
					<option value='128'>subhra.naskar@gmail.com</option><option value='129'>hariharan.deepalakshmi@gmail.com</option><option value='130'>robinfrank88@gmail.com</option><option value='131'>bssuhas@gmail.com</option><option value='132'>anupama.ghoshal@gmail.com</option><option value='133'>vanishree.deepak@gmail.com</option><option value='135'>chetansinghp1991@gmail.com</option><option value='136'>jyothigadiya@gmail.com</option><option value='137'>vikassingh4219@gmail.com</option><option value='138'>suryashweta_c@yahoo.com</option><option value='139'>123sskd75@gmail.com</option><option value='140'>cadjadhav@gmail.com</option><option value='142'>shailaja.faithbuild@gmail.com</option><option value='143'>vineetabora@gmail.com</option><option value='144'>surbhi_koshta@yahoo.co.in</option><option value='145'>roy.fernandes7@gmail.com</option><option value='146'>lavneet.s.rathor@gmail.com</option><option value='147'>anjaliatre@yahoo.co.in</option><option value='148'>nititaj@gmail.com</option><option value='149'>findlubna@gmail.com</option><option value='150'>swatirath57@gmail.com</option><option value='151'>swatigothoskar@hotmail.com</option><option value='152'>narayananbadri09@gmail.com</option><option value='153'>priyanka55shelar@gmail.com</option><option value='155'>priyasrinivasan08@gmail.com</option><option value='156'>subin_ck@yahoo.co.in</option><option value='157'>sunitharunkumar@yahoo.co.in</option><option value='158'>sathyavenkatraj@gmail.com</option><option value='159'>thangaraj.academics@gmail.com</option><option value='160'>abip72@gmail.com</option><option value='161'>ragapriya.priya@gmail.com</option><option value='162'>paul_1@istarindia.com</option><option value='163'>shreeram_1@istarindia.com</option><option value='164'>shruthi_1@istarindia.com</option><option value='165'>deepti_1@istarindia.com</option><option value='166'>santosh_1@istarindia.com</option><option value='7504'>krisashokan@gmail.com</option><option value='170'>anusha_paul_1@istarindia.com</option><option value='172'>hemashree_1@istarindia.com</option><option value='134'>prernakapoor1@rediffmail.com</option><option value='141'>bikash_rathi@hotmail.com</option><option value='154'>nagadharanya@gmail.com</option><option value='171'>surga_1@istarindia.com</option><option value='7159'>divya.srinivasan05@gmail.com</option><option value='416'>sana19in@gmail.com</option><option value='385'>suraghsan@gmail.com</option><option value='387'>dummy@istarindia.com</option><option value='404'>sreekantha.mb@gmail.com</option><option value='406'>prvsomani@gmail.com</option><option value='410'>krishnankiru@gmail.com</option><option value='412'>mrigakshi.isms@gmail.com</option><option value='414'>pal.navinkumar@gmail.com</option><option value='418'>nirmalsonu17@gmail.com</option><option value='420'>amikakkad@rediffmail.com</option><option value='422'>selvilkannan@gmail.com</option><option value='424'>baral.namrata1@gmail.com</option><option value='426'>latishin@gmail.com</option><option value='1775'>84.ambika@gmail.com</option><option value='1777'>aditya.jain835@gmail.com</option><option value='1781'>uswarna@gmail.com</option><option value='1783'>cakaustubhbasu@gmail.com</option><option value='1785'>koteswaranaidu.j@gmail.com</option><option value='1787'>dinakar070@gmail.com</option><option value='1789'>subra.naskar@gmail.com</option><option value='1905'>anuja.jd@gmail.com</option><option value='2315'>venkatesh@istarindia.com</option><option value='2635'>uma_naresh@yahoo.com</option><option value='2636'>vidbha.m20@gmail.com</option><option value='2637'>swati1ximb@gmail.com</option><option value='2638'>sanjay@redwoodsyndicate.com</option><option value='2639'>saptarshim@ymail.com</option><option value='2640'>kirankvknet@gmail.com</option><option value='2641'>shubhada.vaidyanath@gmail.com</option><option value='2642'>nidhi.v.verma@gmail.com</option><option value='2643'>priyanka.sarawagi123@gmail.com</option><option value='2644'>prishikkesh@gmail.com</option><option value='2645'>twinkle.puc@gmail.com</option><option value='2646'>ratnashukla05@rediffmail.com</option><option value='2647'>viswanath_g_n@yahoo.com</option><option value='2648'>joydipg@gmail.com</option><option value='2649'>sayoojyasanil@gmail.com</option><option value='2650'>helinajay@gmail.com</option><option value='2651'>mohammadi_kousar@yahoo.co.in</option><option value='2652'>ymuralidharreddy@gmail.com</option><option value='2653'>poornima.jnv@gmail.com</option><option value='2654'>sreevenu74@gmail.com</option><option value='7722'>sureshkrish53535@gmail.com</option><option value='3318'>swatisinghnew@gmail.com</option><option value='3322'>apeksha.ashtekar@gmail.com</option><option value='3403'>rohitvkatira@gmail.com</option><option value='3501'>pooja@gmail.com</option><option value='3512'>ophir.impact@gmail.com</option><option value='3523'>ddddd@gmail.com</option><option value='3552'>payal_23pari@yahoo.co.in</option><option value='3595'>demo_developer@istarindia.com</option><option value='3640'>panank12@yahoo.com</option><option value='3665'>cuttambakamharikishan89@gmail.com</option><option value='3671'>sonisrikanth@yahoo.com</option><option value='3729'>shailendra.k.garg@gmail.com</option><option value='4478'>syedjaffer00@gmail.com</option><option value='4480'>anudesikan@hotmail.com</option><option value='4482'>poojau.sampat@gmail.com</option><option value='4484'>kumar.sanjeet2009@yahoo</option><option value='4486'>priya_angle@hotmail.com</option><option value='4488'>saurabhpkjain@gmail.com</option><option value='4490'>praveenshivs@gmail.com</option><option value='4498'>subhadraaithal@gmail.com</option><option value='4500'>darshana11daga@gmail.com</option><option value='4502'>caajaysbp@gmail.com</option><option value='4504'>parida2588@gmail.com</option><option value='4506'>urvashi.mirani7@gmail.com</option><option value='4508'>iyershankar2016@gmail.com</option><option value='4510'>Pankaj.singhal77@gmail.com</option><option value='4512'>baji143@rediffmail.com</option><option value='4514'>u.sheikshavali@gmail.com</option><option value='4545'>sandeepg@istarindia.com</option><option value='4696'>jaishankarcm@gmail.com</option><option value='4700'>dubeyhemlata36@gmail.com</option><option value='4702'>mona.shyamal@gmail.com</option><option value='4704'>pallavikarun@gmail.com</option><option value='4714'>salahuddin.shoupa@gmail.com</option><option value='4716'>bc_sanjay@rediffmail.com</option><option value='4718'>ms.srividyanaik@gmail.com</option><option value='4720'>shubhashree.krishnan@gmail.com</option><option value='4729'>pchavan2003.19@gmail.com</option><option value='4730'>abcd@istarindia.com</option><option value='4732'>saloni.j.jain@gmail.com</option><option value='4737'>im_abhishek@rediffmail.com</option><option value='7161'>pattammal@hotmail.com</option><option value='4743'>gayathri@istarindia.com</option><option value='4753'>sethi.parveen@gmail.com</option><option value='4906'>santhoshsam00@gmail.com</option><option value='4929'>rohini@istarindia.com</option><option value='5045'>milind.mohod@gmail.com</option><option value='5064'>solomon@gianthunt.com</option><option value='5068'>vrishali.singh@istarindia.com</option><option value='5098'>ronakrai02@gmail.com</option><option value='5100'>amin_vandana@yahoo.com</option><option value='5127'>cvjshastry@gmail.com</option><option value='5154'>venkateshwarreddy@istarindia.com</option><option value='5189'>ca.saiganesh@gmail.com</option><option value='5276'>bhagyaraj@istarindia.com</option><option value='5279'>nikhil@istarindia.com</option><option value='5282'>jaswinder.sunskills@gmail.com</option><option value='5348'>niru.mane@gmail.com</option><option value='5372'>satwinderkaur02@gmail.com</option><option value='5374'>alfy_972@yahoo.co.in</option><option value='5384'>hnagaraj11@gmail.com</option><option value='5412'>rajansathish@rediffmail.com</option><option value='5968'>dvlhimabindu@gmail.com</option><option value='5982'>faizairam.123@gmail.com</option><option value='5984'>misra.smita@rediffmail.com</option><option value='6022'>aditya_1@istarindia.com</option><option value='5265'>karthiik@istarindia.com</option><option value='5517'>vaibhav_9@istarindia.com</option><option value='6051'>gg@gmail.com</option><option value='5284'>saikumar@istarindia.com</option><option value='5454'>visu.chintu@gmail.com</option><option value='5286'>sandeep@istarindia.com</option><option value='4739'>nams.77@gmail.com</option><option value='173'>divya_1@istarindia.com</option><option value='7169'>sahuprabhat1992@gmail.com</option><option value='4496'>sarovishwa@gmail.com</option><option value='4522'>karthik_trainer@istarindia.com</option><option value='6972'>anusha_t@istarindia.com</option><option value='7179'>testing2@istarindia.com</option><option value='167'>neetu_1@istarindia.com</option><option value='127'>beena.aruna@gmail.com</option><option value='6978'>priyankas0907@gmail.com</option><option value='5092'>swarup@istarindia.com</option><option value='7193'>sastikmr@gmail.com</option><option value='7199'>vandana7rao@gmail.com</option><option value='6971'>teju@istarindia.com</option><option value='7662'>subha2492@gmail.com</option><option value='6992'>techintern1@istarindia.com</option><option value='7163'>demo_trainer@istarindia.com</option><option value='7177'>testing1@istarindia.com</option><option value='6989'>tetstr@gmail.com</option><option value='6994'>vinay123@gmail.com</option><option value='6996'>techintern3@istarindia.com</option><option value='6998'>ravi@istarindia.com</option><option value='7000'>swathi.jain96@gmail.com</option><option value='7005'>ajay@rajagffiri.edu</option><option value='7088'>vijay@istarindia.com</option><option value='7171'>demotrainer@istarindia.com</option><option value='7187'>s.maneesh1986@gmail.com</option><option value='7201'>ravichandra@istarindia.com</option><option value='7165'>carobertmjesu@gmail.com</option><option value='7206'>mahalakshmi333.ravi@gmail.com</option><option value='7105'>muksatt2505@gmail.com</option><option value='7210'>charmi_ca@yahoo.com</option><option value='7212'>asmithaiwala@gmail.com</option><option value='7214'>asms009@gmail.com</option><option value='7220'>remya.vjn@gmail.com</option><option value='7225'>shuklabhishek0792@gmail.com</option><option value='7231'>ASHOKKUMARK80@GMAIL.COM</option><option value='7233'>ashokkumark80@gmail.com</option><option value='7235'>veekshithhc@gmail.com</option><option value='7237'>mrsawant1@gmail.com</option><option value='168'>hema_1@istarindia.com</option><option value='7717'>vijing11@gmail.com</option><option value='7183'>anjalimsarda93@gmail.com</option><option value='7090'>durgi62@gmail.com</option><option value='7092'>farhanmtr1@gmail.com</option><option value='7094'>manasamaragoni@gmail.com</option><option value='7096'>manc.kamdar@gmail.com</option><option value='7098'>shweta_khanzode@yahoo.com</option><option value='175'>mark_1@istarindia.com</option><option value='7100'>krishnan.jayasri@gmail.com</option><option value='7117'>pdharmu@gmail.com</option><option value='7175'>ranjitk.mishra@gmail.com</option><option value='7103'>priyank@gmail.com</option><option value='7107'>aslam.driger@gmail.com</option><option value='7109'>vinayfortest@istarindia.com</option><option value='7111'>rahul.ramchandani792@gmail.com</option><option value='7113'>shreyagovind@gmail.com</option><option value='7115'>28june@istarindia.com</option><option value='7119'>lol@lol.com</option><option value='7121'>al@lol.com</option><option value='7123'>adal@lol.com</option><option value='7125'>ravi2@istarindia.com</option><option value='7127'>murali.s.seetharaman@gmail.com</option><option value='7129'>abhishek.cka@gmail.com</option><option value='7133'>praveen.hore@rediffmail.com</option><option value='7135'>mother@istarindia.com</option><option value='7136'>mother_presenter@istarindia.com</option><option value='7137'>keyboard@istarindia.com</option><option value='7195'>karthikdhilip@gmail.com</option><option value='7139'>VaibhavTemap@istarindia.com</option><option value='7203'>chiranjeevi.gatti@gmail.com</option><option value='7141'>nagadharanya@istarindia.com</option><option value='7167'>test1@istarindia.com</option><option value='6985'>deeptolive@gmail.com</option><option value='7181'>santosh.neups@gmail.com</option><option value='7143'>ab@istarindia.com</option><option value='7145'>dhanadakishor@gmail.com</option><option value='7185'>munirajuharsha@gmail.com</option><option value='8'>mark@istarindia.com</option><option value='7189'>reddyvinay100@gmail.com</option><option value='7197'>amolmotghare2913@gmail.com</option><option value='7154'>senthilkumarbabu@hotmail.com</option><option value='7147'>soumya.kash@gmail.com</option><option value='7149'>rbalu1960@gmail.com</option><option value='7243'>soundram63@gmail.com</option><option value='7151'>ms.ananthan@gmail.com</option><option value='6974'>iamvivekanands@gmail.com</option><option value='169'>teju_1@istarindia.com</option><option value='7208'>caanmolagrawal@gmail.com</option><option value='7227'>senthilkumar.rajappan@gmail.com</option><option value='408'>henna.khemani@gmail.com</option><option value='7156'>pranavmilan99@gmail.com</option><option value='7223'>sandeep_dbest@yahoo.co.in</option><option value='7229'>abby42.va@gmail.com</option><option value='7239'>alakshmanan75@gmail.com</option><option value='7241'>krajeev1976@gmail.com</option><option value='174'>archana_1@istarindia.com</option><option value='4741'>rameshk@istarindia.com</option><option value='7438'>tijovarghese3@gmail.com</option><option value='7728'>stutivadalia@gmail.com</option><option value='7513'>mpsrinivas28@gmail.com</option><option value='7585'>roshni23@gmail.com</option><option value='7574'>Vigneshwaranvishal@gmail.com</option><option value='7440'>munirajuharsha@hotmail.com</option><option value='7452'>hemika88@gmail.com</option><option value='7458'>jadhavpoonam1712@gmail.com</option><option value='7467'>Josh7win@gmail.com</option><option value='7469'>badimaladileepkumar@gmail.com</option><option value='7493'>sekarsdream@gmail.com</option><option value='7442'>vijayright05@gmail.com</option><option value='7444'>sha_ba2016@yahoo.com</option><option value='7446'>palashconsultancy@gmail.com</option><option value='7502'>ramadurairaghunathan@gmail.com</option><option value='7465'>anusha_vikram@yahoo.com</option><option value='7488'>savankeshriya@gmail.com</option><option value='7450'>mohanramu19@gmail.com</option><option value='7491'>sudhi4321@gmail.com</option><option value='7454'>reply2hemanth@gmail.com</option><option value='5236'>mamathajobmail2016@gmail.com</option><option value='7498'>suriyamba@live.com</option><option value='7567'>ravinder.gupta@federalmogul.com</option><option value='7462'>miriamphilip@gmail.com</option><option value='3814'>paul@istarindia.com</option><option value='7448'>geethage.rce@gmail.com</option><option value='7456'>sheelamxavier@gmail.com</option><option value='7460'>ashutoshkar11@gmail.com</option><option value='7495'>sridevi_17@yahoo.com</option><option value='7500'>cricvenky2298@gmail.com</option><option value='7572'>janu200292@gmail.com</option><option value='1779'>maureenjs55@gmail.com</option><option value='7478'>preeti.padmanaban@gmail.com</option><option value='7577'>mambu_patrick@yahoo.fr</option><option value='7579'>hariharans337@gmail.Com</option><option value='7664'>cacskrithika@gmail.com</option><option value='4881'>kotresh@istarindia.com</option><option value='7583'>hasini1981@rediffmail.com</option><option value='402'>shyam@istarindia.com</option><option value='7666'>av7ganesan@gmail.com</option><option value='7581'>raziyas221998@gmail.com</option><option value='7740'>new1@istar.com</option><option value='7738'>vinay_24july@istarindia.com</option><option value='449'>vinay_sales@istarindia.com</option><option value='17464'>it_trainer@istarindia.com</option><option value='17466'>it2@istarindia.com</option><option value='17468'>it3@istarindia.com</option>

				</select>
			</div>
			<div class="form-group">
				<label>Choose Associate Trainee</label>
				<input type="hidden" id="weekly_associateTrainerID_holder" name="associateTrainerID" value="0"/>
				<select data-placeholder="Select Associate Trainer"  multiple
						tabindex="4" name="" id="weekly_associateTrainerID" class="associateTrainer">
						<option value="">Select Associate Trainers...</option>
					       <option value='128'>subhra.naskar@gmail.com</option><option value='129'>hariharan.deepalakshmi@gmail.com</option><option value='130'>robinfrank88@gmail.com</option><option value='131'>bssuhas@gmail.com</option><option value='132'>anupama.ghoshal@gmail.com</option><option value='133'>vanishree.deepak@gmail.com</option><option value='135'>chetansinghp1991@gmail.com</option><option value='136'>jyothigadiya@gmail.com</option><option value='137'>vikassingh4219@gmail.com</option><option value='138'>suryashweta_c@yahoo.com</option><option value='139'>123sskd75@gmail.com</option><option value='140'>cadjadhav@gmail.com</option><option value='142'>shailaja.faithbuild@gmail.com</option><option value='143'>vineetabora@gmail.com</option><option value='144'>surbhi_koshta@yahoo.co.in</option><option value='145'>roy.fernandes7@gmail.com</option><option value='146'>lavneet.s.rathor@gmail.com</option><option value='147'>anjaliatre@yahoo.co.in</option><option value='148'>nititaj@gmail.com</option><option value='149'>findlubna@gmail.com</option><option value='150'>swatirath57@gmail.com</option><option value='151'>swatigothoskar@hotmail.com</option><option value='152'>narayananbadri09@gmail.com</option><option value='153'>priyanka55shelar@gmail.com</option><option value='155'>priyasrinivasan08@gmail.com</option><option value='156'>subin_ck@yahoo.co.in</option><option value='157'>sunitharunkumar@yahoo.co.in</option><option value='158'>sathyavenkatraj@gmail.com</option><option value='159'>thangaraj.academics@gmail.com</option><option value='160'>abip72@gmail.com</option><option value='161'>ragapriya.priya@gmail.com</option><option value='162'>paul_1@istarindia.com</option><option value='163'>shreeram_1@istarindia.com</option><option value='164'>shruthi_1@istarindia.com</option><option value='165'>deepti_1@istarindia.com</option><option value='166'>santosh_1@istarindia.com</option><option value='7504'>krisashokan@gmail.com</option><option value='170'>anusha_paul_1@istarindia.com</option><option value='172'>hemashree_1@istarindia.com</option><option value='134'>prernakapoor1@rediffmail.com</option><option value='141'>bikash_rathi@hotmail.com</option><option value='154'>nagadharanya@gmail.com</option><option value='171'>surga_1@istarindia.com</option><option value='7159'>divya.srinivasan05@gmail.com</option><option value='416'>sana19in@gmail.com</option><option value='385'>suraghsan@gmail.com</option><option value='387'>dummy@istarindia.com</option><option value='404'>sreekantha.mb@gmail.com</option><option value='406'>prvsomani@gmail.com</option><option value='410'>krishnankiru@gmail.com</option><option value='412'>mrigakshi.isms@gmail.com</option><option value='414'>pal.navinkumar@gmail.com</option><option value='418'>nirmalsonu17@gmail.com</option><option value='420'>amikakkad@rediffmail.com</option><option value='422'>selvilkannan@gmail.com</option><option value='424'>baral.namrata1@gmail.com</option><option value='426'>latishin@gmail.com</option><option value='1775'>84.ambika@gmail.com</option><option value='1777'>aditya.jain835@gmail.com</option><option value='1781'>uswarna@gmail.com</option><option value='1783'>cakaustubhbasu@gmail.com</option><option value='1785'>koteswaranaidu.j@gmail.com</option><option value='1787'>dinakar070@gmail.com</option><option value='1789'>subra.naskar@gmail.com</option><option value='1905'>anuja.jd@gmail.com</option><option value='2315'>venkatesh@istarindia.com</option><option value='2635'>uma_naresh@yahoo.com</option><option value='2636'>vidbha.m20@gmail.com</option><option value='2637'>swati1ximb@gmail.com</option><option value='2638'>sanjay@redwoodsyndicate.com</option><option value='2639'>saptarshim@ymail.com</option><option value='2640'>kirankvknet@gmail.com</option><option value='2641'>shubhada.vaidyanath@gmail.com</option><option value='2642'>nidhi.v.verma@gmail.com</option><option value='2643'>priyanka.sarawagi123@gmail.com</option><option value='2644'>prishikkesh@gmail.com</option><option value='2645'>twinkle.puc@gmail.com</option><option value='2646'>ratnashukla05@rediffmail.com</option><option value='2647'>viswanath_g_n@yahoo.com</option><option value='2648'>joydipg@gmail.com</option><option value='2649'>sayoojyasanil@gmail.com</option><option value='2650'>helinajay@gmail.com</option><option value='2651'>mohammadi_kousar@yahoo.co.in</option><option value='2652'>ymuralidharreddy@gmail.com</option><option value='2653'>poornima.jnv@gmail.com</option><option value='2654'>sreevenu74@gmail.com</option><option value='7722'>sureshkrish53535@gmail.com</option><option value='3318'>swatisinghnew@gmail.com</option><option value='3322'>apeksha.ashtekar@gmail.com</option><option value='3403'>rohitvkatira@gmail.com</option><option value='3501'>pooja@gmail.com</option><option value='3512'>ophir.impact@gmail.com</option><option value='3523'>ddddd@gmail.com</option><option value='3552'>payal_23pari@yahoo.co.in</option><option value='3595'>demo_developer@istarindia.com</option><option value='3640'>panank12@yahoo.com</option><option value='3665'>cuttambakamharikishan89@gmail.com</option><option value='3671'>sonisrikanth@yahoo.com</option><option value='3729'>shailendra.k.garg@gmail.com</option><option value='4478'>syedjaffer00@gmail.com</option><option value='4480'>anudesikan@hotmail.com</option><option value='4482'>poojau.sampat@gmail.com</option><option value='4484'>kumar.sanjeet2009@yahoo</option><option value='4486'>priya_angle@hotmail.com</option><option value='4488'>saurabhpkjain@gmail.com</option><option value='4490'>praveenshivs@gmail.com</option><option value='4498'>subhadraaithal@gmail.com</option><option value='4500'>darshana11daga@gmail.com</option><option value='4502'>caajaysbp@gmail.com</option><option value='4504'>parida2588@gmail.com</option><option value='4506'>urvashi.mirani7@gmail.com</option><option value='4508'>iyershankar2016@gmail.com</option><option value='4510'>Pankaj.singhal77@gmail.com</option><option value='4512'>baji143@rediffmail.com</option><option value='4514'>u.sheikshavali@gmail.com</option><option value='4545'>sandeepg@istarindia.com</option><option value='4696'>jaishankarcm@gmail.com</option><option value='4700'>dubeyhemlata36@gmail.com</option><option value='4702'>mona.shyamal@gmail.com</option><option value='4704'>pallavikarun@gmail.com</option><option value='4714'>salahuddin.shoupa@gmail.com</option><option value='4716'>bc_sanjay@rediffmail.com</option><option value='4718'>ms.srividyanaik@gmail.com</option><option value='4720'>shubhashree.krishnan@gmail.com</option><option value='4729'>pchavan2003.19@gmail.com</option><option value='4730'>abcd@istarindia.com</option><option value='4732'>saloni.j.jain@gmail.com</option><option value='4737'>im_abhishek@rediffmail.com</option><option value='7161'>pattammal@hotmail.com</option><option value='4743'>gayathri@istarindia.com</option><option value='4753'>sethi.parveen@gmail.com</option><option value='4906'>santhoshsam00@gmail.com</option><option value='4929'>rohini@istarindia.com</option><option value='5045'>milind.mohod@gmail.com</option><option value='5064'>solomon@gianthunt.com</option><option value='5068'>vrishali.singh@istarindia.com</option><option value='5098'>ronakrai02@gmail.com</option><option value='5100'>amin_vandana@yahoo.com</option><option value='5127'>cvjshastry@gmail.com</option><option value='5154'>venkateshwarreddy@istarindia.com</option><option value='5189'>ca.saiganesh@gmail.com</option><option value='5276'>bhagyaraj@istarindia.com</option><option value='5279'>nikhil@istarindia.com</option><option value='5282'>jaswinder.sunskills@gmail.com</option><option value='5348'>niru.mane@gmail.com</option><option value='5372'>satwinderkaur02@gmail.com</option><option value='5374'>alfy_972@yahoo.co.in</option><option value='5384'>hnagaraj11@gmail.com</option><option value='5412'>rajansathish@rediffmail.com</option><option value='5968'>dvlhimabindu@gmail.com</option><option value='5982'>faizairam.123@gmail.com</option><option value='5984'>misra.smita@rediffmail.com</option><option value='6022'>aditya_1@istarindia.com</option><option value='5265'>karthiik@istarindia.com</option><option value='5517'>vaibhav_9@istarindia.com</option><option value='6051'>gg@gmail.com</option><option value='5284'>saikumar@istarindia.com</option><option value='5454'>visu.chintu@gmail.com</option><option value='5286'>sandeep@istarindia.com</option><option value='4739'>nams.77@gmail.com</option><option value='173'>divya_1@istarindia.com</option><option value='7169'>sahuprabhat1992@gmail.com</option><option value='4496'>sarovishwa@gmail.com</option><option value='4522'>karthik_trainer@istarindia.com</option><option value='6972'>anusha_t@istarindia.com</option><option value='7179'>testing2@istarindia.com</option><option value='167'>neetu_1@istarindia.com</option><option value='127'>beena.aruna@gmail.com</option><option value='6978'>priyankas0907@gmail.com</option><option value='5092'>swarup@istarindia.com</option><option value='7193'>sastikmr@gmail.com</option><option value='7199'>vandana7rao@gmail.com</option><option value='6971'>teju@istarindia.com</option><option value='7662'>subha2492@gmail.com</option><option value='6992'>techintern1@istarindia.com</option><option value='7163'>demo_trainer@istarindia.com</option><option value='7177'>testing1@istarindia.com</option><option value='6989'>tetstr@gmail.com</option><option value='6994'>vinay123@gmail.com</option><option value='6996'>techintern3@istarindia.com</option><option value='6998'>ravi@istarindia.com</option><option value='7000'>swathi.jain96@gmail.com</option><option value='7005'>ajay@rajagffiri.edu</option><option value='7088'>vijay@istarindia.com</option><option value='7171'>demotrainer@istarindia.com</option><option value='7187'>s.maneesh1986@gmail.com</option><option value='7201'>ravichandra@istarindia.com</option><option value='7165'>carobertmjesu@gmail.com</option><option value='7206'>mahalakshmi333.ravi@gmail.com</option><option value='7105'>muksatt2505@gmail.com</option><option value='7210'>charmi_ca@yahoo.com</option><option value='7212'>asmithaiwala@gmail.com</option><option value='7214'>asms009@gmail.com</option><option value='7220'>remya.vjn@gmail.com</option><option value='7225'>shuklabhishek0792@gmail.com</option><option value='7231'>ASHOKKUMARK80@GMAIL.COM</option><option value='7233'>ashokkumark80@gmail.com</option><option value='7235'>veekshithhc@gmail.com</option><option value='7237'>mrsawant1@gmail.com</option><option value='168'>hema_1@istarindia.com</option><option value='7717'>vijing11@gmail.com</option><option value='7183'>anjalimsarda93@gmail.com</option><option value='7090'>durgi62@gmail.com</option><option value='7092'>farhanmtr1@gmail.com</option><option value='7094'>manasamaragoni@gmail.com</option><option value='7096'>manc.kamdar@gmail.com</option><option value='7098'>shweta_khanzode@yahoo.com</option><option value='175'>mark_1@istarindia.com</option><option value='7100'>krishnan.jayasri@gmail.com</option><option value='7117'>pdharmu@gmail.com</option><option value='7175'>ranjitk.mishra@gmail.com</option><option value='7103'>priyank@gmail.com</option><option value='7107'>aslam.driger@gmail.com</option><option value='7109'>vinayfortest@istarindia.com</option><option value='7111'>rahul.ramchandani792@gmail.com</option><option value='7113'>shreyagovind@gmail.com</option><option value='7115'>28june@istarindia.com</option><option value='7119'>lol@lol.com</option><option value='7121'>al@lol.com</option><option value='7123'>adal@lol.com</option><option value='7125'>ravi2@istarindia.com</option><option value='7127'>murali.s.seetharaman@gmail.com</option><option value='7129'>abhishek.cka@gmail.com</option><option value='7133'>praveen.hore@rediffmail.com</option><option value='7135'>mother@istarindia.com</option><option value='7136'>mother_presenter@istarindia.com</option><option value='7137'>keyboard@istarindia.com</option><option value='7195'>karthikdhilip@gmail.com</option><option value='7139'>VaibhavTemap@istarindia.com</option><option value='7203'>chiranjeevi.gatti@gmail.com</option><option value='7141'>nagadharanya@istarindia.com</option><option value='7167'>test1@istarindia.com</option><option value='6985'>deeptolive@gmail.com</option><option value='7181'>santosh.neups@gmail.com</option><option value='7143'>ab@istarindia.com</option><option value='7145'>dhanadakishor@gmail.com</option><option value='7185'>munirajuharsha@gmail.com</option><option value='8'>mark@istarindia.com</option><option value='7189'>reddyvinay100@gmail.com</option><option value='7197'>amolmotghare2913@gmail.com</option><option value='7154'>senthilkumarbabu@hotmail.com</option><option value='7147'>soumya.kash@gmail.com</option><option value='7149'>rbalu1960@gmail.com</option><option value='7243'>soundram63@gmail.com</option><option value='7151'>ms.ananthan@gmail.com</option><option value='6974'>iamvivekanands@gmail.com</option><option value='169'>teju_1@istarindia.com</option><option value='7208'>caanmolagrawal@gmail.com</option><option value='7227'>senthilkumar.rajappan@gmail.com</option><option value='408'>henna.khemani@gmail.com</option><option value='7156'>pranavmilan99@gmail.com</option><option value='7223'>sandeep_dbest@yahoo.co.in</option><option value='7229'>abby42.va@gmail.com</option><option value='7239'>alakshmanan75@gmail.com</option><option value='7241'>krajeev1976@gmail.com</option><option value='174'>archana_1@istarindia.com</option><option value='4741'>rameshk@istarindia.com</option><option value='7438'>tijovarghese3@gmail.com</option><option value='7728'>stutivadalia@gmail.com</option><option value='7513'>mpsrinivas28@gmail.com</option><option value='7585'>roshni23@gmail.com</option><option value='7574'>Vigneshwaranvishal@gmail.com</option><option value='7440'>munirajuharsha@hotmail.com</option><option value='7452'>hemika88@gmail.com</option><option value='7458'>jadhavpoonam1712@gmail.com</option><option value='7467'>Josh7win@gmail.com</option><option value='7469'>badimaladileepkumar@gmail.com</option><option value='7493'>sekarsdream@gmail.com</option><option value='7442'>vijayright05@gmail.com</option><option value='7444'>sha_ba2016@yahoo.com</option><option value='7446'>palashconsultancy@gmail.com</option><option value='7502'>ramadurairaghunathan@gmail.com</option><option value='7465'>anusha_vikram@yahoo.com</option><option value='7488'>savankeshriya@gmail.com</option><option value='7450'>mohanramu19@gmail.com</option><option value='7491'>sudhi4321@gmail.com</option><option value='7454'>reply2hemanth@gmail.com</option><option value='5236'>mamathajobmail2016@gmail.com</option><option value='7498'>suriyamba@live.com</option><option value='7567'>ravinder.gupta@federalmogul.com</option><option value='7462'>miriamphilip@gmail.com</option><option value='3814'>paul@istarindia.com</option><option value='7448'>geethage.rce@gmail.com</option><option value='7456'>sheelamxavier@gmail.com</option><option value='7460'>ashutoshkar11@gmail.com</option><option value='7495'>sridevi_17@yahoo.com</option><option value='7500'>cricvenky2298@gmail.com</option><option value='7572'>janu200292@gmail.com</option><option value='1779'>maureenjs55@gmail.com</option><option value='7478'>preeti.padmanaban@gmail.com</option><option value='7577'>mambu_patrick@yahoo.fr</option><option value='7579'>hariharans337@gmail.Com</option><option value='7664'>cacskrithika@gmail.com</option><option value='4881'>kotresh@istarindia.com</option><option value='7583'>hasini1981@rediffmail.com</option><option value='402'>shyam@istarindia.com</option><option value='7666'>av7ganesan@gmail.com</option><option value='7581'>raziyas221998@gmail.com</option><option value='7740'>new1@istar.com</option><option value='7738'>vinay_24july@istarindia.com</option><option value='449'>vinay_sales@istarindia.com</option><option value='17464'>it_trainer@istarindia.com</option><option value='17466'>it2@istarindia.com</option><option value='17468'>it3@istarindia.com</option>

					</select>
			</div>
			<div class="form-group">
				<label>Choose Section</label> <select
					class="form-control m-b batchGroupID" name="">
					<option value="">Select Section...</option>
					

				</select>
			</div>
			<div class="form-group">
				<label>Select Course</label> <select
					class="form-control m-b courseID" name="batchID">
					<option value="">Select Course...</option>
					<option value=''> Select Course...</option>

				</select>
			</div>
			<div class="form-group">
				<label>Select Event Type</label> <select
					class="form-control m-b eventType" name="eventType">
					<option value="session">Session</option>
					<option value="webinar">Webinar (TOT)</option>
					<option value="remote_class">Remote Class</option>
			</select>
			</div>
			<!-- <div class="assessment_list" id="assessment_list"
				style="display: none;">
				<div class="form-group">
					<label>Select Assessment</label> <select
						class="form-control m-b assessment" name="assessmentID">
						<option value="">Select Assessment</option>

					</select>
				</div>
			</div> -->

			<div class="form-group">
				<label>Select Class-Room</label> <select class="form-control m-b"
					name="classroomID">
					<option value="">Select Classroom...</option>
					

				</select>
			</div>
			<!-- <div class="form-group" id="data_2">
				<label class="font-bold">Start Event Date</label>
				<div class="input-group date">
					<span class="input-group-addon"><i class="fa fa-calendar"></i></span><input
						type="text" name="startEventDate" class="form-control date_holder"
						value="03/03/2017">
				</div>
				<label class="font-bold">End Event Date</label>
				<div class="input-group date">
					<span class="input-group-addon"><i class="fa fa-calendar"></i></span><input
						type="text" name="endEventDate" class="form-control date_holder"
						value="03/03/2017">
				</div>
			</div> -->
			 <div class="form-group" id="data_5">
                                <label class="font-bold">Event Date Range</label>
                                <div class="input-daterange input-group" id="datepicker">
                                    <input type="text" class="input-sm form-control date_holder"  name="startEventDate" value="31/03/2017"/>
                                    <span class="input-group-addon">to</span>
                                    <input type="text" class="input-sm form-control date_holder"name="endEventDate" value="01/04/2017" />
                                </div>
                            </div>

			<div class="form-group">
				<label class="font-bold">Event Time</label>
				<div class="input-group" data-autoclose="true">
					 <span class="input-group-addon"> <span
						class="fa fa-clock-o"></span>
					</span><!-- <input type="text" style="width: 100%; height: 28px;" name="startTime" class="timepicker"/> -->
					<input type="text" style="width: 100%; height: 28px;" name="startTime" class="time_element"/>
				</div> 
				<!-- <div class="input-group clockpicker" data-autoclose="true">
					<input type="text" class="form-control time_holder" name="startTime"
						value="09:30"> <span class="input-group-addon"> <span
						class="fa fa-clock-o"></span>
					</span>
				</div> -->

			</div>
			<div class="form-group form-inline">
				<label class="font-bold">Duration</label> <label class="sr-only">Hours</label>
				<input type="number" value="1" name="hours" placeholder="Hours"
					class="form-control duration_holder"> <label class="sr-only">minute</label>
				<input type="number" value="0" name="minute" placeholder="Minute"
					class="form-control duration_holder">
			</div>

			<div class="form-group">

				<label>Select Day</label> <select
					class="form-control m-b eventType" name="day">
					<option value="1">Monday</option>
					<option value="2">Tuesday</option>
					<option value="3">Wednesday</option>
					<option value="4">Thursday</option>
					<option value="5">Friday</option>
					<option value="6">Saturday</option>
					<option value="7">Sunday</option>


				</select>

			</div>
			<button class="btn btn-danger form-submit-btn custom-theme-btn-primary" data-form="idForm3"
				type="button">Save changes</button>
		</form>

	</div>

										</div>
									</div>


									</div>


								</div>
								<div class="col-lg-9 no-padding bg-muted">
									<div class="ibox no-padding no-margins bg-muted p-xs" style="padding-top: 5px;">
										<div class='ibox-header'><h4 style='line-height: 25px;margin-left:12px'>	<span style='background-color:#C0392B' class='label label-primary '>NOT_PUBLISHED</span>	<span style='background-color:#0091ea' class='label label-primary '>ASSESSMENT</span> 			<span style='background-color:#A9CCE3' class='label label-primary'>SCHEDULED</span> 			<span style='background-color:#083761' class='label label-primary'>STARTED</span> 			<span style='background-color:#58D68D' class='label label-primary'>TEACHING</span> 			<span style='background-color:#F7DC6F' class='label label-primary'>ATTENDANCE</span> 			<span style='background-color:#DC7633' class='label label-primary'>FEEDBACK</span> 			<span style='background-color:#626567' class='label label-primary'>COMPLETED</span> 			<span style='background-color:#FF00FF' class='label label-primary'>REACHED</span></h4> 	</div>
										<div class="ibox-content">
											
											<div id='dashoboard_cal' class='p-xs b-r-lg border-left-right border-top-bottom border-size-sm orgadmin_calendar' data-url='/get_events_controller?'></div> 
										</div>
									</div>
								</div>

								<!-- Events details modal -->
								<div class="modal inmodal fade" id="myModal5" tabindex="-1"
									role="dialog" aria-hidden="true">
									<input id="orgID" type="hidden" value="0" />
									<div class="modal-dialog modal-lg">
										<div class="modal-content">
											<div class="panel panel-primary custom-theme-panel-primary" style="margin-bottom: 0px;">
                                        <div class="panel-heading custom-theme-panal-color">
												<button type="button" class="close" data-dismiss="modal">
													<span aria-hidden="true">&times;</span><span
														class="sr-only">Close</span>
												</button>
												<h4 class="modal-title text-center">Events Details</h4>
												<h4 class="text-danger modal-subTitle"></h4>
											</div>
											<div class="modal-body">
												<div class="row" id="modal_data"></div>
											</div>

											<div class="modal-footer">
												<h4 class="text-danger modal-subTitle pull-left"></h4>
												<button type="button" class="btn btn-danger"
													data-dismiss="modal">Close</button>
												<button type="button" id="final_submit_btn"
													data-dismiss="modal"
													class="btn btn-primary final-submit-btn custom-theme-btn-primary">Save
													changes</button>
											</div></div>
										</div>
									</div>
								</div>

								<!--  -->

								<!-- modal -->

								<div class="modal inmodal" id="myModal2" tabindex="-1"
									role="dialog" aria-hidden="true">
									
									<div class="modal-dialog">
										<div class="modal-content animated flipInY event-edit-modal">

										</div>
									</div>
								</div>
								<!--  -->
<!-- event details modal -->

								<div class="modal inmodal" id="event_details" tabindex="-1"
									role="dialog" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content animated flipInY event_details">

										</div>
									</div>
								</div>


		<!--  -->

							</div>

						</div>


					</div>
                                </div>
                            </div>
                            <div id="tab-a" class="tab-pane">
                                <div class="panel-body">
                                   








<div class="row">
	<div class="col-lg-12">
		<div class="col-lg-12">
			<div class="ibox">
				<div class="ibox-content">
					<div id="wizard">
						<h1>Select Organization</h1>
						<div class="step-content" style="position: relative !important;">
							<div class="row">
								<div class="col-lg-3">
									<div class="form-group ">
										<label>Select Organization*</label> <select class="select2_demo_1 form-control"										
										id="org_selector">
											<option value="null">Select Organization</option>
											
												<option value="4">MES teachers College</option>
												
												<option value="5">BVP College</option>
												
												<option value="6">PSGR Krishnammal College for Women			</option>
												
												<option value="7">Dr NGP Arts &amp; Science College.</option>
												
												<option value="8">St. Joseph college of commerce.</option>
												
												<option value="67">Som-Lalit institute of Management Studies</option>
												
												<option value="68"> Adarsha Institute of Technology</option>
												
												<option value="69">Guru Nanak Institute of Management</option>
												
												<option value="70">HR Institute of technology</option>
												
												<option value="71">Delhi Institute of Advanced Studies</option>
												
												<option value="72">Indira College of Commerce</option>
												
												<option value="73">BVP Engineering</option>
												
												<option value="74">Methodist Engineering College</option>
												
												<option value="75">TKR College of Engineering and Technology</option>
												
												<option value="76">Menarini Asia Pacific</option>
												
												<option value="78">Ajuba</option>
												
												<option value="79">Allianz</option>
												
												<option value="80">Amnet Systems</option>
												
												<option value="81">Aspire Systems</option>
												
												<option value="82">Bmc Software</option>
												
												<option value="83">Capgemini</option>
												
												<option value="84">Charter Global</option>
												
												<option value="85">Clover Infotech</option>
												
												<option value="86">CME Group</option>
												
												<option value="123">HP</option>
												
												<option value="124">Vizag_DDU-GKY </option>
												
												<option value="2">ISTAR</option>
												
												<option value="3">East Point College</option>
												
												<option value="87">Crayon</option>
												
												<option value="88">Cyber Infrastructure</option>
												
												<option value="89">Espire</option>
												
												<option value="90">Geometric</option>
												
												<option value="92">Harman Connected Sevices</option>
												
												<option value="93">Headstrong</option>
												
												<option value="94">Hinduja Global Solutions</option>
												
												<option value="95">iFocus Systec</option>
												
												<option value="96">Impetus</option>
												
												<option value="97">Infogain</option>
												
												<option value="98">Infosys</option>
												
												<option value="99">Invenio Business Solutions</option>
												
												<option value="100">Iron Mountain</option>
												
												<option value="101">Mindteck</option>
												
												<option value="102">Nasdaq</option>
												
												<option value="103">Ocwen Financial Services</option>
												
												<option value="104">Opteamix</option>
												
												<option value="105">People Tech Group</option>
												
												<option value="106">Polaris</option>
												
												<option value="107">PWC</option>
												
												<option value="108">Q3 Technologies</option>
												
												<option value="109">Sopra Steria</option>
												
												<option value="110">SourceHOV</option>
												
												<option value="111">Syntel</option>
												
												<option value="112">T-Systems</option>
												
												<option value="113">Tata Consultancy Services</option>
												
												<option value="114">Teradata</option>
												
												<option value="115">Valtech</option>
												
												<option value="116">Value Labs</option>
												
												<option value="117">Williams Lea</option>
												
												<option value="118">Wipro</option>
												
												<option value="119">WNS Global Services</option>
												
												<option value="120">Yash Technologies</option>
												
												<option value="121">Zen3 Infosolutions India Ltd</option>
												
												<option value="122">Zensar Technologies</option>
												
												<option value="126">3i Infotech</option>
												
												<option value="127">Morgan Stanley</option>
												
												<option value="128">Mutual Mobile</option>
												
												<option value="129">Infoshore</option>
												
												<option value="130">Mc Fadyen Solutions</option>
												
												<option value="137">BAE Systems</option>
												
												<option value="131">AGC Networks Ltd</option>
												
												<option value="132">Solution Hawk</option>
												
												<option value="133">Aztec Software</option>
												
												<option value="134">Metlife</option>
												
												<option value="135">Experian</option>
												
												<option value="136">Intel</option>
												
												<option value="138">Fiserv</option>
												
												<option value="139">Honeywell</option>
												
												<option value="140">Northrop Grumman</option>
												
												<option value="141">Raytheon Websense</option>
												
												<option value="142">Serco</option>
												
												<option value="143">Unisys</option>
												
												<option value="158">Code Brew Labs</option>
												
												<option value="144">Lauruss Infotech</option>
												
												<option value="145">Peerbits</option>
												
												<option value="146">Telecom Network Solutions</option>
												
												<option value="147">Ciber</option>
												
												<option value="148">Hyperlink Infosystems</option>
												
												<option value="149">Tata ELXSI Ltd</option>
												
												<option value="150">Acer </option>
												
												<option value="151">Experion</option>
												
												<option value="152">Syon Infomedia pvt ltd</option>
												
												<option value="153">Accel frontline ltd</option>
												
												<option value="154">Cadence Design Systems</option>
												
												<option value="155">Intellect Design Arena</option>
												
												<option value="156">Debut infotech</option>
												
												<option value="157">Savex Technologies</option>
												
												<option value="159">Variance Infotech</option>
												
												<option value="160">Trigyn Technologies </option>
												
												<option value="161">Great-West Financial Services</option>
												
												<option value="162">Zoondia Pvt Ltd</option>
												
												<option value="163">Evince Development Pvt. Ltd. </option>
												
												<option value="164">Terasol Technologies</option>
												
												<option value="165">Accenture </option>
												
												<option value="166">Aditi Consulting</option>
												
												<option value="167">Adobe</option>
												
												<option value="168">Amazon</option>
												
												<option value="169">Apple</option>
												
												<option value="170">Appster</option>
												
												<option value="178">Cognizant</option>
												
												<option value="171">Atos consulting  &amp; Technology Services</option>
												
												<option value="172">ADP India Pvt Ltd</option>
												
												<option value="173">Intex</option>
												
												<option value="174">Brillio</option>
												
												<option value="175">CA Technologies</option>
												
												<option value="176">Canon</option>
												
												<option value="177">Cisco</option>
												
												<option value="179">Convergys</option>
												
												<option value="180">Credit Suisse</option>
												
												<option value="181">CSC</option>
												
												<option value="182">Cyient</option>
												
												<option value="183">Dell</option>
												
												<option value="190">Technource</option>
												
												<option value="184">D-Link</option>
												
												<option value="185">Huawei Technologies</option>
												
												<option value="186">Fidelity Investments</option>
												
												<option value="187">First Data</option>
												
												<option value="188">Google</option>
												
												<option value="189">Torry Harris Business Solutions</option>
												
												<option value="191">Goldman Sachs</option>
												
												<option value="192">Deloitte</option>
												
												<option value="193">Hitachi Data Systems</option>
												
												<option value="194">Citi Group</option>
												
												<option value="195">Synapse</option>
												
												<option value="196">Vinsol</option>
												
												<option value="197">Contus</option>
												
												<option value="198">Andola Soft</option>
												
												<option value="199">Metaoption</option>
												
												<option value="200">Infinite computer solutions</option>
												
												<option value="201">Ingram micro</option>
												
												<option value="202">IBM</option>
												
												<option value="203">Intuit</option>
												
												<option value="204">ISHIR</option>
												
												<option value="205">ITC Infotech</option>
												
												<option value="206">Kellton Tech</option>
												
												<option value="207">KPIT</option>
												
												<option value="208">Lenovo</option>
												
												<option value="209">LG Soft India Pvt Ltd</option>
												
												<option value="210">Prismetric Technologies</option>
												
												<option value="211">kotak</option>
												
												<option value="212">Xerox</option>
												
												<option value="213">ADCC Infocad limited</option>
												
												<option value="214">Replicon</option>
												
												<option value="215">Fujitsu</option>
												
												<option value="216">Mastek</option>
												
												<option value="217">Mastercard</option>
												
												<option value="218">McKinsey and Company</option>
												
												<option value="219">SIFY Technologies Limited</option>
												
												<option value="220">Microsoft</option>
												
												<option value="221">Mobikasa</option>
												
												<option value="222">Mphasis</option>
												
												<option value="223">NCR</option>
												
												<option value="224">NET Solutions</option>
												
												<option value="225">Nokia</option>
												
												<option value="226">NTT Data</option>
												
												<option value="227">Nucleus Software</option>
												
												<option value="228">Oracle</option>
												
												<option value="229">RR Donnelley</option>
												
												<option value="230">Saksoft</option>
												
												<option value="231">Samsung Electronics</option>
												
												<option value="232">CSS CORP</option>
												
												<option value="233">Synchrony Financial</option>
												
												<option value="234">Sierra Cedar</option>
												
												<option value="235">Bajaj Capital Services</option>
												
												<option value="236">Sonata Software</option>
												
												<option value="237">Sourcebits</option>
												
												<option value="238">SQS</option>
												
												<option value="239">Subex</option>
												
												<option value="240">Sutherland Global Services</option>
												
												<option value="241">Symantec</option>
												
												<option value="242">Tata Technologies</option>
												
												<option value="243">Tech Mahindra</option>
												
												<option value="244">Texas Instruments</option>
												
												<option value="245">TIBCO Software Inc</option>
												
												<option value="246">TATA Interactive Systems</option>
												
												<option value="247">Celetronix Power India Pvt Ltd</option>
												
												<option value="248">TVS Electronics</option>
												
												<option value="249">Vmware</option>
												
												<option value="250">Xilinx</option>
												
												<option value="251">Yudiz Solutions Pvt Ltd</option>
												
												<option value="252">Zenith Software LTD</option>
												
												<option value="253">Zensar Technologies</option>
												
												<option value="254">Zetagile Infosolutions Pvt Ltd</option>
												
												<option value="255">OSS Cube</option>
												
												<option value="256">Velocity Software</option>
												
												<option value="257">HeadHonchos.com</option>
												
												<option value="258">Dhanwate National College</option>
												
												<option value="261">Reva Institute of Technology and Management</option>
												
												<option value="262">Rathinam College of Arts and Science</option>
												
												<option value="263">Alpha Arts &amp; Science College	</option>
												
												<option value="264">ABC Bank Ltd</option>
												
												<option value="265">abc</option>
												
												<option value="266">Meenakshi Academy of Higher Education and Research</option>
												
												<option value="267">St. Britto&#146;s Academy</option>
												
												<option value="268">Parul University</option>
												
												<option value="269">Janalakshmi Financial Services</option>
												
												<option value="270">mes institute of management</option>
												
												<option value="259">Warangal_DDUGKY</option>
												
												<option value="260">Marwadi University		</option>
												
												<option value="271">Rajagiri College of Social Sciences </option>
												
												<option value="273">Retail</option>
												
												<option value="272">Istar IT Services Pvt Limited</option>
												
										</select>
									</div>
								</div>								
							</div>
						</div>
						<h1>Select Entity Type</h1>
						<div class="step-content" style="position: relative !important;">
							<div class="row">
								<div class="col-lg-3">
									<div class="form-group ">
										<label>Select Entity Type*</label> <select class="select2_demo_1 form-control" 
										data-college_id="" 
										data-user_report_id="3057" 
										data-section_report_id="3058" 
										data-role_report_id="3059" 
										data-course_report_id_for_user="3060"
										data-course_report_id_for_section="3061"
										data-course_report_id_for_role="3062"
										id="entity_type_selector" style="display:none">
											<option value="null">Select Entity Type</option>
											<option value="USER">User</option>
											<option value="SECTION">Section</option>
											<option value="ROLE">Role</option>
										</select>
									</div>
								</div>
								<div class="col-lg-12">										
									<div id="entity_list_holder" style="display:none">
																											
									</div>									
								</div>
							</div>
						</div>

						<h1>Select Course</h1>
						<div class="step-content" style="position: relative !important;">
							<div class="text-center m-t-md">
								<div class="row">
									<div class="col-lg-12">										
									<div id="entity_course_holder" style="display:none">
																											
									</div>									
								</div>
								</div>

							</div>
						</div>
						<h1>Edit Course</h1>
						<div class="step-content" style="position: relative !important;">
							<div class="row m-b-lg m-t-lg">
								<div class="col-lg-4">
									<div id="auto_scheduler_edit_course">
									
									</div>
								</div>
								
							</div>
						</div>
					</div>

				</div>
			</div>
		</div>

	</div>
	</div>
                                    </div>
                            </div>
                        </div>


                    </div>
				</div>
			</div>
		</div>
	</div>


	<!-- Mainly scripts -->
	





<script src="http://localhost:8080/assets/js/plugins/fullcalendar/moment.min.js"></script>

<script src="http://localhost:8080/assets/js/jquery-2.1.1.js"></script>



<script src="http://localhost:8080/assets/js/bootstrap.min.js"></script>
<script src="http://localhost:8080/assets/js/plugins/metisMenu/jquery.metisMenu.js"></script>
<script
	src="http://localhost:8080/assets/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>

<!-- Custom and plugin javascript -->
<script src="http://localhost:8080/assets/js/inspinia.js"></script>
<script src="http://localhost:8080/assets/js/plugins/pace/pace.min.js"></script>

<!-- Flot -->
<script src="http://localhost:8080/assets/js/plugins/flot/jquery.flot.js"></script>
<script src="http://localhost:8080/assets/js/plugins/flot/jquery.flot.tooltip.min.js"></script>
<script src="http://localhost:8080/assets/js/plugins/flot/jquery.flot.resize.js"></script>
<!-- dataTables -->
<script src="http://localhost:8080/assets/js/plugins/dataTables/datatables.min.js"></script>
<script type="text/javascript" src="http://localhost:8080/assets/js/jquery.bootpag.js"></script>


<!-- Data picker -->
<script
	src="http://localhost:8080/assets/js/plugins/datapicker/bootstrap-datepicker.js"></script>

<!-- Clock picker -->
<script src="http://localhost:8080/assets/js/plugins/clockpicker/clockpicker.js"></script>

<!-- Full Calendar -->
<script src="http://localhost:8080/assets/js/plugins/fullcalendar/fullcalendar.min.js"></script>
<!-- Toastr script -->
<script src="http://localhost:8080/assets/js/plugins/toastr/toastr.min.js"></script>

<script type="text/javascript" src="http://localhost:8080/assets/js/wickedpicker.js"></script>

<!-- Jquery Validate -->
<script src="http://localhost:8080/assets/js/plugins/validate/jquery.validate.min.js"></script>
<script
	src="https://swisnl.github.io/jQuery-contextMenu/dist/jquery.contextMenu.js"
	type="text/javascript"></script>
 <script type="text/javascript" src="http://localhost:8080/assets/js/timepicki.js"></script>
 
   <!-- Tags Input -->
    <script src="http://localhost:8080/assets/js/plugins/bootstrap-tagsinput/bootstrap-tagsinput.js"></script>

<!-- highcharts -->


<script src="http://localhost:8080/assets/js/plugins/chosen/chosen.jquery.js"></script>
<script src="http://localhost:8080/assets/js/plugins/select2/select2.full.min.js"></script>

<script src="http://localhost:8080/assets/js/jquery.rateyo.min.js"></script>

<!-- 	<script src="https://code.highcharts.com/modules/data.js"></script>
 -->
 <script src="http://localhost:8080/assets/js//jquery.equalheights.js"></script>
<script src="http://localhost:8080/assets/js/plugins/sweetalert/sweetalert.min.js"></script>
<script src="http://localhost:8080/assets/js/plugins/highchart/highcharts.js"></script>
<script src="http://localhost:8080/assets/js/plugins/highchart/no-data-to-display.js"></script>
<script src="http://localhost:8080/assets/js/plugins/highchart/data.js"></script>
<script src="http://localhost:8080/assets/js/plugins/highchart/exporting.js"></script>
<script src="http://localhost:8080/assets/js/plugins/highchart/drilldown.js"></script>
<script src="http://localhost:8080/assets/js/reconnecting-websocket.min.js"></script>
<script src="http://localhost:8080/assets/js/websocket.js"></script>
<script src="http://localhost:8080/assets/js/plugins/steps/jquery.steps.min.js"></script>
<script src="http://localhost:8080/assets/js/plugins/daterangepicker/daterangepicker.js"></script>
<script src="http://localhost:8080/assets/js/plugins/iCheck/icheck.min.js"></script>
<script src="http://localhost:8080/assets/js/circular-custom-plugin.js"></script>
<script src="http://localhost:8080/assets/js/isotope.pkgd.js"></script>
<script src="http://localhost:8080/assets/js/jquery.flip.min.js"></script>
<script src="http://localhost:8080/assets/js/plugins/ionRangeSlider/ion.rangeSlider.min.js"></script>
<script src="http://localhost:8080/assets/js/app.js"></script>

<script>
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
	  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
	  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
	  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

ga('create', 'UA-103015121-1', 'auto', {
	  userId: '17_300'
	});
ga('send', 'pageview');


</script>

	<script>
		$(document).ready(function() {
		
			

						}); 
	</script>
</body>

</html>
