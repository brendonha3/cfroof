<!---

    Besides this comment, this is the original and unedited file.

--->
<!---- TABLE----->
<cfinclude template="_header.cfm">

<!---- VARIABLES ---->

<CFPARAM name="PEOPLEID" default="0">

<!-------- SQL QUERIES ---------->

<cfquery name="getUser" datasource="#dsn#">
	SELECT * FROM Users WHERE userID = #cookie.userID#
</cfquery>
<cfquery name="getPeople" datasource="#dsn#">
	SELECT * FROM People WHERE PeopleID = #PeopleID#
</cfquery>

<CFIF ISNUMERIC(getPeople.LinkUserID)>
 
<cfquery name="getPeopleUser" datasource="#dsn#">
	SELECT * FROM Users WHERE UserID = #getPeople.LinkUserID#
</cfquery>

<CFELSE>
<CFOUTPUT>
People Not Found. <a href="people_detail.cfm?PeopleID=#PeopleID#">Try here</a>.<CFABORT>
</CFOUTPUT>
</CFIF>
 
 
<CFIF ISNUMERIC(getPeopleUser.RegionalDirectorID)>
<cfquery name="getRep" datasource="#dsn#">
	SELECT * FROM Users WHERE userID = #getPeopleUser.RegionalDirectorID#
</cfquery>
</CFIF>
 
 


<cfquery name="getStatusTags" datasource="#dsn#" maxrows="1">
	SELECT * FROM PeopleTag,PeopleTagMap WHERE 
    PeopleTag.PeopleTagID = PeopleTagMap.PeopleTagID AND
    PeopleTag.PeopleTagTypeID = 2 
    AND PeopleTagMap.DateExpired IS NULL
    AND PeopleTagMap.PeopleID = #PeopleID#
    AND (PeopleTagMap.DateDeleted is NULL)
	ORDER BY PeopleTagMap.DateStamp DESC
</cfquery>
 



<cfquery name="getDescriptiveTags" datasource="#dsn#">
	SELECT * FROM PeopleTag,PeopleTagMap WHERE 
    PeopleTag.PeopleTagID = PeopleTagMap.PeopleTagID AND
    PeopleTag.PeopleTagTypeID = 1 AND
	PeopleTagMap.PeopleID = #PeopleID# AND
    PeopleTagMap.DateExpired IS NULL  
    AND PeopleTag NOT IN ('Lookup Lead','Verified Lead','Smart Lead')
    AND (PeopleTagMap.DateDeleted is NULL)
	ORDER BY PeopleTag.IsSystem,PeopleTag.PeopleTagID
</cfquery>


<cfquery name="getDescriptiveTagsSystemOnly" datasource="#dsn#">
	SELECT * FROM PeopleTag,PeopleTagMap WHERE 
    PeopleTag.PeopleTagID = PeopleTagMap.PeopleTagID AND
    PeopleTag.PeopleTagTypeID = 1 AND 
    PeopleTagMap.DateExpired IS NULL
    AND IsSystem = 1
    AND PeopleTag IN ('Lookup Lead','Verified Lead','Smart Lead')
    AND PeopleTagMap.PeopleID = #PeopleID#
    AND (PeopleTagMap.DateDeleted is NULL)
	ORDER BY PeopleTag.IsSystem,PeopleTag.PeopleTagID
</cfquery>

<CFIF ISNUMERIC(GetPeople.ATTOM_ID)> 
 <cfquery name="GetProperty" datasource="#dsn#">
	SELECT * FROM Tax_Assessor_Live 
    WHERE ATTOM_ID = #GetPeople.ATTOM_ID#
</cfquery>  
</CFIF>

<cfquery name="getCalendarEvent" datasource="#DSN#">
	SELECT Calendly.*, Users.OnboardDate FROM Calendly
	INNER JOIN Users ON
	Calendly.INVITEE__EMAIL = Users.Email
	WHERE Email = '#getPeople.email#'
	AND EVENT_TYPE__SLUG IN ('livetraining','platformonboarding','offrs-101-v6')
</cfquery>

<cfquery name="getDemo" datasource="#DSN#">
	SELECT Calendly.*, Users.OnboardDate FROM Calendly
	INNER JOIN Users ON
	Calendly.INVITEE__EMAIL = Users.Email
	WHERE Email = '#getPeople.email#'
	AND EVENT_TYPE__SLUG IN ('demo30min','smartsession30min','smartsession60min','demo60min','smartsession45min')
</cfquery>

<!---- Track People Views----> 
<CFTRY>
<cfquery name="RecordPeopleView" datasource="#dsn#">
	INSERT INTO PEOPLEVIEW (PeopleID,UserID,DateStamp) VALUES (#PeopleID#,#cookie.UserID#,#NOW()#)
</cfquery>

<CFCATCH type="any"></CFCATCH>
</CFTRY> 

<body class="has-bg-image navbar-bottom">
<cfinclude template="_nav.cfm">

 
<CFINCLUDE template="people_map.cfm">

            
	<div style=" margin-top: -20px; margin-bottom: -40px;">

              <div class="gradient-overlay" style="">

                <div class="media text-center">
                    <div class="media">
                        <CFIF LEN(getPeople.PhotoURL)>
                            <img src="<CFOUTPUT>#getPeople.PhotoURL#</CFOUTPUT>" class="img-circle img-lg" alt="">
                        <CFELSE>
						<CFIF getStatusTags.RecordCount>
							<CFIF getStatusTags.PeopleTag EQ 'Win'> 
								<i class="icon-piggy-bank text-primary" style="font-size:50px;"></i> 
							<CFELSEIF getStatusTags.PeopleTag EQ 'Hot'>
								<i class="icon-fire text-danger" style="font-size:50px;"></i>  
							<CFELSEIF getStatusTags.PeopleTag EQ 'Verified'>
								<i class="icon-shield-check text-primary" style="font-size:50px;"></i>
						    <CFELSE> 
								<i class="icon-user text-primary" style="font-size:50px;"></i>
							</CFIF>

						<CFELSE>
							<i class="icon-user text-primary" style="font-size:50px;"></i>
						</CFIF> 
                        </CFIF>
                        <!---<span class="badge bg-danger-400 media-badge-score">85</span>---> 
                    </div>
                    <div class="media-body">
                        <h4 class="media-heading mt-10"><CFOUTPUT>#reReplace(lcase(getPeople.FirstName),"(^[a-z])","\U\1","ALL")# #reReplace(lcase(getPeople.LastName),"(^[a-z])","\U\1","ALL")# </CFOUTPUT></h4>
                       <!--- <span class="text-muted"> 
						<CFIF ISNUMERIC(GetPeople.ATTOM_ID)>
                        	<CFOUTPUT>
                           <CFIF LEN(GetProperty.PropertyAddressFull)>
                            #GetProperty.PropertyAddressFull# #GetProperty.PropertyAddressCity#, #GetProperty.PropertyAddressState# #GetProperty.PropertyAddressZip#
                           <CFELSEIF LEN(getPeople.Address)>
                           
						    <CFOUTPUT>
							   <CFIF LEN(getPeople.Address)>
								  #getPeople.Address# #getPeople.Address2# 
							   </CFIF>
							   <CFIF LEN(getPeople.City)>
								  #getPeople.City#, #getPeople.State# #getPeople.Zip#
							   </CFIF>
						    </CFOUTPUT> 
                        
					  </CFIF>
                         
                         </CFOUTPUT> 
                        <CFELSE>
						
				    <CFOUTPUT>
                            <CFIF LEN(getPeople.Address)>
                                #getPeople.Address# #getPeople.Address2# 
                            </CFIF>
                            <CFIF LEN(getPeople.City)>
                                #getPeople.City#, #getPeople.State# #getPeople.Zip#
                            </CFIF>
                        </CFOUTPUT> 
                       </CFIF>
                        <a href=""><i class="icon-location3 text-slate"></i></a>
                       </span> --->
                        
                        <!---- Get System Tags----->
                        
                        <div class="text-center mt-10"> 
                        <CFOUTPUT QUERY="getStatusTags"> <span class="label label-success border-success-300 text-success-600 label-rounded label-flat" style="font-size:12px;">STATUS: #PeopleTag#</span> </CFOUTPUT> 
                        <CFOUTPUT QUERY="getDescriptiveTags"> <span class="label label-success border-success-300 text-success-600 label-rounded label-flat" style="font-size:12px;"><CFIF LEN(Alias)>#Alias#<CFELSE>#PeopleTag#</CFIF></span> </CFOUTPUT> 
                         
                        </div>
                    
                    
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
								<li class="active"><a href="#tab-overview" data-toggle="tab">Overview</a></li>  
								<li><a href="#tab-stats" data-toggle="tab">Stats</a></li> 
							</ul>



							<div class="tab-content"> 
								<div class="tab-pane active" id="tab-overview"> 
									<CFINCLUDE template="people_detail_tab_overview.cfm">
								</div>  
								<div class="tab-pane" id="tab-stats">
                                			<CFINCLUDE template="admin_people_stats.cfm">  
								</div> 
								<!---<div class="tab-pane" id="tab-stats"> 
									<CFINCLUDE template="people_detail_tab_stats.cfm"> 
								</div> --->
							</div> 
						</div>

			 
				 <CFINCLUDE template="admin_people_user_coach.cfm">
				 <CFINCLUDE template="people_detail_tags_v6.cfm">
 				 <CFINCLUDE template="people_detail_append.cfm"> 
					 
					 
                </div>
                
                
                
                <!-- Task navigation --> 
                
                <!----- MIDDLE COLUMN-------->
                <div class="col-lg-6">

                    <div class="row mb-10">   
                        <CFINCLUDE template="admin_people_detail_launchcampaign.cfm">
                    </div>
                    
                    
                    
                    
                    <div class="tab-content content-group"> 
							<ul class="nav nav-tabs nav-tabs-highlight nav-lg nav-justified"> 
								<li class="active"><a href="#tab-notes" data-toggle="tab">Notes</a></li>  
								<li><a href="#tab-tickets" data-toggle="tab">Tickets</a></li> 
                                <li><a href="#tab-log" data-toggle="tab">Log</a></li> 
							</ul>



							<div class="tab-content"> 
								<div class="tab-pane active" id="tab-notes"> 
									
									
								
									
								<CFINCLUDE template="admin_people_detail_notes.cfm">
                                
                                <CFINCLUDE template="people_detail_notes.cfm">

								<CFINCLUDE template="admin_people_detail_timeline.cfm">
								 
								
								<!---- Notes from v4---->
								<CFINCLUDE template="admin_people_detail_timeline_legacy.cfm">	

								</div>  
								<div class="tab-pane" id="tab-tickets">

                                	<CFINCLUDE template="admin_people_detail_tickets.cfm"> 

								</div>
                                
								<div class="tab-pane" id="tab-log"> 
                                    
									<CFINCLUDE template="admin_people_log.cfm"> 
								</div> 
							</div> 
					</div> 


                </div>
                <!------ RIGHT COLUMN--------->
                <div class="col-lg-3">  
                
			 	<CFINCLUDE template="admin_people_user_abz.cfm">
                
				<CFINCLUDE template="admin_people_user_abz_aa.cfm">
                    
                    
                <CFINCLUDE template="admin_people_user_settings.cfm">
				
			<!---	<CFINCLUDE template="admin_people_user_contracts.cfm">--->
					
				<CFINCLUDE template="admin_people_user_licenses.cfm">
                
					
					<CFINCLUDE template="admin_people_user_facebook.cfm">
						
						
             <!---   <CFINCLUDE template="admin_people_user_social.cfm">--->
                
                
                  
                </div>
                
            </div>
        </div>
    </div>
</div>
<!---</div>
</div>--->
 
<!-- /main content -->
 

<!---<CFINCLUDE template="people_detail_addTag.cfm">--->



<!----------------------------------->
<!---------- DEBUG 			--------->
<!----------------------------------->
<CFTRY>
<CFIF ISDEFINED("Debug")>

<cfquery name="getPeopleTags" datasource="#dsn#">
	SELECT PeopleTag.PeopleTagID,PeopleTag.PeopleTag,PeopleTagMap.DateStamp,PeopleTagMap.PeopleTagMapID  
    FROM PeopleTag,PeopleTagMap WHERE 
    PeopleTag.PeopleTagID = PeopleTagMap.PeopleTagID AND 
	PeopleTagMap.PeopleID = #PeopleID#   
</cfquery>

<cfquery name="getPeopleUserMap" datasource="#dsn#">
	SELECT Users.UserID,Users.FName,Users.LName,PeopleUserMap.PeopleRouteID,PeopleUserMap.DateEmailSent
    FROM Users,PeopleUserMap  WHERE 
    Users.UserID = PeopleUserMap.UserID AND 
	PeopleUserMap.PeopleID = #PeopleID#   
</cfquery>

<cfquery name="getPeopleCampaigns" datasource="#dsn#" maxrows="10">
	SELECT PeopleCampaign.PeopleCampaign,PeopleCampaignPeople.DateStamp,PeopleCampaignPeople.DateQueued,PeopleCampaignPeople.DateComplete 
    FROM PeopleCampaign,PeopleCampaignPeople WHERE 
    PeopleCampaign.PeopleCampaignID = PeopleCampaignPeople.PeopleCampaignID AND 
	PeopleCampaignPeople.PeopleID = #PeopleID#  
	ORDER BY PeopleCampaignPeople.DateStamp DESC
</cfquery>

<DIV STYLE="padding:20px;background-color:#D7D7D7;">
<b>DEBUG INFO</b><BR>
<CFOUTPUT>
UserID: #cookie.UserID#<br>
PeopleID: #PeopleID#<br> 
Source: #getPeople.Source#<br>
UserID: #getPeople.UserID#<br>
SphereID: #getPeople.SphereID#<br>
ATTOM_ID: #getPeople.ATTOM_ID#<br>
Date Imported: #DateFormat(getPeople.DateImported,'mm/dd/yyyy')#<Br>

<BR><BR>
</CFOUTPUT>
<strong>TAGS (What has this person been tagged):</strong><br>
<TABLE class="table">
<TR>
<TD COLSPAN="3"><strong>These are Tags for this Person</strong></TD>
</TR>
<TR>
<TD><strong>PeopleTagID</strong></TD>
<TD><strong>PeopleTag</strong></TD>
<TD><strong>PeopleTagMapID</strong></TD>
</TR>
<CFOUTPUT QUERY="getPeopleTags">
<TR>
<TD>#PeopleTagID#</TD>
<TD>#PeopleTag#</TD>
<TD>#PeopleTagMapID#</TD>
</TR>
</CFOUTPUT>
</TABLE>
<BR><BR>
<strong>CAMPAIGNS (what marketing is hitting this person):</strong><BR>
<TABLE class="table">
<TR>
<TD COLSPAN="3"> </TD></TR>
<TR>
<TD><strong>Campaign</strong></TD>
<TD><strong>Queued</strong></TD>
<TD><strong>Complete</strong></TD>
</TR>
<CFOUTPUT QUERY="getPeopleCampaigns">
<TR>
<TD>#PeopleCampaign#</TD>
<TD>#DateFormat(DateQueued,'mm/dd/yyyy')#</TD>
<TD>#DateFormat(DateComplete,'mm/dd/yyyy')#</TD>
</TR>
</CFOUTPUT>
</TABLE>


<BR><BR>
<strong>USERS MAPPED TO THIS PERSON (who else can see them):</strong><BR>
<TABLE class="table">
<TR>
<TD COLSPAN="3"> </TD></TR>
<TR>
<TD><strong>UserID</strong></TD>
<TD><strong>Name</strong></TD>
<TD><strong>Route</strong></TD>
<TD><strong>Route Email</strong></TD>
</TR>
<CFOUTPUT QUERY="getPeopleUserMap">
<TR>
<TD>#UserID#</TD>
<TD>#FName# #LName#</TD>
<TD>#PeopleRouteID#</TD>
<TD>#DateFormat(DateEmailSent,'mm/dd/yyyy')#</TD>
</TR>
</CFOUTPUT>
</TABLE>




</DIV>
</CFIF>
<BR><BR>
<CFCATCH type="any"><CFDUMP VAR="#CFCATCH.Detail#"></CFCATCH>
</CFTRY>
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
