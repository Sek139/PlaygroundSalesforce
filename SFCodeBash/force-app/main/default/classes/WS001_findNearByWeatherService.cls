public with sharing class WS001_findNearByWeatherService{
	public final static String USERNAME  = 'testdlapi';
	public static HttpResponse getCurrentLocationWeather(Double lat, Double lng){
		HttpRequest req = new HttpRequest();
		if (!Test.isRunningTest()) {
			req.setEndpoint('callout:findNearByWeatherService?lat=' + lat + '&lng=' + lat + '&username=' + USERNAME);
		}else {
			req.setEndpoint('callout:test?lat=' + lat + '&lng=' + lat + '&username=' + USERNAME);
		}
		
		req.setMethod('GET');
		Http http = new Http();
		HTTPResponse res = http.send(req);
		return res;
	}
   
}