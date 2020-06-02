@isTest
private class ProjectRESTServiceTest {
  
    @testSetup static void testDataSetup() {
        Opportunity oppty = new Opportunity(Name='Test Oppty', StageName='Closed Won', CloseDate= Date.today().addYears(1), DeliveryInstallationStatus__c = 'In progress');
        Insert oppty;
        Project__c project = new Project__c(Name = 'Test Project', ProjectRef__c = 'TP000', Opportunity__c = oppty.Id, Billable_Amount__c = 100);
        Insert project;
    }
    
    @isTest static void testPostProjectData() {
        Opportunity oppty = [Select Id, Name, AccountId, CloseDate, Amount, StageName, DeliveryInstallationStatus__c From Opportunity Where Name =: 'Test Oppty' Limit 1];
        Project__c project = [Select Id, Name, ProjectRef__c, Opportunity__c, Billable_Amount__c From Project__c Where Name =: 'Test Project' Limit 1];
        String result = ProjectRESTService.postProjectData(project.ProjectRef__c, project.Name, String.valueOf(oppty.Id), Date.today(), Date.today().addDays(5), 100, 'Running');        
        System.assertEquals('OK', result);
        System.assertEquals('In progress', oppty.DeliveryInstallationStatus__c);
    }
    
    @isTest static void testPostProjectDataInvalid() {
    	Opportunity oppty = [Select Id, Name, AccountId, CloseDate, Amount, StageName, DeliveryInstallationStatus__c From Opportunity Where Name =: 'Test Oppty' Limit 1];    
        String result = ProjectRESTService.postProjectData('Invalid', 'Invalid', String.valueOf(oppty.Id), Date.today(), Date.today().addDays(5), 100, 'Running');
        System.assertEquals('OK', result);
        System.assertEquals('In progress', oppty.DeliveryInstallationStatus__c);
    }
}