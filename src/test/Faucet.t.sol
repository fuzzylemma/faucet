// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ds-test/test.sol";
import {ERC20Mock} from "solidstate-solidity/token/ERC20/ERC20Mock.sol";
import {Faucet} from "../Faucet.sol";
import {MockUser} from "./utils/MockUser.sol";

contract FaucetTest is DSTest {

    ERC20Mock mockA;
    ERC20Mock mockB;

    Faucet faucet;

    function setUp() public {
        mockA = new ERC20Mock("MockA", "MA", 18, 0);
        mockB = new ERC20Mock("MockB", "MB", 18, 0);
    }

    function testCreateFaucet() public {
        faucet = new Faucet();
    }
    function testDonateToFaucet() public {}
    function testRequest() public {}
    function testDestroyFaucet() public {} 

    /*
    function destroyFaucet(address token) external; 
    function getDrip(address token) external returns (uint256); 
    function setDrip(address token, uint256 drip) external; 
    function getDripFrequency(address token) external returns (uint256); 
    function setDripFrequency(address token, uint256 frequency) external; 
    function donateToFaucet(address token, uint256 amount) external; 
    function request(address token) external ; 
    */

}
