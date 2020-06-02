public class AccountProcessor {
	@future
    public static void countContacts(Set<ID> accountIds) {
    
        List<Account> listAccount = [Select Id, Name, Number_of_Contacts__c, (Select Id, Name, AccountId From Contacts Where AccountId != Null) From Account Where Id IN: accountIds];
        For(Account accnt : listAccount) {
            List<Contact> contactList = accnt.Contacts;
            if(contactList != Null && contactList.size() > 0) {
            	accnt.Number_of_Contacts__c = contactList.size();    
            }
        }
        Update listAccount;
    }
}