import { LightningElement, api, track, wire } from 'lwc';
import getRating from '@salesforce/apex/StarRatingController.getRating';
import updateRating from '@salesforce/apex/StarRatingController.updateRating';

export default class StarRating extends LightningElement {
    @api recordId;
    @track currentRating = 0;
    @track hoverRating = 0;
    @track stars = [];

    @wire(getRating, { recordId: '$recordId' })
    wiredRating({ data, error }) {
        if (data !== undefined) {
            this.currentRating = data;
            this.renderStars();
        } else if (error) {
            console.error(error);
        }
        }
        renderStars() {
            this.stars = [];
            for (let i = 1; i <= 5; i++) {
                let className = 'star';
                if (i <= (this.hoverRating || this.currentRating)) {
                    className += ' filled';
                }
                this.stars.push({ value: i, class: className });
            }
        }
        handleMouseOver(event){}
        handleMouseOut(event){}
        handleclick(event){

        }
    }




