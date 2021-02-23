/**
 * @description       : component to display tags on a card
 * @author            : daniel@hyphen8.com
 * @last modified on  : 23/02/2021
 * @last modified by  : daniel@hyphen8.com
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   19/01/2021   daniel@hyphen8.com   Initial Version
**/
import { LightningElement, api } from 'lwc';

export default class CardTags extends LightningElement {
    
    @api tags;
    
}