public class OpportunityTriggerHandler {

    private static Boolean isFirstRun = true;

    public static void handleAfterUpdate(
        List<Opportunity> newList,
        Map<Id, Opportunity> oldMap
    ) {
        if (!isFirstRun) return;
        isFirstRun = false;

        List<Opportunity> oppsForApproval = new List<Opportunity>();
        Set<Id> ownerIds = new Set<Id>();

        for (Opportunity opp : newList) {
            Opportunity oldOpp = oldMap.get(opp.Id);

            if (oldOpp.Amount == null || opp.Amount == null) continue;

            Decimal changePercent =
                ((opp.Amount - oldOpp.Amount) / oldOpp.Amount) * 100;

            if (Math.abs(changePercent) > 20 &&
                opp.StageName != 'Submitted for Approval'
            ) {
                oppsForApproval.add(opp);
                ownerIds.add(opp.OwnerId);
            }
        }

        if (!oppsForApproval.isEmpty()) {
            OpportunityApprovalHelper.submitForApproval(
                oppsForApproval,
                ownerIds
            );
        }
    }
}
