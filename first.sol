// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract LicenseAgreementOnChain {
    address public licensor;

    struct License {
        address licensee;
        string terms;
        uint256 timestamp;
    }

    mapping(address => License) public licenses;

    event LicenseCreated(address indexed licensee, string terms, uint256 timestamp);

    constructor() {
        licensor = msg.sender;
    }

    function createLicense(address _licensee, string memory _terms) external {
        require(msg.sender == licensor, "Only licensor can create licenses");
        require(licenses[_licensee].timestamp == 0, "License already exists");

        licenses[_licensee] = License({
            licensee: _licensee,
            terms: _terms,
            timestamp: block.timestamp
        });

        emit LicenseCreated(_licensee, _terms, block.timestamp);
    }

    function getLicense(address _licensee) external view returns (string memory, uint256) {
        License memory lic = licenses[_licensee];
        require(lic.timestamp != 0, "License does not exist");
        return (lic.terms, lic.timestamp);
    }
}
