({
	doInit : function(component, event, helper) {
		helper.onInit(component, event, helper);	
	},
    
    onUserInfoClick : function (component, event, helper) {
        var userId = event.currentTarget.getAttribute('data-userid');
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            'recordId' : userId,
            'slideDevName': 'detail'
        });
        navEvt.fire();
    }
})