public class Product2Extension {

    public List<ProductWrapper> productsToInsert {get;set;}

    public Product2Extension(ApexPages.StandardController controller){
        productsToInsert = new List<ProductWrapper>();
        addRows();
    }

    public void AddRows(){
        for ( Integer i=0; i< Constants.DEFAULT_ROWS; i++ ){
            productsToInsert.add( new ProductWrapper() );
        }
    }

    public List<ChartHelper.ChartData> GetInventory(){
        return ChartHelper.GetInventory();
    }
    
    public List<SelectOption> GetFamilyOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Constants.SELECT_ONE, Constants.SELECT_ONE));
        for(PickListEntry eachPicklistValue : Constants.PRODUCT_FAMILY) {
            options.add(new SelectOption(eachPicklistValue.getValue(), eachPicklistValue.getLabel()));
        }
        return options;
    }

    public PageReference Save(){
        SavePoint sp = Database.setSavepoint();
        try {
            List<Product2> productList = new List<Product2>();
            List<PricebookEntry> priceBookEntryList = new List<PricebookEntry>();
            for(ProductWrapper prodWrapper : productsToInsert) {
                if(prodWrapper.productRecord != Null && prodWrapper.pricebookEntryRecord != Null) {
                    if(prodWrapper.productRecord.Name != Null && prodWrapper.productRecord.Family != Null && 
                       prodWrapper.productRecord.Family != Constants.SELECT_ONE && prodwrapper.productRecord.Initial_Inventory__c != null &&
                       prodwrapper.pricebookEntryRecord.UnitPrice != null) {
                           
                           productList.add(prodWrapper.productRecord); 
                           PriceBookEntry pbe = prodwrapper.pricebookEntryRecord;
                           pbe.IsActive = true;
                           pbe.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
                           priceBookEntryList.add(pbe);
                       }
                }    
            }
            if(productList != Null & productList.size() > 0) {
                Insert productList;
                if(priceBookEntryList != Null) {
                    for(Integer i = 0; i < priceBookEntryList.size(); i++) {
                        priceBookEntryList[i].Product2Id = productList[i].Id;
                    }
                    Insert priceBookEntryList;    
                }    
            }
            //If successful clear the list and display an informational message
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,productsToInsert.size()+' Inserted'));
            productsToInsert.clear();   //Do not remove
            addRows();  //Do not remove
        } catch (Exception e){
			Database.rollback(sp);
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Constants.ERROR_MESSAGE));
        }
        return null;
    }
    
    public class ProductWrapper {
        public Product2 productRecord {get; set;}
        public PriceBookEntry pricebookEntryRecord {get; set;}
        
        public ProductWrapper() {
            productRecord = new product2(Initial_Inventory__c = 0);
            pricebookEntryRecord = new pricebookEntry(Unitprice = 0.0);
        }  
    }
}