// SPDX-License-Identifier: UNLINCENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract TitreImmo is Ownable {

    using Counters for Counters.Counter; 

    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

    mapping(uint => string) private _descriptions;
    mapping(uint => address) private _owners;
    mapping(address => uint) private _balances;

    Counters.Counter private _tokenIdCounter;

    function balanceOf(address _owner) external view returns (uint256){
        return _balances[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address){
        return _owners[_tokenId];
    }

    function descriptionOf(uint256 _tokenId) public view returns (string memory){
        return _descriptions[_tokenId];
    }
 
    function transfer(address _from, address _to, uint _tokenId) external {
        _transfer(_from, _to, _tokenId);
    }

    function mint(string memory _description, address _to) external onlyOwner {
        require(keccak256(abi.encodePacked(_description)) != keccak256(""), "Description vide");
        _tokenIdCounter.increment();
        _descriptions[_tokenIdCounter.current()] = _description;
        _mint(_tokenIdCounter.current(), _to);
    }

    function _mint(uint256 _tokenId, address _to) internal {
        require(_to != address(0), "Impossible de minter sur l'adresse nulle");
        require(!_exists(_tokenId), "TokenId existe deja");
        _owners[_tokenId] = _to;
        _balances[_to] += 1;

        emit Transfer(address(0), _to, _tokenId);
    }

    function _transfer(address _from, address _to, uint _tokenId) internal {
        require(ownerOf(_tokenId) == _from, "Adresse de transfert != Adresse proprietaire");
        require(_exists(_tokenId), "TokenId inexistant");

        _owners[_tokenId] = _to;

        _balances[_from] -= 1;
        _balances[_to] += 1;

        emit Transfer(_from, _to, _tokenId);
    }

    function _exists(uint256 _tokenId) internal view virtual returns (bool) {
        return _owners[_tokenId] != address(0);
    }
}