pragma solidity ^0.8.19;

contract SimpleStorage {

    uint256 public favoriteNumber;

    struct Person {
        string name;
        uint256 favNum;
    }

    Person [] public people_list;
    mapping (string => uint256) public nameToFavNum;

    function store(uint256 _favoriteNumber) public virtual {favoriteNumber = _favoriteNumber;}

    function retrieve() public view returns(uint256){return favoriteNumber;}

    function retrivePure() public pure {  }

    function addPerson(string calldata _name, uint256  _num) public  {
        // people_list.push(Person(_name, _num));
        nameToFavNum[_name] = _num;
    }

}

