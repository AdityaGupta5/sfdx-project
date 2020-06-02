({
	doInit : function(component, event, helper) {
		console.log('window.location.origin -=-=-=-=<> ' + window.location.origin);
        console.log('event -=-=-=-=<> ' + event);
        
        component.set("v.vfBaseURL", window.location.origin);
        component.set('v.srcIFrame' , window.location.origin +'/apex/Proxy_CalculatorAsyncPage');
        console.log('######### ' + component.get('v.srcIFrame'));
        window.addEventListener("message", function (event, component) {
            //debugger;
            if(!event.data.isEddie && event.data.uniqueId) {
                console.log("Async callout response received: " + event.data.methodName + "_" + event.data.uniqueId);
                var callBackEvent = $A.get("e.c:Calculator_CallBackWSAsyncEvent");
                callBackEvent.setParams({
                    "result"        : event.data.response,
                    "UniqueId"      : event.data.uniqueId,
                    "methodName"    : event.data.methodName});
                callBackEvent.fire();
            }
        }, false);
	},
    
    callCalculatorWSAsync : function(component, event, helper) {
		console.log('Inside  callCalculatorWSAsync -=-=-=-=<> ');	
        var vfBaseURL = component.get("v.vfBaseURL");
        var UniqueId = event.getParam("UniqueId");
        var methodName = event.getParam("methodName");
        var methodParams = event.getParam("methodParams");
        
        console.log("Async callout request received: " + methodName);
        
        var message = {
            uniqueId        : UniqueId,
            methodName      : methodName,
            methodParams    : methodParams.toString()
        };
        
        var vf = component.find("vfFrame").getElement().contentWindow;
        
        try{
            vf.postMessage(message, vfBaseURL);
            console.log('** message to send '+message)
            console.log("postMessage sent: " + methodName + "_" + message.uniqueId);
        }catch(e){
            console.log("Error sending postMessage: " + e.toString());
        }
	}
})