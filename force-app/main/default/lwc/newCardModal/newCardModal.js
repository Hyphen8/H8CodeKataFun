/**
 * @description       : new card modal
 * @author            : daniel@hyphen8.com
 * @last modified on  : 19/01/2021
 * @last modified by  : daniel@hyphen8.com
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   19/01/2021   daniel@hyphen8.com   Initial Version
**/
import { LightningElement, api } from 'lwc';

export default class NewCardModal extends LightningElement {

    boardID;
    currentLaneID;
    modalOpen = false;

    @api
    get recordId(){
        return this._recordId;
    }
    set recordId(value){
        this._recordId = value;
        this.boardID = value;
    }

    @api
    get laneId(){
        return this._laneId;
    }
    set laneId(value){
        this._laneId = value;
        this.currentLaneID = value;
    }

    @api
    get openModal(){
        return this._openModal;
    }
    set openModal(value){
        this._openModal = value;
        this.modalOpen = value;
    }

    closeModal(){
        this.modalOpen = false;
        const selectedEvent = new CustomEvent("modaclosed", {
            detail: true
        });  
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    }

    saveNewCard(){
        this.template.querySelector('lightning-record-edit-form').submit();
    }

    handleSucess(event){
        this.modalOpen = false;
        const selectedEvent = new CustomEvent("newcardcreated", {
            detail: true
        });  
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
     }
}