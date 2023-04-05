trigger OpportunityTrigger on Opportunity (before insert, before update, before delete, after insert,after undelete, after delete) {
	if(Trigger.isBefore){
        if(Trigger.isInsert){
        	OpportunityTriggerHandler.updateOpportunityAmount(Trigger.new);
			OpportunityTriggerHandler.updateDescription(Trigger.new);
            // OpportunityTriggerHandler.updateOpportunityStage(Trigger.new,Trigger.oldMap);
   		}
        if(Trigger.isUpdate){
            OpportunityTriggerHandler.updateDescription(Trigger.new);
            OpportunityTriggerHandler.updateOpportunityStage(Trigger.new,Trigger.oldMap);
            OpportunityTriggerHandler.updateStageName(Trigger.new,Trigger.oldMap);
        }
        if(Trigger.isDelete){
            OpportunityTriggerHandler.checkOpportunity(Trigger.old);
        }
    }
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            OpportunityTriggerHandler.updateAccountAnnualRevenue(Trigger.new);
        }
        if(Trigger.isDelete){
            OpportunityTriggerHandler.updateAccountAnnualRevenue(Trigger.old);
        }
        if(Trigger.isUndelete){
            OpportunityTriggerHandler.updateAccountAnnualRevenue(Trigger.new);
        }
    }
}