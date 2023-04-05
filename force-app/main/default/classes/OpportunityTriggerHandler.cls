public class OpportunityTriggerHandler {
	public static void updateOpportunityAmount(List<Opportunity> opportunities){
        
        Account account = [SELECT Id,Name,Recent_Opportunity_Amount__c FROM Account Where Id =: opportunities[0].AccountId];
        
        account.Recent_Opportunity_Amount__c = opportunities[0].Amount;
        
        update account;
    }
    
    public static void updateDescription(List<Opportunity> Opportunity){
        for(Opportunity opp : Opportunity){

            if(opp.Amount != NULL && opp.Amount > 100000){
                opp.Description = 'Hot Opportunity';
            }
            if(opp.StageName == 'Closed Lost'){
                opp.Description = 'Opportunity is Closed Lost';
            }
            else if(opp.StageName == 'Closed Won'){
                opp.Description = 'Opportunity is Closed Won';
            }
            else {
                opp.Description = 'Opportunity is Open';
            }
        }
    }

    public static void updateOpportunityStage(List<Opportunity> Opportunities,Map<Id,Opportunity> opportunityMap){

        List<Task> taskList = new List<Task>();
        for(Opportunity opp : Opportunities){
            if(opp.StageName != NULL && opp.StageName != opportunityMap.get(opp.Id).StageName){
                Task instance = new Task();
                instance.OwnerId = opp.OwnerId;
                instance.Status = 'In Progress';
                instance.WhatId = opp.Id;
                instance.Subject = 'Opportunity Stage is '+opp.StageName;
                System.debug('Instance create' );
                taskList.add(instance);                
            }
        }
        if(!taskList.isEmpty()){
            System.debug('TaskList :'+taskList);
            insert taskList;
        }
    }
    public static void checkOpportunity(List<Opportunity> opprtunities){       
        Id profileId = UserInfo.getProfileId();
        Profile profileName = [SELECT id,Name FROM Profile WHERE id =: profileId];

        for(Opportunity opportunity: opprtunities){
            if(opportunity.StageName == 'Closed Lost' && profileName.Name != 'System Administrator'){
                opportunity.addError('If Opportunity stage is closed Lost so Only System Administrator can delete opportunity');
            }
        }
    }
    public static void updateStageName(List<Opportunity> Opportunities,Map<Id,Opportunity> OpportunityMap){
        for(Opportunity opportunity: Opportunities){
            if(opportunity.StageName == 'Closed Lost' 
            && opportunity.StageName != OpportunityMap.get(opportunity.id).StageName
            && opportunity.Closed_Lost_Reason__c == NULL){
                opportunity.addError('Please populate Closed Lost Reason');
            }
        }
    }
    public static void updateAccountAnnualRevenue(List<Opportunity> Opportunities){
        Set<Id> AccountIds = new Set<Id>();
        for(Opportunity opportunity :Opportunities){
            if(opportunity.AccountId != NULL){
                AccountIds.add(opportunity.AccountId);
            }
        }
        List<Account> accounts = [SELECT id,AnnualRevenue,(SELECT accountId,Amount FROM Opportunities) 
        FROM account WHERE id =: AccountIds];

        for(Account account :accounts){
            Decimal total = 0;
            for(Opportunity opportunity: account.opportunities){
                total+= opportunity.Amount;
            }
            account.AnnualRevenue = total;
        }
        if(!accounts.isEmpty()){
            update accounts;
        }
    }
}