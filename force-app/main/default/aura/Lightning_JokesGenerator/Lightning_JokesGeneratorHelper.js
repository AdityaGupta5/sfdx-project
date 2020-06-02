({
	handleAjaxRequest : function(component, event, helper) {
        debugger;
		var xhr = new XMLHttpRequest();
        var number = component.get('v.number');
        var url = 'http://api.icndb.com/jokes/random/' + number;
        xhr.open('GET', url, true);
        xhr.onload = function() {
            if(xhr.status === 200) {
                var response = JSON.parse(xhr.responseText);
                var output = '<ul class=\'slds-list--dotted\'>';
                if(response.type === 'success') {
                    response.value.forEach(function(joke){
                        output += '<li>${joke.joke}</li>';
                    });    
                }
                output += '</ul>';
                component.set('v.html', output);
            }  
        };
        xhr.send();
	}
})