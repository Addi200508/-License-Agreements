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
    event LicenseUpdated(address indexed licensee, string newTerms, uint256 timestamp);
    event LicenseRevoked(address indexed licensee, uint256 timestamp);
    event LicensorTransferred(address indexed oldLicensor, address indexed newLicensor);

    constructor() {
        licensor = msg.sender;
    }

    modifier onlyLicensor() {
        require(msg.sender == licensor, "Only licensor can perform this action");
        _;
    }

    function createLicense(address _licensee, string memory _terms) external onlyLicensor {
        require(licenses[_licensee].timestamp == 0, "License already exists");

        licenses[_licensee] = License({
            licensee: _licensee,
            terms: _terms,
            timestamp: block.timestamp
        });

        emit LicenseCreated(_licensee, _terms, block.timestamp);
    }

    function updateLicense(address _licensee, string memory _newTerms) external onlyLicensor {
        License storage lic = licenses[_licensee];
        require(lic.timestamp != 0, "License does not exist");

        lic.terms = _newTerms;
        lic.timestamp = block.timestamp;

        emit LicenseUpdated(_licensee, _newTerms, block.timestamp);
    }

    function revokeLicense(address _licensee) external onlyLicensor {
        License memory lic = licenses[_licensee];
        require(lic.timestamp != 0, "License does not exist");

        delete licenses[_licensee];

        emit LicenseRevoked(_licensee, block.timestamp);
    }

    function transferLicensor(address _newLicensor) external onlyLicensor {
        require(_newLicensor != address(0), "New licensor cannot be zero address");
        address oldLicensor = licensor;
        licensor = _newLicensor;

        emit LicensorTransferred(oldLicensor, _newLicensor);
    }

    function licenseExists(address _licensee) external view returns (bool) {
        return licenses[_licensee].timestamp != 0;
    }

    function getLicense(address _licensee) external view returns (string memory terms, uint256 timestamp) {
        License memory lic = licenses[_licensee];
        require(lic.timestamp != 0, "License does not exist");
        return (lic.terms, lic.timestamp);
    }
}
