({
    doInit : function(component, event, helper) {
        helper.onInit(component, event, helper);
    },
    
    onSave : function(component, event, helper) {
        component.find('service').saveRecord(function (saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                var boatReviewAddedEvent = component.getEvent('BoatReviewAdded');
                boatReviewAddedEvent.fire();
                var resultsToast = $A.get("e.force:showToast");
                if(resultsToast) {
                    resultsToast.setParams({
                        'title'  : 'Boat Review',
                        'message': 'Boat Review saved successfully!',
                        'type'   : 'Success',
                    });
                    resultsToast.fire();
                }
            } else if(saveResult.state === "INCOMPLETE") {
                var resultsToast = $A.get("e.force:showToast");
                if(resultsToast) {
                    resultsToast.setParams({
                        'title'  : 'Boat Review',
                        'message': 'User is offline, device doesn\'t support drafts',
                        'type'   : 'info',
                    });
                    resultsToast.fire();
                } else {
                    alert('User is offline, device doesn\'t support drafts');
                }
            } else if (saveResult.state === "ERROR") {
                var errMsg = "";
                var resultsToast = $A.get("e.force:showToast");
                if(resultsToast) {
                    for (var i = 0; i < saveResult.error.length; i++) {
                        errMsg += saveResult.error[i].message + "\n";
                    }
                    cmp.set("v.recordError", errMsg);
                    
                    resultsToast.setParams({
                        'title'  : 'Boat Review',
                        'message': 'Problem saving review, error: ' + JSON.stringify(saveResult.error),
                        'type'   : 'error',
                    });
                    resultsToast.fire();
                } else {
                    cmp.set("v.recordError", "");
                    alert('Problem saving review, error: ' + JSON.stringify(saveResult.error));
                }                
            } else {
                var resultsToast = $A.get("e.force:showToast");
                if(resultsToast) {
                    for (var i = 0; i < saveResult.error.length; i++) {
                        errMsg += saveResult.error[i].message + "\n";
                    }
                    cmp.set("v.recordError", errMsg);
                    resultsToast.setParams({
                        'title': 'Boat Review',
                        'message': 'Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error),
                        'type': 'error',
                    });
                    resultsToast.fire();
                } else {
                    cmp.set("v.recordError", "");
                    alert('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
                }
            }
        })    
    },
            
    onRecordUpdated : function(component, event, helper) {
        var recordUpdatedToast = $A.get("e.force:showToast");
        if(recordUpdatedToast) {
            recordUpdatedToast.setParams({
                'title'	 : 'Boat Review',
                'message': 'Boat Review has been updated!',
                'type'   : 'Success',
            });
            recordUpdatedToast.fire();
        } else {
            alert('Boat Review has been updated!');
        }    
    } 
})