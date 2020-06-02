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
	}
})