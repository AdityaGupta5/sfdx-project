({
	handleClick  : function(component, event, helper) {
        debugger;
		var number = component.find('number').get('v.value');
        if (number) {
            component.set('v.number', number);
            helper.handleAjaxRequest(component, event, helper);
        }
	}
})