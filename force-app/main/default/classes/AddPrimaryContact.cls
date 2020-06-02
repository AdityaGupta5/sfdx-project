public class AddPrimaryContact Implements Queueable  {
    
    public Contact cont;
    public String stateStr;

    public AddPrimaryContact(Contact con, String state) {
    	this.cont = con;
        this.stateStr = state;
    }
    public void execute(QueueableContext qc) {
    	List<Account> listAccount = [Select Id, Name, BillingState From Account Where BillingState =: stateStr Limit 200];
        List<Contact> listContact = new List<Contact>();
        For(Account accnt : listAccount) {
            Contact newCon = cont.clone(false, true);
            newCon.AccountId = accnt.Id; 
            listContact.add(newCon);
        }
        if(listContact != null && listContact.size() > 0) {
            Insert listContact;
        }
    }
}