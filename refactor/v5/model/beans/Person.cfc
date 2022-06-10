component displayname="Person bean" accessors=true {
    
    property peopleId;
    property username;
    property email;
    property phone;
    property address;
    property createdOn;
    property lastLogin;
    
    public User function init() {
		return this;
	}
    
}
