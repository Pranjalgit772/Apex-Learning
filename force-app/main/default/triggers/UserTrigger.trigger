trigger UserTrigger on User (before insert) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            UserTriggerHandler.createUserAddOnPublicGroup(Trigger.new);
        }
    }
}