public with sharing class OpportunityTriggerHandler {
    private List<Opportunity> oppList = Trigger.new;
    private Map<Id,Opportunity> oldRecords = (Map<Id,Opportunity>)Trigger.oldMap;   
    
    public void execute(){
        if(Trigger.isAfter){
            if(Trigger.isInsert){
                this.afterInsert();
            }
            if(Trigger.isUpdate){
                this.afterUpdate();
            }
        }
    }

    private void afterUpdate(){
     updateTotalOnParent(this.oppList,this.oldRecords);            

    }
    private void afterInsert(){
        this.updateTotalOnParent(oppList, null);
        

    }
    
    private void updateTotalOnParent(List<Opportunity> oppList, Map<Id,Opportunity> oldRecords){
     Set<Id> accIds = new Set<Id>(); 
     Map<Id,Decimal> mapOfRevenue = new Map<Id,Decimal>();
     List<Account> accList = new List<Account>();
        for(Opportunity opp : oppList){
            if(opp.Amount <> null && opp.AccountId <> null || (oldRecords <> null && oldRecords.get(opp.Id).Amount <> opp.Amount)){
                accIds.add(opp.AccountId);
                if(oldRecords?.get(opp.AccountId)?.AccountId <> opp.AccountId){
                    accIds.add(oldRecords?.get(opp.Id).AccountId);
                }
            }
        }

        for(AggregateResult ag : [SELECT SUM(Amount)cnt,AccountId FROM Opportunity WHERE Amount <> null GROUP BY AccountId]){
            mapOfRevenue.put((String)ag.get('AccountId'), (Decimal)ag.get('cnt'));

        }
        
        for(Account acc : [SELECT Id,Total_Amount__c FROM Account WHERE Id IN : accIds]){
            acc.Total_Amount__c  = mapOfRevenue.get(acc.Id);
            accList.add(acc);
        }
        if(!accList.isEmpty()){
            update accList;
        }

        
    }

}
