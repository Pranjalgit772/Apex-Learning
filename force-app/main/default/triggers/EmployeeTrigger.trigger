trigger EmployeeTrigger on Employee__c (after insert, after undelete, after delete) {
    
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            EmployeeTriggerHandler.updateEmployeeCountOnAccount(Trigger.new);
        }
        if(Trigger.isDelete){
            EmployeeTriggerHandler.updateEmployeeCountOnAccount(Trigger.old);
        }
        if(Trigger.isUndelete){
            System.debug('Enter in Undelete');
            EmployeeTriggerHandler.updateActive(Trigger.new);
            EmployeeTriggerHandler.updateEmployeeCountOnAccount(Trigger.new);
        }
    }
}