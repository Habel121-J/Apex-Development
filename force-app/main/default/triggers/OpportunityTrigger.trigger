trigger OpportunityTrigger on Opportunity (after update,after insert) {

    new OpportunityTriggerHandler().execute();

}