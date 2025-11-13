public with sharing class StarRatingController {
    @AuraEnabled(cacheable=true)
    public static Integer getRating(Id recordId) {
        Account acc = [SELECT Rating__c FROM Account WHERE Id = :recordId LIMIT 1];
        return acc.Rating__c != null ? Integer.valueOf(acc.Rating__c) : 0;
    }

    @AuraEnabled
    public static void updateRating(Id recordId, Integer newRating) {
        Account acc = new Account(Id = recordId, Rating__c = String.valueOf(newRating));
        update acc;
    }
}