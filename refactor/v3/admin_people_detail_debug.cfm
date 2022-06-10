<!----------------------------------->
<!---------- DEBUG 			--------->
<!----------------------------------->
<cftry>
    <cfquery name="getPeopleTags" datasource="#dsn#">
        SELECT 
            PeopleTag.PeopleTagID,
            PeopleTag.PeopleTag,
            PeopleTagMap.DateStamp,
            PeopleTagMap.PeopleTagMapID  
        FROM PeopleTag,PeopleTagMap 
        WHERE PeopleTag.PeopleTagID = PeopleTagMap.PeopleTagID 
        AND PeopleTagMap.PeopleID = #PeopleID#   
    </cfquery>
    
    <cfquery name="getPeopleUserMap" datasource="#dsn#">
        SELECT 
            Users.UserID,
            Users.FName,
            Users.LName,
            PeopleUserMap.PeopleRouteID,
            PeopleUserMap.DateEmailSent
        FROM Users,PeopleUserMap  
        WHERE Users.UserID = PeopleUserMap.UserID 
        AND PeopleUserMap.PeopleID = #PeopleID#   
    </cfquery>
    
    <cfquery name="getPeopleCampaigns" datasource="#dsn#" maxrows="10">
        SELECT 
            PeopleCampaign.PeopleCampaign,
            PeopleCampaignPeople.DateStamp,
            PeopleCampaignPeople.DateQueued,
            PeopleCampaignPeople.DateComplete 
        FROM PeopleCampaign,PeopleCampaignPeople 
        WHERE PeopleCampaign.PeopleCampaignID = PeopleCampaignPeople.PeopleCampaignID 
        AND PeopleCampaignPeople.PeopleID = #PeopleID#  
        ORDER BY PeopleCampaignPeople.DateStamp DESC
    </cfquery>
    
    <div STYLE="padding:20px;background-color:#D7D7D7;">
    <b>DEBUG INFO</b>
    <br>
        
        UserID: #cookie.UserID#<br>
        PeopleID: #PeopleID#<br> 
        Source: #getPeople.Source#<br>
        UserID: #getPeople.UserID#<br>
        SphereID: #getPeople.SphereID#<br>
        ATTOM_ID: #getPeople.ATTOM_ID#<br>
        Date Imported: #DateFormat(getPeople.DateImported,'mm/dd/yyyy')#<Br>
    
    <br>
    <br>
    
    <strong>TAGS (What has this person been tagged):</strong><br>
    <TABLE class="table">
        <TR>
            <td COLSPAN="3"><strong>These are Tags for this Person</strong></td>
        </TR>
        <TR>
            <td><strong>PeopleTagID</strong></td>
            <td><strong>PeopleTag</strong></td>
            <td><strong>PeopleTagMapID</strong></td>
        </TR>
    <cfoutput query="getPeopleTags">
    <TR>
        <td>#PeopleTagID#</td>
        <td>#PeopleTag#</td>
        <td>#PeopleTagMapID#</td>
    </TR>
    
    </TABLE>
    <br><br>
    <strong>CAMPAIGNS (what marketing is hitting this person):</strong><br>
    <TABLE class="table">
    <TR>
    <td COLSPAN="3"> </td></TR>
    <TR>
    <td><strong>Campaign</strong></td>
    <td><strong>Queued</strong></td>
    <td><strong>Complete</strong></td>
    </TR>
    <cfoutput query="getPeopleCampaigns">
    <TR>
    <td>#PeopleCampaign#</td>
    <td>#DateFormat(DateQueued,'mm/dd/yyyy')#</td>
    <td>#DateFormat(DateComplete,'mm/dd/yyyy')#</td>
    </TR>
    
    </TABLE>
    
    
    <br><br>
    <strong>USERS MAPPED TO THIS PERSON (who else can see them):</strong><br>
    <TABLE class="table">
    <TR>
    <td COLSPAN="3"> </td></TR>
    <TR>
    <td><strong>UserID</strong></td>
    <td><strong>Name</strong></td>
    <td><strong>Route</strong></td>
    <td><strong>Route Email</strong></td>
    </TR>
    <cfoutput query="getPeopleUserMap">
    <TR>
    <td>#UserID#</td>
    <td>#FName# #LName#</td>
    <td>#PeopleRouteID#</td>
    <td>#DateFormat(DateEmailSent,'mm/dd/yyyy')#</td>
    </TR>
    
    </TABLE>
    
    
    
    
    </div>
    </cfif>
    <br><br>
    <cfcatch type="any">
        <cfdump var="#cfcatch.Detail#">
    </cfcatch>
</cftry>