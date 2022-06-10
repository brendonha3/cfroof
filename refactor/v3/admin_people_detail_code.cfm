<cfscript>

    cfparam(name="peopleId", default="0");

    var getUser = queryExecute(
        "SELECT * FROM Users 
        WHERE userID = :userId", 
        {userId = {value="cookie.userID", cfsqltype="cf_sql_integer"}},
        {datasource="dsn"});

    var getPeople = queryExecute(
        "SELECT * FROM People
        WHERE PeopleID = :peopleId", 
        {peopleId = {value="peopleId", cfsqltype="cf_sql_integer"}},
        {datasource="dsn"});


    if (isNumeric(getPeople.LinkUserID)) {
        var getPeopleUser = queryExecute(
            "SELECT * FROM Users 
            WHERE UserID = :userId", 
            {userId = {value="getPeople.LinkUserID", cfsqltype="cf_sql_integer"}},
            {datasource="dsn"});
    }

    if (isNumeric(getPeopleUser.RegionalDirectorID)) {
        var getRep = queryExecute(
            "SELECT * FROM Users 
            WHERE UserID = :userId", 
            {userId = {value="getPeopleUser.RegionalDirectorID", cfsqltype="cf_sql_integer"}},
            {datasource="dsn"});
    }

    var getStatusTags = queryExecute(
        "SELECT * FROM PeopleTag,PeopleTagMap 
        WHERE PeopleTag.PeopleTagID = PeopleTagMap.PeopleTagID 
        AND PeopleTag.PeopleTagTypeID = 2 
        AND PeopleTagMap.DateExpired IS NULL
        AND PeopleTagMap.PeopleID = :peopleId
        AND (PeopleTagMap.DateDeleted is NULL)
        ORDER BY PeopleTagMap.DateStamp DESC",
        {peopleId = {value="peopleId", cfsqltype="cf_sql_integer"}},
        {datasource="dsn"});

    var getDescriptiveTags = queryExecute(
        "SELECT * FROM PeopleTag,PeopleTagMap 
        WHERE PeopleTag.PeopleTagID = PeopleTagMap.PeopleTagID 
        AND PeopleTag.PeopleTagTypeID = 1 
        AND PeopleTagMap.PeopleID = :peopleId
        AND PeopleTagMap.DateExpired IS NULL
        AND PeopleTagMap.PeopleTag NOT IN ('Lookup Lead','Verified Lead','Smart Lead')
        AND (PeopleTagMap.DateDeleted is NULL)
        ORDER BY PeopleTag.IsSystem,PeopleTag.PeopleTagID",
        {peopleId = {value="peopleId", cfsqltype="cf_sql_integer"}},
        {datasource="dsn"});

    var getDescriptiveTagsSystemOnly = queryExecute(
        "SELECT * FROM PeopleTag,PeopleTagMap 
        WHERE PeopleTag.PeopleTagID = PeopleTagMap.PeopleTagID 
        AND PeopleTag.PeopleTagTypeID = 1 
        AND PeopleTagMap.PeopleID = :peopleId
        AND PeopleTagMap.DateExpired IS NULL
        AND PeopleTagMap.PeopleTag NOT IN ('Lookup Lead','Verified Lead','Smart Lead')
        AND (PeopleTagMap.DateDeleted is NULL)
        AND PeopleTag.IsSystem = 1
        ORDER BY PeopleTag.IsSystem,PeopleTag.PeopleTagID",
        {peopleId = {value="peopleId", cfsqltype="cf_sql_integer"}},
        {datasource="dsn"});

    if (isNumeric(getPeople.ATTOM_ID)) {
        var getAttom = queryExecute(
            "SELECT * FROM Tax_Assessor_Live 
            WHERE ATTOM_ID = :attomId", 
            {attomId = {value="getPeople.ATTOM_ID", cfsqltype="cf_sql_integer"}},
            {datasource="dsn"});
    }

    var getCalendarEvent = queryExecute(
        "SELECT Calendly.*, Users.OnboardDate 
        FROM Calendly
        INNER JOIN Users 
        ON Calendly.INVITEE__EMAIL = Users.Email
        WHERE Email = :email
        AND EVENT_TYPE__SLUG IN ('demo30min','smartsession30min','smartsession60min','demo60min','smartsession45min')",
        {email = {value="getPeople.email", cfsqltype="cf_sql_varchar"}},
        {datasource="dsn"});

    var getDemo = queryExecute(
        "SELECT * 
        FROM Calendly 
        WHERE Email = :email 
        AND EVENT_TYPE__SLUG IN ('demo30min','demo60min')",
        {email = {value="getPeople.email", cfsqltype="cf_sql_varchar"}},
        {datasource="dsn"});

    if (!len(getPeople.PhotoURL)) {
        var profileIcon = "";
        
        if (getStatusTags.PeopleTag == 'Win')
            profileIcon = "icon-piggy-bank text-primary";
        else if (getStatusTags.PeopleTag == 'Hot')
            profileIcon = "icon-fire text-danger";
        else if (getStatusTags.PeopleTag == 'Verified')
            profileIcon = "icon-shield-check text-primary";
        else 
            profileIcon = "icon-user text-primary";
    }

    var profileName = reReplace(lcase(getPeople.FirstName),"(^[a-z])","\U\1","ALL") + " " + reReplace(lcase(getPeople.LastName),"(^[a-z])","\U\1","ALL");

<!---- Track People Views----> 
    try {
        queryExecute(
            "INSERT INTO PeopleViews (PeopleID, UserID, DateStamp)
            VALUES (:peopleId, :userId, NOW())",
            {peopleId = {value="peopleId", cfsqltype="cf_sql_integer"},
            userId = {value=cookie.userID, cfsqltype="cf_sql_integer"}},
            {datasource=dsn}); 
    }
    catch(any e) {
        // do nothing
    }

</cfscript>