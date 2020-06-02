trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {

    List<Task> taskList = new List<Task>();
    List<Opportunity> opptyList = [Select Id, StageName, (SELECT Id,Priority,Status,Subject,WhatId,WhoId FROM Tasks Where Status != 'Completed') From Opportunity Where Id IN: Trigger.New AND StageName =: 'Closed Won'];
    
    if(Trigger.isInsert || Trigger.isUpdate) {
        if(Trigger.isAfter) {
            for(Opportunity oppty : opptyList) {
                if(oppty.Tasks.size() == 0) {
                    Task newTask = new Task(whatID = oppty.ID, Subject='Follow Up Test Task');
                    taskList.add(newTask);
                }    
            }
            if(taskList != null && taskList.size() > 0) {
            	Insert taskList;    
            }
        }
    }
}