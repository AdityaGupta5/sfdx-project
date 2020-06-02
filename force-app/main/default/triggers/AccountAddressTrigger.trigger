trigger AccountAddressTrigger on Account (before insert, before update) {

    if(Trigger.isInsert || Trigger.isUpdate) {
        if(Trigger.isBefore) {
            for(Account accnt : Trigger.New) {
                if(accnt.Match_Billing_Address__c && String.isNotBlank(accnt.BillingPostalCode)) {
                    accnt.ShippingPostalCode = accnt.BillingPostalCode;
                }
            }    
        }  
    }
}