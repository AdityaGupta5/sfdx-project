({
	clickCreateItem : function(component, event, helper) {
        var isFormValid = component.find("campingItemForm").reduce(function(isValid, inputCmp) {
        	inputCmp.showHelpMessageIfInvalid();
            return isValid && inputCmp.get("v.validity").valid;
        });	
        if(isFormValid) {
            var newCampingItem = component.get("v.newItem");
            helper.createItem(component, newCampingItem);
        }
	},
    
    doInit :  function(component, event, helper) {
        var action = component.get("c.getItems");  
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            	component.set("v.items", response.getReturnValue());    
            }    
        });
        $A.enqueueAction(action);
    },
    
    handleAddItem : function(component, event, helper) {
        var itemEvent = event.getParam("item");
        //helper.createItem(component, itemEvent);
        var action = component.get("c.saveItem");
		var campings = component.get("v.items");
        console.log("Before******* " + campings);
		campings.push(itemEvent);
        component.set("v.items",campings);
		console.log("After ##### " + campings);
        action.setParams({"campingItem":itemEvent});
        action.setCallback(this,function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                console.log('save');
            }
        });
        $A.enqueueAction(action); 
    }
})