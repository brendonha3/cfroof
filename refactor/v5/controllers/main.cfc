component name="main" output="false" accessors="true"{
	
    property userService;

    function init() {
        return this; 
    }
    
    public void function default(struct rc = {}) {
		param name="rc.skeletonType" default="Basic FW/1 Skeleton";
        arguments.rc.user = variables.userService.get();
	}

    public void function user(struct rc = {}) {
        arguments.rc.user = variables.userService.get();
    }
}