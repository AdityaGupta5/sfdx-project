@isTest
public class TestVerifyDate {
    @isTest static void testCheckDatesScenario1() {
    	Date date1 = System.today();
        Date date2 = System.today()+30;
     
        VerifyDate.CheckDates(date1, date2);
    }
    
    @isTest static void testCheckDatesScenario2() {
    	Date date1 = System.today()+10;
        Date date2 = System.today();
        
        VerifyDate.CheckDates(date1, date2);
    }
    
    @isTest static void testCheckDatesScenario3() {
    	Date date1 = System.today()+30;
        Date date2 = System.today()+30;
        
        VerifyDate.CheckDates(date1, date2);
    }
}