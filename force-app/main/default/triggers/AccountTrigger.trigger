trigger AccountTrigger on Account(after update) {
    AccountTriggerHandler handler = new AccountTriggerHandler();

    if (Trigger.isUpdate) {
        handler.handleContactStatus(Trigger.newMap, Trigger.oldMap);
    }
}