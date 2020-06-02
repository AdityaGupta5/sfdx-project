public class Product2Helper {

    /**
     * @name COLLABORATION_GROUP
     * @description List of CollaborationGroup used in both business and test logic
    **/
    static List<CollaborationGroup> COLLABORATION_GROUP = [
        SELECT Id
        FROM CollaborationGroup
        WHERE Name = : Constants.INVENTORY_ANNOUNCEMENTS
        OR Name = :('TEST'+Constants.INVENTORY_ANNOUNCEMENTS)
        LIMIT 1
    ];

    /**
     * @name afterUpdate
     * @description called by product2 Trigger on After Update
     * @param List<Product2> newList
     * @param List<Product2> oldList
    **/
    public static void AfterUpdate(List<Product2> newList){
        //ToDo: Declare a List of Product2 records named needsAnnouncement
		List<Product2> needsAnnouncement = new List<Product2>();
        //ToDo: Declare a Map of Strings to Inventory_Setting__mdt records
		Map<String, Decimal> invSettingMap = new Map<String, Decimal>();
        //ToDo: Loop through a query of Inventory_Setting__mdt records and populate the Map with Name as the key
		List<Inventory_Setting__mdt> invSettingList = [SELECT Id, DeveloperName, Low_Quantity_Alert__c FROM Inventory_Setting__mdt];
        For(Inventory_Setting__mdt invSettingMdt : invSettingList) {
            system.debug('invSettingMdt.DeveloperName ====<> ' + invSettingMdt.DeveloperName);
            system.debug('low quantity alert ====<> ' + invSettingMdt.Low_Quantity_Alert__c);
        	invSettingMap.put(invSettingMdt.DeveloperName, invSettingMdt.Low_Quantity_Alert__c);    
        }
        //ToDo: Loop through the Products in newList
        // Use the corresponding Inventory Setting record to determine the correct Low Quantity Alert
        // If the Product's Quantity Remaining has been changed to less than the Low Quantity Alert
        //      add it to the needsAnnouncement list
		For(Product2 prod : newList) {
            System.debug('prod.Name <====> ' + prod.Name);
            System.debug('prod.Family <====> ' + prod.Family);
            System.debug('prod.Quantity_Remaining__c ====> ' + prod.Quantity_Remaining__c);
            System.debug('invSettingMap.get(prod.Name) ====> ' + invSettingMap.get(prod.Name));
            System.debug('invSettingMap.get(prod.Name) ====> ' + invSettingMap.get(prod.Name));
            if(invSettingMap.containsKey(prod.Family) && prod.Quantity_Remaining__c < invSettingMap.get(prod.Family)) {
            	needsAnnouncement.add(prod);    
            }   
        }
        //ToDo: Pass records to the postAlerts method
        PostAlerts(needsAnnouncement);
    }

    /**
     * @name postAlerts
     * @description called by product2 Trigger on After Update
     * @param List<Product2> productList
    **/
    public static void PostAlerts(List<Product2> productList){
        List<ConnectApi.AnnouncementInput> toPost = new List<ConnectApi.AnnouncementInput>();
        for ( Product2 p : productList ){
            // ToDo: Construct a new AnnouncementInput for the Chatter Group so that it:
            // expires in a day
            // does not notify users via email.
            // and has a text body that includes the name of the product followed by the INVENTORY_LEVEL_LOW constant
            ConnectAPI.MessageBodyInput msgBodyInput = new ConnectAPI.MessageBodyInput();
            ConnectAPI.TextSegmentInput textSegmentInput = new ConnectAPI.TextSegmentInput();
            
            ConnectAPI.AnnouncementInput announcementInput = new ConnectAPI.AnnouncementInput();
            announcementInput.expirationDate = Date.today().addDays(1);
            announcementInput.sendEmails = true;
            announcementInput.parentId = COLLABORATION_GROUP[0].Id;
            
            textSegmentInput.text = p.Name + ' ' + Constants.INVENTORY_LEVEL_LOW;
            
            msgBodyInput.messageSegments = new List<ConnectApi.messageSegmentInput>();
            msgBodyInput.messageSegments.add(textSegmentInput);
            announcementInput.body = msgBodyInput;
            
            toPost.add(announcementInput);
        }
        // ToDo: Create and enqueue an instance of the announcementQueuable class with the list of Products
        //If(toPost != Null & toPost.size() > 0) {
        	AnnouncementQueueable announceQueueable = new AnnouncementQueueable();
            announceQueueable.toPost = toPost;
            System.enqueueJob(announceQueueable);
        //}
    }
}