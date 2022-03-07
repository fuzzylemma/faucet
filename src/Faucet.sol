// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import {IERC20} from "solidstate-solidity/token/ERC20/IERC20.sol";
import {SafeERC20} from "solidstate-solidity/utils/SafeERC20.sol";
import {Ownable, OwnableStorage} from "solidstate-solidity/access/Ownable.sol";
import {IFaucet} from "./interfaces/IFaucet.sol";
import "solidstate-solidity/utils/ReentrancyGuard.sol";

contract Faucet is IFaucet, Ownable, ReentrancyGuard {

    using OwnableStorage for OwnableStorage.Layout;
    using SafeERC20 for IERC20;

    address[] public tokens;
    // token => exists
    mapping(address => bool) public exists;
    // token => drip size 
    mapping(address => uint256) public dripSize;
    // token => time between faucet requests;
    //      a value of 0 implies faucet is closed 
    mapping(address => uint256) public dripFrequency;
    // token => account => last request
    mapping(address => mapping(address => uint256)) public lastSip;

    constructor() {
        OwnableStorage.layout().setOwner(msg.sender);
    } 

    function allTokensLength() external returns (uint) {
        return tokens.length;
    }

    function createFaucet(address token, uint256 drip, uint256 frequency) external onlyOwner {
        require(!exists[token], "faucet exists");
        exists[token] = true;
        dripSize[token] = drip;
        dripFrequency[token] = frequency;
        tokens.push(token);
    }

    function destroyFaucet(address token) external onlyOwner {

        // send faucet balance to plumber
        uint256 balance = IERC20(token).balanceOf(address(this));
        IERC20(token).safeTransfer(owner(), balance);

        delete exists[token];
        delete dripSize[token];
        delete dripFrequency[token];
        //delete lastSip[token]; // traverse and delete?

        for (uint i = 0; i < tokens.length; i++) {
            if (tokens[i] == token) {
                tokens[i] = tokens[tokens.length-1];
                tokens.pop();
                break;
            }
        }
    }

    function donateToFaucet(address token, uint256 amount) external {
        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
    }

    function request(address token) external nonReentrant {
        require(dripFrequency[token] > 0, "faucet closed");
        if (lastSip[token][msg.sender] != 0) {
            require(block.timestamp > lastSip[token][msg.sender] + dripFrequency[token], "request too high frequency");
        }
        require(IERC20(token).balanceOf(address(this)) >= dripSize[token], "faucet dry");

        lastSip[token][msg.sender] = block.timestamp;
        IERC20(token).safeTransfer(msg.sender, dripSize[token]);
    }
 
    function setDrip(address token, uint256 drip) external onlyOwner {
        dripSize[token] = drip;
    }

    function setDripFrequency(address token, uint256 frequency) external onlyOwner {
        dripFrequency[token] = frequency;
    }
   
}
