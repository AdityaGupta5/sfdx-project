({
	doInit : function(component, event, helper) {
		component.set('v.showOnFullDetailsButton', $A.get("e.force:navigateToSObject"));	
	},
    
    onFullDetails : function(component, event, helper) {
    	var navigateToDetailPageEvt = $A.get("e.force:navigateToSObject");
        navigateToDetailPageEvt.setParams({
            "recordId"		: component.get('v.boat').Id,
            "slideDevName"	: "detail"
        });
        navigateToDetailPageEvt.fire();
    }
})