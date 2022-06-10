component {

    public void function onLoad(struct beanFactory) {
        arguments.beanfactory
            .declare("StarWarsClient")
            .asValue(new hyper.models.HyperBuilder(baseUrl = "https://swapi.dev/api", timeout = 20))
            .done();
        arguments.beanfactory
            .declare("BaseGrammar")
            .instanceOf("qb.models.Grammars.BaseGrammar")
            .done()
            .declare("PostgresGrammar")
            .instanceOf("qb.models.Grammars.PostgresGrammar")
            .done()
            .declare("QueryUtils")
            .instanceOf("qb.models.Query.QueryUtils")
            .done()
            .declare("qb")
            .instanceOf("qb.models.Query.QueryBuilder")
            .withOverrides(
                {"grammar": arguments.beanfactory.getBean("PostgresGrammar"), 
                "utils": arguments.beanfactory.getBean("QueryUtils")})
            .asTransient()
            .done();
        arguments.beanfactory
            .declare("LogBoxConfig")
            .instanceOf("logbox.system.logging.config.LogBoxConfig")
            .withOverrides({"CFCConfigPath": "conf.LogBoxConfig"})
            .done();
        arguments.beanfactory
            .declare("LogBoxBase")
            .instanceOf("logbox.system.logging.LogBox")
            .withOverrides({"config": arguments.beanfactory.getBean("LogBoxConfig")})
            .done();
        arguments.beanfactory
            .declare("LogBox")
            .asValue(arguments.beanfactory.getBean("LogBoxBase"))
            .done();
    
        arguments.beanFactory.load();
    }
}
