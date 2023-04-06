public class EmployeeTriggerHandler {

    public static void afterInsert(List<Employee__c> employeeList){
        EmployeeTriggerService.updateEmployeeCountOnAccount(findOutAccounts(employeeList));
    }
    public static void afterDelete(List<Employee__c> employeeList){
        EmployeeTriggerService.updateEmployeeCountOnAccount(findOutAccounts(employeeList));
    }
    public static void afterUndelete(List<Employee__c> employeeList){
        //EmployeeTriggerService.updateActive(findOutAccounts(employeeList));
        EmployeeTriggerService.updateEmployeeCountOnAccount(findOutAccounts(employeeList));
    }
    private static Set<Id> findOutAccounts(List<Employee__c> employeeList){
        Set<Id> AccountIds = new Set<Id>();

        for(Employee__c employee: employeeList){
            if(employee.accountId__c != NULL){
                AccountIds.add(employee.accountId__c);
            }
        }
        return AccountIds;
    }
}