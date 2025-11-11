trigger StudentTrigger on Student__c (before insert, before update) {
    if (StudentTriggerHandler.isFirstRun) {
        StudentTriggerHandler.isFirstRun = false;

        if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
            StudentTriggerHandler.setReservationPercentage(Trigger.new);
        }
    }
    //testing for deployment
}
