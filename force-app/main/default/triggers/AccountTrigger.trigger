trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update) {
     if(Trigger.isInsert){
        if(Trigger.isBefore){
            AccountTriggerHandler.updateAddress(Trigger.new);
            AccountTriggerHandler.updateRating(Trigger.new);
        }
        if(Trigger.isAfter){
            AccountTriggerHandler.createContactOpportunity(Trigger.new);
            AccountTriggerHandler.shareAccountWithStandardUser(Trigger.new);
           //AccountTriggerHandler.createContact(Trigger.new); 
        }
    }
    if(Trigger.isUpdate){
        if(Trigger.isBefore){
            AccountTriggerHandler.updateShippingAddress(Trigger.new);
            AccountTriggerHandler.beforeUpdatePhone(Trigger.new, Trigger.oldMap);
            AccountTriggerHandler.updateRating(Trigger.new);
            // AccountTriggerHandler.updatePrevent(Trigger.new, Trigger.oldMap);
        }
        if(Trigger.isAfter){
        //    AccountTriggerHandler.updatePhoneOfContacts(Trigger.new, Trigger.oldMap);
            AccountTriggerHandler.updatePhoneOfContactsByMap(Trigger.new, Trigger.oldMap);
            AccountTriggerHandler.updateMailAddressOfContactsByMap(Trigger.new,Trigger.oldMap);
        //    AccountTriggerHandler.updateMailAddressOfContacts(Trigger.new, Trigger.oldMap);
            AccountTriggerHandler.updateActive(Trigger.new,Trigger.oldMap);
        }
	}
    if(Trigger.isDelete){
        if(Trigger.isBefore){
            AccountTriggerHandler.checkActive(Trigger.old);
            AccountTriggerHandler.checkProfile(Trigger.old);
            AccountTriggerHandler.checkOpportunity(Trigger.old);
            AccountTriggerHandler.checkCase(Trigger.old);           
        }
    }
}