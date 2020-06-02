global class WarehouseSyncSchedule implements Schedulable{
  // implement scheduled code here
    global void execute(SchedulableContext sc) {
        WarehouseCalloutService.runWarehouseEquipmentSync();
        //String cronExp = '0 0 1 * * ?'; // 1 AM PST
        //String jobId = System.schedule('WarehouseSyncScheduleTest', cronExp, new WarehouseSyncSchedule());
        //System.schedule('Scheduled Job 1', '0 0 1 * * ?', new WarehouseSyncSchedule());
    }
}