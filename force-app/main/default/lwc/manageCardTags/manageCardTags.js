/**
 * @description       : 
 * @author            : daniel@hyphen8.com
 * @last modified on  : 23/02/2021
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
            let resultTags = [];
            results.forEach(function(item){
                 console.log(' actual Item > ' + JSON.stringify(item));
                 let newColour = 'tagContainer ' + item.tagColour;
                 item.tagColour = newColour;
                 console.log('colour set ' + newColour);
                 console.log(' actual Item > ' + JSON.stringify(item));
                 resultTags.push(item);
            });
            console.log('resultTags > ' + resultTags);
            this.availableTags = resultTags;
        })
        .catch((error) => {
            console.error('error HandlegetAvailableTags > ' + JSON.stringify(error));
           this.errors = error;
        });
    }
}