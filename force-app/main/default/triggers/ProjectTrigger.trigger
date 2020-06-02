trigger ProjectTrigger on Project__c (after update) {
    
    If(Trigger.isAfter && Trigger.isUpdate) {
        List<Project__c> projects = BillingCalloutService.getProjectDetails(Trigger.New, Trigger.OldMap);
        If(projects != Null && !projects.isEmpty()) {
            BillingCalloutService.callBillingService(projects[0].Id);
        }
    }
}