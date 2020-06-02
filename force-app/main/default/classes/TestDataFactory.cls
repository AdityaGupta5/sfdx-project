/**
 * @name TestDataFactory
 * @description Contains methods to construct and/or validate commonly used records
**/
public without sharing class TestDataFactory {

    /**
     * @name ConstructCollaborationGroup
     * @description
    **/
    public static CollaborationGroup ConstructCollaborationGroup(){
        //ToDo: Ensure this method returns a single Chatter CollaborationGroup
        //    whose Name starts with 'TEST' followed by the INVENTORY_ANNOUNCEMENTS constant
        //    and configured so anyone can join, see and post updates.
        CollaborationGroup cgroup = new CollaborationGroup();
        cgroup.Name = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS;
        cgroup.CanHaveGuests = false;
        cgroup.CollaborationType = 'Public';
        cgroup.IsArchived = false;
        cgroup.IsAutoArchiveDisabled = false;
        return cgroup;
    }

    /**
     * @name CreateProducts
     * @description Constructs a list of Product2 records for unit tests
    **/
    public static List<Product2> ConstructProducts(Integer cnt){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Product2 records
        //  with all the required fields populated
        //  and IsActive = true
        //  an Initial Inventory set to 10
        //  and iterating through the product family picklist values throughout the list.
        List<Schema.PicklistEntry> pEntries = Constants.PRODUCT_FAMILY;
        Integer listSize = pEntries.size();
        List<Product2> productList = new List<Product2>();
        for(Integer i = 0; i < cnt; i++) {
            Product2 product = new Product2();
            product.Name = 'Test Product ' + i;
            product.isActive = true;
            product.Initial_Inventory__c = 10;
            product.Family = pEntries[Math.mod(i, listSize)].getValue();
            productList.add(product);
        }
        return productList;
    }

    /**
     * @name CreatePricebookEntries
     * @description Constructs a list of PricebookEntry records for unit tests
    **/
    public static List<PricebookEntry> ConstructPricebookEntries(List<Product2> prods){
        //ToDo: Ensure this method returns a corresponding list of PricebookEntries records
        //  related to the provided Products
        //  with all the required fields populated
        //  and IsActive = true
        //  and belonging to the standard Pricebook
        List<PricebookEntry> pbes = new List<PricebookEntry>();
        for (Product2 product: prods) {
            PricebookEntry pbe = new PricebookEntry();
            pbe.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            pbe.Product2Id = product.Id;
            pbe.IsActive = true;
            pbe.UnitPrice = 1;
            pbes.add(pbe);
        }
        return pbes;
    }

    /**
     * @name CreateAccounts
     * @description Constructs a list of Account records for unit tests
    **/
    public static List<Account> ConstructAccounts(Integer cnt){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Account records
        //  with all of the required fields populated.
        List<Account> accts = new List<Account>();
        for (Integer i = 0; i < cnt; i++) {
            Account acct = new Account();
            acct.Name = 'Account ' + i;
            accts.add(acct);
        }
        return accts;
    }

    /**
     * @name CreateContacts
     * @description Constructs a list of Contacxt records for unit tests
    **/
    public static List<Contact> ConstructContacts(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Contact records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        List<Contact> contactList = new List<Contact>();
        for (Integer i = 0; i < cnt; i++) {
            Contact c = new Contact();
            c.LastName = 'Contact ' + i;
            c.AccountId = accts[i].Id;
            contactList.add(c);
        }
        
        return contactList;
    }

    /**
     * @name CreateOrders
     * @description Constructs a list of Order records for unit tests
    **/
    public static List<Order> ConstructOrders(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Order records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        List<Order> orderList = new List<Order>();
        
        for (Integer i = 0; i < cnt; i++) {
            Order o = new Order();
            o.Name = 'Order ' + i;
            o.AccountId = accts[i].Id;
            o.EffectiveDate = Date.today();
            o.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            o.Status = 'Draft';
            orderList.add(o);
        }
        
        return orderList;
    }

    /**
     * @name CreateOrderItems
     * @description Constructs a list of OrderItem records for unit tests
    **/
    public static List<OrderItem> ConstructOrderItems(integer cnt, list<pricebookentry> pbes, list<order> ords){
        //ToDo: Ensure this method returns a list of size cnt of OrderItem records
        //  related to the provided Pricebook Entries
        //  and related to the provided Orders
        //  with all of the required fields populated.
        //  Hint: Use the DEFAULT_ROWS constant for Quantity as it will be used in the next challenge
        List<OrderItem> orderItemList = new List<OrderItem>();
        
        for (Integer i = 0; i < cnt; i++) {
            OrderItem oi = new OrderItem();
            oi.OrderId = ords[i].Id;
            oi.PriceBookEntryId = pbes[i].Id;
            oi.Quantity = Constants.DEFAULT_ROWS;
            oi.UnitPrice = 1;
            orderItemList.add(oi);
        }
        
        return orderItemList;
    }
    
    public static void VerifyQuantityOrdered(Product2 originalProduct, Product2 updatedProduct, Integer qtyOrdered) {
        System.assertEquals(updatedProduct.Quantity_Ordered__c, (originalProduct.Quantity_Ordered__c + qtyOrdered));
    }

    /**
     * @name SetupTestData
     * @description Inserts accounts, contacts, Products, PricebookEntries, Orders, and OrderItems.
    **/
    public static void InsertTestData(Integer cnt){
        //ToDo: Ensure this method calls each of the construct methods
        //  and inserts the results for use as test data.
        insert constructCollaborationGroup();
        
        List<Product2> productList = constructProducts(cnt);
        insert productList;
        
        List<PricebookEntry> pbes = constructPricebookEntries(productList);
        insert pbes;
        
        List<Account> accts = constructAccounts(cnt);
        insert accts;
        insert constructContacts(cnt, accts);
        
        List<Order> ords = constructOrders(cnt, accts);
        insert ords;
        
        insert constructOrderItems(cnt, pbes, ords);
    }

}