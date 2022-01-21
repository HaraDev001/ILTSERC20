// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";


contract ILTSERC20 is ERC20, Ownable {
    using SafeMath for uint256;

    uint256 public _totalSupply;
    uint256 public totalMintedAmount;    
    uint public deployedDate;

    struct Period {
        uint time;        
    }

    Period[] public periodList;
    mapping(address => mapping(uint => uint256)) periodAllowed;
    mapping(address => uint256) public stakedTokens;

    constructor() ERC20("IltsTestToken", "ILTS") {        
        _totalSupply = 100000;
        deployedDate = block.timestamp;   
    }

    function testOperation() public {        
        if(periodAllowed[msg.sender][periodList[0].time] != 0){
            for(uint i = 0 ; i < periodList.length; i++){            
                if((periodAllowed[msg.sender][periodList[i].time] != 0) && (block.timestamp - deployedDate < periodList[i].time * 1 days)){
                    stakedTokens[msg.sender] = stakedTokens[msg.sender].add(periodAllowed[msg.sender][periodList[i-1].time]);
                    break;
                }
            }
        } else {
            stakedTokens[msg.sender] = stakedTokens[msg.sender].add(100);
        }
    }

    function addItemToPeriods(uint _period) public onlyOwner{
        periodList.push(Period(_period));
    }

    function addBrandOptions(address to, uint period, uint256 amount) public onlyOwner{
        periodAllowed[to][period] = amount;
    }

    function claimTokens() public {
        require(totalMintedAmount.add(stakedTokens[msg.sender]) <= _totalSupply, "Can not exceed Maximum number of tokens");
        _mint(msg.sender, stakedTokens[msg.sender] * (10**2));
        totalMintedAmount = totalMintedAmount.add(stakedTokens[msg.sender]);
        stakedTokens[msg.sender] = 0;
    }
}
