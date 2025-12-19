import { LightningElement, api, wire } from 'lwc';
import getOpportunity from '@salesforce/apex/OpportunityRiskController.getOpportunity';
import submitForApproval from '@salesforce/apex/OpportunityRiskController.submitForApproval';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class OpportunityRiskScore extends LightningElement {
@api recordId;


opportunity;
riskScore = 0;
riskLevel = 'Low';


@wire(getOpportunity, { recordId: '$recordId' })
wiredOpportunity({ data, error }) {
if (data) {
this.opportunity = data;
this.calculateRisk();
} else if (error) {
this.showToast('Error', 'Unable to load Opportunity', 'error');
}
}


calculateRisk() {
let score = 0;
const today = new Date();
const closeDate = new Date(this.opportunity.CloseDate);
const diffDays = (closeDate - today) / (1000 * 60 * 60 * 24);


if (this.opportunity.Amount > 500000) score += 30;
if (diffDays <= 15) score += 30;
if (['Proposal', 'Negotiation'].includes(this.opportunity.StageName)) score += 20;
if (!this.opportunity.Primary_Contact__c) score += 20;


this.riskScore = score;
this.riskLevel = score > 60 ? 'High' : score > 30 ? 'Medium' : 'Low';
}


get isHighRisk() {
return this.riskLevel === 'High';
}


handleApproval() {
submitForApproval({ recordId: this.recordId })
.then(() => {
this.showToast('Success', 'Opportunity submitted for approval', 'success');
})
.catch(error => {
this.showToast('Error', error.body.message, 'error');
});
}


showToast(title, message, variant) {
this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
}
}