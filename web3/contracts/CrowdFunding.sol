// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    //  solidity is strictly typed language
        struct Campaign {
            address  owner;
            string title;
            string description;
            uint256 target;
            uint256 deadline;
            uint256 amountCollected;
            string image; 
            address[] donators;
            uint256[] donations; 
        }

        
        mapping( uint256 => Campaign) public campaigns;

        uint256 public numberOfCampaigns = 0 ;


        // 🚗🚙🚙 funcitons for entire logic of smart contracts 🚗🚙🚙

        //  create a compaign
        // _owner : here the _ specifies that it is a local variable(it's for readability and to avoid naming conflicts with global variables.)
        function createCompaign( address _owner, string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _image  ) public returns (uint256) {
            Campaign storage campaign = campaigns[numberOfCampaigns];

            // is everything okay ? 
            require( campaign.deadline < block.timestamp, "The deadline should be a date in future" );

            campaign.owner = _owner;
            campaign.title = _title;
            campaign.description = _description;
            campaign.target = _target;
            campaign.deadline = _deadline;
            campaign.amountCollected = 0;
            campaign.image = _image;

            numberOfCampaigns++;

            // return index of most newly created compaign 
            return numberOfCampaigns - 1;


        }

        // donate to compaign
        // payable : it is a special type of function that can send some crypto to the contract
        function donateToCampaign( uint256 _id ) public payable {
            uint256 amount = msg.value;
            Campaign storage campaign = campaigns[_id];

            campaign.donators.push(msg.sender);
            campaign.donations.push(amount);

            // make the transaction
            (bool sent, ) = payable(campaign.owner).call{value:amount}("");

            if(sent) {
                campaign.amountCollected += amount;
            } else {
                revert("Transaction failed");
            }


        }

        // get all donators
        function getDonators( uint256 _id ) view public returns(address[] memory, uint256[] memory) {
            return( campaigns[_id].donators, campaigns[_id].donations);
        }



        // get all campaigns
        function getCampaigns() public view returns(Campaign[] memory) {
            Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);

            for( uint256 i = 0; i < numberOfCampaigns; i++ ) {
                Campaign storage item = campaigns[i];
                allCampaigns[i] = item; 
            }

            return allCampaigns;

        } 
    
}