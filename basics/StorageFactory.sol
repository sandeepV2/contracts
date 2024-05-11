// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {SimpleStorage} from "./SimpleStorage.sol";

contract StorageFactory {
    SimpleStorage[] public listOfcontracts;
    // in the scope of contract is storage class.
    SimpleStorage public simpleStorage;

    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public {
        listOfcontracts[_simpleStorageIndex].store(
            _simpleStorageNumber
        );
    }
    function sFGet(uint256 _simpleStorageIndex) public view returns(uint256) {
        return listOfcontracts[_simpleStorageIndex].retrieve();
    }

    function createSampleStorageContract() public {
        simpleStorage = new SimpleStorage();
        listOfcontracts.push(simpleStorage);
    }

    function getDeployedContracts() public view returns(uint256) {
        return listOfcontracts.length;
    }
    

    // simpleStorage.nameToFavNum
}
