({
    jsLoaded: function(component) {
        component.set("v.jsLoaded", true);
    },
    
    onPlotMapMarker : function (component, event, helper) {
        //Get lat and long from event params
        var lat = event.getParam('lat');
        var long = event.getParam('long');
        //Set lat and long to the location sObject attribute
        component.set('v.location', {
            lat : lat,
            long : long
        });
    }
})