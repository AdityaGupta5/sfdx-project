@isTest
public class MaintenanceRequestHelperTest {

    @testSetup static void testDataSetup() {
        Vehicle__c vehicle = new Vehicle__c(Name='tata sumo',Air_Conditioner__c=true,Model__c='23Test');
        insert vehicle;
        Product2 equipment = new Product2(Name='tire',Cost__c=100,Current_Inventory__c	=10,Replacement_Part__c=true,
                                          Warehouse_SKU__c ='test',Lifespan_Months__c =10,Maintenance_Cycle__c=10);
        insert equipment;
        List<Case> newMaintenanceList=new List<Case>();
        For(Integer i=1; i <= 300; i++) {
            Case maintenance=new Case(Subject='Test subject'+i, Type='Routine Maintenance'+i, Status='New'+i,
                                      Origin='Phone'+i ,Equipment__c=equipment.Id, Vehicle__c=vehicle.Id);
            newMaintenanceList.add(maintenance);
        }
        Insert newMaintenanceList;
    }
    
    @isTest static void testMaintenanceRequest() {
        Product2 equipment = [Select Name, Maintenance_Cycle__c, Lifespan_Months__c From Product2 Limit 1];
        List<Case> caseList = [Select Id, IsClosed__c, CaseNumber, Date_Due__c, Date_Reported__c, Equipment__c, Equipment__r.Maintenance_Cycle__c,
                               Vehicle__c, Type, Status 
                               From Case
                               Limit 300];
        List<Case> updatedMaintenanceList=new List<Case>();
        For(Case c : caseList) {
            c.Status = 'Closed';
            c.Type = 'Routine Maintenance';
            c.Date_Due__c = date.Today().addDays(Integer.valueOf(equipment.Maintenance_Cycle__c));
            updatedMaintenanceList.add(c);
        }
        Update updatedMaintenanceList;
        Test.startTest();
			MaintenanceRequestHelper.updateWorkOrders(updatedMaintenanceList, caseList);
        Test.stopTest();
        System.assertEquals(300, caseList.size());
    }
}