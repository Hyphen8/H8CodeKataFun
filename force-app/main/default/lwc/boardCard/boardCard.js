/**
 * @description       : card js file
 * @author            : daniel@hyphen8.com
 * @last modified on  : 09/02/2021
 * @last modified by  : daniel@hyphen8.com
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   19/01/2021   daniel@hyphen8.com   Initial Version
**/
import { LightningElement, api } from 'lwc';

import deleteArchive from '@salesforce/apex/boardLWCMethods.deleteArchiveCard';

export default class BoardCard extends LightningElement {

    displayBlankSpace = false;
    displayBlankCard = false;
    errors;
    displayManageTags = false;

    @api
    get card(){
        return this._card;
    }
    set card(value){
        this._card = value;
    }

    @api
    get displayDemoCard(){
        return this._displayDemoCard;
    }
    set displayDemoCard(value){
        
        if(value == this.card.cardId){
        
            this.displayBlankSpace = true;
        
        } else {
        
            this.displayBlankSpace = false;
        
        }
        
        this._displayDemoCard = value;
    
    }

    handleDeleteArchive(event){

        //let cardId = event.;
        let eventType = event.target.dataset.targetId;
        let cardId = event.target.value;

        deleteArchive({
            recordId : cardId,
            type : eventType
        })
        .then((results) => {
            const selectedEvent = new CustomEvent("cardarchiveddeleted", {
                detail: true
            });  
            // Dispatches the event.
            this.dispatchEvent(selectedEvent);
        })
        .catch((error) => {
            this.errors = JSON.stringify(error);
            console.error(error);
        });

    }

    handleTimeSubmission(event) {

    }

    handleManageTags(){
        this.displayManageTags = true;
    }

}