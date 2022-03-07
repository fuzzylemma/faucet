// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

library FaucetErrors {
    string constant FAUCET_EXISTS = "faucet exists";
    string constant FAUCET_CLOSED = "faucet closed";
    string constant REQUEST_FREQUENCY = "request frequency too high";
    string constant FAUCET_EMPTY = "faucet dry";
}
