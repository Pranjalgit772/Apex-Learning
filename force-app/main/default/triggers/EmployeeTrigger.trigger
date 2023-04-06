trigger EmployeeTrigger on Employee__c (after insert, after undelete, after delete) {
    
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            EmployeeTriggerHandler.afterInsert(Trigger.new);
        }
        if(Trigger.isDelete){
            EmployeeTriggerHandler.afterDelete(Trigger.old);
        }
        if(Trigger.isUndelete){
            EmployeeTriggerHandler.afterUndelete(Trigger.new);
        }
    }
}