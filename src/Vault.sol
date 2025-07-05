// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract Vault is {
    address public owner;

    IERC20 public usdc;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not Authorized");
        _;
    } 
    
    function initialise(address _user, address _usdc) external {
        require(owner == address(0), "Vault already initialised");
        owner = _user;
        usdc = IERC20(_usdc);
    }

    function deposit(uint256 _amt) external onlyOwner {
       require(_amt > 0, "Amount must be greater than Zero");
       require(usdc.transferFrom(msg.sender, address(this), _amt), "Transfer Failed");
    }

    function withdraw(uint256 _amt) external onlyOwner {
        require(_amt > 0, "Amount must be greater than Zero");
        require(usdc.transfer(msg.sender, _amt), "Transfer Failed");
       
    }

    function getBalance() external onlyOwner returns (uint256 balance) {
        balance = usdc.balanceOf(address(this));
    }
}