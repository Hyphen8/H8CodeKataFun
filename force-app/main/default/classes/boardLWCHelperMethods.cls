/**
 * @description       : helper reusabled methods
 * @author            : daniel@hyphen8.com
 * @last modified on  : 02/02/2021
 * @last modified by  : daniel@hyphen8.com
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   24/01/2021   daniel@hyphen8.com   Initial Version
**/
public with sharing class boardLWCHelperMethods {
    
    
    /**
    * @description          method converts a list of card members in a Map of BoardWrapper.MemberWrapper broken where ID = cardId
    * @param                List<Card_Member__c> cardMembers 
    * @return               Map<ID, List<BoardWrapper.MemberWrapper>> 
    **/
    public static Map<ID, List<BoardWrapper.MemberWrapper>> getCardMapOfMembers(List<Card_Member__c> cardMembers){

        Map<ID, List<BoardWrapper.MemberWrapper>> returnMap = new Map<ID, List<BoardWrapper.MemberWrapper>>();

        Set<ID> userIDs = new Set<ID>();

        for(Card_Member__c cm:cardMembers){

            userIDs.add(cm.User__c);

        }

        Map<ID, User> mapOfUsers = new Map<ID, User>([SELECT ID, Name, SmallPhotoUrl FROM User WHERE ID in:userIDs]);

        for(Card_Member__c cm:cardMembers){

            User user = mapOfUsers.get(cm.User__c);

            List<BoardWrapper.MemberWrapper> cardUsers;

            if(returnMap.containsKey(cm.Card__c)){

                cardUsers = returnMap.get(cm.Card__c);

            } else {

                cardUsers = new List<BoardWrapper.MemberWrapper>();

            }

            BoardWrapper.MemberWrapper memberWrapper = new BoardWrapper.MemberWrapper();
            memberWrapper.userImageURL = user.SmallPhotoUrl;
            memberWrapper.userName = user.Name;
            memberWrapper.userName = user.Id;

            cardUsers.add(memberWrapper);

            returnMap.put(cm.Card__c, cardUsers);

        }

        return returnMap;
    }


    public static Map<ID, List<BoardWrapper.TagsWrapper>> getCardMapOfTags(List<Card_Tag__c> cardTags){

        Map<ID, List<BoardWrapper.TagsWrapper>> returnMap = new Map<ID, List<BoardWrapper.TagsWrapper>>();

        for(Card_Tag__c ct:cardTags){
            List<BoardWrapper.TagsWrapper> tags;
            if(returnMap.containsKey(ct.Card__c)){
                tags = returnMap.get(ct.Card__c);
            } else {
                tags = new List<BoardWrapper.TagsWrapper>();
            }

            BoardWrapper.TagsWrapper tag = new BoardWrapper.TagsWrapper();
            tag.tagColour = 'tagContainer ' + ct.Tag_Colour__c;
            tag.tagName = ct.Tag_Name__c;
            tag.boardTagId = ct.Board_Tag__c;
            tag.tagId = ct.Id;

            tags.add(tag);

            returnMap.put(ct.Card__c, tags);
        }

        return returnMap;
    }
}
