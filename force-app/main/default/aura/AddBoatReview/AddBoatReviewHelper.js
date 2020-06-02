({
	onInit : function() {
		var service = component.find('service');
        service.getNewRecord(
            'BoatReview__c', //ObjectAPIName
            null, 			 // recordTypeId,
            false,          // skipCache
            $A.getCallback(function () {
            	var boatReview = component.get('v.boatReview');
                var recordError = component.get('v.recordError');
                if (recordError || boatReview === null) {
                    console.log('Error initializing review template: ' + recordError);
                    return;
                } else {
                    boatReview.Boat__c = component.get('v.boat').Id;
                    component.set('v.boatReview', boatReview);
                }
            })
            
        )	
	}
})