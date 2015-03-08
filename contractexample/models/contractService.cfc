/**
*
* @file  /contract/models/contractService.cfc
* @author Ewan Mackie
* @description Service methods for contract object
*
*/

component displayname="contractService" accessors="true" singleton {

	//Dependency injection
	property name="dao" inject="contractDAO";
	property name="gateway" inject="contractGateway";
	property name="pop" inject="wirebox:populator";
	property name="wirebox" inject="wirebox";

	public function init(){
		return this;
	}

	function save(required contract contract){

		return dao.save(arguments.contract);
	}

	function read(required numeric contractid = 0){

		var response = "";
		var qContract = dao.read(arguments.contractid);

		/* If record isn't found, create empty contract object. Otherwise, populate
		the object */
		if (arguments.contractid = 0 or qContract.recordCount eq 0){

			response = wirebox.getInstance("contract");
		}
		else {
			
			response = pop.populateFromQuery(wirebox.getInstance("contract"), qContract, 1);
		}

		return response;
	}

	function delete(required numeric contractid){

		return dao.delete(arguments.contractid);
	}

	function list(){

		return gateway.list();
	}

	function filterName(required string strSearch){

		//filter contracts by servicename
		
		return gateway.filterName(arguments.strSearch);
	}
}