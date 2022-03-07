// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import {Faucet} from "./Faucet.sol";

contract FaucetFactory {

    Faucet[] faucets;

    event FaucetCreated(address faucetAddress, address owner);

    function allFaucetsLength() external view returns (uint) {
        return faucets.length;
    }

    function create_faucet() external {
        Faucet faucet = new Faucet();
        faucets.push(faucet);
        faucet.transferOwnership(msg.sender);
        emit FaucetCreated(address(faucet), msg.sender);
    }

}
