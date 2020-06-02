({
	onBoatSelected : function(component, event, helper) {
		var boat = event.getParam('boat');
        component.set('v.id', boat.Id);
        var service = component.find('service');
        service.reloadRecord();
        //component.find('service').reloadRecord();
	},
    
    onRecordUpdated : function(component, event, helper) {
    	component.find('boatReviews').refresh();    
    },
    
    onBoatReviewAdded : function(component, event, helper) {
        component.find("details").set("v.selectedTabId", "boatreviewtab");
		component.find('boatReviews').refresh();
    }
})