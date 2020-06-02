({
	navToRecord : function(component, event, helper) {
		var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.property.Id")
        });
        navEvt.fire();
	},
    
    editRecord : function(component, event, helper) {
        /*var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": component.get("v.property.Id")
        });
        editRecordEvent.fire();*/ 
        helper.showHide(component);
    },
    
    handleSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The property's info has been updated.",
            "type": "success"
        });
        toastEvent.fire();
        helper.showHide(component);
    },
    
    handleCancel : function(component, event, helper) {
        helper.showHide(component);
        event.preventDefault();
    }

})