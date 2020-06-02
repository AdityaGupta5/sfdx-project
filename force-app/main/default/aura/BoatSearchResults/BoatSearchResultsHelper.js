({
    onSearch : function(component, event) {
        var boatTypId = component.get("v.boatTypeId");
        console.log('boatTypId onSearch ====> ' + boatTypId);
        var action = component.get("c.getBoats");
        action.setParams({boatTypeId:boatTypId});
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log("state " + state);
            if(state === "SUCCESS"){
                var res = response.getReturnValue();
                component.set("v.boats", res);
            }
            else{
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    }
})