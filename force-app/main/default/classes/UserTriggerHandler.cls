public with sharing class UserTriggerHandler {
    public static void createUserAddOnPublicGroup(List<User> users) {
        Group publicGroup = [SELECT Id FROM Group WHERE DeveloperName = 'Admins'];
        Profile profileName = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        List<GroupMember> groupMembers = new List<GroupMember>();
        if(publicGroup != NULL) {
            for(User user : users) {
                if(user.IsActive == TRUE && user.ProfileId == profileName.Id) {
                    GroupMember groupMember = new GroupMember();
                    groupMember.groupId = publicGroup.Id;
                    groupMember.UserOrGroupId = user.Id;
                    groupMembers.add(groupMember);
                }
            }
        }
        if(!groupMembers.isEmpty()) {
            insert groupMembers;
        }
    }
}