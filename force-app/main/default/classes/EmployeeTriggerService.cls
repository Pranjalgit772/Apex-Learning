public class EmployeeTriggerService {
    public static void updateActive(Set<Id> AccountIds){
        
        List<Employee__c> updatedEmployee = [SELECT id,Active__c,accountId__c FROM Employee__c WHERE accountId__c =:AccountIds];
        for(Employee__c employee: updatedEmployee){
            employee.Active__c = true;
        }
        if(!updatedEmployee.isEmpty()){
            System.debug('Checkbox is Active');
            update updatedEmployee; 
        }
        
    }
    public static void updateEmployeeCountOnAccount(Set<Id> AccountIds){
        
        List<Account> accounts = [SELECT id, Name, Present_Employee_Count__c, Left_Employee_Count__c,(SELECT id, AccountId__c, Name FROM Employees__r ) 
        FROM Account WHERE id =: AccountIds];

        for(Account account : accounts){
            if(AccountIds.contains(account.id)){
                account.Present_Employee_Count__c = account.Employees__r.size();
                account.Left_Employee_Count__c = account.Employees__r.size();
                
            }
        }
        if(!accounts.isEmpty()){
            System.debug('Accounts Updated');
            update accounts;
        }

    }
}