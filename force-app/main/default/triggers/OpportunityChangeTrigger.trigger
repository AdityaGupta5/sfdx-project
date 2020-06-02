trigger OpportunityChangeTrigger on OpportunityChangeEvent (after insert) {

    List<Task> tasks = new List<Task>();
    // Iterate through each event message
    For(OpportunityChangeEvent event : Trigger.New) {
        // Get some event header fields by using EventBus.ChangeEventHeader
        EventBus.ChangeEventHeader header = event.ChangeEventHeader;
        System.debug('Received change event Name for ' + header.entityname + 'And Change Event Type for the ' + header.changetype);
        
        // For update operations, we can get a list of changed fields
        If(header.changetype == 'UPDATE' && event.IsWon) {
        	System.debug('Inside Condition List of all changed fields:');
            For(String chagedFieldStr : header.changedfields) {
                If(event.get(chagedFieldStr) == null) {
                    System.debug('Oppty Deleted field value (set to null): ' + chagedFieldStr);
                } else {
                    System.debug('Oppty Changed field Value : ' + chagedFieldStr + ' New Value: '+ event.get(chagedFieldStr));
                }
            }
            // Create a followup task
            If(Test.isRunningTest()) {
                System.debug('Inside Test Running ******' + header.recordIds[0]);
            	Task tsk = new Task();
                tsk.Subject = 'Follow up on won opportunities: ' + header.recordIds;
                tsk.OwnerId = header.commituser;
                tsk.WhatId = header.recordIds[0];
                tasks.add(tsk);    
            } else {
                System.debug('Inside Without Test Running ******');
                Task tsk = new Task();
                tsk.Subject = 'Follow up on won opportunities: ' + header.recordIds;
                tsk.OwnerId = header.commituser;
                tasks.add(tsk);    
            }
        }
        // Get record fields and display only if not null.
    	System.debug('Oppty record field values from the change event:');
        if (event.StageName != null) {
            System.debug('StageName: ' + event.StageName);
        }
        if (event.IsWon != null) {
            System.debug('isWon: ' + event.IsWon);
        }
        if (event.CloseDate != null) {
            System.debug('CloseDate: ' + event.CloseDate);
        }
        if (event.Name != null) {
            System.debug('Name: ' + event.Name);
        }
        
    }
    
    // Insert all tasks in bulk.
    if (tasks.size() > 0) {
        insert tasks;
    }
}