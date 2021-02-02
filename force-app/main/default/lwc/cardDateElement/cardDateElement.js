/**
 * @description       : component to output the card date element
 * @author            : daniel@hyphen8.com
 * @last modified on  : 24/01/2021
 * @last modified by  : daniel@hyphen8.com
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   24/01/2021   daniel@hyphen8.com   Initial Version
**/
import { LightningElement, api } from 'lwc';

export default class CardDateElement extends LightningElement {
    @api
    get card(){
        return this._card;
    }
    set card(value){
        this._card = value;
    }
}