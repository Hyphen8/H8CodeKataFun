/**
 * @description       : 
 * @author            : daniel@hyphen8.com
 * @last modified on  : 02/02/2021
 * @last modified by  : daniel@hyphen8.com
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   02/02/2021   daniel@hyphen8.com   Initial Version
**/
public with sharing class boardLWCTagManagement {
    

    /**
    * @description          method to return a list of available tags for an individual card
    * @param                string recordId board ID passed from LWC Component get recordId
    * @param                List<BoardWrapper.TagsWrapper> currentTags  current tags as selected on LWC Card record card.tags
    * @return               List<BoardWrapper.TagsWrapper> 
    **/
    @AuraEnabled
    public static List<BoardWrapper.TagsWrapper> getAvailableTags(String recordId, List<BoardWrapper.TagsWrapper> currentTags)
    {
        Set<ID> setOfIDs = new Set<ID>();
        List<BoardWrapper.TagsWrapper> returnTagsWrapper = new List<BoardWrapper.TagsWrapper>();   

        for(BoardWrapper.TagsWrapper tag:currentTags){
            setOfIDs.add(tag.boardTagId);
        }
        
        //Query list of all tags
        List<Board_Tags__c> boardTags = [SELECT Id, Colour__c, Name FROM Board_Tags__c WHERE Board__c = :recordId AND ID NOT IN :setOfIDs];

        for(Board_Tags__c boardTag : boardTags) {

             BoardWrapper.TagsWrapper tagWrapper = new BoardWrapper.TagsWrapper();
             tagWrapper.boardTagId = boardTag.id;                        
             tagWrapper.tagColour = boardTag.colour__c;
             tagWrapper.tagName = boardTag.Name;
             returnTagsWrapper.add(tagWrapper);             
        }

        return returnTagsWrapper;
                    
    }
}
