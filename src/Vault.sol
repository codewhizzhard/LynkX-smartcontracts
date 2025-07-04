// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

contract Vault {
    address public owner;
    
    function initialise(address _user) external {
        require(owner == address(0), "Vault already initialised");
        owner = _user;
    }
}