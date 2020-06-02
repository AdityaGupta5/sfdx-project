trigger AccountContactTrigger on Account (after insert, after update) {

    List<Contact> contactList = new List<Contact>();
    List<Account> accountList = [Select Id, Name, (Select Id, Name From Contacts) From Account Where Id IN: Trigger.New];
    If((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter) {
        For(Account accnt : accountList) {
            System.debug(' Contact Size ######' + accnt.Contacts.size());
            if(accnt.Contacts.size() == 0) {
                System.debug(' contact Sizeee -=-=---=> ');
                Contact con = new Contact();
                con.LastName = accnt.Name;
                con.AccountId = accnt.Id;
                contactList.add(con);
            }
        }
        If(contactList != Null && contactList.size() > 0) {
            Insert contactList;
        }
    }
}