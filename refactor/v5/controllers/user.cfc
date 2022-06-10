component displayname="user controller" accessors="true" {

    property gameService;
    
    public function init(struct fw) {
        variables.fw = fw;
        variables.format = 'json';

        return this;
    }

	public void function default(struct rc = {}, struct headers = {}) {
		// For getting all Users Info
		var response = variables.gameService.get(rc);
		variables.fw.renderData().type(format).data(response);
	}

	public void function show(struct rc = {}, struct headers = {}) {
		// For getting selected User
		var response = variables.userService.get(rc);
		variables.fw.renderData().type(format).data(response);
	}

	public void function create(struct rc = {}, struct headers = {}) {
		// For new User creation
		var response = variables.userService.save(rc);
		variables.fw.renderData().type(format).data(response);
	}

	public void function update(struct rc = {}, struct headers = {}) {
		// For update selected User
        var response = variables.userService.save(rc);
     	variables.fw.renderData().type(format).data(response);
	}

	public void function destroy(struct rc = {}, struct headers = {}) {
		// For delete selected User
		var response = variables.userService.delete(rc);
		variables.fw.renderData().type(format).data(response);
	}
}
