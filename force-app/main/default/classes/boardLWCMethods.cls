/**
 * @description       : Series of methods to support the management of boards within Salesforce
 * @author            : daniel@hyphen8.com
 * @last modified on  : 02/02/2021
 * @last modified by  : daniel@hyphen8.com
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   19/01/2021   daniel@hyphen8.com   Initial Version
**/
public with sharing class boardLWCMethods {

    @AuraEnabled
    public static BoardWrapper.CardWrapper getCard(string recordId){
        try {
            system.debug('recordId > ' + recordId);

            Card__c card = [SELECT ID, Lane__c, Name, Order__c, Card_Number__c, Due_Date__c, Due_Date_Passed__c, Description__c, (SELECT ID, Card__c, User__c FROM Card_Members__r), (SELECT ID, Card__c, Tag_Colour__c, Tag_Name__c, Board_Tag__c FROM Card_Tags__r) FROM Card__c WHERE ID=:recordId];

            Map<ID, List<BoardWrapper.MemberWrapper>> mapOfMembers;
            if(card.Card_Members__r != null){
                mapOfMembers = boardLWCHelperMethods.getCardMapOfMembers(card.Card_Members__r);
            } else {
                mapOfMembers = new Map<ID, List<BoardWrapper.MemberWrapper>>();
            }
            
            List<BoardWrapper.MemberWrapper> thisCardMembers;

            if(mapOfMembers.containsKey(card.Id)){
                thisCardMembers = mapOfMembers.get(card.Id);
            } else {
                thisCardMembers = new List<BoardWrapper.MemberWrapper>();
            }
            
            Map<ID, List<BoardWrapper.TagsWrapper>> mapOfTags;
            if(card.Card_Tags__r != null){
                mapOfTags = boardLWCHelperMethods.getCardMapOfTags(card.Card_Tags__r);
            } else {
                mapOfTags = new Map<ID, List<BoardWrapper.TagsWrapper>>();
            }
            
            List<BoardWrapper.TagsWrapper> thisCardTags;
            if(mapOfTags.containsKey(card.Id)){
                thisCardTags = mapOfTags.get(card.Id);
            } else {
                thisCardTags = new List<BoardWrapper.TagsWrapper>();
            }

            BoardWrapper.CardWrapper cw = new BoardWrapper.CardWrapper();
            cw.members = thisCardMembers;
            cw.tags = thisCardTags;
            cw.cardDueDate = card.Due_Date__c;
            cw.cardDueDatePassed = card.Due_Date_Passed__c;
            cw.cardId = card.Id;
            cw.cardName = card.Name;
            cw.cardNumber = integer.valueOf(card.Card_Number__c);
            cw.cardOrder = integer.valueOf(card.Order__c);
            cw.cardDescription = card.Description__c;
            return cw;
            
        } catch (Exception e) {
       
            throw new AuraHandledException(e.getMessage());
       
        }
    }


    /**
     * @description     method to delete or archive a card
     * @param           string recordId
     * @param           string type
     * @return          string
    **/
    @AuraEnabled
    public static string deleteArchiveCard(string recordId, string type){
        try {

            ID laneID = [SELECT ID FROM Lane__c WHERE Name=:type AND Order__c =:0 LIMIT 1].Id;

            Card__c card = [SELECT ID, Lane__c, Card_Status__c, Order__c FROM Card__c WHERE ID=:recordId];

            List<Card__c> listOfExistingCards = [SELECT ID, Card_Status__c, Order__c FROM Card__c WHERE Lane__c =: card.Lane__c AND ID !=:recordId AND Card_Status__c=:'Live' ORDER BY Order__c ASC];
            
            List<Card__c> updateList = new List<Card__c>();

            integer cardCount = 1;

            for(Card__c liveCard:listOfExistingCards) {
                liveCard.Order__c = cardCount;
                cardCount = cardCount + 1;
                updateList.add(liveCard);
            }

            database.update(updateList);
            
            card.Lane__c = laneID;
            card.Card_Status__c = type;
            card.Order__c = null;
            update card;

            return 'Success';
            
        } catch (Exception e) {
        
            throw new AuraHandledException(e.getMessage());
        
        }
    }


    /**
     * @description     method to support drag events
     * @param           string movingCardId
     * @param           string laneId
     * @param           string newParentCardId
     * @return          boolean
    **/
    @AuraEnabled
    public static boolean supportDragCardMethod(string movingCardId, string laneId, string newParentCardId) {
        try {

            if(newParentCardId == 'NoCard') {
            
                Card__c card = new Card__c(ID=movingCardId);
            
                card.Order__c = 1;
            
                card.Lane__c = laneId;
            
                update card;
            
            } else if (newParentCardId == 'TopCard') {

                List<Card__c> listOfCards = [SELECT ID, Order__c, Card_Status__c FROM Card__c WHERE Lane__c=:laneId AND ID !=: movingCardId AND Card_Status__c=:'Live' ORDER BY Order__c ASC];

                integer cardCount = 2;

                List<Card__c> updateList = new List<Card__c>();

                Card__c currentCard = new Card__c(ID=movingCardId);
            
                currentCard.Order__c = 1;
            
                currentCard.Lane__c = laneId;
            
                updateList.add(currentCard);

                for(Card__c card:listOfCards) {
            
                    card.Order__c = cardCount;
            
                    cardCount = cardCount + 1;
            
                    updateList.add(card);
            
                }

                database.update(updateList);

            } else {

                List<Card__c> listOfCards = [SELECT ID, Order__c, Card_Status__c FROM Card__c WHERE Lane__c=:laneId AND ID !=: movingCardId AND Card_Status__c=:'Live' ORDER BY Order__c ASC];

                integer cardOrder = 1;

                List<Card__c> updateList = new List<Card__c>();

                for(Card__c card:listOfCards){
            
                    card.Order__c = cardOrder;
            
                    cardOrder = cardOrder + 1;
            
                    updateList.add(card);
            
                    if(card.Id == newParentCardId){
            
                        Card__c movingCard = new Card__c(ID=movingCardId);
            
                        movingCard.Lane__c = laneId;
            
                        movingCard.Order__c = cardOrder;
            
                        cardOrder = cardOrder + 1;
            
                        updateList.add(movingCard);
            
                    }
            
                }

                database.update(updateList);

            }

            return true;
            
        } catch (Exception e) {

            throw new AuraHandledException(e.getMessage());

        }

    }


    /**
    * @description      simple method to return a list of lanes for a given board
    * @author           daniel@hyphen8.com | 19/01/2021 
    * @param            recordId - board ID
    * @return           List<Lane__c> 
    **/
    @AuraEnabled
    public static BoardWrapper getListOfLanes(string recordId) {
        
        try {

            List<Lane__c> getListOfLane = [SELECT ID, Name, Order__c FROM Lane__c WHERE Board__c=:recordId AND Order__c != 0 ORDER BY Order__c ASC];
        
            List<Card__c> getListOfCards = [SELECT ID, Lane__c, Name, Order__c, Card_Number__c, Due_Date__c, Due_Date_Passed__c, Card_Status__c FROM Card__c WHERE Board__c=:recordId AND Card_Status__c=:'Live' ORDER BY Order__c ASC];

            Set<ID> cardIDs = new Set<ID>();

            Map<ID, List<Card__c>> mapOfCards = new Map<ID, List<Card__c>>();

            for(Card__c card:getListOfCards){
        
                cardIDs.add(card.Id);
        
                List<Card__c> cards;
        
                if(mapOfCards.containsKey(card.Lane__c)){
        
                    cards = mapOfCards.get(card.Lane__c);
        
                } else {
        
                    cards = new List<Card__c>();
        
                }
        
                cards.add(card);
        
                mapOfCards.put(card.Lane__c, cards);
        
            }

            List<Card_Member__c> getListOfMembers = [SELECT ID, Card__c, User__c FROM Card_Member__c WHERE Card__c IN:cardIDs];

            Map<ID, List<BoardWrapper.MemberWrapper>> mapOfMembers = boardLWCHelperMethods.getCardMapOfMembers(getListOfMembers);

            List<Card_Tag__c> getListOfTags = [SELECT ID, Card__c, Tag_Colour__c, Tag_Name__c, Board_Tag__c FROM Card_Tag__c WHERE Card__c IN:cardIDs];

            Map<ID, List<BoardWrapper.TagsWrapper>> mapOfTags = boardLWCHelperMethods.getCardMapOfTags(getListOfTags);

            BoardWrapper bWrapper = new BoardWrapper();

            List<BoardWrapper.LaneWrapper> laneWrappers = new List<BoardWrapper.LaneWrapper>();

            for(Lane__c lane:getListOfLane){

                BoardWrapper.LaneWrapper lw = new BoardWrapper.LaneWrapper();

                lw.laneName = lane.Name;

                lw.laneID = lane.Id;

                lw.laneOrder = integer.valueOf(lane.Order__c);

                if(mapOfCards.containsKey(lane.Id)){
                
                    List<Card__c> cards = mapOfCards.get(lane.Id);
                
                    List<BoardWrapper.CardWrapper> cardWrappers = new List<BoardWrapper.CardWrapper>();
                
                    for(Card__c card:cards){
                
                        BoardWrapper.CardWrapper cWrapper = new BoardWrapper.CardWrapper();
                
                        cWrapper.cardId = card.Id;

                        cWrapper.cardDueDate = card.Due_Date__c;
                        
                        cWrapper.cardDueDatePassed = card.Due_Date_Passed__c;
                        
                        cWrapper.cardName = card.Name;
                        
                        cWrapper.cardNumber = integer.valueOf(card.Card_Number__c);
                        
                        cWrapper.cardOrder = integer.valueOf(card.Order__c);

                        List<BoardWrapper.MemberWrapper> thisCardMembers;

                        if(mapOfMembers.containsKey(card.Id)){
                            thisCardMembers = mapOfMembers.get(card.Id);
                        } else {
                            thisCardMembers = new List<BoardWrapper.MemberWrapper>();
                        }

                        cWrapper.members = thisCardMembers;

                        List<BoardWrapper.TagsWrapper> thisCardTags;
                        if(mapOfTags.containsKey(card.Id)){
                            thisCardTags = mapOfTags.get(card.Id);
                        } else {
                            thisCardTags = new List<BoardWrapper.TagsWrapper>();
                        }
                        cWrapper.tags = thisCardTags;
                        
                        
                        cardWrappers.add(cWrapper);
                    }

                    
                    if(cardWrappers.size() > 0){
                    
                        lw.cards = cardWrappers;
                    
                    }
                }
                
                laneWrappers.add(lw);
            
            }

            bWrapper.lanes = laneWrappers;
            
            return bWrapper;

        } catch (Exception e) {

            throw new AuraHandledException(e.getMessage());

        }

    }

}