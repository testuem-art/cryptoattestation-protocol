// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AttestationRegistry {

    struct Attestation {
        address verifier;
        bytes32 dataHash;
        uint256 timestamp;
    }

    mapping(bytes32 => Attestation[]) public assetAttestations;

    event AttestationAdded(bytes32 indexed assetHash, address indexed verifier, bytes32 dataHash);

    function addAttestation(bytes32 assetHash, bytes32 dataHash) external {
        assetAttestations[assetHash].push(Attestation(msg.sender, dataHash, block.timestamp));
        emit AttestationAdded(assetHash, msg.sender, dataHash);
    }

    function getAttestationCount(bytes32 assetHash) external view returns (uint) {
        return assetAttestations[assetHash].length;
    }
}
