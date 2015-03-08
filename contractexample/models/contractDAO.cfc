/**
*
* @file  /contract/models/contractDAO.cfc
* @author Ewan Mackie
* @description Data access methods for the contract object
*
*/

component displayname="contractDAO" accessors="true" singleton {

	//dependency injection
	property name="dsn" inject="coldbox:datasource:dsn";

	public function init(){
		return this;
	}

	function save(required contract contract){

		//If contract id is already in database, perform update, otherwise, perform insert
		if(exists(arguments.contract.getContractID())){

			response = update(arguments.contract);
		
		}
		else {

			response = create(arguments.contract);
		
		}

		return response;
	}

	private function exists(required numeric contractId) {

		var boolExists = "";
		var qExists = ""

		qExists = queryExecute(
			"SELECT COUNT(1) AS idExists FROM contracts WHERE contractid = :contractid",
			{contractid = {cfsqltype = "cf_sql_numeric", value = arguments.contractid}},
			{datasource = dsn.name}
		);

		if (qExists.idExists) {
			boolExists = true;
		}
		else {
			boolExists = false;
		}

		return boolExists;
	}

	private function create(required contract contract){

		var response = 0;
		var result = "";		

		try {

			qInsert = queryExecute(
				"INSERT INTO [contracts] (serviceid, serviceName, serviceType, startDate, closeDate, provider) 
				VALUES (:serviceid, :servicename, :servicetype, :startDate, :closeDate, :provider)",
				{
					serviceid = {cfsqltype = "cf_sql_varchar", value = arguments.contract.getServiceID()},
					servicename = {cfsqltype = "cf_sql_varchar", value = arguments.contract.getServiceName()},
					servicetype = {cfsqltype = "cf_sql_numeric", value = arguments.contract.getServiceType()},
					startDate = {cfsqltype = "cf_sql_date", value = arguments.contract.getStartDate()},
					closeDate = {cfsqltype = "cf_sql_date", value = arguments.contract.getCloseDate()},
					provider = {cfsqltype = "cf_sql_numeric", value = arguments.contract.getProvider()}
				},
				{datasource = dsn.name, result = "insQuery"}
			);

			//Capture created key for record
			response = insQuery.identitycol;
		}
		catch(any e){
			response = 0;
		}

		return response;
	}

	private function update(required contract contract){

		var boolSuccess = true;
		var result = "";

		try {

			result = queryExecute(
				"UPDATE [contracts]
				 SET serviceid = :serviceid, serviceName = :serviceName, serviceType = :serviceType, startDate = :startDate, closeDate = :closeDate, provider = :provider WHERE contractid = :contractid",
				 {
				 	serviceid = {cfsqltype = "cf_sql_varchar", value = arguments.contract.getServiceID()},
				 	servicename = {cfsqltype = "cf_sql_varchar", value = arguments.contract.getServiceName()},
				 	servicetype = {cfsqltype = "cf_sql_numeric", value = arguments.contract.getServiceType()},
				 	startDate = {cfsqltype = "cf_sql_date", value = arguments.contract.getStartDate()},
				 	closeDate = {cfsqltype = "cf_sql_date", value = arguments.contract.getCloseDate()},
				 	provider = {cfsqltype = "cf_sql_numeric", value = arguments.contract.getProvider()},
				 	contractid = {cfsqltype = "cf_sql_numeric", value = arguments.contract.getContractID()}
				 },
				 {datasource = dsn.name}
			);

		}
		catch(any e){
			boolSuccess = false;
		}

		return boolSuccess;
	}

	public function read(required numeric contractid){

 		var result = queryExecute(
			"SELECT contractid, serviceid, serviceName, serviceType, startDate, closeDate, provider FROM contracts WHERE contractid = :contractid",
			{contractid = {value = arguments.contractid, cfsqltype="cf_sql_numeric"}},
			{datasource = dsn.name}
		);
 
		return result;
	}

	public function delete(required numeric contractid){

		var boolSuccess = true;

		try{

			result = queryExecute(
				"DELETE FROM contracts WHERE contractid = :contractid",
				{contractid = {value = arguments.contractid, cfsqltype="cf_sql_numeric"}},
				{datasource = dsn.name}
			);
		}
		catch(any e){
			boolSuccess = false;
		}

		return boolSuccess;

	}
}