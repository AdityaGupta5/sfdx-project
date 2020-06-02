({
    doInit : function(component, event, helper) {
        component.set('v.renderNewButton', $A.get('e.force:createRecord'));
        helper.getBoatTypeNames(component);
    },
    
    onSelectChange : function(component, event, helper) {
        console.log('-=-=-=-=> ' + component.find("boatTypes").get("v.value"));
        component.set("v.selectedBoatType", component.find("boatTypes").get("v.value"));
    },
    
    onFormSubmit : function(component, event, helper) {
    	var selectedBoatTypeId = component.get("v.selectedBoatType");  
        console.log('selectedBoatTypeId after Search =====<> ' + selectedBoatTypeId);
        var formSubmitEvent = component.getEvent("formsubmit");
        //var formSubmitEvent = $A.get("e.c:FormSubmit");
        formSubmitEvent.setParams({
            "formData": {"boatTypeId" : selectedBoatTypeId}
        });
        formSubmitEvent.fire();
    },
    
    newBoat : function(component, event, helper) {
        var selectedBoatTypeId = component.get("v.selectedBoatType"); 
        console.log('Selected Boat ID after Button Click ====> ' + selectedBoatTypeId);
        var createNewBoatEvent = $A.get('e.force:createRecord');
        createNewBoatEvent.setParams({
            "entityApiName": "Boat__c",
        })
        if(!$A.util.isEmpty(selectedBoatTypeId)) {
            createNewBoatEvent.setParams({
                'defaultFieldValues' : {
                    'BoatType__c': selectedBoatTypeId
                }
            });      
        } 
        createNewBoatEvent.fire();
    },
    
    /*handleNewBoatForm : function(component, event, helper) {
        var createNewBoatEvent = $A.get('e.force:createRecord');
        var selectedBoatTypeId = component.get("v.selectedBoatType"); 
        createNewBoatEvent.setParams({
            "entityApiName": "Boat__c",
        })
        if(!$A.util.isEmpty(selectedBoatTypeId)) {
            createNewBoatEvent.setParams({
                'defaultFieldValues' : {
                    'BoatType__c': selectedBoatTypeId
                }
            });      
        } 
        createNewBoatEvent.fire();
    }*/
})