trigger OpportunityLineItemTrigger on OpportunityLineItem (after insert, after update) {
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        OpportunityLineItemTriggerHandler.submitForApproval(Trigger.new);
    }
}