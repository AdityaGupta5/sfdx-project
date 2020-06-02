@isTest
private class WarehouseCalloutServiceTest {
    // implement your mock callout test here
    @isTest static void TestWarehouseCalloutService() {
        Test.startTest();
            //mock respoonse
            Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
            WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();    
    }
}