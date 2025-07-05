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
    mapping(uint256 => address) public chainIdToVault;

    chainIdToVault[1] = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;// Ethereum Mainnet USDC
    chainIdToVault[137] = 0x2791Bca1f25dB3aF4eD8f9eF7bA6c0cBf4bE8fD6;// Polygon USDC 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174
    chainIdToVault[42161] = 0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8; // Arbitrum USDC

    constructor(address _vaultImplementation) {
        vaultImplementation = _vaultImplementation;
    }

    mapping(address => mapping(uint256 => VaultInfo)) public userToVaults;
    event vaultCreated(
        address indexed user,
        address vaultAddress,
        uint256 chainId
    );

    function createVault(uint256 chainId) public returns (address vault) {
        require(
            userToVaults[msg.sender][chainId].vaultAddress == address(0),
            "user already exist"
        );

        bytes32 salt = keccak256(abi.encodePacked(msg.sender));
        vault = vaultImplementation.cloneDeterministic(salt);
        IVault(vault).initialise(msg.sender, chainIdToVault[chainId])
        userToVaults[msg.sender][chainId] = VaultInfo({
            vaultAddress: address(vault),
            chainId: chainId
        });
        emit vaultCreated(msg.sender, vault, chainId);
    }

    function getVaultAddresses(address user) external returns (address predicted) {
        
        bytes32 salt = keccak256(abi.encodePacked(user));
        predicted = vaultImplementation.predictDeterministicAddress(salt, address(this));
    }
}
