// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

contract Vault {
    address public owner;

    mapping(address => uint256) public balance;
    
    function initialise(address _user) external {
        require(owner == address(0), "Vault already initialised");
        owner = _user;
    }
}