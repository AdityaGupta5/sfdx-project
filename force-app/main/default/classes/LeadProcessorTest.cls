@isTest
public class LeadProcessorTest {

    @testSetup 
    static void setup() {
        List<Lead> leadList = new List<Lead>();
        For(Integer i=0; i<200; i++) {
        	leadList.add(new Lead(LastName = 'Test Lead '+i, Company = 'Test Lead Org', LeadSource = 'Dreamforce'));    
        }
        Insert leadList;
    }
    
    @isTest static void testLeadProcess() {
        Test.startTest();
        	LeadProcessor leadProcess = new LeadProcessor();
        	Id batchId = Database.executeBatch(leadProcess);
        Test.stopTest();
        
        System.assertEquals(200, [Select Count() From Lead Where Company =: 'Test Lead Org']);
    }
}