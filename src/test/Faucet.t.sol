// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ds-test/test.sol";
import {ERC20Mock} from "solidstate-solidity/token/ERC20/ERC20Mock.sol";
import {Faucet} from "../Faucet.sol";
import {MockUser} from "./utils/MockUser.sol";

interface CheatCodes {
    function warp(uint) external;
}

contract FaucetTest is DSTest {

    CheatCodes cheats = CheatCodes(HEVM_ADDRESS);

    ERC20Mock mockA;
    ERC20Mock mockB;
    MockUser alice;

    Faucet faucet;

    function setUp() public {
        mockA = new ERC20Mock("MockA", "MA", 18, 0);
        mockB = new ERC20Mock("MockB", "MB", 18, 0);
    }

    function testCreateFaucet() public {
        faucet = new Faucet();

        uint dripSize = 1000 ether;
        uint dripFrequency = 60 * 60 * 24 * 7; 

        faucet.createFaucet(address(mockA), dripSize, dripFrequency);

        assertEq(faucet.dripFrequency(address(mockA)), dripFrequency);
        assertEq(faucet.dripSize(address(mockA)), dripSize);
        assertEq(faucet.plumber(address(mockA)), address(this));
    }

    function testDonateToFaucet() public {
        faucet = new Faucet();

        uint supply = 1000000 ether;

        mockA.__mint(address(this), supply);
        mockA.approve(address(faucet), supply);

        uint dripSize = 1000 ether;
        uint dripFrequency = 60 * 60 * 24 * 7; 

        faucet.createFaucet(address(mockA), dripSize, dripFrequency);
        faucet.donateToFaucet(address(mockA), supply);

        assertEq(mockA.balanceOf(address(faucet)), supply);
    }

    function testRequest() public {
        faucet = new Faucet();
        alice = new MockUser(address(faucet));

        uint supply = 1000000 ether;
        mockA.__mint(address(this), supply);
        mockA.approve(address(faucet), supply);

        uint dripSize = 1000 ether;
        uint dripFrequency = 60 * 60 * 24 * 7; 

        faucet.createFaucet(address(mockA), dripSize, dripFrequency);
        faucet.donateToFaucet(address(mockA), supply);
        
        alice.request(address(mockA));
        assertEq(mockA.balanceOf(address(alice)), dripSize);
    }

    function testFailDestroyFaucetNotPlumber() public {
        faucet = new Faucet();
        alice = new MockUser(address(faucet));
        faucet.createFaucet(address(mockA), 0, 0);
        alice.destroyFaucet(address(mockA));
    }

    function testDestroyFaucet() public {
        faucet = new Faucet();
        alice = new MockUser(address(faucet));

        uint supply = 1000000 ether;
        mockA.__mint(address(this), supply);
        mockA.approve(address(faucet), supply);

        uint dripSize = 1000 ether;
        uint dripFrequency = 60 * 60 * 24 * 7; 

        faucet.createFaucet(address(mockA), dripSize, dripFrequency);
        faucet.destroyFaucet(address(mockA));

        assertEq(faucet.dripFrequency(address(mockA)), 0);
        assertEq(faucet.dripSize(address(mockA)), 0);
        assertEq(faucet.plumber(address(mockA)), address(0));

        faucet.createFaucet(address(mockA), dripSize, dripFrequency);
        faucet.donateToFaucet(address(mockA), supply);
        alice.request(address(mockA));
        cheats.warp(dripFrequency);
        alice.request(address(mockA));
        faucet.destroyFaucet(address(mockA));

        assertEq(mockA.balanceOf(address(this)), supply-(2*dripSize));
    }

    function testFailClosedFaucet() public {
        faucet = new Faucet();
        alice = new MockUser(address(faucet));

        uint supply = 1000000 ether;
        mockA.__mint(address(this), supply);
        mockA.approve(address(faucet), supply);

        uint dripSize = 1000 ether;
        uint closed = 0; 

        faucet.createFaucet(address(mockA), dripSize, closed);
        faucet.donateToFaucet(address(mockA), supply);
        alice.request(address(mockA));
    }

    function testSetDripSize() public {
        faucet = new Faucet();
        uint dripSize = 1000 ether;
        faucet.createFaucet(address(mockA), dripSize, 0);
        faucet.setDrip(address(mockA), 0);
        assertEq(faucet.dripSize(address(mockA)), 0);
    }

    function testFailSetDripSizeNotPlumber() public {
        faucet = new Faucet();
        alice = new MockUser(address(faucet));
        uint dripSize = 1000 ether;
        faucet.createFaucet(address(mockA), dripSize, 0);
        alice.setDrip(address(mockA), 0);
    }

    function testSetDripFrequency() public {
        faucet = new Faucet();
        uint dripFrequency = 60 * 60 * 24 * 7;
        faucet.createFaucet(address(mockA), 0, dripFrequency);
        faucet.setDripFrequency(address(mockA), 0);
        assertEq(faucet.dripFrequency(address(mockA)), 0);
    }

    function testFailSetDripFrequencyNotPlumber() public {
        faucet = new Faucet();
        alice = new MockUser(address(faucet));
        uint dripFrequency = 60 * 60 * 24 * 7;
        faucet.createFaucet(address(mockA), 0, dripFrequency);
        alice.setDripFrequency(address(mockA), 0);
    }
}
