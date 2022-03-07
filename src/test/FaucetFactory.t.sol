// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ds-test/test.sol";
import {ERC20Mock} from "solidstate-solidity/token/ERC20/ERC20Mock.sol";
import {FaucetFactory} from "../FaucetFactory.sol";
import {IFaucet} from "../interfaces/IFaucet.sol";
import "../libraries/FaucetFactoryErrors.sol";

interface CheatCodes {
    function expectRevert(bytes calldata) external;
}

contract FaucetFactoryTest is DSTest {

    CheatCodes cheats = CheatCodes(HEVM_ADDRESS);

    FaucetFactory faucetFactory;
    ERC20Mock mockA;
    ERC20Mock mockB;

    function setUp() public {
        mockA = new ERC20Mock("MockA", "MA", 18, 0);
        mockB = new ERC20Mock("MockB", "MB", 18, 0);
        faucetFactory = new FaucetFactory();
    }

    function testFactory() public {
        address faucet = faucetFactory.createFaucet();
        cheats.expectRevert(bytes(FaucetFactoryErrors.ACCOUNT_HAS_FAUCET));
        faucetFactory.createFaucet();
        faucetFactory.abandonFaucet(faucet);
        faucetFactory.createFaucet();
    }
}
