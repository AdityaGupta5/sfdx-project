({
	onFormSubmit : function(component, event, helper) {
		var boatTypeId = event.getParam('formData').boatTypeId;
        console.log('boatTypeId From Event ====>>> ' + boatTypeId);
        var boatSearchResult = component.find('boatSearchResult');
        console.log('boatSearchResult ====>>> ' + boatSearchResult);
        boatSearchResult.search(boatTypeId);
	}
})