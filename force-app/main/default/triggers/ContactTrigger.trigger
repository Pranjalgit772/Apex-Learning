trigger ContactTrigger on Contact (before insert) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            ContactTriggerHandler.sendEmailNotification(Trigger.new);
            ContactTriggerHandler.preventSameEmail(Trigger.new);
        }
    }
}