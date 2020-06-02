public class DailyLeadProcessor Implements Schedulable {

    public void execute(SchedulableContext sc) {
    	List<Lead> leadList = [Select Id, Name, LeadSource From Lead Where LeadSource = Null Limit 200]; 
        For(Lead leadObj : leadList) {
        	leadObj.LeadSource = 'Dreamforce';     
        }
        Update leadList;
    }
}