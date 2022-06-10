<!--- 

    v4 -- transition from cfinclude to cfc

--->

<cfinclude template="_header.cfm">

<cfobject name="peopleService" component="PeopleService" />
<cfset user = peopleService.getUser(cookie.userId)>
<cfset person = peopleService.getPeople(url.peopleId)>
<cfset statusTags = peopleService.getStatusTags(url.peopleId)>
<cfset descriptiveTags = peopleService.getDescriptiveTags(url.peopleId)>
<cfset profileIcon = peopleService.setProfileIcon(person.PhotoURL, statusTags.PeopleTag, statusTags)>
<cfset profileName = peopleService.setProfileName(person.FirstName, person.LastName)> 

<cfoutput>

<body class="has-bg-image navbar-bottom">

    <cfinclude template="_nav.cfm">
    <cfinclude template="people_map.cfm">

	<div style=" margin-top: -20px; margin-bottom: -40px;">
        <div class="gradient-overlay" style="">
            <div class="media text-center">
                <div class="media">
                    #profileIcon#
                </div>
                <div class="media-body">
                    <h4 class="media-heading mt-10">
                        #profileName#
                    </h4>

                    <!---- Get System Tags----->
                    <div class="text-center mt-10"> 
                        <span class="label label-success border-success-300 text-success-600 label-rounded label-flat" style="font-size:12px;">
                            STATUS: #statusTags.PeopleTag#
                        </span> 
                        <span class="label label-success border-success-300 text-success-600 label-rounded label-flat" style="font-size:12px;">
                            <cfif len(descriptiveTags.Alias)>
                                #descriptiveTags.Alias#
                            <cfelse>
                                #statusTags.PeopleTag#
                            </cfif>
                        </span> 
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

    <cfset peopleService.trackPeopleViews()>

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