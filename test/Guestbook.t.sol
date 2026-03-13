// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Guestbook} from "../src/Guestbook.sol";

contract GuestbookTest is Test {
    Guestbook public book;
    address alice = address(0xA);
    address bob = address(0xB);

    function setUp() public {
        book = new Guestbook();
    }

    function test_Sign() public {
        vm.prank(alice);
        book.sign("gm from alice", "@alice_eth");
        assertEq(book.totalEntries(), 1);
        (address author, string memory msg_, , ) = book.entries(0);
        assertEq(author, alice);
        assertEq(msg_, "gm from alice");
    }

    function test_MultipleSigners() public {
        vm.prank(alice);
        book.sign("first", "");
        vm.prank(bob);
        book.sign("second", "@bob");
        assertEq(book.totalEntries(), 2);
    }

    function test_EmptyMessageReverts() public {
        vm.prank(alice);
        vm.expectRevert(Guestbook.EmptyMessage.selector);
        book.sign("", "");
    }

    function test_TooLongMessageReverts() public {
        string memory long_msg = new string(281);
        bytes memory b = bytes(long_msg);
        for (uint i = 0; i < b.length; i++) b[i] = "a";
        vm.prank(alice);
        vm.expectRevert(Guestbook.MessageTooLong.selector);
        book.sign(string(b), "");
    }

    function test_EntriesByAuthor() public {
        vm.startPrank(alice);
        book.sign("msg 1", "");
        book.sign("msg 2", "");
        vm.stopPrank();
        uint256[] memory ids = book.getEntriesByAuthor(alice);
        assertEq(ids.length, 2);
    }

    function test_GetEntriesPaginated() public {
        vm.prank(alice);
        book.sign("first", "");
        vm.prank(bob);
        book.sign("second", "");
        Guestbook.Entry[] memory page = book.getEntries(0, 10);
        assertEq(page.length, 2);
        // newest first
        assertEq(page[0].author, bob);
        assertEq(page[1].author, alice);
    }
}
