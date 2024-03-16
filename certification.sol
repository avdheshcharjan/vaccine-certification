//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.24;

contract Certification {
    constructor() {}

    struct Certificate {
        string candidate_name;
        string org_name;
        string vaccine_name;
        string vaccine_ID;
        string date_of_vaccination;
        string no_of_shots;
        uint256 expiration_date;
    }

    mapping(bytes32 => Certificate) public certificates;

    event certificateGenerated(bytes32 _certificateId);

    function stringToBytes32(string memory source) private pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }
        if (tempEmptyStringTest.length > 32) {
            revert("String too long");
        }
        assembly {
            result := mload(add(source, 32))
        }
    }

    function generateCertificate(
        string memory _id,
        string memory _candidate_name,
        string memory _org_name, 
        string memory _vaccine_name,
        string memory _vaccine_ID,
        string memory _date_of_vaccination,
        string memory _no_of_shots,
        uint256 _expiration_date) public {
        bytes32 byte_id = stringToBytes32(_id);
        require(certificates[byte_id].expiration_date == 0, "Certificate with given id already exists");
        certificates[byte_id] = Certificate(_candidate_name, _org_name, _vaccine_name, _vaccine_ID, _date_of_vaccination, _no_of_shots, _expiration_date);
        emit certificateGenerated(byte_id);
    }

    function getData(string memory _id) public view returns(string memory, string memory, string memory, string memory, string memory, string memory, uint256) {
        bytes32 byte_id = stringToBytes32(_id);
        Certificate memory temp = certificates[byte_id];
        require(temp.expiration_date != 0, "No data exists");
        return (temp.candidate_name, temp.org_name, temp.vaccine_name, temp.vaccine_ID, temp.date_of_vaccination, temp.no_of_shots, temp.expiration_date);
    }
}
