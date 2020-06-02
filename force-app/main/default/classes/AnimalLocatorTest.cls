@isTest
public class AnimalLocatorTest {

    @isTest static  void testGetAnimalNameById() {
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock()); 
        String str = AnimalLocator.getAnimalNameById(1);
    }
}