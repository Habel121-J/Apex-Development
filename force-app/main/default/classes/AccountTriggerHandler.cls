public with sharing class AccountTriggerHandler {

    private final List<Account> newAccounts = Trigger.new;
    private final Map<Id,Account> oldAccountMap = (Map<Id,Account>) Trigger.oldMap;

    @TestVisible
    private class AccountTriggerHandlerException extends Exception{}

    public void execute(){
        if(!Trigger.isExecuting){
            throw new AccountTriggerHandlerException('Please execute this class from a trigger.');
        }
        if(Trigger.isBefore){
            if(Trigger.isInsert){
                this.beforeInsert();
            }
            if(Trigger.isUpdate){
                this.beforeUpdate();
            }
        }
    }

    private void beforeInsert(){
        this.concatFields();
    }

    private void beforeUpdate(){
        this.concatFields();
    }

    @TestVisible
    private void concatFields(){
        if(this.newAccounts == null || this.oldAccountMap == null){
            throw new IllegalArgumentException('IllegalArgument Exception: No newAccounts were passed into the AccountTriggerHandler.');
        }
        for(Account acc : this.newAccounts){
            if((String.isEmpty(acc.BillingCity) && String.isEmpty(acc.BillingCountry)) || //before insert criteria
            (oldAccountMap <> null && (oldAccountMap.get(acc.Id).BillingCity == acc.BillingCity || oldAccountMap.get(acc.Id).BillingCountry == acc.BillingCountry)))
            {
                continue;
            }
            acc.Concat__c = acc.BillingCity +' : '+acc.BillingCountry;
        }   
    }
}