/**
*
* @file /contract/tests/specs/integration/ContractBDDTest.cfc
* @author Ewan Mackie
* @description BDD Tests for Contract Handlers
*
*/

component displayname="ContractBDDTest" extends="coldbox.system.testing.BaseTestCase" appMapping="/root" {

	function beforeAll(){
		super.beforeAll();
	}

	function afterAll(){
		super.afterAll();
	}

	function run(testResults, testBox){
		
		describe("Test CRUD methods for Contract Service", function(){

			beforeEach(function(currentSpec){
				setup();

				data = [
						{	
							contractid = 1,		
							serviceId = "a1",
							serviceName = "Test Service Number 1",
						 	serviceType = 1,
						 	startDate = "2015-01-01",
						 	closeDate = "2016-01-01",
						 	provider = 12615
						}
				];

				objContract = getModel(name="contract", initArguments = data[1]);
				serviceToTest = getModel("contractService");
			});

			describe("Testing my domain object", function(){
				
				it("should be populated with the data variable", function(){

					expect(objContract.getServiceID()).toBe("a1");

				});

				it("date outside service period should return active as false", function(){

					expect(objContract.getServiceActive("2014-03-31")).toBeFalse();
				});

				it("date within service period should return active as true", function(){

					expect(objContract.getServiceActive("2015-04-13")).toBeTrue();
				})

			});

			describe("Test CRUD Methods", function(){

				//Create a form with key for rest of functions to use

				describe("Test Insert", function(){
					it("should insert a new form through the save method", function(){

						returnedKey = serviceToTest.save(objContract);

						expect(returnedKey).toBeGT(0);
					});

					describe("Remainder of methods using key generated from insert", function(){

						describe("Test Update", function(){
							it("saving with same contract id should perform update", function(){

								objContract.setContractID(returnedKey);

								//Change value of Service ID, to show a visible change
								objContract.setServiceID("a15");

								expect(serviceToTest.save(objContract)).toBeTrue();
							});
						});

						describe("Test Read", function(){
							it("Reading back contract with returnedKey should bring correct object", function(){

								objReturnedContract = serviceToTest.read(returnedKey);

								expect(objReturnedContract.getContractID()).toBe(returnedKey);
							});

							it("Retrieving contract id 0 should return empty object", function(){

								objReturnedContract = serviceToTest.read(0);

								expect(objReturnedContract.getContractID()).toBe(0);
							});
						});

						describe("Test Filter", function(){

							it("Calling list function should return 1 record", function(){

								qList = serviceToTest.list();

								expect(qList.recordCount).toBe(1);
							});

							it("Search for 'service' string should return 1 record", function(){

								qSearch = serviceToTest.filterName("service");

								expect(qSearch.recordCount).toBe(1);
							});

							it("Search for 'blah' string should return no records", function(){

								qSearch = serviceToTest.filterName("blah");

								expect(qSearch.recordCount).toBe(0);
							});
						});

						describe("Test Delete", function(){

							it("delete form should return true response", function(){

								expect(serviceToTest.delete(returnedKey)).toBeTrue();
							});

							it("retrieving inserted form now returns empty object", function(){

								objReturnedContract = serviceToTest.read(returnedKey);

								expect(objReturnedContract.getContractID()).toBe(0);
							});
						});
					});					
				});
			});
		});
	}
}