/**
 * @description       : master board component
 * @author            : daniel@hyphen8.com
 * @last modified on  : 23/01/2021
 * @last modified by  : daniel@hyphen8.com
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   19/01/2021   daniel@hyphen8.com   Initial Version
**/
import { LightningElement, api } from 'lwc';

import getLanes from '@salesforce/apex/boardLWCMethods.getListOfLanes';

import labels from './labels';

export default class Board extends LightningElement {
    lanes;
    errors;

    dragEventRecord = 'nothing';

    label = labels;

    @api recordId;

    connectedCallback() {
        this.handlegetLanes();
    }

    errorCallback(error) {
        this.errors = error;
    }

    // get a list of lanes for this board
    handlegetLanes(){
        getLanes({
            recordId : this.recordId
        })
        .then((results) => {
            this.lanes = results.lanes;
        })
        .catch((error) => {
            this.errors = JSON.stringify(error);
            this.lanes = null;
            console.error(error);
        });
    }

    
    handleNewLaneClick(event){
        console.log('new lave event triggered');
    }

    handleNewCardAdded(){
        this.handlegetLanes();
    }

    handleCardMoved(){
        this.handlegetLanes();
    }

    handleDragMovements(event){
        window.console.log('drag selected recordId > ' + event.detail);
        this.dragEventRecord = event.detail;
    }

}