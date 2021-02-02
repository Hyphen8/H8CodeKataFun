/**
 * @description       : methods that access from the application triggers
 * @author            : daniel@hyphen8.com
 * @last modified on  : 19/01/2021
 * @last modified by  : daniel@hyphen8.com
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   19/01/2021   daniel@hyphen8.com   Initial Version
**/
public with sharing class boardTriggerMethods {
    

    public static void cardBeforeInsertHandler(List<Card__c> recordList){

        Set<ID> laneIDs = new Set<ID>();
        Set<ID> boardIDs = new Set<ID>();

        for(Card__c card:recordList){
            system.debug('card > ' + card);
            laneIDs.add(card.Lane__c);
            boardIDs.add(card.Board__c);
        }

        AggregateResult[] groupedLanes = [SELECT Lane__c, COUNT(Id) FROM Card__c WHERE Lane__c IN:laneIDs GROUP BY Lane__c];
        system.debug('groupedLanes > ' + groupedLanes);
        AggregateResult[] groupedBoards = [SELECT Board__c, COUNT(Id) FROM Card__c WHERE Board__c IN:boardIDs GROUP BY Board__c];
        system.debug('groupedBoards > ' + groupedBoards);

        Map<ID, Integer> laneCountMap = new Map<ID, Integer>();
        for(AggregateResult gLanes:groupedLanes){
            string laneID = (string)gLanes.get('Lane__c');
            integer laneCount = (integer)gLanes.get('expr0');
            laneCountMap.put(laneID, laneCount);
        }
        Map<ID, Integer> boardCountMap = new Map<ID, Integer>();
        for(AggregateResult gBoards:groupedBoards){
            string boardID = (string)gBoards.get('Board__c');
            integer boardCount = (integer)gBoards.get('expr0');
            boardCountMap.put(boardID, boardCount);
        }

        for(Card__c card:recordList){
            
            integer laneCount;
            if(laneCountMap.containsKey(card.Lane__c)){
                laneCount = laneCountMap.get(card.Lane__c);
                laneCount = laneCount + 1;
            } else {
                laneCount = 1;
            }
            laneCountMap.put(card.Lane__c, laneCount);

            integer boardCount;
            if(boardCountMap.containsKey(card.Board__c)){
                boardCount = boardCountMap.get(card.Board__c);
                boardCount = boardCount + 1;
            } else {
                boardCount = 1;
            }
            boardCountMap.put(card.Board__c, boardCount);

            card.Order__c = laneCount;
            card.Card_Number__c = boardCount;
        }
    }
}
