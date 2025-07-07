trigger AccountTrigger on Account (before insert,before update) {
    new AccountTriggerHandler().execute();
}