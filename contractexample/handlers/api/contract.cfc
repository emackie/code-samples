/**
*
* @file  /contract/handlers/api/contract.cfc
* @author Ewan Mackie
* @description REST API methods for the contract service.
*
*/

component{

	property name="contractService" inject="contractService";

	function index(event,rc,prc){

		prc.listContracts = contractService.list();
		
		if (prc.listContracts.recordCount){
			event.renderData(type = "json", data = prc.listContracts, statusCode=200, statusMessage="OK");
		}
		else {
			event.renderData(type="json", data = prc.listContracts, statusCode=404, statusMessage="Contracts not found");
		}
	}

	function view(event,rc,prc){

		prc.viewContract = contractService.read(rc.contractid);

		if (prc.viewContract.getContractID() neq 0){
			event.renderData(type="json", data=prc.viewContract, statusCode=200, statusMessage="Contract found");
		}
		else {
			event.renderData(type="json", data=prc.viewContract, statusCode=404, statusMessage="Contract not found")
		}
	}

	function save(event,rc,prc){

		var contract = populateModel("contract");

		prc.response = contractService.save(contract);

		if (prc.response){
			event.renderData(type="json", data=prc.response, statusCode = 200, statusMessage="Contract saved");
		}
		else {
			event.renderData(type="json", data=prc.response, statusCode=500, statusMessage="An error occurred")
		}
	}

	function remove(event,rc,prc){

		prc.response = contractService.delete(rc.contractid);

		if (prc.response){
 			event.renderData(type="json", data=prc.response, statusCode="200", statusMessage="Contract deleted.");
 		}
 		else {
 			event.renderData(type="json", data=prc.response, statusCode="500", statusMessage="An error occurred");
 		}
	}
}