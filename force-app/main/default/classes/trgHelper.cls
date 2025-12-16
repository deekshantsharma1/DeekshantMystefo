public with sharing class trgHelper {
    public static void trgMethod(List<Opportunity> oppList, Map<Id,Opportunity> oldMap)  {

            Set<Id> parentIds = new Set<Id>(); // to store parent Ids

            if(!oppList.isEmpty())
            {

                for(Opportunity newOpp : oppList)
                {
                    if(oldMap != null)
                    {
                        Opportunity oldOpp =oldMap.get(newOpp.Id);

                        
                    }
                }
            }
             

    }
}