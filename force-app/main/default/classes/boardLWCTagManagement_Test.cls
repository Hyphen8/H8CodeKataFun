/**
 * @description  : Test class for boardLWCTagManagement
 * @author       : simon@hyphen8.com
 * @date         : 09-02-2021
**/
@IsTest
public class boardLWCTagManagement_Test {
    @IsTest
    static void testGetAvailableTagsNoCurrent(){
        Board__c board = new Board__c(
            Name = 'Test Board'
        );
        insert board;

        List<Board_Tags__c> boardTags = new List<Board_Tags__c>();
        for (Integer i = 0 ; i < 3 ; i++){
            boardTags.add(new Board_Tags__c(
                Board__c = board.Id,
                Name = 'Board Tag ' + i
            ));
        }

        insert boardTags;

        List<BoardWrapper.TagsWrapper> boardTagsFromClass;

        Test.startTest();
        boardTagsFromClass = boardLWCTagManagement.getAvailableTags(board.Id, new List<BoardWrapper.TagsWrapper>());
        Test.stopTest();

        System.assertEquals(boardTagsFromClass.size(), 3, 'Expected number of Tags returned');
    }

    @IsTest
    static void testGetAvailableTagsWithCurrent(){
        Board__c board = new Board__c(
            Name = 'Test Board'
        );
        insert board;

        Card__c card = new Card__c(
            board__c = board.Id,
            name='Test Card'
        );
        insert card;

        List<Board_Tags__c> boardTags = new List<Board_Tags__c>();
        for (Integer i = 0 ; i < 3 ; i++){
            boardTags.add(new Board_Tags__c(
                Board__c = board.Id,
                Name = 'Board Tag ' + i
            ));
        }
        insert boardTags;
        
        List<Card_Tag__c> cardTags = new List<Card_Tag__c>();
        for (Integer i = 0 ; i < 2 ; i++){
            Board_Tags__c boardTag = boardTags.get(i);
            cardTags.add(new Card_Tag__c(
                card__c = card.Id,
                board_Tag__c = boardTag.Id
            ));
        }

        insert cardTags;
        
        List<BoardWrapper.TagsWrapper> boardWrapperList = new List<BoardWrapper.TagsWrapper>();

        for(Card_Tag__c cardTag : cardTags) {

            BoardWrapper.TagsWrapper tag = new BoardWrapper.TagsWrapper();                
            tag.boardTagId = cardTag.Board_Tag__c;
            tag.tagId = cardTag.id;
            boardWrapperList.add(tag) ;

        }

        //  Map<ID, List<BoardWrapper.TagsWrapper>> mapOfTags = boardLWCHelperMethods.getCardMapOfTags(cardTags);

        List<BoardWrapper.TagsWrapper> boardTagsFromClass;

        Test.startTest();
            // boardTagsFromClass = boardLWCTagManagement.getAvailableTags(board.Id, mapOfTags.get(card.Id));
           boardTagsFromClass = boardLWCTagManagement.getAvailableTags(board.Id, boardWrapperList);
        Test.stopTest();

        System.assertEquals(boardTagsFromClass.size(), 1, 'Expected number of Tags returned');
    }
    
}
