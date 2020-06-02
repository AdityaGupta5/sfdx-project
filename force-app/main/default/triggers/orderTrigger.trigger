/**
* @name orderTrigger
* @description
**/
trigger orderTrigger on Order (before insert, after insert,before update, after update,before delete, after delete,after undelete) {
    try {
        if ( Trigger.New != null ){
            OrderHelper.AfterUpdate(Trigger.New, Trigger.Old);
        }
    }catch ( Exception e ){
        
    }
}