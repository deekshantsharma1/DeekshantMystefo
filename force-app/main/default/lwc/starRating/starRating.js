import { LightningElement, api } from 'lwc';
import getRating from '@salesforce/apex/StarRatingController.getRating';
import updateRating from '@salesforce/apex/StarRatingController.updateRating';

export default class StarRating extends LightningElement {

    @api recordId;

    savedRating = 0;   // Rating from DB
    isRated = false;   // Whether user has already rated
    stars = [];        // Array to display on UI

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

    // Generate stars dynamically
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
            // Not rated → show stars only on hover
            this.generateStars(index);
        } else {
            // Rated → temporarily show hover preview
            this.generateStars(index);
        }
    }

    // When mouse leaves the stars
    handleHoverOut() {
        if (!this.isRated) {
            // Not rated → revert to empty stars
            this.generateStars(0);
        } else {
            // Rated → revert to saved rating
            this.generateStars(this.savedRating);
        }
    }

    // When user clicks a star
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
