import { LightningElement, track, api } from 'lwc';
import checkWeather from '@salesforce/apex/LWCC_getWeatherDetails.checkWeather';
import getlocation from '@salesforce/apex/LWCC_getWeatherDetails.getlocation';
import getUserlocation from '@salesforce/apex/LWCC_getWeatherDetails.getUserlocation';
import senEmailtoOrgUsers from '@salesforce/apex/LWCC_getWeatherDetails.senEmailtoOrgUsers';
import senEmailtoContactList from '@salesforce/apex/LWCC_getWeatherDetails.senEmailtoContactList';
import weatherImages from '@salesforce/resourceUrl/svgresources';

import Id from '@salesforce/user/Id';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Lwc_getWeatherInfo extends LightningElement {

    @track mapMarkers = [];
    zoomLevel = 10;
    @track result;
    @api latitude;
    @api longitude;
    @api latitudeApp;
    @api longitudeApp;
    @api objectApiName;
    @api recordId;
    @api isUser;

    cloudy = weatherImages + '/animated/cloudy.svg';
    rainy = weatherImages + '/animated/rainy-1.svg';
    snowy = weatherImages + '/animated/snowy-6.svg';
    sunny = weatherImages + '/animated/day.svg';




    connectedCallback() {
        if (this.objectApiName) {
            getlocation({ recordId: this.recordId }).then(data => {
                if (data.lat && data.lng) {
                    this.latitude = data.lat;
                    this.longitude = data.lng;
                    checkWeather({ lat: this.latitude, lng: this.longitude }).then(data => {
                        this.mapMarkers = [{
                            location: {
                                Latitude: data.weatherObservation.lat,
                                Longitude: data.weatherObservation.lng
                            },
                            title: data.weatherObservation.lat + ', ' + data.weatherObservation.lng,
                        }];
                        this.result = data.weatherObservation;
                    }).catch(error => {
                        if (error) {
                            // UI API read operations return an array of objects
                            if (Array.isArray(error.body)) {
                                this.error = error.body.map(e => e.message).join(', ');
                                const evt = new ShowToastEvent({
                                    title: this.error,
                                    message: this.error,
                                    variant: 'error',
                                });
                                this.dispatchEvent(evt);
                            }
                            // UI API write operations, Apex read and write operations 
                            // and network errors return a single object
                            else if (typeof error.body.message === 'string') {
                                this.error = error.body.message;
                                const evt = new ShowToastEvent({
                                    title: this.error,
                                    message: this.error,
                                    variant: 'error',
                                });
                                this.dispatchEvent(evt);
                            }
                        }
                    });
                } else {
                    const evt = new ShowToastEvent({
                        title: 'no value',
                        message: 'no lat and long on Account',
                        variant: 'warning',
                    });
                    this.dispatchEvent(evt);
                }

            }).catch(err => console.log(err));
        } else if (this.isUser === true) {
            var userId = Id;
            getUserlocation({ recordId: userId }).then(data => {
                if (data.lat && data.lng) {
                    this.latitude = data.lat;
                    this.longitude = data.lng;

                    checkWeather({ lat: this.latitude, lng: this.longitude }).then(data => {
                        this.mapMarkers = [{
                            location: {
                                Latitude: data.weatherObservation.lat,
                                Longitude: data.weatherObservation.lng
                            },
                            title: data.weatherObservation.lat + ', ' + data.weatherObservation.lng,
                        }];
                        this.result = data.weatherObservation;
                    }).catch(error => {
                        console.log(error);
                        if (error) {
                            // UI API read operations return an array of objects
                            if (Array.isArray(error.body)) {
                                this.error = error.body.map(e => e.message).join(', ');
                                const evt = new ShowToastEvent({
                                    title: this.error,
                                    message: this.error,
                                    variant: 'error',
                                });
                                this.dispatchEvent(evt);
                            }
                            // UI API write operations, Apex read and write operations 
                            // and network errors return a single object
                            else if (typeof error.body.message === 'string') {
                                this.error = error.body.message;
                                const evt = new ShowToastEvent({
                                    title: this.error,
                                    message: this.error,
                                    variant: 'error',
                                });
                                this.dispatchEvent(evt);
                            }
                        }
                    }
                    );
                } else {
                    const evt = new ShowToastEvent({
                        title: 'no value',
                        message: 'no lat and long on user',
                        variant: 'warning',
                    });
                    this.dispatchEvent(evt);
                }

            }).catch(error => {
                if (error) {
                    // UI API read operations return an array of objects
                    if (Array.isArray(error.body)) {
                        this.error = error.body.map(e => e.message).join(', ');
                        const evt = new ShowToastEvent({
                            title: this.error,
                            message: this.error,
                            variant: 'error',
                        });
                        this.dispatchEvent(evt);
                    }
                    // UI API write operations, Apex read and write operations 
                    // and network errors return a single object
                    else if (typeof error.body.message === 'string') {
                        this.error = error.body.message;
                        this.error = error.body.map(e => e.message).join(', ');
                        const evt = new ShowToastEvent({
                            title: this.error,
                            message: this.error,
                            variant: 'error',
                        });
                        this.dispatchEvent(evt);
                    }
                }
            });

        } else if (this.latitudeApp && this.longitudeApp) {
            checkWeather({ lat: this.latitudeApp, lng: this.longitudeApp }).then(data => {
                this.mapMarkers = [{
                    location: {
                        Latitude: data.weatherObservation.lat,
                        Longitude: data.weatherObservation.lng
                    },
                    title: data.weatherObservation.lat + ', ' + data.weatherObservation.lng,
                }];
                this.result = data.weatherObservation;
            }).catch(error => {
                console.log(error);
                if (error) {
                    // UI API read operations return an array of objects
                    if (Array.isArray(error.body)) {
                        this.error = error.body.map(e => e.message).join(', ');
                        const evt = new ShowToastEvent({
                            title: this.error,
                            message: this.error,
                            variant: 'error',
                        });
                        this.dispatchEvent(evt);
                    }
                    // UI API write operations, Apex read and write operations 
                    // and network errors return a single object
                    else if (typeof error.body.message === 'string') {
                        this.error = error.body.message;
                        const evt = new ShowToastEvent({
                            title: this.error,
                            message: this.error,
                            variant: 'error',
                        });
                        this.dispatchEvent(evt);
                    }
                }
            }
            );
        }

    }


    sendEmailUsers() {
        console.log(this.result);
        senEmailtoOrgUsers({ JsonBody: JSON.stringify(this.result) }).then(data => {
            const evt = new ShowToastEvent({
                title: 'Success',
                message: 'the report has been sent to the org users!',
                variant: 'success',
            });
            this.dispatchEvent(evt);
        }).catch(error => {
            if (error) {
                // UI API read operations return an array of objects
                if (Array.isArray(error.body)) {
                    this.error = error.body.map(e => e.message).join(', ');
                    const evt = new ShowToastEvent({
                        title: this.error,
                        message: this.error,
                        variant: 'error',
                    });
                    this.dispatchEvent(evt);
                }
                // UI API write operations, Apex read and write operations 
                // and network errors return a single object
                else if (typeof error.body.message === 'string') {
                    this.error = error.body.message;
                    const evt = new ShowToastEvent({
                        title: this.error,
                        message: this.error,
                        variant: 'error',
                    });
                    this.dispatchEvent(evt);
                }
            }


        });
    }

    sendEmailContacts() {
        console.log(this.result);
        senEmailtoContactList({ JsonBody: JSON.stringify(this.result), recordId: this.recordId }).then(data => {
            const evt = new ShowToastEvent({
                title: 'Success',
                message: 'the report has been sent to the contact list',
                variant: 'success',
            });
            this.dispatchEvent(evt);
        }).catch(error => {
            if (error) {
                // UI API read operations return an array of objects
                if (Array.isArray(error.body)) {
                    this.error = error.body.map(e => e.message).join(', ');
                    const evt = new ShowToastEvent({
                        title: this.error,
                        message: this.error,
                        variant: 'error',
                    });
                    this.dispatchEvent(evt);
                }
                // UI API write operations, Apex read and write operations 
                // and network errors return a single object
                else if (typeof error.body.message === 'string') {
                    this.error = error.body.message;
                    this.error = error.body.map(e => e.message).join(', ');
                    const evt = new ShowToastEvent({
                        title: this.error,
                        message: this.error,
                        variant: 'error',
                    });
                    this.dispatchEvent(evt);
                }
            }

        });
    }


    get gethumidity() {
        if (this.result) {
            console.log(this.result);
            console.log(this.result.humidity);
            return this.result.humidity;
        } else {
            return 0;
        }
    }

    get getweatherCondition() {
        if (this.result) {
            return this.result.weatherCondition;
        } else {
            return '---';

        }
    }
    get getwindSpeed() {
        if (this.result) {
            return this.result.windSpeed;
        } else {
            return '---';

        }
    }
    get gettemperature() {
        if (this.result) {
            return this.result.temperature;
        } else {
            return '---';

        }
    }
    get getimages() {
        if (this.result.cloudsCode) {
            switch (this.result.cloudsCode) {
                case 'FEW':
                    return this.cloudy
                case 'RA':
                    return this.rainy
                case 'SN ':
                    this.snowy
                    break;
                case 'CLR':
                    return this.sunny
                case 'SCT':
                    return this.cloudy
                default:
                    return this.sunny
            }

        }
    }

}