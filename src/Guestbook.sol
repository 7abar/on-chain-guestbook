// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Guestbook
/// @notice Leave a permanent, public message on the blockchain.
/// @dev Messages are stored onchain forever. Anyone can read them.
contract Guestbook {
    struct Entry {
        address author;
        string message;
        string handle;   // optional: twitter/ens handle
        uint256 timestamp;
    }

    Entry[] public entries;
    mapping(address => uint256[]) public entriesByAuthor;
    uint256 public constant MAX_MESSAGE_LENGTH = 280;

    event MessageLeft(
        address indexed author,
        uint256 indexed entryId,
        string handle,
        string message,
        uint256 timestamp
    );

    error MessageTooLong();
    error EmptyMessage();

    /// @notice Leave a message in the guestbook
    /// @param message Your message (max 280 chars)
    /// @param handle Optional handle (Twitter, ENS, etc.) — leave empty if none
    function sign(string calldata message, string calldata handle) external {
        if (bytes(message).length == 0) revert EmptyMessage();
        if (bytes(message).length > MAX_MESSAGE_LENGTH) revert MessageTooLong();

        uint256 entryId = entries.length;
        entries.push(Entry({
            author: msg.sender,
            message: message,
            handle: handle,
            timestamp: block.timestamp
        }));
        entriesByAuthor[msg.sender].push(entryId);

        emit MessageLeft(msg.sender, entryId, handle, message, block.timestamp);
    }

    /// @notice Get total number of entries
    function totalEntries() external view returns (uint256) {
        return entries.length;
    }

    /// @notice Get all entry IDs for a specific author
    function getEntriesByAuthor(address author) external view returns (uint256[] memory) {
        return entriesByAuthor[author];
    }

    /// @notice Get a page of entries (newest first)
    function getEntries(uint256 offset, uint256 limit)
        external view returns (Entry[] memory result)
    {
        uint256 total = entries.length;
        if (offset >= total) return new Entry[](0);
        uint256 end = total - offset;
        uint256 start = end > limit ? end - limit : 0;
        result = new Entry[](end - start);
        for (uint256 i = 0; i < result.length; i++) {
            result[i] = entries[start + i];
        }
        // reverse to get newest first
        for (uint256 i = 0; i < result.length / 2; i++) {
            Entry memory tmp = result[i];
            result[i] = result[result.length - 1 - i];
            result[result.length - 1 - i] = tmp;
        }
    }
}
