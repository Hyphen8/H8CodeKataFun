/**
 * @description       : 
 * @author            : daniel@hyphen8.com
 * @last modified on  : 19/01/2021
 * @last modified by  : daniel@hyphen8.com
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   19/01/2021   daniel@hyphen8.com   Initial Version
**/
trigger cardTrigger on Card__c (before insert) {
    boardTriggerMethods.cardBeforeInsertHandler(trigger.new);
}