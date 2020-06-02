@isTest
private class BillingCalloutServiceTest {
	
    @testSetup static void testDataSetup() {
        Opportunity oppty = new Opportunity(Name='Test Oppty', StageName='Closed Won', CloseDate= Date.today().addYears(1), DeliveryInstallationStatus__c = 'In progress');
        Insert oppty;
        Project__c projectNew = new Project__c(Name = 'Test Project', ProjectRef__c = 'TP000', Opportunity__c = oppty.Id, Billable_Amount__c = 100, Status__c = 'Running');
        Insert projectNew;
        ServiceCredentials__c serviceCredential = new ServiceCredentials__c (Name = 'BillingServiceCredential', Username__c = 'bsUser1', Password__c = 'bsPass1');
        Insert serviceCredential;
    }
    
    @isTest static void testBillingServiceCallSuccess() {
    	Project__c project = [Select Id, Name, ProjectRef__c, Opportunity__c, Billable_Amount__c From Project__c Where Name =: 'Test Project' Limit 1];
        Test.startTest();
        	Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
        	BillingCalloutService.callBillingService(project.Id);
        Test.stopTest();
        Project__c proj = [Select Id, Status__c, ProjectRef__c From Project__c Where ProjectRef__c =: project.ProjectRef__c];
        System.assertEquals('TP000', project.ProjectRef__c);
        System.assertEquals('Billed', proj.Status__c);
        
    }
    
    @isTest static void testBillingServiceCallFailure() {
    	Project__c project = [Select Id, Name, ProjectRef__c, Opportunity__c, Billable_Amount__c From Project__c Where Name =: 'Test Project' Limit 1];
        Test.startTest();
        	Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());
        	BillingCalloutService.callBillingService(project.Id);
        Test.stopTest();  
        System.assertEquals('TP000', project.ProjectRef__c);
    }
    
    @isTest static void testBillingServiceCall() {
        List<Project__c> newProjectList = new List<Project__c>();
        Project__c project = [Select Id, Name, ProjectRef__c, Opportunity__c, Billable_Amount__c, Status__c From Project__c Where Name =: 'Test Project' Limit 1];
        Map<Id, Project__c> oldProjectMap = new Map<Id, Project__c>();
        oldProjectMap.put(project.Id, project);
        project.Status__c = 'Billable';
        newProjectList.add(project);
        Update newProjectList;
        Test.startTest();
        	Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
        	BillingCalloutService.getProjectDetails(newProjectList, oldProjectMap);
        Test.stopTest();
    }

}