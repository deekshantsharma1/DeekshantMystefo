public class OpportunityApprovalHelper {

    public static void submitForApproval(
        List<Opportunity> opps,
        Set<Id> ownerIds
    ) {
        Map<Id, User> userMap = new Map<Id, User>(
            [SELECT Id, ManagerId FROM User WHERE Id IN :ownerIds]
        );

        List<Approval.ProcessSubmitRequest> requests =
            new List<Approval.ProcessSubmitRequest>();

        for (Opportunity opp : opps) {
            Approval.ProcessSubmitRequest req =
                new Approval.ProcessSubmitRequest();

            req.setObjectId(opp.Id);
            req.setComments('Amount changed by more than 20%');

            User owner = userMap.get(opp.OwnerId);

            if (owner != null && owner.ManagerId != null) {
                req.setNextApproverIds(
                    new List<Id>{ owner.ManagerId }
                );
            }

            requests.add(req);
        }

        if (!requests.isEmpty()) {
            for (Approval.ProcessSubmitRequest req : requests) {
                Approval.ProcessResult result =
                    Approval.process(req);
            }
        }
    }
}
