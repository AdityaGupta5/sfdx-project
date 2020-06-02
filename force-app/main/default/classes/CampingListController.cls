public with sharing class CampingListController {
	@AuraEnabled
    public static List<Camping_Item__c> getItems() {
    	List<Camping_Item__c> campingItemList = [Select Id, Name, Packed__c, Price__c, Quantity__c
                                                 From Camping_Item__c];
        return campingItemList;
    }
    @AuraEnabled
    public static Camping_Item__c saveItem(Camping_Item__c campingItem) {
        if(campingItem != null) {
            Upsert campingItem;
        }
        return campingItem;
    }
}