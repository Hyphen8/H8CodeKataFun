/**
 * @description       : board lane js file
 * @author            : daniel@hyphen8.com
 * @last modified on  : 02/02/2021
 * @last modified by  : daniel@hyphen8.com
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   19/01/2021   daniel@hyphen8.com   Initial Version
**/
import { LightningElement, api } from 'lwc';

import labels from './labels';
import moveCardSupport from '@salesforce/apex/boardLWCMethods.supportDragCardMethod';

export default class BoardLane extends LightningElement {

    cards;
    openModal = false;
    viewCardModal = false;
    //laneId;
    label = labels;

    dropRecord = 'nothing';
    displayBlankCard = false;

    @api
    get dropEventRecord() {
        return this._dropEventRecord;
    }
    set dropEventRecord(value){
        this.dropRecord = value;
        if(value == 'nothing'){
            this.displayBlankCard = false;
        }
        this._dropEventRecord = value;
    }

    @api
    get recordId(){
        return this._recordId;
    }
    set recordId(value){
        this._recordId = value;
    }

    @api
    get laneId(){
        return this._laneId;
    }
    set laneId(value){
        this._laneId = value;
    }

    @api
    get lane(){
        return this._lane;
    }
    set lane(value){
        this._lane = value;
        this.cards = value.cards;
    }

    // on click events

    // new card event
    handleNewCardClick(event){
        let currentLaneOrder = event.target.dataset.targetId;
        this.laneId = currentLaneOrder;
        this.openModal = true;
    }

    // view card event
    handleViewCard(event){
        window.console.log('view card event triggered');
        let selectedCardId = event.target.parentElement.dataset.targetId;
        this.cardId = selectedCardId;
        this.viewCardModal = true;
    }

    // close of modal new or view event
    handleNewCardAdded(){
        console.log('did this happen');
        this.openModal = false;
        this.viewCardModal = false;
        this.cardId = null;
        const selectedEvent = new CustomEvent("newcardadded", {
            detail: true
        });  
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    }

    // close modal event not change
    handleModalClosing(){
        this.openModal = false;
    }


    // drag and drop functions

    // drag start
    handleDragStart(event){

        event.dataTransfer.setData("card_id", event.target.dataset.targetId);
        event.dataTransfer.dropEffect = "move";

    }

    // drag end or drop
    handleDropElement(event){

        let newParentCardId = event.target.parentElement.dataset.targetId;
        if(newParentCardId == undefined){
            newParentCardId = event.target.dataset.targetId;
        }

        let cardId = event.dataTransfer.getData("card_id");
        this.handleMoveCardDBUpdate(cardId, this.lane.laneID, newParentCardId);

    }

    // allow drop function
    handleAllowDrop(event){
    
        let cardId = event.dataTransfer.getData("card_id");
        let newParentCardId = event.target.parentElement.dataset.targetId;
        if(newParentCardId == undefined){
            this.displayBlankCard = true;
        } else {
            this.displayBlankCard = false;
        }
        if(cardId != newParentCardId && this.displayBlankCard == false){
            const selectedEvent = new CustomEvent("droprecordadded", {
                detail: event.target.parentElement.dataset.targetId
            });  
            // Dispatches the event.
            this.dispatchEvent(selectedEvent);
        }
        event.preventDefault();

    }


    // perform db update based on card movement
    handleMoveCardDBUpdate(movingCardId, laneId, newParentCardId){
        moveCardSupport({
            movingCardId : movingCardId,
            laneId : laneId,
            newParentCardId : newParentCardId
        })
        .then((results) => {
            
            this.displayBlankCard = false;
            
            const selectedEventMoveUpdate = new CustomEvent("cardmoved", {
                detail: true
            });  
            // Dispatches the event.
            this.dispatchEvent(selectedEventMoveUpdate);

            const selectedEventDragChange = new CustomEvent("droprecordadded", {
                detail: 'nothing'
            });  
            // Dispatches the event.
            this.dispatchEvent(selectedEventDragChange);
        })
        .catch((error) => {
            this.errors = JSON.stringify(error);
            console.error(error);
        });
    }


    // card archive function
    handleCardArchiveDelete(event){
        const selectedEventMoveUpdate = new CustomEvent("cardmoved", {
            detail: true
        });  
        // Dispatches the event.
        this.dispatchEvent(selectedEventMoveUpdate);
    }

}