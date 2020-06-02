({
	doSearch : function(component, event, helper) {
        var eventParam = event.getParam('arguments');
        Console.log('eventParam ====>> ' + eventParam);
        if(eventParam) {
            var boatTypeId = eventParam.boatTypeId;
            Console.log('eventParam boatTypeId====>> ' + boatTypeId);
            component.set('v.boatTypeId', boatTypeId);
            helper.onSearch(component);
        }	
	},
    
    onBoatSelect : function(component, event, helper) {
        var boatId = event.getParam('boatId');
        component.set('v.selectedBoatId', boatId);
    }
})