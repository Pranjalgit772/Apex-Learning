public class CaseTriggerHandler {
    public static void updateAccountCaseNo(List<Case> cases){
        List<Account> accountList = new List<Account>();
        Set<Id> caseIds = new Set<Id>();
        Map<Id,Case> caseMapById = new Map<Id,Case>();
        
        for(Case cs: cases){
            if(cs.AccountId != Null ){
                caseIds.add(cs.AccountId);
                caseMapById.put(cs.AccountId, cs);
            }   
        }

        List<Account> accounts = [SELECT Id,Name,Latest_Case_No__c FROM Account WHERE Id =: caseIds];

        for(Account account:accounts){ 
            if(caseMapById.containsKey(account.Id)){
                account.Latest_Case_No__c = caseMapById.get(account.Id).CaseNumber;
            }               
            accountList.add(account);
        }
        
        if(!accountList.isEmpty()){
            update accountList;
        }       
    }

    public static void updateTotalPartnerAndCustomerCase(List<Case> cases){
        
        List<Case> partnerCases = [SELECT RecordType.DeveloperName,AccountId FROM Case WHERE RecordType.DeveloperName =: 'Partner_Case'];
        List<Case> CustomerCases = [SELECT RecordType.DeveloperName,AccountId FROM Case WHERE RecordType.DeveloperName =: 'Customer_Case'];
        
        Map<Id,Integer> accountIdToPartnerCaseMap = new Map<Id,Integer>();
        Map<Id,Integer> accountIdToCustomerCaseMap = new Map<Id,Integer>();

        for(Case partnerCase :partnerCases){
            if(!accountIdToPartnerCaseMap.containsKey(partnerCase.AccountId)){
                accountIdToPartnerCaseMap.put(partnerCase.AccountId, 0);
            }
            accountIdToPartnerCaseMap.put(partnerCase.AccountId, accountIdToPartnerCaseMap.get(partnerCase.AccountId)+1 );
            
        }
        for(Case customerCase : customerCases){
            if(!accountIdToCustomerCaseMap.containsKey(customerCase.AccountId)){
                accountIdToCustomerCaseMap.put(customerCase.AccountId, 0);
            }
            accountIdToCustomerCaseMap.put(customerCase.AccountId, accountIdToCustomerCaseMap.get(customerCase.AccountId)+1 );
           
        }
        Set<Id> AccountIds = new Set<Id>();
        for(Case caseInstance : cases){
            if(caseInstance.AccountId != NULL){
                AccountIds.add(caseInstance.AccountId);
            }
        }
        List<Account> updatedAccount = [SELECT Id FROM Account WHERE id =: AccountIds];
        for(Account account: updatedAccount){
            account.Total_Customer_Cases__c = accountIdToCustomerCaseMap.get(account.id);
            account.Total_Partner_Cases__c = accountIdToPartnerCaseMap.get(account.id);
        }
        if(!updatedAccount.isEmpty()){
            update updatedAccount;
        }
        
    }

}