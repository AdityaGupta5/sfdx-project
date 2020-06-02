public With Sharing class BoatReviews {

    @AuraEnabled
    public static List<BoatReview__c> getAll(Id boatId) {
        List<BoatReview__c> boatReviews = [SELECT Id, Name, Comment__c, Rating__c, LastModifiedDate, CreatedDate, CreatedBy.Name, CreatedBy.SmallPhotoUrl, CreatedBy.CompanyName
                        FROM BoatReview__c WHERE Boat__c =: boatId];
        return boatReviews;
    }
}