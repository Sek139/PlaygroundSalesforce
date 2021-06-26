public with sharing class WRP001_findNearByWeatherService{
	@AuraEnabled
	public weatherObservation weatherObservation;
	public class weatherObservation{
		@AuraEnabled
		public String temperature;
		@AuraEnabled
		public Integer humidity;
		@AuraEnabled
		public String weatherCondition;
		@AuraEnabled
		public String windSpeed;
		@AuraEnabled
		public Double lat;
		@AuraEnabled
		public Double lng;
		@AuraEnabled
		public String cloudsCode;

	}
}