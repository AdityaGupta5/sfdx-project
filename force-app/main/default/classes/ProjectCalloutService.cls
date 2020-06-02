public class ProjectCalloutService {
    //Complete the implementation for business and callout logic
    @InvocableMethod(label='Post Opportunity To PMS')
	public static void postOpportunityToPMS(List<Id> OpptyIds){
        System.debug('OpptyIds from Process Builder ===> ' + OpptyIds);
        if(OpptyIds != Null & !OpptyIds.isEmpty()) {
        	System.enqueueJob(new QueueablePMSCall(OpptyIds[0]));  
        }   
    }
    
    public class QueueablePMSCall implements Queueable, Database.AllowsCallouts {

        public Id OppId;
        public QueueablePMSCall(Id OpptyId) {
            this.OppId = OpptyId;   
        }
        public void execute(System.QueueableContext qc) {
            System.debug('OpptyIds inside execute Method ===> ' + OppId);
            if(OppId != Null) {
                Opportunity oppty = [Select Id, Name, AccountId, Account.Name, CloseDate, Amount, StageName 
                                     From Opportunity 
                                     Where Id =: OppId];
                System.debug('oppty Records ##### ' + oppty);
                HttpResponse httpRes = getResponse(oppty);
                System.debug('httpRes !!!!!! ' + httpRes);
                if(httpRes.getStatusCode() == 201) {
                	oppty.StageName = 'Submitted Project';    
                } else {
                    oppty.StageName = 'Resubmit Project';
                }
                System.debug('oppty.StageName after Update ******' + oppty.StageName);
                Update oppty;
                System.debug('oppty after Update *#*#*# ' + oppty);
            }
                
        }
        
        private HttpResponse getResponse(Opportunity Oppty) {
            String token = ServiceTokens__c.getInstance('ProjectServiceToken').Token__c;
            Http http = new Http();
            HttpRequest httpReq = new HttpRequest();
            httpReq.setEndpoint('callout:ProjectService');
            httpReq.setHeader('token', token);
            httpReq.setHeader('Content-Type', 'application/json;charset=UTF-8');
            httpReq.setMethod('POST');
            httpReq.setBody(getOpptyJsonData(Oppty));
            System.debug('httpReq -=-=-=-=> ' + httpReq);
            System.debug('httpReq.toString()-=-=-=-=> ' + httpReq.toString());
            HttpResponse httpRes = http.send(httpReq);
            return httpRes;
        }
        
        private String getOpptyJsonData(Opportunity Oppty) {   
            return '{ ' +
                        '"opportunityId": "' + Oppty.Id + '", ' +
                        '"opportunityName": "' + Oppty.Name + '", ' +
                        '"accountName": "' + Oppty.Account.Name + '", ' +
                        '"closeDate": "' + Oppty.CloseDate + '", ' +
                        '"amount":' + Oppty.Amount +
                    '}';
        }
    }
}