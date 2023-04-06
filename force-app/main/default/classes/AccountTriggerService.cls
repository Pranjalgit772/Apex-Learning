public class AccountTriggerService {

    public static void createContactOpportunity(Set<Id> AccountIds){

        List<Account> accounts = [SELECT Id,Name FROM Account WHERE Id =: AccountIds];
        List<Contact> contacts = new List<Contact>();
        List<Opportunity> Opportunities = new List<Opportunity>();
        for(Account acc : accounts){
            if(acc.Contact__c == true){
                Contact con = new Contact();
                con.LastName = acc.Name;
                con.AccountId = acc.Id;
                contacts.add(con);
            }
            if(acc.Opportunity__c == true && acc.Active__c =='Yes'){
                Opportunity opp = new Opportunity();
                opp.Name = acc.Name;
                opp.CloseDate = System.today();
                opp.StageName = 'Prospecting';
                opp.AccountId = acc.Id;
                Opportunities.add(opp);
            }
        }
        if(!contacts.isEmpty()){
            insert contacts;
        }
        if(!Opportunities.isEmpty()){
            insert Opportunities;
        }   
    }
}