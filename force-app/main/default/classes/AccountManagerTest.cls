@isTest(seeAllData = true)
public class AccountManagerTest {

    static testMethod void testGetAccount() {
        Account accnt = new Account(Name = 'test Account');
        Insert accnt;
        Contact con = new Contact(LastName = 'test Contact', AccountId = accnt.Id);
        Insert con;
        Id accountId = accnt.Id;
        RestRequest request = new RestRequest();
        request.requestURI = 'https://th-apex-soap-service.herokuapp.com/services/apexrest/Accounts/'+ accountId +'/Contacts';
        request.httpMethod = 'Get';
        RestContext.request = request;
        
        Account currentAccount = AccountManager.getAccount();
        //System.assertEquals('test Account', currentAccount.Name);
    }
}