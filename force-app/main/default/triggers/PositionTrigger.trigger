trigger PositionTrigger on Position__c (before insert) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
        	PositionTriggerHandler.checkPosition(Trigger.new);
   		}
    }
}