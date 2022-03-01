// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import {IERC20} from "solidstate-solidity/token/ERC20/IERC20.sol";
import {SafeERC20} from "solidstate-solidity/utils/SafeERC20.sol";
import "solidstate-solidity/utils/ReentrancyGuard.sol";
import {IFaucet} from "./interfaces/IFaucet.sol";

contract Faucet is IFaucet {

    using SafeERC20 for IERC20;

    // token => faucet owner
    mapping(address => address) public plumber;
    // token => drip size 
    mapping(address => uint256) public dripSize;
    // token => time between faucet requests;
    //      a value of 0 implies faucet is closed 
    mapping(address => uint256) public dripFrequency;
    // token => account => last request
    mapping(address => mapping(address => uint256)) public lastSip;

    modifier onlyPlumber(address token) {
        require(plumber[token] == msg.sender, "must be plumber");
        _;
    }

    function createFaucet(address token, uint256 drip, uint256 frequency) external {
        require(plumber[token] == address(0), "faucet exists");
        plumber[token] = msg.sender;
        dripSize[token] = drip;
        dripFrequency[token] = frequency;
    }

    function destroyFaucet(address token) external onlyPlumber(token) {

        // send faucet balance to plumber
        uint256 balance = IERC20(token).balanceOf(address(this));
        IERC20(token).safeTransfer(plumber[token], balance);

        delete plumber[token];
        delete dripSize[token];
        delete dripFrequency[token];
        //delete lastSip[token]; // traverse and delete?

    }

    function donateToFaucet(address token, uint256 amount) external {
        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
    }

    function request(address token) external /*nonEntrant*/ {
        require(dripFrequency[token] > 0, "faucet closed");
        if (lastSip[token][msg.sender] != 0) {
            require(block.timestamp > lastSip[token][msg.sender] + dripFrequency[token], "request too high frequency");
        }
        require(IERC20(token).balanceOf(address(this)) >= dripSize[token], "faucet dry");

        lastSip[token][msg.sender] = block.timestamp;
        IERC20(token).safeTransfer(msg.sender, dripSize[token]);
    }
 
    function setDrip(address token, uint256 drip) external onlyPlumber(token) {
        dripSize[token] = drip;
    }

    function setDripFrequency(address token, uint256 frequency) external onlyPlumber(token) {
        dripFrequency[token] = frequency;
    }
   
}
