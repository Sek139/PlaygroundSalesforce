@istest
public with sharing class LWCC_getWeatherDetails_TEST{
	@istest
	static void checkWeatherTest(){
		Test.setMock(HttpCalloutMock.class, new WS001_Mock());
		test.startTest();
		LWCC_getWeatherDetails.checkWeather(12, 21);
		test.stopTest();
	}

	@istest
	static void getlocationTest(){
		Test.setMock(HttpCalloutMock.class, new WS001_Mock());
		String JSON = '{"weatherObservation":{"elevation":445,"lng":43.63333333333333,"weatherConditionCode":"-TSRA","observation":"URMN 021930Z 03001MPS 9999 -TSRA SCT010 OVC023CB 15/14 Q1011 R24/110060 NOSIG RMK MT OBSC QFE722","ICAO":"URMN","clouds":"scattered clouds","dewPoint":"14","cloudsCode":"SCT","datetime":"2021-06-02 19:30:00","countryCode":"RU","temperature":"15","humidity":93,"stationName":"Nalchik","weatherCondition":"light thunderstorm rain","windDirection":30,"hectoPascAltimeter":1011,"lat":43.516666666666666}}';

		Account acct = new Account(Name = 'accountName', location__Longitude__s = 12, location__Latitude__s = 13);
		insert acct;
		Contact cont = new Contact(FirstName = 'accountName', LastName = 'test', AccountId = acct.id, Email = 'test@yopmail.com');
		insert cont;
		test.startTest();
		LWCC_getWeatherDetails.getlocation(acct.Id);
		LWCC_getWeatherDetails.senEmailtoContactList(JSON, acct.Id);

		test.stopTest();
	}

	@istest
	static void getUserlocationTest(){
		Test.setMock(HttpCalloutMock.class, new WS001_Mock());
		String JSON = '{"weatherObservation":{"elevation":445,"lng":43.63333333333333,"weatherConditionCode":"-TSRA","observation":"URMN 021930Z 03001MPS 9999 -TSRA SCT010 OVC023CB 15/14 Q1011 R24/110060 NOSIG RMK MT OBSC QFE722","ICAO":"URMN","clouds":"scattered clouds","dewPoint":"14","cloudsCode":"SCT","datetime":"2021-06-02 19:30:00","countryCode":"RU","temperature":"15","humidity":93,"stationName":"Nalchik","weatherCondition":"light thunderstorm rain","windDirection":30,"hectoPascAltimeter":1011,"lat":43.516666666666666}}';
		Profile p = [SELECT Id
		             FROM Profile
		             WHERE Name = 'Standard User'];
		User u = new User(Alias = 'test', Email = 'test@testorg.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'standarduser@testorg.com.invalid',location__Longitude__s = 22, location__Latitude__s=23);
		insert u;
		test.startTest();
		LWCC_getWeatherDetails.getUserlocation(u.Id);
		LWCC_getWeatherDetails.senEmailtoOrgUsers(JSON);

		test.stopTest();
	}
}