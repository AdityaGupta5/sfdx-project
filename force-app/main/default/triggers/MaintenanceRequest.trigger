trigger MaintenanceRequest on Case (before update, after update) {
    // call MaintenanceRequestHelper.updateWorkOrders 
    If((Trigger.isBefore || Trigger.isAfter) && Trigger.isUpdate) {
        MaintenanceRequestHelper.updateWorkOrders(Trigger.New, Trigger.Old);
    }
}