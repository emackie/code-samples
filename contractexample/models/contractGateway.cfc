/**
*
* @file  /contract/models/contractGateway.cfc
* @author Ewan Mackie  
* @description Gateway methods for Contract object
*
*/

component output="false" displayname="contractGateway"  {

	//Dependency injection
	property name="dsn" inject="coldbox:datasource:dsn";

	public function init(){
		return this;
	}

	public function list(){

		//Returns all contracts
		var qList = "";

		qList = queryExecute(
			"SELECT contractid, serviceid, serviceName, serviceType, startDate, closeDate, provider FROM contracts",
			{},
			{datasource = dsn.name}
		);

		return qList;
	}

	private function filter(required struct stuFilter){

		//Perform filtered searches of contracts
		var params = {};
		var qFilter = "";
		var sql = "SELECT contractid, serviceid, serviceName, serviceType, startDate, closeDate, provider FROM contracts WHERE 1 = 1";

		//Add further parameters to query
		if (structKeyExists(arguments.stuFilter, "serviceName")) {

			sql = sql & " AND serviceName LIKE :serviceName";
			
			params.serviceName = {cfsqltype = "cf_sql_varchar", value = "%" & arguments.stuFilter.serviceName & "%"};
		}

		qFilter = queryExecute(sql, params, {datasource = dsn.name});

		return qFilter;
	}

	public function filterName(required string serviceName){

		//create struct to hold filter parameters
		var stuFilter = structNew();

		stuFilter.serviceName = arguments.serviceName;

		return filter(stuFilter);
	}
}