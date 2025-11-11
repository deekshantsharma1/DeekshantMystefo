public class StudentTriggerHandler {
    
    
    public static Boolean isFirstRun = true;

    public static void setReservationPercentage(List<Student__c> studentList) {
        
        Set<Id> parentIds = new Set<Id>();
        Set<Id> grandParentIds = new Set<Id>();

        for (Student__c stu : studentList) {
            if (stu.Parent__c != null) parentIds.add(stu.Parent__c);
            if (stu.Grandparent__c != null) grandParentIds.add(stu.Grandparent__c);
        }

        
        Set<Id> alumniIds = new Set<Id>();
        if (!parentIds.isEmpty() || !grandParentIds.isEmpty()) {
            for (Alumni__c alum : [
                SELECT Id FROM Alumni__c 
                WHERE Id IN :parentIds OR Id IN :grandParentIds
            ]) {
                alumniIds.add(alum.Id);
            }
        }

     
        for (Student__c stu : studentList) {
            Boolean hasParent = (stu.Parent__c != null && alumniIds.contains(stu.Parent__c));
            Boolean hasGrandParent = (stu.Grandparent__c != null && alumniIds.contains(stu.Grandparent__c));

            if (!hasParent && !hasGrandParent) {
                stu.Reservation_Percantage__c = 20;  // First-generation student 
            } else if (!hasParent && hasGrandParent) {
                stu.Reservation_Percantage__c = 10;  // Only grandparent studied
            } else if (hasParent && !hasGrandParent) {
                stu.Reservation_Percantage__c = 5;   // Only parent studied
            } else {

                
                stu.Reservation_Percantage__c = 0;   // Both studied
            }
        }
    }
}
