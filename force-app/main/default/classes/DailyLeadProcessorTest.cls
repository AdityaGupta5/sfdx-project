@isTest
public class DailyLeadProcessorTest {

    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    
    @isTest static void testSchedulable() {
        List<Lead> leadList = new List<Lead>();
        For(Integer i=0; i<200; i++) {
            leadList.add(new Lead(LastName = 'Test Lead '+i, Company = 'Test Lead Org'));    
        }
        Insert leadList; 
        
        Test.startTest();
        	String jobId = System.schedule('DailyLeadProcessorJob', CRON_EXP, new DailyLeadProcessor());	
        Test.stopTest();
    }
}