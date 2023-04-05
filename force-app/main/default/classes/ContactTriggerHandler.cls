public class ContactTriggerHandler {

    public static void sendEmailNotification(List<Contact> conList){
        
        List<Messaging.email> emailList = new List<Messaging.email>();
        
        for(Contact con : conList ){
            if(con.Email != null){
                Messaging.singleEmailMessage  emailMsg = new Messaging.singleEmailMessage();
                
                String[] toAddress = new String[]{con.email};
                emailMsg.setToAddresses(toAddress);
                
                String emailSub = 'Welcome to SalesForce Triggers '+con.LastName;
                emailMsg.setSubject(emailSub);
                
                String disname = 'Pranjal Jain Welcomes you at Salesforce';
                emailMsg.setSenderDisplayName(disname);
                
                String Content = 'Hi '+con.LastName+',<br/><br/>'+
                    'How are you ??<br/><br/>'+
                    'Begin Your Salesforce Developer Journey<br/><br/>'
                    +'Happy Learning<br/><br/>'
                    +'Thank You';
                emailMsg.setHtmlBody(Content);
                emailList.add(emailMsg);
            }
        }
        Messaging.sendEmail(emailList);
    }

    public static void preventSameEmail(List<Contact> contactsList){
        List<Contact> allContacts = [SELECT AccountId,Email FROM Contact];
        Set<String> allEmails = new Set<String>();
        for(Contact contact : allContacts){
            allEmails.add(contact.Email);        
        }      
        for(Contact contact : contactsList){
            if(allEmails.contains(contact.Email)){
                contact.addError('You Cannot create account of having same Email');
            }
        }
    }
    
}