public class EmployeeTriggerHandler {
    public static void updateActive(List<Employee__c> employeeList){
        Set<Id> AccountIds = new Set<Id>();

        for(Employee__c employee: employeeList){
            if(employee.accountId__c != NULL){
                AccountIds.add(employee.accountId__c);
            }
        }
        
        List<Employee__c> updatedEmployee = [SELECT id,Active__c,accountId__c FROM Employee__c WHERE accountId__c =:AccountIds];
        for(Employee__c employee: updatedEmployee){
            employee.Active__c = true;
        }
        if(!updatedEmployee.isEmpty()){
            System.debug('Checkbox is Active');
            update updatedEmployee; 
        }
        
    }
    public static void updateEmployeeCountOnAccount(List<Employee__c> employeeList){
        Set<Id> AccountIds = new Set<Id>();

        for(Employee__c employee: employeeList){
            if(employee.accountId__c != NULL){
                AccountIds.add(employee.accountId__c);
            }
        }
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