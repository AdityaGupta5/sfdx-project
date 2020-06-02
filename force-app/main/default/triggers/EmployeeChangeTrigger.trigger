trigger EmployeeChangeTrigger on Employee__ChangeEvent (after insert) {

    List<Task> tasks = new List<Task>();
    // Iterate through each event message
    For(Employee__ChangeEvent empEvent : Trigger.New) {
        // Get some event header fields by using EventBus.ChangeEventHeader
        EventBus.ChangeEventHeader header = empEvent.ChangeEventHeader;
        System.debug('Received change event Name for ' + header.entityname + 'And Change Event Type for the ' + header.changetype);
    	
        // For update operations, we can get a list of changed fields
        If(header.changetype == 'UPDATE') {
            System.debug('Inside Condition List of all changed fields:');
            For(String chagedFieldStr : header.changedfields) {
                If(empEvent.get(chagedFieldStr) == null) {
                    System.debug('Deleted field value (set to null): ' + chagedFieldStr);
                } else {
                    System.debug('Changed field Value : ' + chagedFieldStr + ' New Value: '+ empEvent.get(chagedFieldStr));
                }
            }
        }
        
        // Get record fields and display only if not null.
    	System.debug('Some Employee record field values from the change event:');
        If(empEvent.First_Name__c != null) {
            System.debug('First Name: ' + empEvent.First_Name__c);
        }
        If (empEvent.Last_Name__c != null) {
            System.debug('Last Name: ' + empEvent.Last_Name__c);
        }
        If (empEvent.Name != null) {
            System.debug('Name: ' + empEvent.Name);
        }
        If (empEvent.Tenure__c != null) {
            System.debug('Tenure: ' + empEvent.Tenure__c);
        }
        
        // Create a followup task
        
        Task tsk = new Task();
        tsk.Subject = 'Follow up on employee record(s): ' + header.recordids;
        tsk.OwnerId = header.commituser;
        tasks.add(tsk);
    }
    
    // Insert all tasks in bulk.
    if (tasks.size() > 0) {
        insert tasks;
    }
}