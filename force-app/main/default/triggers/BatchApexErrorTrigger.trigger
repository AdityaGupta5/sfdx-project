trigger BatchApexErrorTrigger on BatchApexErrorEvent (after insert) {

    List<BatchLeadConvertErrors__c> batchLeadConvertErrList = new List<BatchLeadConvertErrors__c>();
    For(BatchApexErrorEvent batchApxErrEvn : Trigger.New) {
        BatchLeadConvertErrors__c batchLeadConvertErr = new BatchLeadConvertErrors__c();
        batchLeadConvertErr.AsyncApexJobId__c = batchApxErrEvn.AsyncApexJobId;
        batchLeadConvertErr.Records__c = batchApxErrEvn.JobScope;
        batchLeadConvertErr.StackTrace__c = batchApxErrEvn.StackTrace;
        batchLeadConvertErrList.add(batchLeadConvertErr);
    }
    If(batchLeadConvertErrList != null && batchLeadConvertErrList.size() > 0) {
        Insert batchLeadConvertErrList;
    }
}