/**
 * @description       : js for the modal to display the card
 * @author            : daniel@hyphen8.com
 * @last modified on  : 24/01/2021
 * @last modified by  : daniel@hyphen8.com
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   23/01/2021   daniel@hyphen8.com   Initial Version
**/
import { LightningElement, api } from 'lwc';

import getCard from '@salesforce/apex/boardLWCMethods.getCard';

export default class BoardViewCardModal extends LightningElement {
    
    modalOpen = false;
    errors;
    card;
    descriptReadOnly = true;

    @api
    get recordId() {
        return this._recordId;
    }
    
    set recordId(value) {
        this._recordId = value;
        window.console.log('recordID for modal > ' + value)
    }

    @api
    get openModal(){
        return this._openModal;
    }
    set openModal(value){
        this._openModal = value;
        this.modalOpen = value;
        window.console.log('view card request received');
        if(value){
            this.handlegetCard();
        }
    }

    errorCallback(error) {
        this.errors = error;
    }

    closeModal(){
        this.modalOpen = false;
        const selectedEvent = new CustomEvent("viewmodalclosed", {
            detail: true
        });  
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    }

    // get a list of lanes for this board
    handlegetCard(){
        if(this._recordId != undefined || this._recordId != null) {
            getCard({
                recordId : this._recordId
            })
            .then((results) => {
                window.console.log('got some results > ' + JSON.stringify(results));
                this.card = results;
            })
            .catch((error) => {
                this.errors = JSON.stringify(error);
                this.card = null;
                console.error(error);
            });

        }
    }

    handleEditText(event){
        this.descriptReadOnly = false;
    }

    cancelEditDescriptSave(event) {
        this.descriptReadOnly = true;
        window.console.log('cancel fired > ' + this.descriptReadOnly);
    }
    
}