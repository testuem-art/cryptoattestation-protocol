// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AttestationRegistry {

    struct Attestation {
        address verifier;
        bytes32 dataHash;
        uint256 timestamp;
    }

    mapping(bytes32 => Attestation[]) public assetAttestations;
    mapping(address => bool) public approvedVerifiers;
    address public owner;

    event AttestationAdded(bytes32 indexed assetHash, address indexed verifier, bytes32 dataHash);
    event VerifierAdded(address indexed verifier);
    event VerifierRemoved(address indexed verifier);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier onlyApprovedVerifier() {
        require(approvedVerifiers[msg.sender], "Not an approved verifier");
        _;
    }

    constructor() {
        owner = msg.sender;
        approvedVerifiers[msg.sender] = true;
    }

    function addVerifier(address _verifier) external onlyOwner {
        approvedVerifiers[_verifier] = true;
        emit VerifierAdded(_verifier);
    }

    function removeVerifier(address _verifier) external onlyOwner {
        approvedVerifiers[_verifier] = false;
        emit VerifierRemoved(_verifier);
    }

    function addAttestation(bytes32 assetHash, bytes32 dataHash) external onlyApprovedVerifier {
        assetAttestations[assetHash].push(Attestation(msg.sender, dataHash, block.timestamp));
        emit AttestationAdded(assetHash, msg.sender, dataHash);
    }

    function getAttestationCount(bytes32 assetHash) external view returns (uint) {
        return assetAttestations[assetHash].length;
    }

    function getAttestation(bytes32 assetHash, uint index) external view returns (address verifier, bytes32 dataHash, uint256 timestamp) {
        Attestation memory a = assetAttestations[assetHash][index];
        return (a.verifier, a.dataHash, a.timestamp);
    }
}
