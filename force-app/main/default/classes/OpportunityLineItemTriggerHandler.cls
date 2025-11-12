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
                if (opp.Status__c != 'Submitted for Approval') {
                    opp.Status__c = 'Submitted for Approval';
                    oppToUpdate.add(opp);
                }
            }
            if (!oppToUpdate.isEmpty()) {
                update oppToUpdate;
            }
            // Submit for approval
        for (Opportunity opp : oppToUpdate) {
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setObjectId(opp.Id);
            try {
                Approval.ProcessResult result = Approval.process(req);
                System.debug('Approval submitted for Opportunity Id: ' + opp.Id);
            } catch (Exception e) {
                System.debug('Error while submitting for approval: ' + e.getMessage());
            }

        }

    }
}
}