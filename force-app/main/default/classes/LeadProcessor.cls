public class LeadProcessor Implements Database.Batchable<sObject>, Database.stateful {

    public Integer recordProcessed = 0;
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('Select Id, Name, LeadSource ' +
        								'From Lead ' +
                                        'Where LeadSource != Null'
                                       );
    } 
    
    public void execute(Database.BatchableContext bc, List<Lead> leads) {
    	List<Lead> leadList = new List<Lead>();
        For(Lead leadObj : leads) {
            if(leadObj.LeadSource == 'Dreamforce') {
            	leadList.add(leadObj); 
                recordProcessed = recordProcessed + 1;
            }  
        }
        if(leadList != Null && leadList.size() > 0) {
            Update leadList;
        }
    }
    
    public void finish(Database.BatchableContext bc) {
    	System.debug('recordProcessed ===> ' + recordProcessed);    
    }
}