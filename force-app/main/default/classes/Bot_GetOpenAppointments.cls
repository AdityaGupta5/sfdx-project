public With Sharing class Bot_GetOpenAppointments {

    @InvocableMethod(label='Get Open Appointments')
    public static List<List<Bot_Appointment__c>> getOpenAppointments(List<String> emailList) {
        String sEmail = emailList[0];
        
        // Create a list for the appointments
        // NOTE: This is a list of lists in order to handle bulk calls...
        List<List<Bot_Appointment__c>> appointmentList = new List<List<Bot_Appointment__c>>();

        // Get the list of new and scheduled appointments
		List<Bot_Appointment__c> appointments = [SELECT Id, Name, JobType__c, AppointmentDate__c, AppointmentSlot__c 
                                             	 FROM Bot_Appointment__c 
                                                 WHERE Contact__r.Email =:sEmail 
                                                 AND Status__c IN ('New','Scheduled')];
        
        // Add all the new and scheduled appointments to the list
        if(appointments != null && appointments.size() > 0) {
        	appointmentList.add(appointments);    
        }
        return appointmentList;
    }
}