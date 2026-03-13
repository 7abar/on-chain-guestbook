// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {Script, console} from "forge-std/Script.sol";
import {Guestbook} from "../src/Guestbook.sol";
contract DeployGuestbook is Script {
    function run() external {
        vm.startBroadcast();
        Guestbook book = new Guestbook();
        console.log("Guestbook deployed:", address(book));
        vm.stopBroadcast();
    }
}
