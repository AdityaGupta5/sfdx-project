@isTest
private class ProjectCalloutServiceTest {
    
    @testSetup static void testDataSetup() {
    	ServiceTokens__c serviceToken = new ServiceTokens__c(Name = 'ProjectServiceToken', Token__c = '06d58d57-5c0d-47c8-a7f5-b7a3320a759e');
        Insert serviceToken;
        List<Opportunity> opportunityList = new List<Opportunity>();
        for(Integer i=0; i<200; i++) {
            opportunityList.add(new Opportunity(Name='Test Oppty ' + i, StageName='Closed Won', CloseDate= Date.today().addYears(1), Discount_Percent__c = 10));
        }
        Insert opportunityList;
    }
    
    @isTest static void testCalloutSuccess() {
    
        Opportunity oppty = [Select Id, Name, AccountId, Account.Name, CloseDate, Amount, StageName, Discount_Percent__c From Opportunity Where Name =: 'Test Oppty 1' Limit 1];
        Test.startTest();
        	Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
        	ProjectCalloutService.postOpportunityToPMS(new List<id>{oppty.Id});
        Test.stopTest();
    }
    
    @isTest static void testCalloutFailure() {
    	Opportunity oppty = [Select Id, Name, AccountId, Account.Name, CloseDate, Amount, StageName, Discount_Percent__c From Opportunity Where Name =: 'Test Oppty 2' Limit 1];
        Test.startTest();
        	Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
        	ProjectCalloutService.postOpportunityToPMS(new List<id>{oppty.Id});
        Test.stopTest();    
    }
}