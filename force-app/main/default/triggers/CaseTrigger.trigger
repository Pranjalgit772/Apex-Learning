trigger CaseTrigger on Case (after insert) {
    if(Trigger.isInsert){
        if(Trigger.isAfter){
            CaseTriggerHandler.updateAccountCaseNo(Trigger.new);
            CaseTriggerHandler.updateTotalPartnerAndCustomerCase(Trigger.new);
        }
    }
}