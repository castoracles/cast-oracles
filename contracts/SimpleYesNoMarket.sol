// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/**
 * Cast Oracles – Identity / metadata anchor.
 * Stores project metadata and allows the owner to update labels/messages.
 * This is your Phase 1 foundation contract.
 */
contract CastOracles {
    address public owner;
    string public projectName;
    string public networkLabel;
    string public message;

    event MessageChanged(string newMessage);
    event LabelsUpdated(string projectName, string networkLabel);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    constructor(
        string memory _projectName,
        string memory _networkLabel,
        string memory _message
    ) {
        owner = msg.sender;
        projectName = _projectName;
        networkLabel = _networkLabel;
        message = _message;
    }

    function setMessage(string calldata newMessage) external onlyOwner {
        message = newMessage;
        emit MessageChanged(newMessage);
    }

    function setLabels(
        string calldata _projectName,
        string calldata _networkLabel
    ) external onlyOwner {
        projectName = _projectName;
        networkLabel = _networkLabel;
        emit LabelsUpdated(_projectName, _networkLabel);
    }
}
