public class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(List<Case> newCase, List<Case> oldCase){
        // update workorders
        List<Case> newMaintenanceRequestList = new List<Case>();
        if(newCase != null && newCase.size() > 0) {
        	List<Case> caseList = [Select Id, IsClosed__c, CaseNumber, Date_Due__c, Date_Reported__c, Equipment__c, Equipment__r.Maintenance_Cycle__c,
                        Vehicle__c, Type, Status
                        From Case
                        Where Id IN : newCase Limit 300]; 
            if(caseList != null && !caseList.isEmpty()) {
                For(Case c : caseList) {
                    if((c.Type == 'Repair' || c.Type == 'Routine Maintenance') && c.Status == 'Closed') {
                    	case newMaintenanceRequest = new Case();
                        newMaintenanceRequest.Subject = 'New Maintenance Request';
                        newMaintenanceRequest.Type = 'Routine Maintenance';
                        newMaintenanceRequest.Vehicle__c = c.Vehicle__c;
                        newMaintenanceRequest.Equipment__c = c.Equipment__c;
                        newMaintenanceRequest.Date_Reported__c = Date.today();
                        newMaintenanceRequest.Date_Due__c = Date.today().addDays(Integer.valueOf(c.Equipment__r.Maintenance_Cycle__c));
                        newMaintenanceRequest.Status = 'New';
                        newMaintenanceRequestList.add(newMaintenanceRequest);
                    }
                }  
                If(newMaintenanceRequestList != null && newMaintenanceRequestList.size() > 0) {
                    Insert newMaintenanceRequestList;
                }
            }
        }
        
    }        
    
}