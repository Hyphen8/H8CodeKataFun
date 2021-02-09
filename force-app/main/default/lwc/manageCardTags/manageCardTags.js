/**
 * @description       : 
 * @author            : daniel@hyphen8.com
 * @last modified on  : 09/02/2021
 * @last modified by  : daniel@hyphen8.com
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   09/02/2021   daniel@hyphen8.com   Initial Version
**/
import { LightningElement, api, track } from 'lwc';

import getAvailableTags from '@salesforce/apex/boardLWCTagManagement.getAvailableTags';

export default class ManageCardTags extends LightningElement {

    @api recordId;
    
    @api
    get currentTags(){
        return this._currentTags;
    }
    set currentTags(value){
        this._currentTags = value;
        this.HandlegetAvailableTags(value);
    }

    errors;
    
    availableTags;

    // renderedCallback(){
    //     this.HandlegetAvailableTags();
    // }

    errorCallback(error){
        this.errors = error;
    }

    HandlegetAvailableTags(theseTags) {
        getAvailableTags({
           recordId: this.recordId,
           currentTags: theseTags
        })
        .then((results) => {
            console.log('results > ' + JSON.stringify(results));
            this.availableTags = results;
        })
        .catch((error) => {
            console.error('error HandlegetAvailableTags > ' + JSON.stringify(error));
           this.errors = error;
        });
    }
}