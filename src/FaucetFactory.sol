// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import {Faucet} from "./Faucet.sol";

contract FaucetFactory {

    address[] public faucets;
    mapping(address => address) ownerToFaucet;

    event FaucetCreated(address faucetAddress, address owner);
    event FaucetAbandoned(address faucetAddress, address owner);

    function allFaucetsLength() external view returns (uint) {
        return faucets.length;
    }

    function create_faucet() external {
        require(ownerToFaucet[msg.sender] == address(0), "account has a faucet");
        Faucet faucet = new Faucet();
        faucet.transferOwnership(msg.sender);
        faucets.push(address(faucet));
        ownerToFaucet[msg.sender] = address(faucet);
        emit FaucetCreated(address(faucet), msg.sender);
    }

    function abandon_faucet(address faucet) external {
        require(ownerToFaucet[msg.sender] == faucet, "not faucet owner");
        ownerToFaucet[msg.sender] = address(0);
        delete ownerToFaucet[msg.sender];
        emit FaucetAbandoned(faucet, msg.sender);
    }

}
