public With Sharing class BoatSearchResults {
    
    @AuraEnabled
    public static List<Boat__c> getBoats(String boatTypeId) {
        List<Boat__c> boatList;
        If(String.isNotBlank(boatTypeId)) {
        	boatList = [Select Id, Name, BoatType__c, picture__c, Contact__r.Name From Boat__c Where BoatType__c =: boatTypeId];    
        } else {
            boatList = [Select Id, Name, BoatType__c, picture__c, Contact__r.Name From Boat__c];  
        }
        return boatList;
    }
}