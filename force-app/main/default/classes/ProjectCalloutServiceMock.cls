@isTest
public class ProjectCalloutServiceMock implements HttpCalloutMock {
    
    public HttpResponse respond(HttpRequest httpReq) {
    	HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        //response.setBody('[{"opportunityId": "00641000004EKmFAAW","opportunityName": "Super-Duper Big Deal","accountName": "ACME Corp, Inc.","closeDate": "2016-10-30","amount": 150000}]');
    	response.setBody('{"status":"Success"}');
        response.setStatusCode(201);
        return response;
    }
   
}