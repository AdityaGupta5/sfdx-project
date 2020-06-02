({
    afterScriptsLoaded : function (component, event, helper) {
        //Get dom element of rating area
        var domEl = component.find('ratingarea').getElement();
        //Get value attribute of component
        var currentRating = component.get('v.value');
        //Get readonly attribute of component
        var readOnly = component.get('v.readonly');
        
        var maxRating = 5;
        var callback = function(rating) {
            component.set('v.value',rating);
        }
        component.ratingObj = rating(domEl,currentRating,maxRating,callback,readOnly);
        
    },
    
    onValueChange : function(component,event,helper) {
        if (component.ratingObj) {
            var value = component.get('v.value');
            component.ratingObj.setRating(value,false);
        }
    }
})