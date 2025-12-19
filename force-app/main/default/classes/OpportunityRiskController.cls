public with sharing class OpportunityRiskController {


    @AuraEnabled(cacheable=true)
    public static Opportunity getOpportunity(Id recordId) {
    return [
    SELECT Id, Name, Amount, StageName, CloseDate, Primary_Contact__c
    FROM Opportunity
    WHERE Id = :recordId
    ];
    }
    
    
    @AuraEnabled
    public static void submitForApproval(Id recordId) {
    Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
    req.setObjectId(recordId);
    Approval.process(req);
    }
    }