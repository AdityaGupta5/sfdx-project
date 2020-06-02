@isTest
public class TestRestrictContactByName {

    @isTest static void testRestrictContactByName() {
    
        Contact newContact = new Contact(LastName = 'INVALIDNAME');
        try{
            Database.SaveResult result = Database.insert(newContact);
        }catch(DmlException e){
            
        }
        //System.assert(!result.isSuccess());
    }
}