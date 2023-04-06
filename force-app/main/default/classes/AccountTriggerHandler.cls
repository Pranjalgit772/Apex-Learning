public class AccountTriggerHandler {

    public static void afterInsert(List<Account> account){

        AccountTriggerService.createContactOpportunity(findOutAccounts(account));
    }
    private static Set<Id> findOutAccounts(List<Account> accounts){
        Set<Id> AccountIds = new Set<Id>();

        for(Account account:accounts){
            if(account.Id != NULL){
                AccountIds.add(account.Id);
            }
        }
        return AccountIds;
    }
    
    public static void updateRating(List<Account> accounts){
        for(Account acc: accounts){
            if(acc.Industry != NULL && acc.Industry == 'Media'){
                acc.Rating = 'Hot';
            }
        }
        
    }
    
	public static void updateAddress(List<Account> accounts){
        for(Account acc : accounts){
            acc.CopyBillingToShipping__c = true;
            
            acc.ShippingCity = acc.BillingCity;
            acc.ShippingCountry = acc.BillingCountry;
            acc.ShippingPostalCode = acc.BillingPostalCode;
            acc.ShippingState = acc.BillingState;
            acc.ShippingStreet = acc.BillingStreet;
        }        
    }
    public static void createContact(List<Account> accounts){
        List<Contact> contacts = new List<Contact>();
        for(Account acc : accounts){
            Contact con = new Contact();
            con.LastName = acc.Name;
            con.AccountId = acc.Id;
            
            contacts.add(con);
        }
        if(!contacts.isEmpty()){
            insert contacts;
        }      
    }

    public static void updatePhoneOfContacts(List<Account> accountsList, Map<Id,Account> accountMap){
        Set<Id> accountIds = new Set<Id>();
        List<Contact> contacts = new List<Contact>();
        for(Account acc: accountsList){
            if(acc.Phone != NULL && acc.Phone != accountMap.get(acc.Id).Phone){
                AccountIds.add(acc.Id);
            }
        }
        for(Account account: [SELECT Id,Phone,(SELECT HomePhone FROM Contacts) FROM Account WHERE Id =: accountIds]) {
            if(account.Contacts != NULL) {
                for(Contact contact: account.Contacts) {
                    contact.HomePhone = account.Phone;
                    contacts.add(contact);
                }
            }
        }
        if(!contacts.isEmpty()) {
            update contacts;
        }
        
    }
    public static void updatePhoneOfContactsByMap(List<Account> accountsList, Map<Id,Account> accountMap){
        Map<Id,String> accountMapForPhone = new Map<Id,String>();

        Set<Id> accountIds = new Set<Id>();
        List<Contact> contactList = new List<Contact>();
        for(Account acc : accountsList) {
            if(acc.phone != null && acc.phone != accountMap.get(acc.Id).phone) {
                accountIds.add(acc.id);
                accountMapForPhone.put(acc.id,acc.phone);
            }
        }
        for(Contact con :[SELECT Id, Name, HomePhone, AccountId FROM Contact WHERE AccountId =: accountIds]){
            if(accountMapForPhone.containsKey(con.accountId)) {                
                con.HomePhone = accountMapForPhone.get(con.accountId);
                contactList.add(con);               
            }
        }
        if(!contactList.isEmpty()){
            update contactList;
        }       
        
    }
    
    public static void updateMailAddressOfContactsByMap(List<Account> accountList, Map<Id,Account> accountMap){
       
        Map<Id,Account> updatedAccount = new Map<Id,Account>();
        
        for(Account account : accountList){
            
            if(account.BillingCity != accountMap.get(account.Id).BillingCity 
            || account.BillingCountry != accountMap.get(account.Id).BillingCountry
            || account.BillingPostalCode != accountMap.get(account.Id).BillingPostalCode
            || account.BillingState != accountMap.get(account.Id).BillingState
            || account.BillingStreet != accountMap.get(account.Id).BillingStreet
            || account.BillingGeocodeAccuracy != accountMap.get(account.Id).BillingGeocodeAccuracy
            )
            updatedAccount.put(account.Id,account);
        }
        Set<Id> AccountIds = updatedAccount.keySet();
        List<Contact> contacts = [SELECT id, AccountId, name FROM contact WHERE AccountId =: AccountIds];
        for(Contact contact: contacts){
            contact.MailingCity = updatedAccount.get(contact.AccountId).BillingCity;
            contact.MailingCountry = updatedAccount.get(contact.AccountId).BillingCountry;
            contact.MailingPostalCode = updatedAccount.get(contact.AccountId).BillingPostalCode;
            contact.MailingState = updatedAccount.get(contact.AccountId).BillingState;
            contact.MailingStreet = updatedAccount.get(contact.AccountId).BillingStreet;
            contact.MailingGeocodeAccuracy = updatedAccount.get(contact.AccountId).BillingGeocodeAccuracy;
        }
        if(!contacts.isEmpty()){
            update contacts;
        }
    }
    
    public static void updateMailAddressOfContacts(List<Account> accountsList, Map<Id,Account> accountMap){
        Set<Id> AccountIds = new Set<Id>();
        List<Contact> contacts = new List<Contact>();

        for(Account account :accountsList){
            if(account.BillingCity != accountMap.get(account.Id).BillingCity 
            || account.BillingCountry != accountMap.get(account.Id).BillingCountry
            || account.BillingPostalCode != accountMap.get(account.Id).BillingPostalCode
            || account.BillingState != accountMap.get(account.Id).BillingState
            || account.BillingStreet != accountMap.get(account.Id).BillingStreet
            || account.BillingGeocodeAccuracy != accountMap.get(account.Id).BillingGeocodeAccuracy
            )
            AccountIds.add(account.Id);
        }
        
        List<Account> accounts = [SELECT Id, Name,(SELECT id, Name,AccountId FROM Contacts WHERE AccountId =:AccountIds) FROM Account WHERE id =: AccountIds];
        
        for(Account account :accounts){
            if(account.Contacts != NULL){
                for(Contact contact: account.Contacts){
                    contact.MailingCity = account.BillingCity;
                    contact.MailingCountry = account.BillingCountry;
                    contact.MailingPostalCode = account.BillingPostalCode;
                    contact.MailingState = account.BillingState;
                    contact.MailingStreet = account.BillingStreet;
                    contact.MailingGeocodeAccuracy = account.BillingGeocodeAccuracy;

                    contacts.add(contact);
                }
            }
        }       
        if(!contacts.isEmpty()){
            update contacts;
        }           
        
    }
    public static void updateShippingAddress(List<Account> accounts){
        for(Account acc : accounts){
            if(acc.CopyBillingToShipping__c == true){
       			acc.ShippingCity = acc.BillingCity;
                acc.ShippingCountry = acc.BillingCountry;
                acc.ShippingPostalCode = acc.BillingPostalCode;
                acc.ShippingState = acc.BillingState;
                acc.ShippingStreet = acc.BillingStreet;                     
            }           
        }        
    }
    public static void beforeUpdatePhone(List<Account> accounts, Map<Id,Account> accountMap){
        for(Account acc : accounts){
            if(accountMap!=null && acc.Phone != accountMap.get(acc.Id).Phone)
            acc.Description = 'Phone no is Updated Old Value:'+accountMap.get(acc.Id).Phone+' New Value: '+acc.Phone;
        }
    }
    public static void updateActive(List<Account> accountList, Map<Id,Account> accountMap){
        Set<Id> accountIds = new Set<Id>();
        for(Account acc : accountList){
            if(acc.Active__c == 'No' && acc.Active__c != accountMap.get(acc.Id).Active__c ){
                accountIds.add(acc.Id);
            }
        }
        List<Opportunity> Opportunities = [SELECT Id, Name, StageName,AccountId FROM Opportunity 
                                        WHERE AccountId =: accountIds AND StageName != 'Closed Won'];
        
        for(Opportunity  opp: Opportunities){
            opp.StageName = 'Closed Lost';
            
        }
        if(!Opportunities.isEmpty()){
            update Opportunities;
        }                                
    }

    public static void checkActive(List<Account> accounts){
        for(Account account : accounts){
            if(account.active__c == 'Yes'){
                account.addError('Active Account cannot be Deleted');
            }
        }
    }
    
    public static void updatePrevent(List<Account> accounts,Map<Id,Account> accountMap){
        for(Account acc: accounts){
            if((system.today()).daysBetween(Date.valueOf(acc.CreatedDate)) < 7){              
                if(acc != accountMap.get(acc.id)){
                    acc.addError('You can not edit the record if the record is created 7 days before');
                }
            }
        }
    }
    public static void checkProfile(List<Account> accounts){
        Id profileId = UserInfo.getProfileId();
        Profile profileName = [SELECT id,Name FROM Profile WHERE id =: profileId];
        for(Account account: accounts){
            if(profileName.name != 'System Administrator'){
                account.addError('Account can be deleted only if you are System Administrator');
            }
        }
    }
    public static void checkOpportunity(List<Account> accounts){
        Set<Id> AccountIds = new Set<Id>();
        for(Account account :accounts){
            if(account.Id != NULL){
                AccountIds.add(account.id);
            }
        }
        List<Opportunity> Opportunities = [SELECT Id,Name,AccountId FROM Opportunity WHERE AccountId =: AccountIds];
        Map<Id,Opportunity> opportunityMapByAccountId = new Map<Id,Opportunity>();
        for(Opportunity opportunity:Opportunities){
            if(opportunity.AccountId!= NULL){
                opportunityMapByAccountId.put(opportunity.AccountId, opportunity);
            }
        }
        for(Account account : accounts){
            if(opportunityMapByAccountId.containsKey(account.Id)){
                account.addError('You cannot Delete the Account it have some related Opportunities');
            }
        }
    }
    public static void checkCase(List<Account> accounts){
        Set<Id> AccountIds = new Set<Id>();
        for(Account account :accounts){
            if(account.Id != NULL){
                AccountIds.add(account.id);
            }
        }
        List<Case> Cases = [SELECT Id, AccountId FROM Case WHERE AccountId =: AccountIds];
        Map<Id,Case> caseMapByAccountId = new Map<Id,Case>();
        for(Case caseInstance:cases){
            if(caseInstance.AccountId != NULL){
                caseMapByAccountId.put(caseInstance.AccountId, caseInstance);
            }
        }
        for(Account account : accounts){
            if(caseMapByAccountId.containsKey(account.Id)){
                account.addError('You cannot Delete the Account it have some related Case');
            }
        }
    }
    public static void shareAccountWithStandardUser(List<Account> accounts){

        List<AccountShare> sharingAccounts = new List<AccountShare>();
        Id standardUserProfileId = [SELECT Id,Name FROM Profile WHERE Name = 'Standard User'].Id;
        Group publicGroup = [SELECT Id,DeveloperName FROM Group WHERE DeveloperName = 'Admins'];
        for (Account account : accounts) {
            for (User standardUser : [SELECT Id FROM User WHERE ProfileId = :standardUserProfileId]) {
                AccountShare accountShare = new AccountShare();
                accountShare.AccountId = account.Id;
                accountShare.UserOrGroupId = publicGroup.Id;
                accountShare.RowCause = 'Manual';
                accountShare.AccountAccessLevel = 'Edit';
                accountShare.OpportunityAccessLevel = 'Edit';
                sharingAccounts.add(accountShare);
            }
            if (sharingAccounts.size() > 0) {
                insert sharingAccounts;
            }
        }
    }

}