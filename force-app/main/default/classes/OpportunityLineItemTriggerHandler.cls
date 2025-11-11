public with sharing class OpportunityLineItemTriggerHandler {

    private static Boolean isFirstrun = true;
    public static void submitForApproval(List<OpportunityLineItem> oliList   ) {

        if(!isFirstrun){

            return;
        }
        isFirstrun = false;

    }
}