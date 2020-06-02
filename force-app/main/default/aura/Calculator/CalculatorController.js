({
	doInit : function(component, event, helper) {
		var id = helper.getUniqueId();
        console.log('unique id : '+id);	
        component.set('v.UniqueId' , id);
	},
    
    callback :  function(component, event, helper) {
        if(event.getParam('methodName')==='Addition' && event.getParam('UniqueId')===component.get('v.UniqueId')) {
        	console.log('Inside CallBack =-=-=-=-<>');    
        }    
    },
    
    doAddition : function(component, event, helper) {
		var num1 = component.find('num1');	
        var num1Value = num1.get('v.value');
        console.log('num1Value ===> ' + num1Value);
        var num2 = component.find('num2');
        var num2Value = num2.get('v.value');
        console.log('num2Value ===> ' + num2Value);
        if ($A.util.isEmpty(num1Value)){
            num1.set('v.validity', {valid:false, badInput :true});
            num1.showHelpMessageIfInvalid();   
        } else if ($A.util.isEmpty(num2Value)){
            num2.set('v.validity', {valid:false, badInput :true});
            num2.showHelpMessageIfInvalid();   
        } else {
            //console.log('Hello');
            var methodName = 'Addition';
            var methodParams = {
                num1	:  num1Value,
                num2	:  num2Value
            };
            var param = JSON.stringify(methodParams);
            console.log('*** param: '+param);  
            console.log('Unique ID =====> ' + component.get('v.UniqueId'));
            var callEvent = $A.get("e.c:Calculator_CallWSAsyncEvent");
            callEvent.setParams({
                "methodName"   : methodName,
                "methodParams" : [param],
                "UniqueId"     : component.get('v.UniqueId') });
            console.log('callEvent: ****** :'+callEvent);
            setTimeout(function(){
                callEvent.fire();    
            },2000);
        }
	},
    
    doSubtraction : function(component, event, helper) {
		
	},
    
    doMultipy : function(component, event, helper) {
		
	},
    
    doDivide : function(component, event, helper) {
		
	},
})