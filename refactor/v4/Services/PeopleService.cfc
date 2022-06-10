component displayname="PeopleService" output="false" {

    /**
     * Returns a single user based on the specified user ID.
     * @param userId The user ID of the user to retrieve.
     * @return query object containing the user.
     */
    public query function getUser(numeric userId = 0) {
        return queryExecute(
            "SELECT * FROM Users 
            WHERE userID = :userId", 
            {userId = {value=arguments.userId, cfsqltype="cf_sql_integer"}},
            {datasource="dsn"});
    }

    /**
     * Returns a person based on the specified peopleId.
     * @param peopleId The peopleId of the person to retrieve.
     * @return query object containing the person.
     */
    public query function getPeople(numeric peopleId = 0) {
        return queryExecute(
            "SELECT * FROM People
            WHERE PeopleID = :peopleId", 
            {peopleId = {value=arguments.peopleId, cfsqltype="cf_sql_integer"}},
            {datasource="dsn"});
    };

    /**
     * Returns the full name of a person based on the first and last name arguments. 
     * @param firstName the first name of the person.
     * @param lastName the last name of the person.
     * @return string containing the full name.
     */
    public string function setProfileName(string firstName = "", string lastName = "") {
        var fullName = reReplace(lcase(arguments.firstName,"(^[a-z])","\U\1","ALL")) 
                       + " " 
                       + reReplace(lcase(arguments.lastName),"(^[a-z])","\U\1","ALL");
        return fullName;
    }

    /**
     * Returns all status tags for a person.
     * @param peopleId The people ID of the people tags to retrieve.
     * @return query object containing the people.
     */
    public query function getStatusTags(numeric peopleId = 0) {
        return queryExecute(
            "SELECT * FROM PeopleTag,PeopleTagMap 
            WHERE PeopleTag.PeopleTagID = PeopleTagMap.PeopleTagID 
            AND PeopleTag.PeopleTagTypeID = 2 
            AND PeopleTagMap.DateExpired IS NULL
            AND PeopleTagMap.PeopleID = :peopleId
            AND (PeopleTagMap.DateDeleted is NULL)
            ORDER BY PeopleTagMap.DateStamp DESC",
            {peopleId = {value=arguments.peopleId, cfsqltype="cf_sql_integer"}},
            {datasource="dsn"});
    }

    /**
     * Returns all descriptive tags for a person.
     * @param peopleId The people ID of the people tags to retrieve.
     * @return query object containing the people.
     */
    public query function getDescriptiveTags(numeric peopleId = 0) {
        return queryExecute(
            "SELECT * FROM PeopleTag,PeopleTagMap 
            WHERE PeopleTag.PeopleTagID = PeopleTagMap.PeopleTagID 
            AND PeopleTag.PeopleTagTypeID = 1 
            AND PeopleTagMap.PeopleID = :peopleId
            AND PeopleTagMap.DateExpired IS NULL
            AND PeopleTagMap.PeopleTag NOT IN ('Lookup Lead','Verified Lead','Smart Lead')
            AND (PeopleTagMap.DateDeleted is NULL)
            ORDER BY PeopleTag.IsSystem,PeopleTag.PeopleTagID",
            {peopleId = {value=arguments.peopleId, cfsqltype="cf_sql_integer"}},
            {datasource="dsn"});
    }

    /**
     * Returns cfml for the profile icon of a person in the people profile detail page.
     * @param url The url of the person's profile image stored in the server.
     * @param statusTag The status tag of the user to retrieve.
     * @param statusQuery status tag query object to check if null.
     * @return string cfml for the profile icon of the person.
     */
    public string function setProfileIcon(string url = "", 
                                          string statusTag = "", 
                                          query statusQuery = null) {

        if (len(arguments.url))
            return "<img src=""#arguments.url#"" class=""img-circle img-lg"" alt="""">";
        else if (arguments.statusQuery.recordCount) {
            var icon = ""; 

            if (arguments.statusTag == 'Win')
                icon = "icon-piggy-bank text-primary";
            else if (arguments.statusTag == 'Hot')
                icon = "icon-fire text-danger";
            else if (arguments.statusTag == 'Verified')
                icon = "icon-shield-check text-primary";   
            else 
                icon = "icon-user text-primary";

        }
        else
            return "<i class=""icon-user text-primary"" style=""font-size:50px;""></i>";
        
    }

    /**
     * Inserts a tracking entry for people views in the PeopleViews table.
     */
    public void function trackPeopleViews() {
        try {
            queryExecute (
                "INSERT INTO PeopleViews (PeopleID, UserID, DateStamp)
                VALUES (:peopleId, :userId, NOW())",
                {peopleId = {value="peopleId", cfsqltype="cf_sql_integer"},
                userId = {value="cookie.userID", cfsqltype="cf_sql_integer"}},
                {datasource="dsn"}); 
        }
        catch(any e) {
            // do nothing
        }
    }
}