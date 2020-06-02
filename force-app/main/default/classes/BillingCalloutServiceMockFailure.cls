@isTest
public class BillingCalloutServiceMockFailure Implements WebServiceMock {
   
    public void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint, String soapAction, 
                         String requestName, String responseNS, String responseName, String responseType) 
    {
        BillingServiceProxy.billProjectResponse_element responseElement = new BillingServiceProxy.billProjectResponse_element();
        responseElement.status = 'UNAUTHORIZED';
        response.put('response_x', responseElement);
    }
}