({
	doInit : function(component, event, helper) {
		var url = '/apex/ChatBotPage';	
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": url
        });
        urlEvent.fire();
	}
})