/**
 * @name product2Trigger
 * @description Trigger to notify staff of low levels of inventory
**/
trigger product2Trigger on Product2 (
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    try {
        if(Trigger.isAfter && Trigger.isUpdate) {
            Product2Helper.AfterUpdate(Trigger.New);
        }
    } catch ( Exception e ){
        //A good developer would do something with this Exception!
    }
}