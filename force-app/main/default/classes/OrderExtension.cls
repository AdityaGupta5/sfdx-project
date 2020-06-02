/**
 * @name OrderExtension
 * @description This class is provided for you to facilitate the Super Badge
**/
public class OrderExtension {

    public Order orderRecord {get;set;}
    public List<OrderItem> orderItemList {get;set;}
    public String selectedFamily {get;set;}
    public List<chartHelper.chartData> pieData {get;set;}
    public Decimal total {get;set;}

    public Map<Id,OrderItem> orderItemMap;
    ApexPages.StandardSetController standardSetController;

    public OrderExtension(ApexPages.StandardController standardController){
        orderRecord = (Order)standardController.getRecord();
        orderItemMap = new Map<id,OrderItem>();
        if ( orderRecord.Id != null ){
            orderRecord = queryOrderRecord(orderRecord.Id);
        }
        refreshStandardSetController();
        //loadData();
        total = 0;
        For(OrderItem oi : orderRecord.OrderItems) {
        	orderItemMap.put(oi.Product2Id, oi);
            if(oi.Quantity > 0) {
                if(pieData == Null) {
                	pieData = new List<chartHelper.chartData>();    
                }
                pieData.add(new chartHelper.chartData(oi.Product2.Name, oi.Quantity * oi.UnitPrice));
                total += oi.Quantity * oi.UnitPrice;
            }
        }
        loadData();
    }
    

    //ToDo: Implement your own method to populate orderItemList
    //  that you will call after pagination and/or family selection
    private void refreshStandardSetController() {
    	String query = 'SELECT Name, Product2.Family, Product2.Name, Product2Id, UnitPrice, Product2.Quantity_Remaining__c FROM PricebookEntry WHERE IsActive = TRUE';    
        if(selectedFamily != null && selectedFamily != Constants.SELECT_ONE) {
            query += ' AND Product2.Family = \'' + selectedFamily + '\'';
        }
        query += ' ORDER BY Name';
        standardSetController = new ApexPages.StandardSetController(Database.getQueryLocator(query));
        standardSetController.setPageSize(Constants.DEFAULT_ROWS);
    }
    
    private void loadData() {
        orderItemList = new List<OrderItem>();
        for(SObject obj : standardSetController.getRecords()) {
        	PricebookEntry pbe = (PricebookEntry)obj;
            if(orderItemMap.containsKey(pbe.Product2Id)) {
                orderItemList.add(orderItemMap.get(pbe.Product2Id));
            } else {
                OrderItem oItem = new OrderItem(PricebookEntryId = pbe.Id, 
                                                Product2Id = pbe.Product2Id, 
                                                UnitPrice = pbe.UnitPrice,
                                                Quantity = 0,
                                                Product2 = pbe.Product2
                                               );
                orderItemList.add(oItem);
                orderItemMap.put(pbe.Product2Id, oItem);
            }
        }
    }

    /**
     * @name OnFieldChange
     * @description
    **/
    public void OnFieldChange(){
        //ToDo: Implement logic to store the values changed on the page
        //      and populate pieData
        //      and populate total
        /*for (OrderItem oi : orderItemList) {
            orderItemMap.put(oi.Product2Id, oi);
        }*/
        pieData = null;
        total = 0;
        for (OrderItem oi : orderItemList) {
            if(oi.Quantity > 0) {
                if(null == pieData) {
                    pieData = new List<chartHelper.ChartData>();
                }    
                pieData.add(new chartHelper.ChartData(oi.Product2.Name, oi.Quantity * oi.UnitPrice));
                total += oi.UnitPrice * oi.Quantity;
            }
        }
    }

    /**
     * @name SelectFamily
     * @description
    **/
    public void SelectFamily(){
        //ToDo: Implement logic to filter based on the selected product family
        refreshStandardSetController();
        loadData();
    }

    /**
     * @name Save
     * @description
    **/
    public void Save(){
        //ToDo: Implement logic to save the Order and populated OrderItems
		System.SavePoint sp = Database.setSavepoint();
        try {
            if(orderRecord.Pricebook2Id == null) {
                orderRecord.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            }   
            upsert orderRecord;
            List<OrderItem> orderItemsToUpdate = new List<OrderItem>();
            List<OrderItem> orderItemsToDelete = new List<OrderItem>();
            For(OrderItem oi : orderItemMap.values()) {
                if(oi.Quantity > 0) {
                    if(oi.OrderId == Null) {
                        oi.OrderId = orderRecord.Id;
                    }  
                    orderItemsToUpdate.add(oi);
                } else {
                    if(oi.Id != Null) {
                    	orderItemsToDelete.add(new OrderItem(Id = oi.Id));
                        //oi.Id = null;
                    }    
                }
            }
            upsert orderItemsToUpdate;
            delete orderItemsToDelete;
        } catch(Exception e) {
        	Database.rollback(sp);
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,Constants.ERROR_MESSAGE));
        }
    }


    /**
     * @name First
     * @description
    **/
    public void First(){
		standardSetController.first();
        loadData();
    }


    /**
     * @name Next
     * @description
    **/
    public void Next(){
		standardSetController.next();
        loadData();
    }


    /**
     * @name Previous
     * @description
    **/
    public void Previous(){
		standardSetController.previous();
        loadData();
    }

    /**
     * @name Last
     * @description
    **/
    public void Last(){
		standardSetController.last();
        loadData();
    }

    /**
     * @name GetHasPrevious
     * @description
    **/
    public Boolean GetHasPrevious(){
        return standardSetController.getHasPrevious();
    }

    /**
     * @name GetHasNext
     * @description
    **/
    public Boolean GetHasNext(){
        return standardSetController.getHasNext();
    }

    /**
     * @name GetTotalPages
     * @description
    **/
    public Integer GetTotalPages(){
        return (Integer)Math.ceil(standardSetController.getResultSize() / (Decimal)Constants.DEFAULT_ROWS);
    }

    /**
     * @name GetPageNumber
     * @description
    **/
    public Integer GetPageNumber(){
        return standardSetController.getPageNumber();
    }
    
    public void cancel() {
        standardSetController.cancel();
    } 

    /**
     * @name GetFamilyOptions
     * @description
    **/
    public List<SelectOption> GetFamilyOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Constants.SELECT_ONE, Constants.SELECT_ONE));
        for(PickListEntry eachPicklistValue : Constants.PRODUCT_FAMILY) {
            options.add(new SelectOption(eachPicklistValue.getValue(), eachPicklistValue.getLabel()));
        }
        return options;
    }

    /**
     * @name QueryOrderRecord
     * @description
    **/
    public static Order QueryOrderRecord(Id orderId){
        return [
            SELECT Id, AccountId, EffectiveDate, Name, Status, Pricebook2Id,
                (
                    SELECT Id, OrderId, Quantity, UnitPrice, PricebookEntryId, Product2Id,
                         Product2.Name, Product2.Family, Product2.Quantity_Remaining__c
                    FROM OrderItems
                )
            FROM Order
            WHERE Id = :orderId
        ];
    }

}