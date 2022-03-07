// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import {Faucet} from "./Faucet.sol";

contract FaucetFactory {

    address[] public faucets;

    // Note: owner stored here may drift from actual faucet owner 
    mapping(address => address) ownerToFaucet;

    event FaucetCreated(address faucetAddress, address owner);
    event FaucetAbandoned(address faucetAddress, address owner);

    function allFaucetsLength() external view returns (uint) {
        return faucets.length;
    }

    function createFaucet() external returns (address){
        require(ownerToFaucet[msg.sender] == address(0), "account has a faucet");
        Faucet faucet = new Faucet();
        faucet.transferOwnership(msg.sender);
        faucets.push(address(faucet));
        ownerToFaucet[msg.sender] = address(faucet);
        emit FaucetCreated(address(faucet), msg.sender);
        return address(faucet);
    }

    function abandonFaucet(address faucet) external {
        require(ownerToFaucet[msg.sender] == faucet, "not cached faucet owner");
        ownerToFaucet[msg.sender] = address(0);
        delete ownerToFaucet[msg.sender];
        emit FaucetAbandoned(faucet, msg.sender);
    }

}
