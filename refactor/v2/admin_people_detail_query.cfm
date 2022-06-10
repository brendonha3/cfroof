<cfparam name="PEOPLEID" default="0">

<cfquery name="getUser" datasource="#dsn#">
	SELECT * FROM Users 
    WHERE userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#cookie.userID#" />
</cfquery>

<cfquery name="getPeople" datasource="#dsn#">
	SELECT * FROM People 
    WHERE PeopleID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PEOPLEID#" />
</cfquery>

<cfif isNumeric(getPeople.LinkUserID)>
    <cfquery name="getPeopleUser" datasource="#dsn#">
        SELECT * FROM Users 
        WHERE UserID = <cfsqlparam cfsqltype="cf_sql_integer" value="#getPeople.LinkUserID#" />
    </cfquery>
<cfelse>
    People Not Found. <a href="people_detail.cfm?PeopleID=#PeopleID#">Try here</a>.<cfabort>
</cfif>
 
<cfif isNumeric(getPeopleUser.RegionalDirectorID)>
    <cfquery name="getRep" datasource="#dsn#">
        SELECT * FROM Users 
        WHERE userID = <cfsqlparam cfsqltype="cf_sql_integer" value="#getPeopleUser.RegionalDirectorID#" />
    </cfquery>
</cfif>

<cfquery name="getStatusTags" datasource="#dsn#" maxrows="1">
	SELECT * FROM PeopleTag,PeopleTagMap 
    WHERE PeopleTag.PeopleTagID = PeopleTagMap.PeopleTagID 
    AND PeopleTag.PeopleTagTypeID = 2 
    AND PeopleTagMap.DateExpired IS NULL
    AND PeopleTagMap.PeopleID = <cfsqlparam cfsqltype="cf_sql_integer" value="#PeopleID#" />
    AND (PeopleTagMap.DateDeleted is NULL)
	ORDER BY PeopleTagMap.DateStamp DESC
</cfquery>

<cfquery name="getDescriptiveTags" datasource="#dsn#">
	SELECT * FROM PeopleTag,PeopleTagMap 
    WHERE PeopleTag.PeopleTagID = PeopleTagMap.PeopleTagID 
    AND PeopleTag.PeopleTagTypeID = 1 
    AND PeopleTagMap.PeopleID = <cfsqlparam cfsqltype="cf_sql_integer" value="#PeopleID#" /> 
    AND PeopleTagMap.DateExpired IS NULL  
    AND PeopleTag NOT IN ('Lookup Lead','Verified Lead','Smart Lead')
    AND (PeopleTagMap.DateDeleted is NULL)
	ORDER BY PeopleTag.IsSystem,PeopleTag.PeopleTagID
</cfquery>

<cfquery name="getDescriptiveTagsSystemOnly" datasource="#dsn#">
	SELECT * FROM PeopleTag,PeopleTagMap 
    WHERE PeopleTag.PeopleTagID = PeopleTagMap.PeopleTagID 
    AND PeopleTag.PeopleTagTypeID = 1 
    AND PeopleTagMap.DateExpired IS NULL
    AND IsSystem = 1
    AND PeopleTag IN ('Lookup Lead','Verified Lead','Smart Lead')
    AND PeopleTagMap.PeopleID = <cfsqlparam cfsqltype="cf_sql_integer" value="#PeopleID#" />
    AND (PeopleTagMap.DateDeleted is NULL)
	ORDER BY PeopleTag.IsSystem,PeopleTag.PeopleTagID
</cfquery>

<cfif isNumeric(GetPeople.ATTOM_ID)> 
    <cfquery name="GetProperty" datasource="#dsn#">
        SELECT * FROM Tax_Assessor_Live 
        WHERE ATTOM_ID = <cfsqlparam type="cf_sql_integer" value="#GetPeople.ATTOM_ID#" />
    </cfquery>  
</cfif>

<cfquery name="getCalendarEvent" datasource="#dsn#">
	SELECT Calendly.*, Users.OnboardDate 
    FROM Calendly
	INNER JOIN Users 
    ON Calendly.INVITEE__EMAIL = Users.Email
	WHERE Email = '<cfsqlparam type="varchar" value="#getPeople.email#" />'
	AND EVENT_TYPE__SLUG IN ('livetraining','platformonboarding','offrs-101-v6')
</cfquery>

<cfquery name="getDemo" datasource="#dsn#">
	SELECT Calendly.*, Users.OnboardDate 
    FROM Calendly
	INNER JOIN Users 
    ON Calendly.INVITEE__EMAIL = Users.Email
	WHERE Email = '<cfsqlparam type="varchar" value="#getPeople.email#" />'
	AND EVENT_TYPE__SLUG IN ('demo30min','smartsession30min','smartsession60min','demo60min','smartsession45min')
</cfquery>

<!---- Track People Views----> 
<cftry>
    <cfquery name="recordPeopleView" datasource="#dsn#">
        INSERT INTO PEOPLEVIEW (PeopleID,UserID,DateStamp) 
        VALUES (<cfsqlparam cfsqltype="cf_sql_integer" value="#PeopleID#" />,
                <cfsqlparam cfsqltype="cf_sql_integer" value="#cookie.UserID#" />,
                <cfsqlparam cfsqltype="cf_sql_timestamp" value="#NOW()#" />)
    </cfquery>

<cfcatch type="any" /> 

</cftry> 
