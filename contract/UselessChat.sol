// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract UselessChat {
    struct Message {
        address sender;
        string name;
        string text;
        uint256 timestamp;
    }

    Message[] public messages;

    // Maximum limits
    uint256 public constant MAX_NAME_LENGTH = 15;
    uint256 public constant MAX_MESSAGE_LENGTH = 180;

    // Events for better tracking
    event MessageSent(address indexed sender, string name, string text, uint256 timestamp);

    // Custom errors (more gas efficient than require strings)
    error NameTooLong();
    error MessageTooLong();
    error EmptyName();
    error EmptyMessage();

    function sendMessage(string calldata name, string calldata text) external {
        // Check name length
        if (bytes(name).length == 0) revert EmptyName();
        if (bytes(name).length > MAX_NAME_LENGTH) revert NameTooLong();

        // Check message length
        if (bytes(text).length == 0) revert EmptyMessage();
        if (bytes(text).length > MAX_MESSAGE_LENGTH) revert MessageTooLong();

        // Create and store the message
        Message memory newMessage = Message(msg.sender, name, text, block.timestamp);
        messages.push(newMessage);

        // Emit event
        emit MessageSent(msg.sender, name, text, block.timestamp);
    }

    function getMessages(uint256 offset, uint256 limit) external view returns (Message[] memory) {
        if (offset >= messages.length) {
            return new Message[](0);
        }

        uint256 end = offset + limit > messages.length ? messages.length : offset + limit;
        uint256 size = end - offset;
        Message[] memory result = new Message[](size);

        for (uint256 i = 0; i < size; i++) {
            result[i] = messages[end - i - 1]; // reverse order (latest first)
        }

        return result;
    }

    function getMessageCount() external view returns (uint256) {
        return messages.length;
    }

    // Additional helper function to get latest messages
    function getLatestMessages(uint256 limit) external view returns (Message[] memory) {
        return this.getMessages(0, limit);
    }
}