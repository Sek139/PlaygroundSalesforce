public with sharing class LWCC_getWeatherDetails{
	@AuraEnabled
	public location location;
	public class location{
		@AuraEnabled
		public Double lat;
		@AuraEnabled
		public Double lng;
	}

	/**
	 * checkWeather description
	 *
	 * ## lat (Double): lat
	 * ## lng (Double): lng
	 * @@ Return WRP001_findNearByWeatherService: Return description
	 */
	@AuraEnabled(cacheable = true)
	public static WRP001_findNearByWeatherService checkWeather(Double lat, Double lng){
		String jsonBody = '';
		WRP001_findNearByWeatherService weather = null;

		HttpResponse res = WS001_findNearByWeatherService.getCurrentLocationWeather(lat, lng);
		switch on res.getStatusCode(){

			when 200{
				jsonBody = res.getBody();
				System.debug(jsonBody);
				if (jsonBody.contains('status')){
					WRP001_FindNearByWtherServiceError status = null;
					status = (WRP001_FindNearByWtherServiceError)System.JSON.deserialize(jsonBody, WRP001_FindNearByWtherServiceError.class);
					throw new AuraHandledException(status.status.message);

				} else{
					weather = (WRP001_findNearByWeatherService)System.JSON.deserialize(jsonBody, WRP001_findNearByWeatherService.class);

				}
			}
			when else{
				throw new AuraHandledException('error');

			}
		}
		return weather;
	}

	@AuraEnabled
	public static LWCC_getWeatherDetails.location getlocation(String recordId){
		LWCC_getWeatherDetails.location lc = new LWCC_getWeatherDetails.location();
		String query = 'SELECT location__Longitude__s,location__Latitude__s FROM Account WHERE Id =:recordId';
		List<Account> lsobj = Database.query(query);
		if (!lsobj.isEmpty()){
			for (Account s : lsobj){
				if (s.location__Longitude__s != null)
					lc.lng = s.location__Longitude__s;
				if (s.location__Latitude__s != null)
					lc.lat = s.location__Latitude__s;
			}
		}
		return lc;
	}

	@AuraEnabled
	public static LWCC_getWeatherDetails.location getUserlocation(String recordId){
		LWCC_getWeatherDetails.location lc = new LWCC_getWeatherDetails.location();
		String query = 'SELECT location__Longitude__s,location__Latitude__s FROM User WHERE Id =:recordId';
		List<User> lsobj = Database.query(query);
		if (!lsobj.isEmpty()){
			for (User s : lsobj){
				if (s.location__Longitude__s != null)
					lc.lng = s.location__Longitude__s;
				if (s.location__Latitude__s != null)
					lc.lat = s.location__Latitude__s;
			}
		}
		return lc;
	}

	@AuraEnabled
	public static void senEmailtoOrgUsers(String JsonBody){
		System.debug(JsonBody);
		WRP001_findNearByWeatherService.weatherObservation weather = (WRP001_findNearByWeatherService.weatherObservation)System.JSON.deserialize(JsonBody, WRP001_findNearByWeatherService.weatherObservation.class);
		System.debug((WRP001_findNearByWeatherService.weatherObservation)System.JSON.deserialize(JsonBody, WRP001_findNearByWeatherService.weatherObservation.class));
		System.debug(weather);
		List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
		List<User> lUsers = new List<User>();
		lUsers = [SELECT Id, Email
		          FROM User
		          ORDER BY CreatedDate DESC
		          LIMIT 10];
		if (!lUsers.isEmpty()){
			for (User u : lUsers){
				if (String.isNotBlank(u.Email)){
					Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
					List<String> sendTo = new List<String>();
					if (validateEmail(u.Email)){
						sendTo.add(u.Email);
					} else{
						throw new AuraHandledException('Malformed Email check the contact deatil ' + u.Name);
					}
					mail.setToAddresses(sendTo);
					mail.setReplyTo('noreply@yopmail.com');
					mail.setSenderDisplayName('Kyse');
					List<String> ccTo = new List<String>();
					ccTo.add('noreply@yopmail.com');
					mail.setCcAddresses(ccTo);
					mail.setSubject('Weather report');
					String body = '';
					String sBody = '';
					if (String.isNotBlank(weather.weatherCondition))
						body = 'weatherCondition :' + weather.weatherCondition;
					if (weather.humidity != null)
						body += ' humidity : ' + weather.humidity;
					if (String.isNotBlank(weather.windSpeed))
						body += ' windSpeed : ' + weather.windSpeed;
					if (String.isNotBlank(weather.temperature))
						body += ' temperature : ' + weather.temperature;
					mail.setHtmlBody(body);


					mails.add(mail);
				}

			}
			if (!Test.isRunningTest())
				Messaging.sendEmail(mails);
		}
	}

	@AuraEnabled
	public static void senEmailtoContactList(String JsonBody, String recordId){
		System.debug(JsonBody);
		WRP001_findNearByWeatherService.weatherObservation weather = (WRP001_findNearByWeatherService.weatherObservation)System.JSON.deserialize(JsonBody, WRP001_findNearByWeatherService.weatherObservation.class);
		System.debug((WRP001_findNearByWeatherService.weatherObservation)System.JSON.deserialize(JsonBody, WRP001_findNearByWeatherService.weatherObservation.class));
		System.debug(weather);
		List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
		List<Contact> lcontacts = new List<Contact>();
		lcontacts = [SELECT Id, Email, Name
		             FROM Contact
		             WHERE AccountId = :recordId
		             ORDER BY CreatedDate DESC
		             LIMIT 10];
		if (!lcontacts.isEmpty()){
			for (Contact u : lcontacts){
				if (String.isNotBlank(u.Email)){
					Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
					List<String> sendTo = new List<String>();

					if (validateEmail(u.Email)){
						sendTo.add(u.Email);
					} else{
						throw new AuraHandledException('Malformed Email check the contact deatil ' + u.Name);
					}
					mail.setToAddresses(sendTo);
					mail.setReplyTo('noreply@yopmail.com');
					mail.setSenderDisplayName('Kyse');
					List<String> ccTo = new List<String>();
					ccTo.add('noreply@yopmail.com');
					mail.setCcAddresses(ccTo);
					mail.setSubject('Weather report');
					String body = '';
					String sBody = '';
					if (String.isNotBlank(weather.weatherCondition))
						body = 'weatherCondition :' + weather.weatherCondition;
					if (weather.humidity != null)
						body += ' humidity : ' + weather.humidity;
					if (String.isNotBlank(weather.windSpeed))
						body += ' windSpeed : ' + weather.windSpeed;
					if (String.isNotBlank(weather.temperature))
						body += ' temperature : ' + weather.temperature;
					mail.setHtmlBody(body);
					mails.add(mail);
				}

			}
			if (!Test.isRunningTest())
				Messaging.sendEmail(mails);
		}
	}

	public static Boolean validateEmail(String email){
		Boolean res = true;


		String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
		Pattern MyPattern = Pattern.compile(emailRegex);
		Matcher MyMatcher = MyPattern.matcher(email);

		if (!MyMatcher.matches())
			res = false;
		return res;
	}
}