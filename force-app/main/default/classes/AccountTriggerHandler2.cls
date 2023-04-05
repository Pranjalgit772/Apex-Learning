public class AccountTriggerHandler2 {
	public static void updateAddress(List<Account> accounts){
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
}