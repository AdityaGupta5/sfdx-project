public with sharing class WarehouseCalloutService {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    // complete this method to make the callout (using @future) to the
    // REST endpoint and update equipment on hand.
    @future(Callout = true)
    public static void runWarehouseEquipmentSync(){
    
        /*Http http = new Http();
        HttpRequest httpReq = new HttpRequest();
        httpReq.setEndpoint(WAREHOUSE_URL);
        httpReq.setMethod('GET');
        HttpResponse httpRes = http.send(httpReq);*/
        HttpResponse httpRes = getResponse();
        If(httpRes.getStatusCode() == 200) {
        	//Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(httpRes.getBody());
        	List<Product2> updatedEquipmentList = getUpdatedProducts(httpRes); 
            If(updatedEquipmentList != Null && updatedEquipmentList.size() > 0) {
                Upsert updatedEquipmentList;
            }
        	
        }
    }
    
    public static HttpResponse getResponse() {
        Http http = new Http();
        HttpRequest httpReq = new HttpRequest();
        httpReq.setEndpoint(WAREHOUSE_URL);
        httpReq.setMethod('GET');
        HttpResponse httpRes = http.send(httpReq);
        return httpRes;
    }
    
    public static List<Product2> getUpdatedProducts(HttpResponse httpRes) {
    	List<Product2> equipmentList = new List<Product2>(); 
        List<Object> resultList = (List<Object>) JSON.deserializeUntyped(httpRes.getBody()); 
        System.debug('resultList ===>> ' + resultList); 
        For(Object result : resultList) {
            Map<String, Object> mapResult = (Map<String, Object>)result;
            //System.debug('mapResult lifespan -=-=<> ' + mapResult.get('lifespan'));
            Product2 equipment = new Product2();
            equipment.Cost__c = (Integer)mapResult.get('cost');
            equipment.Lifespan_Months__c = (Integer)mapResult.get('lifespan');
            equipment.Maintenance_Cycle__c = (Integer)mapResult.get('maintenanceperiod');
            equipment.Name = (String)mapResult.get('name');
            equipment.Current_Inventory__c = (Integer)mapResult.get('quantity');
            equipment.Replacement_Part__c = (Boolean)mapResult.get('replacement');
            equipment.Warehouse_SKU__c = (String)mapResult.get('sku');
            equipmentList.add(equipment);
        }
        return equipmentList;
    }

}