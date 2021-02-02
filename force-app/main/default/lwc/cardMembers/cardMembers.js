/**
 * @description       : 
 * @author            : daniel@hyphen8.com
 * @last modified on  : 24/01/2021
 * @last modified by  : daniel@hyphen8.com
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   19/01/2021   daniel@hyphen8.com   Initial Version
**/
import { LightningElement, api } from 'lwc';

export default class CardMembers extends LightningElement {
    
    members;

    showAddMemberIcon = false;
    
    @api
    get cardId(){
        return this._cardId;
    }
    set cardId(value){
        this._cardId = value;
    }

    @api 
    get memberCount(){
        return this._memberCount;
    }
    set memberCount(value){
        this._memberCount = value;
    }
    @api 
    get cardMembers(){
        return this._cardMembers;
    }
    set cardMembers(value) {
        this._cardMembers = value;
        if(value == null){
            this.members = null;
        } else {
            this.members = value;
        }
    }

    @api
    get displayAddMemberIcon() {
        return this._displayAddMemberIcon;
    }
    set displayAddMemberIcon(value) {
        if(value == "true"){
            this.showAddMemberIcon = true;
        } else {
            this.showAddMemberIcon = false;
        }
        this._displayAddMemberIcon = value;
    }
}