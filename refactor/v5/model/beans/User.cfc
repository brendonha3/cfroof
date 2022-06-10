component displayname="User bean" accessors=true {
    
    property userId;
    property name;
    property password;
    property email;
    property phone;
    property createdOn;
    property lastLogin;
    
    public User function init() {
		return this;
	}
    
}
