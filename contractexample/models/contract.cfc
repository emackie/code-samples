/**
*
* @file  /contract/models/contract.cfc
* @author Ewan Mackie
* @description Contract Domain Object
*
*/

component output="false" displayname="contractBean" accessors="true" {

	property name="contractId" type="numeric" default=0;
	property name="serviceID" type="string" default = "";
	property name="serviceName" type="string" default="";
	property name="serviceType" type="numeric" default=0;
	property name="startDate" type="string" default="";
	property name="closeDate" type="string" default="";
	property name="provider" type="string" default=0;

	public function init(
		required numeric contractId = 0,
		required string serviceId = "",
		required string serviceName = "",
		required numeric serviceType = 0,
		required string startDate = "",
		required string closeDate = "",
		required string provider = 0
	)
	{
		variables.contractId = arguments.contractId;
		variables.serviceID = arguments.serviceID;
		variables.serviceName = arguments.serviceName;
		variables.serviceType = arguments.serviceType;
		variables.startDate = arguments.startDate;
		variables.closeDate = arguments.closeDate;
		variables.provider = arguments.provider;

		return this;
	}

	public function getServiceActive(required date dateToTest){

		//Checks the service is active on a particular date - used for validation.

		boolActive = "";

		if (dateToTest gt variables.startDate and dateToTest lt variables.closeDate){

			boolActive = true;
		}
		else {

			boolActive = false;
		}

		return boolActive
	}
}