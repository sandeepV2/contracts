pragma solidity ^0.8.18;

import {SimpleStorage} from './SimpleStorage.sol';

contract AddFiveStorage is SimpleStorage {

    function store(uint256 _newFavNumber) override public {
        favoriteNumber = _newFavNumber + 5;
    }
}
