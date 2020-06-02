public class Proxy_CalculatorAsyncController {

    public String uniqueId {get; set;}
    public String methodName {get; set;}
    public String params {get; set;}
    
    public Proxy_CalculatorAsyncController() {
    	//Set headers for cross origin
        //String baseURL = 'https://akg005-superbadge-dev-ed.my.salesforce.com';
        String baseURL = System.URL.getSalesforceBaseURL().toExternalForm();
        System.debug('baseURL ===');
        Map<string,string> headers = Apexpages.currentPage().getHeaders();
        headers.put('X-Frame-Options', 'ALLOW-FROM ' + baseURL);
        headers.put('Content-Security-Policy', 'frame-ancestors ' + baseURL);    
    }
    
    public Continuation invoke() {
        system.debug('Async request invoked (Id:' + this.uniqueId + ', methodName:' + this.methodName + ')');
        Continuation cont = new Continuation(60);
        if(methodName.equalsIgnoreCase('Addition')) {
            
            return cont;
        }
        return null;
    }
}