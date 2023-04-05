public class PositionTriggerHandler {

    public static void checkPosition(List<Position__c> positions){
        for(Position__c position: positions){
            if(position.OpenDate__c == NULL){
            	position.OpenDate__c = System.today();    
            }
            if(position.MinPay__c == NULL){
                position.MinPay__c = 10000;
            }
            if(position.MaxPay__c == NULL){
                position.MaxPay__c = 15000;
            }
        }
    }
}