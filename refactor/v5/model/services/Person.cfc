component displayname="Person service" accessors=true {

    property beanFactory;

    variables.users = [];

	public User function init(struct beanFactory, struct fw) {
        variables.framework = fw;
        variables.beanFactory = arguments.beanFactory;
        variables.qb = arguments.beanFactory.getBean("qb");        
		return this;
	}

    public array function get(struct args) {
        variables.users = variables.qb.from("users").get();
        return variables.users;
    }

    public string function save(struct args) {
        if (structKeyExists(arguments.args, "name")) 
        if (structKeyExists(arguments.args, "description")) 
        if (structKeyExists(arguments.args, "studio")) 
        if (structKeyExists(arguments.args, "releaseDate")) 
        if (structKeyExists(arguments.args, "rating"))
           local.rating = parseNumber(arguments.args.rating);

        variables.qb.from("users").insert([
            {
                "user_name": arguments.args.name,
                "user_desc": arguments.args.description,
                "studio": arguments.args.studio,
                "release_date": arguments.args.releaseDate,
                "rating": local.rating,
                "time_stamp": qb.raw("NOW()")
            }
        ]);

        return "success";
    }

    public struct function delete(struct args) { 
        var response = {};

        return response;
    }
}
