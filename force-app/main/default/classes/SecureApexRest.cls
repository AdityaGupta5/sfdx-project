@RestResource(urlMapping='/secureApexRest')
global with sharing class SecureApexRest {
    @HttpGet
    global static Contact doGet(){
        Id recordId = RestContext.request.params.get('id');
        Contact result;
        if (recordId == null){
            throw new FunctionalException('Id parameter is required');
        }
        /*if (Schema.SObjectType.Contact.isAccessible()
            && Schema.SObjectType.Contact.fields.Name.isAccessible()
            && Schema.SObjectType.Contact.fields.Secret_Key__c.isAccessible()){
            List<Contact> results = [SELECT id, Name, Secret_Key__c FROM Contact WHERE Id = :recordId];
            if (!results.isEmpty()) {
                result = results[0];
            }
        } else{
            throw new SecurityException('You don\'t have access to all contact fields required to use this API');
        }*/
        //Refactor the code based on Security checks in SOQL - Starts Here
        try{
            List<Contact> results = [SELECT id, Name, Secret_Key__c FROM Contact WHERE Id = :recordId WITH SECURITY_ENFORCED];
            if (!results.isEmpty()) {
                result = results[0];
            }    
        } catch(QueryException qe) {
            //throw new SecurityException('You don\'t have access to all contact fields required to use this API');
        }
        
        //Ends Here
        return result;
    }
    public class FunctionalException extends Exception{}
    public class SecurityException extends Exception{}
}