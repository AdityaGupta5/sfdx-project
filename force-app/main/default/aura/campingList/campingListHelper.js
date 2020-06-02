({
    createItem : function(component, newCampingItem) {
        var newCampingItemAction = component.get("c.saveItem");
        newCampingItemAction.setParams({
            "campingItem": component.get("v.newItem")
        });
        newCampingItemAction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var campings = component.get("v.items");
                campings.push(response.getReturnValue());
                component.set("v.items",campings);
                //component.set("v.newItem", {'sobjectType': 'Camping_Item__c','Name':'','Quantity__c': 0,'Price__c': 0, 'Packed__c': false});
            }
        });
        $A.enqueueAction(newCampingItemAction);	
    }
})