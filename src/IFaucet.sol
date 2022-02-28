// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

interface IFaucet {

    function createFaucet(address token, uint256 drip, uint256 frequency) external; 
    function destroyFaucet(address token) external; 
    function getDrip(address token) external returns (uint256); 
    function setDrip(address token, uint256 drip) external; 
    function getDripFrequency(address token) external returns (uint256); 
    function setDripFrequency(address token, uint256 frequency) external; 
    function donateToFaucet(address token, uint256 amount) external; 
    function request(address token) external ; 

}
