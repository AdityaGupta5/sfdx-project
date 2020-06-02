public class RandomContactFactory {
    
    public static List<Contact> generateRandomContacts(Integer intVal, String strVal) {
    	List<Contact> contacts = new List<Contact>();  
        for(Integer i=0; i<intVal; i++) {
        	Contact con = new Contact(FirstName = 'TestContact' + i, LastName = strVal); 
            contacts.add(con);
        }
        return contacts;
    }

}