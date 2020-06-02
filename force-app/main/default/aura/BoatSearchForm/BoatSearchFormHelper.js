({
    getBoatTypeNames : function(component) {
        var action = component.get("c.getBoatTypes");
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                console.log('====response value =====> ' + response.getReturnValue());
                component.set("v.boatTypes", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);	
    }
})