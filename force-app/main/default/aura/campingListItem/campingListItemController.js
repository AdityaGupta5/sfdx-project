({
	packItem : function(component, event, helper) {
        //var btnClicked = event.getSource().get("v.label"); 
		var btnClick = component.find('btnId');
        console.log('btnClick ====> ' + btnClick);
        btnClick.set('v.disabled',true);
        component.set('v.item.Packed__c', 'true');
	}
})