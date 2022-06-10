component extends="framework.one" output="false" {
	this.applicationTimeout = createTimeSpan(0, 2, 0, 0);
	this.setClientCookies = true;
	this.sessionManagement = true;
	this.sessionTimeout = createTimeSpan(0, 0, 30, 0);
    this.mappings = {
        "/hyper"      = expandPath("./modules/hyper"),
        "/qb"         = expandPath("./modules/qb"),
        "/cbpaginator"= expandPath("./modules/qb/modules/cbpaginator"),
        "/logbox"     = expandPath("./modules/logbox")
    };

    this.datasource = {
        "type": 'postgresql'
        , "host": 'localhost'
        , "database": 'postgres'
        , "port": 5432
        , "username": 'postgres'
        , "password": "password"
        
    };

	//FW/1 settings
	variables.framework = {
		"action" = 'action',
		"defaultSection" = 'main',
		"defaultItem" = 'default',
		"generateSES" = true,
		"SESOmitIndex" = true,
        "reloadApplicationOnEveryRequest" = true,
        "decodeRequestBody" = true,
        "routesCaseSensitive" = false,
		"diEngine" = "di1",
		"diComponent" = "framework.ioc",
		"diLocations" = "model, controllers",
        "diConfig": { "loadListener": "LoadListener" },
        "trace" = true,
        "routes" = [ 
            { "$RESOURCES" = "game" }
        ]
	};


	public void function setupSession() {  }

	public void function setupRequest() {  }

	public void function setupView() {  }

	public void function setupResponse() {  }

	public string function onMissingView(struct rc = {}) {
		return "Error 404 - Page not found.";
	}
}