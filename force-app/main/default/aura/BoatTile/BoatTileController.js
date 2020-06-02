({
	onBoatClick : function(component, event, helper) {
		var boat = component.get('v.boat');	
        var boatId = boat.Id
        var boatSelectEvent = component.getEvent('v.BoatSelect');
        boatSelectEvent.setParams({
            boatId : boatId
        });
        boatSelectEvent.fire();
        
        //var boatSelectedEvent = $A.get('e.c:BoatSelected'); // Another way to create an instance of event.
        
        var boatSelectedEvent = component.getEvent('v.BoatSelected');
        boatSelectedEvent.setParams({
            boat : boat
        });
        boatSelectedEvent.fire();
        
        //Get boat name, latitude, and longitude. Pass data as parameters. Fire the event.
        var label = boat.Name;
        var lat = boat.Geolocation__latitude__s;
        var long = boat.Geolocation__longitude__s;
        //var plotMapMarkerEvent = component.getEvent('v.plotMapMarker');
        var plotMapMarkerEvent = $A.get("e.c:PlotMapMarker");
        plotMapMarkerEvent.setParams({
            'sObjectId' : boatId,
            'lat' : lat,
            'long' : long,
            'label' : label
        });
        plotMapMarkerEvent.fire();
	}
})