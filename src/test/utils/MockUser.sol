// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import {IFaucet} from "../../interfaces/IFaucet.sol";

contract MockUser {

    IFaucet immutable faucet;

    constructor(address _faucet) {
        faucet = IFaucet(_faucet);
    }

    function request(address token) external {
        faucet.request(token);
    }

    function createFaucet(address token, uint256 drip, uint256 frequency) external {
        faucet.createFaucet(token, drip, frequency);
    }
    
    function destroyFaucet(address token) external {
        faucet.destroyFaucet(token);
    }

    function setDrip(address token, uint drip) external {
        faucet.setDrip(token, drip);
    }

    function setDripFrequency(address token, uint frequency) external {
        faucet.setDripFrequency(token, frequency);
    }

}
