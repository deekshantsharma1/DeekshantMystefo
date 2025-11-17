import { LightningElement, api } from 'lwc';
import getRating from '@salesforce/apex/StarRatingController.getRating';
import updateRating from '@salesforce/apex/StarRatingController.updateRating';

export default class StarRating extends LightningElement {

    @api recordId;

    savedRating = 0;   
    isRated = false;   
    stars = [];        

    connectedCallback() {
        this.loadRating();
    }

    // Load rating from Apex
    loadRating() {
        getRating({ recordId: this.recordId })
            .then(result => {
                this.savedRating = result;
                this.isRated = result > 0;
                this.generateStars(this.savedRating);
            })
            .catch(error => {
                console.error('Error loading rating', error);
            });
    }

    
    generateStars(value) {
        this.stars = [];

        for (let i = 1; i <= 5; i++) {
            this.stars.push({
                index: i,
                class: i <= value ? 'star filled' : 'star'
            });
        }
    }

    // When mouse is over a star
    handleHover(event) {
        const index = Number(event.target.dataset.index);

        if (!this.isRated) {
           
            this.generateStars(index);
        } else {
            
            this.generateStars(index);
        }
    }

    
    handleHoverOut() {
        if (!this.isRated) {
            
            this.generateStars(0);
        } else {
            
            this.generateStars(this.savedRating);
        }
    }

   
    handleClick(event) {
        const index = Number(event.target.dataset.index);

        this.savedRating = index;
        this.isRated = true;

        this.generateStars(index);

        updateRating({ recordId: this.recordId, newRating: index })
            .catch(error => {
                console.error('Error updating rating', error);
            });
    }
}
