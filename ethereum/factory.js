import web3 from './web3';
import CampaignFactory from './build/CampaignFactory.json';

// instance of deployed copy of CampaignFactory
const instance = new web3.eth.Contract(
    JSON.parse(CampaignFactory.interface),
    '0x2BD9577671735544d909ba52246A44ae2514f9d8'
);

export default instance;