public with sharing class OpportunityLineItemTriggerHandler {

    private static Boolean isFirstrun = true;
    public static void submitForApproval(List<OpportunityLineItem> oliList   ) {

        if(!isFirstrun){

            return;
        }
        isFirstrun = false;
        // created a set to storee opportunity IDs
        Set<Id> oppIds = new Set<Id>();
        for(opportunitylineitem oli:oliList){
            if(oli.Discount!= null && oli.Discount > 20 ){
                oppIds.add(oli.opportunityID);//if opportunity needs approval then we cna add oppid to set

            }
            if(oppIds.isEmpty()){
                return;
            }
            // now we need to fetch related opportunities
            List<Opportunity> oppList = [select Id,	Status__c from Opportunity WHERE Id IN:oppIds];

            List<Opportunity> opptoupdate = new List<Opportunity>();

            for(opportunity opp :oppList){
                //will put the logic here to chek if opp needs approval or not
            }

        }

    }
}