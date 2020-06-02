@isTest
public class ProjectCalloutServiceMockFailure implements HttpCalloutMock {
   
    public HttpResponse respond(HttpRequest httpReq) {
    	HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
    	response.setBody('{"status":"Failure"}');
        response.setStatusCode(500);
        return response;
    }
}