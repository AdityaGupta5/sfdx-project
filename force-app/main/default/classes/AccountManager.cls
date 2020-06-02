@RestResource(urlMapping='/Accounts/*/Contacts')
global with sharing class AccountManager {

    @HttpGet
    global static Account getAccount() {
        RestRequest restReq = RestContext.request;
        String accountId = restReq.requestURI.substringBetween('/Accounts/','/Contacts');
        System.debug('accountId ===> ' + accountId);
        String orgAccountId = '0016F00002PPlVE';
        Account accnt = [Select Id, Name, (Select Id, Name From Contacts) From Account Where Id =: orgAccountId Limit 1];    
        return accnt;
    }
}