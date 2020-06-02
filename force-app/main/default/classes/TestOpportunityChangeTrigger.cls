@isTest
public class TestOpportunityChangeTrigger {
    @isTest static void testCreateAndUpdateEmployee() {
        // Enable all Change Data Capture entities for notifications.
        Test.enableChangeDataCapture();
        insert new Opportunity(Name='Sell 100 Widgets', StageName='Prospecting', CloseDate=Date.today().addMonths(3));
        // Call deliver to fire the trigger and deliver the test change event.
        Test.getEventBus().deliver();
        // VERIFICATIONS
        // Check that the change event trigger created a task.
        Task[] taskList = [SELECT Id,Subject FROM Task];
        Opportunity[] oppList = [SELECT Id,StageName FROM Opportunity Limit 1];
        Opportunity oppty = oppList[0];
        // Debug
        System.debug('Retrieved oppty record: ' + oppty);
        // Update Stage to ClosedWon
        oppty.StageName = 'Closed Won';
        Update oppty;
        // Call deliver to fire the trigger for the update operation.
        Test.getEventBus().deliver();
        taskList = [SELECT Id FROM Task Limit 1];
        System.debug('Task Size ===> ' + taskList.size());
        System.assertEquals(1, taskList.size(),'The change event trigger did not create the expected task.');
    }
}