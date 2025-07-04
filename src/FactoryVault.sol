// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "./Vault.sol";
import "openzeppelin-contracts/contracts/proxy/Clones.sol";

interface IVault {
    function initialise(address _user) external;
}

contract VaultFactory {

    struct VaultInfo {
        address vaultAddress;
        uint256 chainId;
    }

    using Clones for address;

    address public immutable vaultImplementation;

    constructor(address _vaultImplementation) {
        vaultImplementation = _vaultImplementation;
    }

    mapping(address => mapping(uint256 => VaultInfo)) public userToVaults;

    function createVault(uint256 chainId) public returns (address vault) {
        require(
            userToVaults[msg.sender][chainId].vaultAddress == address(0),
            "user already exist"
        );

        bytes32 salt = keccak256(abi.encodePacked(msg.sender));
        vault = vaultImplementation.cloneDeterministic(salt);
        IVault(vault).initialise(msg.sender)
        userToVaults[msg.sender][chainId] = VaultInfo({
            vaultAddress: address(vault),
            chainId: chainId
        });
    }

    function getVaultAddresses(address user) external returns (address predicted) {
        
        bytes32 salt = keccak256(abi.encodePacked(user));
        predicted = vaultImplementation.predictDeterministicAddress(salt, address(this));
    }
}
