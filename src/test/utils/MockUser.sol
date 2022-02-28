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

}
