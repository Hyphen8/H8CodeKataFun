/**
 * @description       : wrapper class for storing board details in
 * @author            : daniel@hyphen8.com
 * @last modified on  : 02/02/2021
 * @last modified by  : daniel@hyphen8.com
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   24/01/2021   daniel@hyphen8.com   Initial Version
**/
public class BoardWrapper {

    @AuraEnabled public List<LaneWrapper> lanes;
    
    public class LaneWrapper {
    
        @AuraEnabled public string laneName;
    
        @AuraEnabled public string laneID;
    
        @AuraEnabled public integer laneOrder;
    
        @AuraEnabled public List<CardWrapper> cards;
    
    }

    public class CardWrapper {
    
        @AuraEnabled public List<MemberWrapper> members;

        @AuraEnabled public List<TagsWrapper> tags;

        @AuraEnabled public string cardName;

        @AuraEnabled public string cardId;

        @AuraEnabled public integer cardNumber;

        @AuraEnabled public date cardDueDate;

        @AuraEnabled public integer cardOrder;

        @AuraEnabled public boolean cardDueDatePassed;

        @AuraEnabled public string cardDescription;

    }

    public class MemberWrapper {

        @AuraEnabled public string userName;

        @AuraEnabled public string userImageURL;

        @AuraEnabled public string userId;

    }

    public class TagsWrapper {

        @AuraEnabled public string tagColour;

        @AuraEnabled public string tagName;

        @AuraEnabled public string tagId;

        @AuraEnabled public string boardTagId;

    }
}
