<!--- 

    v2 - a fix to formatting, security issues, and general code cleanup.
    
    formatting  - functions, tags, and variables that were capitalized were changed to lower case or camel case.
                - indentation was made uniform.
                - spacing was made uniform.
                - commented out older code was removed.

    security    - cfqueryparams added to all cfqueries
                    - I remembered that a lot of data is stored as varchar in the database. If so, swap cf_sql_integer for varchar.
                    - I can't look at the datatypes, as I don't have access to the database any longer.

    cleanup     - consolidated the <cfoutput></cfoutput> tags.
                    - each <cfoutput></cfoutput> is a function call to the server, so having multiple on a page slows the performance.
                    - the <cfoutput query="{query}"> tags are throwing this off a bit.
                - moved queries to a separate file.
                - moved debug to separate file.

    other       - line 159 seems like a deprecated feature, and I would consider removal if I could go look at it. v4 was ages ago.
                - I would also go through the queries and change select * to specific columns queried. This would make the page faster to load.

--->

<!---- TABLE----->

<cfinclude template="_header.cfm">

<!---- VARIABLES ---->

<cfparam name="PEOPLEID" default="0">

<!-------- SQL QUERIES ---------->

<cfinclude template="admin_people_detail_queries.cfm">

<cfoutput>

<body class="has-bg-image navbar-bottom">

    <cfinclude template="_nav.cfm">
    <cfinclude template="people_map.cfm">

	<div style=" margin-top: -20px; margin-bottom: -40px;">
        <div class="gradient-overlay" style="">
            <div class="media text-center">
                <div class="media">
                    <cfif len(getPeople.PhotoURL)>
                        <img src="#getPeople.PhotoURL#" class="img-circle img-lg" alt="">
                    <cfelse>
						<cfif getStatusTags.RecordCount>
							<cfif getStatusTags.PeopleTag EQ 'Win'> 
								<i class="icon-piggy-bank text-primary" style="font-size:50px;"></i> 
							<cfelseif getStatusTags.PeopleTag EQ 'Hot'>
								<i class="icon-fire text-danger" style="font-size:50px;"></i>  
							<cfelseif getStatusTags.PeopleTag EQ 'Verified'>
								<i class="icon-shield-check text-primary" style="font-size:50px;"></i>
						    <cfelse> 
								<i class="icon-user text-primary" style="font-size:50px;"></i>
							</cfif>
						<cfelse>
							<i class="icon-user text-primary" style="font-size:50px;"></i>
						</cfif> 
                    </cfif>
                </div>
                <div class="media-body">
                    <h4 class="media-heading mt-10">
                        #reReplace(lcase(getPeople.FirstName),"(^[a-z])","\U\1","ALL")# #reReplace(lcase(getPeople.LastName),"(^[a-z])","\U\1","ALL")# 
                    </h4>

                    <!---- Get System Tags----->
                    <div class="text-center mt-10"> 
</cfoutput>
                        <cfoutput query="getStatusTags"> 
                            <span class="label label-success border-success-300 text-success-600 label-rounded label-flat" style="font-size:12px;">
                                STATUS: #PeopleTag#
                            </span> 
                        </cfoutput>
                        <cfoutput query="getDescriptiveTags"> 
                            <span class="label label-success border-success-300 text-success-600 label-rounded label-flat" style="font-size:12px;">
                                <cfif len(Alias)>
                                    #Alias#
                                <cfelse>
                                    #PeopleTag#
                                </cfif>
                            </span> 
                        </cfoutput>
<cfoutput>     
                    </div>
                </div>
            </div>
       </div>
       
    <!-- Page container -->
    <div class="page-container"> 
        
        <!-- Page content -->
        <div class="page-content"> 
            
            <!-- Main sidebar -->
            <div class="content-wrapper"> 
            
                <div class="row"> 
                    <!----- MIDDLE COLUMN-------->
                    <div class="col-lg-3">   
                        <!--  tabs widget -->
                        <div class="tab-content-bordered content-group"> 
                            <ul class="nav nav-tabs nav-tabs-highlight nav-lg nav-justified"> 
                                <li class="active">
                                    <a href="##tab-overview" data-toggle="tab">Overview</a>
                                </li>  
                                <li>
                                    <a href="##tab-stats" data-toggle="tab">Stats</a>
                                </li> 
                            </ul>

                            <div class="tab-content"> 
                                <div class="tab-pane active" id="tab-overview"> 
                                    <cfinclude template="people_detail_tab_overview.cfm">
                                </div>  
                                <div class="tab-pane" id="tab-stats">
                                    <cfinclude template="admin_people_stats.cfm">  
                                </div> 
                            </div> 
                        
                            <cfinclude template="admin_people_user_coach.cfm">
                            <cfinclude template="people_detail_tags_v6.cfm">
                            <cfinclude template="people_detail_append.cfm">                                 
                        
                        </div>                                    
                    </div>
                    <!----- MIDDLE COLUMN-------->
                    <div class="col-lg-6">

                        <div class="row mb-10">   
                            <cfinclude template="admin_people_detail_launchcampaign.cfm">
                        </div>
                        
                        <div class="tab-content content-group"> 
                            <ul class="nav nav-tabs nav-tabs-highlight nav-lg nav-justified"> 
                                <li class="active">
                                    <a href="##tab-notes" data-toggle="tab">Notes</a>
                                </li>  
                                <li>
                                    <a href="##tab-tickets" data-toggle="tab">Tickets</a>
                                </li> 
                                <li>
                                    <a href="##tab-log" data-toggle="tab">Log</a>
                                </li> 
                            </ul>

                            <div class="tab-content"> 
                                <div class="tab-pane active" id="tab-notes"> 
                                    
                                    <cfinclude template="admin_people_detail_notes.cfm">
                                    <cfinclude template="people_detail_notes.cfm">
                                    <cfinclude template="admin_people_detail_timeline.cfm">
                                    <!---- Notes from v4---->
                                    <cfinclude template="admin_people_detail_timeline_legacy.cfm"> 	

                                </div>  
                                <div class="tab-pane" id="tab-tickets">

                                    <cfinclude template="admin_people_detail_tickets.cfm"> 

                                </div>
                                
                                <div class="tab-pane" id="tab-log"> 
                                    
                                    <cfinclude template="admin_people_log.cfm"> 
                                    
                                </div> 
                            </div> 
                        </div> 
                    </div>
                    <!------ RIGHT COLUMN--------->
                    <div class="col-lg-3">  
                    
                        <cfinclude template="admin_people_user_abz.cfm">
                        <cfinclude template="admin_people_user_abz_aa.cfm">
                        <cfinclude template="admin_people_user_settings.cfm">                        
                        <cfinclude template="admin_people_user_licenses.cfm">    
                        <cfinclude template="admin_people_user_facebook.cfm">
                            
                    </div>
                </div>
            </div>
        </div>
    </div>

    <cfif isDefined("Debug")>
        <cfinclude template="admin_people_debug.cfm">
    </cfif>

<!----------------------------------->
<!------------- ////// -------------->
<!----------------------------------->

<div class="modal fade" id="model_refresh_profile" tabindex="-1" role="dialog" aria-labelledby="model_refresh_profile" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-body"> <i>Loading...</i> </div>
        </div>
    </div>
</div>

<div class="modal fade" id="model_baddata_profile" tabindex="-1" role="dialog" aria-labelledby="model_baddata_profile" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-body"> <i>Loading...</i> </div>
        </div>
    </div>
</div>

<div class="modal fade" id="model_archive_profile" tabindex="-1" role="dialog" aria-labelledby="model_archive_profile" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-body"> <i>Loading...</i> </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modal_site_create" tabindex="-1" role="dialog" aria-labelledby="modal_site_create" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-body"> <i>Loading...</i> </div>
        </div>
    </div>
</div>

<div class="modal fade" id="model_update_profile" tabindex="-1" role="dialog" aria-labelledby="model_update_profile" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-body"> <i>Loading...</i> </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modal_update_user" tabindex="-1" role="dialog" aria-labelledby="modal_update_user" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-body"> <i>Loading...</i> </div>
        </div>
    </div>
</div>

<cfinclude template="_footer.cfm">

</cfoutput>